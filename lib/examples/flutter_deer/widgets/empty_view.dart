import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';

class EmptyView extends StatelessWidget {
  final EmptyType type;
  final String? hintText;

  const EmptyView({
    Key? key,
    required this.type,
    this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (type == EmptyType.loading)
          const CupertinoActivityIndicator(radius: 16)
        else
          LoadAssetImage(
            'state/${type.img}',
            width: 120,
          ),
        const SizedBox(height: 16),
        Text(
          hintText ?? type.hintText,
          style: TextStyle(
            fontSize: 14,
            color: Colours.text,
          ),
        )
      ],
    );
  }
}

enum EmptyType {
  /// 订单
  order,

  /// 商品
  goods,

  /// 无网络
  network,

  /// 消息
  message,

  /// 无提现账号
  account,

  /// 加载中
  loading,

  /// 空
  empty
}

extension EmptyTypeExtension on EmptyType {
  String get img =>
      <String>['zwdd', 'zwsp', 'zwwl', 'zwxx', 'zwzh', '', 'zwdd'][index];

  String get hintText =>
      <String>['暂无订单', '暂无商品', '无网络连接', '暂无消息', '马上添加提现账号吧', '', '暂无数据'][index];
}
