import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jajan_meter/app/jajan_session_app.dart';
import 'package:jajan_meter/models/jajan.dart';
import 'package:jajan_meter/vaka_ui/formatters.dart';

import 'fake_jajan_source.dart';

const capture = bool.fromEnvironment('CAPTURE_CRUD');
const boundaryKey = ValueKey('capture_crud');
final day = DateTime(2026, 11, 3, 15);

Future<void> screenshot(WidgetTester tester, String name) async {
  if (!capture) return;
  FocusManager.instance.primaryFocus?.unfocus();
  final navigatorContext = tester.element(find.byType(Navigator).first);
  ScaffoldMessenger.of(navigatorContext).clearSnackBars();
  await tester.pumpAndSettle();
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(boundaryKey),
  );
  await tester.runAsync(() async {
    final img = await boundary.toImage(pixelRatio: 1);
    final bytes = await img.toByteData(format: ui.ImageByteFormat.png);
    final file = File('docs/screenshots/vaka-tahap-1-5/$name.png');
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes!.buffer.asUint8List());
    img.dispose();
  });
}

Future<void> click(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> input(WidgetTester tester, String key, String value) async {
  final finder = find.byKey(ValueKey(key));
  await tester.ensureVisible(finder);
  await tester.enterText(finder, value);
  await tester.pumpAndSettle();
}

Future<void> pumpApp(
  WidgetTester tester,
  FakeJajanSource source,
  Size size, {
  Key? key,
  double textScale = 1,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  await tester.pumpWidget(
    RepaintBoundary(
      key: boundaryKey,
      child: MediaQuery(
        data: MediaQueryData(
          size: size,
          textScaler: TextScaler.linear(textScale),
        ),
        child: JajanSessionApp(
          key: key,
          source: source,
          now: () => day,
          autoRefreshClock: false,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

FakeJajanSource seeded({bool dark = false}) {
  final s = FakeJajanSource();
  s.profile['tema'] = dark ? 'gelap' : 'terang';
  s.items = [
    Jajan(
      id: 'food-tx',
      nominal: 20000,
      kategori: 'Makan',
      kategoriId: 'food',
      alasan: 'Lapar',
      tanggal: DateTime(2026, 11, 3, 12, 15),
      catatan: 'Nasi Ayam',
    ),
    Jajan(
      id: 'coffee-tx',
      nominal: 25000,
      kategori: 'Kopi',
      kategoriId: 'coffee',
      alasan: 'Teman belajar',
      tanggal: DateTime(2026, 11, 3, 10, 30),
      catatan: 'Kopi Susu',
    ),
    Jajan(
      id: 'transport-tx',
      nominal: 10000,
      kategori: 'Transport',
      kategoriId: 'transport',
      alasan: 'Ke kampus',
      tanggal: DateTime(2026, 11, 3, 7, 45),
      catatan: 'Ojek ke Kampus',
    ),
  ];
  return s;
}

void main() {
  setUpAll(() async {
    await initializeJajanFormats();
    final font = FontLoader('Poppins');
    for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
      font.addFont(rootBundle.load('assets/fonts/poppins/Poppins-$weight.ttf'));
    }
    await font.load();
    await (FontLoader(
      'MaterialIcons',
    )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
  });
  for (final tablet in [false, true]) {
    for (final dark in [false, true]) {
      final label = '${tablet ? 'tablet' : 'hp'}-${dark ? 'gelap' : 'terang'}';
      testWidgets('CRUD dan filter lengkap $label', (tester) async {
        final source = seeded(dark: dark);
        final oldShadows = debugDisableShadows;
        if (capture) debugDisableShadows = false;
        try {
          await pumpApp(
            tester,
            source,
            tablet ? const Size(1024, 1194) : const Size(393, 852),
          );
          expect(tester.takeException(), isNull);
          expect(find.text('Halo, Vaka!'), findsOneWidget);
          expect(find.text('Google'), findsNothing);
          expect(find.text('Facebook'), findsNothing);
          expect(find.text('Apple'), findsNothing);
          await screenshot(tester, 'beranda-$label');
          await click(tester, find.byKey(const ValueKey('add_jajan')));
          final save = find.byKey(const ValueKey('save_jajan'));
          final button = find.descendant(
            of: save,
            matching: find.byType(FilledButton),
          );
          expect(tester.widget<FilledButton>(button).onPressed, isNull);
          await input(tester, 'nominal_input', '0');
          expect(tester.widget<FilledButton>(button).onPressed, isNull);
          await input(tester, 'nominal_input', '15000');
          await click(tester, find.byKey(const ValueKey('category_kopi')));
          expect(tester.widget<FilledButton>(button).onPressed, isNull);
          await click(tester, find.byKey(const ValueKey('choice_stres')));
          await input(tester, 'note_input', 'Es kopi baru');
          expect(tester.widget<FilledButton>(button).onPressed, isNotNull);
          // Screenshot bagian form atas pada HP, seluruh kolom pada tablet.
          await tester.ensureVisible(find.text('Tambah Jajan').first);
          await tester.pumpAndSettle();
          await screenshot(tester, 'tambah-$label');
          await click(tester, save);
          expect(source.items.length, 4);
          expect(source.items.last.alasan, 'Stres');
          expect(source.items.last.kategoriId, 'coffee');
          await click(
            tester,
            find.byKey(ValueKey(tablet ? 'side_1' : 'tab_1')),
          );
          expect(find.text('Rp70.000'), findsOneWidget);
          await screenshot(tester, 'riwayat-$label');
          await click(tester, find.byKey(const ValueKey('choice_kopi')));
          expect(find.text('Rp40.000'), findsOneWidget);
          await click(tester, find.byKey(const ValueKey('transaction_new-1')));
          expect(find.text('Stres'), findsOneWidget);
          await screenshot(tester, 'detail-$label');
          await click(tester, find.byKey(const ValueKey('edit_jajan')));
          await input(tester, 'nominal_input', '18000');
          await click(tester, find.byKey(const ValueKey('form_date')));
          await click(tester, find.text('2').last);
          await click(tester, find.text('OK').last);
          await click(tester, find.byKey(const ValueKey('save_jajan')));
          expect(source.items.last.tanggal.day, 2);
          expect(source.items.last.nominal, 18000);
          expect(find.text('-Rp18.000'), findsOneWidget);
          await click(tester, find.byKey(const ValueKey('delete_jajan')));
          await click(tester, find.byKey(const ValueKey('cancel_delete')));
          expect(source.items.length, 4);
          await click(tester, find.byKey(const ValueKey('delete_jajan')));
          await click(tester, find.byKey(const ValueKey('confirm_delete')));
          expect(source.items.length, 3);
          expect(find.text('Rp25.000'), findsOneWidget);
          expect(tester.takeException(), isNull);
          await tester.pumpWidget(const SizedBox.shrink());
          await tester.pumpAndSettle();
          await source.dispose();
        } finally {
          debugDisableShadows = oldShadows;
          tester.view.resetDevicePixelRatio();
          tester.view.resetPhysicalSize();
        }
      });
    }
  }
  testWidgets('error simpan mempertahankan form; coba ulang berhasil', (
    tester,
  ) async {
    final source = seeded()..failWrite = true;
    await pumpApp(tester, source, const Size(393, 852));
    await click(tester, find.byKey(const ValueKey('add_jajan')));
    await input(tester, 'nominal_input', '5000');
    await click(tester, find.byKey(const ValueKey('category_makan')));
    await click(tester, find.byKey(const ValueKey('choice_lapar')));
    await click(tester, find.byKey(const ValueKey('save_jajan')));
    expect(find.byKey(const ValueKey('form_error')), findsOneWidget);
    expect(source.items.length, 3);
    expect(
      tester
          .widget<TextField>(find.byKey(const ValueKey('nominal_input')))
          .controller!
          .text,
      '5000',
    );
    source.failWrite = false;
    await click(tester, find.byKey(const ValueKey('save_jajan')));
    expect(source.items.length, 4);
    await tester.pumpWidget(const SizedBox.shrink());
    await source.dispose();
    tester.view.resetDevicePixelRatio();
    tester.view.resetPhysicalSize();
  });
  testWidgets(
    'ganti akun ketika detail terbuka membuang route serta data lama',
    (tester) async {
      final first = seeded();
      final second = FakeJajanSource();
      second.profile['nama_panggilan'] = 'Akun kedua';
      await pumpApp(
        tester,
        first,
        const Size(393, 852),
        key: const ValueKey('uid-one'),
      );
      await click(tester, find.byKey(const ValueKey('transaction_food-tx')));
      expect(find.text('Detail Jajan'), findsOneWidget);
      await pumpApp(
        tester,
        second,
        const Size(393, 852),
        key: const ValueKey('uid-two'),
      );
      expect(find.text('Detail Jajan'), findsNothing);
      expect(find.text('Nasi Ayam'), findsNothing);
      expect(find.text('Halo, Akun kedua!'), findsOneWidget);
      expect(first.cancelled, 3);
      first.emit();
      await tester.pumpAndSettle();
      expect(find.text('Nasi Ayam'), findsNothing);
      await tester.pumpWidget(const SizedBox.shrink());
      await first.dispose();
      await second.dispose();
      tester.view.resetDevicePixelRatio();
      tester.view.resetPhysicalSize();
    },
  );
  testWidgets(
    'pengaturan tema dan jatah diterapkan lalu kembali ke Beranda di HP',
    (tester) async {
      final source = seeded();
      await pumpApp(tester, source, const Size(393, 852));
      await click(tester, find.byKey(const ValueKey('open_settings')));
      await click(tester, find.byType(SwitchListTile));
      expect(source.profile['tema'], 'gelap');
      await input(tester, 'budget_input', '80000');
      await click(tester, find.byKey(const ValueKey('save_budget')));
      expect(source.profile['jatah_harian'], 80000);
      await click(tester, find.byTooltip('Kembali'));
      expect(find.text('Halo, Vaka!'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
      await source.dispose();
      tester.view.resetDevicePixelRatio();
      tester.view.resetPhysicalSize();
    },
  );
  testWidgets(
    'stream error dan kosong mempunyai state berbeda serta tombol Coba lagi',
    (tester) async {
      final source = FakeJajanSource()..failRead = true;
      await pumpApp(tester, source, const Size(393, 852));
      expect(find.text('Coba lagi'), findsOneWidget);
      expect(find.text('Belum ada jajan hari ini'), findsNothing);
      source.failRead = false;
      await click(tester, find.text('Coba lagi'));
      expect(find.text('Coba lagi'), findsNothing);
      expect(find.text('Belum ada jajan hari ini'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
      await source.dispose();
      tester.view.resetDevicePixelRatio();
      tester.view.resetPhysicalSize();
    },
  );
  testWidgets(
    'lebar 320 dan teks besar tidak overflow; resize mempertahankan input',
    (tester) async {
      final source = seeded();
      await pumpApp(tester, source, const Size(320, 900), textScale: 1.5);
      expect(tester.takeException(), isNull);
      expect(
        MediaQuery.textScalerOf(tester.element(find.text('Halo, Vaka!')))
            .scale(10),
        15,
      );
      await click(tester, find.byKey(const ValueKey('add_jajan')));
      await input(tester, 'nominal_input', '12000');
      await click(tester, find.byKey(const ValueKey('category_transport')));
      await input(tester, 'reason_input', 'Ke kampus');
      expect(tester.takeException(), isNull);
      tester.view.physicalSize = const Size(1024, 1194);
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<TextField>(find.byKey(const ValueKey('nominal_input')))
            .controller!
            .text,
        '12000',
      );
      expect(
        tester
            .widget<TextField>(find.byKey(const ValueKey('reason_input')))
            .controller!
            .text,
        'Ke kampus',
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await source.dispose();
      tester.view.resetDevicePixelRatio();
      tester.view.resetPhysicalSize();
    },
  );
}
