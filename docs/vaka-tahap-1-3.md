> Arsip tahap 1–3. Untuk provider, CRUD, dan keputusan terbaru (tanpa login sosial, hati, atau level), lihat [tahap 1–5](vaka-tahap-1-5.md).

# Serah terima Vaka — tema final dan kerangka adaptif (tahap 1–3)

Tanggal: 12 November 2026. Basis integrasi: vaka-frontend efd426d + main 236ccf1 (kartu Rekap Salsa).
Acuan: Untitled (1).zip, Untitled (2).zip, Fondasi Visual & UI Kit / Design Playbook 1.0.

## Keputusan yang diterapkan

Folder foundation yang sudah diunggah Vaka dipakai sebagai sumber tema/kartu/tombol/transaksi. API lama di lib/vaka_ui menjadi jembatan ke komponen tersebut. Preview UI Kit lama tetap dapat dijalankan; preview adaptif memakai lib/main_vaka_preview.dart. Dependensi google_fonts dan dependency_overrides yang sudah ada tetap dipertahankan, tetapi tema sekarang memakai aset Poppins lokal agar tidak perlu mengunduh font saat aplikasi dijalankan.

- Poppins lokal (400/500/600/700), lisensi OFL disertakan. Tidak menambah paket.
- Biru #1CB0F6, hijau #58CC02, emas #FFC800, merah #FF4B4B, latar terang #F7F7F7, latar gelap #101E2B. Tanpa oranye.
- Kartu radius 24, border 2, bayangan padat Y6. Tombol bulat tinggi minimum 56.
- HP: Beranda, Riwayat, Statistik, Lencana. Tablet: menu samping ditambah Target hemat dan Pengaturan.
- Breakpoint 840 logical pixels untuk sidebar; dua kolom isi pada ruang konten >=720. Ini keputusan implementasi, bukan ukuran wajib perangkat.
- Empat kategori UI: Makan, Kopi, Transport, Lainnya. Alasan tetap tersedia sebagai chip Lapar/Stres/Ikut teman/Hadiah. Form pratinjau mewajibkan alasan agar selaras dengan validasi layar Zara saat ini.
- Nama panggilan dipasok ke widget; pratinjau dapat mengubah contoh nama melalui Pengaturan. Penyimpanan nama akun masih tahap integrasi.
- Komponen Google/Apple/Facebook tersedia dengan callback nullable. Tombol nonaktif sampai callback autentikasi benar-benar tersedia.
- Hati/nyawa/level belum ditampilkan dan tidak dihitung. Tidak memakai angka palsu untuk fitur yang menunggu aturan.

## Cara menjalankan

```sh
flutter pub get
flutter run -d chrome -t lib/main_vaka_preview.dart
```

`pub get` mengambil dependensi yang sudah tercantum; bukan menambah paket baru. Gunakan Flutter 3.47.4 / Dart 3.13.3 sesuai kelompok.

Pratinjau tidak menginisialisasi Firebase, tidak menulis transaksi, dan memakai tanggal/nominal contoh. Untuk Android, entry point ini tetap terkena konfigurasi Gradle proyek (termasuk kebutuhan google-services.json). Gunakan Chrome untuk review tahap 1–3 bila konfigurasi Android belum tersedia; tidak perlu mengubah plugin Google Services atau main.dart.

## Pemeriksaan

```sh
flutter analyze lib/vaka_ui lib/main_vaka_preview.dart lib/main_vaka_ui_kit_preview.dart test/vaka_week1
flutter test test/vaka_week1
```

Tes mencakup format, nilai jatah (termasuk nol/terlampaui), pemilihan kategori/alasan, validasi tombol, navigasi, tema, sapaan, serta resize. Analisis dibatasi komponen Vaka karena konfigurasi Firebase lokal belum tersedia di checkout ini. Ini bukan bukti bahwa aplikasi produksi/keamanan Firebase telah lulus.

Screenshot pratinjau dapat diregenerasi dengan:

```sh
flutter test test/vaka_week1/adaptive_ui_test.dart --dart-define=CAPTURE_UI=true
```

File di docs/screenshots/vaka-tahap-1-3 dihasilkan renderer Flutter pada logical viewport HP 393×852 dan tablet 1024×1194. Bukan screenshot dari iPad fisik. Tampilan HP pendek dapat digulir untuk melihat alasan/tombol Simpan.

## Komponen yang siap dipakai

| Komponen | Kontrak |
|---|---|
| buildJajanTheme(brightness: ...) | ThemeData terang/gelap, Poppins dan token bersama |
| JajanAdaptiveShell | selectedIndex, onSelected, child, nickname, showMobileNavigation, floatingActionButton |
| JajanBottomBar | Empat tab; selectedIndex dan onSelected berasal dari router |
| JajanSurface | Kartu; child/padding/color/onTap |
| JajanActionButton | Tombol; label/icon/color/onPressed. null = nonaktif |
| BudgetCard | jatah, terpakai, sisa, onAturJatah. Progress menunjukkan sisa |
| JajanTile | judul, nominal, kategori, label, tanggal, alasan opsional, onTap |
| JajanCategoryGrid | Empat kategori; selectedValue/onChanged |
| JajanChoiceChips | Pilihan alasan; selectedValue/onChanged; optional untuk pemanggil yang membolehkan kosong |
| SocialSignInButtons | onGoogle/onApple/onFacebook nullable |
| WalletMascot | Ilustrasi vektor Flutter sementara, bukan aset asli hasil ekspor Figma |

