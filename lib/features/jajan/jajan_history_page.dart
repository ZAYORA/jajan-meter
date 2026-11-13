import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/jajan.dart';
import '../../providers/jajan_provider.dart';
import '../../vaka_ui/formatters.dart';
import '../../vaka_ui/jajan_theme.dart';
import '../../vaka_ui/widgets/jajan_choice_chips.dart';
import '../../vaka_ui/widgets/jajan_surface.dart';
import '../../vaka_ui/widgets/wallet_mascot.dart';
import 'jajan_shared.dart';

class JajanHistoryPage extends StatelessWidget {
  const JajanHistoryPage({super.key, required this.onDetail});
  final ValueChanged<Jajan> onDetail;
  Future<void> _date(BuildContext context, JajanProvider p) async {
    final value = await showDatePicker(
      context: context,
      initialDate: p.tanggalFilter,
      firstDate: DateTime(1900),
      lastDate: DateTime(2200),
    );
    if (value != null && context.mounted) p.setFilter(tanggal: value);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<JajanProvider>();
    final items = p.transaksiTerfilter;
    final end = DateTime(
      p.akhirRentang.year,
      p.akhirRentang.month,
      p.akhirRentang.day - 1,
    );
    final range = p.periode == PeriodeJajan.hari
        ? formatTanggal(p.tanggalFilter)
        : '${formatTanggal(p.awalRentang)} – ${formatTanggal(end)}';
    return JajanPage(
      title: 'Riwayat Jajan',
      subtitle: 'Jejak kecil untuk kebiasaan besar.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, c) => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final period in PeriodeJajan.values)
                  ChoiceChip(
                    key: ValueKey('period_${period.name}'),
                    selected: p.periode == period,
                    label: Text(switch (period) {
                      PeriodeJajan.hari => 'Hari',
                      PeriodeJajan.minggu => 'Minggu',
                      PeriodeJajan.bulan => 'Bulan',
                    }),
                    selectedColor: JajanColors.blue,
                    showCheckmark: false,
                    onSelected: (_) => p.setFilter(periode: period),
                  ),
                OutlinedButton.icon(
                  key: const ValueKey('history_date'),
                  onPressed: () => _date(context, p),
                  icon: const Icon(Icons.calendar_month_outlined, size: 20),
                  label: Text(range),
                ),
                TextButton(
                  onPressed: () => p.setFilter(tanggal: p.hariIni),
                  child: const Text('Ke hari ini'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          JajanChoiceChips(
            choices: const [JajanChoice('semua', 'Semua'), ...jajanCategories],
            selectedValue: p.kategoriFilter ?? 'semua',
            onChanged: (value) =>
                p.setKategoriFilter(value == 'semua' ? null : value),
          ),
          const SizedBox(height: 24),
          if (!p.hasData)
            const DataWaiting()
          else ...[
            JajanSurface(
              color: context.softBlue,
              child: Row(
                children: [
                  const Icon(
                    Icons.receipt_long_rounded,
                    color: JajanColors.blue,
                    size: 40,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total sesuai filter'),
                        Text(
                          formatRupiah(p.totalTerfilter),
                          key: const ValueKey('history_total'),
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        Text(
                          '${items.length} transaksi',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, c) {
                final list = Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (items.isEmpty)
                      const EmptyJajan(
                        title: 'Belum ada transaksi',
                        message: 'Coba periode, tanggal, atau kategori lain.',
                      ),
                    for (var i = 0; i < items.length; i++) ...[
                      if (i == 0 ||
                          kunciHari(items[i].tanggal) !=
                              kunciHari(items[i - 1].tanggal))
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 16),
                          child: Text(
                            formatTanggal(items[i].tanggal, denganHari: true),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      TransactionTile(
                        value: items[i],
                        onTap: () => onDetail(items[i]),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ],
                );
                if (c.maxWidth < 720) return list;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: list),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 2,
                      child: JajanSurface(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const WalletMascot(size: 100),
                            const SizedBox(height: 16),
                            Text(
                              'Catat terus,\nkenali polamu.',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Pilih Minggu atau Bulan untuk melihat jajanmu dari waktu ke waktu. Ketuk transaksi untuk melihat detail.',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
