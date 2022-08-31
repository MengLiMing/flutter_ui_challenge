import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/model/shop_withdraw_models.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/provider/shop_withdraw_providers.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/shop_router.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/widgets/shop_pwd_dialog.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/widgets/shop_withdraw_account.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/text_styles.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/navigator_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/dialog_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/toast.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/custon_back_button.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/my_app_bar.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/my_scroll_view.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/simple_textfield.dart';

class ShopWithDrawPage extends ConsumerStatefulWidget {
  const ShopWithDrawPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ShopWithDrawPage> createState() => _ShopWithDrawPageState();
}

class _ShopWithDrawPageState extends ConsumerState<ShopWithDrawPage>
    with ShopWithdrawProviders {
  final TextEditingController editingController = TextEditingController();

  @override
  void dispose() {
    editingController.dispose();
    super.dispose();
  }

  void withdrawAction() {
    DialogUtils.show(context, builder: (context) {
      return const ShopPwdDialog();
    }).then((pwd) {
      if (pwd == null) return;
      if (pwd == '666666') {
        Toast.show('密码正确');
      } else {
        Toast.show('密码错误');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        leading: null,
        title: Row(
          children: const [
            CustomBackButton(),
            Text('提现'),
          ],
        ),
      ),
      body: MyScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          Consumer(
            builder: (context, ref, _) => InkWell(
              onTap: () {
                NavigatorUtils.push(context, ShopRouter.withdrawChoose,
                    arguments: ref.read(accountModel), resultCallback: (model) {
                  if (model is ShopWithdrawAccountModel) {
                    ref.watch(manager.notifier).change(accountModel: model);
                  }
                });
              },
              child: ShopWithdrawAccount(
                model: ref.watch(accountModel),
              ),
            ),
          ),
          withdrawMoney(),
          _withdrawStyleTitle(),
          _withdrawStyle(style: ShopWithdrawStyle.quick, children: const [
            TextSpan(text: '手续费按'),
            TextSpan(text: '0.3%', style: TextStyle(color: Colours.orange)),
            TextSpan(text: '收取'),
          ]),
          const Divider(),
          _withdrawStyle(style: ShopWithdrawStyle.normal, children: const [
            TextSpan(text: '预计'),
            TextSpan(
              text: 'T+1天到账(免手续费，T为工作日)',
              style: TextStyle(color: Colours.orange),
            ),
          ]),
          SizedBox(width: 24.fit),
          _commitButton(),
        ],
      ),
    );
  }

  Widget withdrawMoney() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Column(
        children: [
          Row(
            children: const [
              Expanded(
                child:
                    Text('提现金额', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
              Text(
                '单笔2万，单日2万',
                style: TextStyle(fontSize: 12, color: Colours.orange),
              )
            ],
          ),
          Row(
            children: [
              const Text('¥', style: TextStyles.textBold24),
              const SizedBox(width: 8),
              Expanded(
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Consumer(builder: (_, ref, __) {
                      return Text(
                        ref.watch(moneyIsNotEmpty) ? "" : '不能少于1元',
                        style: const TextStyle(
                            fontSize: 14, color: Colours.textGrayC),
                      );
                    }),
                    SimpleTextField(
                      hasLine: false,
                      controller: editingController,
                      hintText: '',
                      inputFormatters: [
                        UsNumberTextInputFormatter(max: 70),
                      ],
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                      onChanged: (value) {
                        ref.read(manager.notifier).change(money: value);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(),
          Row(
            children: [
              const Expanded(
                child: Text(
                  '最多可提现70元',
                  style: TextStyle(color: Colours.textGray, fontSize: 12),
                ),
              ),
              InkWell(
                onTap: () {
                  var all = "70";
                  editingController.text = all;
                  editingController.selection = TextSelection.collapsed(
                    offset: all.length,
                  );
                  ref.read(manager.notifier).change(money: all);
                },
                child: Container(
                  width: 100,
                  height: 32,
                  alignment: Alignment.centerRight,
                  child: const Text(
                    '全部提现',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colours.appMain,
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _withdrawStyleTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          const Text(
            '转出方式',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          Expanded(child: Container()),
          const LoadAssetImage('account/sm', width: 16.0),
        ],
      ),
    );
  }

  Widget _withdrawStyle(
      {required ShopWithdrawStyle style, required List<InlineSpan> children}) {
    return InkWell(
      onTap: () {
        NavigatorUtils.unfocus();
        ref.read(manager.notifier).change(withdrawStyle: style);
      },
      child: Consumer(
        builder: (_, ref, child) {
          final currentStyle = ref.watch(withdrawStyle);
          return SizedBox(
            height: 74.fit,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Positioned(
                  left: 0,
                  top: 16.fit,
                  child: LoadAssetImage(
                      currentStyle == style ? 'account/txxz' : 'account/txwxz',
                      width: 16.fit),
                ),
                Positioned(
                  left: 24.fit,
                  top: 0,
                  right: 0,
                  child: child!,
                ),
              ],
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 14.7.fit),
            Text(
              style.title,
              style: const TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8.fit),
            Text.rich(
              TextSpan(children: children),
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _commitButton() {
    return Consumer(builder: (_, ref, __) {
      return MaterialButton(
        elevation: 0,
        color: Colours.appMain,
        disabledColor: Colours.buttonDisabled,
        minWidth: double.infinity,
        height: 44,
        onPressed: ref.watch(canCommit) ? withdrawAction : null,
        child: const Text(
          '提现',
          style: TextStyle(color: Colors.white),
        ),
      );
    });
  }
}
