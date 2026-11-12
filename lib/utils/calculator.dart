// lib/utils/calculator.dart

class JajanCalculator {
  /// 1. Menghitung Total Pengeluaran Hari Ini
  static int hitungTotalHariIni(List listJajan, String hariIni) {
    int total = 0;
    for (var item in listJajan) {
      if (item is Map && item['hari'] == hariIni) {
        total += (item['nominal'] as num?)?.toInt() ?? 0;
      }
    }
    return total;
  }

  /// 2. Menghitung Sisa Jatah Harian
  static int hitungSisaJatah(int jatahHarian, int totalHariIni) {
    return jatahHarian - totalHariIni;
  }

  /// 3. Menghitung Persentase Terpakai (Maksimal 100%)
  static double hitungPersenTerpakai(int totalHariIni, int jatahHarian) {
    if (jatahHarian <= 0) return 0.0;
    double persen = (totalHariIni / jatahHarian) * 100;
    return persen > 100 ? 100.0 : persen;
  }

  /// 4. Peringatan Aktif jika sisa jatah <= 20% dari jatah harian
  static bool isPeringatanAktif(int sisaJatah, int jatahHarian) {
    if (jatahHarian <= 0) return false;
    return (sisaJatah / jatahHarian) <= 0.20;
  }

  /// 5. Status Target (Tercapai atau Terlampaui)
  static String getStatusTarget(int totalHariIni, int jatahHarian) {
    return totalHariIni <= jatahHarian ? "Tercapai" : "Terlampaui";
  }

  /// 6. Menghitung Rekap Mingguan (Sesuai Proposal Tabel 3.10)
  static Map<String, dynamic> hitungRekapMingguan(List listJajanMingguIni) {
    if (listJajanMingguIni.isEmpty) {
      return {
        'total': 0,
        'hariTerboros': '-',
        'kategoriTerbanyak': '-',
        'alasanTerbanyak': '-',
      };
    }

    int total = 0;
    Map<String, int> totalPerHari = {};
    Map<String, int> totalPerKategori = {};
    Map<String, int> totalPerAlasan = {};

    for (var jajan in listJajanMingguIni) {
      if (jajan is Map) {
        int nominal = (jajan['nominal'] as num?)?.toInt() ?? 0;
        String hari = jajan['hari'] as String? ?? '-';
        String kategori = jajan['kategori'] as String? ?? '-';
        String alasan = jajan['alasan'] as String? ?? '';

        total += nominal;
        totalPerHari[hari] = (totalPerHari[hari] ?? 0) + nominal;
        totalPerKategori[kategori] =
            (totalPerKategori[kategori] ?? 0) + nominal;

        if (alasan.isNotEmpty) {
          totalPerAlasan[alasan] = (totalPerAlasan[alasan] ?? 0) + nominal;
        }
      }
    }

    String hariTerboros = totalPerHari.isNotEmpty
        ? totalPerHari.entries.reduce((a, b) => a.value > b.value ? a : b).key
        : '-';

    String kategoriTerbanyak = totalPerKategori.isNotEmpty
        ? totalPerKategori.entries
              .reduce((a, b) => a.value > b.value ? a : b)
              .key
        : '-';

    String alasanTerbanyak = totalPerAlasan.isNotEmpty
        ? totalPerAlasan.entries.reduce((a, b) => a.value > b.value ? a : b).key
        : '-';

    return {
      'total': total,
      'hariTerboros': hariTerboros,
      'kategoriTerbanyak': kategoriTerbanyak,
      'alasanTerbanyak': alasanTerbanyak,
    };
  }
}
