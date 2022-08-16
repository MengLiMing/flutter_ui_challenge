// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'easy_segment.dart';

enum EasySegmentChangeType {
  /// 未改动
  none,

  /// 通过外部滑动切换 - 调用 changeProgress
  scroll,

  /// 通过点击切换 - 调用 scrollToIndex
  tap,
}

class EasySegmentController extends ChangeNotifier {
  final int initialIndex;

  double _progress = -1;

  final Map<int, EasySegmentItemData> itemDatas = {};

  double get progress => _progress;

  final Map<int, ValueNotifier<EasyIndicatorConfig>> _indicatorConfigs = {};

  ValueNotifier<EasyIndicatorConfig> indicatorConfig(int index) {
    _indicatorConfigs[index] ??= ValueNotifier(
      const EasyIndicatorConfig(left: 0, bottom: 0, width: 0, height: 0),
    );
    return _indicatorConfigs[index]!;
  }

  /// 当前下标
  int get currentIndex => _progress.round();

  EasySegmentChangeType _changeType = EasySegmentChangeType.none;

  /// 切换类型
  EasySegmentChangeType get changeType => _changeType;

  /// 滑动中的上一个坐标
  int get preIndex => _progress.truncate();

  /// 下一个坐标
  int get nextIndex => _progress.ceil();

  int? _oldSelectedIndex;

  /// 点击切换时的上一个坐标 用来外部对其做动画
  int? get oldSelectedIndex => _oldSelectedIndex;

  EasySegmentController({this.initialIndex = 0});

  /// 滚动到当前下标
  void scrollToIndex(int index) {
    if (_progress == index.toDouble()) return;
    _changeType = EasySegmentChangeType.tap;

    _oldSelectedIndex = nextIndex;
    _progress = index.toDouble();
    notifyListeners();
  }

  void changeProgress(double progress) {
    if (_progress == progress) return;
    _progress = progress;
    _changeType = EasySegmentChangeType.scroll;
    notifyListeners();
  }

  /// 标记是否滚动到初始位置
  var _hadScrollToInitialIndex = false;

  /// 标记是否校正
  var _hadCorrectInitialIndex = false;

  void _configData(int index, EasySegmentItemData data) {
    final old = itemDatas[index];
    itemDatas[index] = data;

    /// 滚动到初始位置
    if (_hadScrollToInitialIndex == false) {
      _hadScrollToInitialIndex = true;
      changeProgress(initialIndex.toDouble());
    }

    /// 测试发现滚动到初始位置 会出现size不同的情况，再次调整
    if (_hadCorrectInitialIndex == false &&
        old != null &&
        initialIndex == index &&
        old != data) {
      _hadCorrectInitialIndex = true;
      notifyListeners();
    }
  }
}

class EasySegment extends StatefulWidget {
  final double space;
  final EdgeInsets padding;
  final List<Widget> children;
  final List<Widget> indicators;
  final EasySegmentController controller;
  final ValueChanged<int>? onTap;

  const EasySegment({
    Key? key,
    this.space = 10,
    this.padding = const EdgeInsets.only(left: 10, right: 10),
    required this.controller,
    required this.children,
    this.indicators = const [],
    this.onTap,
  }) : super(key: key);

  @override
  State<EasySegment> createState() => _EasySegmentState();
}

