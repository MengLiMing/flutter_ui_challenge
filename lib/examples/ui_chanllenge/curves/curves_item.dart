import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/ui_chanllenge/curves/curve_type.dart';

final frame = seconds * 60;

final seconds = 1;

class CurveItem extends StatefulWidget {
  final CurveType curveType;

  const CurveItem({Key? key, required this.curveType}) : super(key: key);

  @override
  State<CurveItem> createState() => _CurveItemState();
}

class _CurveItemState extends State<CurveItem>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: seconds),
    );
  }

  void _startAnimation() {
    animationController.forward(from: 0);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _startAnimation,
      child: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(color: Colors.black38, blurRadius: 2),
        ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(widget.curveType.name),
            ),
            SizedBox(
              height: 180,
              width: double.infinity,
              child: CustomPaint(
                painter: CurvePainter(
                  curveType: widget.curveType,
                  time: animationController,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  final CurveType curveType;

  final ValueListenable<double> time;

  CurvePainter({
    required this.curveType,
    required this.time,
  }) : super(repaint: time);

  late final oneTextPaint = TextPainter(
    textDirection: TextDirection.ltr,
    text: const TextSpan(
      text: '1.0',
      style: TextStyle(color: Colors.grey, fontSize: 13),
    ),
  )..layout();

  @override
  void paint(Canvas canvas, Size size) {
    _drawXY(canvas, size);
    _drawText(canvas, size);
    _drawCurve(canvas, size);
    _drawTimes(canvas, size);
    _drawIndicator(canvas, size);
  }

  /// 绘制指示器
  void _drawIndicator(Canvas canvas, Size size) {
    canvas.save();

    canvas.translate(size.width - right, size.height - bottom);
    canvas.scale(1, -1);

    Path path = Path();

    final vy = curveBy(curveType).transform(time.value) * vLength(size);
    path
      ..moveTo(0, vy)
      ..relativeLineTo(indicatorSize.width * 0.3, indicatorSize.height / 2)
      ..relativeLineTo(indicatorSize.width * 0.7, 0)
      ..relativeLineTo(0, -indicatorSize.height)
      ..relativeLineTo(-indicatorSize.width * 0.7, 0)
      ..close();

    canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.red);

    canvas.restore();
  }

  /// 绘制动画曲线
  void _drawTimes(Canvas canvas, Size size) {
    final stopFrame = (time.value * frame).toInt();
    _drawPoints(stopFrame, canvas, size, color: Colors.red);
  }

  /// 绘制背景曲线
  void _drawCurve(Canvas canvas, Size size) {
    _drawPoints(
      frame,
      canvas,
      size,
    );
  }

  /// 绘制点
  void _drawPoints(int stopFrame, Canvas canvas, Size size,
      {Color color = Colors.grey}) {
    canvas.save();
    canvas.translate(left, size.height - bottom);
    canvas.scale(1, -1);
    Path path = Path();

    final curve = curveBy(curveType);

    Offset preOffset = Offset.zero;
    for (int i = 0; i < stopFrame; i++) {
      final t = i / frame;
      final point = Offset(
        hLength(size) * t,
        curve.transform(t) * vLength(size),
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        final controlPoint = (point + preOffset) / 2;
        path.quadraticBezierTo(
            controlPoint.dx, controlPoint.dy, point.dx, point.dy);
      }
      preOffset = point;
    }
    canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = color);
    canvas.restore();
  }

  /// 绘制坐标轴
  void _drawXY(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(left, size.height - bottom);

    final axisPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset.zero,
      Offset(0, -vLength(size)),
      axisPaint,
    );

    canvas.drawLine(
      Offset.zero,
      Offset(hLength(size), 0),
      axisPaint,
    );

    canvas.restore();
  }

  void _drawText(Canvas canvas, Size size) {
    oneTextPaint.paint(
      canvas,
      Offset(
        (left - oneTextPaint.width) / 2,
        top - oneTextPaint.height / 2,
      ),
    );
    oneTextPaint.paint(
      canvas,
      Offset(
        size.width - right - oneTextPaint.width / 2,
        (size.height - bottom + (bottom - oneTextPaint.height) / 2),
      ),
    );

    final xTextPaint = TextPainter(
      textDirection: TextDirection.ltr,
      text: const TextSpan(
        text: 'x',
        style: TextStyle(color: Colors.grey, fontSize: 12),
      ),
    )..layout();
    xTextPaint.paint(
      canvas,
      Offset(
        left + 6,
        top - xTextPaint.height / 2,
      ),
    );

    final tTextPaint = TextPainter(
      textDirection: TextDirection.ltr,
      text: const TextSpan(
        text: 't',
        style: TextStyle(color: Colors.grey, fontSize: 12),
      ),
    )..layout();
    tTextPaint.paint(
      canvas,
      Offset(
        size.width - right - tTextPaint.width / 2,
        size.height - bottom - tTextPaint.height - 5,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

extension CurvePainterLogic on CurvePainter {
  /// 指示器size
  Size get indicatorSize => Size(30, 10);

  /// 竖直方向 左距离
  double get left => oneTextPaint.width * 2;

  /// 右侧距离
  double get right => indicatorSize.width + 3;

  /// 下方距离
  double get bottom => oneTextPaint.height * 2;

  /// 上方距离
  double get top => max(oneTextPaint.height / 2, indicatorSize.height / 2);

  /// 竖直方向高度
  double vLength(Size size) {
    return size.height - top - bottom;
  }

  double hLength(Size size) {
    return size.width - left - right;
  }
}
