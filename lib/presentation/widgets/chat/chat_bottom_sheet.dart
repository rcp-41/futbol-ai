import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../providers/chat_provider.dart';
import 'chat_input_bar.dart';
import 'chat_message_bubble.dart';
import 'typing_indicator.dart';

/// Chat Bottom Sheet — DraggableScrollableSheet
class ChatBottomSheet extends ConsumerStatefulWidget {
  final String matchId;
  final String matchTitle;

  const ChatBottomSheet({
    required this.matchId,
    required this.matchTitle,
    super.key,
  });

  /// Bottom sheet'i açmak için helper
  static void show(BuildContext context, String matchId, String matchTitle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChatBottomSheet(
        matchId: matchId,
        matchTitle: matchTitle,
      ),
    );
  }

  @override
  ConsumerState<ChatBottomSheet> createState() => _ChatBottomSheetState();
}

class _ChatBottomSheetState extends ConsumerState<ChatBottomSheet> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chatState = ref.watch(chatNotifierProvider(widget.matchId));
    final messages = ref.watch(chatMessagesProvider(widget.matchId));
    final remaining = ref.watch(chatRemainingProvider(widget.matchId));

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // ═══ Drag Handle + Header ═══
              _buildHeader(theme, remaining),

              // ═══ Messages ═══
              Expanded(
                child: messages.when(
                  data: (msgs) {
                    if (msgs.isEmpty) {
                      return _buildEmptyState(theme);
                    }
                    // Auto-scroll on new data
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollToBottom();
                    });
                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: msgs.length + (chatState.isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == msgs.length && chatState.isLoading) {
                          return const TypingIndicator();
                        }
                        return ChatMessageBubble(message: msgs[index]);
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(
                    child: Text('Mesajlar yüklenemedi: $e',
                        style: theme.textTheme.bodyMedium),
                  ),
                ),
              ),

              // ═══ Rate limit warning ═══
              if (remaining.valueOrNull != null && remaining.valueOrNull! <= 0)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  color: theme.colorScheme.error.withValues(alpha: 0.1),
                  child: Text(
                    '⚠️ Günlük mesaj limitinize ulaştınız.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              // ═══ Input Bar ═══
              ChatInputBar(
                matchId: widget.matchId,
                enabled: remaining.valueOrNull == null || remaining.valueOrNull! > 0,
                isLoading: chatState.isLoading,
                onSent: _scrollToBottom,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(ThemeData theme, AsyncValue<int> remaining) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('🤖', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI\'a Sor',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      widget.matchTitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Kalan mesaj hakkı
              remaining.when(
                data: (count) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: count > 5
                        ? theme.colorScheme.primary.withValues(alpha: 0.1)
                        : theme.colorScheme.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$count hak',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: count > 5
                          ? theme.colorScheme.primary
                          : theme.colorScheme.error,
                    ),
                  ),
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('💬', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text(
              'Bu maç hakkında AI\'a soru sorabilirsiniz',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Örnek: "Ev sahibinin defans zaafiyeti nedir?"',
              style: theme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
