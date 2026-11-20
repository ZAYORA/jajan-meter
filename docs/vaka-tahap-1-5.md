# Vaka — provider dan transaksi, tahap 1–5

Dasar pekerjaan: `main` pada `3298e29224b9c97fde53bf9a1f1ac681a7b41a93`.
PR #9 untuk fondasi UI telah merged; paket ini melanjutkan fondasi tersebut.
Tanggal penyiapan: 13 November 2026 (WIB).

## Cakupan yang sudah diimplementasikan

- Tema Poppins terang/gelap, empat tab ponsel dan sidebar tablet dari tahap 1–3.
- `JajanProvider` bersama untuk stream transaksi, kategori, dan profil.
- Beranda dengan data akun, sapaan, total harian, sisa jatah, progres, peringatan.
- Tambah, Riwayat (hari/minggu/bulan, tanggal, empat kelompok kategori), Detail,
  Edit termasuk tanggal/jam, Hapus dengan konfirmasi.
- Simpan nonaktif saat nominal nol, kategori belum dipilih, alasan kosong,
  data awal belum siap, atau operasi penyimpanan sedang berjalan.
- Error, data kosong, indikator muat, coba lagi, dan state formulir saat gagal.
- Panel minimum jatah/tema memakai fungsi `UserRepository` yang sudah tersedia.
  Desain lengkap Target/Profil/Pengaturan tetap tugas Zara.
- Setelah email–kata sandi berhasil masuk, `main.dart` memakai aplikasi baru.
  Layar Masuk/Daftar fungsional Zara tetap dipakai; polesan desainnya tahap 6.

## Keputusan terbaru

| Hal | Implementasi |
| --- | --- |
| Alasan | Wajib. Chip Lapar/Stres/Ikut teman/Hadiah serta isian bebas untuk alasan lama atau alasan lain. |
| Nama panggilan | Baca `users/{uid}.nama_panggilan` (String). Jika belum ada, sapaan `teman jajan`. Penyimpanan dari Profil/Daftar disiapkan Zara. |
| Login | Email dan kata sandi; alamat Gmail dapat digunakan. Tidak ada tombol OAuth Google/Apple/Facebook. |
| Hati/nyawa/level | Tidak ditampilkan. |
| Streak | Tab tersedia; tidak ada angka contoh atau rumus yang dianggap final. Menunggu aturan tim. |
| Kategori | Empat pilihan tampilan Makan, Kopi, Transport, Lainnya; ID Firestore tidak diganti dengan kode UI. |
| Ilustrasi | Wallet dari komponen tahap 1–3 dan ikon Material. Ekspor ZIP tidak menyediakan aset maskot terpisah; ilustrasi Detail belum identik dengan maskot di Figma. |

## Jalur data dan batas perubahan

`main.dart → JajanApplication → JajanSessionApp(key: uid) → JajanProvider →
FirebaseJajanSource → repository Zara → Firestore`.

Satu sesi memiliki satu provider dan Navigator. Ketika keluar atau berganti UID,
provider, stream, filter, draft form, serta route Detail/Edit akun lama dilepas.
Repository menerima **parameter opsional `uid`** agar operasi yang menunggu
`await` tidak memakai akun lain. Constructor lama tanpa argumen tetap valid.
Koleksi dan nama field transaksi tidak diubah. Security Rules tetap wajib diuji
Zara: pemisahan state UI tidak menggantikan keamanan server.

File `halaman_jajan.dart` lama tetap tersedia sebagai referensi implementasi
Zara; `main.dart` sekarang membuka alur UI baru. `halaman_auth.dart` hanya
mendapat penanganan error saat widget sudah dilepas; tampilan login belum didesain
ulang. Paket tidak mengubah versi dependency, Rules, indeks, atau konfigurasi
Firebase kelompok.

`DemoJajanSource` hanya dipakai `main_vaka_crud_demo.dart`: data contoh di memori,
reset ketika proses demo dimuat ulang, tanpa akun dan tanpa penyimpanan Firebase.
Layar serta provider demo sama dengan alur produksi. Jangan memakai entrypoint
demo untuk mengklaim uji Firebase berhasil.

