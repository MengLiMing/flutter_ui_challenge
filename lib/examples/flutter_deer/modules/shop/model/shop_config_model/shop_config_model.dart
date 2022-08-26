// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:freezed_annotation/freezed_annotation.dart';

part 'shop_config_model.g.dart';

enum ShopPaymentStyle {
  @JsonValue(0)
  online,

  @JsonValue(1)
  public,

  @JsonValue(2)
  delivery,
}

extension ShopPaymentStyleExtension on ShopPaymentStyle {
  String get title => ['线上支付', '对公转账', '货到付款'][index];
}

enum ShopFreightConfig {
  @JsonValue(0)
  breaks,

  @JsonValue(1)
  scale,
}

extension ShopFreightConfigExtension on ShopFreightConfig {
  String get title => ['运费减免配置', '运费比例配置'][index];
}

@JsonSerializable()
class ShopConfigModel {
  final bool isBusiness;

  final String desc;
  final String sevice;

  final List<ShopPaymentStyle> payment;

  final ShopFreightConfig freightConfig;

  final String freightScale;

  final String freightBreaks;
  final String freightCost;

  final String phone;
  final String address;

  const ShopConfigModel({
    this.isBusiness = false,
    this.desc = '',
    this.sevice = '',
    this.payment = const [ShopPaymentStyle.online],
    this.freightConfig = ShopFreightConfig.breaks,
    this.freightScale = '',
    this.freightBreaks = '',
    this.freightCost = '',
    this.phone = '',
    this.address = '',
  });

  ShopConfigModel copyWith({
    bool? isBusiness,
    String? desc,
    String? sevice,
    List<ShopPaymentStyle>? payment,
    ShopFreightConfig? freightConfig,
    String? freightScale,
    String? freightBreaks,
    String? freightCost,
    String? phone,
    String? address,
  }) {
    return ShopConfigModel(
      isBusiness: isBusiness ?? this.isBusiness,
      desc: desc ?? this.desc,
      sevice: sevice ?? this.sevice,
      payment: payment ?? this.payment,
      freightConfig: freightConfig ?? this.freightConfig,
      freightScale: freightScale ?? this.freightScale,
      freightBreaks: freightBreaks ?? this.freightBreaks,
      freightCost: freightCost ?? this.freightCost,
      phone: phone ?? this.phone,
      address: address ?? this.address,
    );
  }

  @override
  bool operator ==(covariant ShopConfigModel other) {
    if (identical(this, other)) return true;

    return other.isBusiness == isBusiness &&
        other.desc == desc &&
        other.sevice == sevice &&
        other.payment == payment &&
        other.freightConfig == freightConfig &&
        other.freightScale == freightScale &&
        other.freightBreaks == freightBreaks &&
        other.freightCost == freightCost &&
        other.phone == phone &&
        other.address == address;
  }

  @override
  int get hashCode {
    return isBusiness.hashCode ^
        desc.hashCode ^
        sevice.hashCode ^
        payment.hashCode ^
        freightConfig.hashCode ^
        freightScale.hashCode ^
        freightBreaks.hashCode ^
        freightCost.hashCode ^
        phone.hashCode ^
        address.hashCode;
  }

  Map<String, dynamic> toJson() => _$ShopConfigModelToJson(this);

  factory ShopConfigModel.fromJson(Map<String, dynamic> source) =>
      _$ShopConfigModelFromJson(source);
}
