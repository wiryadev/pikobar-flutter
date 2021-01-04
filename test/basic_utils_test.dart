import 'package:flutter_test/flutter_test.dart';
import 'package:pikobar_flutter/utilities/BasicUtils.dart';

void main() {
  String stringTest = 'this String is for Test';
  String stringHTMLTest = '<html><body><p>this String is for Test</p></body></html>';
  List<String> listStringTest = ['Pikobar', 'Jawa', 'Barat'];

  test('Capitalize Word Test', () {
    expect(StringUtils.capitalizeWord(stringTest), 'This String Is For Test');
  });

  test('Replace Space To Underscore Test', () {
    expect(StringUtils.replaceSpaceToUnderscore(stringTest), 'this_String_is_for_Test');
  });

  test('Contains Word Test', () {
    expect(StringUtils.containsWords('Pikobar', listStringTest), true);
  });

  test('Parse String From HTML Test', () async {
    expect( await stringFromHtmlString(stringHTMLTest), stringTest);
  });

  test('Formatted String Number Test', () {
    expect(formattedStringNumber('50000'), '50.000');
  });
}