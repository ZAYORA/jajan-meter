import 'package:flutter/material.dart';

import '../theme/jajan_colors.dart';
import 'jm_card.dart';

/// Baris transaksi presentasional, adaptif untuk nominal panjang/teks besar.
class JmTransactionTile extends StatelessWidget {
  const JmTransactionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    this.icon = Icons.receipt_long_rounded,
    this.isExpense = true,
    this.onTap,
    this.accentColor = JajanColors.blue,
  });
  final String title;
  final String subtitle;
  final String amount;
  final IconData icon;
  final bool isExpense;
  final VoidCallback? onTap;
  final Color accentColor;
  @override
  Widget build(BuildContext context) => JmCard(
    padding: const EdgeInsets.all(12),
    onTap: onTap,
    child: Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: .14),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: accentColor, size: 28),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final stacked =
                  constraints.maxWidth < 210 ||
                  MediaQuery.textScalerOf(context).scale(14) > 19 ||
                  amount.length > 13;
              final heading = Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              );
              final nominal = Text(
                amount,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isExpense ? JajanColors.red : JajanColors.green,
                ),
              );
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (stacked) ...[
                    heading,
                    const SizedBox(height: 4),
                    nominal,
                  ] else
                    Row(
                      children: [
                        Expanded(child: heading),
                        const SizedBox(width: 8),
                        nominal,
                      ],
                    ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
              );
            },
          ),
        ),
      ],
    ),
  );
}
