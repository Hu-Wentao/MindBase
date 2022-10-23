import 'package:mind_base/src/space/application/service/expr/parser_char.dart';
import 'package:mind_base/src/space/inter/dto/expr_token_dto.dart';
import 'package:petitparser/core.dart';
import 'package:petitparser/parser.dart';


final exprParser = ExpressionParser();
/// 用户输入表达式解析器
class ExpressionParser {
  ExpressionParser() {
    expression.set(binaryExpression);
    readableString.set((literal | unaryExpression | variable).cast<ExprTokenDto>());
  }

  Parser<Identifier> get identifier =>
      (digit().not() & (word() | char(r'$') | chineseChar()).plus())
          .flatten()
          .map((v) => Identifier(v));

  // 解析数值: `12`, `3.4`, `.5`.
  Parser<LiteralDto> get numericLiteral => ((digit() | char('.')).and() &
              (digit().star() &
                  ((char('.') & digit().plus()) |
                          (char('x') & digit().plus()) |
                          (anyOf('Ee') &
                              anyOf('+-').optional() &
                              digit().plus()))
                      .optional()))
          .flatten()
          .map((v) {
        return LiteralDto(num.parse(v), v);
      });

  // 解析换行符
  Parser<String> get escapedChar =>
      (char(r'\') & anyOf("nrtbfv\"'")).pick(1).cast();

  String unescape(String v) => v.replaceAllMapped(
      RegExp("\\\\[nrtbf\"']"),
      (v) => const {
            'n': '\n',
            'r': '\r',
            't': '\t',
            'b': '\b',
            'f': '\f',
            'v': '\v',
            "'": "'",
            '"': '"'
          }[v.group(0)!.substring(1)]!);

  // 解析单引号字符串
  Parser<LiteralDto> get sqStringLiteral => (char("'") &
          (anyOf(r"'\").neg() | escapedChar).star().flatten() &
          char("'"))
      .pick(1)
      .map((v) => LiteralDto(unescape(v), "'$v'"));

  // 解析双引号字符串
  Parser<LiteralDto> get dqStringLiteral => (char('"') &
          (anyOf(r'"\').neg() | escapedChar).star().flatten() &
          char('"'))
      .pick(1)
      .map((v) => LiteralDto(unescape(v), '"$v"'));

  // 解析字符串
  Parser<LiteralDto> get stringLiteral =>
      sqStringLiteral.or(dqStringLiteral).cast();

  // 解析 bool值
  Parser<LiteralDto> get boolLiteral =>
      (string('true') | string('false')).map((v) => LiteralDto(v == 'true', v));

  // 解析 null
  Parser<LiteralDto> get nullLiteral =>
      string('null').map((v) => LiteralDto(null, v));

  // 解析 this
  Parser<ThisExprTokenDto> get thisExpr =>
      string('this').map((v) => ThisExprTokenDto());

  // 解析数组, 如: [1, 2, 3]
  Parser<LiteralDto> get arrayLiteral =>
      (char('[').trim() & arguments & char(']').trim())
          .pick(1)
          .map((l) => LiteralDto(l, '$l'));

  // 解析映射, 如: {a: 1, b: 2}
  Parser<LiteralDto> get mapLiteral =>
      (char('{').trim() & mapArguments & char('}').trim())
          .pick(1)
          .map((l) => LiteralDto(l, '$l'));

  // 解析字面值 Value
  Parser<LiteralDto> get literal => (numericLiteral |
          stringLiteral |
          boolLiteral |
          nullLiteral |
          arrayLiteral |
          mapLiteral)
      .cast();

  /// 相关[expression]
  /// 方法: foo.bar(baz), 一元表达式: -1, 字面值 "abc", 括号()
  final SettableParser<ExprTokenDto> readableString = undefined<ExprTokenDto>();

  // 二元表达式操作符优先级
  static const Map<String, int> binaryOperations = {
    '||': 1,
    '&&': 2,
    '|': 3,
    '^': 4,
    '&': 5,
    '==': 6,
    '!=': 6,
    '<=': 7,
    '>=': 7,
    '<': 7,
    '>': 7,
    '<<': 8,
    '>>': 8,
    '+': 9,
    '-': 9,
    '*': 10,
    '/': 10,
    '%': 10
  };

  // 处理单个表达式
  // 如 `1`, `1+2`, `a+(b*2)-Math.sqrt(2)`
  Parser<String> get binaryOperation => binaryOperations.keys
      .map<Parser<String>>((v) => string(v))
      .reduce((a, b) => (a | b).cast<String>())
      .trim();

  /// 二元表达式
  Parser<ExprTokenDto> get binaryExpression =>
      readableString.separatedBy(binaryOperation).map((l) {
        var first = l[0];
        var stack = <dynamic>[first];

        for (var i = 1; i < l.length; i += 2) {
          var op = l[i];
          var level = BinaryExprTokenDto.precedenceForOperator(op);

          // 构建一个二元表达式
          while ((stack.length > 2) &&
              (level <=
                  BinaryExprTokenDto.precedenceForOperator(
                      stack[stack.length - 2]))) {
            var right = stack.removeLast();
            var op = stack.removeLast();
            var left = stack.removeLast();
            var node = BinaryExprTokenDto(op, left, right);
            stack.add(node);
          }

          var node = l[i + 1];
          stack.addAll([op, node]);
        }

        var i = stack.length - 1;
        var node = stack[i];
        while (i > 1) {
          node = BinaryExprTokenDto(stack[i - 1], stack[i - 2], node);
          i -= 2;
        }
        return node;
      });

  // 一元表达式操作符
  static const _unaryOperations = ['-', '!', '~', '+'];

  /// 一元表达式
  Parser<UnaryExprTokenDto> get unaryExpression => _unaryOperations
      .map<Parser<String>>((v) => string(v))
      .reduce((a, b) => (a | b).cast<String>())
      .trim()
      .seq(readableString)
      .map((l) => UnaryExprTokenDto(l[0], l[1]));

  // 处理List形式的参数列表, 例如方法参数列表`(a, b, c)`, 数组`[a, b, c]`
  // `foo(bar, baz)`, `bar()`, `[bar, baz]`
  Parser<List<ExprTokenDto>> get arguments => expression
      .separatedBy(char(',').trim(), includeSeparators: false)
      .castList<ExprTokenDto>()
      .optionalWith([]);

  Parser<Map<ExprTokenDto, ExprTokenDto>> get mapArguments =>
      (expression & char(':').trim() & expression)
          .map((l) => MapEntry<ExprTokenDto, ExprTokenDto>(l[0], l[2]))
          .separatedBy(char(',').trim(), includeSeparators: false)
          .castList<MapEntry<ExprTokenDto, ExprTokenDto>>()
          .map((l) => Map.fromEntries(l))
          .optionalWith({});

  // 处理变量/方法名 (包括其他类的属性名)
  // `foo`, `bar.baz`, `foo['bar'].baz`
  // 包括函数调用
  // `Math.acos(obj.angle)`
  Parser<ExprTokenDto> get variable => groupOrIdentifier
          .seq((memberArgument.cast() | indexArgument | callArgument).star())
          .map((l) {
        var a = l[0] as ExprTokenDto;
        var b = l[1] as List;
        return b.fold(a, (ExprTokenDto object, argument) {
          if (argument is Identifier) {
            return MemberExprTokenDto(object, argument);
          }
          if (argument is ExprTokenDto) {
            return IndexExprTokenDto(object, argument);
          }
          if (argument is List<ExprTokenDto>) {
            return CallExprTokenDto(object, argument);
          }
          throw ArgumentError('Invalid type ${argument.runtimeType}');
        });
      });

  // 解析`()`
  Parser<ExprTokenDto> get group =>
      (char('(') & expression.trim() & char(')')).pick(1).cast();

  Parser<ExprTokenDto> get groupOrIdentifier =>
      (group | thisExpr | identifier.map((v) => VariableDto(v))).cast();

  Parser<Identifier> get memberArgument =>
      (char('.') & identifier).pick(1).cast();

  Parser<ExprTokenDto> get indexArgument =>
      (char('[') & expression.trim() & char(']')).pick(1).cast();

  Parser<List<ExprTokenDto>> get callArgument =>
      (char('(') & arguments & char(')')).pick(1).cast();

  /// 相关:[readableString]
  /// 二元表达式
  final SettableParser<ExprTokenDto> expression = undefined();
}
