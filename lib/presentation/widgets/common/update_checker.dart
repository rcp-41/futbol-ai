import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';

import '../../../core/services/update_service.dart';

/// Güncelleme Kontrol Butonu — GitHub Releases tabanlı
class UpdateCheckerButton extends ConsumerStatefulWidget {
  const UpdateCheckerButton({super.key});

  @override
  ConsumerState<UpdateCheckerButton> createState() =>
      _UpdateCheckerButtonState();
}

class _UpdateCheckerButtonState extends ConsumerState<UpdateCheckerButton> {
  UpdateCheckState _state = UpdateCheckState.idle;
  double _progress = 0;
  String? _latestVersion;

  Future<void> _checkForUpdates() async {
    setState(() => _state = UpdateCheckState.checking);

    try {
      final updateService = ref.read(updateServiceProvider);
      final result = await updateService.checkForUpdate();

      switch (result) {
        case UpdateCheckResult.updateAvailable:
          _latestVersion = updateService.latestVersion;
          setState(() => _state = UpdateCheckState.updateAvailable);
          _showUpdateDialog(updateService);
        case UpdateCheckResult.upToDate:
          setState(() => _state = UpdateCheckState.upToDate);
          _showSnackBar('✅ Uygulamanız güncel!');
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) setState(() => _state = UpdateCheckState.idle);
          });
        case UpdateCheckResult.error:
          setState(() => _state = UpdateCheckState.error);
          _showSnackBar('❌ Güncelleme kontrol edilemedi.');
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) setState(() => _state = UpdateCheckState.idle);
          });
      }
    } catch (e) {
      setState(() => _state = UpdateCheckState.error);
      _showSnackBar('❌ Bir hata oluştu: $e');
    }
  }

  void _showUpdateDialog(UpdateService updateService) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('🆕 Güncelleme Mevcut!'),
        content: Text(
          'Yeni versiyon v$_latestVersion yayınlandı.\n\n'
          'İndirmek ve yüklemek ister misiniz?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _state = UpdateCheckState.idle);
            },
            child: const Text('Sonra'),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              _downloadAndInstall(updateService);
            },
            icon: const Icon(Icons.download),
            label: const Text('İndir ve Kur'),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadAndInstall(UpdateService updateService) async {
    setState(() {
      _state = UpdateCheckState.downloading;
      _progress = 0;
    });

    final filePath = await updateService.downloadUpdate(
      onProgress: (p) {
        if (mounted) setState(() => _progress = p);
      },
    );

    if (filePath == null) {
      setState(() => _state = UpdateCheckState.error);
      _showSnackBar('❌ İndirme başarısız.');
      return;
    }

    setState(() => _state = UpdateCheckState.installing);

    // APK'yı aç — Android kurulum ekranı açılır
    try {
      if (Platform.isAndroid) {
        final result = await OpenFilex.open(filePath, type: 'application/vnd.android.package-archive');
        if (result.type != ResultType.done) {
          _showSnackBar('⚠️ Kurulum açılamadı: ${result.message}');
        }
      } else {
        _showSnackBar('ℹ️ APK kurulumu sadece Android\'de çalışır.');
      }
    } catch (e) {
      _showSnackBar('❌ Kurulum hatası: $e');
    }

    setState(() => _state = UpdateCheckState.idle);
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Icon(_getIcon(), color: _getIconColor(theme)),
          title: const Text('Güncellemeleri Kontrol Et'),
          subtitle: Text(_getSubtitle()),
          trailing: _state == UpdateCheckState.checking
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.chevron_right),
          onTap: _state == UpdateCheckState.checking ||
                  _state == UpdateCheckState.downloading
              ? null
              : _checkForUpdates,
        ),
        // İndirme progress bar
        if (_state == UpdateCheckState.downloading)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: _progress,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
                const SizedBox(height: 4),
                Text(
                  'İndiriliyor... %${(_progress * 100).toInt()}',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
      ],
    );
  }

  IconData _getIcon() => switch (_state) {
        UpdateCheckState.idle => Icons.system_update,
        UpdateCheckState.checking => Icons.sync,
        UpdateCheckState.upToDate => Icons.check_circle,
        UpdateCheckState.updateAvailable => Icons.new_releases,
        UpdateCheckState.downloading => Icons.downloading,
        UpdateCheckState.installing => Icons.install_mobile,
        UpdateCheckState.error => Icons.error_outline,
      };

  Color? _getIconColor(ThemeData theme) => switch (_state) {
        UpdateCheckState.upToDate => Colors.green,
        UpdateCheckState.updateAvailable => Colors.orange,
        UpdateCheckState.downloading => theme.colorScheme.primary,
        UpdateCheckState.error => Colors.red,
        _ => null,
      };

  String _getSubtitle() => switch (_state) {
        UpdateCheckState.idle =>
          'Yeni güncelleme olup olmadığını kontrol et',
        UpdateCheckState.checking => 'Kontrol ediliyor...',
        UpdateCheckState.upToDate => 'Uygulamanız güncel ✓',
        UpdateCheckState.updateAvailable =>
          'v$_latestVersion mevcut — indirmek için tıklayın',
        UpdateCheckState.downloading => 'İndiriliyor...',
        UpdateCheckState.installing => 'Kuruluyor...',
        UpdateCheckState.error => 'Kontrol edilemedi, tekrar deneyin',
      };
}

enum UpdateCheckState {
  idle,
  checking,
  upToDate,
  updateAvailable,
  downloading,
  installing,
  error,
}
