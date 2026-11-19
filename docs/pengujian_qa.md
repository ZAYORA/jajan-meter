Dokumentasi Pengujian QA – Jajan Meter

1. Informasi Pengujian

* Nama Aplikasi: Jajan Meter
* Jenis Pengujian: Manual Testing
* Platform: Web (Google Chrome)
* Tools: Flutter, Visual Studio Code, Firebase
* Penguji: QA / System Analyst

2. Tujuan Pengujian

Pengujian dilakukan untuk memastikan fitur aplikasi Jajan Meter berjalan sesuai dengan fungsinya, menemukan kesalahan atau bug, serta memastikan perbaikan yang dilakukan dapat berjalan dengan baik.

3. Hasil Pengujian

ID	Fitur	Skenario Pengujian	Hasil yang Diharapkan	Hasil Pengujian	Status
QA-001	Profil	Membuka halaman Profil	Informasi akun ditampilkan	[PASS]
QA-002	Profil	Mengubah nama panggilan	Nama berhasil diperbarui	[PASS] dengan catatan
QA-003	Profil	Mengubah nama menjadi kosong	Sistem menolak nama kosong	[PASS]
QA-004	Profil	Mengubah nama lebih dari 30 karakter	Sistem membatasi jumlah karakter [PASS]
QA-005	Profil	Mengaktifkan mode gelap	Tema aplikasi berubah	[PASS]
QA-006	Profil	Membuka menu Bantuan	Informasi bantuan ditampilkan	[PASS]
QA-007	Profil	Melakukan logout	Pengguna keluar dari akun	[PASS]
QA-008	Target Hemat	Mengatur jatah harian	Jatah berhasil disimpan	[PASS]
QA-009	Target Hemat	Memeriksa pengeluaran hari ini	Total pengeluaran dihitung otomatis		[PASS]
QA-010	Target Hemat	Memeriksa sisa jatah	Sisa jatah dihitung otomatis  [PASS]

4. Catatan Bug dan Perbaikan

ID Bug	Permasalahan	Perbaikan	Status
BUG-001	Aplikasi menampilkan layar merah ketika nama panggilan diedit kembali	Memperbaiki pengelolaan TextEditingController pada dialog edit nama agar tidak digunakan setelah dispose	Fixed

5. Kesimpulan

Pengujian dilakukan untuk memastikan fitur Profil dan Target Hemat pada aplikasi Jajan Meter berjalan sesuai kebutuhan. Pengujian juga membantu menemukan kendala pada proses pengeditan nama panggilan yang kemudian diperbaiki. Pengujian lanjutan dilakukan untuk memastikan seluruh fitur berjalan dengan baik.
