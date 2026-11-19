import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';

import 'package:jajan_meter/data/datasources/firebase_user_datasource.dart';
import 'package:jajan_meter/services/user_repository.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseUserDataSource extends Mock
    implements FirebaseUserDataSource {}

class MockFirebaseUser extends Mock implements User {}

void main() {
  late MockFirebaseAuth firebaseAuth;
  late MockFirebaseUserDataSource dataSource;
  late UserRepository repository;

  setUp(() {
    firebaseAuth = MockFirebaseAuth();
    dataSource = MockFirebaseUserDataSource();

    repository = UserRepository(
      dataSource: dataSource,
      firebaseAuth: firebaseAuth,
    );
  });

  group('UserRepository validasi sesi', () {
    test('streamPengguna ditolak saat belum login', () {
      when(() => firebaseAuth.currentUser).thenReturn(null);

      expect(() => repository.streamPengguna(), throwsA(isA<StateError>()));
    });

    test('setJatahHarian ditolak saat belum login', () {
      when(() => firebaseAuth.currentUser).thenReturn(null);

      expect(
        () => repository.setJatahHarian(10000),
        throwsA(isA<StateError>()),
      );
    });

    test('setTema ditolak saat belum login', () {
      when(() => firebaseAuth.currentUser).thenReturn(null);

      expect(() => repository.setTema('gelap'), throwsA(isA<StateError>()));
    });

    test('selesaikanOnboarding ditolak saat belum login', () {
      when(() => firebaseAuth.currentUser).thenReturn(null);

      expect(
        () => repository.selesaikanOnboarding(),
        throwsA(isA<StateError>()),
      );
    });
  });

  group('Validasi data', () {
    test('jatah harian negatif ditolak', () {
      expect(
        () => repository.setJatahHarian(-1000),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('tema tidak valid ditolak', () {
      expect(() => repository.setTema('merah'), throwsA(isA<ArgumentError>()));
    });

    test('tema terang diterima', () {
      final mockUser = _user();

      when(() => firebaseAuth.currentUser).thenReturn(mockUser);

      when(() => dataSource.updateUser('uid-test', {'tema': 'terang'}))
          .thenAnswer((_) async {});

      expect(repository.setTema('terang'), completes);
    });
    test('tema gelap diterima', () {
      final mockUser = _user();

      when(() => firebaseAuth.currentUser).thenReturn(mockUser);

      when(() => dataSource.updateUser('uid-test', {'tema': 'gelap'}))
          .thenAnswer((_) async {});

      expect(repository.setTema('gelap'), completes);
    });
  });
}

MockFirebaseUser _user() {
  final user = MockFirebaseUser();

  when(() => user.uid).thenReturn('uid-test');
  when(() => user.email).thenReturn('test@example.com');

  return user;
}
