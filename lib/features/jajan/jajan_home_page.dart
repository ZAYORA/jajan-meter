import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/jajan.dart';
import '../../providers/jajan_provider.dart';
import '../../vaka_ui/formatters.dart';
import '../../vaka_ui/jajan_theme.dart';
import '../../vaka_ui/widgets/budget_card.dart';
import '../../vaka_ui/widgets/jajan_surface.dart';
import '../../vaka_ui/widgets/wallet_mascot.dart';
import 'jajan_shared.dart';

class JajanHomePage extends StatelessWidget {
  const JajanHomePage({
    super.key,
    required this.onAdd,
    required this.onDetail,
    required this.onHistory,
    required this.onTarget,
    required this.onSettings,
  });
  final VoidCallback onAdd, onHistory, onTarget, onSettings;
  final ValueChanged<Jajan> onDetail;
  @override
  Widget build(BuildContext context) {
    final p = context.watch<JajanProvider>();
    final hour = p.sekarang.hour;
    final sapaan = hour < 11
        ? 'Selamat pagi'
        : hour < 15
        ? 'Selamat siang'
        : hour < 18
        ? 'Selamat sore'
        : 'Selamat malam';
    return JajanPage(
      title: 'Halo, ${p.namaPanggilan}!',
      subtitle: '$sapaan · ${formatTanggal(p.hariIni, denganHari: true)}',
      actions: [
        IconButton(
          key: const ValueKey('open_settings'),
          tooltip: 'Pengaturan',
          onPressed: onSettings,
          icon: const Icon(Icons.tune, color: JajanColors.blue),
        ),
      ],
      child: !p.hasData || !p.hasProfile
          ? const DataWaiting()
          : LayoutBuilder(
              builder: (context, c) {
                final wide = c.maxWidth >= 720;
                final budget = Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    BudgetCard(
                      jatah: p.jatahHarian,
                      terpakai: p.totalHariIni,
                      sisa: p.sisaJatah,
                      onAturJatah: onTarget,
                    ),
                    const SizedBox(height: 18),
                    JajanActionButton(
                      key: const ValueKey('add_jajan'),
                      label: 'Tambah Jajan',
                      icon: Icons.add,
                      onPressed: onAdd,
                    ),
                    const SizedBox(height: 18),
                    JajanSurface(
                      onTap: onTarget,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.track_changes_outlined,
                            color: JajanColors.green,
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Target hemat',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Text(
                            p.statusTarget,
                            style: const TextStyle(fontSize: 12),
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
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
                    if (p.jajanHariIni.isEmpty)
                      const EmptyJajan(
                        title: 'Belum ada jajan hari ini',
                        message:
                            'Catat pengeluaran pertamamu lewat Tambah Jajan.',
                      )
                    else
                      ...p.jajanHariIni
                          .take(5)
                          .map(
                            (j) => Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: TransactionTile(
                                value: j,
                                onTap: () => onDetail(j),
                              ),
                            ),
                          ),
                    const SizedBox(height: 8),
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
                                  '${p.jajanHariIni.length} transaksi hari ini',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Text(
                                  formatRupiah(p.totalHariIni),
                                  key: const ValueKey('home_total'),
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
                if (!wide) return budget;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: budget),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 2,
                      child: JajanSurface(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const WalletMascot(size: 120),
                            const SizedBox(height: 20),
                            Text(
                              'Jajan kecil,\nlangkah berarti.',
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Catat jajanmu dan kenali kebiasaanmu, satu hari demi satu hari.',
                            ),
                            const SizedBox(height: 24),
                            Text(
                              p.hasBudget
                                  ? '${p.persenSisa.round()}% jatah tersisa hari ini.'
                                  : 'Mulai dengan menetapkan jatah harian.',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
