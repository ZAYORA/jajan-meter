# Vaka — pemindahan frontend ke screens dan integrasi services

Tanggal: 14 November 2026 (WIB).
Dasar: `vaka-frontend` pada `e7e6b1156811636c726c87d7d43a17d2d7876cca`.

## Cakupan dua pekerjaan

1. Memindahkan tujuh file UI produksi Vaka dari `lib/features/jajan` langsung ke
   `lib/screens` dan memperbarui import yang bergantung pada lokasi itu.
2. Menempatkan adapter `FirebaseJajanSource` di `lib/services` serta menghubungkan
   aplikasi produksi ke lokasi barunya. Adapter menggunakan repository yang
   sudah ada; fungsi CRUD, field Firestore, dan pembagian sesi akun dipertahankan.

Integrasi ke services sudah tersedia pada tahap 1–5. Perubahan ini menata
lokasinya dan memeriksa bahwa alur aplikasi tetap memakai integrasi tersebut.
Ini bukan pembuatan ulang backend atau implementasi statistik/streak.

## Peta file

| File | Lokasi lama | Lokasi baru |
| --- | --- | --- |
| Beranda | `lib/features/jajan/jajan_home_page.dart` | `lib/screens/jajan_home_page.dart` |
| Form tambah/edit | `lib/features/jajan/jajan_form_page.dart` | `lib/screens/jajan_form_page.dart` |
| Riwayat dan filter | `lib/features/jajan/jajan_history_page.dart` | `lib/screens/jajan_history_page.dart` |
| Detail dan hapus | `lib/features/jajan/jajan_detail_page.dart` | `lib/screens/jajan_detail_page.dart` |
| Jatah dan tema | `lib/features/jajan/jajan_preferences_page.dart` | `lib/screens/jajan_preferences_page.dart` |
| Komponen pendukung layar | `lib/features/jajan/jajan_shared.dart` | `lib/screens/jajan_shared.dart` |
| Penghubung navigasi layar | `lib/features/jajan/jajan_workspace.dart` | `lib/screens/jajan_workspace.dart` |
| Adapter Firebase | `lib/data/firebase_jajan_source.dart` | `lib/services/firebase_jajan_source.dart` |

`lib/app/jajan_session_app.dart` sekarang mengimpor
`../screens/jajan_workspace.dart`. `lib/app/jajan_application.dart` sekarang
mengimpor `../services/firebase_jajan_source.dart`.

Pada tujuh file layar, import menuju model/provider/UI kit berubah dari
`../../...` menjadi `../...` karena file naik satu tingkat folder. Nama kelas,
callback, state, dan aturan validasi tidak berubah. Import antarlayar tetap
relatif di folder `screens` yang sama.

Folder `lib/providers` tetap berisi state, `lib/models` berisi model,
`lib/vaka_ui` berisi tema/widget bersama dan pratinjau, dan `lib/data` menyimpan
kontrak `JajanSource`. File-file tersebut bukan halaman produksi yang perlu
dipindahkan. `halaman_auth.dart` tetap dipakai untuk login, sedangkan
`halaman_jajan.dart` lama tetap tersedia untuk referensi tim dan bukan tujuan
setelah login pada entrypoint baru.

## Alur aplikasi produksi

`lib/main.dart` menginisialisasi Firebase lalu membuka `JajanApplication`.
Saat akun tersedia, aplikasi membuat `FirebaseJajanSource(uid)` dan
`JajanSessionApp(key: ValueKey(uid))`. Sesi memiliki satu `JajanProvider` yang
dibaca layar di `lib/screens`. Provider memanggil kontrak `JajanSource`;
adapter meneruskan operasi ke repository di `lib/services`.

UI tidak membuat instance repository baru di setiap layar. Pendekatan ini
mempertahankan satu sumber data untuk total Beranda, Riwayat, dan Detail,
sekaligus membuang state/route akun sebelumnya saat UID berubah.

## Pemetaan aksi frontend ke services

