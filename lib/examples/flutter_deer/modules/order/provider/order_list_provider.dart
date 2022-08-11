// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/order/models/order_models.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/page_request.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/random_utils.dart';

class OrderListParams extends Equatable {
  final OrderType? orderType;
  final String? keyword;

  const OrderListParams({
    this.orderType,
    this.keyword,
  });

  @override
  List<Object?> get props => [orderType, keyword];
}

mixin OrderListProviders {
  /// 不同页面使用不同的managerId，推荐使用 uuid
  final dataManager =
      StateNotifierProvider.autoDispose<OrderListDataManager, OrderListData>(
          (ref) {
    return OrderListDataManager();
  });

  /// 是否有更多
  late final hasMore = Provider.autoDispose<bool>((ref) {
    return ref.watch(dataManager).hadMore;
  });

  /// 数据源
  late final datas = Provider.autoDispose<List<OrderListItemData>>((ref) {
    return ref.watch(dataManager).datas;
  });

  /// 对应类型 当前展开的items
  late final unfoldItem = StateProvider<OrderListItemData?>((ref) {
    return null;
  });

  /// 是否正在刷新
  late final isLoading = Provider.autoDispose<bool>((ref) {
    return ref.watch(dataManager).isLoading;
  });
}

class OrderListDataManager extends StateNotifier<OrderListData>
    with PageRequest<OrderListItemData> {
  OrderListParams params = OrderListParams();

  OrderListDataManager() : super(OrderListData.empty());

  @override
  void cancelRequest() {}

  @override
  Future<PageResponseWrapper<OrderListItemData>> request(
      int page, int pageSize, PageRequestType requestType) async {
    final list = await _request(page, pageSize);
    return PageResponseWrapper(
        page: page,
        requestType: requestType,
        hasMore: list.length >= pageSize,
        responseList: list);
  }

  Future<List<OrderListItemData>> _request(int page, int pageSize) async {
    await Future.delayed(const Duration(seconds: 1));
    return List<OrderListItemData>.generate(
        page == 3 ? pageSize ~/ 2 : pageSize,
        (index) => OrderListItemData(
              index: page * pageSize + index,
              orderType: params.orderType ??
                  OrderType.values[RandomUtil.number(OrderType.values.length)],
            ));
  }

  @override
  void startRequest(int page, int pageSize, PageRequestType requestType) {
    super.startRequest(page, pageSize, requestType);

    if (mounted == false) return;
    ServicesBinding.instance.addPostFrameCallback((timeStamp) {
      state = state.copyWith(isLoading: true);
    });
  }

  @override
  void endRequest(PageResponseWrapper<OrderListItemData> response) {
    if (mounted == false) return;

    state = state.copyWith(hadMore: response.hasMore, isLoading: false);

    switch (response.requestType) {
      case PageRequestType.none:
        break;
      case PageRequestType.refresh:
        state = state.copyWith(datas: response.responseList);
        break;
      case PageRequestType.loadMore:
        state =
            state.copyWith(datas: [...state.datas, ...response.responseList]);
        break;
    }
  }
}

class OrderListData extends Equatable {
  /// 数据
  final List<OrderListItemData> datas;

  /// 没有更多数据
  final bool hadMore;

  /// 当前刷新方式
  final PageRequestType requestType;

  final bool isLoading;

  OrderListData({
    required this.isLoading,
    required this.datas,
    required this.hadMore,
    required this.requestType,
  });

  factory OrderListData.empty() {
    return OrderListData(
      isLoading: false,
      datas: [],
      hadMore: true,
      requestType: PageRequestType.none,
    );
  }

  OrderListData copyWith({
    List<OrderListItemData>? datas,
    bool? hadMore,
    bool? isLoading,
    PageRequestType? requestType,
  }) {
    return OrderListData(
      datas: datas ?? this.datas,
      hadMore: hadMore ?? this.hadMore,
      isLoading: isLoading ?? this.isLoading,
      requestType: requestType ?? this.requestType,
    );
  }

  @override
  List<Object?> get props => [datas, hadMore, requestType, isLoading];
}