## Kontrak JajanProvider untuk Agnie, Zara, Salsa

Di bawah `JajanSessionApp`, gunakan `context.watch<JajanProvider>()` untuk
membaca state dan `context.read<JajanProvider>()` untuk menjalankan aksi.

| Getter | Bentuk / arti |
| --- | --- |
| `daftarJajan` | `List<Jajan>` readonly, seluruh hasil stream, terbaru dahulu. |
| `jajanHariIni` | Transaksi tanggal lokal hari ini. |
| `jatahHarian`, `totalHariIni`, `sisaJatah` | `int`, rupiah; sisa boleh negatif. |
| `hasBudget` | Jatah lebih dari nol. |
| `persenTerpakai`, `persenSisa` | `double` 0–100. |
| `progresTerpakai`, `progresSisa` | `double` 0–1 untuk progress bar. |
| `peringatanAktif` | Sisa <=20% jika jatah sudah diatur. |
| `statusTarget` | `Belum diatur`, `Tercapai`, atau `Terlampaui`, mengikuti kalkulator Salsa. |
| `isLoading`, `isSaving`, `isReady` | Muat awal/retry, mutasi berlangsung, ketiga sumber pernah berhasil dimuat. |
| `hasData`, `hasProfile`, `isEmpty` | Bedakan belum muat, profil siap, dan daftar kosong. |
| `error`, `actionError` | Pesan stream dan pesan aksi terakhir, nullable. |
| `namaPanggilan`, `themeMode` | Nilai profil; nama fallback dan tema terang jika belum ada. |
| `periode`, `tanggalFilter`, `kategoriFilter` | State filter Riwayat. |
| `awalRentang`, `akhirRentang` | Awal inklusif dan akhir eksklusif. |
| `transaksiTerfilter`, `totalTerfilter` | Daftar dan total sesuai semua filter. |
| `transaksiMingguIni`, `rekapMingguan` | Senin–Minggu saat ini, tidak dipengaruhi filter Riwayat. |
| `totalPerHariMingguIni` | Map kunci `yyyy-MM-dd` ke total; tujuh hari termasuk hari nol. |
| `totalPerKategoriMingguIni`, `totalPerAlasanMingguIni` | Map label asli ke jumlah rupiah; bukan jumlah kejadian. |
| `cariJajan(id)` | Model terbaru atau null jika tidak tersedia. |

Contoh pemakaian (widget perlu mengimpor provider package dan file provider):

```dart
final p = context.watch<JajanProvider>();
if (!p.hasData || !p.hasProfile) return const CircularProgressIndicator();
return BudgetCard(
  jatah: p.jatahHarian,
  terpakai: p.totalHariIni,
  sisa: p.sisaJatah,
);
```

Aksi:
- `mulai()` dipanggil oleh pemilik sesi; `cobaLagi()` mengganti subscription.
- `setFilter(periode:, tanggal:)`, `setKategoriFilter(nilaiAtauNull)`.
- `simpanJajan(original:, nominal:, kelompok:, alasan:, tanggal:, catatan:)`
  mengembalikan ID saat berhasil atau null saat gagal/sedang sibuk.
- `hapusJajan(id)` hanya dipanggil setelah UI memperoleh konfirmasi.
- `setJatahHarian(nilai)` dan `setTema(gelap)` mengembalikan bool.
- Jangan memanggil `dispose()` dari halaman; `JajanSessionApp` yang memilikinya.

## Aturan data yang sudah dipilih untuk tahap ini

1. Tanggal dihitung dalam zona lokal perangkat. Hari berganti saat melewati
   tengah malam; provider memeriksa setiap menit dan saat aplikasi aktif lagi.
   Pilihan tanggal historis tidak ikut berpindah otomatis.
2. Minggu dimulai Senin. Rentang bulan menangani pergantian tahun. Rentang selalu
   `[awal, akhir)`; transaksi tepat tengah malam hanya masuk satu hari.
3. Kalkulator Salsa dipanggil untuk total harian, sisa, persen, peringatan,
   status, dan rekap. Adapter membentuk `hari` dari `tanggal`; tidak menambah
   field Firestore atau menyalin perhitungan rekap.
