import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/jajan_application.dart';
import 'firebase_options.dart';
import 'vaka_ui/formatters.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeJajanFormats();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const JajanApplication());
}

class JajanMeterApp extends StatelessWidget {
  const JajanMeterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const JajanApplication();
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return const JajanApplication();
  }
}
