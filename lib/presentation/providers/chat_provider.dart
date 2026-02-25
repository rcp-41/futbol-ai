import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/chat_message_model.dart';
import '../../data/repositories/chat_repository.dart';
import 'analysis_provider.dart' show geminiDatasourceProvider;

// ═══ Repository Provider ═══

final chatRepositoryProvider = Provider<ChatRepository>(
  (ref) => ChatRepository(datasource: ref.watch(geminiDatasourceProvider)),
);

// ═══ Chat Messages Stream ═══

final chatMessagesProvider =
    StreamProvider.family<List<ChatMessageModel>, String>((ref, matchId) {
  return ref.watch(chatRepositoryProvider).streamMessages(matchId);
});

// ═══ Remaining Messages ═══

final chatRemainingProvider =
    FutureProvider.family<int, String>((ref, matchId) async {
  const maxDaily = 20;
  final count =
      await ref.watch(chatRepositoryProvider).getTodayMessageCount(matchId);
  return maxDaily - count;
});

// ═══ Chat Notifier (send message + loading state) ═══

final chatNotifierProvider = StateNotifierProvider.family<ChatNotifier,
    ChatState, String>(
  (ref, matchId) => ChatNotifier(
    ref.watch(chatRepositoryProvider),
    matchId,
    ref,
  ),
);

class ChatState {
  final bool isLoading;
  final String? error;
  const ChatState({this.isLoading = false, this.error});
}

class ChatNotifier extends StateNotifier<ChatState> {
  final ChatRepository _repository;
  final String _matchId;
  final Ref _ref;

  ChatNotifier(this._repository, this._matchId, this._ref)
      : super(const ChatState());

  Future<void> sendMessage(String message) async {
    state = const ChatState(isLoading: true);

    try {
      // Mevcut geçmişi al
      final messages =
          _ref.read(chatMessagesProvider(_matchId)).valueOrNull ?? [];

      await _repository.sendMessage(
        matchId: _matchId,
        message: message,
        history: messages,
      );

      // Kalan hakkı yenile
      _ref.invalidate(chatRemainingProvider(_matchId));

      state = const ChatState();
    } catch (e) {
      state = ChatState(error: e.toString());
    }
  }

  void clearError() => state = const ChatState();
}
