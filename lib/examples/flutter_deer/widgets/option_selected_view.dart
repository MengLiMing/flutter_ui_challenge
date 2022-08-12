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
  final OptionSelectedController controller;

  /// 箭头所在位置百分比 （0 - 1）
  final double arrowPointScale;
  final VoidCallback onEnd;

  const OptionSelectedView({
    Key? key,
    required this.width,
    required this.child,
    required this.top,
    required this.right,
    required this.arrowPointScale,
    required this.onEnd,
    required this.controller,
  }) : super(key: key);

  @override
  State<OptionSelectedView> createState() => _OptionSelectedViewState();
}

class _OptionSelectedViewState extends State<OptionSelectedView>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  late Animation<double> scale;

  /// 箭头宽
  double get arrowWidth => 8;

  /// 箭头高
  double get arrowHeight => 4;

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

    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500))
      ..forward()
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          widget.onEnd();
        }
      });

    scale = Tween<double>(begin: 0, end: 1)
        .chain(CurveTween(curve: Curves.easeInOut))
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
                child: CustomPaint(
                  child: child,
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.only(top: arrowHeight),
              child: widget.child,
            ),
          ),
        )
      ],
    );
  }
}
