import 'package:flutter/material.dart';

import '../formatters.dart';
import '../jajan_theme.dart';
import '../widgets/budget_card.dart';
import '../widgets/jajan_tile.dart';
import 'component_preview_page.dart';

class HomePreviewPage extends StatelessWidget {
  const HomePreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    void openComponents() {
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const ComponentPreviewPage()),
      );
    }

    void showSampleDetails(String title) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$title adalah data contoh untuk memeriksa baris transaksi.',
          ),
        ),
      );
    }

    return ListView(
      key: const PageStorageKey('home_preview_scroll'),
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                formatTanggal(DateTime(2026, 10, 14), denganHari: true),
                style: Theme.of(context).textTheme.bodyLarge
                    ?.copyWith(color: JajanColors.muted),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: JajanColors.yellow,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.account_balance_wallet_outlined),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Halo, anak jajan!',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 24),
        const BudgetCard(jatah: 50000, terpakai: 33000, sisa: 17000),
        const SizedBox(height: 20),
        FilledButton.icon(
          key: const ValueKey('open_components'),
          onPressed: openComponents,
          icon: const Icon(Icons.add),
          label: const Text('Tambah Jajan'),
        ),
        const SizedBox(height: 24),
        Text('Jajan hari ini', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        JajanTile(
          title: 'Kopi susu',
          nominal: 15000,
          kategori: 'kopi',
          kategoriLabel: 'Kopi/minum',
          alasanLabel: 'Stres',
          tanggal: DateTime(2026, 10, 14, 7, 30),
          onTap: () => showSampleDetails('Kopi susu'),
        ),
        const SizedBox(height: 8),
        JajanTile(
          title: 'Nasi goreng',
          nominal: 18000,
          kategori: 'makan',
          kategoriLabel: 'Makan berat',
          alasanLabel: 'Lapar',
          tanggal: DateTime(2026, 10, 14, 12),
          onTap: () => showSampleDetails('Nasi goreng'),
        ),
        const SizedBox(height: 20),
        const Text(
          'Nominal dan tanggal di atas adalah data contoh dari desain.',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
