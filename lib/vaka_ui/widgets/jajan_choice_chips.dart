import 'package:flutter/material.dart';

import '../jajan_theme.dart';

class JajanChoice {
  const JajanChoice(this.value, this.label);
  final String value;
  final String label;
}

/// Kode UI saja, BUKAN ID dokumen kategori Firestore.
const jajanCategories = [
  JajanChoice('makan', 'Makan'),
  JajanChoice('kopi', 'Kopi'),
  JajanChoice('transport', 'Transport'),
  JajanChoice('lainnya', 'Lainnya'),
];
const jajanReasons = [
  JajanChoice('lapar', 'Lapar'),
  JajanChoice('stres', 'Stres'),
  JajanChoice('ikut_teman', 'Ikut teman'),
  JajanChoice('hadiah', 'Hadiah'),
];
IconData jajanCategoryIcon(String value) => switch (value) {
  'makan' => Icons.restaurant_outlined,
  'kopi' => Icons.local_cafe_outlined,
  'transport' => Icons.directions_bike_outlined,
  _ => Icons.shopping_bag_outlined,
};
Color jajanCategoryColor(String value) => switch (value) {
  'makan' => JajanColors.yellow,
  'transport' => JajanColors.green,
  _ => JajanColors.blue,
};

/// Nilai dipasok dan disimpan pemanggil, sehingga aman dibagi antarlayar.
class JajanChoiceChips extends StatelessWidget {
  const JajanChoiceChips({
    super.key,
    required this.choices,
    required this.selectedValue,
    required this.onChanged,
    this.optional = false,
    this.useYellow = false,
  });
  final List<JajanChoice> choices;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;
  final bool optional;
  final bool useYellow;
  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: choices.map((choice) {
      final selected = selectedValue == choice.value;
      return ChoiceChip(
        key: ValueKey('choice_${choice.value}'),
        label: Text(choice.label),
        selected: selected,
        showCheckmark: true,
        backgroundColor: context.cardColor,
        selectedColor: useYellow ? JajanColors.yellow : JajanColors.blue,
        checkmarkColor: JajanColors.ink,
        labelStyle: TextStyle(
          color: selected ? JajanColors.ink : context.inkColor,
          fontWeight: FontWeight.w600,
        ),
        shape: const StadiumBorder(),
        side: BorderSide(
          color: selected ? Colors.transparent : context.lineColor,
          width: 2,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        onSelected: (value) =>
            onChanged(!value && optional ? null : choice.value),
      );
    }).toList(),
  );
}

class JajanCategoryGrid extends StatelessWidget {
  const JajanCategoryGrid({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });
  final String? selectedValue;
  final ValueChanged<String> onChanged;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => Wrap(
      spacing: 12,
      runSpacing: 18,
      children: jajanCategories.map((choice) {
        final selected = selectedValue == choice.value;
        final color = selected ? Colors.white : context.inkColor;
        return SizedBox(
          width: (constraints.maxWidth - 12) / 2,
          child: Semantics(
            selected: selected,
            onTap: () => onChanged(choice.value),
            button: true,
            label: choice.label,
            child: ExcludeSemantics(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: selected
                          ? const Color(0xFF148CC3)
                          : context.lineColor,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Material(
                  color: selected ? JajanColors.blue : context.cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                    side: BorderSide(
                      color: selected
                          ? const Color(0xFF148CC3)
                          : context.lineColor,
                      width: 2,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    key: ValueKey('category_${choice.value}'),
                    onTap: () => onChanged(choice.value),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 8,
                      ),
                      child: Column(
                        children: [
                          Icon(
                            jajanCategoryIcon(choice.value),
                            size: 28,
                            color: selected ? Colors.white : JajanColors.blue,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${choice.label}${selected ? ' ✓' : ''}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}