| Aksi layar | Provider/adapter | Service yang dipakai |
| --- | --- | --- |
| Masuk, daftar, keluar | `HalamanAuth` / `JajanApplication` | `AuthService.masuk`, `daftar`, `keluar` |
| Muat transaksi | `mulai` → `streamJajan` | `JajanRepository.streamJajan` |
| Tambah transaksi | `simpanJajan` → `tambahJajan` | `JajanRepository.tambahJajan` |
| Edit transaksi | `simpanJajan(original: ...)` → `ubahJajan` | `JajanRepository.ubahJajan` |
| Hapus setelah konfirmasi | `hapusJajan` | `JajanRepository.hapusJajan` |
| Muat/buat kategori | `streamKategori` / `tambahKategori` | `KategoriRepository` |
| Sapaan, jatah, dan tema | `streamPengguna` | `UserRepository.streamPengguna` |
| Simpan jatah | `setJatahHarian` | `UserRepository.setJatahHarian` |
| Simpan tema | `setTema` | `UserRepository.setTema` |

Repository menerima UID sesi yang sama. Transaksi tetap berada pada
`users/{uid}/jajan`, kategori pada `users/{uid}/kategori`, dan profil pada
`users/{uid}`. Nilai uang tetap integer rupiah; nominal positif dan alasan
wajib. Identitas kategori lama dipertahankan saat edit. Sapaan membaca
`nama_panggilan`; jika belum disimpan backend, fallback tetap `teman jajan`.

## Cara menjalankan

Demo untuk pemeriksaan UI tanpa Firebase:

```powershell
flutter run -d chrome -t lib/main_vaka_crud_demo.dart
```

Demo menggunakan `DemoJajanSource` di memori. Reset demo menghapus perubahan
contoh, dan demo tidak membuktikan penyimpanan Firestore.

Aplikasi produksi menggunakan konfigurasi Firebase kelompok yang sudah ada:

```powershell
flutter run -d chrome
```

Chrome memerlukan konfigurasi platform web pada `firebase_options.dart`.
Alternatif Android: jalankan `flutter devices`, lalu
`flutter run -d ID_PERANGKAT` dengan ID yang benar. Android juga memerlukan
`android/app/google-services.json` yang sesuai. Gunakan konfigurasi dari Zara;
jangan membuat project Firebase lain untuk pekerjaan pemindahan folder ini.

## Pemeriksaan setelah pemasangan

```powershell
flutter pub get
flutter analyze lib/app lib/data lib/demo lib/providers lib/screens lib/vaka_ui lib/services lib/models lib/utils lib/widgets lib/main_vaka_crud_demo.dart test
flutter test
```

Analisis terarah tidak memasukkan `main.dart` karena konfigurasi Firebase
pribadi tidak berada di Git. Setelah konfigurasi tersedia, jalankan juga
`flutter analyze` penuh dan catat hasil aktual, termasuk masalah di file lama
jika ada. Jangan menyembunyikan masalah dengan menghapus dependency/config.

Alur UI yang perlu diulang: tambah → riwayat → filter → detail → edit tanggal
dan nominal → hapus batal → hapus konfirmasi → ubah jatah/tema. Uji viewport
393×852 dan 1024×1194 dalam tema terang/gelap.

Pada aplikasi produksi, tambah transaksi uji, tutup dan buka kembali aplikasi,
lalu pastikan transaksi masih ada pada akun yang sama. Pemeriksaan antar akun
dan Security Rules tetap membutuhkan Firebase kelompok bersama Zara/Salsa.

Hasil penyiapan perubahan ini dicatat terpisah di
`docs/validasi-vaka-screens-services/hasil-validasi.md`. Log tahap 1–5 adalah
bukti paket sebelumnya, bukan otomatis hasil uji ulang perubahan ini.

## Git dan PR

Paket diterapkan pada branch `vaka-frontend`, di atas commit tahap 1–5, dengan
working tree bersih. Gunakan `git apply --check` sebelum `git apply`.
Patch tidak diterapkan ulang pada `main` yang belum memuat tahap 1–5.

Setelah pengujian, commit dengan pesan `rapikan screens dan integrasi services`,
lalu push `vaka-frontend`. PR yang masih terbuka dari branch ini ke `main`
akan memuat commit baru tersebut. Periksa kembali status review sesudah push;
anggota kelompok dapat perlu meninjau ulang perubahan terbaru.

Tidak ada push/merge otomatis yang dilakukan saat menyiapkan paket ini.
