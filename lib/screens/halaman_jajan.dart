import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/jajan.dart';
import '../models/kategori.dart';
import '../services/jajan_repository.dart';
import '../services/kategori_repository.dart';
import '../services/rekap_repository.dart';

class HalamanJajan extends StatefulWidget {
  const HalamanJajan({super.key});

  @override
  State<HalamanJajan> createState() => _HalamanJajanState();
}

class _HalamanJajanState extends State<HalamanJajan> {
  final JajanRepository _jajanRepository = JajanRepository();
  final KategoriRepository _kategoriRepository = KategoriRepository();
  final RekapRepository _rekapRepository = RekapRepository();

  final TextEditingController _nominalController = TextEditingController();
  final TextEditingController _alasanController = TextEditingController();

  String? _kategoriTerpilihId;
  bool _sedangMenyimpan = false;

  String formatRupiah(int nominal) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(nominal);
  }

  void tampilkanPesan(String pesan) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pesan)));
  }

  // ==========================================
  // MENAMBAHKAN KATEGORI CUSTOM
  // ==========================================

  Future<void> _tambahKategori() async {
    final controller = TextEditingController();

    try {
      final nama = await showDialog<String>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Tambah Kategori'),
            content: TextField(
              controller: controller,
              autofocus: true,
              maxLength: 30,
              decoration: const InputDecoration(
                labelText: 'Nama kategori',
                hintText: 'Contoh: Skincare',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogContext, controller.text.trim());
                },
                child: const Text('Simpan'),
              ),
            ],
          );
        },
      );

      if (nama == null || nama.trim().isEmpty || !mounted) return;

      final id = await _kategoriRepository.tambahKategori(nama);

      if (!mounted) return;

      setState(() {
        _kategoriTerpilihId = id;
      });

      tampilkanPesan('Kategori berhasil ditambahkan!');
    } catch (e) {
      tampilkanPesan('Gagal menambahkan kategori: $e');
    } finally {
      controller.dispose();
    }
  }

  // ==========================================
  // MENAMBAHKAN TRANSAKSI
  // ==========================================

  Future<void> _tambahJajan(List<Kategori> kategoriList) async {
    final nominal = int.tryParse(_nominalController.text.trim());
    final alasan = _alasanController.text.trim();

    final kategori = kategoriList
        .where((item) => item.id == _kategoriTerpilihId)
        .firstOrNull;

    if (nominal == null || nominal <= 0 || alasan.isEmpty || kategori == null) {
      tampilkanPesan('Isi nominal, kategori, dan alasan dengan benar.');
      return;
    }

    setState(() => _sedangMenyimpan = true);

    try {
      final jajan = Jajan(
        nominal: nominal,
        kategori: kategori.nama,
        kategoriId: kategori.id,
        alasan: alasan,
        tanggal: DateTime.now(),
      );

      await _jajanRepository.tambahJajan(jajan);

      _nominalController.clear();
      _alasanController.clear();

      tampilkanPesan('Transaksi berhasil disimpan!');
    } catch (e) {
      tampilkanPesan('Gagal menyimpan transaksi: $e');
    } finally {
      if (mounted) {
        setState(() => _sedangMenyimpan = false);
      }
    }
  }

  // ==========================================
  // MENGEDIT TRANSAKSI
  // ==========================================

  Future<void> _editJajan(Jajan jajan, List<Kategori> kategoriList) async {
    final nominalController = TextEditingController(
      text: jajan.nominal.toString(),
    );

    final alasanController = TextEditingController(text: jajan.alasan);

    String? kategoriId = jajan.kategoriId;

    // Menangani transaksi lama yang belum memiliki kategoriId.
    const legacyId = '__kategori_lama__';

    if (kategoriId == null ||
        !kategoriList.any((item) => item.id == kategoriId)) {
      kategoriId = legacyId;
    }

    try {
      final hasil = await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              final items = kategoriList
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item.id,
                      child: Text(item.nama),
                    ),
                  )
                  .toList();

              if (kategoriId == legacyId) {
                items.add(
                  DropdownMenuItem<String>(
                    value: legacyId,
                    child: Text(jajan.kategori),
                  ),
                );
              }

              return AlertDialog(
                title: const Text('Edit Transaksi'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nominalController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Nominal (Rp)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: kategoriId,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Kategori',
                          border: OutlineInputBorder(),
                        ),
                        items: items,
                        onChanged: (value) {
                          setDialogState(() => kategoriId = value);
                        },
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: alasanController,
                        decoration: const InputDecoration(
                          labelText: 'Alasan jajan',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('Batal'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext, {'kategoriId': kategoriId});
                    },
                    child: const Text('Simpan'),
                  ),
                ],
              );
            },
          );
        },
      );

      if (hasil == null || !mounted) return;

      final nominal = int.tryParse(nominalController.text.trim());
      final alasan = alasanController.text.trim();
      final idKategoriBaru = hasil['kategoriId'] as String?;

      if (nominal == null || nominal <= 0 || alasan.isEmpty) {
        tampilkanPesan('Isi semua data dengan benar.');
        return;
      }

      if (idKategoriBaru == null) {
        tampilkanPesan('Pilih kategori terlebih dahulu.');
        return;
      }

      final kategoriBaru = kategoriList
          .where((item) => item.id == idKategoriBaru)
          .firstOrNull;

      final namaKategori = idKategoriBaru == legacyId
          ? jajan.kategori
          : kategoriBaru?.nama;

      if (namaKategori == null) {
        tampilkanPesan('Kategori tidak ditemukan.');
        return;
      }

      await _jajanRepository.ubahJajan(
        Jajan(
          id: jajan.id,
          nominal: nominal,
          kategori: namaKategori,
          kategoriId: idKategoriBaru == legacyId ? null : idKategoriBaru,
          alasan: alasan,
          tanggal: jajan.tanggal,
          catatan: jajan.catatan,
          dibuatPada: jajan.dibuatPada,
        ),
      );

      tampilkanPesan('Transaksi berhasil diperbarui!');
    } catch (e) {
      tampilkanPesan('Gagal mengedit transaksi: $e');
    } finally {
      nominalController.dispose();
      alasanController.dispose();
    }
  }

  // ==========================================
  // MENGHAPUS TRANSAKSI
  // ==========================================

  Future<void> _hapusJajan(Jajan jajan) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Transaksi?'),
          content: Text(
            'Apakah kamu yakin ingin menghapus '
            '${jajan.kategori} sebesar ${formatRupiah(jajan.nominal)}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (konfirmasi != true) return;

    try {
      await _jajanRepository.hapusJajan(jajan.id);
      tampilkanPesan('Transaksi berhasil dihapus!');
    } catch (e) {
      tampilkanPesan('Gagal menghapus transaksi: $e');
    }
  }

  // ==========================================
  // FORM TRANSAKSI
  // ==========================================

  Widget _buildForm(List<Kategori> kategoriList) {
    final kategoriValid = kategoriList.any(
      (item) => item.id == _kategoriTerpilihId,
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _nominalController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Nominal (Rp)',
              prefixIcon: Icon(Icons.payments_outlined),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: kategoriValid ? _kategoriTerpilihId : null,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Kategori',
                    prefixIcon: Icon(Icons.category_outlined),
                    border: OutlineInputBorder(),
                  ),
                  hint: const Text('Pilih kategori'),
                  items: kategoriList.map((kategori) {
                    return DropdownMenuItem<String>(
                      value: kategori.id,
                      child: Text(kategori.nama),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _kategoriTerpilihId = value);
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                tooltip: 'Tambah kategori',
                onPressed: _tambahKategori,
                icon: const Icon(Icons.add),
              ),
            ],
          ),

          if (kategoriList.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Belum ada kategori. Tekan tombol + untuk menambahkan.',
                  style: TextStyle(color: Colors.orange),
                ),
              ),
            ),

          const SizedBox(height: 12),

          TextField(
            controller: _alasanController,
            decoration: const InputDecoration(
              labelText: 'Alasan jajan',
              hintText: 'Contoh: Makan siang',
              prefixIcon: Icon(Icons.edit_note),
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _sedangMenyimpan
                  ? null
                  : () => _tambahJajan(kategoriList),
              icon: const Icon(Icons.save_outlined),
              label: Text(
                _sedangMenyimpan ? 'Menyimpan...' : 'Simpan Transaksi',
              ),
            ),
          ),

          const Divider(height: 32),

          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Riwayat Transaksi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: StreamBuilder<List<Jajan>>(
              stream: _jajanRepository.streamJajan(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Gagal mengambil data: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final daftarJajan = snapshot.data ?? [];

                if (daftarJajan.isEmpty) {
                  return const Center(child: Text('Belum ada transaksi.'));
                }

                return ListView.builder(
                  itemCount: daftarJajan.length,
                  itemBuilder: (context, index) {
                    final jajan = daftarJajan[index];

                    return Card(
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.shopping_bag_outlined),
                        ),
                        title: Text(jajan.kategori),
                        subtitle: Text(
                          '${jajan.alasan}\n'
                          '${DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(jajan.tanggal)}',
                        ),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              formatRupiah(jajan.nominal),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'edit') {
                                  _editJajan(jajan, kategoriList);
                                } else if (value == 'hapus') {
                                  _hapusJajan(jajan);
                                }
                              },
                              itemBuilder: (context) => const [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit'),
                                ),
                                PopupMenuItem(
                                  value: 'hapus',
                                  child: Text('Hapus'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // FILTER PERIODE REKAP
  // ==========================================

  String _periode = 'Harian';
  DateTime _tanggalRekap = DateTime.now();

  String _labelTanggal() {
    if (_periode == 'Harian') {
      return DateFormat('dd MMMM yyyy', 'id_ID').format(_tanggalRekap);
    }

    if (_periode == 'Mingguan') {
      final awal = DateTime(
        _tanggalRekap.year,
        _tanggalRekap.month,
        _tanggalRekap.day,
      ).subtract(Duration(days: _tanggalRekap.weekday - 1));

      final akhir = awal.add(const Duration(days: 6));

      return '${DateFormat('dd MMM', 'id_ID').format(awal)} - '
          '${DateFormat('dd MMM yyyy', 'id_ID').format(akhir)}';
    }

    if (_periode == 'Bulanan') {
      return DateFormat('MMMM yyyy', 'id_ID').format(_tanggalRekap);
    }

    if (_periode == 'Tahunan') {
      return 'Tahun ${_tanggalRekap.year}';
    }

    return '';
  }

  Future<void> _pilihTanggal() async {
    final tanggal = await showDatePicker(
      context: context,
      initialDate: _tanggalRekap,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (tanggal != null) {
      setState(() => _tanggalRekap = tanggal);
    }
  }

  // ==========================================
  // REKAP PENGELUARAN
  // ==========================================

  Widget _buildRekap() {
    return StreamBuilder<List<Jajan>>(
      stream: _jajanRepository.streamJajan(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Gagal mengambil data: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final semuaJajan = snapshot.data ?? [];

        // Seluruh perhitungan rekap dilakukan oleh RekapRepository.
        final hasilRekap = _rekapRepository.hitungRekap(
          transaksi: semuaJajan,
          periode: _periode,
          tanggal: _tanggalRekap,
        );

        final daftarJajan = hasilRekap.daftarTransaksi;
        final total = hasilRekap.totalPengeluaran;
        final kategoriUrut = hasilRekap.pengeluaranPerKategori.entries.toList();

        final warna = [
          Colors.blue,
          Colors.orange,
          Colors.green,
          Colors.purple,
          Colors.red,
          Colors.teal,
          Colors.pink,
          Colors.amber,
        ];

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<String>(
              initialValue: _periode,
              decoration: const InputDecoration(
                labelText: 'Periode Rekap',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Harian', child: Text('Harian')),
                DropdownMenuItem(value: 'Mingguan', child: Text('Mingguan')),
                DropdownMenuItem(value: 'Bulanan', child: Text('Bulanan')),
                DropdownMenuItem(value: 'Tahunan', child: Text('Tahunan')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _periode = value);
                }
              },
            ),

            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: _pilihTanggal,
              icon: const Icon(Icons.calendar_month),
              label: Text(_labelTanggal()),
            ),

            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Pengeluaran $_periode',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formatRupiah(total),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('${daftarJajan.length} transaksi'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Pengeluaran per Kategori',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            if (kategoriUrut.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: Text('Belum ada pengeluaran pada periode ini.'),
                  ),
                ),
              )
            else ...[
              SizedBox(
                height: 220,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 3,
                    centerSpaceRadius: 35,
                    sections: List.generate(kategoriUrut.length, (index) {
                      final item = kategoriUrut[index];
                      final persentase = total == 0
                          ? 0.0
                          : item.value / total * 100;

                      return PieChartSectionData(
                        value: item.value.toDouble(),
                        color: warna[index % warna.length],
                        title: '${persentase.toStringAsFixed(1)}%',
                        radius: 85,
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              ...List.generate(kategoriUrut.length, (index) {
                final item = kategoriUrut[index];

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 7,
                      backgroundColor: warna[index % warna.length],
                    ),
                    title: Text(item.key),
                    trailing: Text(
                      formatRupiah(item.value),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }),
            ],
          ],
        );
      },
    );
  }

  // ==========================================
  // TAMPILAN UTAMA
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: StreamBuilder<List<Kategori>>(
        stream: _kategoriRepository.streamKategori(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(title: const Text('Jajan Meter')),
              body: Center(
                child: Text('Gagal mengambil kategori: ${snapshot.error}'),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final kategoriList = snapshot.data ?? [];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Jajan Meter'),
              bottom: const TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.receipt_long), text: 'Transaksi'),
                  Tab(icon: Icon(Icons.bar_chart), text: 'Rekap'),
                ],
              ),
            ),
            body: TabBarView(
              children: [_buildForm(kategoriList), _buildRekap()],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _nominalController.dispose();
    _alasanController.dispose();
    super.dispose();
  }
}
