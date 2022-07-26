part of 'model.dart';

@Deprecated('RecordModel')
typedef Record = RecordModel;

extension PropertyBizX on RecordModel {
  dynamic eval(
    PropertyDto prop,
    @Deprecated('无需传入,将在记录所在工作空间内自动查询') FindRecordFn find,
  ) {
    if (prop is MethodDto) {
      final r = exprEvaluator.eval(prop.expr.toDomain(at.at.queryMeta), {
        AsFuncThis.ctxSign: this,
        Workspace.ctxFindRecordFnSign: at.at.findRecord,
      });
      return r.value;
    } else {
      return data.fields[prop.propId];
    }
  }
}

class RecordModel extends ModelSidecar<RecordDto, BaseException?> {
  String get id => data.id;
  final MetaModel at;

  RecordModel(this.at, RecordDto data) : super(data, ExceptionAdapter.of);

  @Deprecated('使用RecordDto.updateData')
  RecordDto update(RecordDto data) {
    return updateData(data);
  }
}
