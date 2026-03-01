import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/team_model.dart';
import '../providers/football_providers.dart';

/// Takım Profil Sayfası — kadro, form, istatistikler, haberler
class TeamProfileScreen extends ConsumerWidget {
  final String teamSlug;
  const TeamProfileScreen({required this.teamSlug, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamAsync = ref.watch(teamDetailProvider(teamSlug));
    final playersAsync = ref.watch(playersByTeamProvider(teamSlug));
    final newsAsync = ref.watch(teamNewsProvider(teamSlug));
    final theme = Theme.of(context);

    return Scaffold(
      body: teamAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Hata: $e')),
        data: (team) {
          if (team == null) {
            return const Center(child: Text('Takım bulunamadı.'));
          }
          return CustomScrollView(
            slivers: [
              // ═══ Hero AppBar ═══
              SliverAppBar(
                expandedHeight: 180,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    team.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      shadows: [Shadow(blurRadius: 8, color: Colors.black45)],
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.secondary,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.shield_rounded,
                        size: 72,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                ),
              ),

              // ═══ Quick Stats ═══
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _QuickStatsRow(team: team),
                ),
              ),

              // ═══ Form ═══
              if (team.recentForm.isNotEmpty)
                SliverToBoxAdapter(
                  child: _FormCard(form: team.recentForm),
                ),

              // ═══ Sakatlar ve Cezalılar ═══
              if (team.injuries.isNotEmpty || team.suspended.isNotEmpty)
                SliverToBoxAdapter(
                  child: _AbsencesCard(
                    injuries: team.injuries,
                    suspended: team.suspended,
                  ),
                ),

              // ═══ Transfer Söylentileri ═══
              if (team.transferRumors.isNotEmpty)
                SliverToBoxAdapter(
                  child: _TransferRumorsCard(rumors: team.transferRumors),
                ),

              // ═══ Kadro ═══
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text('Kadro', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                ),
              ),
              playersAsync.when(
                loading: () => const SliverToBoxAdapter(
                  child: Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator())),
                ),
                error: (e, _) => const SliverToBoxAdapter(child: SizedBox.shrink()),
                data: (players) => SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _PlayerTile(player: players[index]),
                    childCount: players.length,
                  ),
                ),
              ),

              // ═══ Haberler ═══
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text('Haberler', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                ),
              ),
              newsAsync.when(
                loading: () => const SliverToBoxAdapter(
                  child: Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator())),
                ),
                error: (e, _) => const SliverToBoxAdapter(child: SizedBox.shrink()),
                data: (news) => news.isEmpty
                    ? const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Center(child: Text('Haber bulunamadı')),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _NewsTile(news: news[index]),
                          childCount: news.length,
                        ),
                      ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────── WIDGETS ───────────────────

class _QuickStatsRow extends StatelessWidget {
  final TeamModel team;
  const _QuickStatsRow({required this.team});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _StatItem(
          icon: Icons.people_rounded,
          label: 'Kadro',
          value: '${team.squad.length}',
          color: theme.colorScheme.primary,
        ),
        _StatItem(
          icon: Icons.euro_rounded,
          label: 'Değer',
          value: _formatValue(team.totalSquadValue),
          color: Colors.green,
        ),
        _StatItem(
          icon: Icons.cake_rounded,
          label: 'Ort. Yaş',
          value: team.averageAge.toStringAsFixed(1),
          color: Colors.orange,
        ),
        _StatItem(
          icon: Icons.local_hospital_rounded,
          label: 'Sakat',
          value: '${team.injuries.length}',
          color: Colors.red,
        ),
      ],
    );
  }

  String _formatValue(int value) {
    if (value >= 1000000000) return '€${(value / 1000000000).toStringAsFixed(1)}B';
    if (value >= 1000000) return '€${(value / 1000000).toStringAsFixed(0)}M';
    if (value >= 1000) return '€${(value / 1000).toStringAsFixed(0)}K';
    return '€$value';
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _StatItem({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 6),
        Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _FormCard extends StatelessWidget {
  final List<String> form;
  const _FormCard({required this.form});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Son Form', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: form.take(5).map((r) {
                final color = r == 'W' ? Colors.green : r == 'D' ? Colors.orange : Colors.red;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(r, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _AbsencesCard extends StatelessWidget {
  final List<InjuryInfo> injuries;
  final List<SuspendedPlayer> suspended;
  const _AbsencesCard({required this.injuries, required this.suspended});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Eksik Oyuncular', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...injuries.map((i) => ListTile(
              leading: const Icon(Icons.local_hospital, color: Colors.red, size: 20),
              title: Text(i.player),
              subtitle: Text('${i.type} — Dönüş: ${i.expectedReturn}'),
              dense: true,
              contentPadding: EdgeInsets.zero,
            )),
            ...suspended.map((s) => ListTile(
              leading: const Icon(Icons.warning_rounded, color: Colors.amber, size: 20),
              title: Text(s.player),
              subtitle: Text('Cezalı: ${s.reason}'),
              dense: true,
              contentPadding: EdgeInsets.zero,
            )),
          ],
        ),
      ),
    );
  }
}

class _TransferRumorsCard extends StatelessWidget {
  final List<TransferRumor> rumors;
  const _TransferRumorsCard({required this.rumors});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Transfer Söylentileri',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...rumors.map((r) => ListTile(
              leading: Icon(
                r.type == 'in' ? Icons.arrow_downward : Icons.arrow_upward,
                color: r.type == 'in' ? Colors.green : Colors.red,
              ),
              title: Text(r.player),
              subtitle: Text('${r.source} • ${r.reliability}'),
              dense: true,
              contentPadding: EdgeInsets.zero,
            )),
          ],
        ),
      ),
    );
  }
}

class _PlayerTile extends StatelessWidget {
  final dynamic player; // PlayerModel
  const _PlayerTile({required this.player});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
        child: Text(
          '${player.number}',
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(player.name, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text('${player.position} • ${player.nationality}'),
      trailing: player.marketValue > 0
          ? Text(
              '€${(player.marketValue / 1000000).toStringAsFixed(1)}M',
              style: TextStyle(
                color: Colors.green.shade700,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
    );
  }
}

class _NewsTile extends StatelessWidget {
  final dynamic news; // NewsModel
  const _NewsTile({required this.news});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: const Icon(Icons.article_rounded),
        title: Text(
          news.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text('${news.source} • ${news.date}'),
      ),
    );
  }
}
