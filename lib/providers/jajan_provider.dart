import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../data/jajan_source.dart';
import '../models/jajan.dart';
import '../models/kategori.dart';
import '../utils/calculator.dart';
import 'jajan_category.dart';

enum PeriodeJajan { hari, minggu, bulan }

DateTime tanggalLokal(DateTime value) {
  final local = value.toLocal();
  return DateTime(local.year, local.month, local.day);
}

String kunciHari(DateTime value) {
  final local = tanggalLokal(value);
  return '${local.year.toString().padLeft(4, '0')}-'
      '${local.month.toString().padLeft(2, '0')}-'
      '${local.day.toString().padLeft(2, '0')}';
}

/// State satu akun. Semua layar membaca stream yang sama; nilai uang tetap int.
/// Hari memakai zona lokal perangkat. Rentang [awal, akhir) menghindari dobel
/// hitung transaksi tepat tengah malam. Minggu dimulai pada Senin.
class JajanProvider extends ChangeNotifier {
  JajanProvider({
    required this._source,
    DateTime Function()? now,
    bool autoRefreshClock = true,
  }) : _now = now ?? DateTime.now {
    _hariIni = tanggalLokal(_now());
    _tanggalFilter = _hariIni;
    if (autoRefreshClock) {
      _timer = Timer.periodic(
        const Duration(minutes: 1),
        (_) => refreshClock(),
      );
    }
  }

  final JajanSource _source;
  final DateTime Function() _now;
  final _subscriptions = <StreamSubscription<dynamic>>[];
  final _ready = <String>{};
  final _loaded = <String>{};
  final _errors = <String, String>{};
  List<Jajan> _items = [];
  List<Kategori> _kategori = [];
  Map<String, dynamic> _profil = {};
  final Map<String, Kategori> _createdCategories = {};
  Timer? _timer;
  bool _disposed = false;
  bool _busy = false;
  int _generation = 0;
  String? _writeError;
  late DateTime _hariIni;
  late DateTime _tanggalFilter;
  bool _ikutiHariIni = true;
  PeriodeJajan _periode = PeriodeJajan.hari;
  String? _kategoriFilter;

  List<Jajan> get daftarJajan => List.unmodifiable(_items);
  List<Kategori> get kategori => List.unmodifiable(_kategori);
  bool get isLoading => _ready.length < 3;
  bool get isSaving => _busy;
  bool get hasData => _loaded.contains('transaksi');
  bool get hasProfile => _loaded.contains('profil');
  bool get isReady => _loaded.length == 3;
  bool get isEmpty => hasData && _items.isEmpty;
  String? get error => _errors.isEmpty ? null : _errors.values.join('\n');
  String? get actionError => _writeError;
  DateTime get hariIni => _hariIni;
  DateTime get sekarang => _now().toLocal();
  String get namaPanggilan {
    final nama = _profil['nama_panggilan'];
    return nama is String && nama.trim().isNotEmpty
        ? nama.trim()
        : 'teman jajan';
  }

  int get jatahHarian {
    final value = _profil['jatah_harian'];
    return value is num && value.isFinite && value > 0 ? value.toInt() : 0;
  }

  bool get hasBudget => jatahHarian > 0;
  ThemeMode get themeMode =>
      _profil['tema'] == 'gelap' ? ThemeMode.dark : ThemeMode.light;

  Map<String, dynamic> _row(Jajan jajan, {bool namaHari = false}) => {
    'nominal': jajan.nominal,
    'hari': namaHari
        ? const [
            'Senin',
            'Selasa',
            'Rabu',
            'Kamis',
            'Jumat',
            'Sabtu',
            'Minggu',
          ][jajan.tanggal.toLocal().weekday - 1]
        : kunciHari(jajan.tanggal),
    'kategori': jajan.kategori,
    'alasan': jajan.alasan,
  };

  List<Jajan> get jajanHariIni => List.unmodifiable(
    _items.where((j) => kunciHari(j.tanggal) == kunciHari(_hariIni)),
  );
  int get totalHariIni => JajanCalculator.hitungTotalHariIni(
    _items.map((j) => _row(j)).toList(),
    kunciHari(_hariIni),
  );
  int get sisaJatah =>
      JajanCalculator.hitungSisaJatah(jatahHarian, totalHariIni);
  double get persenTerpakai =>
      JajanCalculator.hitungPersenTerpakai(totalHariIni, jatahHarian);
  double get progresTerpakai => persenTerpakai / 100;
  double get persenSisa =>
      hasBudget ? (100 - persenTerpakai).clamp(0.0, 100.0) : 0;
  double get progresSisa => persenSisa / 100;
  bool get peringatanAktif =>
      JajanCalculator.isPeringatanAktif(sisaJatah, jatahHarian);
  String get statusTarget => hasBudget
      ? JajanCalculator.getStatusTarget(totalHariIni, jatahHarian)
      : 'Belum diatur';

