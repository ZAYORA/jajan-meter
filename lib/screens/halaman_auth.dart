import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class HalamanAuth extends StatefulWidget {
  const HalamanAuth({super.key});

  @override
  State<HalamanAuth> createState() => _HalamanAuthState();
}

class _HalamanAuthState extends State<HalamanAuth> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _auth = AuthService();
  bool _modeDaftar = false;
  bool _loading = false;
  String? _error;

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      if (_modeDaftar) {
        await _auth.daftar(_email.text, _password.text);
      } else {
        await _auth.masuk(_email.text, _password.text);
      }
    } on AuthException catch (e) {
      setState(() => _error = e.pesan);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _modeDaftar ? 'Daftar' : 'Masuk',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _password,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Kata sandi'),
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: Text(
                  _loading
                      ? 'Memproses...'
                      : (_modeDaftar ? 'Daftar' : 'Masuk'),
                ),
              ),
              TextButton(
                onPressed: () => setState(() {
                  _modeDaftar = !_modeDaftar;
                  _error = null;
                }),
                child: Text(
                  _modeDaftar
                      ? 'Sudah punya akun? Masuk'
                      : 'Belum punya akun? Daftar',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
