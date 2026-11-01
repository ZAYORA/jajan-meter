import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

/// Panggil sekali sebelum runApp. Data tanggal Indonesia tersedia secara lokal.
Future<void> initializeJajanFormats() => initializeDateFormatting('id_ID');

/// Nominal domain tetap int (rupiah), tanpa angka desimal.
String formatRupiah(int value) {
  final digits = NumberFormat.decimalPattern('id_ID').format(value.abs());
  return value < 0 ? '-Rp$digits' : 'Rp$digits';
}

String formatTanggal(DateTime value, {bool denganHari = false}) {
  return DateFormat(
    denganHari ? 'EEEE, d MMM yyyy' : 'd MMM yyyy',
    'id_ID',
  ).format(value.toLocal());
}

String formatJam(DateTime value) =>
    DateFormat('HH.mm', 'id_ID').format(value.toLocal());
