import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/order/models/order_models.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/order/provider/order_header_provider.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/text_styles.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';

class OrderTypeChoose extends ConsumerWidget {
  final List<OrderChooseItemData> items;

  const OrderTypeChoose({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        boxShadow: [
          BoxShadow(
            color: Color(0xffdce7fa),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          for (int index = 0; index < items.length; index++)
            Expanded(
              child: _OrderTypeChooseItem(
                index: index,
                data: items[index],
              ),
            ),
        ],
      ),
    );
  }
}

class OrderChooseItemData extends Equatable {
  final String title;
  final String unSelectImg;
  final String selectImg;
  int count;
  final OrderType orderType;

  OrderChooseItemData({
    required this.title,
    required this.unSelectImg,
    required this.selectImg,
    required this.orderType,
    this.count = 0,
  });

  @override
  List<Object?> get props => [title, count];
}

class _OrderTypeChooseItem extends ConsumerWidget {
  final int index;

  final OrderChooseItemData data;

  const _OrderTypeChooseItem({
    Key? key,
    required this.index,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(HeaderProviders.isSelected(index));

    Widget content = Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        Positioned(
          top: 18,
          child: Column(children: [
            LoadAssetImage(
              result ? data.selectImg : data.unSelectImg,
              width: 24,
              height: 24,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              data.title,
              style: TextStyle(
                  fontWeight: result ? FontWeight.bold : FontWeight.normal),
            ),
          ]),
        ),
        if (data.count > 0)
          Align(
            alignment: const Alignment(0.4, -0.6),
            child: DecoratedBox(
              decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  '${data.count > 99 ? 99 : data.count}',
                  style: TextStyles.textSize12.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
      ],
    );

    content = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        ref.read(HeaderProviders.tapIndex.state).state = index;
      },
      child: content,
    );

    return content;
  }
}
