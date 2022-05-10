import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/application/expr_evaluator.dart';
import 'package:mind_base/src/application/expression_parser.dart';
import 'package:mind_base/src/domain/entity/functor.dart';
import 'package:mind_base/src/domain/value.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:mongo_dart/mongo_dart.dart' hide Type;

/// 表 =========================================================================

/// 记录
/// 必须通过DTO转换 [RecordDto]
/// fields[0] 始终为 [id]
class Record implements IEtt<ObjectId> {
  @override
  final ObjectId id;
  final RecordMeta meta; // Aggregate组装得到,实际只存储Id
  Map<int, Value> fields;

  List<Method> get methods => meta.methods; // method自带k值

  Record({
    required this.id,
    required this.meta,
    required this.fields,
  });

  factory Record.of({
    ObjectId? id,
    required RecordMeta meta,
    required Map<int, Value> fields,
  }) {
    final recordId = id ?? ObjectId(clientMode: true);
    return Record(
      id: recordId,
      meta: meta,
      fields: {
        0: Value.of(recordId.toHexString()),
        1: Value.of(meta.id.toHexString()),
      }..addAll(fields),
    );
  }

  RecordDto toDto() => RecordDto.fromDomain(this);

  @override
  String toString() => toDto().toString();

  /// Value不存在时返回一个空Value
  Value getFieldByColumn(String name) =>
      tryGetFieldByColumn(name, orElse: (_) => Value.of(''))!;

  Value? tryGetFieldByColumn(String name, {Value Function(int k)? orElse}) {
    final propId = Property.parsePropId(name);
    return tryGetFieldBy(propId.value2, orElse: orElse);
  }

  Value getFieldBy(int attrKey, {Value Function(int k)? orElse}) =>
      tryGetFieldBy(attrKey) ??
      orElse?.call(attrKey) ??
      (throw "找不到attrKey: [$attrKey] 对应的Field");

  Value? tryGetFieldBy(int attrKey, {Value Function(int k)? orElse}) =>
      fields[attrKey] ?? orElse?.call(attrKey);

  Method? tryGetMethodBy(int methodKey, {Method Function(int k)? orElse}) =>
      methods.firstWhere((mth) => mth.k == methodKey,
          orElse: () =>
              orElse?.call(methodKey) ??
              (throw "找不到attrKey: [$methods] 对应的Method"));

  static ExpressionParser parser = ExpressionParser();

  /// 根据属性名称获取属性值(同时调用表达式进行计算)
  Value getValueBy(Property prop) {
    if (prop is Method) {
      final method = prop;
      return Value.of(method.eval(this));
    } else {
      return getFieldBy(prop.k, orElse: (_) => Value.of(null)); // 填充一个null默认值
    }
  }

  // // fixme 待完善
  // getPropBy(String propId) {
  //   print("debug # getPropBy# propId: $propId");
  //   final parsedPropId = Property.parsePropId(propId);
  //   if (parsedPropId.value1 == 'm') {
  //     return tryGetMethodBy(parsedPropId.value2);
  //   } else {
  //     return tryGetFieldBy(parsedPropId.value2);
  //   }
  // }

  // 更新属性值
  void update(Record record) {
    assert(id == record.id, "Record::update,当前ID[$id]与更新ID[${record.id}]不一致!");
    fields = record.fields;
  }

