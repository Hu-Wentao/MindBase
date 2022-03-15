import 'package:flutter/foundation.dart';
import 'package:mongo_dart/mongo_dart.dart';

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
  final int retryAttempts;

  MongoStorageConfig({
    this.auth,
    this.host = "localhost",
    this.port = 27017,
    required this.databaseName,
    this.authSource = "admin",
    this.retryAttempts = 5,
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

  Future<void> close() async => await _db?.close();

  /// 如果在依赖注入时调用本方法,则可以使用 sync相关方法
  /// Db如果已经连接过，重复连接会导致卡在 Opening状态，需要 await ::close, 然后再 ::open
  /// see: https://github.com/mongo-dart/mongo_dart/issues/223#issuecomment-813872280
  Future<Db> preInit() async {
    if (_db == null || !_db!.isConnected) {
      await close();
      var retry = 0;
      while (true) {
        try {
          retry++;
          var db = Db(config.fullUri());
          await db.open();
          _db = db;
          // print('OK after "$retry" attempts');
          break;
        } catch (e) {
          if (kDebugMode) print('Failed to connect to mongoDB, retry "$retry"');
          if (retry >= config.retryAttempts) {
            rethrow;
          }
          await Future.delayed(Duration(milliseconds: 100 * retry));
        }
      }
    }
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
