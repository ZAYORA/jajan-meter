import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthDataSource {
  FirebaseAuthDataSource({FirebaseAuth? firebaseAuth})
    : _auth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  Stream<User?> get statusLogin => _auth.authStateChanges();

  User? get penggunaSaatIni => _auth.currentUser;

  Future<UserCredential> daftar({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential> masuk({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> lupaKataSandi(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> keluar() async {
    await _auth.signOut();
  }
}
