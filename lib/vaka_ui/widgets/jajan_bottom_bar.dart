import 'package:flutter/material.dart';

import '../jajan_theme.dart';
import '../navigation/jajan_destinations.dart';

const jajanTabLabels = ['Beranda', 'Riwayat', 'Statistik', 'Lencana'];
const jajanTabRoutes = ['/', '/riwayat', '/statistik', '/streak'];

class JajanBottomBar extends StatelessWidget {
  const JajanBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: Container(
      margin: const EdgeInsets.fromLTRB(16, 6, 16, 14),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: context.lineColor, width: 2),
        boxShadow: [
          BoxShadow(color: context.lineColor, offset: const Offset(0, 6)),
        ],
      ),
      child: Row(
        children: List.generate(4, (index) {
          final selected = selectedIndex == index;
          return Expanded(
            child: Semantics(
              button: true,
              selected: selected,
              label: jajanTabLabels[index],
              onTap: () => onSelected(index),
              child: ExcludeSemantics(
                child: InkWell(
                  key: ValueKey('tab_$index'),
                  borderRadius: BorderRadius.circular(28),
                  onTap: () => onSelected(index),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selected
                                ? JajanColors.blue
                                : Colors.transparent,
                            boxShadow: selected
                                ? const [
                                    BoxShadow(
                                      color: Color(0xFF148CC3),
                                      offset: Offset(0, 4),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Icon(
                            jajanDestinations[index].icon,
                            color: selected ? Colors.white : context.mutedColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          jajanTabLabels[index],
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: selected
                                ? JajanColors.blue
                                : context.mutedColor,
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
      ),
    ),
  );
}
