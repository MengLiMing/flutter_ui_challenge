import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/order/models/order_models.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/order/provider/order_list_provider.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/order/widgets/order_list_item.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/toast.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/custom_show_loading.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_more_footer.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/search_bar.dart';

class OrderSearchPage extends ConsumerStatefulWidget {
  const OrderSearchPage({Key? key}) : super(key: key);

  @override
  ConsumerState<OrderSearchPage> createState() => _OrderSearchPageState();
}

class _OrderSearchPageState extends ConsumerState<OrderSearchPage>
    with OrderListProviders {
  final loadingController = CustomShowLoadingController();

  bool _isSearching = false;

  void searchAction(String keyword) {
    if (keyword.isEmpty) {
      Toast.show('请输入关键字');
      return;
    }
    final manager = ref.read(dataManager.notifier);
    manager.params = OrderListParams(keyword: keyword);
    request(true, isSearching: true);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(isLoading, (previous, next) {
      loadingController.isLoading = _isSearching && (next as bool);
    });
    return CustomShowLoading(
      controller: loadingController,
      child: Scaffold(
        appBar: MySearchBar(
          hintText: '时间/关键字查询',
          onSearch: searchAction,
        ),
        body: Consumer(builder: (context, ref, _) {
          final dataList = ref.watch(datas);
          return ListView.builder(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
            itemBuilder: (context, index) {
              if (index == dataList.length) {
                return _footerWidget();
              } else {
                return itemBuilder(context, index, dataList);
              }
            },
            itemCount: dataList.isEmpty ? 0 : dataList.length + 1,
          );
        }),
      ),
    );
  }

  Widget _footerWidget() {
    return Consumer(builder: (context, ref, _) {
      final result = ref.watch(hasMore);
      if (result) {
        request(false);
      }
      return LoadMoreFooter(hasMore: result);
    });
  }

  Widget itemBuilder(
      BuildContext context, int index, List<OrderListItemData> datas) {
    final itemData = datas[index];
    return OrderListItem(
      key: ValueKey(itemData.index),
      unfoldItem: unfoldItem,
      itemData: itemData,
    );
  }

  Future<void> request(bool isRefresh, {bool isSearching = false}) async {
    _isSearching = isSearching;
    final notifier = ref.read(dataManager.notifier);
    if (notifier.params.keyword == null || notifier.params.keyword!.isEmpty) {
      return;
    }

    if (isRefresh) {
      await notifier.refresh();
    } else {
      await notifier.loadMore();
    }
    return;
  }
}
