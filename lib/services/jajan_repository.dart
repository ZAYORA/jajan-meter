import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/jajan.dart';

class JajanRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get _uid {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('Pengguna belum login.');
    }

    return user.uid;
  }

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('users').doc(_uid).collection('jajan');

  Future<String> tambahJajan(Jajan jajan) async {
    if (jajan.nominal <= 0) {
      throw Exception('Nominal jajan harus lebih dari 0.');
    }

    final doc = await _collection.add(jajan.toCreateMap());
    return doc.id;
  }

  Stream<List<Jajan>> streamJajan() {
    return _collection.orderBy('tanggal', descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) {
        return Jajan.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  Future<void> ubahJajan(Jajan jajan) async {
    if (jajan.id.isEmpty) {
      throw Exception('ID transaksi tidak ditemukan.');
    }

    if (jajan.nominal <= 0) {
      throw Exception('Nominal jajan harus lebih dari 0.');
    }

    await _collection.doc(jajan.id).update(jajan.toUpdateMap());
  }

  Future<void> hapusJajan(String id) async {
    if (id.isEmpty) {
      throw Exception('ID transaksi tidak ditemukan.');
    }

    await _collection.doc(id).delete();
  }
}
