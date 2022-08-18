import 'package:freezed_annotation/freezed_annotation.dart';

part 'goods_type_model.freezed.dart';
part 'goods_type_model.g.dart';

@freezed
class GoodsTypeModel with _$GoodsTypeModel {
  factory GoodsTypeModel({
    String? id,
    String? name,
  }) = _GoodsTypeModel;

  factory GoodsTypeModel.fromJson(Map<String, dynamic> json) =>
      _$GoodsTypeModelFromJson(json);
}
