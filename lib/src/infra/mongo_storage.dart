import 'package:logging/logging.dart';
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
  final String? _fullUrl;

  MongoStorageConfig({
    this.auth,
    this.host = "localhost",
    this.port = 27017,
    required this.databaseName,
    this.authSource = "admin",
    this.retryAttempts = 5,
  }) : _fullUrl = null;

  MongoStorageConfig.ofUrl(
    String url, {
    this.databaseName = 'see_url',
    this.retryAttempts = 5,
    this.auth,
    this.host = 'see_url',
    this.port = 0,
    this.authSource = 'see_url',
  }) : _fullUrl = url;

  String get authStr => auth?.toAuthPreString() ?? "";

  String fullUri() =>
      // mongodb+srv://mind_base_dev:<password>@cluster0.nqkse.mongodb.net/myFirstDatabase?retryWrites=true&w=majority
      _fullUrl ??
      'mongodb://$authStr$host:$port/$databaseName?authSource=$authSource';
}

// 一个Storage表示一个数据库, 因此不需要泛型约束
abstract class IMongoStorage {
  Logger logger = Logger("IMongoStorage");

  MongoStorageConfig get config; // 配置一个mongo database的信息

  Db? _db;

  Db get syncDb =>
      _db ??
      (throw "Please use [await $runtimeType::preInit()] to init Storage");

  /// see [withSyncBox] [withSyncAsync]
  Future<Db> get asyncDb async => await preInit();

  var _tryGet = 0;

  /// todo 已确认解决Future期间重复调用出错问题, 但需要优化代码
  /// 如果在依赖注入时调用本方法,则可以使用 sync相关方法
  Future<Db> preInit() async {
    if (_db == null) {
      // 解决网络等原因 导致连接失败的问题
      var _tryConnect = 0;
      while (true) {
        try {
          _tryConnect++;
          _db = await Db.create(config.fullUri());
          await _db!.open();
          break;
        } catch (e) {
          logger.config("Failed to connect to mongoDB, retry $_tryConnect");
          if (_tryConnect >= config.retryAttempts) {
            rethrow;
          }
          await Future.delayed(Duration(milliseconds: 100 * _tryConnect));
        }
      }
      return await preInit();
    } else {
      // 解决并发请求问题
      if (!_db!.isConnected) {
        while (true) {
          await Future.delayed(Duration(milliseconds: 100 * _tryGet));
          _tryGet++;
          if (_db!.isConnected) {
            logger.config("db state:${_db!.state}");
            return _db!;
          }
          if (_tryGet > config.retryAttempts) {
            // 持续出错,可能是连接异常,close后重试
            await _db?.close();
            return await preInit();
          }
        }
      } else {
        return _db!;
      }
    }
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
