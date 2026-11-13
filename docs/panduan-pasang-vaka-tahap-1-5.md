# Panduan Vaka — memasang tahap 1–5 di Windows

Paket ini **lanjutan** tahap 1–3 yang sudah masuk `main` lewat PR #9.
Tidak perlu memasang ZIP lama lagi. Kode baru belum berada di laptopmu sampai
patch ini diterapkan. Jangan buat ulang proyek Flutter atau memasang ulang paket.

## 1. Samakan branch dengan main terbaru

1. Di VS Code pilih **File → Save All**.
2. Buka **GitHub Desktop**. Pastikan **Current repository: jajan-meter**.
3. Pilih **Current branch → vaka-frontend**. Jika ada perubahan di **Changes**,
   simpan dahulu melalui commit. Jangan klik Discard. Jika 0 changed files, lanjut.
4. Klik **Fetch origin**; jika muncul **Pull origin**, klik.
5. Klik **Current branch → main**. Klik **Fetch origin**, lalu **Pull origin**
   jika tersedia. Tunggu selesai.
6. Kembali ke **Current branch → vaka-frontend**.
7. Klik menu **Branch → Merge into current branch…**, pilih **main**, lalu
   **Create a merge commit** / tombol merge yang ditampilkan. Jika already up to
   date, lanjut. Jika konflik, simpan screenshot dan minta bantuan; jangan pilih
   versi file secara acak.
8. Klik **Push origin** jika tersedia. Pilih **Repository → Open in Visual Studio Code**.

Dasar paket adalah main `3298e29`. Jika main sudah lebih baru, patch masih harus
lolos `git apply --check`. Jika tidak, berhenti sebelum apply agar perubahan tim
terbaru tidak tertimpa.

## 2. Unduh dan ekstrak

1. Unduh **JajanMeter_Vaka_Tahap_1-5.zip** dari tautan di chat.
2. Buka File Explorer → **Downloads**.
3. Klik kanan ZIP → **Extract All… / Ekstrak Semua…**.
4. Gunakan folder `C:\Users\TATA IVANKA\Downloads\JajanMeter_Vaka_Tahap_1-5`.
5. Di dalamnya harus ada `vaka-tahap-1-5.patch`, `PANDUAN_PASANG.md`, `FILES.txt`,
   dan `files`. Jangan seret seluruh folder `files` ke proyek; gunakan patch.
   Patch menangani penghapusan tombol sosial dan memeriksa kesesuaian file.

## 3. Buka terminal proyek dan periksa

Di VS Code, klik **Terminal → New Terminal** (jika tidak tampak, klik `…` pada menu).
Terminal harus berada di `C:\Users\TATA IVANKA\GitHub\jajan-meter`.
Jalankan satu per satu:

```powershell
Get-Location
git branch --show-current
git status --short
```

Branch harus `vaka-frontend`; status harus kosong. Jika ada perubahan, commit
terlebih dahulu atau kirim hasilnya untuk ditinjau. Jangan lanjut pada `main`.

## 4. Periksa patch, kemudian pasang

```powershell
git apply --check "$env:USERPROFILE\Downloads\JajanMeter_Vaka_Tahap_1-5\vaka-tahap-1-5.patch"
```

Jika terminal kembali tanpa pesan error, pemeriksaan lolos. Jika ada `error`,
`patch failed`, `already exists`, atau file tidak ditemukan, **jangan jalankan
perintah apply berikut**; kirim pesan lengkapnya. Folder hasil ekstrak mungkin
berbeda, atau kode lokal/main sudah berubah.

Setelah check lolos:

```powershell
git apply "$env:USERPROFILE\Downloads\JajanMeter_Vaka_Tahap_1-5\vaka-tahap-1-5.patch"
git status --short
```

Tanda benar: muncul perubahan pada main, provider, app, features, beberapa
repository, dokumentasi dan tes. File konfigurasi Firebase pribadi tidak disentuh.

## 5. Ambil dependency yang sudah tercantum dan uji

```powershell
flutter pub get
flutter analyze lib/app lib/data lib/demo lib/providers lib/features lib/vaka_ui lib/services lib/screens/halaman_auth.dart lib/main_vaka_crud_demo.dart test/vaka_week4 test/vaka_week1
flutter test
```

Paket disiapkan dengan Flutter 3.47.4 / Dart 3.13.3. Hasil saat penyiapan:
**analisis tanpa masalah dan 46 tes lulus**. Cocokkan dengan hasil laptopmu.
Jangan menulis tes lulus di PR sebelum benar-benar melihat hasilnya.
`flutter pub get` mengambil dependency yang sudah tercantum, bukan menambahkan
paket baru. Tidak perlu `flutter pub upgrade`.

Analisis terarah di atas sengaja tidak memasukkan `main.dart` yang mengimpor
konfigurasi Firebase lokal. Setelah konfigurasi tersedia, jalankan juga
`flutter analyze` seluruh proyek dan catat hasil aktual.

## 6. Coba alur lengkap tanpa Firebase dahulu

```powershell
flutter run -d chrome -t lib/main_vaka_crud_demo.dart
```

Ini demo CRUD di memori dengan banner DEMO. Perubahan hilang saat proses demo
muat ulang; tidak dikirim ke Firestore.

1. Beranda menampilkan sapaan Vaka, jatah Rp100.000, terpakai Rp55.000.
2. Klik **Tambah Jajan**. Coba isi `0`: Simpan harus nonaktif.
3. Isi `15000`, pilih **Kopi**, pilih alasan **Stres**, isi catatan **Es kopi baru**.
4. Klik **Simpan Jajan!**. Angka Beranda menjadi Rp70.000 terpakai.
5. Buka **Riwayat**, pilih **Kopi**: total filter Rp40.000.
6. Ketuk **Es kopi baru** → **Edit** → ubah nominal jadi `18000`, pindahkan tanggal
   ke kemarin → **Simpan perubahan**. Total hari ini harus kembali Rp55.000.
