import 'package:cloud_firestore/cloud_firestore.dart';

class Kategori {
  final String id;
  final String nama;
  final DateTime? dibuatPada;

  Kategori({required this.id, required this.nama, this.dibuatPada});

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'nama_normalisasi': nama.trim().toLowerCase(),
      'dibuat_pada': FieldValue.serverTimestamp(),
    };
  }

  factory Kategori.fromMap(String id, Map<String, dynamic> map) {
    final raw = map['dibuat_pada'];
    DateTime? dibuatPada;
    if (raw is Timestamp) {
      dibuatPada = raw.toDate();
    } else if (raw is DateTime) {
      dibuatPada = raw;
    }

    return Kategori(
      id: id,
      nama: map['nama'] as String? ?? '',
      dibuatPada: dibuatPada,
    );
  }
}
