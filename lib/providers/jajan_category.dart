/// Empat kelompok tampilan. Nama dan ID asli transaksi tetap disimpan.
String kelompokKategori(String nama) => switch (nama.trim().toLowerCase()) {
  'makan' || 'makanan' || 'makan berat' || 'cemilan' || 'camilan' => 'makan',
  'kopi' || 'kopi/minum' || 'coffee' => 'kopi',
  'transport' || 'transportasi' || 'ojek' => 'transport',
  _ => 'lainnya',
};

const labelKategori = {
  'makan': 'Makan',
  'kopi': 'Kopi',
  'transport': 'Transport',
  'lainnya': 'Lainnya',
};
