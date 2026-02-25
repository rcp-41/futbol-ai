import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/theme_provider.dart';

import '../widgets/home/week_selector.dart';
import '../widgets/home/league_filter.dart';
import '../widgets/home/match_list.dart';

/// Home Screen — Ana ekran per SPEC.md Bölüm 5.2
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ═══ AppBar ═══
          SliverAppBar(
            floating: true,
            title: Row(
              children: [
                Icon(
                  Icons.sports_soccer,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'FutbolAI',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            actions: [
              // Tema toggle
              IconButton(
                icon: Icon(
                  themeMode == ThemeMode.dark
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                ),
                onPressed: () => ref.read(themeProvider.notifier).toggle(),
                tooltip: 'Tema Değiştir',
              ),
              // Ayarlar
              IconButton(
                icon: const Icon(Icons.settings_rounded),
                onPressed: () => context.go('/settings'),
                tooltip: 'Ayarlar',
              ),
              const SizedBox(width: 8),
            ],
          ),

          // ═══ Hafta Seçici ═══
          const SliverToBoxAdapter(
            child: WeekSelector(),
          ),

          // ═══ Lig Filtresi ═══
          const SliverToBoxAdapter(
            child: LeagueFilter(),
          ),

          // ═══ Maç Listesi ═══
          const MatchList(),
        ],
      ),
    );
  }
}
