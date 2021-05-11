import 'package:firebase_course/app/sign_in/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Non Empty String', () {
    final validator = NonEmptyStringValidator();
    expect(validator.isValid('test'), true);
  });
  test('Empty String', () {
    final validator = NonEmptyStringValidator();
    expect(validator.isValid(''), false);
  });
  test('null String', () {
    final validator = NonEmptyStringValidator();
    expect(validator.isValid(null), false);
  });
}
