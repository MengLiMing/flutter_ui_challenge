// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/goods/models/goods_type_model/goods_type_model.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/random_utils.dart';

mixin GoodsTypeChooseProviders {
  final typeManager = StateNotifierProvider.autoDispose<
      GoodsTypeChooseStateNotifier,
      GoodsTypeChooseState>((ref) => GoodsTypeChooseStateNotifier());

  /// segmentTitle
  late final segmentTitles = Provider.autoDispose<List<String>>((ref) {
    final state = ref.watch(typeManager);
    var choosed = state.choosed.map((e) => e.name!).toList();
    if (state.hasNext) {
      choosed.add('请选择');
    }
    return choosed;
  }, dependencies: [typeManager]);

  /// segmentIndex
  late final segmentIndex = Provider.autoDispose<int>((ref) {
    return ref.watch(typeManager).segmentIndex;
  }, dependencies: [typeManager]);

  /// 当前数据
  late final datas = Provider.autoDispose<List<GoodsTypeModel>>((ref) {
    return ref.watch(typeManager).datas;
  }, dependencies: [typeManager]);

  /// 是否正在刷新
  late final isLoading = Provider.autoDispose<bool>((ref) {
    return ref.watch(typeManager).isLoading;
  }, dependencies: [typeManager]);

  /// 当前选择
  late final choosed =
      Provider.autoDispose.family<GoodsTypeModel?, int>((ref, arg) {
    final choosed = ref.watch(typeManager).choosed;
    if (choosed.length > arg && arg >= 0) {
      return choosed[arg];
    }
    return null;
  }, dependencies: [typeManager]);

  late final closeAction = Provider.autoDispose<int>((ref) {
    return ref.watch(typeManager).tag;
  }, dependencies: [typeManager]);
}

class GoodsTypeChooseStateNotifier extends StateNotifier<GoodsTypeChooseState> {
  GoodsTypeChooseStateNotifier() : super(GoodsTypeChooseState());
  List<GoodsTypeModel> _dataSource = [];

  final Map<GoodsTypeModel, List<GoodsTypeModel>> _allDataSource = {};

  int get segmentIndex => state.segmentIndex;

  /// 初始化数据
  Future<void> setDataSource(List<GoodsTypeModel> dataSource) async {
    if (_dataSource.isNotEmpty) return;
    _dataSource = dataSource;
    if (dataSource.isEmpty) {
      final result = await _request(0);
      if (result.isNotEmpty) {
        setDataSource(result);
      }
    } else {
      state = state.copyWith(datas: dataSource, choosed: []);
    }
  }

  void changeSegmentIndex(int index) {
    final preIndex = index - 1;
    List<GoodsTypeModel> datas;
    if (preIndex < 0) {
      datas = _dataSource;
    } else {
      final model = state.choosed[preIndex];
      datas = _allDataSource[model] ?? [];
    }

    state = state.copyWith(datas: datas, segmentIndex: index);
  }

  /// 点击选择
  void selected(int itemIndex, int segmentIndex) {
    final model = state.datas[itemIndex];

    final cache = _allDataSource[model];

    /// 模拟实际开发中可能有的只有两级 有的有三级
    final maxNum = RandomUtil.number(2) == 0 ? 1 : 2;

    bool hasNext = segmentIndex < maxNum;

    void changeState(List<GoodsTypeModel> result) {
      state = state.copyWith(
        datas: result,
        choosed: [
          for (int i = 0; i < segmentIndex; i++) state.choosed[i],
          model,
        ],
        hasNext: hasNext,
        segmentIndex: hasNext ? segmentIndex + 1 : segmentIndex,
        tag: hasNext ? state.tag : state.tag + 1,
      );
    }

    if (hasNext) {
      if (cache == null) {
        _request(segmentIndex + 1).then((value) {
          changeState(value);
          _allDataSource[model] = value;
        });
      } else {
        changeState(cache);
      }
    } else {
      changeState(state.datas);
    }
  }

  Future<List<GoodsTypeModel>> _request(int level) async {
    state = state.copyWith(isLoading: true);

    await Future.delayed(const Duration(seconds: 1));

    String jsonPath;
    if (level == 0) {
      jsonPath = 'assets/data/sort_0.json';
    } else if (level == 1) {
      jsonPath = 'assets/data/sort_1.json';
    } else {
      jsonPath = 'assets/data/sort_2.json';
    }

    String jsonString = await rootBundle.loadString(jsonPath);

    List<GoodsTypeModel> result;
    final decodeResult = jsonDecode(jsonString);
    if (decodeResult is List) {
      result = decodeResult.map((e) => GoodsTypeModel.fromJson(e)).toList();
    } else {
      result = [];
    }

    state = state.copyWith(isLoading: false);

    return result;
  }
}

class GoodsTypeChooseState {
  /// 当前展示的
  final List<GoodsTypeModel> datas;

  /// 已选择的
  final List<GoodsTypeModel> choosed;

  /// 是否正在请求
  final bool isLoading;

  /// 是否还有
  final bool hasNext;

  /// 当前tab下标
  final int segmentIndex;

  /// 标记可以关闭的tag
  final int tag;

  const GoodsTypeChooseState({
    this.datas = const [],
    this.choosed = const [],
    this.isLoading = false,
    this.hasNext = true,
    this.segmentIndex = 0,
    this.tag = 0,
  });

  GoodsTypeChooseState copyWith({
    List<GoodsTypeModel>? datas,
    List<GoodsTypeModel>? choosed,
    bool? isLoading,
    bool? hasNext,
    int? segmentIndex,
    int? tag,
  }) {
    return GoodsTypeChooseState(
      datas: datas ?? this.datas,
      choosed: choosed ?? this.choosed,
      isLoading: isLoading ?? this.isLoading,
      hasNext: hasNext ?? this.hasNext,
      segmentIndex: segmentIndex ?? this.segmentIndex,
      tag: tag ?? this.tag,
    );
  }

  @override
  bool operator ==(covariant GoodsTypeChooseState other) {
    if (identical(this, other)) return true;

    return listEquals(other.datas, datas) &&
        listEquals(other.choosed, choosed) &&
        other.isLoading == isLoading &&
        other.hasNext == hasNext &&
        other.segmentIndex == segmentIndex &&
        other.tag == tag;
  }

  @override
  int get hashCode {
    return datas.hashCode ^
        choosed.hashCode ^
        isLoading.hashCode ^
        hasNext.hashCode ^
        segmentIndex.hashCode ^
        tag.hashCode;
  }
}
