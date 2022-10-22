import 'package:mind_base/src/space/domain/value/value.dart';

import '../../../domain/entity/entity.dart';
import '../../../../app/application/model.dart';
import 'expr_evaluator.dart';

/// 传入 (Meta, propName), 返回 Prop
/// 将对象名改成转换成 prop, 以便持久化和类型推断
class MetaMemberAccessor implements MemberAccessor<MetaModel> {
  const MetaMemberAccessor();

  @override
  bool canHandle(meta, String member) {
    // 只允许访问Record类型
    if (meta is! MetaModel) return false;
    // 是否存在对应的成员
    return meta.properties.any((element) => element.name == member);
  }

  /// 将成员名称-> 成员prop
  /// fixme 逻辑需要优化
  @override
  ExprValue getMember(MetaModel meta, String member) {
    final prop = meta.properties.firstWhere(
      (element) => element.name == member,
      orElse: () => throw "在Record[${meta.id}]找不到名称为[$member]的成员方法或变量",
    );
    return ExprValue.build(
        type: prop.type.toDomain(meta.at.queryMeta), ag: [prop.propId]);
  }
}

/// 记录值访问器
class RecordMemberAccessor implements MemberAccessor<RecordModel> {
  // final SpaceModelDataHolder workspace;

  const RecordMemberAccessor();

  @override
  bool canHandle(object, String member) {
    return object is RecordModel; // 不再检查是否有成员, 如果真的不存在,则交给eval去处理
    // 只允许访问Record类型
    // if (object is! Record) return false;
    // // 是否存在对应的成员
    // return object.meta.hasPropBy(member);
  }

  /// 成员可以是值, 也可是函数[Function]
  /// todo 在新增/修改变量/方法名称时,没有检查名称唯一性
  /// 考虑允许方法与变量重名,用于表达"get"方法
  /// fixme 逻辑需要优化
  @override
  IExpr getMember(RecordModel record, String propId) {
    final method = record.at.tryGetMethodBy(propId.parsePropK);
    if (method != null) {
      return method.expr.toDomain(record.at.at.queryMeta).callee
          as ExprValue; // 可以被调用
    } else {
      final field = record.getField(propId.parsePropK);
      if (field.value != null) {
        return field; // Expr值, 如果是ref,则直接返回,如果是原始类型, 则要返回value
      } else {
        return ExprValue.err(
            "在Record[${record.id}]找不到名称为[$propId]的成员方法或变量"); // 可以被调用,但是没有值
      }
    }
  }
}
