part of '../../model.dart';

class RecordModel extends ModelSidecar<RecordDto, BaseException?> {
  String get id => data.id;
  final MetaModel at;

  RecordModel(this.at, RecordDto data) : super(data, ExceptionAdapter.of);
}

extension PropertyBizX on RecordModel {
  ExprValue getField(int attrKey) {
    final pIndex = at.attrs.indexWhere((attr) => attr.k == attrKey);
    if (pIndex == -1) {
      // 找不到属性，通常是因为新增列，但没有填充值导致的
      return ExprValue.build(
          type: AttrType.string, ag: [null, "Error#找不到k为[$attrKey]的Prop"]);
    }
    final prop = at.attrs[pIndex];
    final value = data.fields[attrKey];
    return ExprValue.build(
        type: prop.type.toDomain(at.at.queryMeta),
        ag: [value?.value, value == null ? "Error#找不到Value值" : null]);
  }

  /// 求值,返回值即字面量
  dynamic eval(PropertyDto prop) {
    if (prop is MethodDto) {
      final r = exprEvaluator.eval(prop.expr.toDomain(at.at.queryMeta), {
        AsFuncThis.ctxSign: this,
        SpaceModel.ctxFindRecordFnSign: at.at.findRecord,
      });
      return r.value;
    } else {
      return data.fields[prop.k]!.v;
      // fixme #332
      // return data.fields[prop.propId];
    }
  }
}
