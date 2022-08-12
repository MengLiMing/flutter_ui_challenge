import 'dart:ui';

import 'package:flutter/material.dart';

class OptionSelectedController {
  VoidCallback? _dismissHandler;

  void dismiss() {
    _dismissHandler?.call();
  }
}

/// 没有封装完 只是完成ui效果
class OptionSelectedView extends StatefulWidget {
  final Widget child;
  final double width;
  final double top;
  final double right;

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
    required this.width,
    required this.child,
    required this.top,
    required this.right,
    required this.arrowPointScale,
    required this.onEnd,
    required this.controller,
    this.duration = const Duration(milliseconds: 500),
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
    widget.controller._dismissHandler = () {
      animationController.reverse();
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
    /// 计算剩余宽度
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
          width: widget.width,
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

// class _ArrowPainter extends CustomPainter {
//   final Size arrowSize;

//   final Scal

//   @override
//   void paint(Canvas canvas, Size size) {}

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     // TODO: implement shouldRepaint
//     throw UnimplementedError();
//   }
// }
