import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/gemini_datasource.dart';
import '../../data/models/analysis_model.dart';
import '../../data/repositories/analysis_repository.dart';
import 'matches_provider.dart';

// ═══ Datasource & Repository Providers ═══

final geminiDatasourceProvider = Provider<GeminiDatasource>(
  (ref) => GeminiDatasource(),
);

final analysisRepositoryProvider = Provider<AnalysisRepository>(
  (ref) => AnalysisRepository(datasource: ref.watch(geminiDatasourceProvider)),
);

// ═══ Analysis Provider ═══

/// Maç bazlı analiz — FutureProvider.family
final analysisProvider =
    FutureProvider.family<AnalysisModel, String>((ref, matchId) async {
  final auth = ref.watch(authStateProvider).value;
  if (auth == null) throw Exception('Giriş yapmalısınız.');

  return ref.watch(analysisRepositoryProvider).getOrRequestAnalysis(
        matchId: matchId,
        userId: auth.uid,
      );
});

// ═══ Analysis Status Stream ═══

final analysisStatusProvider =
    StreamProvider.family<String, String>((ref, matchId) {
  final auth = ref.watch(authStateProvider).value;
  if (auth == null) return Stream.value('idle');

  return ref.watch(analysisRepositoryProvider).streamAnalysisStatus(
        matchId: matchId,
        userId: auth.uid,
      );
});
