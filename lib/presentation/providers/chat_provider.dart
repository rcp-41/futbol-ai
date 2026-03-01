import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/constants/app_constants.dart';
import '../../core/services/analytics_service.dart';
import '../../data/models/chat_message_model.dart';
import '../../data/repositories/chat_repository.dart';
import 'core_providers.dart';

// ═══ Repository Provider ═══

/// [A-06] FIX: geminiDatasourceProvider artık core_providers.dart'tan geliyor
final chatRepositoryProvider = Provider<ChatRepository>(
  (ref) => ChatRepository(datasource: ref.watch(geminiDatasourceProvider)),
);

// ═══ Chat Messages Stream ═══

/// [P-05] autoDispose eklendi
final chatMessagesProvider =
    StreamProvider.autoDispose.family<List<ChatMessageModel>, String>((ref, matchId) {
  return ref.watch(chatRepositoryProvider).streamMessages(matchId);
});

// ═══ Remaining Messages ═══

final chatRemainingProvider =
    FutureProvider.autoDispose.family<int, String>((ref, matchId) async {
  final count =
      await ref.watch(chatRepositoryProvider).getTodayMessageCount(matchId);
  return AppConstants.maxDailyMessages - count;
});

// ═══ Chat Notifier (send message + loading state) ═══

/// [A-05] FIX: AutoDisposeNotifier kullanılıyor, Ref anti-pattern düzeltildi
final chatNotifierProvider = AutoDisposeNotifierProvider.family<ChatNotifier,
    ChatState, String>(
  ChatNotifier.new,
);

class ChatState {
  final bool isLoading;
  final String? error;
  const ChatState({this.isLoading = false, this.error});
}

class ChatNotifier extends AutoDisposeFamilyNotifier<ChatState, String> {
  @override
  ChatState build(String matchId) => const ChatState();

  Future<void> sendMessage(String message) async {
    state = const ChatState(isLoading: true);

    try {
      final repo = ref.read(chatRepositoryProvider);
      final messages =
          ref.read(chatMessagesProvider(arg)).valueOrNull ?? [];

      await repo.sendMessage(
        matchId: arg,
        message: message,
        history: messages,
      );

      AnalyticsService.logChatMessageSent(arg);

      // Kalan hakkı yenile
      ref.invalidate(chatRemainingProvider(arg));

      state = const ChatState();
    } catch (e) {
      state = ChatState(error: e.toString());
    }
  }

  void clearError() => state = const ChatState();
}
