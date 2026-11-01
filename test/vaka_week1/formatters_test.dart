import 'package:flutter_test/flutter_test.dart';
import 'package:jajan_meter/vaka_ui/formatters.dart';

void main() {
  setUpAll(initializeJajanFormats);

  test('rupiah menggunakan titik ribuan dan tanpa desimal', () {
    expect(formatRupiah(17000), 'Rp17.000');
    expect(formatRupiah(135000), 'Rp135.000');
    expect(formatRupiah(0), 'Rp0');
    expect(formatRupiah(-10000), '-Rp10.000');
    expect(formatRupiah(123456789), 'Rp123.456.789');
  });

  test('tanggal dan jam mengikuti bahasa Indonesia', () {
    final sample = DateTime(2026, 10, 14, 7, 30);
    expect(formatTanggal(sample), '14 Okt 2026');
    expect(formatTanggal(sample, denganHari: true), 'Rabu, 14 Okt 2026');
    expect(formatJam(sample), '07.30');
  });

  test('tanggal lintas tahun tetap benar', () {
    expect(formatTanggal(DateTime(2027, 1, 1)), '1 Jan 2027');
    expect(formatTanggal(DateTime(2026, 12, 31)), '31 Des 2026');
  });
}
