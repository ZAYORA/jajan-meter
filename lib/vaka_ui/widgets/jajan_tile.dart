import 'package:flutter/material.dart';

import '../formatters.dart';
import '../foundation/widgets/jm_transaction_tile.dart';
import 'jajan_choice_chips.dart';

/// Adapter transaksi bertipe ke komponen foundation yang sama.
class JajanTile extends StatelessWidget {
  const JajanTile({
    super.key,
    required this.title,
    required this.nominal,
    required this.kategori,
    required this.kategoriLabel,
    required this.tanggal,
    this.alasanLabel,
    this.onTap,
  });
  final String title;
  final int nominal;
  final String kategori;
  final String kategoriLabel;
  final DateTime tanggal;
  final String? alasanLabel;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => JmTransactionTile(
    title: title,
    amount: formatRupiah(-nominal.abs()),
    icon: jajanCategoryIcon(kategori),
    accentColor: jajanCategoryColor(kategori),
    onTap: onTap,
    subtitle: [
      kategoriLabel,
      if (alasanLabel != null && alasanLabel!.trim().isNotEmpty) alasanLabel!,
      formatJam(tanggal),
    ].join(' · '),
  );
}
