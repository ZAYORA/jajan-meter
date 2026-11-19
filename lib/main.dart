import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'services/auth_service.dart';
import 'screens/halaman_auth.dart';
import 'screens/halaman_jajan.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await initializeDateFormatting('id_ID', null);

  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: const JajanMeterApp(),
    ),
  );
}

class JajanMeterApp extends StatelessWidget {
  const JajanMeterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jajan Meter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().statusLogin,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                'Terjadi kesalahan: ${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (snapshot.data == null) {
          return const HalamanAuth();
        }

        return const HalamanJajan();
      },
    );
  }
}
