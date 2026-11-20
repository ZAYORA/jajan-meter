import '../models/jajan.dart';

/// Hasil pengolahan transaksi untuk satu periode rekap.
class HasilRekap {
  final String periode;
  final DateTime tanggalAcuan;
  final List<Jajan> daftarTransaksi;
  final int totalPengeluaran;
  final int jumlahTransaksi;
  final Map<String, int> pengeluaranPerKategori;

  /// Berisi 12 nilai (Januari sampai Desember) jika periode Tahunan.
  /// Untuk periode lain, nilainya berupa list kosong.
  final List<int> pengeluaranPerBulan;

  /// Rata-rata pengeluaran per bulan untuk rekap tahunan.
  /// Nilainya null untuk periode selain Tahunan.
  final double? rataRataBulanan;

  const HasilRekap({
    required this.periode,
    required this.tanggalAcuan,
    required this.daftarTransaksi,
    required this.totalPengeluaran,
    required this.jumlahTransaksi,
    required this.pengeluaranPerKategori,
    required this.pengeluaranPerBulan,
    required this.rataRataBulanan,
  });
}

/// Pusat perhitungan rekap pengeluaran Jajan Meter.
/// Repository ini mengolah data transaksi yang sudah diambil dari Firestore;
/// tidak melakukan pembacaan atau penulisan Firestore secara langsung.
class RekapRepository {
  HasilRekap hitungRekap({
    required List<Jajan> transaksi,
    required String periode,
    required DateTime tanggal,
  }) {
    final awalHari = DateTime(tanggal.year, tanggal.month, tanggal.day);
    late final DateTime awalPeriode;
    late final DateTime akhirPeriode;

    switch (periode) {
      case 'Harian':
        awalPeriode = awalHari;
        akhirPeriode = awalPeriode.add(const Duration(days: 1));
        break;
      case 'Mingguan':
        awalPeriode = awalHari.subtract(Duration(days: awalHari.weekday - 1));
        akhirPeriode = awalPeriode.add(const Duration(days: 7));
        break;
      case 'Bulanan':
        awalPeriode = DateTime(tanggal.year, tanggal.month, 1);
        akhirPeriode = DateTime(tanggal.year, tanggal.month + 1, 1);
        break;
      case 'Tahunan':
        awalPeriode = DateTime(tanggal.year, 1, 1);
        akhirPeriode = DateTime(tanggal.year + 1, 1, 1);
        break;
      default:
        throw ArgumentError.value(periode, 'periode', 'Periode tidak dikenal.');
    }

    final daftarTransaksi = transaksi.where((jajan) {
      return !jajan.tanggal.isBefore(awalPeriode) &&
          jajan.tanggal.isBefore(akhirPeriode);
    }).toList()..sort((a, b) => b.tanggal.compareTo(a.tanggal));

    var totalPengeluaran = 0;
    final pengeluaranPerKategori = <String, int>{};
    final pengeluaranPerBulan = periode == 'Tahunan'
        ? List<int>.filled(12, 0)
        : <int>[];

    for (final jajan in daftarTransaksi) {
      totalPengeluaran += jajan.nominal;
      pengeluaranPerKategori.update(
        jajan.kategori,
        (total) => total + jajan.nominal,
        ifAbsent: () => jajan.nominal,
      );

      if (periode == 'Tahunan') {
        pengeluaranPerBulan[jajan.tanggal.month - 1] += jajan.nominal;
      }
    }

    final kategoriTerurut = pengeluaranPerKategori.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return HasilRekap(
      periode: periode,
      tanggalAcuan: tanggal,
      daftarTransaksi: daftarTransaksi,
      totalPengeluaran: totalPengeluaran,
      jumlahTransaksi: daftarTransaksi.length,
      pengeluaranPerKategori: Map.fromEntries(kategoriTerurut),
      pengeluaranPerBulan: pengeluaranPerBulan,
      rataRataBulanan: periode == 'Tahunan' ? totalPengeluaran / 12 : null,
    );
  }
}
