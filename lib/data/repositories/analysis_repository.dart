import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../config/constants/firestore_paths.dart';
import '../datasources/gemini_datasource.dart';
import '../models/analysis_model.dart';

/// Analiz repository — cache + API cagrisi + Firestore write-back
class AnalysisRepository {
  final FirebaseFirestore _firestore;
  final GeminiDatasource _datasource;

  AnalysisRepository({
    FirebaseFirestore? firestore,
    GeminiDatasource? datasource,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _datasource = datasource ?? GeminiDatasource();

  /// Cache kontrol + yoksa API'den iste + sonucu Firestore'a kaydet
  Future<AnalysisModel> getOrRequestAnalysis({
    required String matchId,
    required String userId,
  }) async {
    // 1. Firestore cache check
    final cached = await getCachedAnalysis(matchId: matchId, userId: userId);
    if (cached != null) {
      debugPrint('[Analysis] Cache hit: $matchId');
      return cached;
    }

    debugPrint('[Analysis] Cache miss, API cagrisi yapiliyor: $matchId');

    // 2. API cagrisi
    final result = await _datasource.requestAnalysis(matchId);

    // 3. Parse
    final analysis = AnalysisModel.fromJson({
      ...result,
      'matchId': matchId,
      'userId': userId,
      'status': 'completed',
      'modelUsed': 'gemini-2.5-flash-preview-04-17',
    });

    // 4. Firestore'a cache'le
    try {
      await _saveAnalysisToFirestore(analysis, matchId, userId, result);
      debugPrint('[Analysis] Firestore cache kaydedildi: $matchId');
    } catch (e) {
      debugPrint('[Analysis] Firestore cache kaydi basarisiz: $e');
      // Cache kaydi basarisiz olsa bile analiz sonucunu don
    }

    return analysis;
  }

  /// Analiz sonucunu Firestore'a kaydet (cache)
  Future<void> _saveAnalysisToFirestore(
    AnalysisModel analysis,
    String matchId,
    String userId,
    Map<String, dynamic> rawResult,
  ) async {
    final docId = '${matchId}_$userId';
    await _firestore.collection(FirestorePaths.analyses).doc(docId).set({
      'matchId': matchId,
      'userId': userId,
      'status': 'completed',
      'prediction': analysis.prediction != null
          ? {
              'result': analysis.prediction!.result,
              'resultLabel': analysis.prediction!.resultLabel,
              'confidence': analysis.prediction!.confidence,
              'surpriseAlert': analysis.prediction!.surpriseAlert,
              'bankoLevel': analysis.prediction!.bankoLevel,
              'mainReason': analysis.prediction!.mainReason,
            }
          : null,
      'categories': rawResult['categories'],
      'vetoRules': rawResult['vetoRules'],
      'weightedTotal': rawResult['weightedTotal'],
      'dataIntelligence': rawResult['dataIntelligence'],
      'xgAnalysis': analysis.xgAnalysis,
      'fixtureAnalysis': analysis.fixtureAnalysis,
      'injuryReport': analysis.injuryReport,
      'setPieceBreakdown': analysis.setPieceBreakdown,
      'refereeImpact': analysis.refereeImpact,
      'detailedNarrative': analysis.detailedNarrative,
      'rawGeminiResponse': rawResult.toString(),
      'modelUsed': 'gemini-2.5-flash-preview-04-17',
      'createdAt': FieldValue.serverTimestamp(),
      'expiresAt': Timestamp.fromDate(
        DateTime.now().add(const Duration(hours: 24)),
      ),
    });
  }

  /// Firestore cache'den oku
  Future<AnalysisModel?> getCachedAnalysis({
    required String matchId,
    required String userId,
  }) async {
    try {
      // Once docId ile dene (hizli)
      final docId = '${matchId}_$userId';
      final directDoc = await _firestore
          .collection(FirestorePaths.analyses)
          .doc(docId)
          .get();

      if (directDoc.exists) {
        final data = directDoc.data()!;
        // Suresi dolmus mu kontrol et
        final expiresAt = data['expiresAt'];
        if (expiresAt is Timestamp &&
            expiresAt.toDate().isAfter(DateTime.now())) {
          return AnalysisModel.fromJson(data);
        }
      }

      // Query ile de dene (geriye uyumluluk)
      final snap = await _firestore
          .collection(FirestorePaths.analyses)
          .where('matchId', isEqualTo: matchId)
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'completed')
          .limit(1)
          .get();

      if (snap.docs.isEmpty) return null;
      return AnalysisModel.fromJson(snap.docs.first.data());
    } catch (e) {
      debugPrint('[Analysis] Cache okuma hatasi: $e');
      return null;
    }
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
