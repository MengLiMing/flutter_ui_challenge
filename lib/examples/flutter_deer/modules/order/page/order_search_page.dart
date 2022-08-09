import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/order/models/order_models.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/order/provider/order_list_provider.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/order/widgets/order_list_item.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/toast.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/search_bar.dart';

class OrderSearchPage extends ConsumerStatefulWidget {
  const OrderSearchPage({Key? key}) : super(key: key);

  @override
  ConsumerState<OrderSearchPage> createState() => _OrderSearchPageState();
}

class _OrderSearchPageState extends ConsumerState<OrderSearchPage> {
  final String id = UniqueKey().toString();

  void searchAction(String keyword) {
    if (keyword.isEmpty) {
      Toast.show('请输入关键字');
      return;
    }
    final manager = ref.read(OrderListProviders.dataManager(id).notifier);
    manager.params = OrderListParams(keyword: keyword);
    request(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchBar(
        hintText: '时间/关键字查询',
        onSearch: searchAction,
      ),
      body: Consumer(builder: (context, ref, _) {
        final datas = ref.watch(OrderListProviders.datas(id));
        return ListView.builder(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
          itemBuilder: (context, index) {
            if (index == datas.length) {
              return _footerWidget();
            } else {
              return itemBuilder(context, index, datas);
            }
          },
          itemCount: datas.length == 0 ? 0 : datas.length + 1,
        );
      }),
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

  Widget itemBuilder(
      BuildContext context, int index, List<OrderListItemData> datas) {
    final itemData = datas[index];
    return OrderListItem(
      key: ValueKey(itemData.index),
      itemData: itemData,
    );
  }

  Future<void> request(bool isRefresh) async {
    final dataManager = ref.read(OrderListProviders.dataManager(id).notifier);
    if (dataManager.params.keyword == null ||
        dataManager.params.keyword!.isEmpty) return;

    if (isRefresh) {
      await dataManager.refresh();
    } else {
      await dataManager.loadMore();
    }
    return;
  }
}
