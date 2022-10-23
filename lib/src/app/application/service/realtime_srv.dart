part of '../service.dart';

Pattern _ptn = RegExp(r'.*\.(create|update|delete)$');

enum DataEvtTp {
  create,
  delete,
  update;

  // 适配Appwrite
  factory DataEvtTp.ofEvents(List<String> events) {
    for (final e in events) {
      if (e.startsWith(_ptn)) {
        final name = e.split('.').last;
        return DataEvtTp.values.byName(name);
      }
    }
    throw '无法识别DataEvtTp类型[$events]';
  }
}

class DataEvt<T> {
  final DataEvtTp type;
  final T data;

  DataEvt(this.type, this.data);
}

extension DataSetX<T> on List<T> {
  List<T> updateDataSet<R>(
    DataEvt<R> event, {
    required T Function(R data) transform,
    required bool Function(T origin, T data) equals,
  }) {
    final data = transform(event.data);
    switch (event.type) {
      case DataEvtTp.create:
        return this..add(data);
      case DataEvtTp.delete:
        // todo 如果删除事件 仅回传被删除实体的Id，则此处会出错
        return this..removeWhere((e) => equals.call(e, data));
      case DataEvtTp.update:
        return this
          ..removeWhere((e) => equals.call(e, data))
          ..add(data);
    }
  }
}

///
/// 将监听逻辑整合到本类中，Stream直接由hub持有
@lazySingleton
class RealtimeSrv {
  final RealtimeChannelHub _hub;

  RealtimeSrv(this._hub);

  Stream<DataEvt<md.Team>> watchTeams() =>
      watchBy(const SubChannel.watchTeams()).map((event) => DataEvt<md.Team>(
            DataEvtTp.ofEvents(event.events),
            md.Team.fromMap(event.payload
              // 修复属性值缺失问题
              ..['total'] = 0),
          ));

  @protected
  Stream<aw.RealtimeMessage> watchBy(SubChannel channel) {
    _hub.actAddChannel(channel);
    return _hub.stream
        .doOnCancel(() => _hub.actRemoveChannel(channel))
        // 过滤得到特定channel的Stream
        .where((event) => event.channels.contains(channel.channel));
  }
}
