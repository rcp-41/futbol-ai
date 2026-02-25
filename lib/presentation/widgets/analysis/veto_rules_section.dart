import 'package:flutter/material.dart';

import '../../../config/theme/app_colors.dart';
import '../../../data/models/analysis_model.dart';

/// Veto kuralları bölümü — aktif veto kuralların listesi
class VetoRulesSection extends StatelessWidget {
  final List<VetoRule> rules;
  const VetoRulesSection({required this.rules, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (rules.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              const Text('🚫', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                'Aktif Veto Kuralları (${rules.length})',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.dangerColor,
                ),
              ),
            ],
          ),
        ),
        ...rules.map((rule) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              color: AppColors.dangerColor.withValues(alpha: 0.05),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.dangerColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            rule.penalty,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.dangerColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            rule.rule,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${rule.affectedTeam} → ${rule.affectedCategory}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                    if (rule.reason.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          rule.reason,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
