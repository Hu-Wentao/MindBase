import '../../../domain/entity/entity.dart';
import '../../model/model.dart';
import 'expr_evaluator.dart';

/// 传入 (Meta, propName), 返回 Prop
/// 将对象名改成转换成 prop, 以便持久化和类型推断
class MetaMemberAccessor implements MemberAccessor<RecordMeta> {
  const MetaMemberAccessor();

  @override
  bool canHandle(meta, String member) {
    // 只允许访问Record类型
    if (meta is! RecordMeta) return false;
    // 是否存在对应的成员
    return meta.properties.any((element) => element.name == member);
  }

  /// 将成员名称-> 成员prop
  @override
  ExprValue getMember(RecordMeta meta, String member) {
    final prop = meta.properties.firstWhere(
      (element) => element.name == member,
      orElse: () => throw "在Record[${meta.id}]找不到名称为[$member]的成员方法或变量",
    );
    return ExprValue.build(type: prop.type, ag: [prop.propId]);
    // return prop;
    // if (prop.type.tp == AttrTp.ref) {
    //   // 引用类型, 同时返回类型信息, 以便推断表达式返回值类型
    //   return Value(
    //       fn: AsFuncRef(prop.type),
    //       ag: [prop.propId]); // 返回一个Value,同时通过 asRef将string转换成Meta
    //   // return Expression(const AsFuncRecordMeta(), [prop.type, prop.propId]); // 返回一个Expr, 通过AsFuncMeta 将 prop转换为Meta, 此时就与propId无关了,
    // } else {
    //   // 原始类型, 同时返回类型信息, 以便推断表达式返回值类型
    //   return Value.of(prop.propId);
    // }
  }
}

/// 记录值访问器
class RecordMemberAccessor implements MemberAccessor<Record> {
  // final WorkspaceDataHolder workspace;

  const RecordMemberAccessor();

  @override
  bool canHandle(object, String member) {
    return object is Record; // 不再检查是否有成员, 如果真的不存在,则交给eval去处理
    // 只允许访问Record类型
    // if (object is! Record) return false;
    // // 是否存在对应的成员
    // return object.meta.hasPropBy(member);
  }

  /// 成员可以是值, 也可是函数[Function]
  /// todo 在新增/修改变量/方法名称时,没有检查名称唯一性
  /// 考虑允许方法与变量重名,用于表达"get"方法
  @override
  IExpr getMember(Record record, String member) {
    final method = record.at.tryGetMethodBy(member);
    if (method != null) {
      return method.expr.callee as ExprValue; // 可以被调用
    }
    final field = record.at.getFieldByAttrName(member);
    if (field.value != null) {
      return field; // Expr值, 如果是ref,则直接返回,如果是原始类型, 则要返回value
    }
    return ExprValue.err(
        "在Record[${record.id}]找不到名称为[$member]的成员方法或变量"); // 可以被调用,但是没有值
  }
}
