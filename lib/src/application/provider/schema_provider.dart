import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/domain/aggregate.dart';
import 'package:mind_base/src/domain/entity/func.dart';
import 'package:mind_base/src/domain/repo.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:provider_sidecar/provider_sidecar.dart';

class SchemaProvider extends ProviderSidecar {
  late final SchemaRepo _schemaRepo;

  // 防止同一个对象状态更新后被重复缓存
  final Map<ObjectId, RecordMeta> _cache = {};

  List<RecordMeta> get schemas => _cache.values.toList();

  @override
  onInitializing() {
    _schemaRepo = sl<SchemaRepo>();

    // 先查询有所元素
    _schemaRepo.findAll().listen(_onUpdate);
    // 然后开始监听变更
    // todo test 如果时删除了元素，watch是否也会产生事件?
    _schemaRepo.watchAll().listen(_onUpdate);
    setInitialized();
  }

  void _onUpdate(RecordMeta event) => setInitialized("刷新缓存", () {
        _cache[event.id] = event;
      });

  Future<void> actInsertSchema(RecordMeta schema) =>
      actWrapper(() => setInitialized("新增Schema", () async {
            await _schemaRepo.insert(schema);
          }));

  Future<void> actSaveSchema(RecordMetaDto? dto) =>
      actWrapper(() => setInitialized("保存元素", () async {
            if (dto == null) {
              return null;
            }
            final schema = dto.toDm((dto) => dto.toDm(FuncManager.findBy));
            await _schemaRepo.save(schema);
          }));
}
