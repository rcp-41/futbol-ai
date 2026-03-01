import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/league_model.dart';
import '../../data/models/team_model.dart';
import '../providers/football_providers.dart';

/// Lig Genel Bakış — puan tablosu, takımlar, istatistikler
class LeagueOverviewScreen extends ConsumerWidget {
  final String leagueKey;
  const LeagueOverviewScreen({required this.leagueKey, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leagueAsync = ref.watch(leagueDetailProvider(leagueKey));
    final teamsAsync = ref.watch(teamsByLeagueProvider(leagueKey));
    final theme = Theme.of(context);

    return Scaffold(
      body: leagueAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Hata: $e')),
        data: (league) {
          if (league == null) {
            return const Center(child: Text('Lig bulunamadı.'));
          }
          return DefaultTabController(
            length: 3,
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  expandedHeight: 140,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      league.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        shadows: [Shadow(blurRadius: 8, color: Colors.black45)],
                      ),
                    ),
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            theme.colorScheme.secondary,
                            theme.colorScheme.primary,
                          ],
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.emoji_events_rounded,
                          size: 64,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  ),
                  bottom: TabBar(
                    labelColor: theme.colorScheme.primary,
                    tabs: const [
                      Tab(text: 'Puan Tablosu'),
                      Tab(text: 'Gol Krallığı'),
                      Tab(text: 'Takımlar'),
                    ],
                  ),
                ),
              ],
              body: TabBarView(
                children: [
                  // Tab 1: Puan Tablosu
                  _StandingsTab(standings: league.standings?.total ?? []),
                  // Tab 2: Gol Krallığı
                  _TopPlayersTab(
                    scorers: league.topScorers,
                    assists: league.topAssists,
                  ),
                  // Tab 3: Takımlar
                  teamsAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => const Center(child: Text('Takımlar yüklenemedi')),
                    data: (teams) => _TeamsGridTab(teams: teams),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────── TABS ───────────────────

class _StandingsTab extends StatelessWidget {
  final List<StandingEntry> standings;
  const _StandingsTab({required this.standings});

  @override
  Widget build(BuildContext context) {
    if (standings.isEmpty) {
      return const Center(child: Text('Puan tablosu henüz yüklenemedi'));
    }

    final theme = Theme.of(context);
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: standings.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          // Header
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                SizedBox(width: 28, child: Text('#', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(child: Text('Takım', style: TextStyle(fontWeight: FontWeight.bold))),
                SizedBox(width: 32, child: Text('O', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                SizedBox(width: 32, child: Text('G', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                SizedBox(width: 32, child: Text('B', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                SizedBox(width: 32, child: Text('M', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                SizedBox(width: 48, child: Text('Av', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                SizedBox(width: 40, child: Text('P', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
          );
        }

        final s = standings[index - 1];
        final bgColor = _standingBgColor(s.rank, standings.length, theme);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: bgColor,
            border: Border(
              bottom: BorderSide(color: theme.dividerColor.withValues(alpha: 0.3)),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 28,
                child: Text(
                  '${s.rank}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: s.rank <= 4 ? theme.colorScheme.primary : null,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  s.team,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 32, child: Text('${s.played}', textAlign: TextAlign.center)),
              SizedBox(width: 32, child: Text('${s.won}', textAlign: TextAlign.center)),
              SizedBox(width: 32, child: Text('${s.drawn}', textAlign: TextAlign.center)),
              SizedBox(width: 32, child: Text('${s.lost}', textAlign: TextAlign.center)),
              SizedBox(
                width: 48,
                child: Text(
                  '${s.goalDifference >= 0 ? '+' : ''}${s.goalDifference}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: s.goalDifference > 0 ? Colors.green : s.goalDifference < 0 ? Colors.red : null,
                  ),
                ),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  '${s.points}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color? _standingBgColor(int rank, int total, ThemeData theme) {
    if (rank <= 4) return Colors.green.withValues(alpha: 0.08);
    if (rank >= total - 2) return Colors.red.withValues(alpha: 0.08);
    return null;
  }
}

class _TopPlayersTab extends StatelessWidget {
  final List<TopPlayerEntry> scorers;
  final List<TopPlayerEntry> assists;
  const _TopPlayersTab({required this.scorers, required this.assists});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Gol Krallığı
        Text('⚽ Gol Krallığı', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (scorers.isEmpty)
          const Padding(padding: EdgeInsets.all(16), child: Text('Veri yüklenemedi'))
        else
          ...scorers.asMap().entries.map((e) {
            final rank = e.key + 1;
            final p = e.value;
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: rank <= 3 ? Colors.amber : theme.colorScheme.primary.withValues(alpha: 0.1),
                child: Text('$rank', style: TextStyle(
                  color: rank <= 3 ? Colors.white : theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                )),
              ),
              title: Text(p.player, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(p.team),
              trailing: Text('${p.goals}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            );
          }),

        const Divider(height: 32),

        // Asist Krallığı
        Text('🎯 Asist Krallığı', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (assists.isEmpty)
          const Padding(padding: EdgeInsets.all(16), child: Text('Veri yüklenemedi'))
        else
          ...assists.asMap().entries.map((e) {
            final rank = e.key + 1;
            final p = e.value;
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: rank <= 3 ? Colors.blue : theme.colorScheme.primary.withValues(alpha: 0.1),
                child: Text('$rank', style: TextStyle(
                  color: rank <= 3 ? Colors.white : theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                )),
              ),
              title: Text(p.player, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(p.team),
              trailing: Text('${p.assists}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            );
          }),
      ],
    );
  }
}

class _TeamsGridTab extends StatelessWidget {
  final List<TeamModel> teams;
  const _TeamsGridTab({required this.teams});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: teams.length,
      itemBuilder: (context, index) {
        final team = teams[index];
        return InkWell(
          onTap: () => context.push('/team/${team.slug}'),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              border: Border.all(color: theme.dividerColor.withValues(alpha: 0.3)),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shield_rounded, size: 32, color: theme.colorScheme.primary),
                const SizedBox(height: 8),
                Text(
                  team.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
