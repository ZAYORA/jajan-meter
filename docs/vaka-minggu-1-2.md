# Serah terima komponen Vaka — minggu 1–2

Dasar: proposal final, ekspor UI Agnie, dan main `a34fccc`. Login wajib email/kata sandi mengikuti arahan terbaru kelompok, menggantikan autentikasi anonim atau keterangan tanpa akun pada materi lama.

## Menjalankan dan memeriksa

```sh
flutter pub get
flutter run -d chrome -t lib/main_vaka_preview.dart
```

Pratinjau memakai data contoh dan tidak mengakses Firebase. Tidak ada transaksi yang disimpan. `lib/main.dart`, AuthService, UserRepository, dan konfigurasi routing produksi tetap menjadi jalur aplikasi utama.

```sh
flutter analyze lib/vaka_ui lib/main_vaka_preview.dart test/vaka_week1
flutter test test/vaka_week1
```

Perintah analisis di atas dibatasi pada komponen Vaka karena konfigurasi Firebase lokal tidak ada di Git. Analisis dan pengujian aplikasi utama perlu dilakukan kembali setelah konfigurasi kelompok tersedia.

## Kontrak komponen

| Komponen | Input utama | Output/interaksi |
|---|---|---|
| `BudgetCard` | `int jatah`, `int terpakai`, `int sisa`, opsional `onAturJatah` | Tampilan angka, persentase sisa, keadaan belum diatur/20%/terlampaui. |
| `JajanTile` | Judul, nominal integer rupiah, kode/label kategori, tanggal, alasan opsional | `onTap` untuk rute Detail saat tersedia. |
| `JajanChoiceChips` | Daftar pilihan, `selectedValue`, `optional`, `useYellow` | `onChanged(String?)`; pemanggil menyimpan pilihan. |
| `JajanBottomBar` | `selectedIndex`, `onSelected` | Memilih satu dari empat tab. |
| `formatRupiah` | Integer satuan rupiah | Contoh `Rp15.000`, `Rp0`, `-Rp10.000`. |
| `formatTanggal` / `formatJam` | DateTime | Tanggal Indonesia dan jam `HH.mm`, dalam waktu lokal. |

Jalankan `initializeJajanFormats()` sebelum formatter tanggal dipakai. Font Inter dibundel dengan lisensi OFL; deklarasi font perlu ada pada `pubspec.yaml`.

Empat tujuan tab: `/`, `/statistik`, `/target`, `/pengaturan`, mengikuti peta rute proposal. `JajanBottomBar` sengaja tidak memiliki router sendiri. Agnie dapat menghubungkan `onSelected` dengan `context.go(jajanTabRoutes[index])` di ShellRoute, dan mendapatkan `selectedIndex` dari lokasi rute aktif. Redirect login/onboarding tetap dikelola router utama.

Nominal dan tanggal Beranda pratinjau mengikuti contoh desain: 14 Oktober 2026, Rp50.000 jatah, Rp33.000 terpakai, Rp17.000 sisa, bar sisa 34%. Ini fixture tetap, bukan tanggal hari ini atau pembacaan Firestore.

`BudgetCard` menerima total dan sisa dari pemanggil, bukan menghitung total transaksi. Rasio dan ambang yang ada saat ini hanya untuk presentasi komponen. Pada minggu 3–4, sambungkan nilai ke getter JajanProvider dan hasil calculator Salsa agar aturan tepi tetap konsisten.

Kode kategori: `makan`, `kopi`, `camilan`, `transport`, `lainnya`. Kode alasan: `lapar`, `stres`, `ikut_teman`, `hadiah`. Alasan boleh null. Label dapat disesuaikan tanpa mengubah kode penyimpanan. Cocokkan lagi dengan model/repository Zara sebelum mengaktifkan penyimpanan.

## Cakupan saat ini

- Kerangka empat tab dan halaman contoh komponen.
- Palet, font, ukuran teks, format rupiah/tanggal.
- Komponen dengan parameter dan callback untuk integrasi.
- Tes format, nominal nol, keadaan jatah, pemilihan chip, perpindahan tab, dan lebar 320/393/768 dengan teks 1,5 kali.

Statistik, Target, dan Pengaturan pada pratinjau berupa placeholder. Tombol Tambah Jajan membuka sarana uji komponen; tombol Simpan hanya menampilkan pesan validasi. Provider, CRUD, Riwayat/Detail, router produksi, pengaturan tema, login UI final, serta integrasi Firestore belum diselesaikan dalam paket minggu 1–2 ini.

## Review dan bukti

Vaka menjalankan pemeriksaan di laptopnya dan mencatat hasil aktual. Agnie meninjau kesesuaian visual dan kontrak navigasi. Salsa menguji UI serta memberi status lulus/gagal. Keberhasilan pratinjau tidak menggantikan checkpoint kelompok berupa aplikasi utama yang benar-benar terhubung ke Firebase.

Gunakan PR ke main dari `vaka-frontend`. Cantumkan perintah menjalankan pratinjau, screenshot, hasil analisis/tes aktual, dan batas cakupan di atas. Jangan memasukkan file konfigurasi yang diabaikan `.gitignore` secara paksa.
