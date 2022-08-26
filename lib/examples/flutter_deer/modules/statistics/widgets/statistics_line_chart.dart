import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class StatisticsLineChart extends StatefulWidget {
  final Color textColor;
  final Color lineColor;
  final List<double> datas;
  final StatisticsLineAnimationStyle animationStyle;
  const StatisticsLineChart({
    Key? key,
    required this.textColor,
    required this.lineColor,
    required this.datas,
    required this.animationStyle,
  }) : super(key: key);

  @override
  State<StatisticsLineChart> createState() => _StatisticsLineChartState();
}

class _StatisticsLineChartState extends State<StatisticsLineChart>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  late Animation<double> progress;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..forward();

    progress = CurveTween(curve: Curves.easeInOut).animate(animationController);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => animationController.forward(from: 0),
      child: Column(
        children: [
          const SizedBox(width: double.infinity),
          DefaultTextStyle(
            style: TextStyle(color: widget.textColor, fontSize: 11),
            child: _week(context),
          ),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: CustomPaint(
                painter: StatisticsLinePainter(
                  datas: widget.datas,
                  lineColor: widget.lineColor,
                  progress: progress,
                  style: widget.animationStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _week(BuildContext context) {
    const weeks = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: weeks.length * 2 - 1,
        childAspectRatio: 1.5,
      ),
      itemBuilder: (context, index) {
        final weekIndex = index ~/ 2;
        if (index % 2 == 0 && weeks.length > weekIndex) {
          return Center(
            child: Text(weeks[weekIndex]),
          );
        }
        return Container();
      },
      itemCount: weeks.length * 2 - 1,
    );
  }
}

enum StatisticsLineAnimationStyle {
  /// 水平动画
  horizontal,

  /// 竖直方向动画
  vertical,

  /// 两个方向
  hV,
}

class StatisticsLinePainter extends CustomPainter {
  final List<double> datas;

  final ValueListenable<double> progress;

  final StatisticsLineAnimationStyle style;

  final Color lineColor;
  final double lineWith;

  StatisticsLinePainter({
    required this.datas,
    required this.progress,
    required this.lineColor,
    this.lineWith = 2,
    this.style = StatisticsLineAnimationStyle.horizontal,
  }) : super(
          repaint: progress,
        );

  late final linePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..strokeWidth = lineWith;

  double get hProgress {
    switch (style) {
      case StatisticsLineAnimationStyle.horizontal:
      case StatisticsLineAnimationStyle.hV:
        return progress.value;
      default:
        return 1;
    }
  }

  double get vProgress {
    switch (style) {
      case StatisticsLineAnimationStyle.vertical:
      case StatisticsLineAnimationStyle.hV:
        return progress.value;
      default:
        return 1;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(0, size.height);
    final progressSize = ui.Size(size.width, size.height * vProgress);
    canvas.scale(1.0, -1);
    drawRectangle(canvas, progressSize);
    drawLine(canvas, progressSize);
    canvas.restore();
  }

  Offset point(int index, Size size) {
    if (datas.isEmpty) return Offset.zero;
    final singleSpace = size.width / max(1, (datas.length - 1));
    final data = datas[index];
    return Offset(singleSpace * index, data * size.height);
  }

  ui.Path progressPath(Path path) {
    ui.PathMetrics pathMetrics = path.computeMetrics();
    final pathMetric = pathMetrics.first;
    return pathMetric.extractPath(0, pathMetric.length * hProgress);
  }

  /// 绘制渐变方块
  void drawRectangle(Canvas canvas, Size size) {
    if (datas.isEmpty) return;
    canvas.save();
    final first = point(0, size);
    final last = point(datas.length - 1, size);
    final bottomPath = Path()
      ..moveTo(first.dx, first.dy)
      ..lineTo(0, 0)
      ..relativeLineTo(size.width, 0)
      ..lineTo(last.dx, last.dy);

    var linePath = createPath(canvas, size, 1, 1);

    final clipPath = Path.combine(PathOperation.xor, bottomPath, linePath);
    canvas.clipPath(clipPath);

    final hProgressPath = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, 0)
      ..relativeLineTo(size.width * hProgress, 0)
      ..lineTo(size.width * hProgress, size.height);
    canvas.clipPath(hProgressPath);

    final singleSpace = size.width / (datas.length * 2 - 1);

    for (int i = 0; i < (datas.length * 2); i++) {
      if (i % 2 == 0) {
        canvas.drawRect(
          ui.Rect.fromLTWH(i * singleSpace, 0, singleSpace, size.height),
          Paint()
            ..style = ui.PaintingStyle.fill
            ..shader = ui.Gradient.linear(
              ui.Offset(singleSpace, size.height),
              ui.Offset(singleSpace, 0),
              [
                lineColor.withOpacity(0.5),
                Colors.white.withOpacity(0.3),
              ],
            ),
        );
      }
    }

    canvas.drawRect(
      ui.Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..style = ui.PaintingStyle.fill
        ..shader = ui.Gradient.linear(
          ui.Offset(singleSpace, size.height),
          ui.Offset(singleSpace, 0),
          [
            lineColor.withOpacity(0.5),
            Colors.white.withOpacity(0.3),
          ],
        ),
    );

    canvas.restore();
  }

  void drawLine(
    Canvas canvas,
    Size size,
  ) {
    /// 绘制深色的
    final path = createPath(canvas, size, 1, 1);
    canvas.drawPath(
      progressPath(path),
      linePaint..color = lineColor,
    );

    /// 偏移后绘制浅色的
    final otherPath = path.shift(const Offset(2, -2));
    canvas.drawPath(
      progressPath(otherPath),
      linePaint..color = lineColor.withOpacity(0.5),
    );
  }

  /// 线路径
  Path createPath(
    Canvas canvas,
    Size size,
    double vScale,
    double hScale,
  ) {
    final path = Path();

    if (datas.isEmpty) return path;

    /// 前一个
    Offset prePoint;

    for (int i = 0; i < datas.length; i++) {
      final current = point(i, size);

      if (i > 0) {
        prePoint = point(i - 1, size);
      } else {
        prePoint = current;
      }

      if (i == 0) {
        path.moveTo(current.dx, current.dy);
      } else {
        final double controlPointX = (current.dx + prePoint.dx) / 2;
        path.cubicTo(
          controlPointX,
          prePoint.dy,
          controlPointX,
          current.dy,
          current.dx,
          current.dy,
        );
      }
    }

    return path;
  }

  @override
  bool shouldRepaint(covariant StatisticsLinePainter oldDelegate) {
    return oldDelegate.datas != datas || oldDelegate.lineColor != lineColor;
  }
}
