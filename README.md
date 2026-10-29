# Jajan Meter

Aplikasi mobile pencatat dan penganalisis uang jajan mahasiswa,
dibangun dengan Flutter dan Firebase.

> Proyek kelompok mata kuliah Pemrograman Aplikasi Bergerak,
> Program Studi S1 Sistem Informasi, Universitas Negeri Surabaya (2026).

## Latar belakang
Pengeluaran kecil sehari-hari sering tidak tercatat dan membuat uang jajan
cepat habis. Jajan Meter membantu mencatat jajan dengan cepat (target
3 ketukan) dan melihat pola pengeluarannya.

## Fitur
- Beranda: sisa jatah harian dan transaksi terbaru
- Tambah Jajan: nominal, kategori, alasan, tanggal, catatan
- Riwayat: filter hari, minggu, bulan, kategori; edit dan hapus
- Statistik: grafik per hari, kategori, dan alasan
- Target Hemat: jatah, progres, peringatan sisa 20%
- Streak dan Lencana (3, 7, 14 hari)
- Rekap Mingguan
- Pendukung: Onboarding, Pengaturan, mode gelap, ekspor CSV

## Screenshot
(ditambahkan setelah aplikasi berjalan)

## Teknologi
Flutter, Dart, Firebase (Cloud Firestore dan Authentication anonim),
Provider, go_router, fl_chart.

## Tim dan peran
| Nama | NIM | Peran | Branch |
|---|---|---|---|
| Agnie Esqi Rachmadhani | 24051214031 | Project Manager dan UI/UX | agnie-ui |
| Tata Ivanka | 24051214001 | Front-End dan State Management | vaka-frontend |
| Azzahra Anggarista Yoan Putri | 24051214032 | Back-End dan Firebase | zara-backend |
| Fahriza Salsabila | 24051214019 | QA dan System Analyst | salsa-qa |

## Cara menjalankan
1. Pastikan Flutter terpasang (`flutter --version`).
2. `git clone <url-repo>` lalu `flutter pub get`.
3. Buat project Firebase sendiri, aktifkan Firestore dan Authentication anonim.
4. Jalankan `flutterfire configure`.
5. Pasang Security Rules dari folder `docs/`, lalu `flutter run`.

## Pengujian
Skenario uji ada di `docs/test-cases.md`. Unit test logika perhitungan
ada di folder `test/` dan dijalankan dengan `flutter test`.

## Aturan kerja tim
1. Jangan push langsung ke `main`.
2. Kerja di branch masing-masing, lalu buka Pull Request ke `main`.
3. Satu PR minimal di-review satu orang lain sebelum merge.
4. Satu fitur dianggap selesai setelah lolos uji QA.
5. Jangan commit file rahasia atau konfigurasi Firebase pribadi.
6. Semua memakai versi Flutter yang sama (`flutter --version`).
7. Pesan commit singkat dan jelas, misalnya `tambah form Tambah Jajan`.

## Pelaporan bug
Buat Issue baru dengan template Bug Report dan beri label yang sesuai.
