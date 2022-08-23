import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'city_model.g.dart';

@JsonSerializable()
class CityModel extends Equatable {
  final String name;
  final String cityCode;
  final String firstCharacter;

  const CityModel(
      {required this.name,
      required this.cityCode,
      required this.firstCharacter});

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return _$CityModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CityModelToJson(this);

  @override
  List<Object?> get props => [name, cityCode, firstCharacter];
}
