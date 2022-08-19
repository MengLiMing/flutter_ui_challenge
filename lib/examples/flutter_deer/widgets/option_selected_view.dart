import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class OptionSelectedController {
  ValueChanged<bool>? _dismissHandler;

  void dismiss({bool animation = false}) {
    _dismissHandler?.call(animation);
  }
}

class OptionSelectedView extends StatefulWidget {
  final Widget child;
  final double top;
  final double right;
  final double radius;

  /// controller
  final OptionSelectedController controller;

  /// 箭头所在位置百分比 （0 - 1）
  final double arrowPointScale;

  /// 消失回调
  final VoidCallback onEnd;

  final Duration duration;

  final Curve curve;

  /// 箭头宽
  final Size arrowSize;

  const OptionSelectedView({
    Key? key,
    required this.child,
    required this.top,
    required this.right,
    required this.arrowPointScale,
    required this.onEnd,
    this.radius = 0,
    required this.controller,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.arrowSize = const Size(8.0, 4.0),
  }) : super(key: key);

  @override
  State<OptionSelectedView> createState() => _OptionSelectedViewState();
}

class _OptionSelectedViewState extends State<OptionSelectedView>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  late Animation<double> scale;

  /// 箭头宽
  double get arrowWidth => widget.arrowSize.width;

  /// 箭头高
  double get arrowHeight => widget.arrowSize.height;

  /// arrowPointScale 百分比为0-1，alignment 为 -1 - 1，转换一下
  double alignmentX() {
    if (widget.arrowPointScale <= 0.5) {
      return lerpDouble(-1, 0, widget.arrowPointScale * 2)!;
    } else {
      return lerpDouble(0, 1, (widget.arrowPointScale - 0.5) * 2)!;
    }
  }

  @override
  void initState() {
    super.initState();

    configController();

    animationController =
        AnimationController(vsync: this, duration: widget.duration)
          ..forward()
          ..addStatusListener((status) {
            if (status == AnimationStatus.dismissed) {
              widget.onEnd();
            }
          });

    scale = Tween<double>(begin: 0, end: 1)
        .chain(CurveTween(curve: widget.curve))
        .animate(animationController);
  }

  void configController() {
    widget.controller._dismissHandler = (animation) {
      if (animation) {
        animationController.reverse();
      } else {
        animationController.value = 0;
      }
    };
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant OptionSelectedView oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.controller._dismissHandler = null;
    configController();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => animationController.reverse(),
          child: AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return Opacity(
                opacity: animationController.value,
                child: child,
              );
            },
            child: const ColoredBox(color: Colors.black38),
          ),
        ),
        Positioned(
          right: widget.right,
          top: widget.top,
          child: AnimatedBuilder(
            animation: scale,
            builder: (context, child) {
              return Transform(
                alignment: Alignment(alignmentX(), -1),
                transform: Matrix4.diagonal3Values(
                  scale.value,
                  scale.value,
                  0,
                ),
                child: child,
              );
            },
            child: CustomPaint(
              painter: _ArrowPainter(
                arrowSize: widget.arrowSize,
                arrowPointScale: widget.arrowPointScale,
                radius: widget.radius,
              ),
              child: Padding(
                padding: EdgeInsets.only(top: arrowHeight),
                child: widget.child,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _ArrowPainter extends CustomPainter {
  final Size arrowSize;

  final double arrowPointScale;

  final double radius;

  const _ArrowPainter({
    required this.arrowSize,
    required this.arrowPointScale,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    /// 根据size计算pointScale的范围
    final minScale = (radius + arrowSize.width / 2) / size.width;
    final maxScale = 1 - minScale;
    final pointScale = min(max(minScale, arrowPointScale), maxScale);

    final rectPath = Path()
      ..addRRect(RRect.fromRectXY(
          Rect.fromLTWH(0, arrowSize.height, size.width, size.height),
          radius,
          radius));

    final arrowPath = Path()
      ..lineTo(arrowPointScale * size.width, 0)
      ..relativeLineTo(arrowSize.width / 2, arrowSize.height)
      ..relativeLineTo(-arrowSize.width, 0)
      ..relativeLineTo(arrowSize.width / 2, -arrowSize.height);

    final path = Path.combine(PathOperation.union, rectPath, arrowPath);

    canvas.drawPath(
        path,
        Paint()
          ..color = Colors.white
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant _ArrowPainter oldDelegate) {
    return oldDelegate.arrowSize != arrowSize ||
        oldDelegate.arrowPointScale != arrowPointScale ||
        oldDelegate.radius != radius;
  }
}
