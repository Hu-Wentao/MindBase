import 'package:get_arch_core/get_arch_core.dart';
import 'package:mind_base/src/workspace/domain/aggregate/aggregate.dart';

enum ViewType {
  sheet, // 列前缀 vs
  form, // 列前缀  vf
}

/// 视图信息
/// 多[MetaView]对一[RecordMeta]
/// 关系展现: 表名 `mv_$metaId`
class MetaView implements IEtt<String> {
  @override
  final String id;
  final RecordMeta meta; // 组装得到
  final ViewType type; // 列类型
  final List<String> cols; // 列排序与可见性

  MetaView(
    this.id,
    this.meta,
    this.type,
    this.cols,
  );
}
