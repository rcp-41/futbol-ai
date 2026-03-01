import 'package:firebase_analytics/firebase_analytics.dart';

/// [E-07] Firebase Analytics — merkezi event loglama servisi
class AnalyticsService {
  static final _analytics = FirebaseAnalytics.instance;

  static FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  static Future<void> logLogin(String method) =>
      _analytics.logLogin(loginMethod: method);

  static Future<void> logSignUp(String method) =>
      _analytics.logSignUp(signUpMethod: method);

  static Future<void> logAnalysisRequested(String matchId) =>
      _analytics.logEvent(
        name: 'analysis_requested',
        parameters: {'match_id': matchId},
      );

  static Future<void> logAnalysisCompleted(String matchId) =>
      _analytics.logEvent(
        name: 'analysis_completed',
        parameters: {'match_id': matchId},
      );

  static Future<void> logChatMessageSent(String matchId) =>
      _analytics.logEvent(
        name: 'chat_message_sent',
        parameters: {'match_id': matchId},
      );

  static Future<void> logSportotoRefreshed() =>
      _analytics.logEvent(name: 'sportoto_refreshed');

  static Future<void> logThemeChanged(String theme) =>
      _analytics.logEvent(
        name: 'theme_changed',
        parameters: {'theme': theme},
      );
}
