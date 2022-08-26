import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/model/shop_withdraw_models.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/provider/shop_withdraw_account_providers.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/shop_router.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/widgets/shop_withdraw_account_item.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/navigator_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/dialog_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/action_sheet.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/my_app_bar.dart';

class ShopWithdrawAccountPage extends ConsumerStatefulWidget {
  const ShopWithdrawAccountPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ShopWithdrawAccountPage> createState() =>
      _ShopWithdrawAccountPageState();
}

class _ShopWithdrawAccountPageState
    extends ConsumerState<ShopWithdrawAccountPage>
    with ShopWithdrawAccountProviders {
  final globalKey = GlobalKey<AnimatedListState>();

  void addAction() {
    NavigatorUtils.push(context, ShopRouter.withdrawAdd,
        resultCallback: (model) {
      if (model is ShopWithdrawAccountModel) {
        insertModel(model);
      }
    });
  }

  void insertModel(ShopWithdrawAccountModel model) {
    ref.read(manager.notifier).insertItem(model);
    globalKey.currentState?.insertItem(0);
  }

  void deleteIndex(int index) {
    globalKey.currentState?.removeItem(index, (context, animation) {
      final item = _buildItem(context, index);
      ref.read(manager.notifier).removeAt(index);

      final offsetTween = Tween<Offset>(
        begin: const Offset(-1, 0),
        end: const Offset(0, 0),
      );
      return SlideTransition(
        position: offsetTween.animate(animation),
        child: item,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: const Text('提现账号'),
        actions: [
          TextButton(
            onPressed: addAction,
            child: const Text(
              '添加',
              style: TextStyle(color: Colours.text),
            ),
          ),
        ],
      ),
      body: AnimatedList(
        padding: EdgeInsets.only(bottom: ScreenUtils.bottomPadding + 20),
        key: globalKey,
        initialItemCount: ref.watch(manager).length,
        itemBuilder: (context, index, animation) {
          return FadeTransition(
            opacity: animation,
            child: SizeTransition(
              axisAlignment: 1,
              sizeFactor: animation,
              child: _buildItem(context, index),
            ),
          );
        },
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final model = ref.read(manager)[index];
    return GestureDetector(
        onLongPress: () => showDelete(() => deleteIndex(index)),
        child: ShopWithdrawAccountItem(model: model));
  }

  void showDelete(VoidCallback onDelete) {
    DialogUtils.show(context, builder: (context) {
      return ActionSheet(items: [
        ActionSheetItemProvider.actionTitle(title: '是否确认解绑，防止错误操作'),
        ActionSheetItemProvider.destructive(
            text: '确认解绑',
            onTap: (context) {
              NavigatorUtils.pop(context);
              onDelete();
            }),
        ActionSheetItemProvider.cancel(),
      ]);
    });
  }
}
