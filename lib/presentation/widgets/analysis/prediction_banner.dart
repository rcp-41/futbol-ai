import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../config/theme/app_colors.dart';
import '../../../data/models/analysis_model.dart';

/// Prediction Banner — tahmin + güven + banko badge
class PredictionBanner extends StatelessWidget {
  final PredictionModel prediction;
  const PredictionBanner({required this.prediction, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bankoColor = _bankoColor(prediction.bankoLevel);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            bankoColor.withValues(alpha: 0.15),
            bankoColor.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: bankoColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          // Surprise Alert
          if (prediction.surpriseAlert)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.warningColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.warningColor.withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('⚠️', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Text(
                    'SÜRPRİZ ALARMI — Beklenmedik sonuç riski!',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.warningColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

          // Tahmin sonucu
          Text(
            prediction.resultLabel.isNotEmpty
                ? prediction.resultLabel
                : prediction.result,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),

          // Güven + Badge satırı
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Güven yüzdesi
              _ConfidenceCircle(
                confidence: prediction.confidence,
                color: bankoColor,
              ),
              const SizedBox(width: 16),

              // Banko badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: bankoColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: bankoColor),
                ),
                child: Text(
                  prediction.bankoLevel,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: bankoColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Ana sebep
          if (prediction.mainReason.isNotEmpty)
            Text(
              prediction.mainReason,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  Color _bankoColor(String level) => switch (level.toUpperCase()) {
        'BANKO' => AppColors.bankoColor,
        'GÜÇLÜ' => AppColors.gucluColor,
        'RİSKLİ' => AppColors.riskliColor,
        _ => AppColors.kapatColor,
      };
}

class _ConfidenceCircle extends StatelessWidget {
  final double confidence;
  final Color color;
  const _ConfidenceCircle({required this.confidence, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: confidence,
            strokeWidth: 4,
            backgroundColor: color.withValues(alpha: 0.15),
            color: color,
          ),
          Text(
            '${(confidence * 100).toInt()}%',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
