import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/easy_segment/easy_segment.dart';

class ShopInfoChooseIndicator extends StatefulWidget {
  final List<String> datas;
  final ValueChanged<int?> onChanged;

  /// 多久消失
  final Duration duration;

  const ShopInfoChooseIndicator({
    Key? key,
    required this.datas,
    required this.onChanged,
    this.duration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  State<ShopInfoChooseIndicator> createState() =>
      _ShopInfoChooseIndicatorState();
}

class _ShopInfoChooseIndicatorState extends State<ShopInfoChooseIndicator> {
  /// 总高度
  double height = 0;

  Map<String, Rect> letterRectMap = {};

  /// 1s后小时
  Timer? timer;

  @override
  void didUpdateWidget(covariant ShopInfoChooseIndicator oldWidget) {
    if (listEquals(oldWidget.datas, widget.datas) == false) {
      letterRectMap.clear();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutAfter(
        handler: (renderBox) {
          height = renderBox.size.height;
        },
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTapUp: onTapUp,
          onVerticalDragDown: onDragDown,
          onVerticalDragUpdate: onDrag,
          onVerticalDragEnd: (_) => onDragEnd(),
          onVerticalDragCancel: onDragEnd,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: widget.datas
                .map(
                  (e) => LayoutAfter(
                    handler: (renderBox) {
                      final parentData = renderBox.parentData as BoxParentData;
                      final size = renderBox.size;
                      letterRectMap[e] = parentData.offset & size;
                    },
                    child: Container(
                      alignment: Alignment.center,
                      constraints: BoxConstraints(
                        minHeight: 16.fit,
                        minWidth: double.infinity,
                      ),
                      child: Text(
                        e.split('').join('\n'),
                        style: const TextStyle(
                          height: 1.1,
                          color: Colours.textGray,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  void startTimer() {
    timer = Timer(widget.duration, () {
      widget.onChanged(null);
    });
  }

  void stopTimer() {
    timer?.cancel();
    timer = null;
  }

  void onTapUp(TapUpDetails details) {
    startTimer();
  }

  void onDragDown(DragDownDetails details) {
    stopTimer();
    final index = findLetter(details.localPosition);
    widget.onChanged(index);
  }

  void onDrag(DragUpdateDetails details) {
    stopTimer();
    final index = findLetter(details.localPosition);
    widget.onChanged(index);
  }

  void onDragEnd() {
    startTimer();
  }

  int findLetter(Offset position) {
    /// 超过上方就返回第一个
    if (position.dy < 0) {
      return 0;
    }
    for (int index = 0; index < widget.datas.length; index++) {
      final letter = widget.datas[index];
      final rect = letterRectMap[letter];

      if (rect != null) {
        final minY = rect.top;
        final maxY = rect.bottom;
        if (position.dy >= minY && position.dy <= maxY) {
          return index;
        }
      }
    }

    /// 超出下方就返回最后一个
    return widget.datas.length - 1;
  }
}
