part of flutter_table_view;

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
    reloadSection(earyEnd: true);
  }

  void loadNextSection(int sectionIndex) {
    reloadSection(from: sectionIndex + 1, earyEnd: true);
  }

  /// 重新刷新 范围内的section 并返回rowCount, earyEnd 是否changed发生变化提前结束
  void reloadSection({
    int from = 0,
    bool earyEnd = false,
    Function(int sectionIndex)? autoRemoveZeroAction,
  }) {
    final sectionCount = dataSource.sectionCount();
    if (sectionCount == 0) {
      clear();
      return;
    }
    int lastIndex = -1;
    int changed = 0;
    int startIndex = 0;

    if (from != 0 && _sectionCountCache[from] != null) {
      startIndex = from;
      final cache = _sectionCountCache[from]!;
      lastIndex = cache.lastIndex - cache.rowCount;
    }

    Set<int> zeroSections = {};

    int sectionOffset = 0;
    for (int i = startIndex; i < sectionCount; i++) {
      final rowCount = dataSource.rowCount(i);
      final cache = _sectionCountCache[i];

      final realSectionIndex = i + sectionOffset;
      if (cache == null) {
        final newDirty = lastIndex + 1;

        if (_dirtyIndex > newDirty) {
          _dirtyIndex = newDirty;
        }
        lastIndex += rowCount;
        _sectionCountCache[realSectionIndex] = _SectionCache(
          sectionIndex: i,
          rowCount: rowCount,
          lastIndex: lastIndex,
        );

        changed += rowCount;
      } else {
        final cacheRowCount = cache.rowCount;
        final sectionRowChange = rowCount - cacheRowCount;

        final newLastIndex = cache.lastIndex + sectionRowChange;

        _sectionCountCache[realSectionIndex] = cache.copyWith(
          rowCount: rowCount,
          lastIndex: newLastIndex,
        );

        /// 当前有变化 标脏
        final newDirty = lastIndex + 1;
        if (sectionRowChange != 0 && _dirtyIndex > newDirty) {
          _dirtyIndex = newDirty;
        }

        lastIndex = newLastIndex;
        changed += sectionRowChange;
      }
      if (autoRemoveZeroAction != null && rowCount == 0) {
        sectionOffset -= 1;
        final newDirty = lastIndex + 1;

        if (_dirtyIndex > newDirty) {
          _dirtyIndex = newDirty;
        }
        zeroSections.add(i);
      }
      if (earyEnd && changed != 0) {
        break;
      }
    }
    for (final index in zeroSections) {
      autoRemoveZeroAction?.call(index);
    }

    value += changed;
    print('当前个数:$value');
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
