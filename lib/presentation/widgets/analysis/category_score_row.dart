import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../config/theme/app_colors.dart';

/// Kategori puan satırı — animasyonlu çubuklar + detay
class CategoryScoreRow extends StatelessWidget {
  final double homeScore;
  final double awayScore;
  final String detail;

  const CategoryScoreRow({
    required this.homeScore,
    required this.awayScore,
    required this.detail,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Puan çubukları
        Row(
          children: [
            // Ev sahibi puanı
            Text(
              homeScore.toStringAsFixed(1),
              style: GoogleFonts.jetBrainsMono(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(child: _ScoreBar(score: homeScore, isHome: true)),
            const SizedBox(width: 12),
            Expanded(child: _ScoreBar(score: awayScore, isHome: false)),
            const SizedBox(width: 8),
            Text(
              awayScore.toStringAsFixed(1),
              style: GoogleFonts.jetBrainsMono(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.accentColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Detay metni
        if (detail.isNotEmpty)
          Text(
            detail,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              height: 1.4,
            ),
          ),
      ],
    );
  }
}

class _ScoreBar extends StatelessWidget {
  final double score;
  final bool isHome;
  const _ScoreBar({required this.score, required this.isHome});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isHome ? AppColors.primaryColor : AppColors.accentColor;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth * (score / 10).clamp(0.0, 1.0);
        return Container(
          height: 8,
          alignment: isHome ? Alignment.centerRight : Alignment.centerLeft,
          decoration: BoxDecoration(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(4),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            width: width,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
