import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jajan_meter/main_vaka_ui_kit_preview.dart' as catalog;
import 'package:jajan_meter/vaka_ui/foundation/widgets/jm_button.dart';
import 'package:jajan_meter/vaka_ui/formatters.dart';
import 'package:jajan_meter/vaka_ui/jajan_theme.dart';
import 'package:jajan_meter/vaka_ui/preview/preview_app.dart';
import 'package:jajan_meter/vaka_ui/widgets/jajan_choice_chips.dart';
import 'package:jajan_meter/vaka_ui/widgets/jajan_surface.dart';

const capture = bool.fromEnvironment('CAPTURE_UI');
const captureKey = ValueKey('capture');

Future<void> size(WidgetTester tester, Size value) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = value;
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
}

Future<void> screenshot(WidgetTester tester, String name) async {
  if (!capture) return;
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(captureKey),
  );
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 1);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    final file = File('docs/screenshots/vaka-tahap-1-3/$name.png');
    await file.parent.create(recursive: true);
    await file.writeAsBytes(data!.buffer.asUint8List());
    image.dispose();
  });
}

void main() {
  setUpAll(() async {
    await initializeJajanFormats();
    final loader = FontLoader('Poppins');
    for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
      loader.addFont(
        rootBundle.load('assets/fonts/poppins/Poppins-$weight.ttf'),
      );
    }
    await loader.load();
    final icons = FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await icons.load();
  });
  testWidgets('preview foundation lama tetap dapat dibuka dengan tema lokal', (
    tester,
  ) async {
    await size(tester, const Size(393, 852));
    await tester.pumpWidget(const catalog.JajanUiKitPreviewApp());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
  testWidgets('tombol foundation loading tidak menjalankan aksi', (
    tester,
  ) async {
    var called = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildJajanTheme(),
        home: Scaffold(
          body: JmButton(
            label: 'Simpan',
            isLoading: true,
            onPressed: () => called = true,
          ),
        ),
      ),
    );
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
    expect(called, isFalse);
  });
  for (final viewport in [const Size(393, 852), const Size(1024, 1194)]) {
    for (final mode in [ThemeMode.light, ThemeMode.dark]) {
      final device = viewport.width < 840 ? 'hp' : 'tablet';
      final theme = mode == ThemeMode.light ? 'terang' : 'gelap';
      testWidgets('$device $theme: layout, menu, dan form tidak overflow', (
        tester,
      ) async {
        await size(tester, viewport);
        final previousShadows = debugDisableShadows;
        debugDisableShadows = false;
        try {
          await tester.pumpWidget(
            RepaintBoundary(
              key: captureKey,
              child: VakaPreviewApp(initialThemeMode: mode),
            ),
          );
          await tester.pumpAndSettle();
          final tablet = device == 'tablet';
          expect(
            find.byKey(const ValueKey('tablet_sidebar')),
            tablet ? findsOneWidget : findsNothing,
          );
          expect(
            find.byKey(const ValueKey('home_two_columns')),
            tablet ? findsOneWidget : findsNothing,
          );
          expect(tester.takeException(), isNull);
          await screenshot(tester, 'beranda-$device-$theme');
          for (final index in [1, 2, 3, 0]) {
            await tester.tap(
              find.byKey(ValueKey('${tablet ? 'side' : 'tab'}_$index')),
            );
            await tester.pumpAndSettle();
            expect(tester.takeException(), isNull);
          }
          await tester.tap(find.byKey(const ValueKey('open_components')));
          await tester.pumpAndSettle();
          expect(find.byType(JajanCategoryGrid), findsOneWidget);
          expect(jajanCategories.map((c) => c.value), [
            'makan',
            'kopi',
            'transport',
            'lainnya',
          ]);
          expect(
            find.byKey(const ValueKey('form_two_columns')),
            tablet ? findsOneWidget : findsNothing,
          );
          expect(tester.takeException(), isNull);
          await screenshot(tester, 'tambah-$device-$theme');
        } finally {
          debugDisableShadows = previousShadows;
        }
      });
    }
  }
  testWidgets(
    'tema berubah dan nama panggilan memperbarui sapaan tanpa Firebase',
    (tester) async {
      await size(tester, const Size(393, 852));
      await tester.pumpWidget(const VakaPreviewApp());
      await tester.tap(find.byKey(const ValueKey('preview_theme')));
      await tester.pumpAndSettle();
      expect(
        Theme.of(tester.element(find.byKey(const ValueKey('greeting'))))
            .brightness,
        Brightness.dark,
      );
      await tester.tap(find.byKey(const ValueKey('open_settings')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('nickname_input')),
        'Vaka',
      );
      await tester.tap(find.byTooltip('Kembali ke Beranda').last);
      await tester.pumpAndSettle();
      expect(find.text('Halo, Vaka!'), findsOneWidget);
    },
  );
  testWidgets(
    'isian kategori/alasan tetap tersimpan setelah resize HP ke tablet',
    (tester) async {
      await size(tester, const Size(393, 852));
      await tester.pumpWidget(const VakaPreviewApp());
      await tester.tap(find.byKey(const ValueKey('open_components')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('nominal_input')),
        '25000',
      );
      Future<void> reveal(Finder finder) async {
        await tester.ensureVisible(finder);
        await tester.pumpAndSettle();
      }

      await reveal(find.byKey(const ValueKey('category_kopi')));
      await tester.tap(find.byKey(const ValueKey('category_kopi')));
      await reveal(find.byKey(const ValueKey('preview_save')));
      expect(
        tester
            .widget<JajanActionButton>(
              find.byKey(const ValueKey('preview_save')),
            )
            .onPressed,
        isNull,
      );
      await reveal(find.byKey(const ValueKey('choice_stres')));
      await tester.tap(find.byKey(const ValueKey('choice_stres')));
      await tester.pump();
      tester.view.physicalSize = const Size(1024, 1194);
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<JajanCategoryGrid>(find.byType(JajanCategoryGrid))
            .selectedValue,
        'kopi',
      );
      expect(
        tester
            .widget<ChoiceChip>(find.byKey(const ValueKey('choice_stres')))
            .selected,
        isTrue,
      );
      expect(find.text('Rp25.000'), findsOneWidget);
      expect(
        tester
            .widget<JajanActionButton>(
              find.byKey(const ValueKey('preview_save')),
            )
            .onPressed,
        isNotNull,
      );
      expect(tester.takeException(), isNull);
    },
  );
}
