import 'package:flutter/material.dart';

import 'vaka_ui/formatters.dart';
import 'vaka_ui/preview/preview_app.dart';

/// Entry point khusus pemeriksaan UI tanpa Firebase dan tanpa data pengguna.
/// Jalankan: flutter run -d chrome -t lib/main_vaka_preview.dart
/// Entry point produksi tetap lib/main.dart, dengan autentikasi milik Zara.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeJajanFormats();
  runApp(const VakaPreviewApp());
}
