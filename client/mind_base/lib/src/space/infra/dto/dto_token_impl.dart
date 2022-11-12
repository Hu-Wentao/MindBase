import 'package:mind_base/src/app/application/model.dart';
import 'package:mind_base/src/space/application/service/expr/domain_to_token.dart';
import 'package:mind_base/src/space/application/service/expr/node_to_token.dart';
import 'package:mind_base/src/space/domain/aggregate/aggregate.dart';
import 'package:mind_base/src/space/domain/entity/entity.dart';
import 'package:mind_base/src/space/inter/dto/i_dto.dart';

/// 针对表达式TokenDTO的转换
/// TokenString + ctx => TokenDTO
/// TokenDTO + ctx => TokenString
///
/// TokenString(ReadableString) : 用户直接输入的字符串
/// TokenDTO(ReadableDto): 对字符串的包装, 需要Meta   Context, 用于映射用户输入的标识->propId
/// Domain: 表达式对象, 需要Record Context, 可以计算出表达式的结果
/// JsonDTO(NodeDto): 将表达式转换为Map保存
/// Json: 用于持久化
///
/// ┌──────────────────┐                         ┌────────┐
/// │ 中缀表达式/函数嵌套 │     函数嵌套型字符串       │        │
/// │  TokenString     ◄───────────┐             │  Json  │
/// │                  │           │             │        │
/// └─────────┬────────┘           │             └───▲──┬─┘
///           │                    │                 │  │
///           │                    │                 │  │
///  ┌────────▼──────┐      ┌──────┴───────┐    ┌────┴──┴──▼┐
///  │               │      │              │    │           │
///  │   TokenDTO    └─ctx──►    Domain    └────►  JsonDto  │
///  │               ◄──────┐              ◄────┐           │
///  └───────────────┘      └──────────────┘    └───────────┘
/// 1. TokenString[String] -> TokenDTO[ExpressionDto]
///     [ExpressionParser], 字符串表达式的解析
///     ExpressionParser::expression.end().parse(<humanReadableString>).value
///
/// 2. TokenDTO[ExpressionDto] -> Domain [IExpr]
///     [ExprDtoToDomain]::convert(ExpressionDto expr, Map<String, dynamic> ctx)
///     将TokenDTO转换为Domain
///
/// 3. Domain [IExpr] -> JsonDTO [IExprJsonDto]
///    [IExprJsonDto].fromDomain
///    将Domain对象转换为持久化DTO
///
/// 4. JsonDTO [IExprJsonDto] -> Json [Map]
///   [IExprJsonDto].toJson

/// 这里是直接从Domain转换到 TokenString
extension IExprTokenX on IExpr {
  // 由于Domain本身已经携带了ctx, 所以这里不许需要额外传入ctx
  String toTokenString() => domainToToken.convert(this, const {});
}

extension IExprNodeDtoTokenX on IExprNodeDto {
  // 由于Domain本身已经携带了ctx, 所以这里不许需要额外传入ctx
  String toTokenString(QueryMetaFn queryMetaFn) => nodeToToken.convert(this, {
        SpaceModel.ctxQueryMetaSign: queryMetaFn,
      });
}
