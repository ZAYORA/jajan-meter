import 'dart:async';

import 'package:jajan_meter/data/jajan_source.dart';
import 'package:jajan_meter/models/jajan.dart';
import 'package:jajan_meter/models/kategori.dart';

class FakeJajanSource implements JajanSource {
  List<Jajan> items = [];
  List<Kategori> categories = [
    Kategori(id: 'food', nama: 'Makan'),
    Kategori(id: 'coffee', nama: 'Kopi'),
    Kategori(id: 'transport', nama: 'Transport'),
    Kategori(id: 'other', nama: 'Lainnya'),
  ];
  Map<String, dynamic> profile = {
    'jatah_harian': 100000,
    'nama_panggilan': 'Vaka',
    'tema': 'terang',
  };
  final jajanEvents = StreamController<List<Jajan>>.broadcast();
  final categoryEvents = StreamController<List<Kategori>>.broadcast();
  final userEvents = StreamController<Map<String, dynamic>?>.broadcast();
  bool failRead = false, failWrite = false;
  int writes = 0, categoryWrites = 0, cancelled = 0;
  Completer<void>? holdWrite, holdCategory;
  @override
  Stream<List<Jajan>> streamJajan() => Stream.multi((sink) {
    final sub = jajanEvents.stream.listen(sink.add, onError: sink.addError);
    if (failRead) {
      sink.addError(StateError('read failure'));
    } else {
      sink.add(List.of(items));
    }
    sink.onCancel = () {
      cancelled++;
      return sub.cancel();
    };
  });
  @override
  Stream<List<Kategori>> streamKategori() => Stream.multi((sink) {
    final sub = categoryEvents.stream.listen(sink.add, onError: sink.addError);
    sink.add(List.of(categories));
    sink.onCancel = () {
      cancelled++;
      return sub.cancel();
    };
  });
  @override
  Stream<Map<String, dynamic>?> streamPengguna() => Stream.multi((sink) {
    final sub = userEvents.stream.listen(sink.add, onError: sink.addError);
    sink.add(Map.of(profile));
    sink.onCancel = () {
      cancelled++;
      return sub.cancel();
    };
  });
  void emit() => jajanEvents.add(List.of(items));
  void emitProfile() => userEvents.add(Map.of(profile));
  Future<void> _check() async {
    if (holdWrite != null) await holdWrite!.future;
    if (failWrite) throw StateError('write failure');
  }

  @override
  Future<String> tambahJajan(Jajan j) async {
    writes++;
    await _check();
    final id = 'new-$writes';
    items.add(
      Jajan(
        id: id,
        nominal: j.nominal,
        kategori: j.kategori,
        kategoriId: j.kategoriId,
        alasan: j.alasan,
        tanggal: j.tanggal,
        catatan: j.catatan,
      ),
    );
    emit();
    return id;
  }

  @override
  Future<void> ubahJajan(Jajan j) async {
    writes++;
    await _check();
    final i = items.indexWhere((old) => old.id == j.id);
    if (i < 0) throw StateError('missing');
    items[i] = j;
    emit();
  }

  @override
  Future<void> hapusJajan(String id) async {
    writes++;
    await _check();
    items.removeWhere((j) => j.id == id);
    emit();
  }

  @override
  Future<String> tambahKategori(String nama) async {
    categoryWrites++;
    if (holdCategory != null) await holdCategory!.future;
    final id = 'category-$categoryWrites';
    categories.add(Kategori(id: id, nama: nama));
    // Sengaja tidak emit: menguji cache ID sementara sebelum stream menyusul.
    return id;
  }

  @override
  Future<void> setJatahHarian(int nilai) async {
    await _check();
    profile['jatah_harian'] = nilai;
    emitProfile();
  }

  @override
  Future<void> setTema(String tema) async {
    await _check();
    profile['tema'] = tema;
    emitProfile();
  }

  Future<void> dispose() async {
    await jajanEvents.close();
    await categoryEvents.close();
    await userEvents.close();
  }
}
