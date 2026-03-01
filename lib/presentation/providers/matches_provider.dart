import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/match_model.dart';
import '../../data/repositories/match_repository.dart';
import 'core_providers.dart';

// Re-export core providers for backward compatibility
export 'core_providers.dart' show authStateProvider, authRepositoryProvider;

// ═══ Repository Providers ═══

final matchRepositoryProvider = Provider<MatchRepository>(
  (ref) => MatchRepository(),
);

// ═══ Match Providers ═══

/// [B-09] FIX: selectedWeekProvider artık availableWeeks'ten son haftayı alır.
/// İlk değer -1 (henüz yüklenmemiş); UI tarafında availableWeeks yüklenince set edilir.
final selectedWeekProvider = StateProvider<int>((ref) {
  final weeks = ref.watch(availableWeeksProvider).valueOrNull;
  if (weeks != null && weeks.isNotEmpty) {
    return weeks.last; // En son hafta
  }
  return 1; // Fallback
});

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
