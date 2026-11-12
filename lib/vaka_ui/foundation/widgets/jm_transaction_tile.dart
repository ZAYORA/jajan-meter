import 'package:flutter/material.dart';

import '../theme/jajan_colors.dart';
import 'jm_card.dart';

/// Baris transaksi presentasional. Tidak mengubah model atau repository Zara.
class JmTransactionTile extends StatelessWidget {
  const JmTransactionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    this.icon = Icons.receipt_long_rounded,
    this.isExpense = true,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String amount;
  final IconData icon;
  final bool isExpense;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final amountColor = isExpense ? JajanColors.red : JajanColors.green;

    return JmCard(
      padding: EdgeInsets.zero,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: JajanColors.blue.withValues(alpha: isDark ? 0.20 : 0.10),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: JajanColors.blue),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Text(
          amount,
          style: TextStyle(
            color: amountColor,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
