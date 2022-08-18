part of easy_segment;

enum EasySegmentChangeType {
  /// 未改动
  none,

  /// 通过外部滑动切换 - 调用 changeProgress
  scroll,

  /// 通过点击切换 - 调用 scrollToIndex
  tap,
}

class EasySegmentController extends ChangeNotifier {
  int _initialIndex;

  int _maxNumber = 0;

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

  EasySegmentController({int initialIndex = 0}) : _initialIndex = initialIndex;

  /// 重置
  void resetInitialIndex(int index) {
    if (index >= _maxNumber || index < 0) return;

    _initialIndex = index;
    _changeType = EasySegmentChangeType.tap;

    if (currentIndex < _maxNumber && currentIndex >= 0) {
      _oldSelectedIndex = currentIndex;
    } else {
      _oldSelectedIndex = null;
    }
    _progress = index.toDouble();
    notifyListeners();
  }

  /// 滚动到当前下标
  void scrollToIndex(int index) {
    if (index >= _maxNumber || index < 0) return;
    if (_progress == index.toDouble()) return;
    _changeType = EasySegmentChangeType.tap;

    _oldSelectedIndex = nextIndex;
    _progress = index.toDouble();
    notifyListeners();
  }

  void changeProgress(double progress) {
    if (progress >= _maxNumber || progress < 0) return;
    if (_progress == progress) return;
    _progress = progress;
    _changeType = EasySegmentChangeType.scroll;
    notifyListeners();
  }

  /// 标记是否滚动到初始位置
  var _hadScrollToInitialIndex = false;

  void _configData(int index, EasySegmentItemData data) {
    final old = itemDatas[index];
    itemDatas[index] = data;

    /// 滚动到初始位置
    if (_hadScrollToInitialIndex == false) {
      _hadScrollToInitialIndex = true;
      resetInitialIndex(_initialIndex);
    }
  }
}

class EasySegmentControllerProvider extends InheritedWidget {
  final EasySegmentController controller;

  const EasySegmentControllerProvider({
    Key? key,
    required Widget child,
    required this.controller,
  }) : super(key: key, child: child);

  static EasySegmentController? of(BuildContext context) {
    final controlerProvider = context
        .getElementForInheritedWidgetOfExactType<
            EasySegmentControllerProvider>()
        ?.widget as EasySegmentControllerProvider?;
    return controlerProvider?.controller;
  }

  @override
  bool updateShouldNotify(covariant EasySegmentControllerProvider oldWidget) {
    return oldWidget.controller != controller;
  }
}

mixin EasySegmentControllerConfig<T extends StatefulWidget, R extends State<T>>
    on State<T>, SingleTickerProviderStateMixin<T> {
  Duration get duration;

  EasySegmentController? get controller {
    if (mounted) {
      return EasySegmentControllerProvider.of(context);
    }
    return null;
  }

  late final AnimationController animationController;

  @override
  void initState() {
    SingleChildRenderObjectElement;
    animationController = AnimationController(vsync: this, duration: duration)
      ..addListener(animationHandler);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _configController();

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    animationController.dispose();
    controller?.removeListener(_segControllerListener);
    super.dispose();
  }

  void _configController() {
    controller?.removeListener(_segControllerListener);
    controller?.addListener(_segControllerListener);
  }

  void _segControllerListener() {
    final controller = this.controller;
    if (controller == null) return;
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
  }

  /// 点击切换时的动画回调
  void animationHandler();

  /// 滑动百分比回调
  void scrollChanged();

  /// 点击回调
  void tapChanged();
}
