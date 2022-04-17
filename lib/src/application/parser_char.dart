import 'package:petitparser/core.dart';
import 'package:petitparser/parser.dart';

/// Returns a parser that accepts any word character (lowercase, uppercase,
/// underscore, or digit). The accepted input is equivalent to the character-set
/// `a-zA-Z_0-9`.
Parser<String> chineseChar([String message = 'chinese char expected']) =>
    CharacterParser(const ChineseCharPredicate(), message);

class ChineseCharPredicate implements CharacterPredicate {
  const ChineseCharPredicate();

  // 汉字范围
  @override
  bool test(int value) => (value >= 0x4e00 && value <= 0x9fa5);

  @override
  bool isEqualTo(CharacterPredicate other) => other is WordCharPredicate;
}

main() {
  const ch = ChineseCharPredicate();
  final r = ch.test('汉'.codeUnitAt(0));
  print(r);
}
