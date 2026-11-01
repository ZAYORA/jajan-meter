import 'package:flutter/material.dart';

import '../jajan_theme.dart';

class JajanChoice {
  const JajanChoice(this.value, this.label);
  final String value;
  final String label;
}

/// Kode disamakan dengan proposal; label antarmuka dapat berbeda.
const jajanCategories = [
  JajanChoice('makan', 'Makan'),
  JajanChoice('kopi', 'Kopi'),
  JajanChoice('camilan', 'Camilan'),
  JajanChoice('transport', 'Transport'),
  JajanChoice('lainnya', 'Lainnya'),
];
const jajanReasons = [
  JajanChoice('lapar', 'Lapar'),
  JajanChoice('stres', 'Stres'),
  JajanChoice('ikut_teman', 'Ikut teman'),
  JajanChoice('hadiah', 'Hadiah'),
];

/// Controlled widget: nilai pilihan disimpan pemanggil, bukan disalin di sini.
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
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: choices.map((choice) {
        final selected = selectedValue == choice.value;
        return ChoiceChip(
          key: ValueKey('choice_${choice.value}'),
          label: Text(choice.label),
          selected: selected,
          showCheckmark: false,
          backgroundColor: Colors.white,
          selectedColor: useYellow ? JajanColors.yellow : JajanColors.blue,
          labelStyle: TextStyle(
            color: selected && !useYellow ? Colors.white : JajanColors.ink,
            fontSize: 15,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
          shape: const StadiumBorder(),
          side: BorderSide(
            color: selected ? Colors.transparent : JajanColors.border,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          materialTapTargetSize: MaterialTapTargetSize.padded,
          onSelected: (isSelected) {
            onChanged(!isSelected && optional ? null : choice.value);
          },
        );
      }).toList(),
    );
  }
}
