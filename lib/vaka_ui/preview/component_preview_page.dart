import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../formatters.dart';
import '../jajan_theme.dart';
import '../widgets/jajan_choice_chips.dart';
import '../widgets/jajan_surface.dart';

/// Sarana uji komponen. Tidak menjalankan repository atau CRUD.
class ComponentPreviewPage extends StatefulWidget {
  const ComponentPreviewPage({super.key, this.onBack});
  final VoidCallback? onBack;
  @override
  State<ComponentPreviewPage> createState() => _ComponentPreviewPageState();
}

class _ComponentPreviewPageState extends State<ComponentPreviewPage> {
  final _nominalController = TextEditingController();
  final _noteController = TextEditingController();
  String? _category;
  String? _reason;
  int get _nominal => int.tryParse(_nominalController.text) ?? 0;
  @override
  void dispose() {
    _nominalController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _keypad(String value) {
    final old = _nominalController.text;
    final next = value == '⌫'
        ? (old.isEmpty ? '' : old.substring(0, old.length - 1))
        : old == '0'
        ? value
        : old + value;
    if (next.length <= 12) {
      setState(() {
        _nominalController.value = TextEditingValue(
          text: next,
          selection: TextSelection.collapsed(offset: next.length),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final canSave = _nominal > 0 && _category != null && _reason != null;
    return Scaffold(
      appBar: AppBar(
        leading: widget.onBack == null
            ? null
            : IconButton(
                tooltip: 'Kembali',
                onPressed: widget.onBack,
                icon: const Icon(Icons.arrow_back),
              ),
        title: const Text('Tambah Jajan'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 720;
          final amount = JajanSurface(
            child: Column(
              children: [
                Text(
                  'Berapa jajanmu?',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    formatRupiah(_nominal),
                    key: const ValueKey('formatted_amount'),
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                      color: context.inkColor,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  key: const ValueKey('nominal_input'),
                  controller: _nominalController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(12),
                  ],
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: 'Nominal',
                    prefixText: 'Rp ',
                    hintText: '0',
                    errorText:
                        _nominalController.text.isNotEmpty && _nominal <= 0
                        ? 'Nominal harus lebih dari Rp0.'
                        : null,
                  ),
                ),
                if (wide) ...[
                  const SizedBox(height: 20),
                  LayoutBuilder(
                    builder: (context, c) => Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          [
                                '1',
                                '2',
                                '3',
                                '4',
                                '5',
                                '6',
                                '7',
                                '8',
                                '9',
                                '00',
                                '0',
                                '⌫',
                              ]
                              .map(
                                (value) => SizedBox(
                                  width: (c.maxWidth - 16) / 3,
                                  child: OutlinedButton(
                                    key: ValueKey('keypad_$value'),
                                    onPressed: () => _keypad(value),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: value == '⌫'
                                        ? const Icon(
                                            Icons.backspace_outlined,
                                            semanticLabel: 'Hapus satu digit',
                                            size: 20,
                                          )
                                        : Text(value),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ],
              ],
            ),
          );
          final inputs = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Pilih kategori',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              JajanCategoryGrid(
                selectedValue: _category,
                onChanged: (value) => setState(() => _category = value),
              ),
              const SizedBox(height: 28),
              Text(
                'Alasan jajan',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              const Text('Pilih alasan yang paling sesuai.'),
              const SizedBox(height: 12),
              JajanChoiceChips(
                choices: jajanReasons,
                selectedValue: _reason,
                useYellow: true,
                onChanged: (value) => setState(() => _reason = value),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _noteController,
                maxLength: 150,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Catatan (opsional)',
                  hintText: 'Misalnya: kopi sebelum kelas',
                  prefixIcon: Icon(Icons.edit_note),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Contoh waktu: 3 Nov 2026 · 10.30',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 24),
              JajanActionButton(
                key: const ValueKey('preview_save'),
                label: 'Simpan Jajan!',
                icon: Icons.check,
                onPressed: canSave
                    ? () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Input valid. Ini pratinjau; belum ada transaksi tersimpan.',
                          ),
                        ),
                      )
                    : null,
              ),
              const SizedBox(height: 12),
              Text(
                'Pratinjau: isi nominal, kategori, dan alasan untuk menguji tombol.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          );
          return SingleChildScrollView(
            key: const PageStorageKey('component_scroll'),
            padding: const EdgeInsets.all(24),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Catat sekarang, tenang kemudian.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 24),
                    if (wide)
                      Row(
                        key: const ValueKey('form_two_columns'),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: amount),
                          const SizedBox(width: 24),
                          Expanded(child: inputs),
                        ],
                      )
                    else
                      Column(
                        children: [amount, const SizedBox(height: 24), inputs],
                      ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
