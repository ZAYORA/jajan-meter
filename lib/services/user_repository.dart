
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/datasources/firebase_user_datasource.dart';
import '../models/user_model.dart';

class UserRepository {
  UserRepository({
    String? uid,
    FirebaseUserDataSource? dataSource,
    FirebaseAuth? firebaseAuth,
  }) : _sessionUid = uid,
       _dataSource = dataSource ?? FirebaseUserDataSource(),
       _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final String? _sessionUid;
  final FirebaseUserDataSource _dataSource;
  final FirebaseAuth _firebaseAuth;

  String get _uid {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw StateError('Pengguna belum login.');
    }
    if (_sessionUid != null && user.uid != _sessionUid) {
      throw StateError('Sesi akun sudah berubah.');
    }
    return _sessionUid ?? user.uid;
  }

  /// Membuat dokumen pengguna jika belum ada.
  /// Bisa sekaligus menyimpan nama saat pendaftaran.
  Future<UserModel> pastikanDokumen({String nama = ''}) async {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      throw StateError('Pengguna belum login.');
    }

    final namaBersih = nama.trim();
    final data = await _dataSource.getUser(user.uid);

    if (data == null) {
      final model = UserModel(
        uid: user.uid,
        email: user.email,
        nama: namaBersih,
        jatahHarian: 0,
        onboardingSelesai: false,
        tema: 'terang',
      );

      await _dataSource.createUser(user.uid, {
        ...model.toMap(),
        'dibuat_pada': FieldValue.serverTimestamp(),
      });

      return model;
    }

    final model = UserModel.fromMap(user.uid, data);

    if (namaBersih.isNotEmpty && model.nama.isEmpty) {
      await _dataSource.updateUser(user.uid, {
        'nama': namaBersih,
        'nama_panggilan': namaBersih,
      });
      return model.copyWith(nama: namaBersih);
    }

    return model;
  }

  /// Mengambil data pengguna sekali.
  Future<UserModel?> getPengguna() async {
    final uid = _uid;
    final data = await _dataSource.getUser(uid);

    if (data == null) return null;

    return UserModel.fromMap(uid, data);
  }

  /// Mengambil data pengguna secara realtime dalam bentuk UserModel.
  Stream<UserModel?> streamPengguna() {
    final uid = _uid;
    return _dataSource.streamUser(uid).map((data) {
      if (data == null) return null;
      return UserModel.fromMap(uid, data);
    });
  }

  /// Mengambil data pengguna secara realtime dalam bentuk Map untuk JajanSource.
  Stream<Map<String, dynamic>?> streamPenggunaMap() {
    final uid = _uid;
    return _dataSource.streamUser(uid);
  }

  /// Mengubah jatah jajan harian.
  Future<void> setJatahHarian(int nilai) {
    if (nilai < 0) {
      throw ArgumentError('Jatah harian tidak boleh negatif.');
    }

    return _dataSource.updateUser(_uid, {
      'jatah_harian': nilai,
    });
  }

  /// Mengubah nama panggilan pengguna.
  Future<void> setNamaPanggilan(String nama) {
    final namaBersih = nama.trim();
    return _dataSource.updateUser(_uid, {
      'nama': namaBersih,
      'nama_panggilan': namaBersih,
    });
  }

  /// Mengubah tema pengguna.
  Future<void> setTema(String tema) {
    if (!['terang', 'gelap', 'sistem'].contains(tema)) {
      throw ArgumentError('Tema tidak valid.');
    }

    return _dataSource.updateUser(_uid, {
      'tema': tema,
    });
  }

  /// Menandai onboarding telah selesai.
  Future<void> selesaikanOnboarding() {
    return _dataSource.updateUser(_uid, {
      'onboarding_selesai': true,
    });
  }
}
