import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/analysis_model.dart';

/// Data Intelligence kartları — hava, sakatlık, hakem, xG, dinlenme, H2H
class DataIntelligenceCard extends StatelessWidget {
  final DataIntelligence data;
  const DataIntelligenceCard({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            '📊 Toplanan Veri İstihbaratı',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        // Weather
        if (data.weather != null)
          _InfoTile(
            icon: '🌡️',
            title: 'Hava Durumu',
            content: '${data.weather!.temperature} • '
                'Nem: ${data.weather!.humidity} • '
                'Yağış: ${data.weather!.rain} • '
                'Rüzgar: ${data.weather!.wind}\n'
                '${data.weather!.impact}',
            theme: theme,
          ),

        // Injuries
        if (data.injuries != null) _InjuryTile(data: data.injuries!, theme: theme),

        // Referee
        if (data.referee != null)
          _InfoTile(
            icon: '⚖️',
            title: '${data.referee!.name}${data.referee!.varReferee.isNotEmpty ? ' (VAR: ${data.referee!.varReferee})' : ''}',
            content: 'Ort. Faul: ${data.referee!.avgFoulsPerMatch} • '
                'Ort. Sarı: ${data.referee!.avgYellowCards} • '
                'Ort. Penaltı: ${data.referee!.avgPenalties}',
            theme: theme,
          ),

        // xG
        if (data.xgData != null)
          _XgTile(xg: data.xgData!, theme: theme),

        // Rest Days
        if (data.restDays != null)
          _InfoTile(
            icon: '🛌',
            title: 'Dinlenme',
            content: 'Ev: ${data.restDays!.home} gün (${data.restDays!.lastMatchHome})\n'
                'Dep: ${data.restDays!.away} gün (${data.restDays!.lastMatchAway})',
            theme: theme,
          ),

        // H2H
        if (data.headToHead != null)
          _InfoTile(
            icon: '🤝',
            title: 'Son 5 Karşılaşma',
            content: '${data.headToHead!.last5}\n'
                'Ev: ${data.headToHead!.homeWins}G  Ber: ${data.headToHead!.draws}  Dep: ${data.headToHead!.awayWins}G',
            theme: theme,
          ),

        // Stadium
        if (data.stadiumInfo != null)
          _InfoTile(
            icon: '🏟️',
            title: data.stadiumInfo!.name,
            content: 'Kapasite: ${data.stadiumInfo!.capacity} • '
                'Rakım: ${data.stadiumInfo!.altitude}m • '
                'Zemin: ${data.stadiumInfo!.pitchType} • '
                '${data.stadiumInfo!.pitchDimensions}',
            theme: theme,
          ),

        // Fixture Context
        if (data.fixtureContext != null)
          _InfoTile(
            icon: '📅',
            title: 'Fikstür',
            content: 'Ev sonraki: ${data.fixtureContext!.homeNextMatch}\n'
                'Dep sonraki: ${data.fixtureContext!.awayNextMatch}\n'
                'Hedef Maç: ${data.fixtureContext!.targetMatchSyndrome}',
            theme: theme,
          ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String icon;
  final String title;
  final String content;
  final ThemeData theme;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.content,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(icon, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              content,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InjuryTile extends StatelessWidget {
  final InjuryData data;
  final ThemeData theme;
  const _InjuryTile({required this.data, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('🏥', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Text(
                  'Sakatlık Raporu',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (data.homeTeamOut.isNotEmpty) ...[
              Text('Ev — Kesin Eksik ❌', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
              ...data.homeTeamOut.map((p) => Text('  • $p', style: theme.textTheme.bodySmall)),
            ],
            if (data.homeTeamDoubtful.isNotEmpty) ...[
              Text('Ev — Şüpheli ❓', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
              ...data.homeTeamDoubtful.map((p) => Text('  • $p', style: theme.textTheme.bodySmall)),
            ],
            if (data.awayTeamOut.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text('Dep — Kesin Eksik ❌', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
              ...data.awayTeamOut.map((p) => Text('  • $p', style: theme.textTheme.bodySmall)),
            ],
            if (data.awayTeamDoubtful.isNotEmpty) ...[
              Text('Dep — Şüpheli ❓', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
              ...data.awayTeamDoubtful.map((p) => Text('  • $p', style: theme.textTheme.bodySmall)),
            ],
          ],
        ),
      ),
    );
  }
}

class _XgTile extends StatelessWidget {
  final XgData xg;
  final ThemeData theme;
  const _XgTile({required this.xg, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('📈', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Text(
                  'xG Verileri',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Text(
                  xg.source,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _xgStat('xG', xg.homeXg, xg.awayXg),
                _xgStat('xGA', xg.homeXga, xg.awayXga),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _xgStat(String label, double home, double away) {
    return Column(
      children: [
        Text(label, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              home.toStringAsFixed(2),
              style: GoogleFonts.jetBrainsMono(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const Text(' vs '),
            Text(
              away.toStringAsFixed(2),
              style: GoogleFonts.jetBrainsMono(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ],
    );
  }
}
