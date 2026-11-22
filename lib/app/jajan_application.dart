import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../screens/halaman_auth.dart';
import '../services/auth_service.dart';
import '../services/firebase_jajan_source.dart';
import '../vaka_ui/jajan_theme.dart';
import 'jajan_session_app.dart';

class JajanApplication extends StatefulWidget {
  const JajanApplication({super.key});
  @override
  State<JajanApplication> createState() => _JajanApplicationState();
}

class _JajanApplicationState extends State<JajanApplication> {
  final _auth = AuthService();
  late final _authProvider = AuthProvider(authService: _auth);
  late Stream<User?> _login;
  @override
  void initState() {
    super.initState();
    _login = _auth.statusLogin;
  }

  @override
  void dispose() {
    _authProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<AuthProvider>.value(
    value: _authProvider,
    child: StreamBuilder<User?>(
      stream: _login,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active &&
            !snapshot.hasError &&
            snapshot.data != null) {
          final uid = snapshot.data!.uid;
          _auth.pastikanDokumenSesi();
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
    ),
  );
}
