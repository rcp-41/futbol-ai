import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

import 'app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Arka planda OTA güncelleme kontrolü (kullanıcıyı bekletmez)
  _checkForOTAUpdates();

  runApp(const ProviderScope(child: FutbolAIApp()));
}

/// Shorebird OTA güncelleme — SPEC.md Bölüm 14.5
Future<void> _checkForOTAUpdates() async {
  try {
    final updater = ShorebirdUpdater();
    if (!updater.isAvailable) return;

    final status = await updater.checkForUpdate();
    if (status == UpdateStatus.outdated) {
      await updater.update();
      debugPrint('[Shorebird] Patch indirildi, sonraki açılışta aktif.');
    }
  } catch (e) {
    debugPrint('[Shorebird] Güncelleme kontrolü başarısız: $e');
  }
}
