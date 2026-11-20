import 'package:flutter/material.dart';

import '../formatters.dart';
import '../jajan_theme.dart';
import '../widgets/budget_card.dart';
import '../widgets/jajan_surface.dart';
import '../widgets/jajan_tile.dart';
import '../widgets/wallet_mascot.dart';

class HomePreviewPage extends StatelessWidget {
  const HomePreviewPage({
    super.key,
    this.nickname = 'Budi',
    required this.onAdd,
    required this.onHistory,
    required this.onTarget,
    required this.onSettings,
  });
  final String nickname;
  final VoidCallback onAdd;
  final VoidCallback onHistory;
  final VoidCallback onTarget;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final wide = constraints.maxWidth >= 720;
      final name = nickname.trim().isEmpty ? 'teman jajan' : nickname.trim();
      final transactions = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Jajan hari ini',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              TextButton(
                onPressed: onHistory,
                child: const Text('Lihat semua'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const PreviewTransactions(),
          const SizedBox(height: 16),
          JajanSurface(
            color: context.softBlue,
            child: Row(
              children: [
                const Icon(
                  Icons.receipt_long_outlined,
                  color: JajanColors.blue,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '3 transaksi hari ini',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        'Rp55.000',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
      final budget = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const BudgetCard(jatah: 100000, terpakai: 55000, sisa: 45000),
          const SizedBox(height: 16),
          if (wide)
            JajanActionButton(
              key: const ValueKey('open_components'),
              label: 'Tambah Jajan',
              icon: Icons.add,
              onPressed: onAdd,
            )
          else
            JajanSurface(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              onTap: onTarget,
              child: Row(
                children: [
                  const Icon(
                    Icons.account_balance_wallet_outlined,
                    color: JajanColors.green,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Target hemat',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Icon(Icons.chevron_right, color: context.mutedColor),
                ],
              ),
            ),
          const SizedBox(height: 16),
          transactions,
        ],
      );
      return SingleChildScrollView(
        key: const PageStorageKey('home_preview_scroll'),
        padding: EdgeInsets.all(wide ? 28 : 20),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Halo, $name!',
                            key: const ValueKey('greeting'),
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formatTanggal(
                              DateTime(2026, 11, 3),
                              denganHari: true,
                            ),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      key: const ValueKey('open_settings'),
                      tooltip: 'Pengaturan pratinjau',
                      onPressed: onSettings,
                      icon: const Icon(
                        Icons.tune_rounded,
                        color: JajanColors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (wide)
                  Row(
                    key: const ValueKey('home_two_columns'),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: budget),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            JajanSurface(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const WalletMascot(size: 100),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Jajan kecil,\nlangkah berarti.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge,
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Catat jajanmu dan kenali kebiasaanmu, satu hari demi satu hari.',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            JajanSurface(
                              onTap: onTarget,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.track_changes,
                                    color: JajanColors.green,
                                    size: 32,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Jaga jatah harian',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  const Text('Lihat target hematmu'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  budget,
                const SizedBox(height: 20),
                Text(
                  'Nominal dan tanggal adalah contoh desain.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class PreviewTransactions extends StatelessWidget {
  const PreviewTransactions({super.key});
  @override
  Widget build(BuildContext context) {
    void detail() => ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Ini data contoh. Detail dan CRUD disambungkan pada tahap berikutnya.',
        ),
      ),
    );
    return Column(
      children: [
        JajanTile(
          title: 'Nasi Ayam',
          nominal: 20000,
          kategori: 'makan',
          kategoriLabel: 'Makan',
          tanggal: DateTime(2026, 11, 3, 12, 15),
          onTap: detail,
        ),
        const SizedBox(height: 12),
        JajanTile(
          title: 'Kopi Susu',
          nominal: 25000,
          kategori: 'kopi',
          kategoriLabel: 'Kopi',
          tanggal: DateTime(2026, 11, 3, 10, 30),
          onTap: detail,
        ),
        const SizedBox(height: 12),
        JajanTile(
          title: 'Ojek ke Kampus',
          nominal: 10000,
          kategori: 'transport',
          kategoriLabel: 'Transport',
          tanggal: DateTime(2026, 11, 3, 7, 45),
          onTap: detail,
        ),
      ],
    );
  }
}
