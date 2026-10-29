
# Jajan Meter — Test Scenarios

**PIC:** Salsa (QA / System Analyst)  
**Status:** Draft — menunggu verifikasi terhadap proposal dan implementasi tim

## 1. Authentication

| ID | Skenario | Langkah Pengujian | Hasil yang Diharapkan |
|---|---|---|---|
| AUTH-01 | Daftar dengan data valid | Buka halaman daftar, isi email dan password yang valid, lalu tekan Daftar. | Akun berhasil dibuat dan aplikasi menampilkan alur setelah daftar sesuai rancangan. |
| AUTH-02 | Daftar dengan email tidak valid | Isi email dengan format tidak valid, lalu tekan Daftar. | Pendaftaran ditolak dan pesan validasi ditampilkan. |
| AUTH-03 | Login dengan akun valid | Masukkan email dan password akun yang sudah terdaftar. | Login berhasil dan pengguna masuk ke halaman utama. |
| AUTH-04 | Login dengan password salah | Masukkan email terdaftar dengan password yang salah. | Login ditolak dan pesan kesalahan ditampilkan. |
| AUTH-05 | Logout | Login, buka Pengaturan, lalu tekan Logout. | Sesi pengguna berakhir dan pengguna kembali ke halaman login. |
| AUTH-06 | Berpindah akun | Logout dari akun A, lalu login dengan akun B. | Aplikasi menampilkan data milik akun B. |
| AUTH-07 | Isolasi data antar akun | Buat data dengan akun A, lalu login dengan akun B. | Akun B tidak dapat melihat atau mengubah data privat milik akun A. |

## 2. Transaksi (CRUD)

| ID | Skenario | Langkah Pengujian | Hasil yang Diharapkan |
|---|---|---|---|
| CRUD-01 | Tambah transaksi valid | Tambahkan transaksi dengan jumlah dan tanggal valid. | Transaksi tersimpan dan tampil pada daftar. |
| CRUD-02 | Jumlah transaksi nol | Coba simpan transaksi dengan jumlah Rp0. | Aplikasi mengikuti aturan validasi yang disepakati tim. |
| CRUD-03 | Edit transaksi | Ubah nominal atau kategori transaksi yang sudah tersimpan. | Perubahan tersimpan dan data terbaru ditampilkan. |
| CRUD-04 | Ubah tanggal transaksi | Edit transaksi dan ganti tanggalnya. | Tanggal terbaru tampil dan rekap mengikuti tanggal yang benar. |
| CRUD-05 | Hapus transaksi | Hapus transaksi yang sudah tersimpan. | Transaksi tidak lagi tampil dan total diperbarui. |
| CRUD-06 | Konsistensi total | Tambah, edit, dan hapus transaksi, lalu periksa total pengeluaran. | Total sesuai dengan transaksi yang masih tersimpan. |

## 3. Kalkulasi dan Rekap

| ID | Skenario | Langkah Pengujian | Hasil yang Diharapkan |
|---|---|---|---|
| CALC-01 | Total pengeluaran | Masukkan beberapa transaksi dengan nominal yang diketahui. | Total sesuai penjumlahan transaksi yang dihitung. |
| CALC-02 | Sisa anggaran | Masukkan anggaran dan total pengeluaran. | Sisa anggaran sesuai rumus yang ditetapkan dalam proposal. |
| CALC-03 | Persentase anggaran | Masukkan anggaran dan pengeluaran. | Persentase penggunaan sesuai rumus proposal; anggaran nol ditangani dengan aman. |
| CALC-04 | Peringatan 20% | Uji nilai di bawah, tepat pada, dan di atas ambang 20%. | Peringatan muncul sesuai definisi ambang pada proposal. |
| CALC-05 | Status anggaran | Uji beberapa kondisi pengeluaran terhadap anggaran. | Status sesuai aturan pada proposal. |
| CALC-06 | Streak | Uji rangkaian hari dengan aktivitas dan hari tanpa aktivitas. | Streak mengikuti definisi pada proposal. |
| CALC-07 | Rekap mingguan | Masukkan data contoh untuk beberapa hari dan kategori. | Total, hari dengan pengeluaran terbesar, kategori teratas, dan alasannya sesuai data dan aturan rekap. |

## 4. Keamanan dan Isolasi Data

| ID | Skenario | Langkah Pengujian | Hasil yang Diharapkan |
|---|---|---|---|
| SEC-01 | Akses setelah logout | Logout, lalu coba membuka halaman yang membutuhkan login. | Pengguna diarahkan ke login atau akses ditolak. |
| SEC-02 | Akses data akun lain | Login dengan akun B dan coba mengakses data akun A. | Akses ditolak sesuai aturan keamanan Firebase. |

## Catatan Pelaksanaan

- Status awal seluruh skenario: **Belum Diuji**.
- Catat hasil aktual, status lulus/gagal, dan bukti pengujian saat implementasi tersedia.
- Verifikasi rumus, ambang batas, status, streak, dan aturan rekap terhadap proposal sebelum menetapkan hasil akhir.
- Laporkan bug melalui GitHub Issues dengan langkah reproduksi, hasil yang diharapkan, hasil aktual, dan bukti jika tersedia.
