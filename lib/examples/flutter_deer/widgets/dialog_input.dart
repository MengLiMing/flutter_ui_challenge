import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/easy_segment/easy_segment.dart';

enum DialogInpuAlignment {
  center,
  bottom,
}

extension on DialogInpuAlignment {
  AlignmentGeometry get alignment {
    switch (this) {
      case DialogInpuAlignment.center:
        return Alignment.center;
      case DialogInpuAlignment.bottom:
        return Alignment.bottomCenter;
    }
  }
}

class DialogInput extends StatefulWidget {
  final Widget child;

  /// 弹出后距离键盘的距离 默认为0
  final double keyboardSpace;

  final DialogInpuAlignment alignment;

  const DialogInput({
    Key? key,
    required this.child,
    this.keyboardSpace = 0,
    this.alignment = DialogInpuAlignment.center,
  }) : super(key: key);

  @override
  State<DialogInput> createState() => _DialogInputState();
}

class _DialogInputState extends State<DialogInput> with WidgetsBindingObserver {
  double itemHeight = 0;
  double keyBoardHeight = 0;

  final ValueNotifier<double> bottomOffset = ValueNotifier(0);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();

    keyBoardHeight = ScreenUtils.keyboardHeight;
  }

  void dealOffset() {
    switch (widget.alignment) {
      case DialogInpuAlignment.center:
        bottomOffset.value =
            max(0, keyBoardHeight * 2 - (ScreenUtils.height - itemHeight)) +
                widget.keyboardSpace;
        break;
      case DialogInpuAlignment.bottom:
        bottomOffset.value = keyBoardHeight + widget.keyboardSpace;
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.alignment.alignment,
      child: ValueListenableBuilder<double>(
        valueListenable: bottomOffset,
        builder: (context, value, child) {
          return Padding(
            padding: EdgeInsets.only(bottom: value),
            child: child,
          );
        },
        child: LayoutAfter(
          handler: (renderBox) {
            itemHeight = renderBox.size.height;
            dealOffset();
          },
          child: widget.child,
        ),
      ),
    );
  }
}
