import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/model/shop_config_model/shop_config_model.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/provider/shop_config_providers.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/shop_router.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/widgets/shop_config_freight.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/widgets/shop_config_payment.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/widgets/shop_config_price_edit.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/text_styles.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/navigator_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/dialog_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/my_app_bar.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/my_edit_scroll_view.dart';

class ShopConfigPage extends ConsumerStatefulWidget {
  const ShopConfigPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ShopConfigPage> createState() => _ShopConfigPageState();
}

class _ShopConfigPageState extends ConsumerState<ShopConfigPage>
    with ShopConfigProviders {
  @override
  void initState() {
    super.initState();

    ref.read(manager.notifier).change(
          desc: '零食铺子坚果饮料美酒佳肴',
          sevice: '假一赔十',
          freightScale: '1、订单金额<20元，配送费为订单金额的1% \n2、订单金额≥20元，配送费为订单金额的1%',
          freightBreaks: '10.00',
          freightCost: '1.00',
          phone: '13014795306',
          address: '陕西省 西安市 长安区 郭杜镇 郭北村韩林路圣方医院斜对面',
        );
  }

  void commitAction() {
    // final json = ref.read(manager).model.toJson();
    // print(json);
    NavigatorUtils.pop(context);
  }

  void choosePayment() {
    DialogUtils.show(context, builder: (context) {
      return ShopConfigPayment(
        payments: ref.read(manager).model.payment,
      );
    }).then((value) {
      if (value is List<ShopPaymentStyle>) {
        ref.read(manager.notifier).change(payment: value);
      }
    });
  }

  void freightConfig() {
    DialogUtils.show(context, builder: (context) {
      return ShopConfigFreight(
        config: ref.read(manager).model.freightConfig,
      );
    }).then((value) {
      if (value is ShopFreightConfig) {
        ref.read(manager.notifier).change(freightConfig: value);
      }
    });
  }

  void freightBreaks() {
    DialogUtils.show(context, builder: (context) {
      return ShopConfigPriceEditDialog(
        title: "配送费满免",
        content: ref.read(manager).model.freightBreaks,
      );
    }).then((value) {
      if (value is String) {
        ref.read(manager.notifier).change(freightBreaks: value);
      }
    });
  }

  void freightCost() {
    DialogUtils.show(context, builder: (context) {
      return ShopConfigPriceEditDialog(
        title: '配送费用',
        content: ref.read(manager).model.freightCost,
      );
    }).then((value) {
      if (value is String) {
        ref.read(manager.notifier).change(freightCost: value);
      }
    });
  }

  void configEdit({
    required String title,
    required String content,
    required String hint,
    required int maxLength,
    TextInputType keyboardType = TextInputType.text,
    required ValueChanged<String> onChanged,
  }) {
    NavigatorUtils.push(context, ShopRouter.configEdit,
        arguments: ShopConfigEditParameter(
            title: title,
            content: content,
            hint: hint,
            keyboardType: keyboardType,
            maxLength: maxLength), resultCallback: (value) {
      if (value is String) {
        onChanged(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const MyAppBar(),
      body: MyEditScrollView(
        padding: EdgeInsets.only(left: 16.fit),
        bottom: _bottomButton(),
        bottomHeight: 16 + max(ScreenUtils.bottomPadding, 8) + 44.fit,
        children: children(),
      ),
    );
  }

  List<Widget> children() {
    final state = ref.watch(manager);
    final notifier = ref.read(manager.notifier);
    return [
      _changeBusiness(state.model.isBusiness),

      /// 基础设置
      _title('基础设置'),
      _item(
        title: '店铺简介',
        content: state.model.desc,
        textAlign: TextAlign.right,
        onTap: () {
          configEdit(
            title: '店铺简介',
            content: state.model.desc,
            hint: '这里又一段完美的简介...',
            maxLength: 30,
            onChanged: (value) {
              notifier.change(desc: value);
            },
          );
        },
      ),
      _item(
        title: '保障服务',
        content: state.model.sevice,
        textAlign: TextAlign.right,
        onTap: () {
          configEdit(
            title: '保障服务',
            content: state.model.sevice,
            hint: '这里又一段完美的说明...',
            maxLength: 30,
            onChanged: (value) {
              notifier.change(sevice: value);
            },
          );
        },
      ),
      _item(
        title: '支付方式',
        content: state.model.payment.map((e) => e.title).join('+'),
        textAlign: TextAlign.right,
        onTap: choosePayment,
      ),

      /// 运费设置
      _title('运费设置'),
      _item(
        title: '运费配置',
        content: state.model.freightConfig.title,
        textAlign: TextAlign.right,
        onTap: freightConfig,
      ),
      if (state.model.freightConfig == ShopFreightConfig.scale) ...[
        _item(
          title: '运费比例',
          content: state.model.freightScale,
          maxLines: null,
          textAlign: TextAlign.left,
          onTap: () {},
        ),
      ] else ...[
        _item(
          title: '运费减免',
          content: state.model.freightBreaks,
          textAlign: TextAlign.right,
          onTap: freightBreaks,
        ),
        _item(
          title: '配送费用',
          content: state.model.freightCost,
          textAlign: TextAlign.right,
          onTap: freightCost,
        ),
      ],

      // 联系信息
      _title('练习信息'),
      _item(
        title: '联系电话',
        content: state.model.phone,
        textAlign: TextAlign.right,
        onTap: () {
          configEdit(
            title: '联系电话',
            content: state.model.phone,
            hint: '这里有一串神秘的数字...',
            keyboardType: TextInputType.number,
            maxLength: 11,
            onChanged: (value) {
              notifier.change(phone: value);
            },
          );
        },
      ),
      _item(
        title: '店铺地址',
        content: state.model.address,
        maxLines: null,
        textAlign: TextAlign.left,
        onTap: () {
          configEdit(
            title: '店铺地址',
            content: state.model.address,
            hint: '这里有一个神秘的地址...',
            maxLength: 100,
            onChanged: (value) {
              notifier.change(address: value);
            },
          );
        },
      ),
    ];
  }

  Widget _title(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 32.fit, bottom: 16.fit),
      child: Text(
        title,
        style: TextStyles.textBold18,
      ),
    );
  }

  Widget _item({
    required String title,
    required String content,
    int? maxLines = 1,
    TextAlign? textAlign,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// 这个还是尽量少使用，我这里就是想用一下，最好还是使用其他方式
          IntrinsicHeight(
            child: Row(
              children: [
                SizedBox(height: 50.fit),
                Container(
                  padding: EdgeInsets.only(top: 16.fit),
                  alignment: Alignment.topLeft,
                  child: Text(title),
                ),
                SizedBox(width: 60.fit),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 16.fit, bottom: 16.fit),
                    alignment: Alignment.centerRight,
                    child: Text(
                      content,
                      maxLines: maxLines,
                      textAlign: textAlign,
                      overflow: maxLines == null ? null : TextOverflow.ellipsis,
                      style:
                          const TextStyle(height: 1.4, color: Colours.textGray),
                    ),
                  ),
                ),
                SizedBox(width: 8.fit),
                Container(
                  padding: EdgeInsets.only(top: 18.fit),
                  alignment: Alignment.topLeft,
                  child: LoadAssetImage(
                    'ic_arrow_right',
                    height: 16.fit,
                    width: 16.fit,
                  ),
                ),
                SizedBox(width: 16.fit),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget _changeBusiness(bool isBusiness) {
    return Padding(
      padding: EdgeInsets.only(top: 3.fit),
      child: Row(
        children: [
          Expanded(
            child: Text(
              isBusiness ? '正在营业' : '暂停营业',
              style: TextStyles.textBold24,
            ),
          ),
          Switch.adaptive(
            value: isBusiness,
            onChanged: (value) {
              ref.read(manager.notifier).change(isBusiness: value);
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget _bottomButton() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: 8,
        left: 16,
        right: 16,
        bottom: max(ScreenUtils.bottomPadding, 8),
      ),
      child: Consumer(
        builder: (context, ref, _) {
          final value = ref.watch(canCommit);
          return MaterialButton(
            color: value ? Colours.appMain : Colours.buttonDisabled,
            minWidth: double.infinity,
            elevation: 0,
            height: 44.fit,
            onPressed: () {
              if (value == false) return;
              commitAction();
            },
            child: const Text('提交', style: TextStyle(color: Colors.white)),
          );
        },
      ),
    );
  }
}
