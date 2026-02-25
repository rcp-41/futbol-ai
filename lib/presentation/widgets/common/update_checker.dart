import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/update_service.dart';

/// Güncelleme Kontrol Butonu — SPEC.md Bölüm 14.4
class UpdateCheckerButton extends ConsumerStatefulWidget {
  const UpdateCheckerButton({super.key});

  @override
  ConsumerState<UpdateCheckerButton> createState() =>
      _UpdateCheckerButtonState();
}

class _UpdateCheckerButtonState extends ConsumerState<UpdateCheckerButton> {
  UpdateCheckState _state = UpdateCheckState.idle;

  Future<void> _checkForUpdates() async {
    setState(() => _state = UpdateCheckState.checking);

    try {
      final updateService = ref.read(updateServiceProvider);
      final result = await updateService.checkAndUpdate();

      switch (result) {
        case UpdateResult.updated:
          setState(() => _state = UpdateCheckState.updateReady);
          _showRestartDialog();
        case UpdateResult.upToDate:
          setState(() => _state = UpdateCheckState.upToDate);
          _showSnackBar('✅ Uygulamanız güncel!');
        case UpdateResult.notAvailable:
          setState(() => _state = UpdateCheckState.idle);
          _showSnackBar('ℹ️ Güncelleme servisi kullanılamıyor.');
        case UpdateResult.error:
          setState(() => _state = UpdateCheckState.error);
          _showSnackBar('❌ Güncelleme kontrol edilemedi.');
      }
    } catch (e) {
      setState(() => _state = UpdateCheckState.error);
      _showSnackBar('❌ Bir hata oluştu: $e');
    }

    // 3 saniye sonra idle'a dön
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _state = UpdateCheckState.idle);
    });
  }

  void _showRestartDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('🎉 Güncelleme Hazır!'),
        content: const Text(
          'Yeni bir güncelleme indirildi. Değişikliklerin aktif olması için '
          'uygulamayı yeniden başlatmanız gerekiyor.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Sonra'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              SystemNavigator.pop();
            },
            child: const Text('Şimdi Yeniden Başlat'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(_getIcon()),
      title: const Text('Güncellemeleri Kontrol Et'),
      subtitle: Text(_getSubtitle()),
      trailing: _state == UpdateCheckState.checking
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.chevron_right),
      onTap: _state == UpdateCheckState.checking ? null : _checkForUpdates,
    );
  }

  IconData _getIcon() => switch (_state) {
        UpdateCheckState.idle => Icons.system_update,
        UpdateCheckState.checking => Icons.sync,
        UpdateCheckState.upToDate => Icons.check_circle,
        UpdateCheckState.updateReady => Icons.download_done,
        UpdateCheckState.error => Icons.error_outline,
      };

  String _getSubtitle() => switch (_state) {
        UpdateCheckState.idle =>
          'Yeni güncelleme olup olmadığını kontrol et',
        UpdateCheckState.checking => 'Kontrol ediliyor...',
        UpdateCheckState.upToDate => 'Uygulamanız güncel ✓',
        UpdateCheckState.updateReady =>
          'Güncelleme hazır — yeniden başlatın',
        UpdateCheckState.error => 'Kontrol edilemedi, tekrar deneyin',
      };
}

enum UpdateCheckState { idle, checking, upToDate, updateReady, error }
