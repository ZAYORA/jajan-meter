# 🎨 Design System & UI/UX Guidelines

Dokumen ini berisi acuan desain UI/UX untuk pengembangan aplikasi. Seluruh komponen visual, tata letak, dan alur navigasi mengacu pada standar di bawah ini.

## 🔗 Tautan Desain (Figma)
https://www.figma.com/design/QkNqoG5ebjW8THknRUuLaJ/Untitled?node-id=0-1&t=jijvBJTR6YAsCwrH-1

---

## 🎨 Palet Warna (UI Kit final, diperbarui 13 November 2026)

| Kategori | Warna | Hex Code | Penggunaan Utama |
| :--- | :--- | :--- | :--- |
| **Primary** | Biru | `#1CB0F6` | Identitas, navigasi aktif, aksi sekunder |
| **Action** | Hijau | `#58CC02` | Simpan dan lanjut |
| **Achievement** | Emas | `#FFC800` | Penanda pilihan/pencapaian |
| **Expense / danger** | Merah | `#FF4B4B` | Pengeluaran dan hapus |
| **Background** | Terang / gelap | `#F7F7F7` / `#101E2B` | Latar aplikasi |

Acuan terbaru: **Fondasi Visual & UI Kit — Design Playbook 1.0**, serta ekspor
**Untitled (1).zip** (ponsel) dan **Untitled (2).zip** (tablet) dari Agnie.
Palet ini menggantikan palet lama biru/kuning/oranye. Font Poppins dibundel lokal;
kartu radius 24, border 2, bayangan padat Y6; tombol pil minimum 56.
Ponsel acuan 393×852, tablet 1024×1194 logical pixels, masing-masing terang/gelap.

Keputusan tim terbaru: Alasan tetap wajib; empat pilihan kategori
Makan/Kopi/Transport/Lainnya; nama panggilan untuk sapaan; autentikasi email–kata
sandi (alamat Gmail boleh), tanpa tombol Google/Apple/Facebook; tanpa hati/nyawa
atau level. Streak menunggu aturan yang disepakati. Implementasi dan kontrak
integrasi ada di [docs/vaka-tahap-1-5.md](docs/vaka-tahap-1-5.md).

---

## 📐 Daftar 9 Layar Utama (Screens)

1. **Onboarding:** Pengenalan aplikasi untuk pengguna baru (Dilengkapi aturan *redirect*).
2. **Beranda:** Ringkasan keuangan harian & akses cepat navigasi.
3. **Tambah Jajan:** Form input data pengeluaran jajan harian.
4. **Riwayat:** Daftar histori pengeluaran lengkap dengan fitur filter.
5. **Detail:** Rincian spesifik dari transaksi jajan tertentu.
6. **Statistik:** Grafik batang per hari & grafik donat per kategori/alasan pengeluaran.
7. **Target:** Pengaturan batas maksimal jajan harian/bulanan.
8. **Streak & Lencana:** Tracking konsistensi hemat + Ikon lencana (3, 7, 14 Hari).
9. **Pengaturan:** Profil pengguna, preferensi mode gelap, dan konfigurasi lainnya.

---

## 🧭 Navigasi & Komponen Utama
* **ShellRoute:** Digunakan untuk navigasi utama aplikasi.
* **Komponen Bersama (Reusable):** Kartu rekap, tombol utama, dan *header* standar yang diserahkan ke tim *developer* untuk diintegrasikan.
