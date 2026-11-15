import 'package:african/features/auth/domain/registration_validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('age changes on the birthday, including leap day births', () {
    expect(ageOnDate(DateTime(2008, 11, 16), DateTime(2026, 11, 15)), 17);
    expect(ageOnDate(DateTime(2008, 11, 16), DateTime(2026, 11, 16)), 18);
    expect(ageOnDate(DateTime(2008, 2, 29), DateTime(2026, 2, 28)), 17);
    expect(ageOnDate(DateTime(2008, 2, 29), DateTime(2026, 3, 1)), 18);
  });

  test('password requires every category and at least eight characters', () {
    expect(validateRegistrationPassword('Ab1!xyz'), isNotNull);
    expect(validateRegistrationPassword('abcdefgh1!'), isNotNull);
    expect(validateRegistrationPassword('ABCDEFGH1!'), isNotNull);
    expect(validateRegistrationPassword('Abcdefgh!'), isNotNull);
    expect(validateRegistrationPassword('Abcdefgh1'), isNotNull);
    expect(validateRegistrationPassword('Abcdefg1 '), isNotNull);
    expect(validateRegistrationPassword('Abcdef1!'), isNull);
  });

  test('contact and identity comparisons ignore common formatting', () {
    expect(
      normalizePhone('+243 812-345-678'),
      normalizePhone('00243812345678'),
    );
    expect(
      normalizeIdentityNumber(' id-123 '),
      normalizeIdentityNumber('ID123'),
    );
    expect(validateRegistrationPhone('123-abc-4567'), isNotNull);
    expect(validateRegistrationEmail('a@@example.com'), isNotNull);
    expect(validateRegistrationEmail('user@example.com'), isNull);
  });
}
