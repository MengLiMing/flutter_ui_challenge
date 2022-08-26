import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';

class StatisticsHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget content;

  const StatisticsHeaderDelegate({required this.content});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final maxOffset = maxExtent - minExtent;
    final offset = min(shrinkOffset, maxOffset);
    final progress = offset / maxOffset;

    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          bottom: 130.fit,
          height: maxExtent - 130.fit,
          child: const LoadAssetImage(
            'statistic/statistic_bg',
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 130.fit,
          child: const LoadAssetImage(
            'statistic/statistic_bg1',
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          height: lerpDouble(64.fit, ScreenUtils.navBarHeight, progress),
          top: lerpDouble(30.fit, 0, progress)! + ScreenUtils.topPadding,
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.fit),
              alignment: AlignmentTween(
                begin: Alignment.centerLeft,
                end: Alignment.center,
              ).lerp(progress),
              child: Text(
                '统计',
                style: TextStyle(
                  letterSpacing: 2,
                  fontSize: lerpDouble(26.fit, 18, progress),
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 16.fit,
          right: 16.fit,
          bottom: 10.fit,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(10.fit),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xffDCE7FA).withOpacity(0.5),
                  offset: Offset(0, 2.fit),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            height: 120.fit,
            child: content,
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent =>
      ScreenUtils.topPadding + ScreenUtils.navBarHeight + 178.fit;

  @override
  double get minExtent =>
      ScreenUtils.topPadding + ScreenUtils.navBarHeight + 140.fit;

  @override
  bool shouldRebuild(covariant StatisticsHeaderDelegate oldDelegate) {
    return false;
  }
}
