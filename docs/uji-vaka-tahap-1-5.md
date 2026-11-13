# Skenario uji tahap 1–5

Tanggal penyiapan 13 November 2026. Pengujian otomatis menggunakan sumber data
memori yang mengimplementasikan kontrak sama dengan adapter repository. Kolom
Firebase/laptop Vaka harus diisi dari pengujian aktual, bukan disalin sebagai lulus.

| ID | Langkah / kondisi | Hasil yang diharapkan | Otomatis | Firebase / perangkat Vaka |
| --- | --- | --- | --- | --- |
| P01 | Muat profil jatah 100.000 dan transaksi 55.000 | Sisa 45.000, terpakai 55%, sisa 45% | Lulus | Belum diuji |
| P02 | Jatah 0 | Belum diatur, peringatan tidak aktif, bar aman | Lulus | Belum diuji |
| P03 | Pengeluaran 80.000 dari 100.000 | Peringatan tepat di sisa 20% | Lulus | Belum diuji |
| P04 | Pengeluaran 120.000 dari 100.000 | Sisa -20.000, Terlampaui, bar sisa 0 | Lulus | Belum diuji |
| P05 | Hari/minggu/bulan dengan batas tengah malam | Awal masuk, akhir eksklusif, Senin awal minggu | Lulus | Belum diuji |
| P06 | Filter empat kelompok dengan kategori custom | Custom masuk Lainnya; ID/nama asli tetap | Lulus | Belum diuji |
| P07 | Data Tabel 3.10 | 135.000; Rabu; Makan berat; Lapar | Lulus | Belum diuji |
| P08 | Tambah nominal 0/negatif atau alasan kosong | Tidak ada panggilan tulis repository | Lulus | Belum diuji |
| P09 | Edit nominal kategori custom/legacy | ID dan nama kategori tidak berubah | Lulus | Belum diuji |
| P10 | Pilih kategori canonical yang belum ada | Dibuat sekali; ID hasil repository dipakai | Lulus | Belum diuji |
| P11 | Edit tanggal hari ini menjadi kemarin | Beranda/riwayat/rekap diperbarui | Lulus | Belum diuji |
| P12 | Hapus transaksi | Total konsisten setelah stream berubah | Lulus | Belum diuji |
| P13 | Stream error, kemudian Coba lagi | Error terpisah dari data kosong; stream lama dilepas | Lulus | Belum diuji |
| P14 | Simpan error, kemudian ulangi | Form dan nominal bertahan; berhasil setelah retry | Lulus | Belum diuji |
| P15 | Tekan simpan dua kali saat pending | Satu operasi tulis | Lulus | Belum diuji |
| P16 | Pergantian hari / aplikasi aktif lagi | Angka harian dan filter hari ini diperbarui | Lulus | Belum diuji |
| P17 | Sesi dilepas ketika kategori sedang dibuat | Tidak melanjutkan tulis transaksi akun lama | Lulus | Belum diuji |
| U01 | Tambah → Riwayat → filter → Detail → Edit → Hapus | Alur lengkap pada HP/tablet terang/gelap | Lulus | Belum diuji |
| U02 | Hapus → Batal | Transaksi tetap ada | Lulus | Belum diuji |
| U03 | Ganti akun ketika Detail terbuka | Route dan data akun lama tidak tampil | Lulus (state UI) | Rules belum diuji |
| U04 | Ubah tema dan jatah di Pengaturan, kembali | Tema dan nilai mengikuti stream profil | Lulus | Belum diuji |
| U05 | Layar 320px, teks 1,5×, resize ke tablet | Tidak overflow; isian form tidak hilang | Lulus | Belum diuji |
| U06 | Cek tombol sosial/hati/level | Tidak ditampilkan | Lulus untuk sosial; inspeksi untuk hati/level | Belum diuji |
| F01 | Masuk akun uji, tambah, tutup, masuk lagi | Transaksi masih ada di Firestore akun yang sama | Belum | Wajib dicoba bersama Zara |
| F02 | Masuk akun A lalu B | Data A tidak dibaca/diubah akun B melalui Rules | Belum | Wajib dicoba Zara/Salsa |
| F03 | Putus koneksi saat menulis, sambungkan kembali | Status menunggu/sinkronisasi dinilai dari perangkat nyata | Belum | Wajib dicoba Zara/Salsa |
| F04 | Jalankan main di emulator/HP Android | Login dan CRUD tanpa error konfigurasi | Belum | Perlu konfigurasi kelompok |
| F05 | Jalankan di iPad/iOS | Layout dan interaksi benar di perangkat iOS | Belum | Perlu macOS/Xcode/perangkat yang sesuai |
