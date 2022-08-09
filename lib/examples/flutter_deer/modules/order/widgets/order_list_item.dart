import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/order/models/order_models.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/order/provider/order_list_provider.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';

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
    return Row(
      children: [],
    );
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

enum OrderListActionType {
  // 联系
  contact,
  // 拒单
  refused,
  // 接单
  accept,
  // 开始配送
  start,
  // 订单跟踪
  orderInfo,
  // 完成
  complete,
}
