import 'package:flutter/material.dart';
import '../../../data/models/multi_model_analysis_model.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/text_styles.dart';

class AIResultTab extends StatelessWidget {
  final AIModelResult result;

  const AIResultTab({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Probabilities
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildProbCircle('Ev', result.homeWinProbability, AppColors.success),
              _buildProbCircle('B', result.drawProbability, AppColors.warning),
              _buildProbCircle('Dep', result.awayWinProbability, AppColors.error),
            ],
          ),
          const SizedBox(height: 24),
          Row(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
             children: [
              _buildProbBadge('2.5 Üst', result.over25Probability),
              _buildProbBadge('2.5 Alt', result.under25Probability),
              _buildProbBadge('KG Var', result.bttsProbability),
             ],
          ),
          const SizedBox(height: 24),
          
          Text('Skor Tahmini: ${result.predictedScore}', style: TextStyles.h3),
          const Divider(height: 32),

          Text('Öne Çıkan Öncelikli Tahminler', style: TextStyles.h4.copyWith(color: AppColors.primary)),
          const SizedBox(height: 8),
          ...result.topPredictions.map((p) => ListTile(
            leading: const Icon(Icons.star, color: Colors.amber, size: 20),
            title: Text(p, style: TextStyles.body1),
            contentPadding: EdgeInsets.zero,
            dense: true,
          )),
          const Divider(height: 32),

          Text('Taktiksel Analiz & Hikaye', style: TextStyles.h4),
          const SizedBox(height: 8),
          Text(result.gameNarrative, style: TextStyles.body2.copyWith(height: 1.5)),
          const SizedBox(height: 24),

          Text('Kilit Faktörler', style: TextStyles.h4),
          const SizedBox(height: 8),
          ...result.keyFactors.map((f) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontSize: 18, color: AppColors.primary)),
                Expanded(child: Text(f, style: TextStyles.body2)),
              ],
            ),
          )),
          
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: Text('Model Güveni: ${result.confidenceScore}/10', 
                style: TextStyles.caption.copyWith(fontStyle: FontStyle.italic)),
          )
        ],
      ),
    );
  }

  Widget _buildProbCircle(String label, double prob, Color color) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 60, height: 60,
              child: CircularProgressIndicator(
                value: prob / 100,
                backgroundColor: color.withOpacity(0.2),
                color: color,
                strokeWidth: 6,
              ),
            ),
            Text('%${prob.toInt()}', style: TextStyles.h4.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyles.body2),
      ],
    );
  }

  Widget _buildProbBadge(String label, double prob) {
     return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
           color: AppColors.surfaceVariant,
           borderRadius: BorderRadius.circular(16),
        ),
        child: Text('$label %${prob.toInt()}', style: TextStyles.body2.copyWith(fontWeight: FontWeight.w600)),
     );
  }
}
