import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/theme/app_colors.dart';
import '../../providers/chat_provider.dart';

/// Chat Input Bar — TextField + Gradient gönder butonu
class ChatInputBar extends ConsumerStatefulWidget {
  final String matchId;
  final bool enabled;
  final bool isLoading;
  final VoidCallback? onSent;

  const ChatInputBar({
    required this.matchId,
    this.enabled = true,
    this.isLoading = false,
    this.onSent,
    super.key,
  });

  @override
  ConsumerState<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends ConsumerState<ChatInputBar> {
  final _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final hasText = _controller.text.trim().isNotEmpty;
      if (hasText != _hasText) setState(() => _hasText = hasText);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || !widget.enabled || widget.isLoading) return;

    _controller.clear();
    setState(() => _hasText = false);

    await ref
        .read(chatNotifierProvider(widget.matchId).notifier)
        .sendMessage(text);

    widget.onSent?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canSend = _hasText && widget.enabled && !widget.isLoading;

    return Container(
      padding: EdgeInsets.fromLTRB(
        12,
        8,
        8,
        8 + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: theme.dividerColor.withValues(alpha: 0.15),
          ),
        ),
      ),
      child: Row(
        children: [
          // TextField
          Expanded(
            child: TextField(
              controller: _controller,
              enabled: widget.enabled && !widget.isLoading,
              maxLines: 4,
              minLines: 1,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: widget.enabled
                    ? 'Maç hakkında soru sor...'
                    : 'Mesaj limitine ulaşıldı',
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.5),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => _send(),
            ),
          ),
          const SizedBox(width: 8),

          // Gönder butonu
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: canSend
                  ? AppColors.primaryGradient
                  : null,
              color: canSend ? null : theme.colorScheme.onSurface.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: canSend ? _send : null,
                borderRadius: BorderRadius.circular(22),
                child: Center(
                  child: widget.isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                          ),
                        )
                      : Icon(
                          Icons.send_rounded,
                          size: 20,
                          color: canSend
                              ? Colors.white
                              : theme.colorScheme.onSurface.withValues(alpha: 0.3),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
