import 'package:flutter/material.dart';

import '../jajan_theme.dart';

const jajanTabLabels = ['Beranda', 'Statistik', 'Target', 'Pengaturan'];
const jajanTabRoutes = ['/', '/statistik', '/target', '/pengaturan'];
const _tabIcons = [
  Icons.home_outlined,
  Icons.bar_chart_outlined,
  Icons.track_changes_outlined,
  Icons.tune_outlined,
];

/// Agnie dapat memasang komponen ini pada Scaffold milik ShellRoute.
/// onSelected menjadi titik sambung ke context.go(jajanTabRoutes[index]).
class JajanBottomBar extends StatelessWidget {
  const JajanBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: JajanColors.border)),
          ),
          child: Row(
            children: List.generate(4, (index) {
              final selected = selectedIndex == index;
              final color = selected ? JajanColors.blue : JajanColors.muted;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Semantics(
                    button: true,
                    selected: selected,
                    label: jajanTabLabels[index],
                    onTap: () => onSelected(index),
                    child: ExcludeSemantics(
                      child: InkWell(
                        key: ValueKey('tab_$index'),
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => onSelected(index),
                        child: Ink(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 2,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? JajanColors.paleBlue
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(_tabIcons[index], color: color, size: 26),
                              const SizedBox(height: 6),
                              Text(
                                jajanTabLabels[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: color,
                                  fontSize: 10,
                                  fontWeight: selected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
