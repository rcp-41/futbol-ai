import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/team_model.dart';
import '../models/player_model.dart';
import '../models/league_model.dart';
import '../models/news_model.dart';
import '../../core/utils/app_logger.dart';

/// Firestore datasource — scraper koleksiyonlarına erişim
class FootballDatasource {
  static const _tag = 'FootballDatasource';
  final FirebaseFirestore _firestore;

  FootballDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // ─────────────────── TEAMS ───────────────────

  /// Takım bilgilerini slug ile çek
  Future<TeamModel?> getTeam(String slug) async {
    try {
      final doc = await _firestore.collection('teams').doc(slug).get();
      if (!doc.exists) return null;
      return TeamModel.fromFirestore(doc);
    } catch (e) {
      AppLogger.error(_tag, 'getTeam($slug) error', e);
      return null;
    }
  }

  /// Tüm takımları bir lig için çek
  Future<List<TeamModel>> getTeamsByLeague(String league) async {
    try {
      final snap = await _firestore
          .collection('teams')
          .where('league', isEqualTo: league)
          .get();
      return snap.docs.map((d) => TeamModel.fromFirestore(d)).toList();
    } catch (e) {
      AppLogger.error(_tag, 'getTeamsByLeague($league) error', e);
      return [];
    }
  }

  /// Takım stream (real-time)
  Stream<TeamModel?> watchTeam(String slug) {
    return _firestore.collection('teams').doc(slug).snapshots().map((doc) {
      if (!doc.exists) return null;
      return TeamModel.fromFirestore(doc);
    });
  }

  // ─────────────────── PLAYERS ───────────────────

  /// Oyuncu bilgilerini ID ile çek
  Future<PlayerModel?> getPlayer(String playerId) async {
    try {
      final doc = await _firestore.collection('players').doc(playerId).get();
      if (!doc.exists) return null;
      return PlayerModel.fromFirestore(doc);
    } catch (e) {
      AppLogger.error(_tag, 'getPlayer($playerId) error', e);
      return null;
    }
  }

  /// Takımdaki oyuncuları çek
  Future<List<PlayerModel>> getPlayersByTeam(String teamSlug) async {
    try {
      final snap = await _firestore
          .collection('players')
          .where('team', isEqualTo: teamSlug)
          .get();
      return snap.docs.map((d) => PlayerModel.fromFirestore(d)).toList();
    } catch (e) {
      AppLogger.error(_tag, 'getPlayersByTeam($teamSlug) error', e);
      return [];
    }
  }

  /// Oyuncu stream
  Stream<PlayerModel?> watchPlayer(String playerId) {
    return _firestore
        .collection('players')
        .doc(playerId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;
      return PlayerModel.fromFirestore(doc);
    });
  }

  // ─────────────────── LEAGUES ───────────────────

  /// Lig bilgilerini çek
  Future<LeagueModel?> getLeague(String leagueKey) async {
    try {
      final doc = await _firestore.collection('leagues').doc(leagueKey).get();
      if (!doc.exists) return null;
      return LeagueModel.fromFirestore(doc);
    } catch (e) {
      AppLogger.error(_tag, 'getLeague($leagueKey) error', e);
      return null;
    }
  }

  /// Tüm ligleri çek
  Future<List<LeagueModel>> getAllLeagues() async {
    try {
      final snap = await _firestore.collection('leagues').get();
      return snap.docs.map((d) => LeagueModel.fromFirestore(d)).toList();
    } catch (e) {
      AppLogger.error(_tag, 'getAllLeagues error', e);
      return [];
    }
  }

  /// Lig stream
  Stream<LeagueModel?> watchLeague(String leagueKey) {
    return _firestore
        .collection('leagues')
        .doc(leagueKey)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;
      return LeagueModel.fromFirestore(doc);
    });
  }

  // ─────────────────── NEWS ───────────────────

  /// Takım haberlerini çek
  Future<List<NewsModel>> getNewsByTeam(String teamSlug, {int limit = 10}) async {
    try {
      final snap = await _firestore
          .collection('news')
          .where('relatedTeam', isEqualTo: teamSlug)
          .orderBy('date', descending: true)
          .limit(limit)
          .get();
      return snap.docs.map((d) => NewsModel.fromFirestore(d)).toList();
    } catch (e) {
      AppLogger.error(_tag, 'getNewsByTeam($teamSlug) error', e);
      return [];
    }
  }

  /// Son haberleri çek (tüm takımlar)
  Future<List<NewsModel>> getLatestNews({int limit = 20}) async {
    try {
      final snap = await _firestore
          .collection('news')
          .orderBy('date', descending: true)
          .limit(limit)
          .get();
      return snap.docs.map((d) => NewsModel.fromFirestore(d)).toList();
    } catch (e) {
      AppLogger.error(_tag, 'getLatestNews error', e);
      return [];
    }
  }

  /// Haberler stream (real-time)
  Stream<List<NewsModel>> watchNewsByTeam(String teamSlug, {int limit = 10}) {
    return _firestore
        .collection('news')
        .where('relatedTeam', isEqualTo: teamSlug)
        .orderBy('date', descending: true)
        .limit(limit)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => NewsModel.fromFirestore(d)).toList());
  }
}
