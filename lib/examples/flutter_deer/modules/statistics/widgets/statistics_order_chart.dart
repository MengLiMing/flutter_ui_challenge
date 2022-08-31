// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class StatisticsOrderLineItem {
  final int index;
  double scale = 0;
  Offset center = Offset.zero;
  double width = 0;
  double height = 0;

  StatisticsOrderLineItem({
    required this.index,
  });
}

class StatisticsOrderLineRepaint extends Listenable {
  final ValueNotifier<double> heightProgress;
  final ValueNotifier<double> showBubbleProgress;

// oldPoint == null, localPoint != null 显示
// oldPoint != null, localPoint != null 移动
// oldPoint != null, localPoint == null 消失
// 已经展示的坐标，
  Offset? oldPoint;
// 当前点击的坐标
  Offset? localPoint;

  bool isShowingBubble = false;

  StatisticsOrderLineRepaint({
    required this.heightProgress,
    required this.showBubbleProgress,
  });

  @override
  void addListener(VoidCallback listener) {
    heightProgress.addListener(listener);
    showBubbleProgress.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    heightProgress.removeListener(listener);
    showBubbleProgress.removeListener(listener);
  }
}

class StatisticsOrderLinePainter extends CustomPainter {
  final List<int> numbers;
  final Color bgColor;
  final TextSpan Function(int index) content;
  final EdgeInsets padding;
  final StatisticsOrderLineRepaint repaint;

  Path? _path;

  List<StatisticsOrderLineItem> _scales = [];

  final Paint _linePaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  StatisticsOrderLinePainter({
    required this.numbers,
    required this.bgColor,
    required this.padding,
    required this.content,
    required this.repaint,
  }) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    drawLine(canvas, size);