Kategori UI adalah kode tampilan, bukan ID Firestore. Jangan menyimpan `makan` sebagai kategori_id tanpa mencocokkan dokumen repository. Data lama/custom category tidak dihapus atau dimigrasikan oleh perubahan ini.

## Sambungan untuk Agnie (router)

Shell tidak membuat GoRouter kedua dan tidak mengubah AuthGate yang sudah ada. Saat memasang router produksi, gunakan `JajanAdaptiveShell` sebagai pembungkus child ShellRoute; indeks diturunkan dari lokasi rute, bukan state pratinjau.

| Indeks | Tujuan | Path usulan |
|---|---|---|
| 0 | Beranda | / |
| 1 | Riwayat | /riwayat |
| 2 | Statistik | /statistik |
| 3 | Lencana | /streak |
| 4 | Target hemat | /target |
| 5 | Pengaturan | /pengaturan |

Contoh isi builder ShellRoute (potongan, bukan router siap salin):

```dart
JajanAdaptiveShell(
  selectedIndex: selectedIndexFromRoute,
  nickname: namaDariProfil,
  onSelected: (index) => context.go(jajanDestinations[index].path),
  child: child,
)
```

Agnie tetap menangani /login, /daftar, /onboarding, detail/edit/tambah serta redirect. Untuk HP pada halaman detail/tambah/pengaturan, `showMobileNavigation: false`; tablet dapat tetap menampilkan sidebar jika rute dipasang di dalam shell. Sepakati posisi rute ini sebelum integrasi. Nama path dapat disesuaikan terpusat dengan router tim.

Pasang `theme`, `darkTheme`, dan `themeMode` pada MaterialApp.router produksi saat integrasi. Nilai tema dari users/{uid} menjadi sumbernya; toggle pratinjau hanya menyimpan state selama aplikasi terbuka.

## Cakupan dan pekerjaan berikutnya

Tahap ini menyelesaikan fondasi tampilan dan kerangka adaptif. Beranda/form memakai data contoh, Riwayat/Statistik/Lencana/Target masih ruang halaman. main.dart, models, screens, services dan calculator Salsa tidak diganti.

Tahap berikutnya: JajanProvider, adapter ke calculator Salsa, getter, CRUD lengkap, filter, detail/edit, penyimpanan nama, login UI final, serta router/auth/onboarding bersama tim. Jangan menganggap tahap 1–3 sebagai penyelesaian minggu 3–4.

Aset asli wallet/logo/ilustrasi dari Agnie dapat menggantikan WalletMascot. Font Poppins sudah sesuai UI Kit. Sumber font: https://github.com/google/fonts/tree/main/ofl/poppins (Regular, Medium, SemiBold, Bold); lisensi ada di assets/fonts/poppins/OFL.txt.

## PR yang disarankan

Judul: `Sesuaikan UI Kit dan kerangka HP/tablet terang-gelap`

Isi PR: tema dan komponen disesuaikan Design Playbook 1.0; navigasi HP memakai empat tab dan tablet memakai sidebar; alasan dipertahankan serta kategori menjadi empat pilihan. Sertakan hasil tes aktual dan screenshot. Sebutkan bahwa aplikasi utama dan Firebase belum disambungkan, serta ilustrasi wallet masih vektor sementara.

Review: Agnie memeriksa desain/navigasi; Salsa memeriksa layout/validasi; Zara memeriksa kontrak integrasi. Merge setelah review tim.

## Hasil verifikasi paket (12 November 2026)

- Flutter 3.47.4 / Dart 3.13.3, lingkungan Linux.
- Analisis lib/vaka_ui, kedua entry point pratinjau dan test/vaka_week1: tidak ada masalah.
- `flutter test test/vaka_week1 --dart-define=CAPTURE_UI=true`: 22 tes lulus.
- `flutter build web --debug --no-pub -t lib/main_vaka_preview.dart`: berhasil.
- Delapan screenshot aktual renderer Flutter: Beranda/Tambah × HP/tablet × terang/gelap.
- Pengujian tambahan: teks 1,5× pada lebar 320/393/768, perpindahan tab, nama panggilan, pergantian tema, state pilihan setelah resize, nominal nol, alasan belum dipilih, dan tombol sosial nonaktif.
- Tidak ada pengujian Firebase, Android build, atau iPad fisik pada paket ini. Pemeriksaan main.dart tetap membutuhkan konfigurasi Firebase lokal tim.
