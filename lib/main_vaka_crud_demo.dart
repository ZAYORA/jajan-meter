import 'package:flutter/material.dart';

import 'app/jajan_session_app.dart';
import 'demo/demo_jajan_source.dart';
import 'vaka_ui/formatters.dart';

/// Jalankan -t lib/main_vaka_crud_demo.dart untuk berlatih tanpa akun Firebase.
/// Layar/provider sama dengan produksi; hanya sumber data diganti memori.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeJajanFormats();
  runApp(JajanSessionApp(source: DemoJajanSource(), demo: true));
}
