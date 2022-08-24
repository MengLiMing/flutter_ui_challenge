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

  /// 加载firstSection
  void reloadData({bool isAll = false}) {
    _unwrapCountManager((countManager) {
      countManager.clear();
      if (isAll) {
        countManager.reloadSection();
      } else {
        countManager.initLoad();
      }
    });
  }

  /// 加载更多成功后调用
  void loadMoreData() {
    _unwrapCountManager((countManager) {
      if (countManager.value == 0) {
        reloadData();
      } else {
        final currentIndexPath =
            countManager.indexPathWithIndex(countManager.value - 1);
        if (currentIndexPath != null) {
          countManager.loadNextSection(currentIndexPath.section);
        }
      }
    });
  }

  /// 对应sectionIndex下的数据源 改变需要调用
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

  void jumpToSection(int section) {
    jumpTo(indexPath: IndexPath(row: 0, section: section));
  }

  void jumpTo({required IndexPath indexPath, double alignment = 0}) {
    _unwrapCountManager((countManager) {
      // countManager.reloadSection();
      final index = countManager.indexWithIndexPath(indexPath);
      final itemScrollController = _itemScrollController;
      if (index != null &&
          itemScrollController != null &&
          itemScrollController.isAttached) {
        itemScrollController.jumpTo(index: index, alignment: alignment);
      }
    });
  }

  Future<void> scrollTo({
    required IndexPath indexPath,
    double alignment = 0,
    required Duration duration,
    Curve curve = Curves.linear,
    List<double> opacityAnimationWeights = const [40, 20, 40],
  }) async {
    _unwrapCountManager((countManager) async {
      // countManager.reloadSection();
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
