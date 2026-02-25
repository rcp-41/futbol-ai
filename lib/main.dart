import 'dart:async';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

import 'app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // Zone ile tum hatalari yakala
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Firebase Crashlytics — Flutter hatalari
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    // Platform hatalari (async hatalar dahil)
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    // Turkce tarih formati destegi
    await initializeDateFormatting('tr_TR');

    // Arka planda OTA guncelleme kontrolu (kullaniciyi bekletmez)
    _checkForOTAUpdates();

    runApp(const ProviderScope(child: FutbolAIApp()));
  }, (error, stack) {
    // Zone-level hata yakalama
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  });
}

/// Shorebird OTA guncelleme — SPEC.md Bolum 14.5
Future<void> _checkForOTAUpdates() async {
  try {
    final updater = ShorebirdUpdater();
    if (!updater.isAvailable) return;

    final status = await updater.checkForUpdate();
    if (status == UpdateStatus.outdated) {
      await updater.update();
      debugPrint('[Shorebird] Patch indirildi, sonraki acilista aktif.');
    }
  } catch (e) {
    debugPrint('[Shorebird] Guncelleme kontrolu basarisiz: $e');
  }
}
