import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/match_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/match_repository.dart';

// ═══ Repository Providers ═══

final matchRepositoryProvider = Provider<MatchRepository>(
  (ref) => MatchRepository(),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(),
);

// ═══ Auth Providers ═══

final authStateProvider = StreamProvider<User?>(
  (ref) => ref.watch(authRepositoryProvider).authStateChanges,
);

// ═══ Match Providers ═══

final selectedWeekProvider = StateProvider<int>((ref) => 1);
final selectedLeagueProvider = StateProvider<String?>((ref) => null);

final matchesProvider = StreamProvider<List<MatchModel>>((ref) {
  final week = ref.watch(selectedWeekProvider);
  final league = ref.watch(selectedLeagueProvider);
  return ref.watch(matchRepositoryProvider).watchMatches(
        week: week,
        league: league,
      );
});

final availableWeeksProvider = FutureProvider<List<int>>((ref) {
  return ref.watch(matchRepositoryProvider).getAvailableWeeks();
});
