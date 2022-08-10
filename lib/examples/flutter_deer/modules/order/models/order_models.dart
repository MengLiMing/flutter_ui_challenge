import 'package:equatable/equatable.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/order/widgets/order_type_choose.dart';

class OrderListItemData extends Equatable {
  final int index;
  final OrderType orderType;
  const OrderListItemData({
    required this.index,
    required this.orderType,
  });

  @override
  List<Object?> get props => [index];
}

enum OrderType {
  // 新订单
  newOrder,
  // 待配送
  waiting,
  // 待完成
  pending,
  // 已完成
  completed,
  // 已取消
  cancelled,
}

extension OrderTypeExtension on OrderType {
  OrderChooseItemData get orderItemData {
    switch (this) {
      case OrderType.newOrder:
        return OrderChooseItemData(
          title: '新订单',
          selectImg: 'order/xdd_s',
          unSelectImg: 'order/xdd_n',
          orderType: this,
        );
      case OrderType.waiting:
        return OrderChooseItemData(
          title: '待配送',
          selectImg: 'order/dps_s',
          unSelectImg: 'order/dps_n',
          orderType: this,
        );
      case OrderType.pending:
        return OrderChooseItemData(
          title: '待完成',
          selectImg: 'order/dwc_s',
          unSelectImg: 'order/dwc_n',
          orderType: this,
        );
      case OrderType.completed:
        return OrderChooseItemData(
          title: '已完成',
          selectImg: 'order/ywc_s',
          unSelectImg: 'order/ywc_n',
          orderType: this,
        );
      case OrderType.cancelled:
        return OrderChooseItemData(
          title: '已取消',
          selectImg: 'order/yqx_s',
          unSelectImg: 'order/yqx_n',
          orderType: this,
        );
    }
  }
}

enum PaymentType {
  none,
  alipay,
  wechat,
  cash,
}

extension PaymentTypeExtension on PaymentType {
  String get desc => ['未付款', '支付宝', '微信', '现金'][index];
}
