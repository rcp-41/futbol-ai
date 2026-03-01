import 'dart:convert';
import 'dart:io';

import '../utils/app_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

/// [S-09] FIX: Owner/repo bilgileri merkezi config'e taşındı.
/// İleride Firebase Remote Config'den okunabilir.
class _UpdateConfig {
  static const owner = 'rcp-41';
  static const repo = 'futbol-ai';
}

/// GitHub Releases tabanlı güncelleme servisi
class UpdateService {
  static const _apiUrl =
      'https://api.github.com/repos/${_UpdateConfig.owner}/${_UpdateConfig.repo}/releases/latest';

  String? _latestVersion;
  String? _downloadUrl;
  String? _releaseNotes;

  String? get latestVersion => _latestVersion;
  String? get downloadUrl => _downloadUrl;
  String? get releaseNotes => _releaseNotes;

  /// Mevcut patch numarası (artık GitHub based)
  Future<int?> get currentPatchNumber async {
    final info = await PackageInfo.fromPlatform();
    return int.tryParse(info.buildNumber);
  }

  /// GitHub'dan son sürümü kontrol et
  Future<UpdateCheckResult> checkForUpdate() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final currentVersion = info.version; // "1.0.0"

      final response = await http.get(
        Uri.parse(_apiUrl),
        headers: {'Accept': 'application/vnd.github.v3+json'},
      );

      if (response.statusCode != 200) {
        AppLogger.warn('Update', 'GitHub API error: ${response.statusCode}');
        return UpdateCheckResult.error;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final tagName = data['tag_name'] as String; // "v1.0.1"
      final latestVer = tagName.replaceFirst('v', '');

      _latestVersion = latestVer;
      _releaseNotes = data['body'] as String?;

      // APK asset'ini bul
      final assets = data['assets'] as List<dynamic>? ?? [];
      for (final asset in assets) {
        final name = asset['name'] as String;
        if (name.endsWith('.apk')) {
          _downloadUrl = asset['browser_download_url'] as String;
          break;
        }
      }

      if (_compareVersions(currentVersion, latestVer) < 0) {
        return UpdateCheckResult.updateAvailable;
      }

      return UpdateCheckResult.upToDate;
    } catch (e) {
      AppLogger.error('Update', 'Kontrol hatası', e);
      return UpdateCheckResult.error;
    }
  }

  /// APK'yı indir ve dosya yolunu döndür
  Future<String?> downloadUpdate({
    void Function(double progress)? onProgress,
  }) async {
    if (_downloadUrl == null) return null;

    try {
      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/futbolai_update.apk';
      final file = File(filePath);

      // Eski dosya varsa sil
      if (await file.exists()) await file.delete();

      // İndirme
      final request = http.Request('GET', Uri.parse(_downloadUrl!));
      final streamedResponse = await http.Client().send(request);

      final totalBytes = streamedResponse.contentLength ?? 0;
      int receivedBytes = 0;
      final sink = file.openWrite();

      await for (final chunk in streamedResponse.stream) {
        sink.add(chunk);
        receivedBytes += chunk.length;
        if (totalBytes > 0 && onProgress != null) {
          onProgress(receivedBytes / totalBytes);
        }
      }

      await sink.close();

      AppLogger.debug('Update', 'İndirildi: $filePath (${receivedBytes ~/ 1024} KB)');
      return filePath;
    } catch (e) {
      AppLogger.error('Update', 'İndirme hatası', e);
      return null;
    }
  }

  /// Versiyon karşılaştırma: a < b → -1, a == b → 0, a > b → 1
  int _compareVersions(String a, String b) {
    try {
      // Pre-release suffix'lerini temizle (ör: "1.0.0-beta" → "1.0.0")
      final cleanA = a.split('-').first;
      final cleanB = b.split('-').first;
      final aParts = cleanA.split('.').map((s) => int.tryParse(s) ?? 0).toList();
      final bParts = cleanB.split('.').map((s) => int.tryParse(s) ?? 0).toList();

      for (int i = 0; i < 3; i++) {
        final aPart = i < aParts.length ? aParts[i] : 0;
        final bPart = i < bParts.length ? bParts[i] : 0;
        if (aPart < bPart) return -1;
        if (aPart > bPart) return 1;
      }
      return 0;
    } catch (_) {
      return 0;
    }
  }
}

enum UpdateCheckResult { updateAvailable, upToDate, error }

/// Provider
final updateServiceProvider = Provider<UpdateService>((_) => UpdateService());
