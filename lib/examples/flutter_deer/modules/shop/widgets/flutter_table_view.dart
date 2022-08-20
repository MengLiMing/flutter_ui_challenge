// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class FlutterTableViewController {
  ItemScrollController? _itemScrollController;
  ItemScrollController? get itemScrollController => _itemScrollController;

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
        countManager.loadMore(countManager.value, currentIndexPath.section);
      }
    });
  }

  /// 对应sectionIndex下的数据源 改变需要调用
  void dataChangeWithSection(
    int sectionIndex, {
    required int rowCount,
    Function(int sectionIndex)? removeSection,
  }) {
    _unwrapCountManager((countManager) {
      if (removeSection != null && rowCount <= 0) {
        removeSection(sectionIndex);
        countManager.removeSection(sectionIndex);
      } else {
        countManager.setRowCount(
          sectionIndex,
          rowCount: rowCount,
        );
      }
    });
  }
}

class FlutterTableView extends StatefulWidget {
  final int Function() sectionCount;
  final int Function(int) rowCount;
  final FlutterTableViewController controller;
  final Widget Function(BuildContext context, IndexPath indexPath) itemBuilder;

  const FlutterTableView({
    Key? key,
    required this.sectionCount,
    required this.rowCount,
    required this.controller,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  State<FlutterTableView> createState() => _FlutterTableViewState();
}

class _FlutterTableViewState extends State<FlutterTableView> {
  final ItemScrollController itemScrollController = ItemScrollController();

  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  late final _TableViewCountManager countManger;

  late final _TableViewDataSource dataSource;

  @override
  void initState() {
    super.initState();
    dataSource = _TableViewDataSource();
    countManger = _TableViewCountManager(dataSource: dataSource);

    configDataSource();

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
    widget.controller
      .._countManger = countManger
      .._itemPositionsListener = itemPositionsListener
      .._itemScrollController = itemScrollController;
  }

  @override
  void didUpdateWidget(covariant FlutterTableView oldWidget) {
    configDataSource();

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    countManger.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: countManger,
      builder: (context, count, child) {
        return ScrollablePositionedList.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: count,
          itemScrollController: itemScrollController,
          itemPositionsListener: itemPositionsListener,
          itemBuilder: (context, index) {
            final indexPath = countManger.indexPathBy(index);
            if (indexPath == null) {
              return Container();
            } else {
              countManger.loadNext(indexPath);

              return widget.itemBuilder(context, indexPath);
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

class _SectionCache {
  final int sectionIndex;

  /// 当前section row的个数
  final int rowCount;

  /// 当前section最后一个对应的 下标
  final int lastIndex;

  const _SectionCache(
      {required this.sectionIndex,
      required this.rowCount,
      required this.lastIndex});

  _SectionCache copyWith({
    int? sectionIndex,
    int? rowCount,
    int? lastIndex,
  }) {
    return _SectionCache(
      sectionIndex: sectionIndex ?? this.sectionIndex,
      rowCount: rowCount ?? this.rowCount,
      lastIndex: lastIndex ?? this.lastIndex,
    );
  }
}

class _TableViewDataSource {
  late int Function() sectionCount;

  late int Function(int) rowCount;

  _TableViewDataSource();
}

class _TableViewCountManager extends ChangeNotifier
    implements ValueListenable<int> {
  final _TableViewDataSource dataSource;

  _TableViewCountManager({required this.dataSource});

  /// 记录分区
  Map<int, _SectionCache> _sectionCountCache = {};

  /// 记录index对应的path
  final Map<int, IndexPath> _indexPathCache = {};

  /// 删除或者添加变动时，标记dirtyIndex及之后的indexPath缓存不可用需要重新获取设置
  int _dirtyIndex = -1;

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
    _dirtyIndex = -1;
  }

  void initLoad() {
    /// 初始化查找section 直到结束活总数不为0 (够刷新就行， 之后再次查找由loadNext驱动)
    loadMore(value, 0);
  }

  void loadNext(IndexPath indexPath) {
    /// 加载下一个section 直到结束 或者 总数变化就停止(有些section可能没有row)
    loadMore(value, indexPath.section + 1);
  }

  void loadMore(int oldCount, int startSectionIndex) {
    final sectionCount = dataSource.sectionCount();

    var sectionIndex = startSectionIndex;
    if (sectionIndex >= sectionCount) return;

    while (sectionIndex < sectionCount && value == oldCount) {
      final cache = _sectionCountCache[sectionIndex];
      if (cache != null && cache.rowCount != 0) {
        break;
      }
      int rowCount = dataSource.rowCount(sectionIndex);
      setRowCount(sectionIndex, rowCount: rowCount);
      sectionIndex += 1;
    }
  }

  /// 清空当前section的数据
  void removeSection(int sectionIndex) {
    final oldRowCount = _sectionCountCache[sectionIndex]?.rowCount ?? 0;

    Map<int, _SectionCache> sectionCountCache = {};
    _sectionCountCache.forEach((section, cache) {
      if (section < sectionIndex) {
        sectionCountCache[section] = cache;
      } else if (section > sectionIndex) {
        final newCache = cache.copyWith(
          sectionIndex: section - 1,
          lastIndex: cache.lastIndex - oldRowCount,
        );
        sectionCountCache[section - 1] = newCache;
      } else {
        _dirtyIndex = cache.lastIndex - cache.rowCount + 1;
      }
    });
    _sectionCountCache = sectionCountCache;

    value -= oldRowCount;
  }

  /// 重置section的数量
  /// rowCount： null 重新获取
  /// autoRemoveSection: 为true时，当前section的数量为0时自动删除section
  void setRowCount(int sectionIndex, {int? rowCount}) {
    final oldCache = _sectionCountCache[sectionIndex];

    final newCount = rowCount ?? dataSource.rowCount(sectionIndex);
    if (oldCache == null) {
      int startSection = 0;
      int lastIndex = -1;
      while (startSection < sectionIndex) {
        final count = dataSource.rowCount(startSection);
        lastIndex += count;
        startSection += 1;
      }
      final newSection = _SectionCache(
        sectionIndex: sectionIndex,
        rowCount: newCount,
        lastIndex: lastIndex + newCount,
      );
      _sectionCountCache[sectionIndex] = newSection;

      _dirtyIndex = newSection.lastIndex + 1;
      value += newCount;
    } else {
      final countChange = newCount - oldCache.rowCount;
      final newSectionCache = oldCache.copyWith(
        sectionIndex: sectionIndex,
        rowCount: newCount,
        lastIndex: oldCache.lastIndex + countChange,
      );
      _sectionCountCache[sectionIndex] = newSectionCache;
      _dirtyIndex = min(oldCache.lastIndex, newSectionCache.lastIndex) + 1;

      value += countChange;
    }
  }

  IndexPath? indexPathBy(int index) {
    /// 标脏之后的index不可信，需要重新获取 有缓存就取缓存
    if (index < _dirtyIndex && _indexPathCache[index] != null) {
      return _indexPathCache[index];
    }

    /// 正常滑动加载的过程中，可以取前一个indexPath使用
    final preIndexPath = _indexPathCache[index - 1];

    _SectionCache? preSectionCache;
    if ((index - 1) < _dirtyIndex && preIndexPath != null) {
      final preSection = preIndexPath.section;
      preSectionCache = _sectionCountCache[preSection];
    }

    final result = indexPathByPreSectionCache(preSectionCache, index);
    if (result != null) {
      _dirtyIndex = index + 1;
      _indexPathCache[index] = result;
      return result;
    }

    return null;
  }

  IndexPath? indexPathByPreSectionCache(
      _SectionCache? preSectionCache, int index) {
    int lastIndex = preSectionCache?.lastIndex ?? -1;
    if (lastIndex >= index) {
      return IndexPath(
          row: preSectionCache!.rowCount - (lastIndex - index) - 1,
          section: preSectionCache.sectionIndex);
    }
    IndexPath? result;

    int startSection = (preSectionCache?.sectionIndex ?? -1) + 1;
    while (startSection < dataSource.sectionCount()) {
      final rowCount = dataSource.rowCount(startSection);
      if ((lastIndex + rowCount) >= index) {
        result = IndexPath(row: index - lastIndex - 1, section: startSection);
        _sectionCountCache[startSection] = _SectionCache(
          sectionIndex: startSection,
          rowCount: rowCount,
          lastIndex: lastIndex + rowCount,
        );
        break;
      }
      lastIndex += rowCount;
      startSection += 1;
    }
    return result;
  }
}
