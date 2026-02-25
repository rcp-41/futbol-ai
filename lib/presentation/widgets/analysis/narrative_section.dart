import 'package:flutter/material.dart';

/// Detaylı analiz metni — 5-8 paragraf
class NarrativeSection extends StatelessWidget {
  final String narrative;
  const NarrativeSection({required this.narrative, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (narrative.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              const Text('📝', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                'Detaylı Analiz',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              narrative,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.6,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
