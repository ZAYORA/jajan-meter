import 'package:flutter/material.dart';

import 'vaka_ui/foundation/theme/jajan_colors.dart';
import 'vaka_ui/foundation/theme/jajan_theme.dart';
import 'vaka_ui/foundation/widgets/jm_button.dart';
import 'vaka_ui/foundation/widgets/jm_card.dart';
import 'vaka_ui/foundation/widgets/jm_category_chip.dart';
import 'vaka_ui/foundation/widgets/jm_text_field.dart';
import 'vaka_ui/foundation/widgets/jm_transaction_tile.dart';

void main() {
  runApp(const JajanUiKitPreviewApp());
}

class JajanUiKitPreviewApp extends StatefulWidget {
  const JajanUiKitPreviewApp({super.key});

  @override
  State<JajanUiKitPreviewApp> createState() => _JajanUiKitPreviewAppState();
}

class _JajanUiKitPreviewAppState extends State<JajanUiKitPreviewApp> {
  ThemeMode _themeMode = ThemeMode.light;
  String _selectedCategory = 'Makan berat';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jajan Meter UI Kit Preview',
      debugShowCheckedModeBanner: false,
      theme: JajanTheme.light(),
      darkTheme: JajanTheme.dark(),
      themeMode: _themeMode,
      home: Builder(
        builder: (context) {
          final textColor = Theme.of(context).colorScheme.onSurface;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Jajan Meter · UI Kit'),
              actions: [
                const Text('Gelap'),
                Switch(
                  value: _themeMode == ThemeMode.dark,
                  onChanged: (value) {
                    setState(() {
                      _themeMode = value ? ThemeMode.dark : ThemeMode.light;
                    });
                  },
                ),
                const SizedBox(width: 12),
              ],
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                final maxWidth = constraints.maxWidth >= 900 ? 1000.0 : 680.0;

                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        Text(
                          'Fondasi Visual Jajan Meter',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Pratinjau warna, tipografi, tombol, kartu, input, dan kategori.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 22),
                        Text(
                          'Palet warna',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: const [
                            _ColorSwatch(label: 'Biru', color: JajanColors.blue),
                            _ColorSwatch(label: 'Hijau', color: JajanColors.green),
                            _ColorSwatch(label: 'Emas', color: JajanColors.gold),
                            _ColorSwatch(label: 'Merah', color: JajanColors.red),
                          ],
                        ),
                        const SizedBox(height: 22),
                        Text(
                          'Tombol',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            JmButton(
                              label: 'Simpan Jajan',
                              icon: Icons.check_rounded,
                              onPressed: () {},
                            ),
                            JmButton(
                              label: 'Daftar',
                              backgroundColor: JajanColors.blue,
                              onPressed: () {},
                            ),
                            JmButton(
                              label: 'Hapus',
                              backgroundColor: JajanColors.red,
                              onPressed: () {},
                            ),
                            JmButton(
                              label: 'Lanjut',
                              outlined: true,
                              onPressed: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        Text(
                          'Kartu dan input',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 12),
                        JmCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Jajan cerdas!',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Catat jajan, jaga jatah, dan kumpulkan lencana.',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 16),
                              const JmTextField(
                                label: 'Alasan',
                                hint: 'Contoh: Makan siang bersama teman',
                                prefixIcon: Icons.edit_note_rounded,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 22),
                        Text(
                          'Empat kategori',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 9,
                          runSpacing: 9,
                          children: [
                            for (final category in const [
                              'Makan berat',
                              'Kopi/minum',
                              'Camilan',
                              'Transport',
                            ])
                              JmCategoryChip(
                                label: category,
                                selected: _selectedCategory == category,
                                onTap: () {
                                  setState(() {
                                    _selectedCategory = category;
                                  });
                                },
                              ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        Text(
                          'Contoh transaksi',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 12),
                        const JmTransactionTile(
                          title: 'Kopi Susu',
                          subtitle: 'Kopi/minum · 10.30',
                          amount: '-Rp25.000',
                          icon: Icons.coffee_rounded,
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Mode: ${_themeMode == ThemeMode.dark ? 'Gelap' : 'Terang'}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: textColor),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 112,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 34,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(9),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
