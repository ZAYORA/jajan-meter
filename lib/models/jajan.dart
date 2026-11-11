
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

  factory Jajan.fromMap(String id, Map<String, dynamic> map) {
    return Jajan(
      id: id,
      nominal: (map['nominal'] as num).toInt(),
      kategori: map['kategori'] as String? ?? 'Lainnya',
      kategoriId: map['kategori_id'] as String?,
      alasan: map['alasan'] as String? ?? '',
      tanggal: (map['tanggal'] as Timestamp).toDate(),
      catatan: map['catatan'] as String?,
      dibuatPada: (map['dibuat_pada'] as Timestamp?)?.toDate(),
      diubahPada: (map['diubah_pada'] as Timestamp?)?.toDate(),
    );
  }
}