class _EasySegmentState extends State<EasySegment>
    with SingleTickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();

  EasySegmentController get segController => widget.controller;

  Map<int, EasySegmentItemData> get itemDatas => widget.controller.itemDatas;

  late final AnimationController animationController;

  final Tween<double> progressTween = Tween(begin: 0, end: 0);

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..addListener(() {
        final offset = progressTween
            .chain(CurveTween(curve: Curves.easeInOut))
            .evaluate(animationController);
        scrollController.jumpTo(offset);
      });

    configController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    segController.dispose();
    animationController.dispose();
    super.dispose();
  }

  void configController() {
    segController.addListener(() {
      switch (segController.changeType) {
        case EasySegmentChangeType.scroll:
          toMiddle();
          break;
        case EasySegmentChangeType.tap:
          animatedToMiddle();
          break;
        default:
          break;
      }
    });
  }

  @override
  void didUpdateWidget(covariant EasySegment oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.dispose();
      configController();
    }
  }

  /// 相对于起点 停止时的偏移
  double? targetX() {
    final leftIndex = segController.preIndex;
    final rightIndex = segController.nextIndex;

    final leftData = itemDatas[leftIndex];
    final rightData = itemDatas[rightIndex];

    if (leftData == null || rightData == null) return null;

    final progress = segController.progress - leftIndex;

    final startOffset = leftData.center;
    final endOffset = rightData.center;

    final currentOffset = Offset(
        lerpDouble(startOffset.dx, endOffset.dx, progress)!,
        lerpDouble(startOffset.dy, endOffset.dy, progress)!);

    return currentOffset.dx + widget.padding.left;
  }

  /// 取相对起点的偏移 置中 - 后续可以通过不同的枚举添加滑动停止的位置
  double? toMiddleOffsetX() {
    final offsetX = targetX();
    if (scrollController.positions.isEmpty || offsetX == null) return null;

    final position = scrollController.position;
    final centerOffsetX = offsetX - position.viewportDimension / 2;
    return max(min(centerOffsetX, position.maxScrollExtent), 0);
  }

  /// 根据进度置中
  void toMiddle() {
    final result = toMiddleOffsetX();
    if (result != null) {
      scrollController.jumpTo(result);
    }
  }

  /// 点击动画置中
  void animatedToMiddle() {
    final result = toMiddleOffsetX();
    if (result != null) {
      progressTween.begin = scrollController.offset;
      progressTween.end = result;
      animationController.forward(from: 0);
    }
  }

  /// 所有item配置完成后 滚动到初始化位置
  void configCompleted() {
    if (widget.children.isEmpty ||
        widget.controller.itemDatas.length != widget.children.length) return;
    if (widget.controller._hadScrollToInitialIndex == false) {
      widget.controller._hadScrollToInitialIndex = true;
      segController.changeProgress(segController.initialIndex.toDouble());
    }
  }

  @override
  Widget build(BuildContext context) {
    return EasySegmentControllerProvider1(
      controller: widget.controller,
      child: SingleChildScrollView(
        controller: scrollController,
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(
          left: widget.padding.left,
          right: widget.padding.right,
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: widget.padding.top,
                bottom: widget.padding.bottom,
              ),
              child: Wrap(
                spacing: widget.space,
                children: [
                  for (int i = 0; i < widget.children.length; i++)
                    LayoutAfter(
                      child: GestureDetector(
                        onTap: () {
                          segController.scrollToIndex(i);
                          widget.onTap?.call(i);
                        },
                        behavior: HitTestBehavior.translucent,
                        child: widget.children[i],
                      ),
                      handler: (renderBox) {
                        final parentData =
                            renderBox.parentData as WrapParentData;
                        final offset = parentData.offset;
                        final size = renderBox.size;
                        widget.controller._configData(
                          i,
                          EasySegmentItemData(
                              size: size, index: i, offset: offset),
                        );
                      },
                    ),
                ],
              ),
            ),
            for (int i = 0; i < widget.indicators.length; i++)
              ValueListenableBuilder<EasyIndicatorConfig>(
                valueListenable: segController.indicatorConfig(i),
                builder: (context, config, child) {
                  return Positioned(
                    left: config.left,
                    width: config.width,
                    height: config.height,
                    bottom: config.bottom,
                    top: config.top,
                    child: child!,
                  );
                },
                child: widget.indicators[i],
              ),
          ],
        ),
      ),
    );
  }
}

class EasyIndicatorConfig {
  final double left;
  final double width;

  final double? bottom;
  final double? height;
  final double? top;

  const EasyIndicatorConfig({
    required this.left,
    required this.width,
    this.height,
    this.bottom,
    this.top,
  });

  @override
  bool operator ==(covariant EasyIndicatorConfig other) {
    if (identical(this, other)) return true;

    return other.left == left &&
        other.width == width &&
        other.bottom == bottom &&
        other.height == height &&
        other.top == top;
  }

  @override
  int get hashCode {
    return left.hashCode ^
        width.hashCode ^
        bottom.hashCode ^
        height.hashCode ^
        top.hashCode;
  }
}

class EasySegmentItemData {
  final Size size;
  final int index;
  final Offset offset;

  const EasySegmentItemData({
    required this.size,
    required this.index,
    required this.offset,
  });

  Offset get center =>
      Offset(offset.dx + size.width / 2, offset.dy + size.height / 2);

  @override
  bool operator ==(covariant EasySegmentItemData other) {
    if (identical(this, other)) return true;

    return other.size == size && other.index == index && other.offset == offset;
  }

  @override
  int get hashCode => size.hashCode ^ index.hashCode ^ offset.hashCode;
}
