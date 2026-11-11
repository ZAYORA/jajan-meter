import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'firebase_options.dart';
import 'screens/halaman_auth.dart';
import 'screens/halaman_jajan.dart';
import 'services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi format tanggal dan waktu Indonesia.
  await initializeDateFormatting('id_ID', null);

  // Inisialisasi Firebase.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jajan Meter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      home: const AuthGate(),
    );
  }
}

/// Mengatur halaman berdasarkan status login pengguna.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().statusLogin,
      builder: (context, snapshot) {
        // Menampilkan loading saat memeriksa status login.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Jika terjadi error saat memeriksa autentikasi.
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Terjadi kesalahan autentikasi: ${snapshot.error}'),
            ),
          );
        }

        final user = snapshot.data;

        // Jika belum login, tampilkan halaman autentikasi.
        if (user == null) {
          return const HalamanAuth();
        }

        // Jika sudah login, tampilkan halaman transaksi.
        return const HalamanJajan();
      },
    );
  }
}
