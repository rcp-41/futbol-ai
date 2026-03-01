import 'package:flutter/material.dart';
import '../../../data/models/multi_model_analysis_model.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/text_styles.dart';

class VerificationBadge extends StatelessWidget {
  final VerificationResult? verification;

  const VerificationBadge({super.key, required this.verification});

  @override
  Widget build(BuildContext context) {
    if (verification == null) return const SizedBox.shrink();

    final isGreat = verification!.dataCompleteness >= 80;
    final isGood = verification!.dataCompleteness >= 50 && verification!.dataCompleteness < 80;
    
    final color = isGreat ? Colors.green : (isGood ? Colors.orange : Colors.red);
    final icon = isGreat ? Icons.verified : (isGood ? Icons.warning_amber : Icons.error_outline);

    return Tooltip(
      message: 'Veri Tamlığı: %${verification!.dataCompleteness}\nUyarilar:\n${verification!.warnings.join('\n')}',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          border: Border.all(color: color.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              '%${verification!.dataCompleteness} Veri',
              style: TextStyles.caption.copyWith(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
