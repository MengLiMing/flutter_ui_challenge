import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/goods/providers/goods_list_providers.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/custom_show_loading.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/empty_view.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_more_footer.dart';

class GoodsListView extends ConsumerStatefulWidget {
  final int index;

  const GoodsListView({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  ConsumerState<GoodsListView> createState() => _GoodsListViewState();
}

class _GoodsListViewState extends ConsumerState<GoodsListView>
    with GoodsListProvider {
  final CustomShowLoadingController loadController =
      CustomShowLoadingController();

  @override
  void initState() {
    super.initState();

    final notifier = ref.read(manager.notifier);
    notifier.type = widget.index;
    notifier.refresh();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<bool>(isLoading, (_, next) {
      if (next == false) {
        loadController.isLoading = false;
      } else {
        if (ref.read(hadLoaded) == false) {
          loadController.isLoading = true;
        }
      }
    });

    final itemDatas = ref.watch(datas);
    return CustomShowLoading(
      controller: loadController,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Visibility(
            visible: itemDatas.isNotEmpty,
            child: RefreshIndicator(
              onRefresh: ref.read(manager.notifier).refresh,
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 16),
                itemBuilder: (context, index) {
                  if (index == itemDatas.length) {
                    return footer();
                  } else {
                    return buildItem(context, index);
                  }
                },
                itemCount: itemDatas.isNotEmpty ? itemDatas.length + 1 : 0,
              ),
            ),
          ),
          emtpyView(),
        ],
      ),
    );
  }

  Widget emtpyView() {
    return Consumer(builder: (context, ref, _) {
      final notifier = ref.watch(manager);
      if (notifier.hadLoaded && notifier.datas.isEmpty) {
        return const EmptyView(type: EmptyType.goods);
      } else {
        return const SizedBox.shrink();
      }
    });
  }

  Widget footer() {
    return Consumer(builder: (context, ref, _) {
      final result = ref.watch(hasMore);
      if (result) {
        ref.read(manager.notifier).loadMore();
      }
      return LoadMoreFooter(hasMore: result);
    });
  }

  Widget buildItem(BuildContext context, int index) {
    final itemDatas = ref.read(datas);
    final data = itemDatas[index];
    return GoodsLisItem(key: ValueKey(data.id));
  }
}

class GoodsLisItem extends StatelessWidget {
  const GoodsLisItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Row(
            children: [
              const LoadImage(
                'https://avatars.githubusercontent.com/u/19296728?s=400&u=7a099a186684090f50459c87176cf4d291a27ac7&v=4',
                width: 72,
                height: 72,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 72,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 18,
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text('八月十五中秋月饼礼盒',
                                  maxLines: 1, overflow: TextOverflow.ellipsis),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                alignment: Alignment.centerRight,
                                width: 40,
                                height: 40,
                                child: const LoadAssetImage(
                                  'goods/ellipsis',
                                  width: 15,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 4,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                color: Colours.red,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                            padding: const EdgeInsets.only(
                                left: 4, right: 4, bottom: 1),
                            child: const Text(
                              '立减',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                                color: Colours.appMain,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                            padding: const EdgeInsets.only(
                                left: 4, right: 4, bottom: 1),
                            child: const Text(
                              '社区币抵扣',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          child: Row(
                            children: const [
                              Expanded(
                                child: Text(
                                  '¥20.00',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colours.text,
                                  ),
                                ),
                              ),
                              Text(
                                '特产美味',
                                style: TextStyle(
                                    fontSize: 12, color: Colours.textGray),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 16),
        const Divider(),
      ],
    );
  }
}
