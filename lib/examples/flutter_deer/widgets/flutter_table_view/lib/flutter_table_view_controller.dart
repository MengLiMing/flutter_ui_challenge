part of flutter_table_view;

class FlutterTableViewController {
  ItemScrollController? _itemScrollController;
  ItemScrollController? get itemScrollController => _itemScrollController;
  final _lock = Lock();

  ItemPositionsListener? _itemPositionsListener;
  ItemPositionsListener? get itemPositionsListener => _itemPositionsListener;

  _TableViewCountManager? _countManger;

  Future<void> _unwrapCountManager(
      void Function(_TableViewCountManager countManager) then) async {
    final countManager = _countManger;
    if (countManager == null) return;
    await _lock.synchronized(() {
      then(countManager);
    });
  }

  /// 首次加载数据使用
  void reloadData() {
    _unwrapCountManager((countManager) {
      countManager.clear();
      countManager.reloadSection();
    });
  }

  /// 加载更多数据之后使用
  void loadMoreData() {
    _unwrapCountManager((countManager) {
      if (countManager.value == 0) {
        reloadData();
      } else {
        final currentIndexPath =
            countManager.indexPathWithIndex(countManager.value - 1);
        if (currentIndexPath != null) {
          countManager.reloadSection(from: currentIndexPath.section + 1);
        }
      }
    });
  }

  /// 在对应section删除或者添加后 调用
  void reloadSection(
    int sectionIndex, {
    Function(int sectionIndex)? removeAction,
  }) {
    _unwrapCountManager((countManager) {
      countManager.reloadSection(
        from: sectionIndex,
        autoRemoveZeroAction: removeAction,
      );
    });
  }

  void jumpToSection(int section, {double alignment = 0}) {
    jumpTo(
        indexPath: IndexPath(row: 0, section: section), alignment: alignment);
  }

  void jumpTo({required IndexPath indexPath, double alignment = 0}) {
    _unwrapCountManager((countManager) {
      final index = countManager.indexWithIndexPath(indexPath);
      final itemScrollController = _itemScrollController;
      if (index != null &&
          itemScrollController != null &&
          itemScrollController.isAttached) {
        itemScrollController.jumpTo(index: index, alignment: alignment);
      }
    });
  }

  Future<void> scrollToSection(
    int section, {
    double alignment = 0,
    required Duration duration,
    Curve curve = Curves.linear,
    List<double> opacityAnimationWeights = const [40, 20, 40],
  }) async {
    return scrollTo(
      indexPath: IndexPath(row: 0, section: section),
      duration: duration,
      alignment: alignment,
      curve: curve,
      opacityAnimationWeights: opacityAnimationWeights,
    );
  }

  Future<void> scrollTo({
    required IndexPath indexPath,
    double alignment = 0,
    required Duration duration,
    Curve curve = Curves.linear,
    List<double> opacityAnimationWeights = const [40, 20, 40],
  }) async {
    _unwrapCountManager((countManager) async {
      final index = countManager.indexWithIndexPath(indexPath);
      final itemScrollController = _itemScrollController;
      if (index != null &&
          itemScrollController != null &&
          itemScrollController.isAttached) {
        await itemScrollController.scrollTo(
          index: index,
          duration: duration,
          alignment: alignment,
          opacityAnimationWeights: opacityAnimationWeights,
        );
      }
    });
  }
}
