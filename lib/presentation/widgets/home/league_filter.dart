import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/constants/app_constants.dart';
import '../../providers/matches_provider.dart';

/// Lig filtresi — yatay scroll bayraklı filtreler
class LeagueFilter extends ConsumerWidget {
  const LeagueFilter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedLeague = ref.watch(selectedLeagueProvider);

    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: AppConstants.defaultLeagues.length,
        itemBuilder: (context, index) {
          final league = AppConstants.defaultLeagues[index];
          final flag = AppConstants.leagueFlags[league] ?? '⚽';
          final isSelected =
              (selectedLeague == null && league == 'Tümü') ||
                  selectedLeague == league;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                '$flag $league',
                style: TextStyle(
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 13,
                ),
              ),
              selected: isSelected,
              onSelected: (_) {
                ref.read(selectedLeagueProvider.notifier).state =
                    league == 'Tümü' ? null : league;
              },
              selectedColor: theme.colorScheme.primary.withValues(alpha: 0.15),
              checkmarkColor: theme.colorScheme.primary,
            ),
          );
        },
      ),
    );
  }
}
