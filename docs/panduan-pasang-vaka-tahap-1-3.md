# Memasang paket tahap 1–3 di laptop Vaka

Paket berbasis branch vaka-frontend efd426d yang digabung dengan main 236ccf1. Ini perubahan kode Flutter, bukan proyek baru dan bukan APK. Folder foundation yang sudah kamu buat tetap dipakai.

## A. Sinkronkan proyek

1. VS Code: File > Save All.
2. GitHub Desktop: pilih repository jajan-meter dan branch vaka-frontend.
3. Jika Changes berisi pekerjaan yang belum dicommit, review dan commit dahulu. Jangan Discard.
4. Klik Fetch origin, lalu Pull origin jika tersedia.
5. Pindah ke main, Fetch/Pull origin.
6. Kembali ke vaka-frontend. Pilih Branch > Merge into current branch... > main.
7. Jika muncul konflik, berhenti dan kirim screenshot. Jangan memilih versi file secara acak.
8. Klik Repository > Open in Visual Studio Code.

## B. Pasang patch

1. Download ZIP JajanMeter_Vaka_Tahap_1-3.zip.
2. File Explorer > Downloads. Klik kanan ZIP > Extract All / Ekstrak Semua.
3. Pastikan folder hasilnya bernama JajanMeter_Vaka_Tahap_1-3 dan berisi vaka-tahap-1-3.patch langsung di dalamnya.
4. VS Code > Terminal > New Terminal. Pastikan lokasi terminal folder jajan-meter.
5. Jalankan satu per satu:

```powershell
git branch --show-current
git status --short
```

Branch harus vaka-frontend; status bersih. Jika tidak bersih, selesaikan commit perubahan yang kamu kenali terlebih dahulu.

6. Periksa apakah patch cocok (belum mengubah file):

```powershell
git apply --check "$env:USERPROFILE\Downloads\JajanMeter_Vaka_Tahap_1-3\vaka-tahap-1-3.patch"
```

7. Jika tidak muncul error dan prompt terminal kembali, jalankan:

```powershell
git apply "$env:USERPROFILE\Downloads\JajanMeter_Vaka_Tahap_1-3\vaka-tahap-1-3.patch"
```

Jika folder Downloads berbeda, gunakan path sebenarnya. Jika patch gagal, kirim pesan error. Jangan gunakan --reject, jangan memaksa, dan jangan menjalankan patch dua kali setelah berhasil.

## C. Periksa dan jalankan

Tunggu setiap perintah selesai sebelum menjalankan yang berikutnya:

```powershell
flutter pub get
```

```powershell
flutter analyze lib/vaka_ui lib/main_vaka_preview.dart lib/main_vaka_ui_kit_preview.dart test/vaka_week1
```

```powershell
flutter test test/vaka_week1
```

```powershell
flutter run -d chrome -t lib/main_vaka_preview.dart
```

`pub get` mengambil paket yang sudah tercantum. Tidak perlu flutter create, pub add, flutter upgrade, menghapus lockfile, atau menambah dependency_overrides lagi. Konfigurasi dependensi branch Vaka dipertahankan.

## D. Coba HP/tablet dan kedua tema

1. Di jendela Chrome aplikasi, tekan F12 atau Ctrl+Shift+I.
2. Tekan Ctrl+Shift+M untuk toolbar perangkat.
3. Pilih Responsive, isi lebar 393 dan tinggi 852. Jika tampilan terlalu besar, pilih Fit to window pada zoom toolbar.
4. Klik toggle pada strip PRATINJAU UI untuk terang/gelap.
5. Klik Beranda/Riwayat/Statistik/Lencana dan kembali ke Beranda.
6. Klik tombol +. Pilih salah satu empat kategori dan salah satu Alasan; masukkan nominal.
7. Coba nominal kosong/0: Simpan harus nonaktif. Coba 25000 dengan kategori dan alasan: tombol aktif tetapi hanya memberi pesan pratinjau.
8. Gulir form HP untuk melihat seluruh isian dan tombol Simpan.
9. Ubah ukuran menjadi 1024 × 1194: menu samping dan layout dua kolom muncul. Coba tema gelap lagi.
10. Pengaturan pratinjau dapat mengubah nama contoh menjadi Vaka. Kembali ke Beranda untuk melihat sapaan.

Ini simulasi logical viewport, bukan pengujian pada iPad fisik. Tema dan nama di pratinjau hanya tersimpan selama aplikasi berjalan. Google/Apple/Facebook tersedia sebagai komponen nonaktif sampai layanan autentikasi siap. Hati/nyawa/level menunggu aturan kelompok.

## E. Commit dan push

1. Kembali ke terminal VS Code, tekan Ctrl+C untuk menghentikan Flutter.
2. Buka GitHub Desktop > Changes. Cocokkan file dengan FILES.txt dalam ZIP.
3. Jangan sertakan build/, .dart_tool/, atau konfigurasi Firebase lokal yang diabaikan Git.
4. Isi Summary: `sesuaikan fondasi UI dan kerangka HP tablet terang gelap`.
5. Klik Commit to vaka-frontend, lalu Push origin.
6. Preview Pull Request / Create Pull Request ke main. Judul: `Sesuaikan UI Kit dan kerangka HP/tablet terang-gelap`.
7. Tulis hasil tes aktual, sertakan screenshot, dan jelaskan bahwa ini tahap 1–3 dengan data contoh.
8. Minta Agnie/Salsa review sebelum merge mengikuti aturan tim.

Aplikasi produksi tetap lib/main.dart. Jangan menafsirkan pratinjau ini sebagai CRUD/login final yang sudah terhubung Firebase. Untuk Android, konfigurasi google-services.json tetap diperlukan oleh Gradle meskipun menjalankan entry point pratinjau; gunakan Chrome dahulu bila konfigurasi belum siap.
