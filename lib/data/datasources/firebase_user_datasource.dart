import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUserDataSource {
  FirebaseUserDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _userRef(String uid) {
    return _firestore.collection('users').doc(uid);
  }

  Future<Map<String, dynamic>?> getUser(String uid) async {
    final snapshot = await _userRef(uid).get();
    return snapshot.data();
  }

  Future<void> createUser(String uid, Map<String, dynamic> data) async {
    await _userRef(uid).set(data);
  }

  Stream<Map<String, dynamic>?> streamUser(String uid) {
    return _userRef(uid).snapshots().map((snapshot) => snapshot.data());
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) {
    return _userRef(uid).update(data);
  }
}
