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
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_more_footer.dart';

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

class _OrderListPageState extends ConsumerState<OrderListPage>
    with OrderListProviders {
  int get _index => widget.orderType.index;

  @override
  void initState() {
    super.initState();

    final notifier = ref.read(dataManager.notifier);
    notifier.params = OrderListParams(orderType: widget.orderType);

    checkNeedRefresh();
  }

  void checkNeedRefresh() {
    final state = ref.read(dataManager);

    if (state.datas.isEmpty) {
      refresh();
    }
  }

  Future<void> refresh() {
    return ref.read(dataManager.notifier).refresh();
  }

  Future<void> loadMore() {
    return ref.read(dataManager.notifier).loadMore();
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
      onRefresh: refresh,
      child: NotificationListener(
        onNotification: (ScrollNotification notification) {
          if (notification.depth == 0 &&
              notification is ScrollUpdateNotification) {
            final offset = notification.metrics.pixels;
            if (ref.read(HeaderProviders.pageIndex) == _index && offset <= 0) {
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
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              controller: controller,
              slivers: [
                SliverOverlapInjector(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                child!,
              ],
            );
          },
          child: SliverPadding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
            sliver: Consumer(
              builder: (context, ref, _) {
                final dataList = ref.watch(datas);
                final isHadLoaded = ref.watch(hadLoaded);
                return dataList.isEmpty
                    ? SliverFillRemaining(
                        child: Container(
                          alignment: Alignment.center,
                          child: isHadLoaded
                              ? const EmptyView(type: EmptyType.order)
                              : const CupertinoActivityIndicator(),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index == dataList.length) {
                              return _footerWidget();
                            } else {
                              return itemBuilder(context, index, dataList);
                            }
                          },
                          childCount: dataList.length + 1,
                        ),
                      );
              },
            ),
          ),
        ),
      ),
    );
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
      unfoldItem: unfoldItem,
      itemData: itemData,
    );
  }

  Widget _footerWidget() {
    return Consumer(builder: (context, ref, _) {
      final result = ref.watch(hasMore);
      if (result) {
        loadMore();
      }
      return LoadMoreFooter(hasMore: result);
    });
  }
}
