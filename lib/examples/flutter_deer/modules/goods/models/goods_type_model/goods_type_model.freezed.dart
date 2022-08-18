// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'goods_type_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

GoodsTypeModel _$GoodsTypeModelFromJson(Map<String, dynamic> json) {
  return _GoodsTypeModel.fromJson(json);
}

/// @nodoc
mixin _$GoodsTypeModel {
  String? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GoodsTypeModelCopyWith<GoodsTypeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoodsTypeModelCopyWith<$Res> {
  factory $GoodsTypeModelCopyWith(
          GoodsTypeModel value, $Res Function(GoodsTypeModel) then) =
      _$GoodsTypeModelCopyWithImpl<$Res>;
  $Res call({String? id, String? name});
}

/// @nodoc
class _$GoodsTypeModelCopyWithImpl<$Res>
    implements $GoodsTypeModelCopyWith<$Res> {
  _$GoodsTypeModelCopyWithImpl(this._value, this._then);

  final GoodsTypeModel _value;
  // ignore: unused_field
  final $Res Function(GoodsTypeModel) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$$_GoodsTypeModelCopyWith<$Res>
    implements $GoodsTypeModelCopyWith<$Res> {
  factory _$$_GoodsTypeModelCopyWith(
          _$_GoodsTypeModel value, $Res Function(_$_GoodsTypeModel) then) =
      __$$_GoodsTypeModelCopyWithImpl<$Res>;
  @override
  $Res call({String? id, String? name});
}

/// @nodoc
class __$$_GoodsTypeModelCopyWithImpl<$Res>
    extends _$GoodsTypeModelCopyWithImpl<$Res>
    implements _$$_GoodsTypeModelCopyWith<$Res> {
  __$$_GoodsTypeModelCopyWithImpl(
      _$_GoodsTypeModel _value, $Res Function(_$_GoodsTypeModel) _then)
      : super(_value, (v) => _then(v as _$_GoodsTypeModel));

  @override
  _$_GoodsTypeModel get _value => super._value as _$_GoodsTypeModel;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
  }) {
    return _then(_$_GoodsTypeModel(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_GoodsTypeModel implements _GoodsTypeModel {
  _$_GoodsTypeModel({this.id, this.name});

  factory _$_GoodsTypeModel.fromJson(Map<String, dynamic> json) =>
      _$$_GoodsTypeModelFromJson(json);

  @override
  final String? id;
  @override
  final String? name;

  @override
  String toString() {
    return 'GoodsTypeModel(id: $id, name: $name)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GoodsTypeModel &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.name, name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(name));

  @JsonKey(ignore: true)
  @override
  _$$_GoodsTypeModelCopyWith<_$_GoodsTypeModel> get copyWith =>
      __$$_GoodsTypeModelCopyWithImpl<_$_GoodsTypeModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_GoodsTypeModelToJson(
      this,
    );
  }
}

abstract class _GoodsTypeModel implements GoodsTypeModel {
  factory _GoodsTypeModel({final String? id, final String? name}) =
      _$_GoodsTypeModel;

  factory _GoodsTypeModel.fromJson(Map<String, dynamic> json) =
      _$_GoodsTypeModel.fromJson;

  @override
  String? get id;
  @override
  String? get name;
  @override
  @JsonKey(ignore: true)
  _$$_GoodsTypeModelCopyWith<_$_GoodsTypeModel> get copyWith =>
      throw _privateConstructorUsedError;
}
