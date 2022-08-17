part of easy_segment;

/// 本来是想提供多种动画，但是~ 起名字太难了，还好自定义很简单-,-，所以我就只实现一种抱砖引玉吧。

class CustomSegmentLineIndicator extends StatefulWidget {
  /// 请于添加指示器的顺序对应
  final int index;

  final double? bottom;
  final double? height;
  final double? top;

  /// 提供宽度 则使用固定宽度计算
  final double? width;

  final bool animation;

  final Color color;

  final double? cornerRadius;

  const CustomSegmentLineIndicator({
    Key? key,
    required this.color,
    required this.index,
    this.bottom,
    this.height = 3,
    this.width,
    this.top,
    this.animation = true,
    this.cornerRadius,
  })  : assert(top == null || bottom == null || height == null),
        super(key: key);

  @override
  State<CustomSegmentLineIndicator> createState() =>
      _CustomSegmentLineIndicatorState();
}

class _CustomSegmentLineIndicatorState extends State<CustomSegmentLineIndicator>
    with SingleTickerProviderStateMixin, EasySegmentControllerConfig {
  final Tween<double> leftTween = Tween(begin: 0, end: 0);
  final Tween<double> widthTween = Tween(begin: 0, end: 0);

  int? oldSelectedIndex;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.all(
          Radius.circular(
              max(0, widget.cornerRadius ?? (widget.height ?? 0) / 2)),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant CustomSegmentLineIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bottom != widget.bottom ||
        oldWidget.height != widget.height ||
        oldWidget.top != widget.top ||
        oldWidget.index != widget.index ||
        oldWidget.width != widget.width) {
      ServicesBinding.instance.addPostFrameCallback((timeStamp) {
        tapChanged();
      });
    }
  }

  @override
  void animationHandler() {
    final controller = this.controller;
    if (controller == null) return;
    final oldIndex = oldSelectedIndex;
    final currentData = controller.itemDatas[controller.currentIndex];
    if (currentData == null) return;

    EasySegmentItemData? oldData;

    if (oldIndex != null) {
      oldData = controller.itemDatas[oldIndex];
    }

    final fixedWidth = widget.width;

    if (oldData == null) {
      EasyIndicatorConfig config;
      if (fixedWidth != null) {
        config = EasyIndicatorConfig(
          left: currentData.center.dx - fixedWidth / 2,
          width: fixedWidth,
          bottom: widget.bottom,
          height: widget.height,
          top: widget.top,
        );
      } else {
        config = EasyIndicatorConfig(
          left: currentData.offset.dx,
          bottom: widget.bottom,
          width: currentData.size.width,
          height: widget.height,
          top: widget.top,
        );
      }
      controller.indicatorConfig(widget.index).value = config;
    } else {
      if (fixedWidth != null) {
        leftTween.begin = oldData.center.dx - fixedWidth / 2;
        leftTween.end = currentData.center.dx - fixedWidth / 2;

        widthTween.begin = fixedWidth;
        widthTween.end = fixedWidth;
      } else {
        leftTween.begin = oldData.offset.dx;
        leftTween.end = currentData.offset.dx;

        widthTween.begin = oldData.size.width;
        widthTween.end = currentData.size.width;
      }

      final left = leftTween
          .chain(CurveTween(curve: Curves.easeInOut))
          .evaluate(animationController);
      final width = widthTween
          .chain(CurveTween(curve: Curves.easeInOut))
          .evaluate(animationController);

      controller.indicatorConfig(widget.index).value = EasyIndicatorConfig(
        left: left,
        width: width,
        bottom: widget.bottom,
        height: widget.height,
        top: widget.top,
      );
    }
  }

  @override
  Duration get duration => const Duration(milliseconds: 300);

  @override
  void scrollChanged() {
    final controller = this.controller;
    if (controller == null) return;
    final leftIndex = controller.preIndex;
    final endIndex = controller.nextIndex;

    final leftData = controller.itemDatas[leftIndex];
    final rightData = controller.itemDatas[endIndex];

    if (leftData == null || rightData == null) return;
    final progress = controller.progress - leftIndex;

    if (widget.width != null) {
      if (widget.animation) {
        fixedWidthAnimation(
          lineWidth: widget.width!,
          leftData: leftData,
          rightData: rightData,
          progress: progress,
        );
      } else {
        fixedWidth(
          lineWidth: widget.width!,
          leftData: leftData,
          rightData: rightData,
          progress: progress,
        );
      }
    } else {
      if (widget.animation) {
        dynamicWidthAnimation(
            leftData: leftData, rightData: rightData, progress: progress);
      } else {
        dynamicWidth(
            leftData: leftData, rightData: rightData, progress: progress);
      }
    }
  }

  @override
  void tapChanged() {
    oldSelectedIndex = controller?.oldSelectedIndex;
    animationController.forward(from: 0);
  }
}

