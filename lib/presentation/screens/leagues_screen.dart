import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/football_providers.dart';

/// Ligler Listesi — tüm ligleri gösterir
class LeaguesScreen extends ConsumerWidget {
  const LeaguesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaguesAsync = ref.watch(allLeaguesProvider);
    final newsAsync = ref.watch(latestNewsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: Row(
              children: [
                Icon(Icons.emoji_events, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text('Ligler & Haberler',
                    style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
              ],
            ),
          ),

          // ═══ Ligler ═══
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('Ligler', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            ),
          ),
          leaguesAsync.when(
            loading: () => const SliverToBoxAdapter(
              child: Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator())),
            ),
            error: (e, _) => SliverToBoxAdapter(child: Center(child: Text('Hata: $e'))),
            data: (leagues) => leagues.isEmpty
                ? const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: Text('Henüz lig verisi yok.\nScraper çalıştığında burada ligler görünecek.')),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final league = leagues[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                              child: Icon(Icons.emoji_events, color: theme.colorScheme.primary),
                            ),
                            title: Text(league.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                            subtitle: Text('${league.country} • ${league.season}'),
                            trailing: const Icon(Icons.chevron_right_rounded),
                            onTap: () => context.push('/league/${league.key}'),
                          ),
                        );
                      },
                      childCount: leagues.length,
                    ),
                  ),
          ),

          // ═══ Son Haberler ═══
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text('Son Haberler', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            ),
          ),
          newsAsync.when(
            loading: () => const SliverToBoxAdapter(
              child: Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator())),
            ),
            error: (e, _) => SliverToBoxAdapter(child: Center(child: Text('Hata: $e'))),
            data: (news) => news.isEmpty
                ? const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: Text('Henüz haber yok')),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final n = news[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child: ListTile(
                            leading: const Icon(Icons.article_rounded),
                            title: Text(
                              n.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text('${n.source} • ${n.date}'),
                          ),
                        );
                      },
                      childCount: news.length,
                    ),
                  ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}
