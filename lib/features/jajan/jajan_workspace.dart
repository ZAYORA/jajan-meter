import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/jajan.dart';
import '../../providers/jajan_provider.dart';
import '../../vaka_ui/navigation/jajan_adaptive_shell.dart';
import '../../vaka_ui/navigation/jajan_destinations.dart';
import 'jajan_detail_page.dart';
import 'jajan_form_page.dart';
import 'jajan_history_page.dart';
import 'jajan_home_page.dart';
import 'jajan_preferences_page.dart';
import 'jajan_shared.dart';

/// Host navigasi sementara sebelum Agnie memasang GoRouter.
/// Widget halaman dan JajanAdaptiveShell dapat digunakan langsung di ShellRoute.
class JajanWorkspace extends StatefulWidget {
  const JajanWorkspace({super.key, this.onSignOut, this.demo = false});
  final Future<void> Function()? onSignOut;
  final bool demo;
  @override
  State<JajanWorkspace> createState() => _JajanWorkspaceState();
}

class _JajanWorkspaceState extends State<JajanWorkspace> {
  int _index = 0;
  void _select(int value) {
    if (context.read<JajanProvider>().isSaving) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
    setState(() => _index = value);
  }

  Widget _shell(Widget body, {bool route = false}) {
    final p = context.watch<JajanProvider>();
    return JajanAdaptiveShell(
      selectedIndex: _index,
      onSelected: _select,
      nickname: p.namaPanggilan,
      showMobileNavigation: !route && _index < 4,
      child: Column(
        children: [
          if (widget.demo)
            Container(
              width: double.infinity,
              color: Theme.of(context).colorScheme.secondaryContainer,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: const Text(
                'DEMO · DATA CONTOH DI MEMORI · RESET SAAT DITUTUP',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
              ),
            ),
          const JajanDataNotice(),
          Expanded(child: body),
        ],
      ),
    );
  }

  Future<void> _form([Jajan? original]) async {
    final id = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => _RouteHost(
          onSelect: _select,
          demo: widget.demo,
          index: _index,
          child: JajanFormPage(original: original),
        ),
      ),
    );
    if (mounted && id != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            original == null
                ? 'Jajan berhasil disimpan.'
                : 'Jajan berhasil diperbarui.',
          ),
        ),
      );
    }
  }

  void _detail(Jajan j) => Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => _RouteHost(
        onSelect: _select,
        demo: widget.demo,
        index: _index,
        child: JajanDetailPage(id: j.id, onEdit: _form),
      ),
    ),
  );
  @override
  Widget build(BuildContext context) => PopScope(
    canPop: _index == 0,
    onPopInvokedWithResult: (didPop, result) {
      if (!didPop && _index != 0) _select(0);
    },
    child: _shell(switch (_index) {
      0 => JajanHomePage(
        onAdd: _form,
        onDetail: _detail,
        onHistory: () => _select(1),
        onTarget: () => _select(4),
        onSettings: () => _select(5),
      ),
      1 => JajanHistoryPage(onDetail: _detail),
      4 || 5 => JajanPreferencesPage(
        targetOnly: _index == 4,
        onSignOut: widget.onSignOut,
        onBack: () => _select(0),
      ),
      _ => JajanPage(
        title: jajanDestinations[_index].label,
        child: EmptyJajan(
          title: _index == 2
              ? 'Statistik sedang disiapkan'
              : 'Streak & Lencana sedang disiapkan',
          message: _index == 2
              ? 'Sementara itu, lihat pengeluaranmu di Riwayat.'
              : 'Kamu tetap bisa mencatat jajan dan menjaga jatah harianmu.',
          action: () => _select(1),
          actionLabel: 'Lihat riwayat',
        ),
      ),
    }),
  );
}

class _RouteHost extends StatelessWidget {
  const _RouteHost({
    required this.onSelect,
    required this.demo,
    required this.index,
    required this.child,
  });
  final ValueChanged<int> onSelect;
  final bool demo;
  final int index;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final p = context.watch<JajanProvider>();
    return JajanAdaptiveShell(
      selectedIndex: index,
      onSelected: onSelect,
      nickname: p.namaPanggilan,
      showMobileNavigation: false,
      child: Column(
        children: [
          if (demo)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(6),
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: const Text(
                'DEMO · DATA CONTOH DI MEMORI',
                style: TextStyle(fontSize: 10),
              ),
            ),
          const JajanDataNotice(),
          Expanded(child: child),
        ],
      ),
    );
  }
}
