part of 'model.dart';

@Deprecated('RecordModel')
typedef Record = RecordModel;

extension PropertyBizX on RecordModel {
  ExprValue getFieldByAttrName(String attrName) {
    final propId = at.properties.firstWhere((p) => p.name == attrName).propId;
    return getField(propId.parsePropK);
  }

  ExprValue getField(int attrKey) {
    final pIndex = at.attrs.indexWhere((attr) => attr.k == attrKey);
    if (pIndex == -1) {
      // 找不到属性，通常是因为新增列，但没有填充值导致的
      return ExprValue.build(
          type: AttrType.string, ag: [null, "Error#找不到Prop[$attrKey]"]);
    }
    final prop = at.attrs[pIndex];
    final value = data.fields[attrKey];
    return ExprValue.build(
        type: prop.type.toDomain(at.at.queryMeta),
        ag: [value?.value, value == null ? "Error#找不到Value值" : null]);
  }

  /// 求值,返回值即字面量
  dynamic eval(
    PropertyDto prop, [
    @Deprecated('无需传入,将在记录所在工作空间内自动查询') FindRecordFn? find,
  ]) {
    if (prop is MethodDto) {
      final r = exprEvaluator.eval(prop.expr.toDomain(at.at.queryMeta), {
        AsFuncThis.ctxSign: this,
        Workspace.ctxFindRecordFnSign: at.at.findRecord,
      });
      return r.value;
    } else {
      return data.fields[prop.k];
      // fixme #332
      // return data.fields[prop.propId];
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
