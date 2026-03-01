import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../config/constants/firestore_paths.dart';
import '../models/multi_model_analysis_model.dart';
import '../models/match_model.dart';

class MultiModelAnalysisRepository {
  final FirebaseFirestore _firestore;
  final FirebaseFunctions _functions;
  final FirebaseAuth _auth;

  MultiModelAnalysisRepository({
    FirebaseFirestore? firestore,
    FirebaseFunctions? functions,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _functions = functions ?? FirebaseFunctions.instanceFor(region: 'europe-west1'),
        _auth = auth ?? FirebaseAuth.instance;

  Stream<MultiModelAnalysisModel?> watchAnalysis(String matchId) {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(null);

    final docId = '${matchId}_${user.uid}';
    return _firestore
        .collection(FirestorePaths.multiAnalyses)
        .doc(docId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return MultiModelAnalysisModel.fromJson(snapshot.data()!);
      }
      return null;
    });
  }

  Future<void> triggerAnalysis(MatchModel match) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Kullanıcı girişi yapılmamış.');

    try {
      final matchData = match.toJson();
      
      final callable = _functions.httpsCallable('triggerMultiModelAnalysis');
      final result = await callable.call({
        'matchId': match.id,
        'matchData': matchData,
      });

      if (result.data['success'] != true) {
        throw Exception(result.data['message'] ?? 'Analiz başlatılamadı.');
      }
    } on FirebaseFunctionsException catch (e) {
      throw Exception(e.message ?? 'Cloud Function hatası.');
    } catch (e) {
      throw Exception('Beklenmeyen bir hata oluştu: $e');
    }
  }
}