7. Di Detail klik **Hapus → Batal**, pastikan transaksi masih ada.
8. Klik **Hapus → Hapus**, pastikan transaksi hilang.
9. Beranda → ikon Pengaturan kanan atas: coba **Mode gelap**, ubah jatah, simpan.
10. Untuk HP/tablet: Chrome **F12** → **Ctrl+Shift+M** → **Responsive** → ukuran
    **393 × 852**, lalu **1024 × 1194**. Angka adalah logical pixels viewport.
    Coba kedua tema di masing-masing ukuran. Ini pemeriksaan layout iPad,
    bukan bukti aplikasi sudah diuji pada iPad fisik/iOS.

Tekan `q` di terminal untuk menghentikan aplikasi sebelum menjalankan perintah lain.

## 7. Sambungkan pengujian ke Firebase kelompok

Kode sudah memanggil repository Zara. Untuk menjalankan **aplikasi sebenarnya**,
konfigurasi kelompok harus tersedia di laptop:

- `lib/firebase_options.dart` sesuai project dan platform kelompok.
- Untuk Android: `android/app/google-services.json` yang sesuai app Android.
- Authentication email/password serta Rules Firestore disiapkan Zara.

Gunakan konfigurasi yang Zara berikan atau prosedur setup kelompok. Tidak perlu
membuat project Firebase baru. File pribadi yang diabaikan Git tidak dipaksa upload.

Setelah siap, untuk Android:

```powershell
flutter devices
flutter run -d emulator-5554
```

Ganti ID bila berbeda. Untuk Chrome dengan konfigurasi web:

```powershell
flutter run -d chrome
```

Jangan tambahkan `-t lib/main_vaka_crud_demo.dart` saat uji Firebase.
Masuk menggunakan akun uji kelompok. Ulangi tambah/edit/hapus, tutup aplikasi,
masuk lagi, dan pastikan transaksi tetap tersedia. Minta Zara menyimpan
`nama_panggilan` pada dokumen pengguna agar sapaan memakai nama akun.
Catat hasil nyata di `docs/uji-vaka-tahap-1-5.md`; jika belum dilakukan tulis
**Belum diuji**, bukan lulus.

## 8. Commit dan push

1. VS Code → **File → Save All**.
2. GitHub Desktop → **Current branch: vaka-frontend**.
3. Tab **Changes**: periksa perubahan kode, docs, tes, serta screenshot baru.
   Paket tidak membawa konfigurasi pribadi, build, atau dependency baru.
4. Isi Summary:
   `sambungkan provider dan CRUD pada UI HP tablet`
5. Klik **Commit to vaka-frontend**.
6. Klik **Push origin**. Tunggu selesai.

## 9. Buat PR baru

PR #9 sudah merged; jangan mengunggah perubahan ini sebagai komentar di PR lama.

1. Buka https://github.com/ZAYORA/jajan-meter/pulls.
2. Klik **New pull request**.
3. Pilih **base: main** dan **compare: vaka-frontend**.
4. Klik **Create pull request**.
5. Judul: **Sambungkan JajanProvider dan CRUD dengan UI HP/tablet**.
6. Salin draft `docs/pr-vaka-tahap-1-5.md`, lalu isi bagian hasil laptopmu dengan
   hasil aktual. Sertakan screenshot HP/tablet terang/gelap atau tautan folder
   `docs/screenshots/vaka-tahap-1-5`.
7. Klik **Create pull request**. Minta Agnie memeriksa UI/navigasi, Salsa menguji,
   dan Zara memeriksa adapter repository serta kontrak profil.
8. Merge setelah review dan QA sesuai aturan tim. Jika muncul Review required,
   perlu approval anggota lain yang mempunyai Write access.

## 10. Cara kerja bersama Zara sesudah PR digabung

Masing-masing anggota mengedit salinan proyek di laptop sendiri. GitHub `main`
menjadi kode bersama yang sudah direview. Setelah PR Vaka merged, Zara:

1. Simpan/commit pekerjaannya sendiri di `zara-backend`.
2. Fetch/Pull `main` terbaru.
3. Kembali ke `zara-backend`, merge `main` ke branch tersebut.
4. Lanjutkan services/profil/Rules dari kode yang sudah memuat UI baru.
5. Commit, push, lalu PR ke main seperti biasa.

Vaka melakukan alur yang sama saat perubahan backend Zara sudah merged. Hindari
saling mengirim seluruh folder proyek atau menimpa file tanpa melihat perubahan.

Pesan yang dapat dikirim sendiri ke Zara:

> Zar, aku lanjutkan kode repository kamu. Frontend dan JajanProvider akan
> memanggil fungsi tambah/baca/edit/hapus yang sudah ada. Kita sama-sama edit
> salinan proyek di laptop masing-masing, commit/push di branch sendiri, lalu
> PR ke main. Setelah PR-ku merged, kamu pull main dan merge ke zara-backend
> sebelum lanjut services/profil. Alasan tetap, nama panggilan dibaca dari
> users/{uid}.nama_panggilan; login email dan kata sandi tanpa tombol sosial.
> Hati/nyawa dan level dihapus, streak menunggu aturanmu dan kesepakatan tim.
> Aku sertakan kontrak provider di docs/vaka-tahap-1-5.md ya.
