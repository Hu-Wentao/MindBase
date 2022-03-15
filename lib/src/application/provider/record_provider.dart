import 'dart:async';

import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/domain/aggregate.dart';
import 'package:mind_base/src/domain/repo.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:provider_sidecar/provider_sidecar.dart';

class RecordProvider extends ProviderSidecar {
  late final RecordRepo _recordRepo;

  // 防止同一个对象状态更新后被重复缓存
  final Map<ObjectId, Record> _cache = {};
  RecordMeta? selectedSchema;
  StreamSubscription<RepoEvent<Record>>? _recordSub;

  List<Record> get data => _cache.values.toList();

  int get dataLength => _cache.length;

  @override
  onInitializing() => setInitialized(
        "初始化Repo",
        () => _recordRepo = sl<RecordRepo>(),
      );

  Future<void> actWatchSchema(RecordMeta schema) => actWrapper(
        () => setInitialized(
          "开始监听Schema[${schema.name}]",
          () => _watchSchema(schema),
        ),
      );

  void _watchSchema(RecordMeta schema) {
    if (schema == selectedSchema) return;
    // 取消已有监听
    _recordSub?.cancel();

    selectedSchema = schema;
    // 查询
    _recordRepo.findAllByMeta(schema.id).listen(_onInsert);
    // 监听
    _recordSub = _recordRepo.watchAllByMeta(schema.id).listen(_onUpdate);
  }

  void _onInsert(Record event) => setInitialized("初始化缓存", () {
        _cache[event.id] = event;
      });

  void _onUpdate(RepoEvent<Record> event) => setInitialized("缓存更新", () {
        switch (event.type) {
          case RepoEventType.insert:
          case RepoEventType.replace:
          case RepoEventType.update:
            _cache[event.ettId] = (event.entity!);
            break;
          case RepoEventType.delete:
            _cache.remove(event.ettId);
            break;
          case RepoEventType.drop:
            print("###debug drop 尚未确认 '${event.type}'事件的机制, 按照delete处理");
            _cache.remove(event.ettId);
            break;
          case RepoEventType.rename:
          case RepoEventType.dropDatabase:
          case RepoEventType.invalidate:
            print("###debug drop 尚未确认 '${event.type}'事件的机制");
            break;
        }
      });
}
