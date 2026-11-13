import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../providers/jajan_provider.dart';
import '../../vaka_ui/foundation/widgets/jm_button.dart';
import '../../vaka_ui/jajan_theme.dart';
import '../../vaka_ui/widgets/budget_card.dart';
import '../../vaka_ui/widgets/jajan_surface.dart';
import 'jajan_shared.dart';

/// Kontrol minimum untuk mencoba jatah/tema dari UserRepository.
/// Layar Target/Pengaturan lengkap tetap diserahkan ke Zara.
class JajanPreferencesPage extends StatelessWidget {
  const JajanPreferencesPage({
    super.key,
    this.targetOnly = false,
    this.onSignOut,
    required this.onBack,
  });
  final VoidCallback onBack;
  final bool targetOnly;
  final Future<void> Function()? onSignOut;
  @override
  Widget build(BuildContext context) {
    final p = context.watch<JajanProvider>();
    return JajanPage(
      title: targetOnly ? 'Target hemat' : 'Pengaturan',
      onBack: onBack,
      child: !p.hasProfile
          ? const DataWaiting()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!targetOnly) ...[
                  JajanSurface(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.namaPanggilan,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        const Text('Nama panggilan mengikuti profil akunmu.'),
                        SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Mode gelap'),
                          value: p.themeMode == ThemeMode.dark,
                          onChanged: p.isSaving
                              ? null
                              : (value) async {
                                  final ok = await p.setTema(value);
                                  if (!ok && context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          p.actionError ??
                                              'Tema belum tersimpan.',
                                        ),
                                      ),
                                    );
                                  }
                                },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                if (p.hasData) ...[
                  BudgetCard(
                    jatah: p.jatahHarian,
                    terpakai: p.totalHariIni,
                    sisa: p.sisaJatah,
                  ),
                  const SizedBox(height: 24),
                ],
                _BudgetEditor(initial: p.jatahHarian),
                if (onSignOut != null && !targetOnly) ...[
                  const SizedBox(height: 32),
                  JmButton(
                    label: 'Keluar',
                    icon: Icons.logout,
                    backgroundColor: JajanColors.danger,
                    onPressed: () async {
                      try {
                        await onSignOut!();
                      } catch (_) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Belum berhasil keluar. Coba lagi.',
                              ),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              ],
            ),
    );
  }
}

class _BudgetEditor extends StatefulWidget {
  const _BudgetEditor({required this.initial});
  final int initial;
  @override
  State<_BudgetEditor> createState() => _BudgetEditorState();
}

class _BudgetEditorState extends State<_BudgetEditor> {
  late final _controller = TextEditingController(
    text: widget.initial.toString(),
  );
  String? _message;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<JajanProvider>();
    return JajanSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Jatah harian', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          const Text(
            'Jatah berlaku untuk perhitungan hari ini. Nilai 0 berarti belum diatur.',
          ),
          const SizedBox(height: 16),
          TextField(
            key: const ValueKey('budget_input'),
            controller: _controller,
            enabled: !p.isSaving,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(12),
            ],
            decoration: const InputDecoration(
              labelText: 'Jatah per hari',
              prefixText: 'Rp ',
            ),
          ),
          const SizedBox(height: 16),
          JmButton(
            key: const ValueKey('save_budget'),
            label: 'Simpan jatah',
            isLoading: p.isSaving,
            onPressed: () async {
              final value = int.tryParse(_controller.text);
              if (value == null) {
                setState(() => _message = 'Isi jatah dalam rupiah.');
                return;
              }
              final ok = await p.setJatahHarian(value);
              if (mounted) {
                setState(
                  () => _message = ok
                      ? 'Jatah berhasil disimpan.'
                      : p.actionError,
                );
              }
            },
          ),
          if (_message != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(_message!),
            ),
        ],
      ),
    );
  }
}
