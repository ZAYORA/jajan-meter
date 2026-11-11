import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/kategori.dart';

class KategoriRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get _uid {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('Pengguna belum login.');
    }

    return user.uid;
  }

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('users').doc(_uid).collection('kategori');

  Stream<List<Kategori>> streamKategori() {
    return _collection.orderBy('nama').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Kategori.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  Future<String> tambahKategori(String nama) async {
    final namaBersih = nama.trim();

    if (namaBersih.isEmpty) {
      throw Exception('Nama kategori tidak boleh kosong.');
    }

    if (namaBersih.length > 30) {
      throw Exception('Nama kategori maksimal 30 karakter.');
    }

    final namaNormalisasi = namaBersih.toLowerCase();

    final duplikat = await _collection
        .where('nama_normalisasi', isEqualTo: namaNormalisasi)
        .limit(1)
        .get();

    if (duplikat.docs.isNotEmpty) {
      throw Exception('Kategori tersebut sudah tersedia.');
    }

    final dokumen = await _collection.add({
      'nama': namaBersih,
      'nama_normalisasi': namaNormalisasi,
      'dibuat_pada': FieldValue.serverTimestamp(),
    });

    return dokumen.id;
  }
}
