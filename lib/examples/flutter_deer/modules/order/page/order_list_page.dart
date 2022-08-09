import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/order/models/order_models.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/order/provider/order_header_provider.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/order/provider/order_list_provider.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/order/widgets/order_list_item.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/order/widgets/order_tag_item.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/empty_view.dart';

class OrderListPage extends ConsumerStatefulWidget {
  final OrderType orderType;

  final ScrollController? controller;

  final ValueChanged<int> scrollOnTop;

  const OrderListPage({
    Key? key,
    required this.orderType,
    required this.controller,
    required this.scrollOnTop,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrderListPageState();
}

class _OrderListPageState extends ConsumerState<OrderListPage> {
  int get _index => widget.orderType.index;

  final String id = UniqueKey().toString();

  @override
  void initState() {
    super.initState();

    checkNeedRefresh();
  }

  void checkNeedRefresh() {
    final dataManager = ref.read(
      OrderListProviders.dataManager(id),
    );

    if (dataManager.datas.isEmpty) {
      request(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(HeaderProviders.stopIndex, (previous, next) {
      if (next == _index) {
        checkNeedRefresh();
      }
    });
    return RefreshIndicator(
        key: ValueKey(_index),
        edgeOffset: 173 + ScreenUtils.topPadding - 40,
        child: NotificationListener(
          onNotification: (ScrollNotification notification) {
            if (notification.depth == 0 &&
                notification is ScrollUpdateNotification) {
              final offset = notification.metrics.pixels;
              if (ref.read(HeaderProviders.pageIndex) == _index &&
                  offset <= 0) {
                widget.scrollOnTop(_index);
              }
            }
            return false;
          },
          child: Consumer(
            builder: (context, ref, child) {
              final stopIndex = ref.watch(HeaderProviders.stopIndex);
              final controller = stopIndex == _index ? null : widget.controller;

              return CustomScrollView(
                key: PageStorageKey<String>('$_index'),
                controller: controller,
                slivers: [
                  SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                  ),
                  child!,
                ],
              );
            },
            child: SliverPadding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
              sliver: Consumer(builder: (context, ref, _) {
                final datas = ref.watch(OrderListProviders.datas(id));
                return datas.isEmpty
                    ? SliverFillRemaining(
                        child: Container(
                          alignment: Alignment.center,
                          child: const EmptyView(type: EmptyType.order),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index == datas.length) {
                              return _footerWidget();
                            } else {
                              return itemBuilder(context, index, datas);
                            }
                          },
                          childCount: datas.length + 1,
                        ),
                      );
              }),
            ),
          ),
        ),
        onRefresh: () async => await request(true));
  }

  Widget itemBuilder(
      BuildContext context, int index, List<OrderListItemData> datas) {
    if (index % 5 == 0) {
      return const OrderTagItem(
        date: "2022年8月9日",
        orderTotal: 10,
      );
    }
    final itemData = datas[index];
    return OrderListItem(
      key: ValueKey(itemData.index),
      itemData: itemData,
    );
  }

  Widget _footerWidget() {
    return Consumer(builder: (context, ref, _) {
      final hadMore = ref.watch(OrderListProviders.hasMore(id));
      if (hadMore) {
        request(false);
        return Container(
          height: 50,
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text('正在加载更多'),
              SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 10,
                height: 10,
                child: CupertinoActivityIndicator(),
              )
            ],
          ),
        );
      } else {
        return Container(
          height: 50,
          alignment: Alignment.center,
          child: const Text('到底了 ~'),
        );
      }
    });
  }

  Future<void> request(bool isRefresh) async {
    if (ref.read(HeaderProviders.pageIndex) != _index) return;
    final dataManager = ref.read(OrderListProviders.dataManager(id).notifier);
    dataManager.params = OrderListParams(orderType: widget.orderType);
    if (isRefresh) {
      await dataManager.refresh();
    } else {
      await dataManager.loadMore();
    }
    return;
  }
}
