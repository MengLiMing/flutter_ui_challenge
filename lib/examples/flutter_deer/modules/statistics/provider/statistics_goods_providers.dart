import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/statistics/models/statistics_goods_model.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/random_utils.dart';

mixin StatisticsGoodsProviders {
  final manager = StateNotifierProvider.autoDispose<
      StatisticsGoodsStateNotifier,
      StatisticsGoodsState>((ref) => StatisticsGoodsStateNotifier());

  late final style = Provider.autoDispose<StatisticsGoodsStyle>(
      (ref) => ref.watch(manager).style);

  late final itemModels = Provider.autoDispose<List<StatisticsGoodsItemModel>>(
      (ref) => ref.watch(manager).itemModels);
}

class StatisticsGoodsStateNotifier extends StateNotifier<StatisticsGoodsState> {
  StatisticsGoodsStateNotifier() : super(const StatisticsGoodsState());

  void initState() {
    state = state.copyWith(
      itemModels: randomItems(),
    );
  }

  void changeStyle(StatisticsGoodsStyle style) {
    List<StatisticsGoodsItemModel>? itemModels;
    if (style != state.style) {
      itemModels = randomItems();
    }
    state = state.copyWith(style: style, itemModels: itemModels);
  }

  List<StatisticsGoodsItemModel> randomItems() {
    return const [
      Color(0xFFFFD147),
      Color(0xFFA9DAF2),
      Color(0xFFFAAF64),
      Color(0xFF7087FA),
      Color(0xFFA0E65C),
      Color(0xFF5CE6A1),
      Color(0xFFA364FA),
      Color(0xFFDA61F2),
      Color(0xFFFA64AE),
      Color(0xFFFA6464),
    ]
        .map((e) => StatisticsGoodsItemModel(
            number: RandomUtil.number(100) + 100, color: e))
        .toList();
  }
}

class StatisticsGoodsState {
  final StatisticsGoodsStyle style;
  final List<StatisticsGoodsItemModel> itemModels;

  const StatisticsGoodsState({
    this.style = StatisticsGoodsStyle.wating,
    this.itemModels = const [],
  });

  StatisticsGoodsState copyWith({
    StatisticsGoodsStyle? style,
    List<StatisticsGoodsItemModel>? itemModels,
  }) {
    return StatisticsGoodsState(
      style: style ?? this.style,
      itemModels: itemModels ?? this.itemModels,
    );
  }

  @override
  bool operator ==(covariant StatisticsGoodsState other) {
    if (identical(this, other)) return true;

    return other.style == style && listEquals(other.itemModels, itemModels);
  }

  @override
  int get hashCode => style.hashCode ^ itemModels.hashCode;
}

enum StatisticsGoodsStyle {
  wating,
  complete,
}

extension StatisticsGoodsStyleExtension on StatisticsGoodsStyle {
  String get title => ['待配送', '已配送'][index];
}
