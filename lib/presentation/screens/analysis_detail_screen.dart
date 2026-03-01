import 'package:flutter/material.dart';

import '../../data/models/analysis_model.dart';
import '../widgets/analysis/prediction_banner.dart';
import '../widgets/analysis/category_accordion.dart';
import '../widgets/analysis/data_intelligence_card.dart';
import '../widgets/analysis/veto_rules_section.dart';
import '../widgets/analysis/narrative_section.dart';
import '../widgets/chat/chat_bottom_sheet.dart';

/// [E-09] Tam ekran analiz detay sayfası
class AnalysisDetailScreen extends StatelessWidget {
  final AnalysisModel analysis;
  final String matchTitle;

  const AnalysisDetailScreen({
    required this.analysis,
    required this.matchTitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          matchTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.smart_toy_outlined),
            onPressed: () => ChatBottomSheet.show(
              context,
              analysis.matchId,
              matchTitle,
            ),
            tooltip: 'AI\'a Sor',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (analysis.prediction != null)
              PredictionBanner(prediction: analysis.prediction!),
            const SizedBox(height: 16),

            if (analysis.categories != null)
              CategoryAccordion(categories: analysis.categories!),
            const SizedBox(height: 12),

            if (analysis.vetoRules.isNotEmpty)
              VetoRulesSection(rules: analysis.vetoRules),

            if (analysis.dataIntelligence != null)
              DataIntelligenceCard(data: analysis.dataIntelligence!),

            if (analysis.detailedNarrative.isNotEmpty)
              NarrativeSection(narrative: analysis.detailedNarrative),

            const SizedBox(height: 24),

            // AI Chat butonu
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => ChatBottomSheet.show(
                  context,
                  analysis.matchId,
                  matchTitle,
                ),
                icon: const Icon(Icons.smart_toy_outlined, size: 18),
                label: const Text('AI\'a Sor'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
