// part of '../aggregate/aggregate.dart';
//
// /// Meta信息
// /// 必须通过DTO转换 [MetaDto]
// class MetaModel implements IEtt<String> {
//   @override
//   final String id;
//   String name;
//   String memo;
//   int maxKey; // 等于Table中出现过key的数量, 用于新增Attr,只能增加
//   List<Attribute> attrs; // 字段表
//   List<Method> methods; // 方法表
//   List<TableView> views; // 视图表
//   Map<int, Method> get methodMap =>
//       Map.fromEntries(methods.map((e) => MapEntry(e.k, e)).toList());
//
//   // 表头
//   List<Property> get properties => [...attrs, ...methods];
//
//   MetaModel({
//     required this.id,
//     required this.name,
//     required this.memo,
//     required this.maxKey,
//     required this.attrs,
//     required this.methods,
//     this.views = const [],
//   });
//
//   int nextKey() => maxKey + 1;
//
//   // table新增Attr
//   MetaModel addAttr(Attribute attr) {
//     if (attr.k != nextKey()) {
//       throw "逻辑异常! 新增的Attr::k[${attr.k}] 不等于table[$name]的maxKey[$maxKey]+1";
//     }
//     return MetaModel(
//       id: id,
//       name: name,
//       memo: memo,
//       maxKey: nextKey(),
//       attrs: attrs..add(attr),
//       methods: methods,
//       views: views,
//       // properties: properties..add(attr),
//     );
//   }
//
//   Method? tryGetMethodBy(String member) {
//     for (final method in methods) {
//       if (method.name == member) return method;
//     }
//     return null;
//   }
//
//   Property getPropBy(String propId) =>
//       properties.firstWhere((prop) => prop.propId == propId);
//
//   bool hasPropBy(String propId) =>
//       properties.any((prop) => prop.propId == propId);
//
//   void update(MetaModel meta) {
//     assert(id == meta.id, "Meta::update,当前ID[$id]与更新ID[${meta.id}]不一致!");
//     name = meta.name;
//     memo = meta.memo;
//     maxKey = meta.maxKey;
//     attrs = meta.attrs;
//     methods = meta.methods;
//     views = meta.views;
//   }
//
//   @override
//   String toString() =>
//       'MetaModel{id: $id, name: $name, attrs: $attrs, methods: $methods}';
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is MetaModel &&
//           runtimeType == other.runtimeType &&
//           id == other.id &&
//           name == other.name &&
//           memo == other.memo &&
//           maxKey == other.maxKey &&
//           attrs == other.attrs &&
//           methods == other.methods;
//
//   @override
//   int get hashCode =>
//       id.hashCode ^
//       name.hashCode ^
//       memo.hashCode ^
//       maxKey.hashCode ^
//       attrs.hashCode ^
//       methods.hashCode;
// }
