import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MenuFilter extends StatefulWidget {
  final Color bgColor;
  final double contentHeight;

  final WidgetBuilder builder;

  final Duration duration;
  final Curve curve;

  final bool isShow;
  final VoidCallback onDismiss;

  const MenuFilter({
    Key? key,
    this.bgColor = Colors.black38,
    required this.contentHeight,
    required this.builder,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    required this.isShow,
    required this.onDismiss,
  }) : super(key: key);

  @override
  State<MenuFilter> createState() => _MenuFilterState();
}

class _MenuFilterState extends State<MenuFilter> with TickerProviderStateMixin {
  late AnimationController animationController;

  late Animation<double> opacity;

  late Animation<double> heightAnimation;

  late AnimationController heightAnimationController;

  late Animation<double> heightChangedAnimation;

  @override
  void initState() {
    super.initState();

    heightAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    heightChangedAnimation =
        Tween<double>(begin: 0, end: 0).animate(heightAnimationController);

    resetAnimationController();
    resetHeightAnimation();
  }

  void resetAnimationController() {
    animationController =
        AnimationController(vsync: this, duration: widget.duration);
    opacity =
        CurvedAnimation(parent: animationController, curve: Curves.linear);
  }

  void resetHeightAnimation() {
    heightAnimation = Tween(begin: 0.0, end: widget.contentHeight)
        .chain(CurveTween(curve: widget.curve))
        .animate(animationController);
  }

  @override
  void didUpdateWidget(covariant MenuFilter oldWidget) {
    if (oldWidget.duration != widget.duration) {
      final oldValue = animationController.value;
      resetAnimationController();
      resetHeightAnimation();
      animationController.value = oldValue;
    }

    if (oldWidget.contentHeight != widget.contentHeight ||
        oldWidget.curve != widget.curve) {
      resetHeightAnimation();
    }
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isShow != widget.isShow) {
      widget.isShow ? show() : dismiss();
    }

    /// 某些场景 调整高度 提供动画
    /// 比如： 多个筛选弹窗 - 可共用一个 高度改变 动画，比直接重新弹出要好
    if (widget.isShow &&
        animationController.value == 1 &&
        oldWidget.contentHeight != widget.contentHeight) {
      ServicesBinding.instance?.addPostFrameCallback((timeStamp) {
        startHeightAnimation(oldWidget.contentHeight - widget.contentHeight);
      });
    } else {
      startHeightAnimation(0);
    }
  }

  @override
  void dispose() {
    heightAnimationController.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              onTap: () {
                widget.onDismiss();
                dismiss();
              },
              child: AnimatedBuilder(
                animation: opacity,
                builder: (context, child) {
                  return IgnorePointer(
                    ignoring: opacity.value == 0,
                    child: Opacity(
                      opacity: opacity.value,
                      child: child,
                    ),
                  );
                },
                child: ColoredBox(
                  color: widget.bgColor,
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: heightChangedAnimation,
                builder: (context, child) {
                  return AnimatedBuilder(
                    animation: heightAnimation,
                    builder: (context, _) {
                      return Container(
                        color: Colors.white,
                        height: max(
                            0,
                            heightAnimation.value +
                                heightChangedAnimation.value),
                        child: child,
                      );
                    },
                  );
                },
                child: widget.builder(context),
              ),
            ),
          ],
        );
      },
    );
  }

  void startHeightAnimation(double offset) {
    heightChangedAnimation = Tween<double>(begin: offset, end: 0)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(heightAnimationController);
    if (offset == 0) {
      stopHeightAnimation();
    } else {
      heightAnimationController.forward(from: 0);
    }
  }

  void stopHeightAnimation() {
    heightAnimationController.stop();
    heightAnimationController.value = 1;
  }

  void dismiss() {
    stopHeightAnimation();
    animationController.reverse();
  }

  void show() {
    stopHeightAnimation();
    animationController.forward();
  }
}