  @Deprecated("只能更新字段值")
  Record updateWith({required String propId, required Value value}) {
    return Record(
      id: id,
      meta: meta,
      fields: fields..[Property.parsePropId(propId).value2] = value,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Record &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          meta == other.meta &&
          fields == other.fields &&
          methods == other.methods;

  @override
  int get hashCode =>
      id.hashCode ^ meta.hashCode ^ fields.hashCode ^ methods.hashCode;
}

/// Meta信息
/// 必须通过DTO转换 [RecordMetaDto]
class RecordMeta implements IEtt<ObjectId> {
  @override
  final ObjectId id;
  String name;
  String memo;
  int maxKey; // 等于Table中出现过key的数量, 用于新增Attr,只能增加
  List<Attribute> attrs; // 字段表
  List<Method> methods; // 方法表

  Map<int, Method> get methodMap =>
      Map.fromEntries(methods.map((e) => MapEntry(e.k, e)).toList());

  // 表头
  List<Property> get properties => [...attrs, ...methods];

  RecordMeta({
    required this.id,
    required this.name,
    required this.memo,
    required this.maxKey,
    required this.attrs,
    required this.methods,
  });

  int nextKey() => maxKey + 1;

  // table新增Attr
  RecordMeta addAttr(Attribute attr) {
    if (attr.k != nextKey()) {
      throw "逻辑异常! 新增的Attr::k[${attr.k}] 不等于table[$name]的maxKey[$maxKey]+1";
    }
    return RecordMeta(
      id: id,
      name: name,
      memo: memo,
      maxKey: nextKey(),
      attrs: attrs..add(attr),
      methods: methods,
      // properties: properties..add(attr),
    );
  }

  Method? tryGetMethodBy(String member) {
    for (final method in methods) {
      if (method.name == member) return method;
    }
    return null;
  }

  Property getPropBy(String propId) =>
      properties.firstWhere((prop) => prop.propId == propId);

  bool hasPropBy(String propId) =>
      properties.any((prop) => prop.propId == propId);

  RecordMetaDto toDto() => RecordMetaDto.fromDomain(this);

  @override
  String toString() => "RecordMeta#${toDto()}";

  void update(RecordMeta meta) {
    assert(id == meta.id, "Meta::update,当前ID[$id]与更新ID[${meta.id}]不一致!");
    name = meta.name;
    memo = meta.memo;
    maxKey = meta.maxKey;
    attrs = meta.attrs;
    methods = meta.methods;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecordMeta &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          memo == other.memo &&
          maxKey == other.maxKey &&
          attrs == other.attrs &&
          methods == other.methods;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      memo.hashCode ^
      maxKey.hashCode ^
      attrs.hashCode ^
      methods.hashCode;
}

/// 是 [Attribute]和[Method]的父类
abstract class Property extends Equatable {
  final int k; // 表头key,对应Field:k,需要从所在的TableMeta中获取
  final String name; // 表头名称
  final String memo; // 表头备注
  AttrType get type; // 最终返回值类型

  /// 字段或属性在一个Meta中的唯一标识
  /// 在字符串开头使用 m标识[Methods], 使用 a标识[Attribute]
  String get propId => '${(this is Attribute) ? 'a' : 'm'}$k';

  static Tuple2<String, int> parsePropId(String propId) => propId.parsePropId();

  const Property(this.k, this.name, this.memo);

  static const subTypeMap = {
    Method: 'm',
    Attribute: 'a',
  };

  String get toSubTypeSign => subTypeMap[runtimeType]!;

  Type getSubTypeBySign(String sign) {
    final subType = subTypeMap.entries
        .firstWhere((e) => e.value == sign,
            orElse: () => throw "找不到类型标识: [$sign]")
        .key;
    return subType;
  }

  @override
  List<Object> get props => [k, name, memo, type];
}

class Method extends Property {
  // 方法体
  final IExpr expr;

  @override
  AttrType get type => expr.type;

  const Method({
    required int k,
    required String name,
    required String memo,
    required this.expr,
  }) : super(k, name, memo);

  @override
  List<Object> get props => super.props..addAll([expr]);

  MethodDto toDto() => MethodDto.ofDomain(this);

  // 求值, 传入所在record为上下文'this'
  dynamic eval(Record record) =>
      exprEvaluator.eval(expr, {AsFuncThis.ctxSign: record});
}

class Attribute extends Property {
  @override
  final AttrType type; // 类型
  @Deprecated("已将Meta集成到type中,使用 type.ref 访问MetaIdStr")
  final RecordMeta? meta; //如果type是"ref", 该值不为空,存储被引用的MetaId

  const Attribute({
    required int k,
    required String name,
    required String memo,
    required this.type,
    this.meta,
  }) : super(k, name, memo);

  @override
  List<Object> get props => super.props..addAll([if (meta != null) meta!]);

  AttributeDto toDto() => AttributeDto.ofDomain(this);

  @override
  String toString() => toDto().toString();
}
