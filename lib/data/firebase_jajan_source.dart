import '../models/jajan.dart';
import '../models/kategori.dart';
import '../services/jajan_repository.dart';
import '../services/kategori_repository.dart';
import '../services/user_repository.dart';
import 'jajan_source.dart';

/// Satu instance per sesi akun. UID dipatok agar operasi tertunda tidak
/// berpindah ke akun baru ketika pengguna keluar/ganti akun.
class FirebaseJajanSource implements JajanSource {
  FirebaseJajanSource(String uid)
    : _jajan = JajanRepository(uid: uid),
      _kategori = KategoriRepository(uid: uid),
      _user = UserRepository(uid: uid);
  final JajanRepository _jajan;
  final KategoriRepository _kategori;
  final UserRepository _user;

  @override
  Stream<List<Jajan>> streamJajan() => _jajan.streamJajan();
  @override
  Stream<List<Kategori>> streamKategori() => _kategori.streamKategori();
  @override
  Stream<Map<String, dynamic>?> streamPengguna() => _user.streamPengguna();
  @override
  Future<String> tambahJajan(Jajan value) => _jajan.tambahJajan(value);
  @override
  Future<void> ubahJajan(Jajan value) => _jajan.ubahJajan(value);
  @override
  Future<void> hapusJajan(String id) => _jajan.hapusJajan(id);
  @override
  Future<String> tambahKategori(String nama) => _kategori.tambahKategori(nama);
  @override
  Future<void> setJatahHarian(int nilai) => _user.setJatahHarian(nilai);
  @override
  Future<void> setTema(String tema) => _user.setTema(tema);
}
