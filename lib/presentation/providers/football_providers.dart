import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/football_datasource.dart';
import '../../data/models/team_model.dart';
import '../../data/models/player_model.dart';
import '../../data/models/league_model.dart';
import '../../data/models/news_model.dart';

// ═══ Datasource Provider ═══

final footballDatasourceProvider = Provider<FootballDatasource>(
  (ref) => FootballDatasource(),
);

// ═══ League Providers ═══

final allLeaguesProvider = FutureProvider<List<LeagueModel>>((ref) {
  return ref.watch(footballDatasourceProvider).getAllLeagues();
});

final leagueDetailProvider =
    StreamProvider.family<LeagueModel?, String>((ref, leagueKey) {
  return ref.watch(footballDatasourceProvider).watchLeague(leagueKey);
});

// ═══ Team Providers ═══

final teamDetailProvider =
    StreamProvider.family<TeamModel?, String>((ref, slug) {
  return ref.watch(footballDatasourceProvider).watchTeam(slug);
});

final teamsByLeagueProvider =
    FutureProvider.family<List<TeamModel>, String>((ref, league) {
  return ref.watch(footballDatasourceProvider).getTeamsByLeague(league);
});

// ═══ Player Providers ═══

final playerDetailProvider =
    StreamProvider.family<PlayerModel?, String>((ref, playerId) {
  return ref.watch(footballDatasourceProvider).watchPlayer(playerId);
});

final playersByTeamProvider =
    FutureProvider.family<List<PlayerModel>, String>((ref, teamSlug) {
  return ref.watch(footballDatasourceProvider).getPlayersByTeam(teamSlug);
});

// ═══ News Providers ═══

final latestNewsProvider = FutureProvider<List<NewsModel>>((ref) {
  return ref.watch(footballDatasourceProvider).getLatestNews();
});

final teamNewsProvider =
    StreamProvider.family<List<NewsModel>, String>((ref, teamSlug) {
  return ref.watch(footballDatasourceProvider).watchNewsByTeam(teamSlug);
});
