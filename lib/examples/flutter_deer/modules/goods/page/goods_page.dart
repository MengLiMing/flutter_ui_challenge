// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/goods/providers/goods_page_providers.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/goods/widgets/goods_head_title.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/goods/widgets/goods_type_choose.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';

class GoodsPage extends ConsumerStatefulWidget {
  const GoodsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<GoodsPage> createState() => _GoodsPageState();
}

class _GoodsPageState extends ConsumerState<GoodsPage> with GoodsPageProviders {
  List<GoodsTypeItem> items = const [
    GoodsTypeItem(title: '全部商品', count: 10),
    GoodsTypeItem(title: '个人护理', count: 1),
    GoodsTypeItem(title: '饮料', count: 2),
    GoodsTypeItem(title: '沐浴洗护', count: 1),
    GoodsTypeItem(title: '厨房用具', count: 1),
    GoodsTypeItem(title: '休闲食品', count: 1),
    GoodsTypeItem(title: '生鲜水果', count: 1),
    GoodsTypeItem(title: '酒水', count: 2),
    GoodsTypeItem(title: '家庭清洁', count: 1)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: searchAction,
            icon: Container(
                width: 42,
                height: 44,
                alignment: Alignment.center,
                child: const LoadAssetImage('goods/search',
                    width: 24, height: 24)),
          ),
          IconButton(
            onPressed: showAddMenu,
            icon: Container(
                padding: const EdgeInsets.only(right: 5),
                width: 42,
                height: 44,
                alignment: Alignment.center,
                child:
                    const LoadAssetImage('goods/add', width: 24, height: 24)),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _headTitle(),
          Expanded(
            child: Stack(
              children: [
                Consumer(builder: (context, ref, _) {
                  return GoodsTypeChoose(
                    selectedIndex: ref.watch(selectedIndex),
                    datas: items,
                    onChoose: (value) {
                      ref.watch(goodType.notifier).setUnfold(false);
                      ref.read(goodType.notifier).setSelectedIndex(value);
                    },
                    isShow: ref.watch(unfold),
                    onDismiss: () =>
                        ref.read(goodType.notifier).setUnfold(false),
                  );
                })
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _headTitle() {
    return GestureDetector(
      onTap: showGoodsTypeChoose,
      child: Consumer(builder: (context, ref, _) {
        final index = ref.watch(selectedIndex);
        final item = items[index];
        return GoodsHeadTitle(
          title: item.title,
          unfold: ref.watch(unfold),
        );
      }),
    );
  }

  void searchAction() {}

  void showAddMenu() {}

  void showGoodsTypeChoose() {
    ref.read(goodType.notifier).autoUnfold();
  }
}
