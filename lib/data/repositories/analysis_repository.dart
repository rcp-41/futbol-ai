import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/utils/app_logger.dart';

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
      AppLogger.debug('Analysis', 'Cache hit: $matchId');
      return cached;
    }

    AppLogger.debug('Analysis', 'Cache miss, API cagrisi yapiliyor: $matchId');

    // 2. API cagrisi (Cloud Function üzerinden)
    final result = await _datasource.requestAnalysis(matchId);
    AppLogger.debug('Analysis', 'Yanit alindi, parse ediliyor...');

    // modelUsed bilgisini server response'undan al
    final modelUsed = result['modelUsed']?.toString() ?? 'gemini-2.5-flash-preview-05-20';

    // 3. Parse — hata olursa fallback model kullan
    AnalysisModel analysis;
    try {
      analysis = AnalysisModel.fromJson({
        ...result,
        'matchId': matchId,
        'userId': userId,
        'status': 'completed',
        'modelUsed': modelUsed,
      });
    } catch (e) {
      AppLogger.debug('Analysis', 'fromJson parse hatasi: $e');
      analysis = AnalysisModel(
        matchId: matchId,
        userId: userId,
        status: 'completed',
        modelUsed: modelUsed,
        prediction: _extractPrediction(result),
        detailedNarrative: result['detailedNarrative']?.toString() ??
            result['rawGeminiResponse']?.toString() ??
            'Analiz tamamlandi ancak veri formati beklenenden farkli.',
      );
    }

    // 4. Firestore'a cache'le (hata olsa bile analizi don)
    try {
      await _saveAnalysisToFirestore(analysis, matchId, userId, result);
      AppLogger.debug('Analysis', 'Firestore cache kaydedildi: $matchId');
    } catch (e) {
      AppLogger.debug('Analysis', 'Firestore cache kaydi basarisiz: $e');
    }

    return analysis;
  }

  /// Raw JSON'dan prediction cikarmaya calis
  PredictionModel? _extractPrediction(Map<String, dynamic> raw) {
    try {
      final pred = raw['prediction'];
      if (pred is Map<String, dynamic>) {
        return PredictionModel(
          result: pred['result']?.toString() ?? '?',
          resultLabel: pred['resultLabel']?.toString() ?? 'Bilinmiyor',
          confidence: (pred['confidence'] as num?)?.toDouble() ?? 0.5,
          surpriseAlert: pred['surpriseAlert'] == true,
          bankoLevel: pred['bankoLevel']?.toString() ?? 'RISKLI',
          mainReason: pred['mainReason']?.toString() ?? '',
        );
      }
    } catch (e) {
      AppLogger.warn('Analysis', 'Prediction parse hatasi: $e');
    }
    return null;
  }

  /// Analiz sonucunu Firestore'a kaydet (cache)
  Future<void> _saveAnalysisToFirestore(
    AnalysisModel analysis,
    String matchId,
    String userId,
    Map<String, dynamic> rawResult,
  ) async {
    final docId = '${matchId}_$userId';
    final modelUsed = rawResult['modelUsed']?.toString() ?? 'gemini-2.5-flash-preview-05-20';

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
      'rawGeminiResponse': jsonEncode(rawResult),
      'modelUsed': modelUsed,
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
      final docId = '${matchId}_$userId';
      final directDoc = await _firestore
          .collection(FirestorePaths.analyses)
          .doc(docId)
          .get();

      if (directDoc.exists) {
        final data = directDoc.data()!;
        // Timestamp → DateTime donusumu
        if (data['expiresAt'] is Timestamp) {
          final expiresAt = data['expiresAt'] as Timestamp;
          if (expiresAt.toDate().isBefore(DateTime.now())) {
            return null; // Cache suresi dolmus
          }
          data['expiresAt'] = expiresAt.toDate().toIso8601String();
        }
        if (data['createdAt'] is Timestamp) {
          data['createdAt'] = (data['createdAt'] as Timestamp).toDate().toIso8601String();
        }
        return AnalysisModel.fromJson(data);
      }

      // Query ile de dene (geriye uyumluluk)
      // Requires composite index: analyses(matchId, userId, status)
      // See firestore.indexes.json
      final snap = await _firestore
          .collection(FirestorePaths.analyses)
          .where('matchId', isEqualTo: matchId)
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'completed')
          .limit(1)
          .get();

      if (snap.docs.isEmpty) return null;

      final snapData = snap.docs.first.data();
      if (snapData['expiresAt'] is Timestamp) {
        snapData['expiresAt'] = (snapData['expiresAt'] as Timestamp).toDate().toIso8601String();
      }
      if (snapData['createdAt'] is Timestamp) {
        snapData['createdAt'] = (snapData['createdAt'] as Timestamp).toDate().toIso8601String();
      }
      return AnalysisModel.fromJson(snapData);
    } catch (e) {
      AppLogger.debug('Analysis', 'Cache okuma hatasi: $e');
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
