import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../config/theme/app_colors.dart';
import '../../../data/models/match_model.dart';
import '../../../data/models/analysis_model.dart';
import '../../providers/analysis_provider.dart';
import '../common/team_logo.dart';
import '../analysis/prediction_banner.dart';
import '../analysis/category_accordion.dart';
import '../analysis/data_intelligence_card.dart';
import '../analysis/veto_rules_section.dart';
import '../analysis/narrative_section.dart';
import 'analyze_button.dart';
import 'match_card_loading.dart';
import '../chat/chat_bottom_sheet.dart';

/// Match Card — 3 durum: idle → loading → result
class MatchCard extends ConsumerStatefulWidget {
  final MatchModel match;
  const MatchCard({required this.match, super.key});

  @override
  ConsumerState<MatchCard> createState() => _MatchCardState();
}

class _MatchCardState extends ConsumerState<MatchCard> {
  bool _isAnalyzing = false;
  AnalysisModel? _analysisResult;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final match = widget.match;
    final dateFormatted =
        DateFormat('dd MMM HH:mm', 'tr_TR').format(match.matchDate);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ═══ Header ═══
            Row(
              children: [
                Flexible(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      match.league,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Hafta ${match.week}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color:
                        theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                const Spacer(),
                Text(
                  dateFormatted,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color:
                        theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ═══ Teams ═══
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      TeamLogo(
                        logoUrl: match.homeTeam.logoUrl,
                        teamName: match.homeTeam.name,
                        size: 48,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        match.homeTeam.name,
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (match.homeTeam.formLast5.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          match.homeTeam.formLast5,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(letterSpacing: 2),
                        ),
                      ],
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'VS',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.primary.withValues(alpha: 0.6),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      TeamLogo(
                        logoUrl: match.awayTeam.logoUrl,
                        teamName: match.awayTeam.name,
                        size: 48,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        match.awayTeam.name,
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (match.awayTeam.formLast5.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          match.awayTeam.formLast5,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(letterSpacing: 2),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ═══ Odds ═══
            if (match.odds != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.dividerTheme.color ?? AppColors.cardBorderColor,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _OddCell(label: '1', value: match.odds!.home, theme: theme),
                    Container(width: 1, height: 24, color: theme.dividerTheme.color),
                    _OddCell(label: 'X', value: match.odds!.draw, theme: theme),
                    Container(width: 1, height: 24, color: theme.dividerTheme.color),
                    _OddCell(label: '2', value: match.odds!.away, theme: theme),
                  ],
                ),
              ),
            const SizedBox(height: 16),

            // ═══ DURUM SWİTCH ═══
            if (_isAnalyzing && _analysisResult == null)
              // Durum B: Loading
              MatchCardLoading(
                onCancel: () => setState(() => _isAnalyzing = false),
              )
            else if (_analysisResult != null)
              // Durum C: Analiz Sonucu
              _AnalysisResultView(analysis: _analysisResult!)
            else
              // Durum A: İdle — Analiz butonu
              AnalyzeButton(
                onPressed: _startAnalysis,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _startAnalysis() async {
    setState(() => _isAnalyzing = true);

    try {
      final result = await ref
          .read(analysisProvider(widget.match.id).future);
      if (mounted) {
        setState(() {
          _analysisResult = result;
          _isAnalyzing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isAnalyzing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $e')),
        );
      }
    }
  }
}

/// Durum C: Analiz sonucu görünümü
class _AnalysisResultView extends StatelessWidget {
  final AnalysisModel analysis;
  const _AnalysisResultView({required this.analysis});

  @override
  Widget build(BuildContext context) {
    return Column(
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

        const SizedBox(height: 16),
        // 🤖 AI'a Sor butonu
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => ChatBottomSheet.show(
              context,
              analysis.matchId,
              analysis.matchId,
            ),
            icon: const Text('🤖', style: TextStyle(fontSize: 16)),
            label: const Text('AI\'a Sor'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OddCell extends StatelessWidget {
  final String label;
  final double value;
  final ThemeData theme;
  const _OddCell({required this.label, required this.value, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value.toStringAsFixed(2),
          style: GoogleFonts.jetBrainsMono(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
