import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../config/theme/app_colors.dart';
import '../../../data/models/chat_message_model.dart';

/// Chat Message Bubble — Kullanıcı (sağ) / AI (sol)
class ChatMessageBubble extends StatefulWidget {
  final ChatMessageModel message;
  const ChatMessageBubble({required this.message, super.key});

  @override
  State<ChatMessageBubble> createState() => _ChatMessageBubbleState();
}

class _ChatMessageBubbleState extends State<ChatMessageBubble> {
  bool _expanded = false;
  static const int _maxLines = 6;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = widget.message.role == 'user';
    final time = DateFormat('HH:mm').format(widget.message.timestamp);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 14,
              backgroundColor: AppColors.primaryColor.withValues(alpha: 0.15),
              child: const Text('🤖', style: TextStyle(fontSize: 14)),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser
                    ? AppColors.primaryColor
                    : theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mesaj metni
                  Text(
                    widget.message.content,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isUser
                          ? Colors.white
                          : theme.colorScheme.onSurface,
                      height: 1.4,
                    ),
                    maxLines: _expanded ? null : _maxLines,
                    overflow:
                        _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
                  ),

                  // "Devamını oku" toggle
                  if (_isLongMessage(widget.message.content))
                    GestureDetector(
                      onTap: () => setState(() => _expanded = !_expanded),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          _expanded ? 'Daha az göster ▲' : 'Devamını oku ▼',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isUser
                                ? Colors.white70
                                : AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                  // Zaman damgası
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      time,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                        color: isUser
                            ? Colors.white54
                            : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }

  bool _isLongMessage(String content) {
    return content.split('\n').length > _maxLines || content.length > 300;
  }
}
