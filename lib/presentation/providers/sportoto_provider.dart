import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/match_model.dart';
import '../../data/repositories/sportoto_repository.dart';

/// Sportoto Repository Provider
final sportotoRepositoryProvider = Provider<SportotoRepository>(
  (_) => SportotoRepository(),
);

/// Sportoto maçları stream
final sportotoMatchesProvider = StreamProvider<List<MatchModel>>((ref) {
  final repo = ref.watch(sportotoRepositoryProvider);
  return repo.watchSportotoMatches();
});

/// Manuel yenileme state
final sportotoRefreshProvider =
    StateNotifierProvider<SportotoRefreshNotifier, AsyncValue<void>>(
  (ref) => SportotoRefreshNotifier(ref.read(sportotoRepositoryProvider)),
);

class SportotoRefreshNotifier extends StateNotifier<AsyncValue<void>> {
  final SportotoRepository _repo;

  SportotoRefreshNotifier(this._repo)
      : super(const AsyncValue.data(null));

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      await _repo.refreshSportotoData();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
