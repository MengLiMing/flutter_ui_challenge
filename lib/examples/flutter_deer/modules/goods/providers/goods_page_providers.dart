import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin GoodsPageProviders {
  final goodsState = StateNotifierProvider.autoDispose<
      GoodsTypeChooseStateNotifier, GoodsTypeChooseState>((ref) {
    return GoodsTypeChooseStateNotifier();
  });

  late final unfold = Provider.autoDispose<bool>((ref) {
    return ref.watch(goodsState).unfold;
  });

  late final selectedIndex = Provider.autoDispose<int>((ref) {
    return ref.watch(goodsState).selectedIndex;
  });
}

class GoodsTypeChooseStateNotifier extends StateNotifier<GoodsTypeChooseState> {
  GoodsTypeChooseStateNotifier()
      : super(const GoodsTypeChooseState(unfold: false));

  void setSelectedIndex(int value) {
    state = state.copyWith(selectedIndex: value);
  }

  void setUnfold(bool value) {
    state = state.copyWith(unfold: value);
  }

  void autoUnfold() {
    state = state.copyWith(unfold: !state.unfold);
  }

  void setTitle(String title) {
    state = state.copyWith(title: title);
  }
}

class GoodsTypeChooseState extends Equatable {
  final bool unfold;
  final int selectedIndex;

  const GoodsTypeChooseState({
    required this.unfold,
    this.selectedIndex = 0,
  });

  GoodsTypeChooseState copyWith({
    bool? unfold,
    String? title,
    int? selectedIndex,
  }) {
    return GoodsTypeChooseState(
      unfold: unfold ?? this.unfold,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  @override
  List<Object?> get props => [unfold, selectedIndex];
}
