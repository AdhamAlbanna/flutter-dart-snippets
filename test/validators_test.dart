import 'package:flutter_dart_snippets/flutter_dart_snippets.dart';
import 'package:test/test.dart';

void main() {
  group('validate', () {
    test('flags empty, null and whitespace-only values', () {
      expect(validate(null), ValidationError.required);
      expect(validate(''), ValidationError.required);
      expect(validate('   '), ValidationError.required);
    });

    test('accepts a value inside the length range', () {
      expect(validate('abcdef', min: 6, max: 10), isNull);
    });

    test('flags too short and too long', () {
      expect(validate('abc', min: 6), ValidationError.tooShort);
      expect(validate('abcdefghijk', max: 10), ValidationError.tooLong);
    });

    test('checks email format only when asked', () {
      expect(validate('not-an-email'), isNull);
      expect(
          validate('not-an-email', email: true), ValidationError.invalidEmail);
      expect(validate('user@example.com', email: true), isNull);
    });

    test('checks phone format only when asked', () {
      expect(validate('+962791234567', phone: true), isNull);
      expect(validate('12ab', phone: true), ValidationError.invalidPhone);
    });
  });
}
