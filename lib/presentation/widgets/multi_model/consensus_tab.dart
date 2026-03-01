import 'package:flutter/material.dart';
import '../../../data/models/multi_model_analysis_model.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/text_styles.dart';

class ConsensusTab extends StatelessWidget {
  final ConsensusResult result;

  const ConsensusTab({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (result.fallback)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                border: Border.all(color: AppColors.error),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning, color: AppColors.error),
                  SizedBox(width: 8),
                  Expanded(child: Text('Ortak karar oluşturulurken bir hata oluştu. Lütfen bireysel model sonuçlarını değerlendirin.', style: TextStyle(color: AppColors.error))),
                ],
              ),
            ),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2E3192), Color(0xFF1BFFFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text('Ortak Karar (Konsensüs)', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Text(result.predictedScore, style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                const Text('Skor Tahmini', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBigProb('Ev', result.homeWinProbability, AppColors.success),
              _buildBigProb('B', result.drawProbability, AppColors.warning),
              _buildBigProb('Dep', result.awayWinProbability, AppColors.error),
            ],
          ),
          
          const SizedBox(height: 24),
          Wrap(
            spacing: 12, runSpacing: 12, alignment: WrapAlignment.center,
            children: [
              _buildChip('2.5 ÜST', result.over25Probability),
              _buildChip('2.5 ALT', result.under25Probability),
              _buildChip('KG VAR', result.bttsProbability),
            ],
          ),

          const Divider(height: 48, thickness: 2),
          
          Row(
            children: [
              const Icon(Icons.psychology, color: AppColors.primary, size: 28),
              const SizedBox(width: 8),
              Text('Birleşik Analiz Kararı', style: TextStyles.h3),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(result.consensusReasoning, style: TextStyles.body1.copyWith(height: 1.6)),
          ),

          const SizedBox(height: 32),
          Text('En Güçlü Tahminler', style: TextStyles.h3),
          const SizedBox(height: 12),
          ...result.topPredictions.map((t) => Card(
            elevation: 0,
            color: AppColors.surfaceVariant.withOpacity(0.5),
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: AppColors.success),
                  const SizedBox(width: 12),
                  Expanded(child: Text(t, style: TextStyles.h4)),
                ],
              ),
            ),
          )),
          
          const SizedBox(height: 24),
          Center(
            child: Text('Nihai Güven Skoru: ${result.confidenceScore}/10', 
                style: TextStyles.h4.copyWith(color: AppColors.primary)),
          )
        ],
      ),
    );
  }

  Widget _buildBigProb(String label, double prob, Color color) {
    return Column(
      children: [
        Text('%${prob.toInt()}', style: TextStyles.h2.copyWith(color: color)),
        Text(label, style: TextStyles.body1.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildChip(String label, double prob) {
    return Chip(
      label: Text('$label: %${prob.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: AppColors.surfaceVariant,
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}
