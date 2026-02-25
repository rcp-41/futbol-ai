import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/matches_provider.dart';

/// Hafta seçici — yatay kaydırılabilir Chip'ler
class WeekSelector extends ConsumerWidget {
  const WeekSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedWeek = ref.watch(selectedWeekProvider);
    final weeksAsync = ref.watch(availableWeeksProvider);

    return SizedBox(
      height: 56,
      child: weeksAsync.when(
        data: (weeks) {
          final displayWeeks = weeks.isEmpty
              ? List.generate(10, (i) => i + 1)
              : weeks;
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: displayWeeks.length,
            itemBuilder: (context, index) {
              final week = displayWeeks[index];
              final isSelected = week == selectedWeek;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(
                    'Hafta $week${isSelected ? ' ✨' : ''}',
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w400,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (_) {
                    ref.read(selectedWeekProvider.notifier).state = week;
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => const Center(child: Text('Haftalar yüklenemedi')),
      ),
    );
  }
}
