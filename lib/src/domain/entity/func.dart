import 'package:mind_base/src/domain/value.dart';
import 'package:mongo_dart/mongo_dart.dart' show ObjectId;

/// 函数 ========================================================================
enum FunType {
  shell, // 本地CMD命令
  http, // http云函数
  operator, // 操作符
}

abstract class IFunc {
  ObjectId get id; // id是有必要的,因为用户自己会定义函数,使得::name重复
  String get name;

  FunType get type;

  Range get pRange; // 函数参数个数, -1表示无限制
  AttrType get pType; // 输入类型
  AttrType get rType; // 输出类型
  const IFunc();
}


// /// 函数字段组合成的表达式
// class Expression {
//   final IFunc func;
//   final List<Field> args;
//
//   Expression(this.func, this.args);
//
//   Field run() {
//     switch (func.type) {
//       case FunType.shell:
//         return shellFuncRunner(func, args);
//       case FunType.http:
//         return httpFuncRunner(func, args);
//       case FunType.operator:
//         return operatorFuncRunner(func, args);
//     }
//   }
//
//   Field shellFuncRunner(IFunc func, List<Field> args) {
//     throw "not implemented";
//   }
//
//   Field httpFuncRunner(IFunc func, List<Field> args) {
//     throw "not implemented";
//   }
//
//   // 表达式Func用户无法自定义
//   Field operatorFuncRunner(IFunc func, List<Field> args) {
//
//   }
// }


// 多数BaseFunc只存于程序中, 只允许被实现, 不需要被持久化;例如 加减乘除等
// 某些带有属性的Func除外,如regex转换Func,自身存储了regex表达式
//  方案A: 部分持久化: 考虑分为 calc函数和trans函数,calc都是实现类,不能持久化;trans是regex转换,都需要持久化
// 方案B: 全局持久化: 不同的实现类都持久化为不同的文档,对于calc同一个类的不同实例,其id含义为"不同版本的函数标识"
// todo feat A: 为Func添加 tag属性,便于用户自己查询使用,提供默认的sys函数tag,用户自己也可以创建私有函数tag;可能需要单独建立tag表,用于保存对应关系
// todo 方案 C:BaseFun->FunWrap,包装基本函数与云函数，本地函数等
// class FuncWrap extends IMongoEntityDto implements IFunc {
//   @override
//   final ObjectId id; // id是有必要的,因为用户自己会定义函数,使得::name重复
//   @override
//   final String name;
//
//   // final Set<FuncScope> scopes; // 函数适用范围 todo 考虑完全移除
//   @override
//   final Range pRange; // 函数参数个数, -1表示无限制
//   @override
//   final AttrType pType; // 输入类型
//   @override
//   final AttrType rType; // 输出类型
//
//   final Field Function(List<Field> inputs) onRun;
//
//   FuncWrap({
//     required this.id,
//     required this.name,
//     // required this.scopes,
//     this.pRange = const Range.equal(1),
//     required this.pType,
//     required this.rType,
//     required this.onRun,
//   });
//
//   // 对输入参数进行检查
//   Field run(List<Field> inputs) {
//     if (pRange.inBound(inputs.length)) {
//       return Field.err(
//           "函数[$runtimeType]输入参数数量[${inputs
//               .length}]过多,最多只能输入[$pRange]个参数");
//     }
//     return onRun(inputs);
//   }
//
//
//   FuncWrap.fromMongoJson(Map<String, dynamic> mJs)
//       : id = mJs['_id'],
//         name = mJs['name'] as String,
//   // scopes = mJs['scopes'] as Set<FuncScope>,
//         pRange = Range.fromJson(mJs['argsLenRange']),
//         pType = AttrType.values.asNameMap()['inType']!,
//         rType = AttrType.values.asNameMap()['outType']!;
//
//   @override
//   Map<String, dynamic> toJson() =>
//       {
//         '_id': id.toJson(),
//         'name': name,
//         // 'scopes': scopes,
//         'argsLenRange': pRange.toJson(),
//         'inType': pType.name,
//         'outType': rType.name,
//       };
//
//   @override
//   Map<String, dynamic> toMongoDto() =>
//       toJson()
//         ..['_id'] = id;
// }

// // Func实现-无处理-单例
// final noneFunc = FuncWrap(
//   id: ObjectId.fromHexString("6226adf527b60ea31165e4e3"),
//   name: 'None',
//   // {FuncScope.input, FuncScope.check, FuncScope.output},
//   pRange: Range.one,
//   pType: AttrType.any,
//   rType: AttrType.any,
//   onRun: (List<Field> params) => params.first,
// );
//
// final add = FuncWrap(
//     id: ObjectId(),
//     name: "ADD",
//     pRange: Range.one,
//     pType: AttrType.number,
//     rType: AttrType.number,
//     onRun: (p) => Field(p.first, e)
// )