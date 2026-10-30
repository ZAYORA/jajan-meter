import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../formatters.dart';
import '../jajan_theme.dart';
import '../widgets/budget_card.dart';
import '../widgets/jajan_choice_chips.dart';

/// Sarana uji komponen minggu 1–2. Tidak menjalankan repository atau CRUD.
class ComponentPreviewPage extends StatefulWidget {
  const ComponentPreviewPage({super.key});

  @override
  State<ComponentPreviewPage> createState() => _ComponentPreviewPageState();
}

class _ComponentPreviewPageState extends State<ComponentPreviewPage> {
  final _nominalController = TextEditingController();
  String? _category;
  String? _reason;
  int get _nominal => int.tryParse(_nominalController.text) ?? 0;

  @override
  void dispose() {
    _nominalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canSave = _nominal > 0 && _category != null;
    return Scaffold(
      appBar: AppBar(title: const Text('Pratinjau input')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const Text(
                'Uji nominal, kategori, dan alasan. Data di halaman ini tidak disimpan.',
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: JajanColors.paleBlue,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'NOMINAL JAJAN',
                      style: TextStyle(
                        color: JajanColors.blue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          formatRupiah(_nominal),
                          key: const ValueKey('formatted_amount'),
                          style: const TextStyle(
                            color: JajanColors.blue,
                            fontSize: 44,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
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
                  labelText: 'Nominal (angka saja)',
                  hintText: 'Contoh: 15000',
                  errorText: _nominalController.text.isNotEmpty && _nominal <= 0
                      ? 'Masukkan nominal lebih dari Rp0.'
                      : null,
                ),
              ),
              const SizedBox(height: 24),
              Text('Kategori', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              JajanChoiceChips(
                choices: jajanCategories,
                selectedValue: _category,
                onChanged: (value) => setState(() => _category = value),
              ),
              const SizedBox(height: 24),
              Text(
                'Kenapa jajan?',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Text(
                'Opsional. Ketuk pilihan aktif lagi untuk mengosongkan.',
              ),
              const SizedBox(height: 8),
              JajanChoiceChips(
                choices: jajanReasons,
                selectedValue: _reason,
                optional: true,
                useYellow: true,
                onChanged: (value) => setState(() => _reason = value),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                key: const ValueKey('preview_save'),
                onPressed: canSave
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Input valid. Ini pratinjau; belum ada transaksi tersimpan.',
                            ),
                          ),
                        );
                      }
                    : null,
                icon: const Icon(Icons.check),
                label: const Text('Simpan (pratinjau)'),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tombol aktif setelah nominal lebih dari nol dan kategori dipilih.',
              ),
              const SizedBox(height: 32),
              Text(
                'Contoh keadaan kartu',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              const BudgetCard(jatah: 50000, terpakai: 40000, sisa: 10000),
              const SizedBox(height: 16),
              const BudgetCard(jatah: 50000, terpakai: 60000, sisa: -10000),
              const SizedBox(height: 16),
              const BudgetCard(jatah: 0, terpakai: 0, sisa: 0),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
