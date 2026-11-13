import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/firebase_jajan_source.dart';
import '../screens/halaman_auth.dart';
import '../services/auth_service.dart';
import '../vaka_ui/jajan_theme.dart';
import 'jajan_session_app.dart';

class JajanApplication extends StatefulWidget {
  const JajanApplication({super.key});
  @override
  State<JajanApplication> createState() => _JajanApplicationState();
}

class _JajanApplicationState extends State<JajanApplication> {
  final _auth = AuthService();
  late Stream<User?> _login;
  @override
  void initState() {
    super.initState();
    _login = _auth.statusLogin;
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<User?>(
    stream: _login,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.active &&
          !snapshot.hasError &&
          snapshot.data != null) {
        final uid = snapshot.data!.uid;
        return JajanSessionApp(
          key: ValueKey(uid),
          source: FirebaseJajanSource(uid),
          onSignOut: _auth.keluar,
        );
      }
      return MaterialApp(
        title: 'Jajan Meter',
        debugShowCheckedModeBanner: false,
        theme: buildJajanTheme(),
        home: snapshot.hasError
            ? Scaffold(
                body: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Belum berhasil memeriksa sesi akun.'),
                      TextButton(
                        onPressed: () =>
                            setState(() => _login = _auth.statusLogin),
                        child: const Text('Coba lagi'),
                      ),
                    ],
                  ),
                ),
              )
            : snapshot.connectionState == ConnectionState.waiting
            ? const Scaffold(body: Center(child: CircularProgressIndicator()))
            : const HalamanAuth(),
      );
    },
  );
}
