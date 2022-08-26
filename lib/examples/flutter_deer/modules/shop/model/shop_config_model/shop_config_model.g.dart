// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopConfigModel _$ShopConfigModelFromJson(Map<String, dynamic> json) =>
    ShopConfigModel(
      isBusiness: json['isBusiness'] as bool? ?? false,
      desc: json['desc'] as String? ?? '',
      sevice: json['sevice'] as String? ?? '',
      payment: (json['payment'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$ShopPaymentStyleEnumMap, e))
              .toList() ??
          const [ShopPaymentStyle.online],
      freightConfig: $enumDecodeNullable(
              _$ShopFreightConfigEnumMap, json['freightConfig']) ??
          ShopFreightConfig.breaks,
      freightScale: json['freightScale'] as String? ?? '',
      freightBreaks: json['freightBreaks'] as String? ?? '',
      freightCost: json['freightCost'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      address: json['address'] as String? ?? '',
    );

Map<String, dynamic> _$ShopConfigModelToJson(ShopConfigModel instance) =>
    <String, dynamic>{
      'isBusiness': instance.isBusiness,
      'desc': instance.desc,
      'sevice': instance.sevice,
      'payment':
          instance.payment.map((e) => _$ShopPaymentStyleEnumMap[e]!).toList(),
      'freightConfig': _$ShopFreightConfigEnumMap[instance.freightConfig]!,
      'freightScale': instance.freightScale,
      'freightBreaks': instance.freightBreaks,
      'freightCost': instance.freightCost,
      'phone': instance.phone,
      'address': instance.address,
    };

const _$ShopPaymentStyleEnumMap = {
  ShopPaymentStyle.online: 0,
  ShopPaymentStyle.public: 1,
  ShopPaymentStyle.delivery: 2,
};

const _$ShopFreightConfigEnumMap = {
  ShopFreightConfig.breaks: 0,
  ShopFreightConfig.scale: 1,
};