  PeriodeJajan get periode => _periode;
  DateTime get tanggalFilter => _tanggalFilter;
  String? get kategoriFilter => _kategoriFilter;
  DateTime get awalRentang => switch (_periode) {
    PeriodeJajan.hari => _tanggalFilter,
    PeriodeJajan.minggu => DateTime(
      _tanggalFilter.year,
      _tanggalFilter.month,
      _tanggalFilter.day - (_tanggalFilter.weekday - 1),
    ),
    PeriodeJajan.bulan => DateTime(_tanggalFilter.year, _tanggalFilter.month),
  };
  DateTime get akhirRentang => switch (_periode) {
    PeriodeJajan.hari => DateTime(
      awalRentang.year,
      awalRentang.month,
      awalRentang.day + 1,
    ),
    PeriodeJajan.minggu => DateTime(
      awalRentang.year,
      awalRentang.month,
      awalRentang.day + 7,
    ),
    PeriodeJajan.bulan => DateTime(awalRentang.year, awalRentang.month + 1),
  };
  List<Jajan> _rentang(DateTime start, DateTime end) => _items.where((j) {
    final waktu = j.tanggal.toLocal();
    return !waktu.isBefore(start) && waktu.isBefore(end);
  }).toList();
  List<Jajan> get transaksiTerfilter => List.unmodifiable(
    _rentang(awalRentang, akhirRentang).where(
      (j) =>
          _kategoriFilter == null ||
          kelompokKategori(j.kategori) == _kategoriFilter,
    ),
  );
  int get totalTerfilter =>
      transaksiTerfilter.fold(0, (total, j) => total + j.nominal);
  List<Jajan> get transaksiMingguIni {
    final start = DateTime(
      _hariIni.year,
      _hariIni.month,
      _hariIni.day - (_hariIni.weekday - 1),
    );
    return List.unmodifiable(
      _rentang(start, DateTime(start.year, start.month, start.day + 7)),
    );
  }

  Map<String, dynamic> get rekapMingguan => Map.unmodifiable(
    JajanCalculator.hitungRekapMingguan(
      transaksiMingguIni.map((j) => _row(j, namaHari: true)).toList(),
    ),
  );
  Map<String, int> get totalPerHariMingguIni {
    final start = DateTime(
      _hariIni.year,
      _hariIni.month,
      _hariIni.day - (_hariIni.weekday - 1),
    );
    return Map.unmodifiable({
      for (var i = 0; i < 7; i++)
        kunciHari(
          DateTime(start.year, start.month, start.day + i),
        ): JajanCalculator.hitungTotalHariIni(
          transaksiMingguIni.map((j) => _row(j)).toList(),
          kunciHari(DateTime(start.year, start.month, start.day + i)),
        ),
    });
  }

  Map<String, int> _kelompok(String Function(Jajan) key) {
    final hasil = <String, int>{};
    for (final j in transaksiMingguIni) {
      hasil.update(
        key(j),
        (value) => value + j.nominal,
        ifAbsent: () => j.nominal,
      );
    }
    return Map.unmodifiable(hasil);
  }

  Map<String, int> get totalPerKategoriMingguIni =>
      _kelompok((j) => j.kategori);
  Map<String, int> get totalPerAlasanMingguIni => _kelompok((j) => j.alasan);
  Jajan? cariJajan(String id) => _items.where((j) => j.id == id).firstOrNull;

  void setFilter({PeriodeJajan? periode, DateTime? tanggal}) {
    if (periode != null) _periode = periode;
    if (tanggal != null) {
      _tanggalFilter = tanggalLokal(tanggal);
      _ikutiHariIni = _tanggalFilter == _hariIni;
    }
    _notify();
  }

  void setKategoriFilter(String? value) {
    if (value != null && !labelKategori.containsKey(value)) return;
    _kategoriFilter = value;
    _notify();
  }

  void refreshClock() {
    final today = tanggalLokal(_now());
    if (today == _hariIni || _disposed) return;
    _hariIni = today;
    if (_ikutiHariIni) _tanggalFilter = today;
    _notify();
  }

  Future<void> mulai() async {
    if (_disposed) return;
    final generation = ++_generation;
    final old = List<StreamSubscription<dynamic>>.of(_subscriptions);
    _subscriptions.clear();
    _ready.clear();
    _errors.clear();
    _notify();
    // Jangan menahan retry pada acknowledgement pembatalan stream jaringan.
    // Generation guard di semua callback mengabaikan event stream sebelumnya.
    for (final subscription in old) {
      unawaited(subscription.cancel());
    }
    if (_disposed || generation != _generation) return;
    void listen<T>(
      String name,
      Stream<T> Function() stream,
      void Function(T) data,
    ) {
      void failed(Object e) {
        if (_disposed || generation != _generation) return;
        _ready.add(name);
        _errors[name] = 'Gagal memuat $name. ${_pesanError(e)}';
        _notify();
      }

      try {
        _subscriptions.add(
          stream().listen((value) {
            if (_disposed || generation != _generation) return;
            data(value);
            _ready.add(name);
            _loaded.add(name);
            _errors.remove(name);
            _notify();
          }, onError: failed),
        );
      } catch (e) {
        failed(e);
      }
    }

    listen('transaksi', _source.streamJajan, (data) {
      _items = List<Jajan>.of(data)
        ..sort((a, b) {
          final date = b.tanggal.compareTo(a.tanggal);
          return date == 0 ? a.id.compareTo(b.id) : date;
        });
    });
    listen(
      'kategori',
      _source.streamKategori,
      (data) => _kategori = List.of(data),
    );
    listen(
      'profil',
      _source.streamPengguna,
      (data) => _profil = Map.of(data ?? {}),
    );
  }

