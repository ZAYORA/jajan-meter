import 'package:flutter/material.dart';

import '../jajan_theme.dart';
import '../widgets/jajan_bottom_bar.dart';
import '../widgets/wallet_mascot.dart';
import 'jajan_destinations.dart';

/// Stateless: halaman, indeks, nama, dan navigasi dikendalikan pemanggil/router.
/// Tablet >=840 logical pixels; layar kecil tetap dapat discroll/scale teks.
class JajanAdaptiveShell extends StatelessWidget {
  const JajanAdaptiveShell({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
    required this.child,
    this.nickname = '',
    this.showMobileNavigation = true,
    this.floatingActionButton,
  });
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final Widget child;
  final String nickname;
  final bool showMobileNavigation;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final tablet = constraints.maxWidth >= jajanTabletBreakpoint;
      return Scaffold(
        body: SafeArea(
          bottom: false,
          child: Row(
            children: [
              if (tablet)
                _Sidebar(
                  selectedIndex: selectedIndex,
                  onSelected: onSelected,
                  nickname: nickname,
                ),
              Expanded(child: child),
            ],
          ),
        ),
        bottomNavigationBar: !tablet && showMobileNavigation
            ? JajanBottomBar(
                selectedIndex: selectedIndex,
                onSelected: onSelected,
              )
            : null,
        floatingActionButton: !tablet ? floatingActionButton : null,
      );
    },
  );
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.selectedIndex,
    required this.onSelected,
    required this.nickname,
  });
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final String nickname;
  @override
  Widget build(BuildContext context) => Container(
    key: const ValueKey('tablet_sidebar'),
    width: 192,
    decoration: BoxDecoration(
      color: context.cardColor,
      border: Border(right: BorderSide(color: context.lineColor)),
    ),
    child: ListView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: WalletMascot(size: 64),
        ),
        const Text(
          'Jajan Meter',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: JajanColors.blue,
          ),
        ),
        const SizedBox(height: 28),
        ...List.generate(jajanDestinations.length, (index) {
          final destination = jajanDestinations[index];
          final selected = selectedIndex == index;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Semantics(
              selected: selected,
              child: Material(
                color: selected ? context.softBlue : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  key: ValueKey('side_$index'),
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => onSelected(index),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 12,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          destination.icon,
                          color: selected
                              ? JajanColors.blue
                              : context.mutedColor,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            destination.label,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: selected
                                  ? JajanColors.blue
                                  : context.inkColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: JajanColors.paleYellow,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Jajan boleh.\nBoros jangan!',
            style: TextStyle(
              color: JajanColors.ink,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 40),
        Row(
          children: [
            const CircleAvatar(
              backgroundColor: JajanColors.paleBlue,
              child: Icon(Icons.person_outline, color: JajanColors.blue),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                nickname.trim().isEmpty ? 'Teman jajan' : nickname.trim(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
