// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/page_request.dart';

mixin GoodsListProvider {
  final manager =
      StateNotifierProvider.autoDispose<GoodsListStateNotifier, GoodsListState>(
    (ref) => GoodsListStateNotifier(),
  );

  /// 是否正在刷新
  late final isLoading =
      Provider.autoDispose<bool>((ref) => ref.watch(manager).isLoading);

  /// 数据源
  late final datas = Provider.autoDispose<List<GoodsListDataItem>>(
      (ref) => ref.watch(manager).datas);

  /// 是否有更多
  late final hasMore =
      Provider.autoDispose<bool>((ref) => ref.watch(manager).hasMore);

  /// 是否加载过
  late final hadLoaded =
      Provider.autoDispose<bool>((ref) => ref.watch(manager).hadLoaded);
}

class GoodsListStateNotifier extends StateNotifier<GoodsListState>
    with PageRequest<GoodsListDataItem> {
  int? type;

  GoodsListStateNotifier() : super(GoodsListState());

  @override
  void cancelRequest() {}

  @override
  void startRequest(int page, int pageSize, PageRequestType requestType) {
    if (mounted == false) return;
    ServicesBinding.instance.addPostFrameCallback((timeStamp) {
      state = state.copyWith(isLoading: true);
    });
  }

  @override
  void endRequest(PageResponseWrapper<GoodsListDataItem> response) {
    if (mounted == false) return;

    switch (response.requestType) {
      case PageRequestType.none:
        state = state.copyWith(
          hasMore: response.hasMore,
          isLoading: false,
          hadLoaded: true,
        );
        break;
      case PageRequestType.refresh:
        state = state.copyWith(
          datas: response.responseList,
          hasMore: response.hasMore,
          isLoading: false,
          hadLoaded: true,
        );
        break;
      case PageRequestType.loadMore:
        state = state.copyWith(
          datas: [...state.datas, ...response.responseList],
          hasMore: response.hasMore,
          isLoading: false,
          hadLoaded: true,
        );
        break;
    }
  }

  @override
  Future<PageResponseWrapper<GoodsListDataItem>> request(
      int page, int pageSize, PageRequestType requestType) async {
    await Future.delayed(const Duration(seconds: 1));

    /// 模拟一下无数据
    if ((type ?? 0) % 2 == 0) {
      return PageResponseWrapper(
        page: page,
        requestType: requestType,
        hasMore: false,
        responseList: [],
      );
    }
    List<GoodsListDataItem> results = List<GoodsListDataItem>.generate(
        page == 3 ? pageSize ~/ 2 : pageSize, (i) {
      final index = page * pageSize + i;
      return GoodsListDataItem(id: index);
    });

    return PageResponseWrapper(
      page: page,
      requestType: requestType,
      hasMore: results.length == pageSize,
      responseList: results,
    );
  }
}

class GoodsListState {
  final List<GoodsListDataItem> datas;

  final bool isLoading;

  final bool hasMore;

  /// 是否请求过， 如果请求过数据还为空，则显示空页面
  final bool hadLoaded;

  const GoodsListState({
    this.datas = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.hadLoaded = false,
  });

  GoodsListState copyWith({
    List<GoodsListDataItem>? datas,
    bool? isLoading,
    bool? hasMore,
    bool? hadLoaded,
  }) {
    return GoodsListState(
      datas: datas ?? this.datas,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      hadLoaded: hadLoaded ?? this.hadLoaded,
    );
  }
}

class GoodsListDataItem {
  final int id;

  const GoodsListDataItem({required this.id});

  @override
  bool operator ==(covariant GoodsListDataItem other) {
    if (identical(this, other)) return true;

    return other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
