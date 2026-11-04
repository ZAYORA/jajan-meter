# 🎨 Design System & UI/UX Guidelines

Dokumen ini berisi acuan desain UI/UX untuk pengembangan aplikasi. Seluruh komponen visual, tata letak, dan alur navigasi mengacu pada standar di bawah ini.

## 🔗 Tautan Desain (Figma)
https://www.figma.com/design/QkNqoG5ebjW8THknRUuLaJ/Untitled?node-id=0-1&t=jijvBJTR6YAsCwrH-1

---

## 🎨 Palet Warna (Color Palette)

| Kategori | Warna | Hex Code | Penggunaan Utama |
| :--- | :--- | :--- | :--- |
| **Primary** | Biru | `#2563EB` | Header, Button Utama, Navigasi Active |
| **Secondary** | Kuning | `#FBBF24` | Accents, Badge, Highlighting |
| **Warning/Highlight** | Oranye | `#F97316` | Alert, Streak Count, CTA Khusus |
| **Background** | Terang / Gelap | `#F8FAFC` / `#0F172A` | Latar belakang aplikasi (Mode Terang/Gelap) |

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
