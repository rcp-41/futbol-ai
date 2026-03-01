import 'dart:async';

import 'package:flutter/material.dart';

import '../../../config/constants/app_constants.dart';
import '../../../config/theme/app_colors.dart';

/// Match Card Durum B — Loading State
/// Sıralı mesaj animasyonu + progress + iptal
class MatchCardLoading extends StatefulWidget {
  final VoidCallback? onCancel;
  const MatchCardLoading({this.onCancel, super.key});

  @override
  State<MatchCardLoading> createState() => _MatchCardLoadingState();
}

class _MatchCardLoadingState extends State<MatchCardLoading>
    with SingleTickerProviderStateMixin {
  int _messageIndex = 0;
  Timer? _messageTimer;

  @override
  void initState() {
    super.initState();
    // Mesaj geçişi — her 3 saniyede
    _messageTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (mounted) {
        setState(() {
          _messageIndex =
              (_messageIndex + 1) % AppConstants.loadingMessages.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Shimmer glow header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor.withValues(alpha: 0.1),
                    AppColors.accentColor.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '⚡ AI Analiz Yapılıyor...',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Sıralı mesajlar
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Text(
                AppConstants.loadingMessages[_messageIndex],
                key: ValueKey(_messageIndex),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),

            // Progress bar — indeterminate (gerçek ilerleme belli değil)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                minHeight: 6,
                backgroundColor:
                    theme.colorScheme.onSurface.withValues(alpha: 0.1),
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 16),

            // İptal butonu
            if (widget.onCancel != null)
              TextButton(
                onPressed: widget.onCancel,
                child: Text(
                  'İptal Et',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