4. Jatah nol berarti belum diatur; tidak memunculkan peringatan 20%. Sisa negatif
   tetap ditampilkan, bar dibatasi 0–1. Nilai uang disimpan sebagai int.
5. Nama dan ID kategori asli dipertahankan saat edit dengan kelompok UI sama,
   termasuk kategori custom yang tidak ada lagi di daftar kategori. Pilihan baru
   mencari nama canonical/alias yang tersedia; jika belum ada, memanggil
   `KategoriRepository.tambahKategori`, lalu memakai ID yang dikembalikan.
   Alias: Makanan/Makan berat/Camilan/Cemilan → Makan; Kopi/minum → Kopi;
   Transportasi/Ojek → Transport; nama lain ditampilkan dalam filter Lainnya.
6. Model Zara belum memiliki field judul terpisah. Daftar menampilkan baris
   pertama Catatan sebagai judul, atau kategori bila Catatan kosong. Tidak ada
   field transaksi baru yang harus ditambahkan backend untuk tahap ini.
7. Nama profil hanya dibaca. Zara cukup menyimpan String `nama_panggilan` pada
   dokumen pengguna yang sama. Perubahan stream profil langsung memperbarui sapaan.
8. Sukses tampil setelah Future repository selesai. Saat offline, Firestore dapat
   menunggu koneksi kembali; UI menampilkan menunggu konfirmasi, bukan menganggap
   data sudah diterima server. Uji offline aktual masih tugas integrasi/QA.

## Handoff navigasi ke Agnie

Host sementara menggunakan Navigator karena main terbaru belum mempunyai router
produksi. Semua route berada di dalam sesi akun; stateless `JajanAdaptiveShell`
tetap dapat dipasang ke `ShellRoute`. Destinasi: `/`, `/riwayat`, `/statistik`,
`/streak`, `/target`, `/pengaturan`. Agnie dapat memetakan halaman form/detail ke
rute Tambah, Detail ID, dan Edit ID. Pertahankan provider di atas seluruh halaman
sesi, serta reset sesi saat UID berubah. Redirect login/onboarding belum diubah
oleh paket ini.

Statistik lengkap, Streak/Lencana, kartu Rekap di Statistik, onboarding, profil,
serta finalisasi Masuk/Daftar berada di tahap/penanggung jawab berikutnya. Getter
untuk statistik dan rekap sudah terbuka; tidak ada nilai streak palsu.

## Validasi dan batas hasil

Lingkungan penyiapan: Flutter 3.47.4, Dart 3.13.3. Lihat log di
`docs/validasi-vaka-tahap-1-5/` dan skenario di `docs/uji-vaka-tahap-1-5.md`.

- 46 tes lulus: tes kalkulator yang ada, UI tahap awal, provider, dan alur CRUD.
- Analisis kode pada seluruh file baru/berubah yang dapat dianalisis tanpa
  `firebase_options.dart`: tidak ada masalah.
- Build web debug `lib/main_vaka_crud_demo.dart`: berhasil.
- Render Flutter 393×852 dan 1024×1194, masing-masing terang/gelap.
- Layar 320px dengan teks 1,5×, resize saat isi form, dan pergantian sesi diuji.
- Contoh proposal Tabel 3.10: Rp135.000, Rabu, Makan berat, Lapar.

**Belum diuji:** Firebase project kelompok secara langsung, Rules antar akun,
login produksi, APK Android, HP fisik, iPad fisik/iOS. Konfigurasi Firebase tidak
tersedia dalam paket. Build demo bukan bukti bahwa bagian tersebut sudah lulus.
Repository `streamJajan()` masih membaca semua transaksi sesuai implementasi
Zara; pembatasan query/paginasi dan uji volume data tetap perlu dikerjakan pada
optimasi berikutnya. Detail menggunakan ikon, belum aset maskot Figma asli.

Rujukan resmi:
- https://docs.flutter.dev/data-and-backend/state-mgmt/simple
- https://firebase.google.com/docs/firestore/manage-data/enable-offline
