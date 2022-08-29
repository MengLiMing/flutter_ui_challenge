// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class StatisticsOrderChart extends StatefulWidget {
  final List<int> numbers;
  final Color bgColor;

  const StatisticsOrderChart({
    Key? key,
    required this.numbers,
    required this.bgColor,
  }) : super(key: key);

  @override
  State<StatisticsOrderChart> createState() => _StatisticsOrderChartState();
}

class _StatisticsOrderChartState extends State<StatisticsOrderChart> {
  Offset _locatPosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: GestureDetector(
        onLongPressDown: (details) {
          _locatPosition = details.localPosition;
        },
        child: CustomPaint(
          painter: StatisticsOrderLinePainter(
            numbers: widget.numbers,
            bgColor: widget.bgColor,
          ),
        ),
      ),
    );
  }
}

class StatisticsOrderLineItem {
  final int original;
  double scale = 0;
  Offset center = Offset.zero;
  double width = 0;
  double height = 0;

  StatisticsOrderLineItem({
    required this.original,
  });
}

class StatisticsOrderLinePainter extends CustomPainter {
  final List<int> numbers;
  final Color bgColor;

  List<StatisticsOrderLineItem> _scales = [];

  StatisticsOrderLinePainter({
    required this.numbers,
    required this.bgColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(0, size.height);
    canvas.scale(1.0, -1.0);
    drawLine(canvas, size);
    canvas.restore();
  }

  void drawLine(Canvas canvas, Size size) {
    if (numbers.isEmpty) {
      _scales = [];
      return;
    }
    int minNumber = numbers.first;
    int maxNumber = numbers.first;
    for (final number in numbers) {
      minNumber = min(number, minNumber);
      maxNumber = max(number, maxNumber);
    }

    List<StatisticsOrderLineItem> items = [];

    final singleSpace = size.width / (numbers.length - 1);

    Path path = Path();

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

      items.add(
        StatisticsOrderLineItem(original: number),
      );
    }

    final strokeWidth = size.height * 0.04;

    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    final smallRadius = size.height * 0.06;
    final bigRadius = size.height * 0.1;

    PathMetric pm = path.computeMetrics().first;
    for (int i = 0; i < items.length; i++) {
      final scale = i / (items.length - 1);

      /// 设计图不是从0开始也不是到1结束，所以用path生成一个新的scale
      const scaleOffset = 0.03;
      final newScale = lerpDouble(scaleOffset, 1 - scaleOffset, scale)!;

      Tangent tangent = pm.getTangentForOffset(pm.length * newScale)!;

      final position = tangent.position;

      canvas.drawCircle(position, bigRadius, Paint()..color = bgColor);
      canvas.drawCircle(
          tangent.position, smallRadius, Paint()..color = Colors.white);

      /// 因为绘制的时候处理过，此处将offset修正为真实的offset, 宽高扩大一点 点击容易命中
      items[i]
        ..center = Offset(position.dx, size.height - position.dy)
        ..width = bigRadius * 4
        ..height = bigRadius * 4
        ..scale = newScale;
    }

    _scales = items;
  }

  @override
  bool shouldRepaint(covariant StatisticsOrderLinePainter oldDelegate) {
    return listEquals(oldDelegate.numbers, numbers);
  }
}
