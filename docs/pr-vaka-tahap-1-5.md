Beranda dan transaksi sebelumnya masih terpisah antara preview UI dan layar
fungsional. Perubahan ini menyambungkan UI HP/tablet terang–gelap ke
JajanProvider, repository Zara, serta kalkulator Salsa. Tambah, filter riwayat,
detail, edit tanggal, dan hapus dengan konfirmasi menggunakan state yang sama.

- Membuka getter total/sisa/progres/peringatan/rekap untuk integrasi tim.
- Mempertahankan Alasan dan identitas kategori lama dalam empat kelompok UI.
- Membaca nama_panggilan dari profil; menghapus komponen login sosial.
- Mengikat provider, Navigator, dan repository pada sesi UID.
- Menyertakan demo memori, tes, screenshot, dan panduan setup.

Validasi penyiapan paket: 46 tes lulus; analisis terarah tanpa masalah; build web
demo berhasil. Screenshot HP/tablet terang–gelap ada di
`docs/screenshots/vaka-tahap-1-5` dan memakai fixture uji, bukan akun produksi.

Hasil laptop Vaka (isi hasil aktual sebelum mengirim PR):
- flutter analyze terarah: [isi]
- flutter test: [isi]
- Demo CRUD di Chrome: [isi]
- Firebase kelompok/Android: [isi atau Belum diuji]

Batas: konfigurasi Firebase tidak disertakan. Pengujian Rules, persistence akun,
offline, Android/iOS fisik belum dibuktikan oleh tes demo. Layar login masih
versi fungsional Zara; finalisasi desainnya tahap 6. Statistik/streak lengkap,
profil, onboarding dan router final mengikuti penanggung jawab masing-masing.
Penyimpanan nama_panggilan menunggu Zara; provider sudah membaca field tersebut.
