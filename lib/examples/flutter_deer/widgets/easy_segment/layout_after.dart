import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

typedef LayoutAfterHandler = void Function(RenderBox renderBox);

class LayoutAfter extends SingleChildRenderObjectWidget {
  final LayoutAfterHandler handler;

  const LayoutAfter({
    Key? key,
    required Widget child,
    required this.handler,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    ColoredBox;
    return _RenderLayoutAfter(handler: handler);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderObject renderObject) {
    (renderObject as _RenderLayoutAfter).handler = handler;
  }
}

class _RenderLayoutAfter extends RenderProxyBoxWithHitTestBehavior {
  _RenderLayoutAfter({
    required LayoutAfterHandler handler,
  })  : _handler = handler,
        super(behavior: HitTestBehavior.opaque);

  LayoutAfterHandler _handler;
  set handler(value) {
    if (_handler == value) {
      return;
    }
    _handler = value;
    markNeedsLayout();
  }

  LayoutAfterHandler get handler => _handler;

  @override
  void performLayout() {
    super.performLayout();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _handler(this);
    });
  }
}
