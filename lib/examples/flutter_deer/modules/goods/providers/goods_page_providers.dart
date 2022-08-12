import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin GoodsPageProviders {
  final goodType = StateNotifierProvider.autoDispose<
      GoodsTypeChooseStateNotifier, GoodsTypeChooseState>((ref) {
    return GoodsTypeChooseStateNotifier();
  });

  late final isShow = Provider.autoDispose<bool>((ref) {
    return ref.watch(goodType).unfold;
  });
}

class GoodsTypeChooseStateNotifier extends StateNotifier<GoodsTypeChooseState> {
  GoodsTypeChooseStateNotifier()
      : super(const GoodsTypeChooseState(unfold: false, title: '全部商品'));

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
  final String title;

  const GoodsTypeChooseState({
    required this.unfold,
    required this.title,
  });

  GoodsTypeChooseState copyWith({
    bool? unfold,
    String? title,
  }) {
    return GoodsTypeChooseState(
      unfold: unfold ?? this.unfold,
      title: title ?? this.title,
    );
  }

  @override
  List<Object?> get props => [unfold, title];
}