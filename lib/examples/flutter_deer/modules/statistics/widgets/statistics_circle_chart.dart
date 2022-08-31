import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';

class StatisticsCircleChart extends StatefulWidget {
  final List<double> datas;
  const StatisticsCircleChart({
    Key? key,
    required this.datas,
  }) : super(key: key);

  @override
  State<StatisticsCircleChart> createState() => _StatisticsCircleChartState();
}

class _StatisticsCircleChartState extends State<StatisticsCircleChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  late Animation<double> progress;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..forward();

    progress =
        CurvedAnimation(parent: animationController, curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => animationController.forward(from: 0),
      child: SizedBox.expand(
        child: RepaintBoundary(
          child: CustomPaint(
            painter: StatisticsCirclePainter(
              datas: widget.datas,
              progress: progress,
            ),
          ),
        ),
      ),
    );
  }
}

class StatisticsCirclePainter extends CustomPainter {
  final List<double> datas;

  final ValueListenable<double> progress;

  StatisticsCirclePainter({
    required this.datas,
    required this.progress,
  }) : super(
          repaint: progress,
        );

  final linePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..isAntiAlias = true;

  final List<List<Color>> colors = const [
    [
      ui.Color(0xFFFF4759),
      ui.Color(0xFFFFD599),
    ],
    [
      ui.Color(0xFFFFAA33),
      ui.Color(0xFFFFE999),
    ],
    [
      ui.Color(0xFF4688FA),
      ui.Color(0xFF96BBFA),
    ],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final lineWidth = size.height * 0.17;
    canvas.save();
    canvas.translate(size.width / 2, size.height - lineWidth / 2);
    linePaint.strokeWidth = lineWidth;

    final space = lineWidth * 0.3;
    for (int i = 0; i < 3; i++) {
      final radius = size.height - lineWidth * (i + 1) - space * i;

      canvas.drawPath(
          circlePath(radius, 1),
          linePaint
            ..color = Colours.bgColor
            ..shader = null);

      double data = 0;
      if (datas.length > i) {
        data = datas[i];
      }
      canvas.drawPath(
        circlePath(radius, data * progress.value),
        linePaint
          ..shader = ui.Gradient.linear(
            ui.Offset(-radius, 0),
            ui.Offset(radius, 0),
            colors[i],
          ),
      );
    }

    canvas.restore();
  }

  Path circlePath(double radius, double progress) {
    return Path()
      ..addArc(
          Rect.fromCenter(
              center: Offset.zero, width: radius * 2, height: radius * 2),
          pi,
          pi * progress);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
