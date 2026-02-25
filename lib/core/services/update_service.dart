import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

/// GitHub Releases tabanlı güncelleme servisi
class UpdateService {
  static const _owner = 'rcp-41';
  static const _repo = 'futbol-ai';
  static const _apiUrl =
      'https://api.github.com/repos/$_owner/$_repo/releases/latest';

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
        debugPrint('[Update] GitHub API error: ${response.statusCode}');
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
      debugPrint('[Update] Kontrol hatası: $e');
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

      debugPrint('[Update] İndirildi: $filePath (${receivedBytes ~/ 1024} KB)');
      return filePath;
    } catch (e) {
      debugPrint('[Update] İndirme hatası: $e');
      return null;
    }
  }

  /// Versiyon karşılaştırma: a < b → -1, a == b → 0, a > b → 1
  int _compareVersions(String a, String b) {
    final aParts = a.split('.').map(int.parse).toList();
    final bParts = b.split('.').map(int.parse).toList();

    for (int i = 0; i < 3; i++) {
      final aPart = i < aParts.length ? aParts[i] : 0;
      final bPart = i < bParts.length ? bParts[i] : 0;
      if (aPart < bPart) return -1;
      if (aPart > bPart) return 1;
    }
    return 0;
  }
}

enum UpdateCheckResult { updateAvailable, upToDate, error }

/// Provider
final updateServiceProvider = Provider<UpdateService>((_) => UpdateService());
