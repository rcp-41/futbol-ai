import 'package:cloud_firestore/cloud_firestore.dart';

import '../../config/constants/firestore_paths.dart';
import '../datasources/gemini_datasource.dart';
import '../models/analysis_model.dart';

/// Analiz repository — cache + API çağrısı
class AnalysisRepository {
  final FirebaseFirestore _firestore;
  final GeminiDatasource _datasource;

  AnalysisRepository({
    FirebaseFirestore? firestore,
    GeminiDatasource? datasource,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _datasource = datasource ?? GeminiDatasource();

  /// Cache kontrol + yoksa API'den iste
  Future<AnalysisModel> getOrRequestAnalysis({
    required String matchId,
    required String userId,
  }) async {
    // 1. Firestore cache check
    final cached = await getCachedAnalysis(matchId: matchId, userId: userId);
    if (cached != null) return cached;

    // 2. API çağrısı
    final result = await _datasource.requestAnalysis(matchId);

    // 3. Parse
    return AnalysisModel.fromJson({
      ...result,
      'matchId': matchId,
      'userId': userId,
      'status': 'completed',
    });
  }

  /// Firestore cache'den oku
  Future<AnalysisModel?> getCachedAnalysis({
    required String matchId,
    required String userId,
  }) async {
    final snap = await _firestore
        .collection(FirestorePaths.analyses)
        .where('matchId', isEqualTo: matchId)
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'completed')
        .limit(1)
        .get();

    if (snap.docs.isEmpty) return null;
    return AnalysisModel.fromJson(snap.docs.first.data());
  }

  /// Analiz durumu stream (loading → completed)
  Stream<String> streamAnalysisStatus({
    required String matchId,
    required String userId,
  }) {
    return _firestore
        .collection(FirestorePaths.analyses)
        .where('matchId', isEqualTo: matchId)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots()
        .map((snap) {
      if (snap.docs.isEmpty) return 'idle';
      return snap.docs.first.data()['status'] as String? ?? 'idle';
    });
  }
}
