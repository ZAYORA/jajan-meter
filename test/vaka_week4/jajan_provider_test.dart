import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:jajan_meter/models/jajan.dart';
import 'package:jajan_meter/models/kategori.dart';
import 'package:jajan_meter/providers/jajan_provider.dart';

import 'fake_jajan_source.dart';

final today = DateTime(2026, 11, 3, 15);
Jajan item(
  String id,
  int value,
  DateTime date, {
  String category = 'Makan',
  String? categoryId = 'food',
  String reason = 'Lapar',
}) => Jajan(
  id: id,
  nominal: value,
  kategori: category,
  kategoriId: categoryId,
  alasan: reason,
  tanggal: date,
);
Future<void> flush() => Future<void>.delayed(Duration.zero);

void main() {
  late FakeJajanSource source;
  late JajanProvider p;
  setUp(() {
    source = FakeJajanSource();
    p = JajanProvider(
      source: source,
      now: () => today,
      autoRefreshClock: false,
    );
  });
  tearDown(() async {
    p.dispose();
    await source.dispose();
  });
  Future<void> load() async {
    await p.mulai();
    await flush();
  }

  Future<String?> save({
    Jajan? original,
    int amount = 10000,
    String category = 'makan',
    String reason = 'Lapar',
    DateTime? date,
  }) => p.simpanJajan(
    original: original,
    nominal: amount,
    kelompok: category,
    alasan: reason,
    tanggal: date ?? today,
  );

  test(
    'stream menjadi satu sumber angka; daftar getter tidak bisa dimutasi',
    () async {
      source.items = [
        item('a', 20000, today),
        item('b', 25000, today),
        item('c', 10000, today),
      ];
      expect(p.isLoading, isTrue);
      await load();
      expect(p.isLoading, isFalse);
      expect(p.isReady, isTrue);
      expect(p.totalHariIni, 55000);
      expect(p.sisaJatah, 45000);
      expect(p.persenTerpakai, closeTo(55, 1e-9));
      expect(p.progresSisa, closeTo(.45, 1e-9));
      expect(p.namaPanggilan, 'Vaka');
      expect(p.peringatanAktif, isFalse);
      expect(() => p.daftarJajan.clear(), throwsUnsupportedError);
    },
  );
  test('jatah nol, batas tepat 20 persen, dan melebihi jatah', () async {
    source.items = [item('a', 80000, today)];
    await load();
    expect(p.peringatanAktif, isTrue);
    expect(p.sisaJatah, 20000);
    source.items = [item('a', 120000, today)];
    source.emit();
    await flush();
    expect(p.sisaJatah, -20000);
    expect(p.persenTerpakai, 100);
    expect(p.progresSisa, 0);
    expect(p.statusTarget, 'Terlampaui');
    await p.setJatahHarian(0);
    await flush();
    expect(p.statusTarget, 'Belum diatur');
    expect(p.peringatanAktif, isFalse);
    expect(p.persenTerpakai, 0);
    expect(p.persenSisa, 0);
  });
  test(
    'filter hari minggu bulan memakai awal inklusif akhir eksklusif',
    () async {
      source.items = [
        item('oct', 1, DateTime(2026, 10, 31, 23, 59)),
        item('sun', 2, DateTime(2026, 11, 1, 23, 59)),
        item('mon', 4, DateTime(2026, 11, 2)),
        item('tue', 8, DateTime(2026, 11, 3)),
        item('wed', 16, DateTime(2026, 11, 4)),
        item('nextmon', 32, DateTime(2026, 11, 9)),
        item('dec', 64, DateTime(2026, 12, 1)),
      ];
      await load();
      expect(p.totalHariIni, 8);
      expect(p.totalTerfilter, 8);
      p.setFilter(periode: PeriodeJajan.minggu);
      expect(p.totalTerfilter, 28);
      p.setFilter(periode: PeriodeJajan.bulan);
      expect(p.totalTerfilter, 62);
      expect(p.akhirRentang, DateTime(2026, 12, 1));
      p.setFilter(tanggal: DateTime(2026, 12, 1));
      expect(p.totalTerfilter, 64);
    },
  );
  test(
    'empat filter mengelompokkan kategori lama tanpa mengubah data',
    () async {
      source.items = [
        item('a', 3, today, category: 'Makan berat'),
        item('b', 4, today, category: 'Skincare', categoryId: 'custom'),
      ];
      await load();
      p.setKategoriFilter('lainnya');
      expect(p.totalTerfilter, 4);
      expect(p.transaksiTerfilter.single.kategoriId, 'custom');
      p.setKategoriFilter('makan');
      expect(p.totalTerfilter, 3);
      p.setKategoriFilter(null);
      expect(p.totalTerfilter, 7);
    },
  );
  test('adapter Salsa menghasilkan contoh Tabel 3.10 dan tetap mempertahankan nama kategori', () async {
    final values = [15000, 25000, 15000, 18000, 12000, 20000, 18000, 12000];
    final days = [2, 3, 4, 4, 5, 6, 7, 8];
    final cats = [
      'Kopi/minum',
      'Makan berat',
      'Kopi/minum',
      'Makan berat',
      'Camilan',
      'Makan berat',
      'Makan berat',
      'Transport',
    ];
    final reasons = [
      'Stres',
      'Lapar',
      'Stres',
      'Lapar',
      'Ikut teman',
      'Lapar',
      'Hadiah',
      '',
    ];
    source.items = [
      for (var i = 0; i < values.length; i++)
        item(
          '$i',
          values[i],
          DateTime(2026, 11, days[i]),
          category: cats[i],
          reason: reasons[i],
        ),
    ];
    await load();
    expect(p.rekapMingguan, {
      'total': 135000,
      'hariTerboros': 'Rabu',
      'kategoriTerbanyak': 'Makan berat',
      'alasanTerbanyak': 'Lapar',
    });
    expect(p.totalPerHariMingguIni['2026-11-04'], 33000);
    expect(p.totalPerKategoriMingguIni['Makan berat'], 81000);
    expect(p.totalPerAlasanMingguIni['Lapar'], 63000);
  });
  test(
    'validasi nominal nol/negatif dan alasan kosong tidak menyentuh repository',
    () async {
      await load();
      expect(await save(amount: 0), isNull);
      expect(await save(amount: -1), isNull);
      expect(await save(reason: '  '), isNull);
      expect(source.writes, 0);
      expect(p.actionError, isNotNull);
    },
  );
  test('tambah memakai ID repository; edit kategori custom mempertahankan ID dan nama', () async {
    source.categories = [Kategori(id: 'old-food', nama: 'Makan berat')];
    source.items = [
      item('old', 7000, today, category: 'Skincare', categoryId: 'custom-old'),
    ];
    await load();
    await save();
    await flush();
    expect(source.items.last.kategoriId, 'old-food');
    expect(source.items.last.kategori, 'Makan berat');
    await save(original: p.cariJajan('old'), amount: 8000, category: 'lainnya');
    await flush();
    expect(p.cariJajan('old')!.kategoriId, 'custom-old');
    expect(p.cariJajan('old')!.kategori, 'Skincare');
    expect(source.categoryWrites, 0);
  });
  test(
    'kategori yang belum ada dibuat sekali dengan ID nyata, bukan kode UI',
    () async {
      source.categories = [];
      await load();
      await save(category: 'kopi');
      await flush();
      await save(category: 'kopi');
      await flush();
      expect(source.categoryWrites, 1);
      expect(source.items.last.kategoriId, 'category-1');
      expect(source.items.last.kategori, 'Kopi');
    },
  );
  test('edit memindah tanggal lalu hapus memperbarui semua total', () async {
    source.items = [item('old', 20000, today)];
    await load();
    await save(
      original: p.cariJajan('old'),
      amount: 25000,
      date: DateTime(2026, 11, 2),
    );
    await flush();
    expect(p.totalHariIni, 0);
    expect(p.totalTerfilter, 0);
    expect(p.sisaJatah, 100000);
    p.setFilter(periode: PeriodeJajan.minggu);
    expect(p.totalTerfilter, 25000);
    expect(await p.hapusJajan('old'), isTrue);
    await flush();
    expect(p.totalTerfilter, 0);
    expect(p.isEmpty, isTrue);
  });
  test('error baca dapat dicoba lagi; stream lama dibatalkan', () async {
    source.failRead = true;
    await load();
    expect(p.error, isNotNull);
    expect(p.hasData, isFalse);
    source.failRead = false;
    await p.cobaLagi();
    await flush();
    expect(source.cancelled, 3);
    expect(p.error, isNull);
    expect(p.isEmpty, isTrue);
  });
  test('gagal simpan tidak mengubah daftar dan bisa dicoba ulang', () async {
    await load();
    source.failWrite = true;
    expect(await save(), isNull);
    expect(source.items, isEmpty);
    expect(p.isSaving, isFalse);
    source.failWrite = false;
    expect(await save(), isNotNull);
    await flush();
    expect(p.daftarJajan.length, 1);
  });
  test('double submit dibatasi satu operasi repository', () async {
    await load();
    source.holdWrite = Completer<void>();
    final first = save();
    await flush();
    expect(p.isSaving, isTrue);
    expect(await save(), isNull);
    expect(source.writes, 1);
    source.holdWrite!.complete();
    await first;
    await flush();
    expect(p.daftarJajan.length, 1);
  });
  test('tanggal UI mengikuti pergantian hari dan pulih saat aplikasi dibuka kembali', () async {
    var now = DateTime(2026, 11, 3, 23, 59);
    final clockProvider = JajanProvider(
      source: source,
      now: () => now,
      autoRefreshClock: false,
    );
    await clockProvider.mulai();
    await flush();
    now = DateTime(2026, 11, 4);
    clockProvider.refreshClock();
    expect(clockProvider.hariIni, DateTime(2026, 11, 4));
    expect(clockProvider.tanggalFilter, DateTime(2026, 11, 4));
    clockProvider.setFilter(tanggal: DateTime(2026, 11, 1));
    now = DateTime(2026, 11, 5);
    clockProvider.refreshClock();
    expect(clockProvider.tanggalFilter, DateTime(2026, 11, 1));
    clockProvider.dispose();
  });
  test('dispose ketika kategori sedang dibuat tidak melanjutkan transaksi akun lama', () async {
    final scoped = JajanProvider(
      source: source,
      now: () => today,
      autoRefreshClock: false,
    );
    source.categories = [];
    await scoped.mulai();
    await flush();
    source.holdCategory = Completer<void>();
    final pending = scoped.simpanJajan(
      nominal: 1000,
      kelompok: 'makan',
      alasan: 'Lapar',
      tanggal: today,
    );
    await flush();
    scoped.dispose();
    source.holdCategory!.complete();
    expect(await pending, isNull);
    expect(source.writes, 0);
    expect(scoped.daftarJajan, isEmpty);
  });
}
