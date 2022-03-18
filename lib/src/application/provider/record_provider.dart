import 'dart:async';

import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/domain/aggregate.dart';
import 'package:mind_base/src/infra/ui/widget/data_table_frame.dart';
import 'package:mind_base/src/interface/dao.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:mongo_dart/mongo_dart.dart' show Db, ObjectId;
import 'package:provider_sidecar/provider_sidecar.dart';

/// Record数据本身将缓存在DataSource中, Provider只用于创建和持有StreamSubscription
class RecordProvider extends ProviderSidecar {
  RecordAccessor _recordAccessor(ObjectId metaId) =>
      RecordAccessor(sl<Db>(), metaId.toHexString());

  RecordMeta? selectedMeta;

  // todo 后期添加 actCloseSourceByMetaId,
  // todo 注意要检查 opendRecord中关联RecordMeta, 如果有则忽略调用, 但可以从UI中移除
  // todo   上面需求需要双层cache, 即cache stream, cache RecordDataGridSource
  // <MetaId, RecordDataGridSource>
  final Map<ObjectId, RecordDataGridSource> _sourceCache = {};

  @override
  onInitializing() => setInitialized(
      // "初始化 Accessor",
      // () => _recordAccessor = RecordAccessor(sl<Db>, ),
      );

  Future<void> actWatchMeta(RecordMeta schema) => actWrapper(
        () => setInitialized(
          "开始/切换监听Meta[${schema.name}]",
          () => _watchMeta(schema),
        ),
      );

  Future<void> actSaveRecord(RecordDto? dto) => actWrapper(() async {
        log("actSaveRecord ${dto?.toJson()}");
        // 无需set,因为插入成功后, watch会监听到新的变更
        if (dto == null) return;
        await _recordAccessor(dto.metaId).save(dto.id, dto).then((value) {
          log("actSaveRecord 插入成功");
        });
      });

  RecordDataGridSource _watchMeta(RecordMeta meta) {
    selectedMeta = meta;
    if (_sourceCache[meta.id] == null) {
      _sourceCache[meta.id] = RecordDataGridSource(
        meta,
        _recordAccessor(meta.id).findAll().listen(null),
        _recordAccessor(meta.id).watchAll().listen(null),
          actSaveRecord,
      );
    }
    return _sourceCache[meta.id]!;
  }

  RecordDataGridSource actGetDataSource({RecordMeta? schema}) =>
      _watchMeta(schema ?? selectedMeta!);

  @override
  void dispose() {
    _sourceCache.values.map((e) => e.dispose());
    super.dispose();
  }
}
