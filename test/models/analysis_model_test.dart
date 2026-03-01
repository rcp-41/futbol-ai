import 'package:flutter_test/flutter_test.dart';
import 'package:futbol_ai/data/models/analysis_model.dart';

void main() {
  group('AnalysisModel', () {
    test('fromJson creates model with required fields', () {
      final json = {
        'matchId': 'match_123',
        'userId': 'user_456',
        'status': 'completed',
        'detailedNarrative': 'Test narrative',
      };

      final model = AnalysisModel.fromJson(json);
      expect(model.matchId, 'match_123');
      expect(model.userId, 'user_456');
      expect(model.status, 'completed');
      expect(model.detailedNarrative, 'Test narrative');
    });

    test('fromJson uses defaults for optional fields', () {
      final json = {
        'matchId': 'match_123',
        'userId': 'user_456',
      };

      final model = AnalysisModel.fromJson(json);
      expect(model.status, 'pending');
      expect(model.vetoRules, isEmpty);
      expect(model.detailedNarrative, '');
      expect(model.prediction, isNull);
      expect(model.categories, isNull);
    });

    test('fromJson parses prediction correctly', () {
      final json = {
        'matchId': 'match_123',
        'userId': 'user_456',
        'prediction': {
          'result': '1',
          'resultLabel': 'Ev Sahibi Galip',
          'confidence': 0.75,
          'surpriseAlert': false,
          'bankoLevel': 'ORTA',
          'mainReason': 'Test reason',
        },
      };

      final model = AnalysisModel.fromJson(json);
      expect(model.prediction, isNotNull);
      expect(model.prediction!.result, '1');
      expect(model.prediction!.confidence, 0.75);
      expect(model.prediction!.surpriseAlert, false);
    });

    test('fromJson parses categories correctly', () {
      final json = {
        'matchId': 'match_123',
        'userId': 'user_456',
        'categories': {
          'power': {
            'homeScore': 7.5,
            'awayScore': 5.0,
            'weight': 0.20,
            'detail': 'Power detail',
          },
        },
      };

      final model = AnalysisModel.fromJson(json);
      expect(model.categories, isNotNull);
      expect(model.categories!.power, isNotNull);
      expect(model.categories!.power!.homeScore, 7.5);
      expect(model.categories!.power!.weight, 0.20);
    });
  });

  group('PredictionModel', () {
    test('fromJson with all fields', () {
      final json = {
        'result': 'X',
        'resultLabel': 'Beraberlik',
        'confidence': 0.6,
        'surpriseAlert': true,
        'bankoLevel': 'KAPAT',
        'mainReason': 'Both teams defensive',
      };

      final model = PredictionModel.fromJson(json);
      expect(model.result, 'X');
      expect(model.resultLabel, 'Beraberlik');
      expect(model.confidence, 0.6);
      expect(model.surpriseAlert, true);
    });

    test('fromJson with defaults', () {
      final model = PredictionModel.fromJson({});
      expect(model.result, '');
      expect(model.confidence, 0.0);
      expect(model.surpriseAlert, false);
    });
  });
}
