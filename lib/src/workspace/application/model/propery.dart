part of 'model.dart';

// ///
// /// 暂不继承[ModelSidecar]
// /// [PropertyDto]存在于[RecordMetaDto]内部, 没有独立数据表, 不需要进行状态同步
// abstract class PropertyModel<P extends PropertyDto> {
//   final MetaModel at;
//   final P data;
//
//   // todo 实现 #332 propId-v8 之后, 可以通过propId判断
//   bool get isMethod => data is MethodDto;
//
//   PropertyModel(this.at, this.data);
// }