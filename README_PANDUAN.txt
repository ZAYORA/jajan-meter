JAJAN METER - FONDASI VISUAL (PATCH AWAL)
========================================

ISI
---
- Warna resmi Jajan Meter
- Tema terang dan gelap
- Tipografi Poppins
- Komponen tombol, kartu, chip kategori, input, dan baris transaksi
- Halaman pratinjau UI Kit yang terpisah dari main.dart

PENTING
-------
Patch ini menambahkan folder baru:
lib/vaka_ui/foundation/
dan file pratinjau baru:
lib/main_vaka_ui_kit_preview.dart

Patch ini TIDAK mengganti main.dart, AuthGate, repository Zara,
JajanProvider, atau konfigurasi Firebase.

FONT POPPINS
------------
Poppins dipakai melalui package google_fonts. Package mengambil font
dari Google Fonts saat pertama kali diperlukan dan menyimpannya dalam
cache. Koneksi internet diperlukan pada penggunaan pertama. Tidak
perlu menunggu file font dari anggota tim.

CARA MEMASANG
-------------
1. Ekstrak ZIP ke folder utama proyek jajan-meter.
2. Jika Windows bertanya, pilih gabungkan/merge folder, bukan mengganti
   seluruh folder lib.
3. Buka terminal VS Code pada folder jajan-meter.
4. Jalankan:

   flutter pub add google_fonts
   flutter pub get

5. Jalankan pratinjau UI Kit:

   flutter run -t lib/main_vaka_ui_kit_preview.dart -d chrome

6. Periksa file fondasi:

   flutter analyze lib/vaka_ui/foundation lib/main_vaka_ui_kit_preview.dart

7. Jalankan tes:

   flutter test

CATATAN
-------
- Jangan hapus import Firebase dari lib/main.dart.
- Jangan mengganti main.dart dengan file preview.
- File preview ini adalah entry point terpisah agar UI bisa diperiksa
  meskipun firebase_options.dart belum tersedia.
- Empat label kategori pada preview hanya contoh tampilan. Saat integrasi,
  gunakan ID dan data kategori yang sudah disepakati dengan Zara.
- Widget ini hanya komponen presentasional; tidak mengubah data Firestore.

LISENSI FONT
------------
Poppins dikembangkan oleh Indian Type Foundry dan didistribusikan
melalui Google Fonts di bawah SIL Open Font License 1.1.
https://github.com/google/fonts/tree/main/ofl/poppins
