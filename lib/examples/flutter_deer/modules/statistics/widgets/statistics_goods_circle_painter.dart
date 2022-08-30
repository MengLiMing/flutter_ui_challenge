import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class StatisticsGoodsCircleItem extends Equatable {
  final double scale;
  final Color color;

  const StatisticsGoodsCircleItem({
    required this.scale,
    required this.color,
  });

  @override
  List<Object?> get props => [scale, color];
}

enum StatisticsGoodsCircleAnimationStyle {
  /// 单个scale变化
  scale,

  /// 整体裁剪
  clip,
}

class StatisticsGoodsCirclePainter extends CustomPainter {
  final List<StatisticsGoodsCircleItem> items;
  final ValueListenable<double> progress;
  final StatisticsGoodsCircleAnimationStyle style;
  StatisticsGoodsCirclePainter({
    required this.items,
    required this.progress,
    this.style = StatisticsGoodsCircleAnimationStyle.scale,
  }) : super(repaint: progress);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    drawBackGround(canvas, size);
    drawData(canvas, size);
    drawForeground(canvas, size);
    canvas.restore();
  }

  final ringScale = 0.96;
  final foregroundBigScale = 0.55;
  final foregroundSmlScale = 0.5;
  final startAngle = -pi;

  double get scaleProgress {
    switch (style) {
      case StatisticsGoodsCircleAnimationStyle.scale:
        return progress.value;
      default:
        return 1;
    }
  }

  double get clipProgress {
    switch (style) {
      case StatisticsGoodsCircleAnimationStyle.clip:
        return progress.value;
      default:
        return 1;
    }
  }

  void drawData(Canvas canvas, Size size) {
    canvas.save();

    final radius = min(size.width / 2, size.height / 2) * ringScale;

    final rect = Rect.fromCenter(
      center: Offset.zero,
      width: radius * 2,
      height: radius * 2,
    );

    if (clipProgress != 1) {
      // 整体裁剪
      final path = Path()
        ..moveTo(0, 0)
        ..relativeLineTo(-radius, 0)
        ..arcTo(
          rect,
          startAngle,
          2 * pi * clipProgress,
          false,
        )
        ..close();

      canvas.clipPath(path);
    }

    double startScale = 0;
    for (final item in items) {
      final scale = item.scale * scaleProgress;
      canvas.drawArc(
        rect,
        startScale * pi * 2 + startAngle,
        scale * pi * 2,
        true,
        Paint()..color = item.color,
      );
      startScale += scale;
    }

    canvas.restore();
  }

  /// 绘制覆盖层
  void drawForeground(Canvas canvas, Size size) {
    final minSide = min(size.width / 2, size.height / 2);
    canvas.drawCircle(Offset.zero, minSide * foregroundBigScale,
        Paint()..color = Colors.white.withOpacity(0.3));

    canvas.drawCircle(Offset.zero, minSide * foregroundSmlScale,
        Paint()..color = Colors.white);
  }

  /// 绘制背景
  void drawBackGround(Canvas canvas, Size size) {
    final radius = min(size.width / 2, size.height / 2);

    Path path = Path()
      ..addOval(Rect.fromCenter(
          center: Offset.zero, width: radius * 2, height: radius * 2));

    canvas.drawShadow(path.shift(const Offset(0, -2)),
        const Color(0x80C8DAFA).withOpacity(0.5), 4, false);
    canvas.drawPath(path, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant StatisticsGoodsCirclePainter oldDelegate) {
    return listEquals(oldDelegate.items, items) == false;
  }
}
