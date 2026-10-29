import 'package:firebase_auth/firebase_auth.dart';

import 'user_repository.dart';

class AuthException implements Exception {
  final String pesan;
  AuthException(this.pesan);

  @override
  String toString() => pesan;
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get statusLogin => _auth.authStateChanges();
  User? get penggunaSaatIni => _auth.currentUser;

  Future<void> daftar(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await UserRepository().pastikanDokumen();
    } on FirebaseAuthException catch (e) {
      throw AuthException(_pesanError(e.code));
    }
  }

  Future<void> masuk(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await UserRepository().pastikanDokumen();
    } on FirebaseAuthException catch (e) {
      throw AuthException(_pesanError(e.code));
    }
  }

  Future<void> lupaKataSandi(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw AuthException(_pesanError(e.code));
    }
  }

  Future<void> keluar() => _auth.signOut();

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
      default:
        return 'Terjadi kesalahan ($kode). Coba lagi.';
    }
  }
}
