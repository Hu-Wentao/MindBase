import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/domain/aggregate.dart';
import 'package:mind_base/src/domain/entity/func.dart';
import 'package:mind_base/src/domain/repo.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:provider_sidecar/provider_sidecar.dart';

class MetaProvider extends ProviderSidecar {
  late final MetaRepo _metaRepo;

  // 防止同一个对象状态更新后被重复缓存
  final Map<ObjectId, RecordMeta> _cache = {};

  List<RecordMeta> get data => _cache.values.toList();

  @override
  onInitializing() {
    _metaRepo = sl<MetaRepo>();

    // 先查询有所元素
    _metaRepo.findAll().listen(_onInsert);
    // 然后开始监听变更
    _metaRepo.watchAll().listen(_onUpdate);
    setInitialized();
  }

  void _onInsert(RecordMeta meta) => setInitialized("初始化缓存", () {
        _cache[meta.id] = meta;
      });

  void _onUpdate(RepoEvent<RecordMeta> event) => setInitialized("刷新缓存", () {
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

  Future<void> actInsertMeta(RecordMeta meta) =>
      actWrapper(() => setInitialized("新增Meta [$meta]", () async {
            await _metaRepo.insert(meta);
          }));

  Future<void> actSaveMeta(RecordMetaDto? dto) =>
      actWrapper(() => setInitialized("保存元素 [$dto]", () async {
            if (dto == null) {
              return null;
            }
            final schema = dto.toDm((dto) => dto.toDm(FuncManager.findBy));
            await _metaRepo.save(schema);
          }));
}