extension on _CustomSegmentLineIndicatorState {
  void fixedWidth({
    required double lineWidth,
    required EasySegmentItemData leftData,
    required EasySegmentItemData rightData,
    required double progress,
  }) {
    final startLeft = leftData.center.dx - lineWidth / 2;
    final endLeft = rightData.center.dx - lineWidth / 2;
    final left = lerpDouble(startLeft, endLeft, progress) ?? 0;
    controller?.indicatorConfig(widget.index).value = EasyIndicatorConfig(
      left: left,
      width: lineWidth,
      bottom: widget.bottom,
      height: widget.height,
      top: widget.top,
    );
  }

  void fixedWidthAnimation({
    required double lineWidth,
    required EasySegmentItemData leftData,
    required EasySegmentItemData rightData,
    required double progress,
  }) {
    if (progress < 0.5) {
      final startLeft = leftData.center.dx - lineWidth / 2;
      final endLeft = leftData.center.dx;
      final left = lerpDouble(startLeft, endLeft, progress * 2) ?? 0;

      final startWidth = lineWidth;
      final endWidth = rightData.center.dx - leftData.center.dx;

      final width = lerpDouble(startWidth, endWidth, progress * 2) ?? 0;

      controller?.indicatorConfig(widget.index).value = EasyIndicatorConfig(
        left: left,
        width: width,
        bottom: widget.bottom,
        height: widget.height,
        top: widget.top,
      );
    } else {
      final startLeft = leftData.center.dx;
      final endLeft = rightData.center.dx - lineWidth / 2;
      final left = lerpDouble(startLeft, endLeft, (progress - 0.5) * 2) ?? 0;

      final startWidth = rightData.center.dx - leftData.center.dx;
      final endWidth = lineWidth;

      final width = lerpDouble(startWidth, endWidth, (progress - 0.5) * 2) ?? 0;

      controller?.indicatorConfig(widget.index).value = EasyIndicatorConfig(
        left: left,
        width: width,
        bottom: widget.bottom,
        height: widget.height,
        top: widget.top,
      );
    }
  }

  void dynamicWidth({
    required EasySegmentItemData leftData,
    required EasySegmentItemData rightData,
    required double progress,
  }) {
    final startLeft = leftData.offset.dx;
    final endLeft = rightData.offset.dx;
    final left = lerpDouble(startLeft, endLeft, progress) ?? 0;

    final startWidth = leftData.size.width;
    final endWidth = rightData.size.width;

    final width = lerpDouble(startWidth, endWidth, progress) ?? 0;

    controller?.indicatorConfig(widget.index).value = EasyIndicatorConfig(
      left: left,
      width: width,
      bottom: widget.bottom,
      height: widget.height,
      top: widget.top,
    );
  }

  void dynamicWidthAnimation({
    required EasySegmentItemData leftData,
    required EasySegmentItemData rightData,
    required double progress,
  }) {
    if (progress < 0.5) {
      final startLeft = leftData.offset.dx;
      final endLeft = leftData.center.dx;
      final left = lerpDouble(startLeft, endLeft, progress * 2) ?? 0;

      final startWidth = leftData.size.width;
      final endWidth = rightData.center.dx - leftData.center.dx;
      final width = lerpDouble(startWidth, endWidth, progress * 2) ?? 0;

      controller?.indicatorConfig(widget.index).value = EasyIndicatorConfig(
        left: left,
        width: width,
        bottom: widget.bottom,
        height: widget.height,
        top: widget.top,
      );
    } else {
      final startLeft = leftData.center.dx;
      final endLeft = rightData.offset.dx;
      final left = lerpDouble(startLeft, endLeft, (progress - 0.5) * 2) ?? 0;

      final startWidth = rightData.center.dx - leftData.center.dx;
      final endWidth = rightData.size.width;
      final width = lerpDouble(startWidth, endWidth, (progress - 0.5) * 2) ?? 0;

      controller?.indicatorConfig(widget.index).value = EasyIndicatorConfig(
        left: left,
        width: width,
        bottom: widget.bottom,
        height: widget.height,
        top: widget.top,
      );
    }
  }
}
