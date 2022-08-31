import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_segment/flutter_easy_segment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/goods/providers/goods_type_choose_providers.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/text_styles.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/navigator_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';

class GoodsTypeChooseSheet extends StatefulWidget {
  final GoodsTypeChooseStateNotifier notifier;
  const GoodsTypeChooseSheet({
    Key? key,
    required this.notifier,
  }) : super(key: key);

  @override
  State<GoodsTypeChooseSheet> createState() => _GoodsTypeChooseSheetState();
}

class _GoodsTypeChooseSheetState extends State<GoodsTypeChooseSheet>
    with GoodsTypeChooseProviders {
  double get sheetHeight => ScreenUtils.height * 0.6;

  late final EasySegmentController segmentController;

  @override
  void initState() {
    super.initState();

    segmentController =
        EasySegmentController(initialIndex: widget.notifier.segmentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        typeManager.overrideWithValue(widget.notifier),
      ],
      child: buidContent(),
    );
  }

  Widget buidContent() {
    return Consumer(builder: (context, ref, _) {
      ref.read(typeManager.notifier).setDataSource([]);
      ref.listen<int>(segmentIndex, (_, next) {
        segmentController.scrollToIndex(next);
      });
      ref.listen<int>(closeAction, (_, __) {
        NavigatorUtils.pop(context, result: ref.read(typeManager).choosed.last);
      });
      return Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: sheetHeight,
            maxHeight: sheetHeight,
            minWidth: double.infinity,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              ColoredBox(
                color: Colors.white,
                child: Consumer(
                  builder: (context, ref, child) {
                    return IgnorePointer(
                      ignoring: ref.watch(isLoading),
                      child: child,
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      title(),
                      const Divider(),
                      SizedBox(
                        height: 34,
                        child: segmentView(),
                      ),
                      const Divider(),
                      Expanded(child: chooseListView()),
                    ],
                  ),
                ),
              ),
              loadingView(),
            ],
          ),
        ),
      );
    });
  }

  Widget loadingView() {
    return Consumer(
      builder: (context, ref, child) {
        final isLoading = ref.watch(this.isLoading);
        return Visibility(visible: isLoading, child: child!);
      },
      child: const CupertinoActivityIndicator(),
    );
  }

  Widget chooseListView() {
    return Consumer(builder: (context, ref, _) {
      final datas = ref.watch(this.datas);
      return ListView.builder(
        padding: EdgeInsets.only(bottom: ScreenUtils.bottomPadding),
        itemBuilder: (context, index) {
          return listItem(context, index);
        },
        itemCount: datas.length,
      );
    });
  }

  Widget listItem(BuildContext context, int itemIndex) {
    return Consumer(builder: (context, ref, _) {
      final current = ref.watch(datas)[itemIndex];
      final segmentIndex = ref.watch(this.segmentIndex);
      final selected = ref.read(choosed(segmentIndex));
      final isSelected = selected == current;
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          ref
              .read(typeManager.notifier)
              .selected(itemIndex, segmentController.currentIndex);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          child: Row(children: [
            Text(
              current.name ?? '',
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? Colours.appMain : Colours.text,
              ),
            ),
            const SizedBox(width: 8),
            Visibility(
              visible: isSelected,
              child:
                  const LoadAssetImage('goods/xz', height: 16.0, width: 16.0),
            )
          ]),
        ),
      );
    });
  }

  Widget segmentView() {
    return Consumer(builder: (context, ref, _) {
      List<String> choosed = ref.watch(segmentTitles);
      return EasySegment(
        controller: segmentController,
        space: 24,
        padding: const EdgeInsets.only(left: 16),
        indicators: const [
          CustomSegmentLineIndicator(
            color: Colours.appMain,
            bottom: 0,
            cornerRadius: 0,
            height: 2,
          ),
        ],
        onTap: (index) {
          ref.read(typeManager.notifier).changeSegmentIndex(index);
        },
        children: choosed
            .map((model) => CustomSegmentText(
                  content: model,
                  normalStyle:
                      const TextStyle(fontSize: 14, color: Colours.text),
                  selectedStyle:
                      const TextStyle(fontSize: 14, color: Colours.appMain),
                ))
            .toList(),
      );
    });
  }

  Widget title() {
    return SizedBox(
      height: 51,
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          const Center(child: Text('商品分类', style: TextStyles.textBold16)),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: 48,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => NavigatorUtils.pop(context),
              child: Container(
                alignment: Alignment.center,
                child: const LoadAssetImage(
                  'goods/icon_dialog_close',
                  width: 16,
                  height: 16,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
