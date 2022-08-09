import 'package:flutter_riverpod/flutter_riverpod.dart';

class HeaderProviders {
  /// pageView切换
  static final pageIndex = StateProvider.autoDispose<int>((ref) => 0);

  static final isSelected = Provider.autoDispose.family<bool, int>((ref, arg) {
    final index = ref.watch(pageIndex);
    return index == arg;
  });

  /// header点击
  static final tapIndex = StateProvider.autoDispose<int>((ref) => 0);

  /// 滚动停止时的index
  static final stopIndex = StateProvider.autoDispose<int>((ref) => 0);
}
