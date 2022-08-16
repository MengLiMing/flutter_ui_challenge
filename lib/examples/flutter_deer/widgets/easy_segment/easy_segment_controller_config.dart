import 'package:flutter/material.dart';

import 'easy_segment.dart';

class EasySegmentControllerProvider1 extends InheritedWidget {
  final EasySegmentController controller;

  const EasySegmentControllerProvider1({
    Key? key,
    required Widget child,
    required this.controller,
  }) : super(key: key, child: child);

  EasySegmentController? of(BuildContext context) {
    final controlerProvider = context
        .getElementForInheritedWidgetOfExactType<
            EasySegmentControllerProvider1>()
        ?.widget as EasySegmentControllerProvider1?;
    return controlerProvider?.controller;
  }

  @override
  bool updateShouldNotify(covariant EasySegmentControllerProvider1 oldWidget) {
    return oldWidget.controller != controller;
  }
}

mixin EasySegmentControllerProvider on StatefulWidget {
  EasySegmentController get controller;
}

mixin EasySegmentControllerConfig<T extends EasySegmentControllerProvider,
    R extends State<T>> on State<T>, SingleTickerProviderStateMixin<T> {
  Duration get duration;

  EasySegmentController get controller => widget.controller;

  late final AnimationController animationController;

  @override
  void initState() {
    SingleChildRenderObjectElement;
    animationController = AnimationController(vsync: this, duration: duration)
      ..addListener(animationHandler);

    _configController();

    super.initState();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.dispose();
      _configController();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void _configController() {
    controller.addListener(() {
      switch (controller.changeType) {
        case EasySegmentChangeType.scroll:
          scrollChanged();
          break;
        case EasySegmentChangeType.tap:
          tapChanged();
          break;
        default:
          return;
      }
    });
  }

  /// 点击切换时的动画回调
  void animationHandler();

  /// 滑动百分比回调
  void scrollChanged();

  /// 点击回调
  void tapChanged();
}
