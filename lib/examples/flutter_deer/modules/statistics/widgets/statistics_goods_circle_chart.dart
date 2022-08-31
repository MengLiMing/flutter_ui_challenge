// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/statistics/models/statistics_goods_model.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/statistics/provider/statistics_goods_providers.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/statistics/widgets/statistics_goods_circle_painter.dart';

class StatisticsGoodsCircleChart extends StatefulWidget {
  final List<StatisticsGoodsItemModel> goodsModels;
  final StatisticsGoodsStyle style;

  const StatisticsGoodsCircleChart({
    Key? key,
    required this.goodsModels,
    required this.style,
  }) : super(key: key);

  @override
  State<StatisticsGoodsCircleChart> createState() =>
      _StatisticsGoodsCircleChartState();
}

class _StatisticsGoodsCircleChartState extends State<StatisticsGoodsCircleChart>
    with SingleTickerProviderStateMixin {
  List<StatisticsGoodsCircleItem> chartItems = [];

  int _all = 0;

  late AnimationController animationController;
  late Animation<double> progress;

  @override
  void initState() {
    super.initState();
    dealChartItems();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..forward(from: 0);

    progress =
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant StatisticsGoodsCircleChart oldWidget) {
    dealChartItems();
    super.didUpdateWidget(oldWidget);
    if (oldWidget.style != widget.style ||
        listEquals(oldWidget.goodsModels, widget.goodsModels) == false) {
      animationController.forward(from: 0);
    }
  }

  void dealChartItems() {
    final goodsModels = widget.goodsModels;

    _all = goodsModels.fold<int>(
      0,
      (previousValue, element) => previousValue + element.number,
    );

    chartItems = goodsModels.map((e) {
      if (_all == 0) {
        return StatisticsGoodsCircleItem(
            color: e.color, scale: 1 / goodsModels.length);
      } else {
        return StatisticsGoodsCircleItem(
          color: e.color,
          scale: e.number / _all,
        );
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => animationController.forward(from: 0),
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          RepaintBoundary(
            child: CustomPaint(
              painter: StatisticsGoodsCirclePainter(
                items: chartItems,
                progress: progress,
                style: widget.style == StatisticsGoodsStyle.complete
                    ? StatisticsGoodsCircleAnimationStyle.scale
                    : StatisticsGoodsCircleAnimationStyle.clip,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.style == StatisticsGoodsStyle.complete ? "已配送" : "待配送",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text('$_all件'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
