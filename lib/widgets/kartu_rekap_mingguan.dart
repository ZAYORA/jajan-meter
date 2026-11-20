import 'package:flutter/material.dart';

class KartuRekapMingguan extends StatelessWidget {
  final int totalPengeluaran;
  final String hariTerboros;
  final String kategoriTerbanyak;
  final String alasanTerbanyak;

  const KartuRekapMingguan({
    super.key,
    required this.totalPengeluaran,
    required this.hariTerboros,
    required this.kategoriTerbanyak,
    required this.alasanTerbanyak,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rekap Mingguan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Pengeluaran:'),
                Text('Rp $totalPengeluaran', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Hari Terboros:'),
                Text(hariTerboros, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Kategori Terbanyak:'),
                Text(kategoriTerbanyak, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Alasan Terbanyak:'),
                Text(alasanTerbanyak, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
