import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/goods/goods_route.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/goods/providers/goods_list_providers.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/navigator_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/dialog_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/toast.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/action_sheet.dart';
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
              onRefresh: () async {
                await ref.read(manager.notifier).refresh();
                ref.read(showMenuIndex.state).state = null;
                return;
              },
              child: ListView.builder(
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
    return Consumer(builder: (context, ref, _) {
      return GoodsLisItem(
        showMenuIndex: ref.watch(showMenuIndex),
        key: ValueKey(data.id),
        index: index,
        data: data,
        delete: (itemIndex) {
          ref.read(manager.notifier).delete(itemIndex);
        },
        showMenu: (itemIndex) {
          final oldIndex = ref.read(showMenuIndex);
          if (oldIndex == itemIndex) {
            ref.read(showMenuIndex.state).state = null;
          } else {
            ref.read(showMenuIndex.state).state = itemIndex;
          }
        },
      );
    });
  }
}

class GoodsLisItem extends StatefulWidget {
  final int index;
  final GoodsListItemData data;
  final ValueChanged<int> showMenu;
  final ValueChanged<int> delete;
  final int? showMenuIndex;

  const GoodsLisItem({
    Key? key,
    required this.index,
    this.showMenuIndex,
    required this.data,
    required this.showMenu,
    required this.delete,
  }) : super(key: key);

  @override
  State<GoodsLisItem> createState() => _GoodsLisItemState();
}

class _GoodsLisItemState extends State<GoodsLisItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController menuAnimationController;

  @override
  void initState() {
    super.initState();

    menuAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..value = widget.index == widget.showMenuIndex ? 1 : 0;
  }

  @override
  void dispose() {
    menuAnimationController.dispose();
    super.dispose();
  }

  void showMenuAction() {
    widget.showMenu(widget.index);
  }

  @override
  void didUpdateWidget(covariant GoodsLisItem oldWidget) {
    if (widget.showMenuIndex != widget.index &&
        menuAnimationController.value == 1) {
      configAnimation(false);
    }

    if (widget.index == widget.showMenuIndex &&
        menuAnimationController.value == 0) {
      configAnimation(true);
      menuAnimationController.forward(from: 0);
    }

    super.didUpdateWidget(oldWidget);
  }

  void configAnimation(bool isStart) {
    ServicesBinding.instance.addPostFrameCallback((timeStamp) {
      isStart
          ? menuAnimationController.forward(from: 0)
          : menuAnimationController.reverse(from: 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final content = Column(
      children: [
        const SizedBox(height: 16),
        Row(
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
                          Expanded(
                            child: Text('八月十五中秋月饼礼盒${widget.data.id}',
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: showMenuAction,
                            child: Container(
                              padding: const EdgeInsets.only(right: 16),
                              alignment: Alignment.centerRight,
                              width: 56,
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
                        padding: const EdgeInsets.only(right: 16),
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
        const SizedBox(height: 16),
        const Divider(),
      ],
    );

    return Stack(
      children: [
        Padding(padding: const EdgeInsets.only(left: 16), child: content),
        Positioned(left: 0, top: 0, right: 0, bottom: 0, child: goodsMenu()),
      ],
    );
  }

  Widget goodsMenu() {
    return GestureDetector(
      onTap: () => widget.showMenu(widget.index),
      child: ClipPath(
        clipper: _MenuCliper(progress: menuAnimationController),
        child: _GoodsMenu(
          onTap: (action) {
            widget.showMenu(widget.index);
            goodsMenuAction(action);
          },
        ),
      ),
    );
  }

  void goodsMenuAction(_MenuAction action) {
    switch (action) {
      case _MenuAction.delete:
        deleteAction();
        break;
      case _MenuAction.edit:
        NavigatorUtils.push(context, GoodsRouter.edit, parameters: {
          'isEdit': '1',
        });
        break;
      default:
        Toast.show(action.title);
        break;
    }
  }

  void deleteAction() {
    DialogUtils.show(context, builder: (context) {
      return ActionSheet(items: [
        ActionSheetItemProvider.actionTitle(title: '是否确认删除，防止错误操作'),
        ActionSheetItemProvider.destructive(
            text: '确认删除',
            onTap: (_) {
              widget.delete(widget.index);
              NavigatorUtils.pop(context);
            }),
        ActionSheetItemProvider.cancel(),
      ]);
    });
  }
}

class _MenuCliper extends CustomClipper<Path> {
  final Animation<double> progress;

  _MenuCliper({required this.progress}) : super(reclip: progress);

  @override
  Path getClip(Size size) {
    /// 点击区域的中心店为圆心
    final center = Offset(size.width - 25, 25);
    final radius = sqrt(size.width * size.width + size.height * size.height) *
        progress.value;

    return Path()
      ..addOval(Rect.fromCenter(
          center: center, width: radius * 2, height: radius * 2));
  }

  @override
  bool shouldReclip(covariant _MenuCliper oldClipper) {
    return oldClipper.progress != progress;
  }
}

enum _MenuAction {
  edit,
  down,
  delete,
}

extension on _MenuAction {
  String get title {
    switch (this) {
      case _MenuAction.edit:
        return '编辑';
      case _MenuAction.down:
        return '下架';
      case _MenuAction.delete:
        return '删除';
    }
  }
}

class _GoodsMenu extends StatelessWidget {
  final ValueChanged<_MenuAction> onTap;
  const _GoodsMenu({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: Colors.black12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            actionButton(
              '编辑',
              Colours.appMain,
              Colors.white,
              () => onTap(_MenuAction.edit),
            ),
            const SizedBox(width: 24),
            actionButton(
              '下架',
              Colors.white,
              Colours.text,
              () => onTap(_MenuAction.down),
            ),
            const SizedBox(width: 24),
            actionButton(
              '删除',
              Colors.white,
              Colours.text,
              () => onTap(_MenuAction.delete),
            ),
          ],
        )
      ],
    );
  }

  Widget actionButton(
    String text,
    Color bgColor,
    Color textColor,
    VoidCallback onTap,
  ) {
    return MaterialButton(
      elevation: 0,
      onPressed: onTap,
      padding: EdgeInsets.zero,
      minWidth: 56,
      height: 56,
      color: bgColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(28))),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 16,
        ),
      ),
    );
  }
}
