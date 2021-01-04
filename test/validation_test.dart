import 'package:flutter_test/flutter_test.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/utilities/Validations.dart';

void main() {

  String stringTest = 'QJfMbXnEavYobsjGvhuepyNPuTtXIxyDZHuQRWKjivTVKmUikftxxegkQpyBpyrNGvlucIoDCmqkexalrqbVeEYJonxiHYFEyMCKtVStfObHhijQuSagFjxnJhhLzaQnmVnSjwvYVKjCOOwVAdiuVlELEluKiVuYsAVacsiTZVzevAEUpIbxddIEJksXMmkDYqmMdWYVRwbCALvLXsIdwqluUXbdlJRsYpSDekwjPzJslNrhfGfLSyRRvskalhGb';

  group('Telephone Validation Test', () {
    test('Telephone Validation Test - Is Empty', () {
      expect(Validations.telephoneValidation(''), Dictionary.errorEmptyTelephone);
    });

    test('Telephone Validation Test - Minimum Length', () {
      expect(Validations.telephoneValidation('08'), Dictionary.errorMinimumTelephone);
    });

    test('Telephone Validation Test - Maximum Length', () {
      expect(Validations.telephoneValidation('0851566525521254'), Dictionary.errorMaximumTelephone);
    });

    test('Telephone Validation Test - Invalid Format', () {
      expect(Validations.telephoneValidation('ab1234cd456gh'), Dictionary.errorInvalidTelephone);
    });
  });

  group('Address Validation Test', () {
    test('Address Validation Test - Is Empty', () {
      expect(Validations.addressValidation(''), Dictionary.errorEmptyAddress);
    });

    test('Address Validation Test - Maximum Length', () {
      expect(Validations.addressValidation(stringTest), Dictionary.errorMaximumAddress);
    });
  });

  group('NIK Validation Test', () {
    test('NIK Validation Test - Is Empty', () {
      expect(Validations.nikValidation(''), Dictionary.errorEmptyNIK);
    });

    test('NIK Validation Test - Minimum Length', () {
      expect(Validations.nikValidation('321021121292000'), Dictionary.errorMinimumNIK);
    });

    test('NIK Validation Test - Maximum Length', () {
      expect(Validations.nikValidation('32102112129200002'), Dictionary.errorMaximumNIK);
    });
  });

  group('Name Validation Test', () {
    test('Name Validation Test - Is Empty', () {
      expect(Validations.nameValidation(''), Dictionary.errorEmptyName);
    });

    test('Name Validation Test - Minimum Length', () {
      expect(Validations.nameValidation('ab'), Dictionary.errorMinimumName);
    });

    test('Name Validation Test - Maximum Length', () {
      expect(Validations.nameValidation(stringTest), Dictionary.errorMaximumName);
    });

    test('Name Validation Test - Invalid Format', () {
      expect(Validations.nameValidation('ab1234cd456gh'), Dictionary.errorInvalidName);
    });
  });

  group('Phone Validation Test', () {
    test('Phone Validation Test - Is Empty', () {
      expect(Validations.phoneValidation(''), Dictionary.errorEmptyPhone);
    });

    test('Phone Validation Test - Minimum Length', () {
      expect(Validations.phoneValidation('62'), Dictionary.errorMinimumPhone);
    });

    test('Phone Validation Test - Maximum Length', () {
      expect(Validations.phoneValidation('62851566525521254'), Dictionary.errorMaximumPhone);
    });

    test('Phone Validation Test - Invalid Format', () {
      expect(Validations.phoneValidation('81222333444'), Dictionary.errorInvalidPhone);
    });
  });

  group('Other Relation Validation Test', () {
    test('Other Relation Validation Test - Is Empty', () {
      expect(Validations.otherRelationValidation(''), Dictionary.errorEmptyOtherRelation);
    });

    test('Other Relation Validation Test - Minimum Length', () {
      expect(Validations.otherRelationValidation('ab'), Dictionary.errorMinimumOtherRelation);
    });

    test('Other Relation Validation Test - Maximum Length', () {
      expect(Validations.otherRelationValidation(stringTest), Dictionary.errorMaximumOtherRelation);
    });
  });
}