    selectedItem(canvas, size);
  }

  Path linePath(Size size) {
    Path path = Path();

    if (numbers.isEmpty) {
      _scales = [];
      return path;
    }
    int minNumber = numbers.first;
    int maxNumber = numbers.first;
    for (final number in numbers) {
      minNumber = min(number, minNumber);
      maxNumber = max(number, maxNumber);
    }

    final singleSpace = size.width / (numbers.length - 1);

    Offset? prePoint;
    for (int i = 0; i < numbers.length; i++) {
      final number = numbers[i];
      final double scale;
      if (maxNumber == minNumber) {
        scale = 0;
      } else {
        scale = (number - minNumber) / (maxNumber - minNumber);
      }

      final point = Offset(singleSpace * i, scale * size.height);

      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        final controlX = (point.dx + prePoint!.dx) / 2;
        path.cubicTo(
          controlX,
          prePoint.dy,
          controlX,
          point.dy,
          point.dx,
          point.dy,
        );
      }

      prePoint = point;
    }
    return path;
  }

  /// 将绘制信息回调到外部 在Stack上放置气泡， 这样添加动画应该更容易控制一点吧
  void selectedItem(Canvas canvas, Size size) {
    if (_path == null) return;
    if (repaint.heightProgress.value != 1) return;

    final localPoint = repaint.localPoint;
    final oldPoint = repaint.oldPoint;
    StatisticsOrderLineItem? oldSelectedItem; // 用于移动
    StatisticsOrderLineItem? selectedItem;
    if (localPoint != null) {
      selectedItem = findItem(localPoint);
    }
    if (oldPoint != null) {
      oldSelectedItem = findItem(oldPoint);
    }

    if (selectedItem == null && oldSelectedItem == null) return;

    final pointRadius = size.height * 0.06;
    final showBubbleProgress = repaint.showBubbleProgress.value;

    int index;
    Color bubbleColor = Colors.white.withOpacity(showBubbleProgress);
    Offset itemCenter;

    if (repaint.isShowingBubble == false) {
      // 消失
      index = oldSelectedItem!.index;
      final center = oldSelectedItem.center;
      itemCenter = Offset(
        center.dx,
        lerpDouble(size.height, center.dy, showBubbleProgress)!,
      );
      if (showBubbleProgress == 0) {
        repaint.localPoint = null;
        repaint.oldPoint = null;
      }
    } else {
      if (oldSelectedItem == null) {
        //显示
        index = selectedItem!.index;
        final center = selectedItem.center;
        itemCenter = Offset(
          center.dx,
          lerpDouble(size.height, center.dy, showBubbleProgress)!,
        );
      } else {
        //移动
        bubbleColor = Colors.white;

        index = showBubbleProgress < 0.5
            ? oldSelectedItem.index
            : selectedItem!.index;

        // itemCenter = Offset.lerp(
        //     oldSelectedItem.center, selectedItem!.center, showBubbleProgress)!;

        // 来点高端的
        final scale = lerpDouble(
            oldSelectedItem.scale, selectedItem!.scale, showBubbleProgress)!;
        final pm = _path!.computeMetrics().first;
        Tangent tangent = pm.getTangentForOffset(pm.length * scale)!;
        final position = tangent.position;
        itemCenter = Offset(position.dx + padding.left,
            size.height - padding.top - position.dy);
      }
    }

    if (showBubbleProgress == 1) {
      repaint.oldPoint = repaint.localPoint;
    }

    /// 绘制弹出框
    TextPainter textPainter = TextPainter(
      text: content(index),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();

    // 气泡上圆圈的半径
    final circleRadius = textPainter.height / 2;
    // 箭头高
    const arrowHeight = 6.0;
    // 箭头宽
    const arrowWidth = 12.0;
    // 箭头距离远点的间距
    const bottomSpace = 4;

    final bubbleWidth = 2 + circleRadius + 2 + textPainter.width + 2;
    final bubbleHeight = 8 + textPainter.height + 8;

    Rect rect = Rect.fromCenter(
      center: itemCenter,
      width: bubbleWidth,
      height: bubbleHeight,
    );

    rect = Rect.fromLTWH(
        rect.left,
        rect.top - rect.height / 2 - pointRadius - arrowHeight - bottomSpace,
        rect.width,
        rect.height);

    /// 绘制气泡
    canvas.drawRRect(
        RRect.fromRectAndRadius(
          rect,
          const Radius.circular(4),
        ),
        Paint()..color = bubbleColor);

    /// 绘制箭头
    Path arrowPath = Path()
      ..moveTo(rect.center.dx - arrowWidth / 2, rect.bottom - 1)
      ..relativeLineTo(arrowWidth / 2, arrowHeight)
      ..relativeLineTo(arrowWidth / 2, -arrowHeight);

    canvas.drawPath(arrowPath, Paint()..color = bubbleColor);

    if (repaint.isShowingBubble && showBubbleProgress >= 0.5) {
      textPainter.paint(
        canvas,
        Offset(
          rect.center.dx - textPainter.width / 2,
          rect.center.dy - textPainter.height / 2,
        ),
      );

      canvas.drawCircle(
        (selectedItem?.center ?? oldSelectedItem?.center)!,
        pointRadius,
        Paint()..color = Colors.white,
      );
    }
  }

  StatisticsOrderLineItem? findItem(Offset offset) {
    for (final item in _scales) {
      final rect = Rect.fromCenter(
          center: item.center, width: item.width, height: item.height);
      if (rect.contains(offset)) {
        return item;
      }
    }
    return null;
  }

  void drawLine(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(padding.left, size.height - padding.top);
    canvas.scale(1.0, -1.0);

    final width = size.width - padding.horizontal;
    final height =
        (size.height - padding.vertical) * repaint.heightProgress.value;

    final path = linePath(Size(width, height));
    final strokeWidth = size.height * 0.03;

    canvas.drawPath(
      path,
      _linePaint..strokeWidth = strokeWidth,
    );

    List<StatisticsOrderLineItem> items = [];

    final smallRadius = strokeWidth;
    final bigRadius = strokeWidth * 2;

    PathMetric pm = path.computeMetrics().first;

    /// 绘制点
    Paint pointPaint = Paint();

    /// 单个可点击区域的宽
    double singleSpace = width;

    /// 设计图不是从0开始也不是到1结束
    const scaleOffset = 0.02;

    if (numbers.isNotEmpty) {
      singleSpace = (width * (1 - 2 * scaleOffset)) / (numbers.length - 1);
    }
    for (int i = 0; i < numbers.length; i++) {
      final scale = i / (numbers.length - 1);

      final newScale = lerpDouble(scaleOffset, 1 - scaleOffset, scale)!;

      Tangent tangent = pm.getTangentForOffset(pm.length * newScale)!;

      final position = tangent.position;

      canvas.drawCircle(position, bigRadius, pointPaint..color = bgColor);
      canvas.drawCircle(
          tangent.position, smallRadius, pointPaint..color = Colors.white);

      final center = Offset(
          position.dx + padding.left, height - position.dy + padding.top);
      items.add(
        StatisticsOrderLineItem(index: i)
          ..center = center
          ..width = singleSpace
          ..height = size.height * 3
          ..scale = newScale,
      );
    }

    _scales = items;
    _path = path;
    canvas.restore();
  }

  @override
  bool? hitTest(Offset position) {
    return true;
  }

  @override
  bool shouldRepaint(covariant StatisticsOrderLinePainter oldDelegate) {
    return listEquals(oldDelegate.numbers, numbers) == false;
  }
}
