import 'dart:async';

import '../data/jajan_source.dart';
import '../models/jajan.dart';
import '../models/kategori.dart';

/// Hanya dipakai entrypoint demo dan tes. Tidak terhubung ke Firebase.
class DemoJajanSource implements JajanSource {
  DemoJajanSource({DateTime? date, String nama = 'Vaka', bool gelap = false}) {
    final day = date ?? DateTime.now();
    _profile = {
      'jatah_harian': 100000,
      'nama_panggilan': nama,
      'tema': gelap ? 'gelap' : 'terang',
    };
    _items = [
      Jajan(
        id: 'demo-makan',
        nominal: 20000,
        kategori: 'Makan',
        kategoriId: 'demo-cat-makan',
        alasan: 'Lapar',
        tanggal: DateTime(day.year, day.month, day.day, 12, 15),
        catatan: 'Nasi Ayam',
      ),
      Jajan(
        id: 'demo-kopi',
        nominal: 25000,
        kategori: 'Kopi',
        kategoriId: 'demo-cat-kopi',
        alasan: 'Teman belajar',
        tanggal: DateTime(day.year, day.month, day.day, 10, 30),
        catatan: 'Kopi Susu',
      ),
      Jajan(
        id: 'demo-transport',
        nominal: 10000,
        kategori: 'Transport',
        kategoriId: 'demo-cat-transport',
        alasan: 'Ke kampus',
        tanggal: DateTime(day.year, day.month, day.day, 7, 45),
        catatan: 'Ojek ke Kampus',
      ),
    ];
    _categories = [
      for (final entry in {
        'makan': 'Makan',
        'kopi': 'Kopi',
        'transport': 'Transport',
        'lainnya': 'Lainnya',
      }.entries)
        Kategori(id: 'demo-cat-${entry.key}', nama: entry.value),
    ];
  }
  late List<Jajan> _items;
  late List<Kategori> _categories;
  late Map<String, dynamic> _profile;
  final _jajanEvents = StreamController<List<Jajan>>.broadcast();
  final _categoryEvents = StreamController<List<Kategori>>.broadcast();
  final _userEvents = StreamController<Map<String, dynamic>?>.broadcast();
  int _next = 0;
  @override
  Stream<List<Jajan>> streamJajan() => Stream.multi((controller) {
    final sub = _jajanEvents.stream.listen(
      controller.add,
      onError: controller.addError,
    );
    controller.add(List.of(_items));
    controller.onCancel = sub.cancel;
  });
  @override
  Stream<List<Kategori>> streamKategori() => Stream.multi((controller) {
    final sub = _categoryEvents.stream.listen(
      controller.add,
      onError: controller.addError,
    );
    controller.add(List.of(_categories));
    controller.onCancel = sub.cancel;
  });
  @override
  Stream<Map<String, dynamic>?> streamPengguna() => Stream.multi((controller) {
    final sub = _userEvents.stream.listen(
      controller.add,
      onError: controller.addError,
    );
    controller.add(Map.of(_profile));
    controller.onCancel = sub.cancel;
  });
  @override
  Future<String> tambahJajan(Jajan value) async {
    final id = 'demo-added-${++_next}';
    _items.add(
      Jajan(
        id: id,
        nominal: value.nominal,
        kategori: value.kategori,
        kategoriId: value.kategoriId,
        alasan: value.alasan,
        tanggal: value.tanggal,
        catatan: value.catatan,
      ),
    );
    _jajanEvents.add(List.of(_items));
    return id;
  }

  @override
  Future<void> ubahJajan(Jajan value) async {
    final i = _items.indexWhere((j) => j.id == value.id);
    if (i < 0) throw StateError('Transaksi tidak ditemukan.');
    _items[i] = value;
    _jajanEvents.add(List.of(_items));
  }

  @override
  Future<void> hapusJajan(String id) async {
    _items.removeWhere((j) => j.id == id);
    _jajanEvents.add(List.of(_items));
  }

  @override
  Future<String> tambahKategori(String nama) async {
    final id = 'demo-cat-${++_next}';
    _categories.add(Kategori(id: id, nama: nama));
    _categoryEvents.add(List.of(_categories));
    return id;
  }

  @override
  Future<void> setJatahHarian(int nilai) async {
    _profile['jatah_harian'] = nilai;
    _userEvents.add(Map.of(_profile));
  }

  @override
  Future<void> setTema(String tema) async {
    _profile['tema'] = tema;
    _userEvents.add(Map.of(_profile));
  }

  Future<void> dispose() async {
    await _jajanEvents.close();
    await _categoryEvents.close();
    await _userEvents.close();
  }
}
