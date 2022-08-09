import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/order/models/order_models.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/order/provider/order_list_provider.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/toast.dart';

class OrderListItem extends ConsumerStatefulWidget {
  final OrderListItemData itemData;
  const OrderListItem({
    Key? key,
    required this.itemData,
  }) : super(key: key);

  @override
  ConsumerState<OrderListItem> createState() => _OrderListItemState();
}

class _OrderListItemState extends ConsumerState<OrderListItem> {
  void tapAction(OrderListActionType actionType) {
    Toast.show(actionType.title);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Row(
        children: [
          const Text('15503048888（郭李）'),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: Text(
                '货到付款',
                style: TextStyle(
                  color: Theme.of(context).errorColor,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 8,
      ),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            constraints:
                BoxConstraints(maxWidth: ScreenUtils.width - 32 * 2 - 16),
            child: Text(
              '西安市雁塔区 鱼化寨街道唐兴路'.split('').join('\u{200B}'),
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_right,
            color: Colours.textGrayC,
            size: 16,
          ),
        ],
      ),
      Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Divider(),
      ),
      orderInfo(),
      Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Divider(),
      ),
      actions(),
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        boxShadow: [
          BoxShadow(
            color: Color(0x80dce7fa),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget actions() {
    switch (widget.itemData.orderType) {
      case OrderType.newOrder:
        return Row(
          children: [
            Expanded(
                child: OrderListActionType.contact.actionButton(tapAction)),
            const SizedBox(width: 39),
            Expanded(
                child: OrderListActionType.refused.actionButton(tapAction)),
            const SizedBox(width: 8),
            Expanded(child: OrderListActionType.accept.actionButton(tapAction)),
          ],
        );
      case OrderType.waiting:
        return Row(
          children: [
            Expanded(
                child: OrderListActionType.contact.actionButton(tapAction)),
            const SizedBox(width: 39),
            Expanded(
                child: OrderListActionType.refused.actionButton(tapAction)),
            const SizedBox(width: 8),
            Expanded(child: OrderListActionType.start.actionButton(tapAction)),
          ],
        );
      case OrderType.pending:
        return Row(
          children: [
            Expanded(
                child: OrderListActionType.contact.actionButton(tapAction)),
            const SizedBox(width: 39),
            Expanded(
                child: OrderListActionType.orderInfo.actionButton(tapAction)),
            const SizedBox(width: 8),
            Expanded(
                child: OrderListActionType.complete.actionButton(tapAction)),
          ],
        );
      case OrderType.completed:
      case OrderType.cancelled:
        return Row(
          children: [
            Expanded(
                child: OrderListActionType.contact.actionButton(tapAction)),
            SizedBox(width: 135),
            Expanded(
                child: OrderListActionType.orderInfo.actionButton(tapAction)),
          ],
        );
    }
  }

  /// 订单信息
  Widget orderInfo() {
    final TextStyle? textTextStyle =
        Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 12);
    return Consumer(builder: (context, ref, child) {
      final unfoldItem =
          ref.watch(OrderListProviders.unfoldItem(widget.itemData.orderType));

      final unfoldState = ref
          .read(OrderListProviders.unfoldItem(widget.itemData.orderType).state);
      final isUnfold = unfoldItem == widget.itemData;
      List<Widget> children;
      if (isUnfold) {
        children = [
          for (int i = 0; i < 3; i++) ...[
            RichText(
              text: TextSpan(
                style: textTextStyle,
                children: <TextSpan>[
                  const TextSpan(text: '清凉一度抽纸'),
                  TextSpan(
                      text: '  x1',
                      style: Theme.of(context).textTheme.subtitle2),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
          ],
          GestureDetector(
            onTap: () => unfoldState.state = null,
            child: Container(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.keyboard_arrow_up,
                color: Colours.textGrayC,
                size: 16,
              ),
            ),
          )
        ];
      } else {
        children = [
          RichText(
            text: TextSpan(
              style: textTextStyle,
              children: <TextSpan>[
                const TextSpan(text: '清凉一度抽纸'),
                TextSpan(
                    text: '  x1', style: Theme.of(context).textTheme.subtitle2),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          GestureDetector(
            onTap: () => unfoldState.state = widget.itemData,
            child: Row(
              children: [
                Text('…'),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colours.textGrayC,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          )
        ];
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      );
    });
  }
}

extension OrderListActionTypeExtension on OrderListActionType {
  String get title {
    switch (this) {
      case OrderListActionType.contact:
        return '联系客户';
      case OrderListActionType.refused:
        return '拒单';
      case OrderListActionType.accept:
        return '接单';
      case OrderListActionType.start:
        return '开始配送';
      case OrderListActionType.orderInfo:
        return '订单跟踪';
      case OrderListActionType.complete:
        return '完成配送';
    }
  }

  Widget actionButton(ValueChanged<OrderListActionType> onTap) {
    final String title;
    final TextStyle textStyle;
    final Color bgColor;
    switch (this) {
      case OrderListActionType.contact:
        title = '联系客户';
        bgColor = const Color(0xFFF6F6F6);
        textStyle = const TextStyle(color: Colours.text, fontSize: 14);
        break;
      case OrderListActionType.refused:
        title = '拒单';
        bgColor = const Color(0xFFF6F6F6);
        textStyle = const TextStyle(color: Colours.text, fontSize: 14);
        break;
      case OrderListActionType.accept:
        title = '接单';
        bgColor = const Color(0xFF4688FA);
        textStyle = const TextStyle(color: Colors.white, fontSize: 14);
        break;
      case OrderListActionType.start:
        title = '开始配送';
        bgColor = const Color(0xFF4688FA);
        textStyle = const TextStyle(color: Colors.white, fontSize: 14);
        break;
      case OrderListActionType.orderInfo:
        title = '订单跟踪';
        bgColor = const Color(0xFFF6F6F6);
        textStyle = const TextStyle(color: Colours.text, fontSize: 14);
        break;
      case OrderListActionType.complete:
        title = '完成配送';
        bgColor = const Color(0xFF4688FA);
        textStyle = const TextStyle(color: Colors.white, fontSize: 14);
        break;
    }

    return MaterialButton(
      elevation: 0,
      hoverElevation: 0,
      color: bgColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4))),
      onPressed: () {
        onTap(this);
      },
      child: Text(
        title,
        style: textStyle,
      ),
    );
  }
}

enum OrderListActionType {
  /// 联系
  contact,

  /// 拒单
  refused,

  /// 接单
  accept,

  /// 开始配送
  start,

  /// 订单跟踪
  orderInfo,

  /// 完成
  complete,
}
