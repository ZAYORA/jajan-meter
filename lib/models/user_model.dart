import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String? email;
  final String nama;
  final int jatahHarian;
  final bool onboardingSelesai;
  final String tema;
  final DateTime? dibuatPada;

  const UserModel({
    required this.uid,
    this.email,
    this.nama = '',
    this.jatahHarian = 0,
    this.onboardingSelesai = false,
    this.tema = 'terang',
    this.dibuatPada,
  });

  factory UserModel.fromMap(String uid, Map<String, dynamic> map) {
    final timestamp = map['dibuat_pada'];

    DateTime? tanggalDibuat;
    if (timestamp is Timestamp) {
      tanggalDibuat = timestamp.toDate();
    } else if (timestamp is DateTime) {
      tanggalDibuat = timestamp;
    }

    final rawNama = (map['nama'] as String?)?.trim() ?? '';
    final rawPanggilan = (map['nama_panggilan'] as String?)?.trim() ?? '';
    final namaFinal = rawPanggilan.isNotEmpty ? rawPanggilan : rawNama;

    return UserModel(
      uid: uid,
      email: map['email'] as String?,
      nama: namaFinal,
      jatahHarian: (map['jatah_harian'] as num?)?.toInt() ?? 0,
      onboardingSelesai: map['onboarding_selesai'] as bool? ?? false,
      tema: map['tema'] as String? ?? 'terang',
      dibuatPada: tanggalDibuat,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'nama': nama,
      'nama_panggilan': nama,
      'jatah_harian': jatahHarian,
      'onboarding_selesai': onboardingSelesai,
      'tema': tema,
      'dibuat_pada': dibuatPada,
    };
  }

  UserModel copyWith({
    String? email,
    String? nama,
    int? jatahHarian,
    bool? onboardingSelesai,
    String? tema,
    DateTime? dibuatPada,
  }) {
    return UserModel(
      uid: uid,
      email: email ?? this.email,
      nama: nama ?? this.nama,
      jatahHarian: jatahHarian ?? this.jatahHarian,
      onboardingSelesai: onboardingSelesai ?? this.onboardingSelesai,
      tema: tema ?? this.tema,
      dibuatPada: dibuatPada ?? this.dibuatPada,
    );
  }
}
