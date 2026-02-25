import 'package:cloud_firestore/cloud_firestore.dart';

import '../../config/constants/firestore_paths.dart';
import '../models/match_model.dart';

/// Firestore maç repository — CRUD + stream
class MatchRepository {
  final FirebaseFirestore _firestore;

  MatchRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Maçları hafta ve lig filtresiyle stream et
  Stream<List<MatchModel>> watchMatches({
    required int week,
    String? league,
  }) {
    Query query = _firestore
        .collection(FirestorePaths.matches)
        .where('week', isEqualTo: week)
        .orderBy('matchDate');

    if (league != null && league.isNotEmpty && league != 'Tümü') {
      query = query.where('league', isEqualTo: league);
    }

    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => MatchModel.fromFirestore(doc)).toList());
  }

  /// Tekil maç getir
  Future<MatchModel?> getMatch(String matchId) async {
    final doc = await _firestore
        .collection(FirestorePaths.matches)
        .doc(matchId)
        .get();
    if (!doc.exists) return null;
    return MatchModel.fromFirestore(doc);
  }

  /// Tüm hafta numaralarını getir
  Future<List<int>> getAvailableWeeks() async {
    final snapshot =
        await _firestore.collection(FirestorePaths.matches).get();
    final weeks = snapshot.docs
        .map((doc) => (doc.data()['week'] as num?)?.toInt() ?? 0)
        .toSet()
        .toList();
    weeks.sort();
    return weeks;
  }
}
