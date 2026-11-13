import '../models/jajan.dart';
import '../models/kategori.dart';

/// Batas antara state UI dan repository. Implementasi produksi tetap memakai
/// repository Zara; implementasi memori hanya untuk demo dan pengujian.
abstract interface class JajanSource {
  Stream<List<Jajan>> streamJajan();
  Stream<List<Kategori>> streamKategori();
  Stream<Map<String, dynamic>?> streamPengguna();
  Future<String> tambahJajan(Jajan value);
  Future<void> ubahJajan(Jajan value);
  Future<void> hapusJajan(String id);
  Future<String> tambahKategori(String nama);
  Future<void> setJatahHarian(int nilai);
  Future<void> setTema(String tema);
}
