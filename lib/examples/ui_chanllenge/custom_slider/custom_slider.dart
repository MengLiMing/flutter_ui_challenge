import 'dart:math';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomSlider extends LeafRenderObjectWidget {
  final Color barColor;

  final Color thumbColor;

  final double thumbSize;

  final double barHeight;

  final ValueChanged<double>? progressChanged;

  final double progress;

  const CustomSlider({
    Key? key,
    this.barColor = Colors.blue,
    this.thumbColor = Colors.red,
    this.thumbSize = 20,
    this.barHeight = 5,
    this.progressChanged,
    this.progress = 0,
  }) : super(key: key);

  @override
  RenderCustomSlider createRenderObject(BuildContext context) {
    return RenderCustomSlider(
      barColor: barColor,
      thumbColor: thumbColor,
      thumbSize: thumbSize,
      barHeight: barHeight,
      progress: progress,
      progressChanged: progressChanged,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderCustomSlider renderObject,
  ) {
    renderObject
      ..barColor = barColor
      ..thumbColor = thumbColor
      ..thumbSize = thumbSize
      ..barHeight = barHeight
      ..progress = progress
      ..progressChanged = progressChanged;
  }
}

class RenderCustomSlider extends RenderBox implements HitTestTarget {
  ValueChanged<double>? progressChanged;

  RenderCustomSlider({
    required Color barColor,
    required Color thumbColor,
    required double thumbSize,
    required double barHeight,
    this.progressChanged,
    required double progress,
  })  : _barColor = barColor,
        _thumbColor = thumbColor,
        _thumbSize = thumbSize,
        _barHeight = barHeight,
        _progress = progress {
    _drag = HorizontalDragGestureRecognizer()
      ..onStart = (details) {
        _updateThumbPosition(details.localPosition);
      }
      ..onUpdate = (details) {
        _updateThumbPosition(details.localPosition);
      };
  }

  double _progress = 0;
  set progress(double value) {
    if (_progress == value) return;
    _progress = value;
    progressChanged?.call(_progress);

    markNeedsPaint();
  }

  void _updateThumbPosition(Offset localPosition) {
    var dx = localPosition.dx.clamp(0, size.width);
    progress = (dx / size.width).clamp(0, 1);
  }

  bool isTappedThumb(Offset localPosition) {
    double dx = localPosition.dx.clamp(0, size.width);
    double dy = localPosition.dy.clamp(0, size.height);

    final thumbX = lerpDouble(0, size.width - thumbSize, _progress) ?? 0;
    var thumbRect = Offset(thumbX, (size.height - thumbSize) / 2) &
        Size(thumbSize, thumbSize);

    /// 扩大10点击区域
    thumbRect = thumbRect.inflate(10);

    return thumbRect.contains(Offset(dx, dy));
  }

  late HorizontalDragGestureRecognizer _drag;

  Color _barColor;
  Color get barColor => _barColor;
  set barColor(Color value) {
    if (_barColor == value) return;
    _barColor = value;
    markNeedsPaint();
  }

  Color _thumbColor;
  Color get thumbColor => _thumbColor;
  set thumbColor(Color value) {
    if (_thumbColor == value) return;
    _thumbColor = value;
    markNeedsPaint();
  }

  double _thumbSize;
  double get thumbSize => _thumbSize;
  set thumbSize(double size) {
    if (_thumbSize == size) return;
    _thumbSize = size;
    markNeedsLayout();
  }

  double _barHeight;
  double get barHeight => _barHeight;
  set barHeight(double value) {
    if (_barHeight == value) return;
    _barHeight = value;
    markNeedsLayout();
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final barWidth = constraints.maxWidth;
    final barHeight = thumbSize;
    final size = Size(barWidth, barHeight);
    return constraints.constrain(size);
  }

  @override
  void performLayout() {
    size = computeDryLayout(constraints);
  }

  @override
  bool get isRepaintBoundary => true;

  static const double _minDesireWidth = 100;

  @override
  double computeMinIntrinsicWidth(double height) => _minDesireWidth;

  @override
  double computeMaxIntrinsicWidth(double height) => _minDesireWidth;

  @override
  double computeMaxIntrinsicHeight(double width) => max(thumbSize, barHeight);

  @override
  double computeMinIntrinsicHeight(double width) => max(thumbSize, barHeight);

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, HitTestEntry<HitTestTarget> entry) {
    debugHandleEvent(event, entry);
    if (event is PointerDownEvent) {
      /// 判断落点是否在指示器上
      if (!isTappedThumb(event.localPosition)) return;

      _drag.addPointer(event);
    }
  }

  /// 进行绘制
  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    final barPaint = Paint()
      ..color = barColor
      ..strokeWidth = barHeight;
    final barStartPoint = Offset(0, size.height / 2);
    final barEndPoint = Offset(size.width, size.height / 2);
    canvas.drawLine(barStartPoint, barEndPoint, barPaint);

    final thumbPaint = Paint()..color = thumbColor;
    final center = Offset(
        lerpDouble(thumbSize / 2, size.width - thumbSize / 2, _progress)!,
        size.height / 2);
    canvas.drawCircle(center, thumbSize / 2, thumbPaint);
  }
}
