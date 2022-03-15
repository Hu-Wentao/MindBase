import 'dart:async';

import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/domain/aggregate.dart';
import 'package:mind_base/src/interface/dao.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:provider_sidecar/provider_sidecar.dart';

class RecordProvider extends ProviderSidecar {
  late final RecordAccessor _recordAccessor;

  // 防止同一个对象状态更新后被重复缓存
  final Map<ObjectId, RecordDto> _cache = {};
  RecordMeta? selectedSchema;
  StreamSubscription<WatchEvent<RecordDto>>? _recordSub;

  List<RecordDto> get data => _cache.values.toList();

  int get dataLength => _cache.length;

  @override
  onInitializing() => setInitialized(
        "初始化 Accessor",
        () => _recordAccessor = sl<RecordAccessor>(),
      );

  Future<void> actWatchSchema(RecordMeta schema) => actWrapper(
        () => setInitialized(
          "开始监听Schema[${schema.name}]",
          () => _watchSchema(schema),
        ),
      );

  Future<void> actSaveRecord(RecordDto? dto) => actWrapper(() async {
        log("actSaveRecord ${dto?.toJson()}");
        // 无需set,因为插入成功后, watch会监听到新的变更
        if (dto == null) return;
        await _recordAccessor.save(dto.id, dto).then((value) {
          log("actSaveRecord 插入成功");
        });
      });

  void _watchSchema(RecordMeta schema) {
    if (schema == selectedSchema) return;
    // 取消已有监听
    _recordSub?.cancel();

    selectedSchema = schema;
    // 查询
    _recordAccessor.findAllByMetaId(schema.id).listen(_onInsert);
    // 监听
    _recordSub = _recordAccessor.watchAllByMetaId(schema.id).listen(_onUpdate);
  }

  void _onInsert(RecordDto event) => setInitialized("初始化缓存", () {
        _cache[event.id] = event;
      });

  void _onUpdate(WatchEvent<RecordDto> event) => setInitialized("缓存更新", () {
        switch (event.type) {
          case WatchEventType.insert:
          case WatchEventType.replace:
          case WatchEventType.update:
            _cache[event.ettId] = (event.document!);
            break;
          case WatchEventType.delete:
            _cache.remove(event.ettId);
            break;
          case WatchEventType.drop:
            print("###debug drop 尚未确认 '${event.type}'事件的机制, 按照delete处理");
            _cache.remove(event.ettId);
            break;
          case WatchEventType.rename:
          case WatchEventType.dropDatabase:
          case WatchEventType.invalidate:
            print("###debug drop 尚未确认 '${event.type}'事件的机制");
            break;
        }
      });
}
