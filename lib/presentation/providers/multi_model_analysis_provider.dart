import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/multi_model_analysis_model.dart';
import '../../data/repositories/multi_model_analysis_repository.dart';
import '../../data/models/match_model.dart';

final multiModelAnalysisRepositoryProvider = Provider<MultiModelAnalysisRepository>((ref) {
  return MultiModelAnalysisRepository();
});

final multiModelAnalysisStreamProvider = StreamProvider.family<MultiModelAnalysisModel?, String>((ref, matchId) {
  final repository = ref.watch(multiModelAnalysisRepositoryProvider);
  return repository.watchAnalysis(matchId);
});

final triggerMultiModelAnalysisProvider = FutureProvider.family<void, MatchModel>((ref, match) async {
  final repository = ref.watch(multiModelAnalysisRepositoryProvider);
  await repository.triggerAnalysis(match);
});
