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
  ValueNotifier<bool> unfold = ValueNotifier(false);

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
                    isShow: ref.watch(isShow),
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
        final state = ref.watch(goodType);
        return GoodsHeadTitle(title: state.title, unfold: state.unfold);
      }),
    );
  }

  void searchAction() {}

  void showAddMenu() {}

  void showGoodsTypeChoose() {
    ref.read(goodType.notifier).autoUnfold();
  }
}
