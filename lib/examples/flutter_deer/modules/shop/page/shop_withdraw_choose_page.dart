import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/model/shop_withdraw_models.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/provider/shop_withdraw_choose_providers.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/shop_router.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/widgets/shop_withdraw_account.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/navigator_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/my_app_bar.dart';

class ShopWithdrawChoosePage extends ConsumerStatefulWidget {
  final ShopWithdrawAccountModel? model;

  const ShopWithdrawChoosePage({
    Key? key,
    this.model,
  }) : super(key: key);

  @override
  ConsumerState<ShopWithdrawChoosePage> createState() =>
      _ShopWithdrawChoosePageState();
}

class _ShopWithdrawChoosePageState extends ConsumerState<ShopWithdrawChoosePage>
    with ShopWithdrawChooseProviders {
  @override
  void initState() {
    super.initState();

    ref.read(manager.notifier).change(
          datas: ShopWithdrawAccountModel.samples,
          selectedModel: widget.model,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: const Text('选择账号'),
        actions: [
          TextButton(
            onPressed: pushWithdrawAdd,
            child: const Text(
              '添加',
              style: TextStyle(color: Colours.text),
            ),
          )
        ],
      ),
      body: Consumer(builder: (context, ref, _) {
        final items = ref.watch(datas);
        return ListView.separated(
          padding: const EdgeInsets.only(left: 16, right: 16),
          itemBuilder: (context, index) {
            final model = items[index];
            return _chooseItem(model);
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: items.length,
        );
      }),
    );
  }

  Widget _chooseItem(ShopWithdrawAccountModel model) {
    return InkWell(
      onTap: () {
        ref.read(manager.notifier).change(selectedModel: model);
        NavigatorUtils.pop(context, result: model);
      },
      child: Consumer(builder: (_, ref, __) {
        final current = ref.watch(selectedModel);
        return ShopWithdrawAccount(
          key: ValueKey(model.toString()),
          model: model,
          style: current == model
              ? ShopWithdrawAccountStyle.selected
              : ShopWithdrawAccountStyle.normal,
        );
      }),
    );
  }

  void pushWithdrawAdd() {
    NavigatorUtils.push(context, ShopRouter.withdrawAdd,
        resultCallback: (model) {
      if (model is ShopWithdrawAccountModel) {
        ref.read(manager.notifier).addAccount(model);
      }
    });
  }
}
