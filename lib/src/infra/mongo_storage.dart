import 'package:mongo_dart/mongo_dart.dart';

// final db = Db('mongodb://root:example@localhost:27017/testdb'
//     '?authSource=admin');
// final db = Db('mongodb://localhost:27017/testdb');
// final db = Db('mongodb://root:example@localhost:27017/testdb');
// // final db = Db('mongodb://127.0.0.1/testdb');
// await db.open();
// var collection = db.collection('orders');
// await collection.drop();
// await collection.insertMany([
// {'status': 'A', 'cust_id': 3, 'amount': Rational.fromInt(128)},
// {'status': 'B', 'cust_id': 2, 'amount': Rational.fromInt(100)},
// {'status': 'A', 'cust_id': 1, 'amount': Rational.fromInt(80)},
// {'status': 'A', 'cust_id': 3, 'amount': Rational.fromInt(72)},
// ]);
// final pipeline = AggregationPipelineBuilder()
//     .addStage(Match(where.eq('status', 'A').map['\$query']))
//     .addStage(
//     Group(id: Field('cust_id'), fields: {'total': Sum(Field('amount'))}))
//     .build();
// final result =
//     await DbCollection(db, 'orders').modernAggregate(pipeline).toList();
// result.forEach(print);
class MongoAuthBasic {
  final String username;
  final String password;

  const MongoAuthBasic({required this.username, required this.password});

  toAuthPreString() => "$username:$password@";
}

class MongoStorageConfig {
  final MongoAuthBasic? auth;
  final String host;
  final int port;
  final String databaseName;
  final String authSource;

  MongoStorageConfig({
    this.auth,
    this.host = "localhost",
    this.port = 27017,
    required this.databaseName,
    this.authSource = "admin",
  });

  String get authStr => auth?.toAuthPreString() ?? "";

  String fullUri() =>
      'mongodb://$authStr$host:$port/$databaseName?authSource=$authSource';
}

// 一个Storage表示一个数据库, 因此不需要泛型约束
abstract class IMongoStorage {
  MongoStorageConfig get config; // 配置一个mongo database的信息

  Db? _db;

  Db get syncDb =>
      _db ??
      (throw "Please use [await $runtimeType::preInit()] to init Storage");

  /// see [withSyncBox] [withSyncAsync]
  Future<Db> get asyncDb async {
    _db ??= await preInit();
    return _db!;
  }

  /// 如果在依赖注入时调用本方法,则可以使用 sync相关方法
  Future<Db> preInit() async {
    _db = Db(config.fullUri());
    await _db!.open();
    return _db!;
  }

  /// 在实现类内部创建 静态inject方法,内部调用本方法即可实现无@module, @preResolve注入
  Future<T> init<T extends IMongoStorage>() async {
    await preInit();
    return this as T;
  }

  Future<E> withSync<E>(E Function(Db sync) onSync) async =>
      onSync(await asyncDb);

  Future<E> withSyncAsync<E>(Future<E> Function(Db sync) onSync) async =>
      await onSync(await asyncDb);
}

class BaseMongoStorage extends IMongoStorage {
  @override
  final MongoStorageConfig config;

  BaseMongoStorage(this.config);
}
