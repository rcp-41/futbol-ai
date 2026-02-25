import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../providers/theme_provider.dart';
import '../widgets/common/update_checker.dart';

/// Ayarlar sayfası — SPEC.md Bölüm 14.6 wireframe
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('⚙️ Ayarlar'),
      ),
      body: ListView(
        children: [
          // ── Uygulama ──
          _sectionHeader(theme, 'Uygulama'),
          ListTile(
            leading: const Icon(Icons.palette_rounded),
            title: const Text('Tema'),
            trailing: Text(
              themeMode == ThemeMode.dark ? 'Koyu' : 'Açık',
              style: theme.textTheme.bodyMedium,
            ),
            onTap: () => ref.read(themeProvider.notifier).toggle(),
          ),
          ListTile(
            leading: const Icon(Icons.language_rounded),
            title: const Text('Dil'),
            trailing: Text('Türkçe', style: theme.textTheme.bodyMedium),
          ),
          ListTile(
            leading: const Icon(Icons.notifications_rounded),
            title: const Text('Bildirimler'),
            trailing: Switch(
              value: true,
              onChanged: (_) {},
            ),
          ),
          const Divider(),

          // ── Güncelleme ──
          _sectionHeader(theme, 'Güncelleme'),

          // Shorebird güncelleme kontrolü
          const UpdateCheckerButton(),

          // Versiyon bilgileri
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              final info = snapshot.data;
              return ListTile(
                leading: const Icon(Icons.info_outline_rounded),
                title: const Text('Uygulama Versiyonu'),
                trailing: Text(
                  info != null
                      ? 'v${info.version}+${info.buildNumber}'
                      : '...',
                  style: theme.textTheme.bodyMedium,
                ),
              );
            },
          ),
          const Divider(),

          // ── Hakkında ──
          _sectionHeader(theme, 'Hakkında'),
          const ListTile(
            leading: Icon(Icons.description_rounded),
            title: Text('Gizlilik Politikası'),
            trailing: Icon(Icons.chevron_right),
          ),
          const ListTile(
            leading: Icon(Icons.article_rounded),
            title: Text('Kullanım Koşulları'),
            trailing: Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
