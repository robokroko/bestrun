import 'package:bestrun/utils/authentication.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bestrun/screens/activity_screen.dart';

void main() {
  test('Login should be true', () async {
    expect(
      Authentication().createUserWithEmailAndPassword(
          email: 'james@mail.com', password: '123456'),
      true,
    );
  });
  test('Login should be trfalseue', () async {
    expect(
      Authentication().createUserWithEmailAndPassword(
          email: 'james@mail.com', password: '12'),
      false,
    );
  });
  test('Login should be false', () async {
    expect(
      Authentication().createUserWithEmailAndPassword(
          email: 'james@mail.com', password: 'j44h'),
      false,
    );
  });
  test('Login should be false', () async {
    expect(
      Authentication().createUserWithEmailAndPassword(
          email: 'jamesmail.com', password: '123456'),
      false,
    );
  });
  test('Login should be false', () async {
    expect(
      Authentication().createUserWithEmailAndPassword(
          email: 'james@.mail.com', password: '123456'),
      false,
    );
  });
  test('Login should be false', () async {
    expect(
      Authentication().createUserWithEmailAndPassword(
          email: 'jam|es@mail.com', password: '123456'),
      false,
    );
  });
  test('Login should be false', () async {
    expect(
      Authentication().createUserWithEmailAndPassword(
          email: 'jame<s@mail.com', password: '123456'),
      false,
    );
  });
  test('Login should be false', () async {
    expect(
      Authentication().createUserWithEmailAndPassword(
          email: 'james&mail.com', password: '123456'),
      false,
    );
  });
  test('Login should be false', () async {
    expect(
      Authentication().createUserWithEmailAndPassword(
          email: 'jame<s@mail.hu', password: '---'),
      false,
    );
  });
  test('Login should be false', () async {
    expect(
      Authentication()
          .createUserWithEmailAndPassword(
              email: 'james@mail.com', password: '123456')
          .timeout(const Duration(seconds: 10)),
      false,
    );
  });

//logout

  test('Logout should be true', () async {
    expect(
      Authentication().signOut(),
      true,
    );
  });
  test('Logout should be false', () async {
    expect(
      Authentication().signOut().timeout(const Duration(seconds: 10)),
      false,
    );
  });
}
