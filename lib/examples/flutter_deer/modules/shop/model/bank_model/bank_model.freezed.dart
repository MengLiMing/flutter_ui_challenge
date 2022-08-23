// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'bank_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

BankModel _$BankModelFromJson(Map<String, dynamic> json) {
  return _BankModel.fromJson(json);
}

/// @nodoc
mixin _$BankModel {
  int? get id => throw _privateConstructorUsedError;
  String? get bankName => throw _privateConstructorUsedError;
  String? get firstLetter => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BankModelCopyWith<BankModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BankModelCopyWith<$Res> {
  factory $BankModelCopyWith(BankModel value, $Res Function(BankModel) then) =
      _$BankModelCopyWithImpl<$Res>;
  $Res call({int? id, String? bankName, String? firstLetter});
}

/// @nodoc
class _$BankModelCopyWithImpl<$Res> implements $BankModelCopyWith<$Res> {
  _$BankModelCopyWithImpl(this._value, this._then);

  final BankModel _value;
  // ignore: unused_field
  final $Res Function(BankModel) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? bankName = freezed,
    Object? firstLetter = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      bankName: bankName == freezed
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      firstLetter: firstLetter == freezed
          ? _value.firstLetter
          : firstLetter // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$$_BankModelCopyWith<$Res> implements $BankModelCopyWith<$Res> {
  factory _$$_BankModelCopyWith(
          _$_BankModel value, $Res Function(_$_BankModel) then) =
      __$$_BankModelCopyWithImpl<$Res>;
  @override
  $Res call({int? id, String? bankName, String? firstLetter});
}

/// @nodoc
class __$$_BankModelCopyWithImpl<$Res> extends _$BankModelCopyWithImpl<$Res>
    implements _$$_BankModelCopyWith<$Res> {
  __$$_BankModelCopyWithImpl(
      _$_BankModel _value, $Res Function(_$_BankModel) _then)
      : super(_value, (v) => _then(v as _$_BankModel));

  @override
  _$_BankModel get _value => super._value as _$_BankModel;

  @override
  $Res call({
    Object? id = freezed,
    Object? bankName = freezed,
    Object? firstLetter = freezed,
  }) {
    return _then(_$_BankModel(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      bankName: bankName == freezed
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      firstLetter: firstLetter == freezed
          ? _value.firstLetter
          : firstLetter // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_BankModel implements _BankModel {
  _$_BankModel({this.id, this.bankName, this.firstLetter});

  factory _$_BankModel.fromJson(Map<String, dynamic> json) =>
      _$$_BankModelFromJson(json);

  @override
  final int? id;
  @override
  final String? bankName;
  @override
  final String? firstLetter;

  @override
  String toString() {
    return 'BankModel(id: $id, bankName: $bankName, firstLetter: $firstLetter)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BankModel &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.bankName, bankName) &&
            const DeepCollectionEquality()
                .equals(other.firstLetter, firstLetter));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(bankName),
      const DeepCollectionEquality().hash(firstLetter));

  @JsonKey(ignore: true)
  @override
  _$$_BankModelCopyWith<_$_BankModel> get copyWith =>
      __$$_BankModelCopyWithImpl<_$_BankModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_BankModelToJson(
      this,
    );
  }
}

abstract class _BankModel implements BankModel {
  factory _BankModel(
      {final int? id,
      final String? bankName,
      final String? firstLetter}) = _$_BankModel;

  factory _BankModel.fromJson(Map<String, dynamic> json) =
      _$_BankModel.fromJson;

  @override
  int? get id;
  @override
  String? get bankName;
  @override
  String? get firstLetter;
  @override
  @JsonKey(ignore: true)
  _$$_BankModelCopyWith<_$_BankModel> get copyWith =>
      throw _privateConstructorUsedError;
}
