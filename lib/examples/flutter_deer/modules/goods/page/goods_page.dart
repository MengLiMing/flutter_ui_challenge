// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/goods/providers/goods_page_providers.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/goods/widgets/goods_head_title.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/goods/widgets/goods_list_view.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/goods/widgets/goods_page_option.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/goods/widgets/goods_type_choose.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/overlay_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/random_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/toast.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/always_keep_alive.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/easy_segment/easy_segment.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/option_selected_view.dart';

class GoodsPage extends ConsumerStatefulWidget {
  const GoodsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<GoodsPage> createState() => _GoodsPageState();
}

class _GoodsPageState extends ConsumerState<GoodsPage> with GoodsPageProviders {
  final GlobalKey addButtonKey = GlobalKey();

  OverlayEntry? optionEntry;

  final OptionSelectedController selectedController =
      OptionSelectedController();

  EasySegmentController segmentController =
      EasySegmentController(initialIndex: 7);

  final PageController pageController = PageController(initialPage: 7);

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
  void initState() {
    super.initState();

    pageController.addListener(() {
      segmentController.changeProgress(pageController.page ?? 0);
    });

    segmentController.addListener(() {
      ref
          .read(goodsState.notifier)
          .setSelectedIndex(segmentController.currentIndex);
    });

    ref.read(goodsState.notifier).setSelectedIndex(7);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

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
            key: addButtonKey,
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _headTitle(),
              _segmentView(),
              Divider(),
              Expanded(
                child: _pageView(),
              )
            ],
          ),
          Consumer(
            builder: (context, ref, _) {
              return Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                top: 49,
                child: GoodsTypeChoose(
                  selectedIndex: ref.watch(selectedIndex),
                  datas: items,
                  onChoose: (value) {
                    segmentController.scrollToIndex(value);
                    pageController.jumpToPage(value);
                    ref.read(goodsState.notifier).setUnfold(false);
                    ref.read(goodsState.notifier).setSelectedIndex(value);
                  },
                  isShow: ref.watch(unfold),
                  onDismiss: () =>
                      ref.read(goodsState.notifier).setUnfold(false),
                ),
              );
            },
          ),
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

  Widget _segmentView() {
    return EasySegment(
      controller: segmentController,
      space: 15,
      padding: const EdgeInsets.only(left: 15, right: 15),
      onTap: (index) {
        pageController.jumpToPage(index);
      },
      indicators: [
        CustomSegmentLineIndicator(
          index: 0,
          color: Colours.appMain,
          width: 40,
          bottom: 2,
          height: 3,
          animation: false,
        ),
        CustomSegmentLineIndicator(
          index: 1,
          color: Colours.red,
          width: 40,
          bottom: 7,
          height: 3,
          animation: true,
        ),
        CustomSegmentLineIndicator(
          index: 2,
          color: Colors.yellow,
          top: 3,
          height: 3,
          animation: true,
        ),
      ],
      children: List.generate(
        items.length,
        (index) => CustomSegmentText(
          key: ValueKey(items[index].title),
          content: items[index].title,
          index: index,
          height: 50,
          normalStyle: const TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal),
          selectedStyle: const TextStyle(
            color: Colours.appMain,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _pageView() {
    return PageView.builder(
      itemBuilder: (context, index) {
        return AlwaysKeepAlive(
            child: GoodsListView(
          index: index,
        ));
      },
      itemCount: items.length,
      controller: pageController,
    );
  }

  void searchAction() {
    int index = RandomUtil.number(items.length);

    segmentController.resetInitialIndex(index);
    ref.read(goodsState.notifier).setSelectedIndex(index);
    pageController.jumpToPage(index);
  }

  void showAddMenu() {
    if (optionEntry != null && optionEntry!.mounted) return;
    final addBtnRender =
        addButtonKey.currentContext?.findRenderObject() as RenderBox?;
    final addBtnSize = addBtnRender?.size ?? Size.zero;
    final addBtnOffset =
        addBtnRender?.localToGlobal(Offset.zero) ?? Offset.zero;

    optionEntry = OverlayUtils.showEntry(context, (context) {
      return OptionSelectedView(
        top: addBtnSize.height + addBtnOffset.dy - 10,
        right: 8,
        radius: 8,
        arrowPointScale: 0.85,
        controller: selectedController,
        child: GoodsPageOptionView(onTap: (value) {
          Toast.show(value.title);
          selectedController.dismiss();
        }),
        onEnd: () {
          optionEntry?.remove();
          optionEntry = null;
        },
      );
    });
  }

  void showGoodsTypeChoose() {
    ref.read(goodsState.notifier).autoUnfold();
  }
}
