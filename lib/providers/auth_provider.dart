import 'package:flutter/foundation.dart';

import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({AuthService? authService})
    : _authService = authService ?? AuthService();

  final AuthService _authService;

  bool _loading = false;
  String? _error;
  String? _success;

  bool get loading => _loading;
  String? get error => _error;
  String? get success => _success;

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void resetPesan() {
    _error = null;
    _success = null;
    notifyListeners();
  }

  Future<bool> masuk(String email, String password) async {
    resetPesan();
    _setLoading(true);

    try {
      await _authService.masuk(email, password);
      return true;
    } on AuthException catch (e) {
      _error = e.pesan;
      return false;
    } catch (_) {
      _error = 'Terjadi kesalahan. Silakan coba lagi.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> daftar(String nama, String email, String password) async {
    resetPesan();
    _setLoading(true);

    try {
      await _authService.daftar(nama, email, password);
      return true;
    } on AuthException catch (e) {
      _error = e.pesan;
      return false;
    } catch (_) {
      _error = 'Terjadi kesalahan. Silakan coba lagi.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> lupaKataSandi(String email) async {
    resetPesan();
    _setLoading(true);

    try {
      await _authService.lupaKataSandi(email);
      _success = 'Email reset kata sandi berhasil dikirim.';
      return true;
    } on AuthException catch (e) {
      _error = e.pesan;
      return false;
    } catch (_) {
      _error = 'Terjadi kesalahan. Silakan coba lagi.';
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
