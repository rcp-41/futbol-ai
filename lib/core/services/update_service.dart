import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

/// Shorebird OTA güncelleme servisi — SPEC.md Bölüm 14.3
class UpdateService {
  final ShorebirdUpdater _updater = ShorebirdUpdater();

  /// Shorebird aktif mi kontrol et (release build'de true)
  bool get isAvailable => _updater.isAvailable;

  /// Mevcut patch numarası
  Future<int?> get currentPatchNumber async {
    final patch = await _updater.readCurrentPatch();
    return patch?.number;
  }

  /// Güncelleme var mı kontrol et
  Future<UpdateStatus> checkForUpdate() async {
    if (!isAvailable) return UpdateStatus.upToDate;
    return await _updater.checkForUpdate();
  }

  /// Güncellemeyi indir ve kur
  Future<void> update() async {
    if (!isAvailable) return;
    await _updater.update();
  }

  /// Tam akış: kontrol et → varsa indir → sonuç döndür
  Future<UpdateResult> checkAndUpdate() async {
    if (!isAvailable) return UpdateResult.notAvailable;

    try {
      final status = await checkForUpdate();

      if (status == UpdateStatus.outdated) {
        await update();
        return UpdateResult.updated;
      }

      return UpdateResult.upToDate;
    } catch (e) {
      debugPrint('[Shorebird] Güncelleme hatası: $e');
      return UpdateResult.error;
    }
  }
}

enum UpdateResult { updated, upToDate, notAvailable, error }

/// Provider
final updateServiceProvider = Provider<UpdateService>((_) => UpdateService());
