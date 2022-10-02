part of 'service.dart';

Pattern _ptn = RegExp(r'\.(create|update|delete)$');

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
    throw '无法识别DataEvtTp类型';
  }
}

class DataEvt<T> {
  final DataEvtTp type;
  final T data;

  DataEvt(this.type, this.data);

  List<T> updateDataSet(List<T> dataSet,
      {bool Function(T raw, T data)? equals}) {
    equals ??= (a, b) => a == b;
    switch (type) {
      case DataEvtTp.create:
        return dataSet..add(data);
      case DataEvtTp.delete:
        return dataSet..removeWhere((e) => equals!.call(e, data));
      case DataEvtTp.update:
        return dataSet
          ..removeWhere((e) => equals!.call(e, data))
          ..add(data);
    }
  }
}

extension DataSetX<T> on List<T> {
  updateDataSet<R>(
    DataEvt<R> event, {
    required T Function(R data) transform,
    required bool Function(T origin, T data) equals,
  }) {
    final data = transform(event.data);
    switch (event.type) {
      case DataEvtTp.create:
        return this..add(data);
      case DataEvtTp.delete:
        return this..removeWhere((e) => equals.call(e, data));
      case DataEvtTp.update:
        return this
          ..removeWhere((e) => equals.call(e, data))
          ..add(data);
    }
  }
}

@lazySingleton
class RealtimeSrv {
  final RealtimeChannelHub _hub;

  RealtimeSrv(this._hub);

  Stream<DataEvt<md.Team>> watchTeams() =>
      watchBy(const SubChannel.watchTeams()).map((event) => DataEvt<md.Team>(
            DataEvtTp.ofEvents(event.events),
            md.Team.fromMap(event.payload),
          ));

  @protected
  Stream<aw.RealtimeMessage> watchBy(SubChannel channel) {
    _hub.actAddChannel(channel);
    return _hub.stream.doOnCancel(() => _hub.actRemoveChannel(channel));
  }
}
