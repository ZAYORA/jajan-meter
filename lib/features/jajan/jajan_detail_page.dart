import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/jajan.dart';
import '../../providers/jajan_category.dart';
import '../../providers/jajan_provider.dart';
import '../../vaka_ui/formatters.dart';
import '../../vaka_ui/foundation/widgets/jm_button.dart';
import '../../vaka_ui/jajan_theme.dart';
import '../../vaka_ui/widgets/jajan_choice_chips.dart';
import '../../vaka_ui/widgets/jajan_surface.dart';
import 'jajan_shared.dart';

class JajanDetailPage extends StatefulWidget {
  const JajanDetailPage({super.key, required this.id, required this.onEdit});
  final String id;
  final ValueChanged<Jajan> onEdit;
  @override
  State<JajanDetailPage> createState() => _JajanDetailPageState();
}

class _JajanDetailPageState extends State<JajanDetailPage> {
  bool _deleting = false;
  String? _error;
  Future<void> _delete(Jajan j) async {
    if (_deleting) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus jajan ini?'),
        content: Text(
          '${judulJajan(j)} sebesar ${formatRupiah(j.nominal)} akan dihapus.',
        ),
        actions: [
          TextButton(
            key: const ValueKey('cancel_delete'),
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            key: const ValueKey('confirm_delete'),
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Hapus',
              style: TextStyle(color: JajanColors.danger),
            ),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    setState(() {
      _deleting = true;
      _error = null;
    });
    final p = context.read<JajanProvider>();
    final result = await p.hapusJajan(j.id);
    if (!mounted) return;
    setState(() => _deleting = false);
    if (result) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Jajan berhasil dihapus.')));
    } else {
      setState(
        () => _error = p.actionError ?? 'Belum berhasil menghapus. Coba lagi.',
      );
    }
  }

  Widget _info(
    BuildContext context,
    IconData icon,
    String name,
    String value,
  ) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: context.mutedColor, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    ),
  );
  @override
  Widget build(BuildContext context) {
    final p = context.watch<JajanProvider>();
    final j = p.cariJajan(widget.id);
    return PopScope(
      canPop: !_deleting,
      child: JajanPage(
        title: 'Detail Jajan',
        onBack: _deleting ? null : () => Navigator.pop(context),
        child: _deleting
            ? const Center(child: CircularProgressIndicator())
            : j == null
            ? EmptyJajan(
                title: 'Transaksi tidak tersedia',
                message: p.hasData
                    ? 'Transaksi ini mungkin sudah dihapus.'
                    : 'Data masih dimuat.',
              )
            : LayoutBuilder(
                builder: (context, c) {
                  final summary = Column(
                    children: [
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: context.softBlue,
                          borderRadius: BorderRadius.circular(48),
                        ),
                        child: Icon(
                          jajanCategoryIcon(kelompokKategori(j.kategori)),
                          size: 80,
                          color: JajanColors.blue,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        judulJajan(j),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          formatRupiah(-j.nominal),
                          key: const ValueKey('detail_amount'),
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                            color: JajanColors.danger,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Chip(
                        label: Text(j.kategori),
                        backgroundColor: context.softBlue,
                      ),
                    ],
                  );
                  final details = Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      JajanSurface(
                        child: Column(
                          children: [
                            _info(
                              context,
                              Icons.schedule,
                              'Waktu',
                              '${formatTanggal(j.tanggal)} · ${formatJam(j.tanggal)}',
                            ),
                            const Divider(height: 1),
                            _info(
                              context,
                              Icons.category_outlined,
                              'Kategori',
                              j.kategori,
                            ),
                            const Divider(height: 1),
                            _info(
                              context,
                              Icons.chat_bubble_outline,
                              'Alasan',
                              j.alasan,
                            ),
                            const Divider(height: 1),
                            _info(
                              context,
                              Icons.edit_note_outlined,
                              'Catatan',
                              j.catatan?.isNotEmpty == true
                                  ? j.catatan!
                                  : 'Tidak ada catatan',
                            ),
                          ],
                        ),
                      ),
                      if (_error != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            _error!,
                            style: const TextStyle(color: JajanColors.danger),
                          ),
                        ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: JmButton(
                              key: const ValueKey('edit_jajan'),
                              label: 'Edit',
                              icon: Icons.edit_outlined,
                              backgroundColor: JajanColors.blue,
                              onPressed: p.isSaving
                                  ? null
                                  : () => widget.onEdit(j),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: JmButton(
                              key: const ValueKey('delete_jajan'),
                              label: 'Hapus',
                              icon: Icons.delete_outline,
                              backgroundColor: JajanColors.danger,
                              onPressed: p.isSaving ? null : () => _delete(j),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                  if (c.maxWidth < 720) {
                    return Column(
                      children: [summary, const SizedBox(height: 24), details],
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: JajanSurface(child: summary)),
                      const SizedBox(width: 24),
                      Expanded(child: details),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
