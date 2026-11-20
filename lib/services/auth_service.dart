import 'package:firebase_auth/firebase_auth.dart';

import '../data/datasources/firebase_auth_datasource.dart';
import 'user_repository.dart';

class AuthException implements Exception {
  final String pesan;

  AuthException(this.pesan);

  @override
  String toString() => pesan;
}

class AuthService {
  AuthService({
    FirebaseAuthDataSource? authDataSource,
    UserRepository? userRepository,
  }) : _dataSource = authDataSource ?? FirebaseAuthDataSource(),
       _userRepository = userRepository ?? UserRepository();

  final FirebaseAuthDataSource _dataSource;
  final UserRepository _userRepository;

  Stream<User?> get statusLogin => _dataSource.statusLogin;

  User? get penggunaSaatIni => _dataSource.penggunaSaatIni;

  bool _emailValid(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email.trim());
  }

  Future<void> daftar(String nama, String email, String password) async {
    if (nama.trim().isEmpty) {
      throw AuthException('Nama tidak boleh kosong.');
    }

    if (nama.trim().length > 30) {
      throw AuthException('Nama maksimal 30 karakter.');
    }

    if (email.trim().isEmpty || !_emailValid(email)) {
      throw AuthException('Format email tidak valid.');
    }

    if (password.isEmpty) {
      throw AuthException('Kata sandi tidak boleh kosong.');
    }

    if (password.length < 6) {
      throw AuthException('Kata sandi minimal 6 karakter.');
    }

    try {
      await _dataSource.daftar(email: email.trim(), password: password);

      await _userRepository.pastikanDokumen(nama: nama.trim());
    } on FirebaseAuthException catch (e) {
      throw AuthException(_pesanError(e.code));
    }
  }

  Future<void> masuk(String email, String password) async {
    if (email.trim().isEmpty || !_emailValid(email)) {
      throw AuthException('Format email tidak valid.');
    }

    if (password.isEmpty) {
      throw AuthException('Kata sandi tidak boleh kosong.');
    }

    try {
      await _dataSource.masuk(email: email.trim(), password: password);

      await _userRepository.pastikanDokumen();
    } on FirebaseAuthException catch (e) {
      throw AuthException(_pesanError(e.code));
    }
  }

  Future<void> lupaKataSandi(String email) async {
    if (email.trim().isEmpty || !_emailValid(email)) {
      throw AuthException('Format email tidak valid.');
    }

    try {
      await _dataSource.lupaKataSandi(email.trim());
    } on FirebaseAuthException catch (e) {
      throw AuthException(_pesanError(e.code));
    }
  }

  Future<void> keluar() => _dataSource.keluar();

  String _pesanError(String kode) {
    switch (kode) {
      case 'email-already-in-use':
        return 'Email sudah terdaftar. Silakan masuk.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'weak-password':
        return 'Kata sandi terlalu lemah (minimal 6 karakter).';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email atau kata sandi salah.';
      case 'user-disabled':
        return 'Akun ini dinonaktifkan.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Coba lagi nanti.';
      case 'network-request-failed':
        return 'Koneksi bermasalah. Periksa internet lalu coba lagi.';
      case 'operation-not-allowed':
        return 'Metode autentikasi email/password belum diaktifkan.';
      default:
        return 'Terjadi kesalahan ($kode). Coba lagi.';
    }
  }
}
