import 'package:flutter/material.dart';

import '../formatters.dart';
import '../jajan_theme.dart';
import 'wallet_mascot.dart';

/// Nilai berasal dari pemanggil. Progress selalu SISA jatah, bukan terpakai.
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
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: JajanColors.blue,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(color: Color(0xFF148CC3), offset: Offset(0, 6)),
        ],
      ),
      child: DefaultTextStyle(
        style: const TextStyle(
          fontFamily: 'Poppins',
          color: Colors.white,
          fontSize: 12,
          height: 1.4,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Sisa jatah', style: TextStyle(fontSize: 14)),
                      const SizedBox(height: 4),
                      if (hasBudget)
                        Semantics(
                          label: 'Sisa jatah ${formatRupiah(sisa)}',
                          child: ExcludeSemantics(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                formatRupiah(sisa),
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        )
                      else
                        const Text(
                          'Atur jatah dulu',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const WalletMascot(size: 70),
              ],
            ),
            const SizedBox(height: 20),
            Semantics(
              label: 'Persentase sisa jatah',
              value: '$percent persen',
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: fraction,
                      minHeight: 18,
                      color: overBudget
                          ? JajanColors.danger
                          : JajanColors.green,
                      backgroundColor: const Color(0xFFE5EDF2),
                    ),
                  ),
                  Positioned(
                    left: 4,
                    right: 4,
                    top: 3,
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: fraction,
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 4,
              children: [
                Text('Terpakai ${formatRupiah(terpakai)}'),
                Text('Jatah ${formatRupiah(jatah)}'),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              !hasBudget
                  ? 'Tentukan jatah harianmu.'
                  : overBudget
                  ? 'Terlampaui'
                  : '$percent% lagi',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            if (lowBudget) const Text('Sisa jatah tinggal 20% atau kurang.'),
            if (overBudget) const Text('Pengeluaran sudah melebihi jatah.'),
            if (!hasBudget && onAturJatah != null)
              TextButton(
                onPressed: onAturJatah,
                style: TextButton.styleFrom(
                  foregroundColor: JajanColors.ink,
                  backgroundColor: JajanColors.yellow,
                ),
                child: const Text('Atur jatah'),
              ),
          ],
        ),
      ),
    );
  }
}
