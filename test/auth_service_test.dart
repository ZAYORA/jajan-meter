import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';

import 'package:jajan_meter/data/datasources/firebase_auth_datasource.dart';
import 'package:jajan_meter/models/user_model.dart';
import 'package:jajan_meter/services/auth_service.dart';
import 'package:jajan_meter/services/user_repository.dart';

class MockFirebaseAuthDataSource extends Mock
    implements FirebaseAuthDataSource {}

class MockUserRepository extends Mock implements UserRepository {}

class MockUserCredential extends Mock implements UserCredential {}

void main() {
  late MockFirebaseAuthDataSource authDataSource;
  late MockUserRepository userRepository;
  late AuthService authService;

  setUp(() {
    authDataSource = MockFirebaseAuthDataSource();
    userRepository = MockUserRepository();

    authService = AuthService(
      authDataSource: authDataSource,
      userRepository: userRepository,
    );
  });

  group('Register', () {
    test('nama kosong ditolak', () async {
      expect(
        () => authService.daftar('', 'test@example.com', 'password123'),
        throwsA(isA<AuthException>()),
      );
    });

    test('nama terlalu panjang ditolak', () async {
      expect(
        () => authService.daftar('a' * 31, 'test@example.com', 'password123'),
        throwsA(isA<AuthException>()),
      );
    });

    test('email invalid ditolak', () async {
      expect(
        () => authService.daftar('Zara', 'email-invalid', 'password123'),
        throwsA(isA<AuthException>()),
      );
    });

    test('password kosong ditolak', () async {
      expect(
        () => authService.daftar('Zara', 'test@example.com', ''),
        throwsA(isA<AuthException>()),
      );
    });

    test('password pendek ditolak', () async {
      expect(
        () => authService.daftar('Zara', 'test@example.com', '123'),
        throwsA(isA<AuthException>()),
      );
    });

    test('register berhasil memanggil datasource dan repository', () async {
      when(
        () => authDataSource.daftar(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => MockUserCredential());

      when(() => userRepository.pastikanDokumen(nama: any(named: 'nama')))
          .thenAnswer(
            (_) async => const UserModel(
              uid: 'uid-test',
              email: 'test@example.com',
              nama: 'Zara',
            ),
          );

      await authService.daftar('Zara', 'test@example.com', 'password123');

      verify(
        () => authDataSource.daftar(
          email: 'test@example.com',
          password: 'password123',
        ),
      ).called(1);

      verify(() => userRepository.pastikanDokumen(nama: 'Zara')).called(1);
    });
  });

  group('Login', () {
    test('email kosong ditolak', () async {
      expect(
        () => authService.masuk('', 'password123'),
        throwsA(isA<AuthException>()),
      );
    });

    test('email invalid ditolak', () async {
      expect(
        () => authService.masuk('email-invalid', 'password123'),
        throwsA(isA<AuthException>()),
      );
    });

    test('password kosong ditolak', () async {
      expect(
        () => authService.masuk('test@example.com', ''),
        throwsA(isA<AuthException>()),
      );
    });

    test('login berhasil memanggil datasource dan repository', () async {
      when(
        () => authDataSource.masuk(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => MockUserCredential());

      when(() => userRepository.pastikanDokumen()).thenAnswer(
        (_) async => const UserModel(
          uid: 'uid-test',
          email: 'test@example.com',
          nama: 'Zara',
        ),
      );

      await authService.masuk('test@example.com', 'password123');

      verify(
        () => authDataSource.masuk(
          email: 'test@example.com',
          password: 'password123',
        ),
      ).called(1);

      verify(() => userRepository.pastikanDokumen()).called(1);
    });
  });

  group('Lupa password', () {
    test('email kosong ditolak', () async {
      expect(
        () => authService.lupaKataSandi(''),
        throwsA(isA<AuthException>()),
      );
    });

    test('email invalid ditolak', () async {
      expect(
        () => authService.lupaKataSandi('email-invalid'),
        throwsA(isA<AuthException>()),
      );
    });

    test('reset password berhasil memanggil datasource', () async {
      when(() => authDataSource.lupaKataSandi(any())).thenAnswer((_) async {});

      await authService.lupaKataSandi('test@example.com');

      verify(() => authDataSource.lupaKataSandi('test@example.com')).called(1);
    });
  });
}
