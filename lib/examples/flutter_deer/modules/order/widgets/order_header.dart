import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/order/widgets/order_type_choose.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';

class OrderHeader extends SliverPersistentHeaderDelegate {
  final List<OrderChooseItemData> items;

  final VoidCallback onSearch;

  const OrderHeader({
    required this.items,
    required this.onSearch,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final offset = max(0, min(maxExtent - minExtent, shrinkOffset));
    final progress = offset / (maxExtent - minExtent);

    final titleAlignment =
        AlignmentTween(begin: Alignment.centerLeft, end: Alignment.center)
            .lerp(progress);
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
            height: maxExtent - 110,
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          left: 0,
          bottom: 10,
          height: 41,
          child: LoadAssetImage(
            'order/order_bg1',
            width: ScreenUtils.width,
            height: 100.0,
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          top: ScreenUtils.topPadding,
          right: 0,
          height: ScreenUtils.navBarHeight,
          child: Container(
            alignment: Alignment.center,
            width: 50,
            height: ScreenUtils.navBarHeight,
            child: IconButton(
              icon: const LoadAssetImage(
                'order/icon_search',
                width: 22,
                height: 22,
              ),
              onPressed: onSearch,
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          height: lerpDouble(62, ScreenUtils.navBarHeight, progress),
          top: lerpDouble(32, 0, progress)! + ScreenUtils.topPadding,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: titleAlignment,
            child: Text(
              '订单',
              style: TextStyle(
                fontSize: lerpDouble(24, 18, progress),
                fontWeight: FontWeight.w600,
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
  double get maxExtent => ScreenUtils.topPadding + 95 + 80;

  @override
  double get minExtent =>
      ScreenUtils.topPadding + ScreenUtils.navBarHeight + 4 + 80;

  @override
  bool shouldRebuild(covariant OrderHeader oldDelegate) {
    return listEquals(items, oldDelegate.items);
  }
}
