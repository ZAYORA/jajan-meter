import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/jajan.dart';
import '../../providers/jajan_category.dart';
import '../../providers/jajan_provider.dart';
import '../../vaka_ui/jajan_theme.dart';
import '../../vaka_ui/widgets/jajan_surface.dart';
import '../../vaka_ui/widgets/jajan_tile.dart';

String judulJajan(Jajan value) => value.catatan?.trim().isNotEmpty == true
    ? value.catatan!.trim().split('\n').first
    : value.kategori;

class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.value, required this.onTap});
  final Jajan value;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => JajanTile(
    key: ValueKey('transaction_${value.id}'),
    title: judulJajan(value),
    nominal: value.nominal,
    kategori: kelompokKategori(value.kategori),
    kategoriLabel: value.kategori,
    tanggal: value.tanggal,
    onTap: onTap,
  );
}

class JajanPage extends StatelessWidget {
  const JajanPage({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.onBack,
    this.actions = const [],
  });
  final String title;
  final String? subtitle;
  final Widget child;
  final VoidCallback? onBack;
  final List<Widget> actions;
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
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
                if (onBack != null) ...[
                  IconButton.outlined(
                    tooltip: 'Kembali',
                    onPressed: onBack,
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
                ...actions,
              ],
            ),
            const SizedBox(height: 24),
            child,
            const SizedBox(height: 40),
          ],
        ),
      ),
    ),
  );
}

/// Satu banner untuk semua layar; data lama tetap jelas jika stream error.
class JajanDataNotice extends StatelessWidget {
  const JajanDataNotice({super.key});
  @override
  Widget build(BuildContext context) {
    final p = context.watch<JajanProvider>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (p.isLoading) const LinearProgressIndicator(minHeight: 3),
        if (p.error != null)
          Container(
            color: Theme.of(context).colorScheme.errorContainer,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(p.error!, style: const TextStyle(fontSize: 12)),
                ),
                TextButton(
                  onPressed: p.isLoading ? null : p.cobaLagi,
                  child: const Text('Coba lagi'),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class EmptyJajan extends StatelessWidget {
  const EmptyJajan({
    super.key,
    required this.title,
    required this.message,
    this.action,
    this.actionLabel = 'Tambah Jajan',
  });
  final String title;
  final String message;
  final VoidCallback? action;
  final String actionLabel;
  @override
  Widget build(BuildContext context) => JajanSurface(
    child: SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          const Icon(
            Icons.receipt_long_outlined,
            size: 48,
            color: JajanColors.blue,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          if (action != null) ...[
            const SizedBox(height: 16),
            JajanActionButton(label: actionLabel, onPressed: action),
          ],
        ],
      ),
    ),
  );
}

class DataWaiting extends StatelessWidget {
  const DataWaiting({super.key});
  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.all(24),
    child: Text(
      'Data akun belum tersedia. Tunggu proses muat atau gunakan Coba lagi.',
    ),
  );
}
