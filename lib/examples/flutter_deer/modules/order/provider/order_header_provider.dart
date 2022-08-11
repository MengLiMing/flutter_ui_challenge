import 'package:flutter_riverpod/flutter_riverpod.dart';

class HeaderProviders {
  static List<Override> get overrides => [
        pageIndex.overrideWithValue(StateController(0)),
        tapIndex.overrideWithValue(StateController(0)),
        stopIndex.overrideWithValue(StateController(0)),
      ];

  /// pageView切换
  static final pageIndex = StateProvider<int>((ref) => 0);

  static final isSelected = Provider.family<bool, int>((ref, arg) {
    final index = ref.watch(pageIndex);
    return index == arg;
  }, dependencies: [pageIndex]);

  /// header点击
  static final tapIndex = StateProvider<int>((ref) => 0);

  /// 滚动停止时的index
  static final stopIndex = StateProvider<int>((ref) => 0);
}