  Future<void> cobaLagi() => mulai();

  Future<T?> _write<T>(Future<T> Function() action) async {
    if (_disposed || _busy) return null;
    _busy = true;
    _writeError = null;
    _notify();
    try {
      final result = await action();
      return _disposed ? null : result;
    } catch (e) {
      if (!_disposed) _writeError = _pesanError(e);
      return null;
    } finally {
      _busy = false;
      _notify();
    }
  }

  Future<String?> simpanJajan({
    Jajan? original,
    required int nominal,
    required String kelompok,
    required String alasan,
    required DateTime tanggal,
    String? catatan,
  }) => _write(() async {
    if (!isReady) {
      throw const FormatException('Tunggu data akun selesai dimuat.');
    }
    if (nominal <= 0 || nominal > 999999999999) {
      throw const FormatException(
        'Isi nominal antara Rp1 dan Rp999.999.999.999.',
      );
    }
    if (alasan.trim().isEmpty) {
      throw const FormatException('Alasan jajan wajib diisi.');
    }
    if (!labelKategori.containsKey(kelompok)) {
      throw const FormatException('Pilih kategori jajan.');
    }
    if (original != null && cariJajan(original.id) == null) {
      throw const FormatException(
        'Transaksi ini sudah dihapus. Kembali ke Riwayat.',
      );
    }
    String? idKategori;
    String namaKategori;
    if (original != null && kelompokKategori(original.kategori) == kelompok) {
      // Termasuk kategori custom/legacy: edit nominal tidak merusak identitasnya.
      idKategori = original.kategoriId;
      namaKategori = original.kategori;
    } else {
      final canonical = labelKategori[kelompok]!;
      var existing = _kategori
          .where((k) => k.nama.trim().toLowerCase() == canonical.toLowerCase())
          .firstOrNull;
      existing ??= _kategori
          .where(
            (k) =>
                kelompok != 'lainnya' && kelompokKategori(k.nama) == kelompok,
          )
          .firstOrNull;
      existing ??= _createdCategories[kelompok];
      if (existing == null) {
        final id = await _source.tambahKategori(canonical);
        existing = Kategori(id: id, nama: canonical);
        _createdCategories[kelompok] = existing;
      }
      idKategori = existing.id;
      namaKategori = existing.nama;
    }
    if (_disposed) return '';
    final value = Jajan(
      id: original?.id ?? '',
      nominal: nominal,
      kategori: namaKategori,
      kategoriId: idKategori,
      alasan: alasan.trim(),
      tanggal: tanggal,
      catatan: catatan?.trim().isEmpty ?? true ? null : catatan!.trim(),
      dibuatPada: original?.dibuatPada,
    );
    if (original == null) return _source.tambahJajan(value);
    await _source.ubahJajan(value);
    return value.id;
  });

  Future<bool> hapusJajan(String id) async =>
      await _write(() async {
        if (id.isEmpty || cariJajan(id) == null) {
          throw const FormatException('Transaksi tidak ditemukan.');
        }
        await _source.hapusJajan(id);
        return true;
      }) ??
      false;
  Future<bool> setJatahHarian(int nilai) async =>
      await _write(() async {
        if (nilai < 0 || nilai > 999999999999) {
          throw const FormatException('Jatah harus berupa rupiah yang valid.');
        }
        await _source.setJatahHarian(nilai);
        return true;
      }) ??
      false;
  Future<bool> setTema(bool gelap) async =>
      await _write(() async {
        await _source.setTema(gelap ? 'gelap' : 'terang');
        return true;
      }) ??
      false;

  String _pesanError(Object e) {
    if (e is FormatException) return e.message;
    if (e is FirebaseException) {
      return switch (e.code) {
        'permission-denied' =>
          'Akses data ditolak. Hubungi pengelola aplikasi.',
        'unauthenticated' => 'Sesi berakhir. Silakan masuk kembali.',
        'unavailable' || 'deadline-exceeded' =>
          'Koneksi bermasalah. Periksa internet dan coba lagi.',
        _ => 'Data belum berhasil diproses. Coba lagi.',
      };
    }
    return 'Data belum berhasil diproses. Periksa koneksi atau masuk kembali.';
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    ++_generation;
    _timer?.cancel();
    for (final subscription in _subscriptions) {
      unawaited(subscription.cancel());
    }
    _subscriptions.clear();
    _items = [];
    _kategori = [];
    _profil = {};
    _createdCategories.clear();
    super.dispose();
  }
}
