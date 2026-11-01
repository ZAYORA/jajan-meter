import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jajan_meter/vaka_ui/formatters.dart';
import 'package:jajan_meter/vaka_ui/jajan_theme.dart';
import 'package:jajan_meter/vaka_ui/preview/component_preview_page.dart';
import 'package:jajan_meter/vaka_ui/preview/preview_app.dart';
import 'package:jajan_meter/vaka_ui/widgets/budget_card.dart';
import 'package:jajan_meter/vaka_ui/widgets/jajan_choice_chips.dart';
import 'package:jajan_meter/vaka_ui/widgets/jajan_tile.dart';

Widget wrap(Widget child) => MaterialApp(
  theme: buildJajanTheme(),
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

void main() {
  setUpAll(initializeJajanFormats);

  testWidgets('kartu contoh menampilkan sisa 34 persen, bukan terpakai 66', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(const BudgetCard(jatah: 50000, terpakai: 33000, sisa: 17000)),
    );
    expect(find.text('Rp17.000'), findsOneWidget);
    expect(find.text('34% lagi'), findsOneWidget);
    final bar = tester.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );
    expect(bar.value, closeTo(.34, .0001));
  });

  testWidgets('ambang 20 persen dan kondisi terlampaui terbaca', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(const BudgetCard(jatah: 50000, terpakai: 40000, sisa: 10000)),
    );
    expect(find.text('Sisa jatah tinggal 20% atau kurang.'), findsOneWidget);
    await tester.pumpWidget(
      wrap(const BudgetCard(jatah: 50000, terpakai: 60000, sisa: -10000)),
    );
    expect(find.text('-Rp10.000'), findsOneWidget);
    expect(find.text('Terlampaui'), findsOneWidget);
    expect(
      tester
          .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
          .value,
      0,
    );
  });

  testWidgets('jatah nol tidak menghasilkan NaN dan menyediakan ajakan', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(const BudgetCard(jatah: 0, terpakai: 0, sisa: 0)),
    );
    expect(find.text('Atur jatah dulu'), findsOneWidget);
    expect(tester.takeException(), isNull);
    expect(
      tester
          .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
          .value,
      0,
    );
  });

  testWidgets('kategori single-select dan alasan boleh dikosongkan', (
    tester,
  ) async {
    String? category;
    String? reason;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildJajanTheme(),
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: [
                  JajanChoiceChips(
                    choices: jajanCategories,
                    selectedValue: category,
                    onChanged: (value) => setState(() => category = value),
                  ),
                  JajanChoiceChips(
                    choices: jajanReasons,
                    selectedValue: reason,
                    optional: true,
                    onChanged: (value) => setState(() => reason = value),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
    await tester.tap(find.byKey(const ValueKey('choice_kopi')));
    await tester.pump();
    expect(category, 'kopi');
    await tester.tap(find.byKey(const ValueKey('choice_makan')));
    await tester.pump();
    expect(category, 'makan');
    expect(
      tester
          .widget<ChoiceChip>(find.byKey(const ValueKey('choice_kopi')))
          .selected,
      isFalse,
    );
    await tester.tap(find.byKey(const ValueKey('choice_stres')));
    await tester.pump();
    expect(reason, 'stres');
    await tester.tap(find.byKey(const ValueKey('choice_stres')));
    await tester.pump();
    expect(reason, isNull);
  });

  testWidgets('baris jajan tanpa alasan tetap rapi dan dapat diketuk', (
    tester,
  ) async {
    var tapped = false;
    await tester.pumpWidget(
      wrap(
        JajanTile(
          title: 'Kopi susu',
          nominal: 15000,
          kategori: 'kopi',
          kategoriLabel: 'Kopi/minum',
          tanggal: DateTime(2026, 10, 14, 7, 30),
          onTap: () => tapped = true,
        ),
      ),
    );
    expect(find.text('Kopi/minum · 07.30'), findsOneWidget);
    await tester.tap(find.text('Kopi susu'));
    expect(tapped, isTrue);
  });

  testWidgets('empat tab dapat dibuka dan kembali ke Beranda', (tester) async {
    await tester.pumpWidget(const VakaPreviewApp());
    for (final index in [1, 2, 3, 0]) {
      await tester.tap(find.byKey(ValueKey('tab_$index')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
    expect(find.text('Halo, anak jajan!'), findsOneWidget);
  });

  testWidgets('tombol pratinjau tetap nonaktif untuk kosong dan nol', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(theme: buildJajanTheme(), home: const ComponentPreviewPage()),
    );
    final save = find.byKey(const ValueKey('preview_save'));
    Future<void> reveal(Finder target, double delta) =>
        tester.scrollUntilVisible(
          target,
          delta,
          scrollable: find.byType(Scrollable).first,
        );
    await reveal(save, 200);
    await tester.pumpAndSettle();
    expect(tester.widget<FilledButton>(save).onPressed, isNull);
    final input = find.byKey(const ValueKey('nominal_input'));
    await reveal(input, -200);
    await tester.enterText(input, '0');
    await reveal(find.byKey(const ValueKey('choice_kopi')), 150);
    await tester.tap(find.byKey(const ValueKey('choice_kopi')));
    await tester.pump();
    await reveal(save, 200);
    await tester.pumpAndSettle();
    expect(tester.widget<FilledButton>(save).onPressed, isNull);
    await reveal(input, -200);
    await tester.enterText(input, '15000');
    await tester.pump();
    await reveal(save, 200);
    await tester.pumpAndSettle();
    expect(tester.widget<FilledButton>(save).onPressed, isNotNull);
    await tester.tap(save);
    await tester.pump();
    expect(
      find.text('Input valid. Ini pratinjau; belum ada transaksi tersimpan.'),
      findsOneWidget,
    );
  });

  for (final width in [320.0, 393.0, 768.0]) {
    testWidgets('tab tidak overflow pada lebar $width dan teks 1.5x', (
      tester,
    ) async {
      tester.view.resetPhysicalSize();
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = Size(width, 852);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(
          theme: buildJajanTheme(),
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.5)),
            child: child!,
          ),
          home: const VakaPreviewShell(),
        ),
      );
      await tester.pumpAndSettle();
      for (var index = 0; index < 4; index++) {
        await tester.tap(find.byKey(ValueKey('tab_$index')));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
    });
  }
}
