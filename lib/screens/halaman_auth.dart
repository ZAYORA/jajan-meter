import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class HalamanAuth extends StatefulWidget {
  const HalamanAuth({super.key});

  @override
  State<HalamanAuth> createState() => _HalamanAuthState();
}

class _HalamanAuthState extends State<HalamanAuth> {
  final _formKey = GlobalKey<FormState>();
  final _nama = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _modeDaftar = false;
  bool _lihatPassword = false;

  static const Color _biru = Color(0xFF19A9ED);
  static const Color _navy = Color(0xFF173B57);
  static const Color _background = Color(0xFFF5F9FC);

  @override
  void dispose() {
    _nama.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();

    final berhasil = _modeDaftar
        ? await authProvider.daftar(
            _nama.text.trim(),
            _email.text.trim(),
            _password.text,
          )
        : await authProvider.masuk(_email.text.trim(), _password.text);

    if (!mounted) return;

    if (berhasil) {
      // AuthGate akan mengarahkan pengguna secara otomatis.
      return;
    }

    final pesan = authProvider.error;

    if (pesan != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(pesan), behavior: SnackBarBehavior.floating),
      );
    }
  }

  Future<void> _lupaPassword() async {
    final email = _email.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan email terlebih dahulu.')),
      );
      return;
    }

    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Format email tidak valid.')),
      );
      return;
    }

    final berhasil = await context.read<AuthProvider>().lupaKataSandi(email);

    if (!mounted) return;

    final authProvider = context.read<AuthProvider>();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          berhasil
              ? authProvider.success ?? 'Email reset berhasil dikirim.'
              : authProvider.error ?? 'Gagal mengirim email reset.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _ubahMode() {
    setState(() {
      _modeDaftar = !_modeDaftar;
      _lihatPassword = false;
    });

    context.read<AuthProvider>().resetPesan();
  }

  @override
  Widget build(BuildContext context) {
    final ukuran = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Column(
                children: [
                  _header(ukuran),
                  const SizedBox(height: 28),
                  _kartuForm(),
                  const SizedBox(height: 24),
                  const Text(
                    'Kelola pengeluaran jajanmu dengan lebih bijak.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Color(0xFF718096)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(Size ukuran) {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: _biru.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(28),
          ),
          child: const Icon(
            Icons.account_balance_wallet_rounded,
            size: 45,
            color: _biru,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Jajan Meter',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: _navy,
            letterSpacing: -0.7,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          _modeDaftar
              ? 'Buat akun dan mulai atur uang jajanmu.'
              : 'Pantau uang jajanmu, wujudkan hematmu.',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF718096),
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _kartuForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: _navy.withValues(alpha: 0.06),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _modeDaftar ? 'Buat akun' : 'Selamat datang!',
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w800,
              color: _navy,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _modeDaftar
                ? 'Lengkapi data untuk mulai menggunakan Jajan Meter.'
                : 'Masuk ke akunmu untuk melanjutkan.',
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF718096),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_modeDaftar) ...[
                  _label('Nama'),
                  TextFormField(
                    controller: _nama,
                    validator: (value) {
                      if (_modeDaftar &&
                          (value == null || value.trim().isEmpty)) {
                        return 'Nama tidak boleh kosong';
                      }
                      if (value != null && value.trim().length > 30) {
                        return 'Nama maksimal 30 karakter';
                      }
                      return null;
                    },
                    decoration: _inputDecoration(
                      hint: 'Masukkan nama kamu',
                      icon: Icons.person_outline,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                _label('Email'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autocorrect: false,
                  decoration: _inputDecoration(
                    hint: 'Masukkan email',
                    icon: Icons.mail_outline_rounded,
                  ),
                  validator: (value) {
                    final email = value?.trim() ?? '';

                    if (email.isEmpty) {
                      return 'Email wajib diisi.';
                    }

                    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                        .hasMatch(email)) {
                      return 'Format email tidak valid.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _label('Kata sandi'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _password,
                  obscureText: !_lihatPassword,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  decoration:
                      _inputDecoration(
                        hint: 'Masukkan kata sandi',
                        icon: Icons.lock_outline_rounded,
                      ).copyWith(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _lihatPassword = !_lihatPassword;
                            });
                          },
                          icon: Icon(
                            _lihatPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kata sandi wajib diisi.';
                    }

                    if (value.length < 6) {
                      return 'Minimal 6 karakter.';
                    }

                    return null;
                  },
                ),
                if (!_modeDaftar) ...[
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _lupaPassword,
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      child: const Text(
                        'Lupa kata sandi?',
                        style: TextStyle(
                          color: _biru,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Consumer<AuthProvider>(
                  builder: (context, auth, _) {
                    return SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: auth.loading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _biru,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: _biru.withValues(alpha: 0.6),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: auth.loading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                _modeDaftar ? 'Daftar sekarang' : 'Masuk',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey.shade200)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'atau',
                  style: TextStyle(color: Color(0xFF718096), fontSize: 12),
                ),
              ),
              Expanded(child: Divider(color: Colors.grey.shade200)),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  _modeDaftar ? 'Sudah punya akun? ' : 'Belum punya akun? ',
                  style: const TextStyle(
                    color: Color(0xFF718096),
                    fontSize: 13,
                  ),
                ),
                TextButton(
                  onPressed: _ubahMode,
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: Text(
                    _modeDaftar ? 'Masuk' : 'Daftar',
                    style: const TextStyle(
                      color: _biru,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String teks) {
    return Text(
      teks,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 13,
        color: _navy,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF9AA7B5), fontSize: 13),
      prefixIcon: Icon(icon, color: _biru, size: 21),
      filled: true,
      fillColor: _background,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE7EDF2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _biru, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }
}
