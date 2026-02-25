import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../models/match_model.dart';

/// Sportoto maç verisi repository — Firestore + Cloud Function
class SportotoRepository {
  final FirebaseFirestore _firestore;
  final FirebaseFunctions _functions;

  SportotoRepository({
    FirebaseFirestore? firestore,
    FirebaseFunctions? functions,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _functions = functions ??
            FirebaseFunctions.instanceFor(region: 'europe-west1');

  /// Güncel Sportoto maçları stream
  Stream<List<MatchModel>> watchSportotoMatches() {
    return _firestore
        .collection('sportoto_matches')
        .orderBy('orderNo')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            return MatchModel.fromFirestore(doc);
          }).toList(),
        );
  }

  /// Cloud Function tetikle — Sportoto verisini güncelle
  Future<Map<String, dynamic>> refreshSportotoData() async {
    final callable = _functions.httpsCallable('fetchSportotoMatches');
    final result = await callable.call<Map<String, dynamic>>();
    return result.data;
  }
}
