import 'package:flutter/material.dart';

import '../formatters.dart';
import '../jajan_theme.dart';

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
  Widget build(BuildContext context) {
    final icon = switch (kategori) {
      'makan' => Icons.restaurant_outlined,
      'kopi' => Icons.local_cafe_outlined,
      'camilan' => Icons.cookie_outlined,
      'transport' => Icons.directions_bus_outlined,
      _ => Icons.shopping_bag_outlined,
    };
    final subtitle = [
      kategoriLabel,
      if (alasanLabel != null && alasanLabel!.trim().isNotEmpty) alasanLabel!,
      formatJam(tanggal),
    ].join(' · ');
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 48,
                decoration: BoxDecoration(
                  color: kategori == 'makan'
                      ? JajanColors.paleOrange
                      : JajanColors.paleBlue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: JajanColors.blue, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final stacked =
                        constraints.maxWidth < 220 ||
                        MediaQuery.textScalerOf(context).scale(15) > 19 ||
                        formatRupiah(nominal).length > 12;
                    final titleWidget = Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: JajanColors.ink,
                      ),
                    );
                    final amountWidget = Text(
                      formatRupiah(nominal),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: JajanColors.ink,
                      ),
                    );
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (stacked) ...[
                          titleWidget,
                          const SizedBox(height: 3),
                          amountWidget,
                        ] else
                          Row(
                            children: [
                              Expanded(child: titleWidget),
                              const SizedBox(width: 12),
                              amountWidget,
                            ],
                          ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
