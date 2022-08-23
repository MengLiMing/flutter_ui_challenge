import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/order/widgets/order_type_choose.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';

class OrderHeader extends SliverPersistentHeaderDelegate {
  final double maxHeight;
  final double minHeight;
  final List<OrderChooseItemData> items;

  final VoidCallback onSearch;

  const OrderHeader({
    required this.items,
    required this.maxHeight,
    required this.minHeight,
    required this.onSearch,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final offset = max(0, min(maxHeight - minHeight, shrinkOffset));
    final progress = offset / (maxHeight - minHeight);
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: 0,
          left: 0,
          bottom: 40,
          child: LoadAssetImage(
            'order/order_bg',
            width: ScreenUtils.width,
            height: 113.0,
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          left: 0,
          bottom: 0,
          height: 41,
          child: LoadAssetImage(
            'order/order_bg1',
            width: ScreenUtils.width,
            height: 113.0,
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          top: ScreenUtils.topPadding,
          right: 0,
          child: Container(
            alignment: Alignment.center,
            width: 50,
            height: ScreenUtils.navBarHeight,
            child: IconButton(
              icon: const LoadAssetImage('order/icon_search',
                  width: 22, height: 22),
              onPressed: onSearch,
            ),
          ),
        ),
        Positioned(
          left: lerpDouble(16, (ScreenUtils.width - 48) / 2, progress),
          bottom: 96,
          child: Container(
            alignment: Alignment.center,
            height: 30,
            child: Text(
              '订单',
              style: TextStyle(
                fontSize: lerpDouble(24, 18, progress),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 0,
          height: 80,
          child: OrderTypeChoose(items: items),
        ),
      ],
    );
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant OrderHeader oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        listEquals(items, oldDelegate.items);
  }
}
