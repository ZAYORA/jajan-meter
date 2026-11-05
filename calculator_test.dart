import 'package:flutter_test/flutter_test.dart';
// Sesuaikan nama package 'jajan_meter' dengan nama project kamu jika berbeda
import 'package:jajan_meter/utils/calculator.dart';

void main() {
  group('Pengujian JajanCalculator sesuai Proposal', () {
    final jatahHarian = 50000;

    final mockDataMingguan = [
      {'nominal': 15000, 'kategori': 'Kopi/minum', 'alasan': 'Stres', 'hari': 'Senin'},
      {'nominal': 25000, 'kategori': 'Makan berat', 'alasan': 'Lapar', 'hari': 'Selasa'},
      {'nominal': 15000, 'kategori': 'Kopi/minum', 'alasan': 'Stres', 'hari': 'Rabu'},
      {'nominal': 18000, 'kategori': 'Makan berat', 'alasan': 'Lapar', 'hari': 'Rabu'},
      {'nominal': 12000, 'kategori': 'Camilan', 'alasan': 'Ikut teman', 'hari': 'Kamis'},
      {'nominal': 20000, 'kategori': 'Makan berat', 'alasan': 'Lapar', 'hari': 'Jumat'},
      {'nominal': 18000, 'kategori': 'Makan berat', 'alasan': 'Hadiah', 'hari': 'Sabtu'},
      {'nominal': 12000, 'kategori': 'Transport', 'alasan': '', 'hari': 'Minggu'},
    ];

    test('Validasi Rekap Mingguan (Total 135rb, Rabu, Makan berat, Lapar)', () {
      final rekap = JajanCalculator.hitungRekapMingguan(mockDataMingguan);

      expect(rekap['total'], 135000);
      expect(rekap['hariTerboros'], 'Rabu');
      expect(rekap['kategoriTerbanyak'], 'Makan berat');
      expect(rekap['alasanTerbanyak'], 'Lapar');
    });

    test('Validasi Peringatan Sisa Jatah <= 20%', () {
      expect(JajanCalculator.isPeringatanAktif(10000, jatahHarian), true);
      expect(JajanCalculator.isPeringatanAktif(17000, jatahHarian), false);
    });
  });
}