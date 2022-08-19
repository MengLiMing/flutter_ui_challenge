// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class FlutterTableView extends StatefulWidget {
  final int sectionCount;
  final int Function(int) rowCount;

  const FlutterTableView({
    Key? key,
    required this.sectionCount,
    required this.rowCount,
  }) : super(key: key);

  @override
  State<FlutterTableView> createState() => _FlutterTableViewState();
}

class _FlutterTableViewState extends State<FlutterTableView> {
  final ItemScrollController itemScrollController = ItemScrollController();

  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  late final _TableViewCountManager countManger;

  final _TableViewDataSource dataSource = _TableViewDataSource();

  @override
  void initState() {
    super.initState();
    configDataSource();

    countManger = _TableViewCountManager(dataSource: dataSource);
    countManger.initLoad();

    itemPositionsListener.itemPositions.addListener(() {
      final value = itemPositionsListener.itemPositions.value
          .map((e) => '${e.itemLeadingEdge} - ${e.itemTrailingEdge}');
      // print(value);
    });
  }

  void configDataSource() {
    dataSource.sectionCount = widget.sectionCount;
    dataSource.rowCount = widget.rowCount;
  }

  @override
  void didUpdateWidget(covariant FlutterTableView oldWidget) {
    if (oldWidget.sectionCount != widget.sectionCount ||
        oldWidget.rowCount != widget.rowCount) {
      configDataSource();
      countManger.clear();
      countManger.initLoad();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: countManger,
      builder: (context, count, child) {
        return ScrollablePositionedList.builder(
          itemCount: count,
          itemScrollController: itemScrollController,
          itemPositionsListener: itemPositionsListener,
          itemBuilder: (context, index) {
            final indexPath = countManger.indexPathBy(index);
            if (indexPath == null) {
              return Container();
            } else {
              countManger.loadNext(indexPath);

              return ListTile(
                title: Text('$indexPath'),
              );
            }
          },
        );
      },
    );
  }
}

class IndexPath {
  final int row;
  final int section;

  const IndexPath({
    required this.row,
    required this.section,
  });

  @override
  String toString() => '($section, $row)';

  @override
  bool operator ==(covariant IndexPath other) {
    if (identical(this, other)) return true;

    return other.row == row && other.section == section;
  }

  @override
  int get hashCode => row.hashCode ^ section.hashCode;
}

class _TableViewDataSource {
  int sectionCount;

  int Function(int)? rowCount;

  _TableViewDataSource({
    this.sectionCount = 0,
    this.rowCount,
  });
}

class _TableViewCountManager extends ChangeNotifier
    implements ValueListenable<int> {
  final _TableViewDataSource dataSource;

  _TableViewCountManager({required this.dataSource});

  final Map<int, int> _sectionCountCache = {};

  final Map<int, IndexPath> _indexPathCache = {};

  @override
  int get value => _value;
  int _value = 0;
  set value(int newValue) {
    if (_value == newValue) return;
    _value = newValue;
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      notifyListeners();
    });
  }

  void clear() {
    _sectionCountCache.clear();
    _indexPathCache.clear();
    value = 0;
  }

  void initLoad() {
    /// 初始化查找section 直到结束活总数不为0 (够刷新就行， 之后再次查找由loadNext驱动)
    loadMore(value, 0);
  }

  void loadNext(IndexPath indexPath) {
    if (indexPath.section >= dataSource.sectionCount) return;

    /// 加载下一个section 直到结束 或者 总数变化就停止(有些section可能没有row)
    loadMore(value, indexPath.section + 1);
  }

  void loadMore(int oldCount, int startSectionIndex) {
    var sectionIndex = startSectionIndex;
    while (sectionIndex < dataSource.sectionCount && value == oldCount) {
      int rowCount = dataSource.rowCount?.call(sectionIndex) ?? 0;
      setRowCount(sectionIndex, rowCount);
      sectionIndex += 1;
    }
  }

  void setRowCount(int sectionIndex, int rowCount) {
    final oldRowCount = _sectionCountCache[sectionIndex];
    _sectionCountCache[sectionIndex] = rowCount;

    if (oldRowCount == null) {
      value += rowCount;
    } else {
      final countChange = rowCount - oldRowCount;
      value += countChange;
    }
  }

  IndexPath? indexPathBy(int index) {
    int rowIndex = index;
    int sectionIndex = 0;

    /// 有缓存就取缓存
    if (_indexPathCache[index] != null) {
      return _indexPathCache[index];
    }

    /// 没有缓存就依次去找
    while (sectionIndex < dataSource.sectionCount) {
      final cacheCount = _sectionCountCache[sectionIndex];
      int rowCount;
      if (cacheCount == null) {
        rowCount = dataSource.rowCount?.call(sectionIndex) ?? 0;
        _sectionCountCache[sectionIndex] = rowCount;
      } else {
        rowCount = cacheCount;
      }
      setRowCount(sectionIndex, rowCount);
      if (rowCount > rowIndex) {
        break;
      }
      rowIndex -= rowCount;
      sectionIndex += 1;
    }

    if (rowIndex >= 0 && sectionIndex >= 0) {
      return IndexPath(row: rowIndex, section: sectionIndex);
    }
    return null;
  }

  void checkNeedLoad() {}
}
