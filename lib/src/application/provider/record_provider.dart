import 'dart:async';

import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/domain/aggregate.dart';
import 'package:mind_base/src/infra/ui/widget/data_table_frame.dart';
import 'package:mind_base/src/interface/dao.dart';
import 'package:mind_base/src/interface/dto.dart';
import 'package:mongo_dart/mongo_dart.dart' show ObjectId;
import 'package:provider_sidecar/provider_sidecar.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Record数据本身将缓存在DataSource中, Provider只用于创建和持有StreamSubscription
class RecordProvider extends ProviderSidecar {
  late final RecordAccessor _recordAccessor;

  RecordMeta? selectedSchema;

  // List<RecordDto> get data => _cache.values.toList();
  // int get dataLength => _cache.length;

  final Map<ObjectId, RecordDataGridSource> _streamCache = {};

  // final Map<ObjectId, Stream<WatchEvent<RecordDto>>> _streamCache = {};

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

  RecordDataGridSource _watchSchema(RecordMeta schema) {
    selectedSchema = schema;
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
      _watchSchema(schema ?? selectedSchema!);
}
