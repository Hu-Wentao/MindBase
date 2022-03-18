import 'dart:async';

import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/domain/aggregate.dart';
import 'package:mind_base/src/infra/ui/widget/data_table_frame.dart';
import 'package:mind_base/src/interface/dao.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:mongo_dart/mongo_dart.dart' show ObjectId;
import 'package:provider_sidecar/provider_sidecar.dart';

/// Record数据本身将缓存在DataSource中, Provider只用于创建和持有StreamSubscription
class RecordProvider extends ProviderSidecar {
  late final RecordAccessor _recordAccessor;

  RecordMeta? selectedMeta;

  final Map<ObjectId, RecordDataGridSource> _streamCache = {};

  @override
  onInitializing() => setInitialized(
        "初始化 Accessor",
        () => _recordAccessor = sl<RecordAccessor>(),
      );

  Future<void> actWatchMeta(RecordMeta schema) => actWrapper(
        () => setInitialized(
          "开始监听Meta[${schema.name}]",
          () => _watchMeta(schema),
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

  RecordDataGridSource _watchMeta(RecordMeta schema) {
    selectedMeta = schema;
    if (_streamCache[schema.id] == null) {
      _streamCache[schema.id] = RecordDataGridSource(
        schema,
        _recordAccessor.findAllByMetaId(schema.id).listen(null),
        _recordAccessor.watchAllByMetaId(schema.id).listen(null),
      );
    }
    return _streamCache[schema.id]!;
  }

  RecordDataGridSource actGetDataSource({RecordMeta? schema}) =>
      _watchMeta(schema ?? selectedMeta!);

  @override
  void dispose() {
    _streamCache.values.map((e) => e.dispose());
    super.dispose();
  }
}
