import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/jajan_provider.dart';
import '../vaka_ui/jajan_theme.dart';
import '../vaka_ui/widgets/jajan_surface.dart';
import 'jajan_shared.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
    required this.onTarget,
    this.onSignOut,
    this.onBack,
  });

  final VoidCallback onTarget;
  final Future<void> Function()? onSignOut;
  final VoidCallback? onBack;

  String _ambilEmail() {
    try {
      return FirebaseAuth.instance.currentUser?.email ?? 'Email tidak tersedia';
    } catch (_) {
      return 'Email tidak tersedia';
    }
  }

  Future<void> _editNama(BuildContext context, String namaLama) async {
    final controller = TextEditingController(
      text: namaLama == 'teman jajan' ? '' : namaLama,
    );

    final String? hasil;
    try {
      hasil = await showDialog<String>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Edit nama panggilan'),
          content: TextField(
            controller: controller,
            maxLength: 30,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Nama panggilan',
              hintText: 'Masukkan nama panggilan',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, controller.text.trim());
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      );
    } finally {
      controller.dispose();
    }

    if (hasil == null || !context.mounted) return;

    final provider = context.read<JajanProvider>();

    if (hasil.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama panggilan tidak boleh kosong.')),
      );
      return;
    }

    final berhasil = await provider.setNamaPanggilan(hasil);

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          berhasil
              ? 'Nama panggilan berhasil diperbarui.'
              : provider.actionError ?? 'Nama gagal diperbarui.',
        ),
      ),
    );
  }

  Future<void> _konfirmasiLogout(BuildContext context) async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Keluar dari akun?'),
        content: const Text(
          'Kamu harus login kembali untuk menggunakan Jajan Meter.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (yakin == true && context.mounted && onSignOut != null) {
      try {
        await onSignOut!();
      } catch (_) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Belum berhasil keluar. Coba lagi.')),
        );
      }
    }
  }

  void _bantuan(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Bantuan Jajan Meter'),
        content: const Text(
          'Jajan Meter membantu kamu mencatat pengeluaran jajan, '
          'memantau penggunaan uang harian, dan mengatur target hemat.\n\n'
          'Gunakan menu Tambah Jajan untuk mencatat pengeluaran dan '
          'menu Target Hemat untuk mengatur jatah harian.',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Mengerti'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<JajanProvider>();

    final nama = provider.namaPanggilan;
    final email = _ambilEmail();
    final warna = Theme.of(context).colorScheme;

    return JajanPage(
      title: 'Profil Saya',
      subtitle: 'Kelola informasi dan akun Jajan Meter.',
      onBack: onBack,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),

          JajanSurface(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 42,
                  backgroundColor: warna.primaryContainer,
                  child: Icon(
                    Icons.person_rounded,
                    size: 48,
                    color: warna.primary,
                  ),
                ),
                const SizedBox(height: 14),
                Text(nama, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 5),
                Text(
                  email,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => _editNama(context, nama),
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Edit nama panggilan'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Text('Preferensi', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),

          Card(
            child: SwitchListTile.adaptive(
              secondary: const Icon(Icons.dark_mode_outlined),
              title: const Text('Mode gelap'),
              subtitle: const Text('Sesuaikan tampilan aplikasi'),
              value: provider.themeMode == ThemeMode.dark,
              onChanged: provider.isSaving
                  ? null
                  : (value) async {
                      final berhasil = await provider.setTema(value);

                      if (!berhasil && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              provider.actionError ?? 'Tema gagal disimpan.',
                            ),
                          ),
                        );
                      }
                    },
            ),
          ),

          const SizedBox(height: 24),

          Text('Lainnya', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),

          Card(
            child: ListTile(
              leading: const Icon(Icons.track_changes_outlined),
              title: const Text('Target Hemat'),
              subtitle: const Text('Atur dan pantau jatah harianmu'),
              trailing: const Icon(Icons.chevron_right),
              onTap: onTarget,
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Bantuan'),
              subtitle: const Text('Informasi penggunaan Jajan Meter'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _bantuan(context),
            ),
          ),

          const SizedBox(height: 28),

          OutlinedButton.icon(
            onPressed: onSignOut == null
                ? null
                : () => _konfirmasiLogout(context),
            icon: const Icon(Icons.logout),
            label: const Text('Keluar dari akun'),
            style: OutlinedButton.styleFrom(
              foregroundColor: JajanColors.danger,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}
