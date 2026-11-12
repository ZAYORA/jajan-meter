import 'package:flutter/material.dart';

import '../jajan_theme.dart';
import '../navigation/jajan_adaptive_shell.dart';
import '../navigation/jajan_destinations.dart';
import '../widgets/jajan_surface.dart';
import '../widgets/social_sign_in_buttons.dart';
import 'home_preview_page.dart';
import 'component_preview_page.dart';

class VakaPreviewApp extends StatefulWidget {
  const VakaPreviewApp({super.key, this.initialThemeMode = ThemeMode.light});
  final ThemeMode initialThemeMode;
  @override
  State<VakaPreviewApp> createState() => _VakaPreviewAppState();
}

class _VakaPreviewAppState extends State<VakaPreviewApp> {
  late ThemeMode _mode = widget.initialThemeMode;
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Jajan Meter — Pratinjau tahap 1–3',
    debugShowCheckedModeBanner: false,
    theme: buildJajanTheme(),
    darkTheme: buildJajanTheme(brightness: Brightness.dark),
    themeMode: _mode,
    home: VakaPreviewShell(
      onThemeChanged: (dark) =>
          setState(() => _mode = dark ? ThemeMode.dark : ThemeMode.light),
    ),
  );
}

/// State hanya untuk demonstrasi layout. Tidak menulis data pengguna.
class VakaPreviewShell extends StatefulWidget {
  const VakaPreviewShell({super.key, this.onThemeChanged});
  final ValueChanged<bool>? onThemeChanged;
  @override
  State<VakaPreviewShell> createState() => _VakaPreviewShellState();
}

class _VakaPreviewShellState extends State<VakaPreviewShell> {
  int _index = 0;
  bool _form = false;
  String _nickname = 'Budi';
  void _select(int value) => setState(() {
    _index = value;
    _form = false;
  });
  void _openForm() => setState(() => _form = true);
  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return JajanAdaptiveShell(
      selectedIndex: _index,
      onSelected: _select,
      nickname: _nickname,
      showMobileNavigation: !_form && _index < 4,
      floatingActionButton: !_form && _index == 0
          ? FloatingActionButton(
              key: const ValueKey('open_components'),
              tooltip: 'Tambah Jajan (pratinjau)',
              backgroundColor: JajanColors.green,
              foregroundColor: Colors.white,
              shape: const CircleBorder(),
              onPressed: _openForm,
              child: const Icon(Icons.add, size: 32),
            )
          : null,
      child: Column(
        children: [
          Container(
            color: context.softBlue,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'PRATINJAU UI · DATA CONTOH',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                  ),
                ),
                Icon(
                  dark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                  size: 18,
                  color: context.mutedColor,
                ),
                Semantics(
                  label: 'Mode gelap pratinjau',
                  child: Switch(
                    key: const ValueKey('preview_theme'),
                    value: dark,
                    onChanged: widget.onThemeChanged,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _form
                ? ComponentPreviewPage(
                    onBack: () => setState(() => _form = false),
                  )
                : IndexedStack(
                    index: _index,
                    children: [
                      HomePreviewPage(
                        nickname: _nickname,
                        onAdd: _openForm,
                        onHistory: () => _select(1),
                        onTarget: () => _select(4),
                        onSettings: () => _select(5),
                      ),
                      const _DestinationPreview(index: 1),
                      const _DestinationPreview(index: 2),
                      const _DestinationPreview(index: 3),
                      _DestinationPreview(index: 4, onBack: () => _select(0)),
                      _SettingsPreview(
                        nickname: _nickname,
                        onNicknameChanged: (value) =>
                            setState(() => _nickname = value),
                        onBack: () => _select(0),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _DestinationPreview extends StatelessWidget {
  const _DestinationPreview({required this.index, this.onBack});
  final int index;
  final VoidCallback? onBack;
  @override
  Widget build(BuildContext context) {
    final item = jajanDestinations[index];
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        if (onBack != null)
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              tooltip: 'Kembali ke Beranda',
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back),
            ),
          ),
        Text(item.label, style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 24),
        JajanSurface(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(item.icon, size: 40, color: JajanColors.blue),
              const SizedBox(height: 16),
              Text(
                'Ruang untuk ${item.label.toLowerCase()}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              const Text(
                'Kerangka navigasi siap. Isi dan data halaman ini disambungkan pada tahap berikutnya.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsPreview extends StatelessWidget {
  const _SettingsPreview({
    required this.nickname,
    required this.onNicknameChanged,
    required this.onBack,
  });
  final String nickname;
  final ValueChanged<String> onNicknameChanged;
  final VoidCallback onBack;
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(24),
    children: [
      Align(
        alignment: Alignment.centerLeft,
        child: IconButton(
          tooltip: 'Kembali ke Beranda',
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      Text(
        'Pengaturan pratinjau',
        style: Theme.of(context).textTheme.headlineLarge,
      ),
      const SizedBox(height: 24),
      JajanSurface(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              key: const ValueKey('nickname_input'),
              initialValue: nickname,
              maxLength: 30,
              textCapitalization: TextCapitalization.words,
              onChanged: onNicknameChanged,
              decoration: const InputDecoration(
                labelText: 'Nama panggilan contoh',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Nama ini hanya untuk mencoba sapaan. Belum disimpan ke akun.',
            ),
          ],
        ),
      ),
      const SizedBox(height: 24),
      JajanSurface(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Komponen login sosial',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            const SocialSignInButtons(),
            const SizedBox(height: 12),
            const Text(
              'Google, Apple, dan Facebook belum tersedia. Layanan autentikasi akan disambungkan bersama Zara.',
            ),
          ],
        ),
      ),
    ],
  );
}
