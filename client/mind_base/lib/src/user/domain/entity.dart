import 'package:bson/bson.dart';
export 'package:bson/bson.dart' show ObjectId;

abstract class ObjectIdX {
  static ObjectId get create => ObjectId(clientMode: true);

  static String get createHex => create.toHexString();
}
