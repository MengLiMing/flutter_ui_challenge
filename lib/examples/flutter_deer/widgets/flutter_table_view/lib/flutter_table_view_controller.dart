part of flutter_table_view;

class FlutterTableViewController {
  ItemScrollController? _itemScrollController;
  ItemScrollController? get itemScrollController => _itemScrollController;
  var _lock = Lock();

  ItemPositionsListener? _itemPositionsListener;
  ItemPositionsListener? get itemPositionsListener => _itemPositionsListener;

  _TableViewCountManager? _countManger;

  void _unwrapCountManager(
      void Function(_TableViewCountManager countManager) then) {
    final countManager = _countManger;
    if (countManager == null) return;
    then(countManager);
  }

  /// 数据刷新成功后调用
  void refreshSuccess() {
    _unwrapCountManager((countManager) {
      countManager
        ..clear()
        ..initLoad();
    });
  }

  /// 加载更多成功后调用
  void loadMoreSuccess() {
    _unwrapCountManager((countManager) {
      final currentIndexPath = countManager.indexPathBy(countManager.value - 1);
      if (currentIndexPath != null) {
        countManager.loadNextSection(currentIndexPath.section);
      }
    });
  }

  /// 对应sectionIndex下的数据源 改变需要调用
  void reloadSection(
    int sectionIndex, {
    Function(int sectionIndex)? removeAction,
  }) {
    _unwrapCountManager((countManager) {
      _lock.synchronized(() {
        countManager.reloadSection(
          from: sectionIndex,
          autoRemoveZeroAction: removeAction,
        );
      });
    });
  }
}
