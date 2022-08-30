// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class StatisticsOrderChart extends StatefulWidget {
  final List<int> numbers;
  final Color bgColor;
  final double horizontalSpace;
  final TextSpan Function(int index) content;

  const StatisticsOrderChart({
    Key? key,
    required this.numbers,
    required this.bgColor,
    required this.content,
    required this.horizontalSpace,
  }) : super(key: key);

  @override
  State<StatisticsOrderChart> createState() => _StatisticsOrderChartState();
}

class _StatisticsOrderChartState extends State<StatisticsOrderChart> {
  Offset? _localPosition;

  bool showBubble = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: GestureDetector(
        onTap: () {
          if (showBubble) {
            setState(() {
              showBubble = false;
            });
          }
        },
        onLongPressDown: (details) {
          _localPosition = details.localPosition;
        },
        onLongPress: () {
          setState(() {
            showBubble = true;
          });
        },
        child: RepaintBoundary(
          child: CustomPaint(
            painter: StatisticsOrderLinePainter(
              numbers: widget.numbers,
              bgColor: widget.bgColor,
              selectedOffset: showBubble ? _localPosition : null,
              content: widget.content,
              horizontalSpace: widget.horizontalSpace,
            ),
          ),
        ),
      ),
    );
  }
}

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

class StatisticsOrderLinePainter extends CustomPainter {
  final List<int> numbers;
  final Color bgColor;
  final Offset? selectedOffset;
  final TextSpan Function(int index) content;
  final double horizontalSpace;

  List<StatisticsOrderLineItem> _scales = [];

  final Paint _linePaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  StatisticsOrderLinePainter({
    required this.numbers,
    required this.bgColor,
    required this.selectedOffset,
    required this.horizontalSpace,
    required this.content,
  });

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

  /// 此处绘制也可以将其信息回调到外部 在Stack上放置气泡， 这样如果添加动画应该更容易控制一点
  void selectedItem(Canvas canvas, Size size) {
    final point = selectedOffset;
    if (point == null) return;

    final selectedItem = findItem(point);
    if (selectedItem == null) return;

    final pointRadius = size.height * 0.08;
    canvas.drawCircle(
        selectedItem.center, pointRadius, Paint()..color = Colors.white);

    /// 绘制弹出框
    TextPainter textPainter = TextPainter(
      text: content(selectedItem.index),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();

    // 气泡上圆圈的半径
    final circleRadius = textPainter.height / 2;
    // 箭头高
    final arrowHeight = 6.0;
    // 箭头宽
    final arrowWidth = 12.0;
    // 箭头距离远点的间距
    final bottomSpace = 4;

    final bubbleWidth = 2 + circleRadius + 2 + textPainter.width + 2;
    final bubbleHeight = 8 + textPainter.height + 8;

    Rect rect = Rect.fromCenter(
      center: selectedItem.center,
      width: bubbleWidth,
      height: bubbleHeight,
    );

    rect = Rect.fromLTWH(
        rect.left,
        rect.top - rect.height / 2 - pointRadius - arrowHeight - bottomSpace,
        rect.width,
        rect.height);

    if (rect.left < 0) {
      rect = Rect.fromLTRB(0, rect.top, rect.right - rect.left, rect.bottom);
    }

    /// 绘制气泡
    canvas.drawRRect(
        RRect.fromRectAndRadius(
          rect,
          Radius.circular(4),
        ),
        Paint()..color = Colors.white);

    /// 绘制箭头
    Path arrowPath = Path()
      ..moveTo(rect.center.dx - arrowWidth / 2, rect.bottom - 1)
      ..relativeLineTo(arrowWidth / 2, arrowHeight)
      ..relativeLineTo(arrowWidth / 2, -arrowHeight);

    canvas.drawPath(arrowPath, Paint()..color = Colors.white);

    textPainter.paint(
      canvas,
      Offset(
        rect.center.dx - textPainter.width / 2,
        rect.center.dy - textPainter.height / 2,
      ),
    );
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
    canvas.translate(horizontalSpace, size.height);
    canvas.scale(1.0, -1.0);

    final width = size.width - horizontalSpace * 2;
    final height = size.height;

    final path = linePath(Size(width, height));
    final strokeWidth = height * 0.04;

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

      final center =
          Offset(position.dx + horizontalSpace, height - position.dy);
      items.add(
        StatisticsOrderLineItem(index: i)
          ..center = center
          ..width = singleSpace
          ..height = size.height * 3
          ..scale = newScale,
      );
    }

    _scales = items;
    canvas.restore();
  }

  @override
  bool? hitTest(Offset position) {
    return true;
  }

  @override
  bool shouldRepaint(covariant StatisticsOrderLinePainter oldDelegate) {
    return listEquals(oldDelegate.numbers, numbers);
  }
}
