import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../providers/sportoto_provider.dart';
import '../widgets/match_card/match_card.dart';
import '../../core/widgets/error_widget.dart';

/// Sportoto maç listesi ekranı
class SportotoScreen extends ConsumerWidget {
  const SportotoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final matchesAsync = ref.watch(sportotoMatchesProvider);
    final refreshState = ref.watch(sportotoRefreshProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🏆 Spor Toto'),
        actions: [
          // Manuel yenileme butonu
          IconButton(
            icon: refreshState.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh_rounded),
            onPressed: refreshState.isLoading
                ? null
                : () async {
                    await ref
                        .read(sportotoRefreshProvider.notifier)
                        .refresh();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('✅ Sportoto listesi güncellendi!'),
                        ),
                      );
                    }
                  },
            tooltip: 'Listeyi Güncelle',
          ),
        ],
      ),
      body: matchesAsync.when(
        data: (matches) {
          if (matches.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.sports_soccer,
                    size: 64,
                    color:
                        theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Henüz Spor Toto listesi yüklenmedi',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Yenile butonuna basarak güncel listeyi çekin',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.4),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () =>
                        ref.read(sportotoRefreshProvider.notifier).refresh(),
                    icon: const Icon(Icons.download_rounded),
                    label: const Text('Listeyi Çek'),
                  ),
                ],
              ),
            );
          }

          // Hafta header'ı
          final weekNumber = matches.first.week;

          return RefreshIndicator(
            onRefresh: () =>
                ref.read(sportotoRefreshProvider.notifier).refresh(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: matches.length + 1, // +1 header için
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Hafta bilgisi header
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary.withValues(alpha: 0.15),
                            theme.colorScheme.secondary.withValues(alpha: 0.08),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Text('🏆', style: TextStyle(fontSize: 24)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Spor Toto — $weekNumber. Hafta',
                                  style:
                                      theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  '${matches.length} maç',
                                  style:
                                      theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Chip(
                            label: Text(
                              '${matches.length}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: theme.colorScheme.primary
                                .withValues(alpha: 0.1),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Maç kartları — lazy rendering
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: MatchCard(match: matches[index - 1]),
                );
              },
            ),
          );
        },
        loading: () => _buildShimmerList(context),
        error: (error, _) => AppErrorWidget(
          message: 'Sportoto listesi yüklenemedi',
          onRetry: () => ref.invalidate(sportotoMatchesProvider),
        ),
      ),
    );
  }

  Widget _buildShimmerList(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
      highlightColor: isDark ? Colors.grey.shade600 : Colors.grey.shade100,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (_, _) => Container(
          height: 160,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
