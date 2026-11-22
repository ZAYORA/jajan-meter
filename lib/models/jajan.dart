
import 'package:cloud_firestore/cloud_firestore.dart';

class Jajan {
  final String id;
  final int nominal;
  final String kategori;
  final String? kategoriId;
  final String alasan;
  final DateTime tanggal;
  final String? catatan;
  final DateTime? dibuatPada;
  final DateTime? diubahPada;

  Jajan({
    this.id = '',
    required this.nominal,
    required this.kategori,
    this.kategoriId,
    required this.alasan,
    required this.tanggal,
    this.catatan,
    this.dibuatPada,
    this.diubahPada,
  });

  Map<String, dynamic> toCreateMap() {
    return {
      'nominal': nominal,
      'kategori': kategori,
      'kategori_id': kategoriId,
      'alasan': alasan,
      'tanggal': Timestamp.fromDate(tanggal),
      'catatan': catatan,
      'dibuat_pada': FieldValue.serverTimestamp(),
      'diubah_pada': FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      'nominal': nominal,
      'kategori': kategori,
      'kategori_id': kategoriId,
      'alasan': alasan,
      'tanggal': Timestamp.fromDate(tanggal),
      'catatan': catatan,
      'diubah_pada': FieldValue.serverTimestamp(),
    };
  }

  static DateTime? _parseTanggal(Object? raw) {
    if (raw is Timestamp) return raw.toDate();
    if (raw is DateTime) return raw;
    if (raw is String) return DateTime.tryParse(raw);
    if (raw is int) return DateTime.fromMillisecondsSinceEpoch(raw);
    return null;
  }

  factory Jajan.fromMap(String id, Map<String, dynamic> map) {
    final nominalRaw = map['nominal'];
    final nominal = nominalRaw is num
        ? nominalRaw.toInt()
        : int.tryParse(nominalRaw?.toString() ?? '') ?? 0;

    return Jajan(
      id: id,
      nominal: nominal,
      kategori: map['kategori'] as String? ?? 'Lainnya',
      kategoriId: map['kategori_id'] as String?,
      alasan: map['alasan'] as String? ?? '',
      tanggal: _parseTanggal(map['tanggal']) ?? DateTime.now(),
      catatan: map['catatan'] as String?,
      dibuatPada: _parseTanggal(map['dibuat_pada']),
      diubahPada: _parseTanggal(map['diubah_pada']),
    );
  }
}
