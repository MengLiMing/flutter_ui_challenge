// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/model/shop_record_model.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/page_request.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/random_utils.dart';

mixin ShopRecordProviders {
  final manager = StateNotifierProvider.autoDispose<ShopRecordStateNotifier,
      ShopRecordState>((ref) => ShopRecordStateNotifier());

  late final datas = Provider.autoDispose<List<ShopRecordSectionModel>>(
      (ref) => ref.watch(manager).datas);

  late final isLoading =
      Provider.autoDispose<bool>((ref) => ref.watch(manager).isLoading);

  late final hasMore =
      Provider.autoDispose<bool>((ref) => ref.watch(manager).hasMore);

  late final hadLoaded =
      Provider.autoDispose<bool>((ref) => ref.watch(manager).hadLoaded);

  late final refresh =
      Provider.autoDispose<void>((ref) => ref.watch(manager).refreshTag);

  late final loadMore =
      Provider.autoDispose<void>((ref) => ref.watch(manager).loadMoreTag);
}

class ShopRecordStateNotifier extends StateNotifier<ShopRecordState>
    with PageRequest<ShopRecordSectionModel> {
  ShopRecordStateNotifier() : super(ShopRecordState());

  @override
  void cancelRequest() {}

  @override
  Future<PageResponseWrapper<ShopRecordSectionModel>> request(
      int page, int pageSize, PageRequestType requestType) async {
    await Future.delayed(page == 0
        ? const Duration(milliseconds: 400)
        : const Duration(seconds: 2));

    final datas = List.generate(10, (index) {
      return ShopRecordSectionModel(
        /// 模拟下一页和上一页的最后一个时间相同 合并数据的场景
        date: '2022/08/${22 - page * 10 - index + (page > 0 ? 1 : 0)}',
        models: List.generate(
          RandomUtil.number(3) + 3,
          (index) => ShopRecordModel(
              isIncome: index % 2 == 0,
              price: '10.00',
              time: '18:20:01',
              balance: '20.00'),
        ),
      );
    });

    return PageResponseWrapper(
        page: page,
        requestType: requestType,
        hasMore: page < 1,
        responseList: datas);
  }

  @override
  void startRequest(int page, int pageSize, PageRequestType requestType) {
    if (mounted == false) return;
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      state = state.copyWith(isLoading: true);
    });
  }

  @override
  void endRequest(PageResponseWrapper<ShopRecordSectionModel> response) {
    super.endRequest(response);
    if (mounted == false) return;
    state = state.copyWith(isLoading: false, hasMore: response.hasMore);

    switch (response.requestType) {
      case PageRequestType.none:
        break;
      case PageRequestType.refresh:
        state = state.copyWith(
          datas: response.responseList,
          hasMore: response.hasMore,
          isLoading: false,
          hadLoaded: true,
          refreshTag: state.refreshTag == 0 ? 1 : 0,
        );

        break;
      case PageRequestType.loadMore:
        if (state.datas.isNotEmpty &&
            response.responseList.isNotEmpty &&
            state.datas.last.date == response.responseList.first.date) {
          var oldDatas = state.datas;
          var newDatas = response.responseList;

          var oldLast = state.datas.removeLast();
          final newFirst = newDatas.removeAt(0);

          oldLast =
              oldLast.copyWith(models: [...oldLast.models, ...newFirst.models]);
          state = state.copyWith(
            datas: [...oldDatas, oldLast, ...newDatas],
            hasMore: response.hasMore,
            isLoading: false,
            hadLoaded: true,
            loadMoreTag: state.loadMoreTag == 0 ? 1 : 0,
          );
        } else {
          state = state.copyWith(
            datas: [...state.datas, ...response.responseList],
            hasMore: response.hasMore,
            isLoading: false,
            hadLoaded: true,
            loadMoreTag: response.responseList.isEmpty
                ? state.loadMoreTag
                : (state.loadMoreTag == 0 ? 1 : 0),
          );
        }

        break;
    }
  }
}

class ShopRecordState {
  final List<ShopRecordSectionModel> datas;

  final bool isLoading;

  final bool hadLoaded;

  final bool hasMore;

  /// 触发refresh
  final int refreshTag;

  /// 用来触发loadMore
  final int loadMoreTag;

  ShopRecordState({
    this.datas = const [],
    this.isLoading = false,
    this.hadLoaded = false,
    this.hasMore = true,
    this.refreshTag = 0,
    this.loadMoreTag = 0,
  });

  ShopRecordState copyWith({
    List<ShopRecordSectionModel>? datas,
    bool? isLoading,
    bool? hadLoaded,
    bool? hasMore,
    int? refreshTag,
    int? loadMoreTag,
  }) {
    return ShopRecordState(
      datas: datas ?? this.datas,
      isLoading: isLoading ?? this.isLoading,
      hadLoaded: hadLoaded ?? this.hadLoaded,
      hasMore: hasMore ?? this.hasMore,
      refreshTag: refreshTag ?? this.refreshTag,
      loadMoreTag: loadMoreTag ?? this.loadMoreTag,
    );
  }

  @override
  bool operator ==(covariant ShopRecordState other) {
    if (identical(this, other)) return true;

    return listEquals(other.datas, datas) &&
        other.isLoading == isLoading &&
        other.hadLoaded == hadLoaded &&
        other.hasMore == hasMore &&
        other.refreshTag == refreshTag &&
        other.loadMoreTag == loadMoreTag;
  }

  @override
  int get hashCode {
    return datas.hashCode ^
        isLoading.hashCode ^
        hadLoaded.hashCode ^
        hasMore.hashCode ^
        refreshTag.hashCode ^
        loadMoreTag.hashCode;
  }
}
