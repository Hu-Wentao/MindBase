// part of '../aggregate/aggregate.dart';
//
// /// 表 =========================================================================
//
// /// 记录
// /// 必须通过DTO转换 [RecordDto]
// /// fields[0] 始终为 [id]
// class Record implements IEtt<String> {
//   @override
//   final String id;
//   final MetaModel meta; // Aggregate组装得到,实际只存储Id
//   Map<int, Value> fields;
//
//   List<Method> get methods => meta.methods; // method自带k值
//
//   Record({
//     required this.id,
//     required this.meta,
//     required this.fields,
//   });
//
//   factory Record.of({
//     String? id,
//     required MetaModel meta,
//     required Map<int, Value> fields,
//   }) =>
//       Record(
//         id: id ??= ObjectIdX.createHex,
//         meta: meta,
//         fields: {
//           0: Value.of(id),
//           1: Value.of(meta.id),
//         }..addAll(fields),
//       );
//
//   ExprValue getFieldByAttrName(String name) => getField(name.parsePropK);
//
//   ExprValue getField(int attrKey) {
//     final pIndex = meta.attrs.indexWhere((attr) => attr.k == attrKey);
//     if (pIndex == -1) {
//       // 找不到属性，通常是因为新增列，但没有填充值导致的
//       return ExprValue.build(
//           type: AttrType.string, ag: [null, "Error#找不到Prop[$attrKey]"]);
//     }
//
//     final prop = meta.attrs[pIndex];
//     final value = fields[attrKey];
//     return ExprValue.build(
//         type: prop.type,
//         ag: [value?.value, value == null ? "Error#找不到Value值" : null]);
//   }
//
//   Value? getFieldValue(int attrKey, {Value Function(int k)? orElse}) =>
//       fields[attrKey] ?? orElse?.call(attrKey);
//
//   Method? tryGetMethodBy(int methodKey, {Method Function(int k)? orElse}) =>
//       methods.firstWhere((mth) => mth.k == methodKey,
//           orElse: () =>
//               orElse?.call(methodKey) ??
//               (throw "找不到attrKey: [$methods] 对应的Method"));
//
//   static ExpressionParser parser = ExpressionParser();
//
//   /// 根据属性名称获取属性值(同时调用表达式进行计算)
//   Value getValueBy(Property prop, FindRecordFn find) {
//     if (prop is Method) {
//       // 计算求值
//       return Value.of(prop.eval(this, find));
//     } else {
//       // 如果为空泽填充一个null默认值
//       return getFieldValue(prop.k, orElse: (_) => Value.of(''))!;
//     }
//   }
//
//   // 更新属性值
//   void update(Record record) {
//     assert(id == record.id, "Record::update,当前ID[$id]与更新ID[${record.id}]不一致!");
//     fields = record.fields;
//   }
//
//   @Deprecated("只能更新字段值")
//   Record updateWith({required String propId, required Value value}) {
//     return Record(
//       id: id,
//       meta: meta,
//       fields: fields..[Property.parsePropId(propId).value2] = value,
//     );
//   }
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is Record &&
//           runtimeType == other.runtimeType &&
//           id == other.id &&
//           meta == other.meta &&
//           fields == other.fields &&
//           methods == other.methods;
//
//   @override
//   int get hashCode =>
//       id.hashCode ^ meta.hashCode ^ fields.hashCode ^ methods.hashCode;
// }
