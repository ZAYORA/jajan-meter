import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  DocumentReference<Map<String, dynamic>> get _ref => FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  /// Membuat dokumen pengguna jika belum ada (dipanggil setelah daftar/masuk).
  Future<void> pastikanDokumen() async {
    final snap = await _ref.get();
    if (!snap.exists) {
      await _ref.set({
        'jatah_harian': 0,
        'onboarding_selesai': false,
        'tema': 'terang',
        'dibuat_pada': FieldValue.serverTimestamp(),
      });
    }
  }

  Stream<Map<String, dynamic>?> streamPengguna() =>
      _ref.snapshots().map((s) => s.data());

  Future<void> setJatahHarian(int nilai) =>
      _ref.update({'jatah_harian': nilai});

  Future<void> setTema(String tema) => _ref.update({'tema': tema});

  Future<void> selesaikanOnboarding() =>
      _ref.update({'onboarding_selesai': true});
}
