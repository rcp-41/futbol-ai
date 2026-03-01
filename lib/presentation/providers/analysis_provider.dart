import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/analysis_model.dart';
import '../../data/repositories/analysis_repository.dart';
import 'core_providers.dart';

// ═══ Repository Provider ═══

final analysisRepositoryProvider = Provider<AnalysisRepository>(
  (ref) => AnalysisRepository(datasource: ref.watch(geminiDatasourceProvider)),
);

// ═══ Analysis Provider ═══

/// Maç bazlı analiz — [P-05] autoDispose eklenmiş, hafta değiştiğinde bellekten temizlenir.
final analysisProvider =
    FutureProvider.autoDispose.family<AnalysisModel, String>((ref, matchId) async {
  final auth = ref.watch(authStateProvider).value;
  final userId = auth?.uid ?? 'anonymous';

  return ref.watch(analysisRepositoryProvider).getOrRequestAnalysis(
        matchId: matchId,
        userId: userId,
      );
});

// ═══ Analysis Status Stream ═══

final analysisStatusProvider =
    StreamProvider.autoDispose.family<String, String>((ref, matchId) {
  final auth = ref.watch(authStateProvider).value;
  final userId = auth?.uid ?? 'anonymous';

  return ref.watch(analysisRepositoryProvider).streamAnalysisStatus(
        matchId: matchId,
        userId: userId,
      );
});
