import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('FutbolAI App Smoke Tests', () {
    testWidgets('App renders MaterialApp', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Center(child: Text('FutbolAI')),
            ),
          ),
        ),
      );
      expect(find.text('FutbolAI'), findsOneWidget);
    });
  });
}
