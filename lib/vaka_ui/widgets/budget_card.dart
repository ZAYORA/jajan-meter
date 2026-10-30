import 'package:flutter/material.dart';

import '../formatters.dart';
import '../jajan_theme.dart';

/// Komponen tampilan. Nilai total/sisa kelak diberikan oleh JajanProvider.
/// Bar kuning menunjukkan SISA jatah, mengikuti desain, bukan persen terpakai.
class BudgetCard extends StatelessWidget {
  const BudgetCard({
    super.key,
    required this.jatah,
    required this.terpakai,
    required this.sisa,
    this.onAturJatah,
  });

  final int jatah;
  final int terpakai;
  final int sisa;
  final VoidCallback? onAturJatah;

  @override
  Widget build(BuildContext context) {
    final hasBudget = jatah > 0;
    final overBudget = hasBudget && sisa < 0;
    final lowBudget = hasBudget && !overBudget && sisa <= jatah * .2;
    final fraction = hasBudget ? (sisa / jatah).clamp(0.0, 1.0) : 0.0;
    final percent = (fraction * 100).round();
    final message = !hasBudget
        ? 'Tentukan jatah agar sisa uang jajan dapat ditampilkan.'
        : overBudget
        ? 'Pengeluaran sudah melebihi jatah.'
        : lowBudget
        ? 'Sisa jatah tinggal 20% atau kurang.'
        : 'Masih aman. Tetap jajan secukupnya, ya!';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: JajanColors.blue,
        borderRadius: BorderRadius.circular(28),
      ),
      child: DefaultTextStyle(
        style: const TextStyle(
          fontFamily: 'Inter',
          color: Colors.white,
          fontSize: 15,
          height: 1.4,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 12,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text('Sisa jajan hari ini'),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: JajanColors.yellow,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      !hasBudget
                          ? 'Belum diatur'
                          : overBudget
                          ? 'Terlampaui'
                          : '$percent% lagi',
                      style: const TextStyle(
                        color: JajanColors.ink,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (hasBudget)
              Semantics(
                label: 'Sisa jatah ${formatRupiah(sisa)}',
                child: ExcludeSemantics(
                  child: SizedBox(
                    width: double.infinity,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        formatRupiah(sisa),
                        style: const TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.w800,
                          height: 1.12,
                          letterSpacing: -2,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            else
              const Text(
                'Atur jatah dulu',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
              ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LinearProgressIndicator(
                value: fraction,
                minHeight: 10,
                color: overBudget ? JajanColors.orange : JajanColors.yellow,
                backgroundColor: Colors.black.withValues(alpha: .10),
                semanticsLabel: hasBudget
                    ? 'Persentase sisa jatah'
                    : 'Jatah belum diatur',
                semanticsValue: '$percent',
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Terpakai ${formatRupiah(terpakai)} dari ${formatRupiah(jatah)}',
            ),
            const SizedBox(height: 12),
            Text(message),
            if (!hasBudget && onAturJatah != null) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: onAturJatah,
                style: TextButton.styleFrom(
                  foregroundColor: JajanColors.ink,
                  backgroundColor: JajanColors.yellow,
                ),
                child: const Text('Atur jatah'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
