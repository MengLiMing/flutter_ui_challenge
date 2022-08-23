import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

/// 提现方式
enum ShopWithdrawStyle {
  quick,
  normal,
}

extension ShopWithdrawStyleExtension on ShopWithdrawStyle {
  String get title => ['快速到账', '普通到账'][index];
}

/// 账户类型
enum ShopAccontType {
  private,
  public,
  wechat,
}

extension ShopAccontTypeExtension on ShopAccontType {
  String get title => [
        '银行卡(对私账号)',
        '银行卡(对公账号)',
        '微信',
      ][index];

  bool get isBank => this != ShopAccontType.wechat;
}

/// 账户信息
class ShopWithdrawAccountModel {
  bool get isBank => type.isBank;

  final String title;
  final String desc;
  final ShopAccontType type;

  const ShopWithdrawAccountModel({
    required this.title,
    required this.desc,
    required this.type,
  });

  static const List<ShopWithdrawAccountModel> samples = [
    ShopWithdrawAccountModel(
      title: '工商银行',
      desc: '尾号5306 Ming',
      type: ShopAccontType.public,
    ),
    ShopWithdrawAccountModel(
      title: '微信',
      desc: '刚刚好',
      type: ShopAccontType.wechat,
    )
  ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'desc': desc,
      'type': type.index,
    };
  }

  factory ShopWithdrawAccountModel.fromMap(Map<String, dynamic> map) {
    final typeIndex = map['type'] as int;
    return ShopWithdrawAccountModel(
      title: map['title'] as String,
      desc: map['desc'] as String,
      type: ShopAccontType.values[typeIndex],
    );
  }

  String toJson() => json.encode(toMap());

  factory ShopWithdrawAccountModel.fromJson(String source) =>
      ShopWithdrawAccountModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ShopWithdrawAccountModel(title: $title, desc: $desc, type: $type)';

  @override
  bool operator ==(covariant ShopWithdrawAccountModel other) {
    if (identical(this, other)) return true;

    return other.title == title && other.desc == desc && other.type == type;
  }

  @override
  int get hashCode => title.hashCode ^ desc.hashCode ^ type.hashCode;
}
