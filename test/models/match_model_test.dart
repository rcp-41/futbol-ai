import 'package:flutter_test/flutter_test.dart';
import 'package:futbol_ai/data/models/match_model.dart';

void main() {
  group('MatchModel', () {
    test('fromJson creates model with required fields', () {
      final json = {
        'id': 'match_123',
        'homeTeam': {'name': 'Galatasaray', 'shortName': 'GS'},
        'awayTeam': {'name': 'Fenerbahce', 'shortName': 'FB'},
        'league': 'Süper Lig',
        'matchDate': '2026-03-01T20:00:00.000',
      };

      final model = MatchModel.fromJson(json);
      expect(model.id, 'match_123');
      expect(model.homeTeam.name, 'Galatasaray');
      expect(model.awayTeam.name, 'Fenerbahce');
      expect(model.league, 'Süper Lig');
    });

    test('fromJson uses defaults for optional fields', () {
      final json = {
        'id': 'match_123',
        'homeTeam': {'name': 'TeamA'},
        'awayTeam': {'name': 'TeamB'},
        'league': 'Premier League',
        'matchDate': '2026-03-01T20:00:00.000',
      };

      final model = MatchModel.fromJson(json);
      expect(model.week, 0);
      expect(model.status, 'upcoming');
      expect(model.importance, 'normal');
      expect(model.stadium, '');
      expect(model.odds, isNull);
      expect(model.score, isNull);
    });

    test('fromJson parses odds correctly', () {
      final json = {
        'id': 'match_123',
        'homeTeam': {'name': 'TeamA'},
        'awayTeam': {'name': 'TeamB'},
        'league': 'La Liga',
        'matchDate': '2026-03-01T20:00:00.000',
        'odds': {
          'home': 1.85,
          'draw': 3.5,
          'away': 4.2,
          'source': 'nesine',
        },
      };

      final model = MatchModel.fromJson(json);
      expect(model.odds, isNotNull);
      expect(model.odds!.home, 1.85);
      expect(model.odds!.draw, 3.5);
      expect(model.odds!.away, 4.2);
    });

    test('fromJson parses score correctly', () {
      final json = {
        'id': 'match_123',
        'homeTeam': {'name': 'TeamA'},
        'awayTeam': {'name': 'TeamB'},
        'league': 'Serie A',
        'matchDate': '2026-03-01T20:00:00.000',
        'score': {'home': 2, 'away': 1},
      };

      final model = MatchModel.fromJson(json);
      expect(model.score, isNotNull);
      expect(model.score!.home, 2);
      expect(model.score!.away, 1);
    });
  });

  group('TeamInfo', () {
    test('fromJson with all fields', () {
      final json = {
        'name': 'Galatasaray',
        'shortName': 'GS',
        'logoUrl': 'https://example.com/gs.png',
        'formLast5': 'WWDLW',
      };

      final model = TeamInfo.fromJson(json);
      expect(model.name, 'Galatasaray');
      expect(model.shortName, 'GS');
      expect(model.logoUrl, 'https://example.com/gs.png');
      expect(model.formLast5, 'WWDLW');
    });

    test('fromJson with defaults', () {
      final model = TeamInfo.fromJson({'name': 'TeamX'});
      expect(model.shortName, '');
      expect(model.logoUrl, '');
      expect(model.formLast5, '');
    });
  });

  group('MatchOdds', () {
    test('fromJson with defaults', () {
      final model = MatchOdds.fromJson({});
      expect(model.home, 0.0);
      expect(model.draw, 0.0);
      expect(model.away, 0.0);
      expect(model.source, '');
    });
  });
}
