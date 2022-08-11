import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/order/models/order_models.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/order/order_router.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/order/widgets/order_details_payment_dialog.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/text_styles.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/navigator_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/dialog_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/string_extension.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/toast.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/custom_show_loading.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/custon_back_button.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';

class OrderDetailPage extends StatefulWidget {
  final String orderId;

  const OrderDetailPage({
    Key? key,
    required this.orderId,
  }) : super(key: key);

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  List<WidgetBuilder> _items = [];

  final loadingController = CustomShowLoadingController();

  @override
  void initState() {
    super.initState();
    loadingController.isLoading = true;

    Future.delayed(const Duration(seconds: 1)).then((value) {
      loadingController.isLoading = false;
      setState(() {
        loadSuccess();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomShowLoading(
      controller: loadingController,
      child: Scaffold(
        appBar: AppBar(
          leading: const CustomBackButton(),
          actions: [
            if (_items.isNotEmpty)
              TextButton(
                onPressed: () => NavigatorUtils.push(
                  context,
                  OrderRouter.track,
                  arguments: widget.orderId,
                ),
                child: const Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Text(
                    '订单跟踪',
                    style: TextStyle(
                      color: Colours.text,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                itemBuilder: (context, index) => _items[index](context),
                itemCount: _items.length,
              ),
            ),
            SafeArea(
              child: Container(
                height: 44,
                margin: const EdgeInsets.only(top: 10, left: 16, right: 16),
                child: Row(children: [
                  if (_items.isNotEmpty) ...[
                    Expanded(child: _refuseButton()),
                    const SizedBox(width: 17),
                    Expanded(child: _startButton()),
                  ],
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _refuseButton() {
    return MaterialButton(
      height: 44,
      color: const Color(0xffe1eafa),
      shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.zero)),
      elevation: 0,
      onPressed: () {
        Toast.show('拒单');
      },
      child: const Text('拒单', style: TextStyle(color: Colours.gradientBlue)),
    );
  }

  Widget _startButton() {
    return MaterialButton(
      height: 44,
      color: Colours.appMain,
      shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.zero)),
      elevation: 0,
      onPressed: () {
        DialogUtils.show(context, builder: (context) {
          return OrderDetailsPaymentDialog(
            handler: (PaymentType value) => Toast.show(
              value.desc,
            ),
          );
        });
      },
      child: const Text('开始配送', style: TextStyle(color: Colors.white)),
    );
  }
}

extension on _OrderDetailPageState {
  void loadSuccess() {
    /// 采用此种方式构造数据，可根据具体逻辑定制页面
    _items = [
      (context) =>
          sectionTitle('正在配送', topSpace: 3, style: TextStyles.textBold24),
      (context) => sectionTitle('客户信息'),
      (context) => userInfo(),
      (context) => space(16),
      (context) => sectionTitle('商品信息', bottomSpace: 0),
      for (int i = 0; i < 2; i++) (context) => goodInfo(),
      (context) => space(16),
      (context) => Column(children: [
            priceInfo('共2件商品', 50),
            priceInfo('配送费', 5),
            priceInfo('立减', -2.5),
            priceInfo('优惠券', -2.5),
            priceInfo('社区币折扣', -2.5),
            priceInfo('佣金', -1),
            Divider(),
            priceInfo('合计', 46.5, topSpace: 16),
            Divider(),
          ]),
      (context) => sectionTitle('订单信息', topSpace: 32),
      (context) => Column(
            children: [
              labelInfo('订单编号', '1212312321235435'),
              labelInfo('下单时间', '2018/08/26 12:20'),
              labelInfo('支付方式', '货到付款/支付宝'),
              labelInfo('配送方式', '送货上门'),
              labelInfo('客户备注', '无'),
            ],
          ),
      (context) => sectionTitle('发票信息', topSpace: 32),
      (context) => Column(
            children: [
              labelInfo('发票类型', '电子发票', width: 75),
              labelInfo('发票抬头', '某某科技', width: 75),
              labelInfo('发票内容', '办公用品', width: 75),
              labelInfo('收票人姓名', '姓名', width: 75),
              labelInfo('收票人手机', '13000000000', width: 75),
              labelInfo('收票人邮箱', '13014795306@163.com', width: 75),
            ],
          ),
    ];
  }

  /// 空白间距
  Widget space(double height) {
    return SizedBox(height: height);
  }

  /// 标题
  Widget sectionTitle(
    String title, {
    TextStyle style = TextStyles.textBold18,
    double topSpace = 16,
    double bottomSpace = 16,
  }) {
    return Container(
      margin: EdgeInsets.only(top: topSpace, bottom: bottomSpace),
      child: Text(title, style: style),
    );
  }

  /// 其他信息
  Widget labelInfo(
    String title,
    String content, {
    double bottomSpace = 8,
    double? width,
  }) {
    final style = const TextStyle(
      fontSize: 14,
      color: Colours.textGray,
      fontFeatures: [FontFeature.tabularFigures()],
    );
    return Padding(
      padding: EdgeInsets.only(bottom: bottomSpace),
      child: Row(
        children: [
          width == null
              ? Text(
                  title,
                  style: style,
                )
              : SizedBox(
                  width: width,
                  child: DefaultTextStyle(
                    style: style,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: title.split('').map((e) => Text(e)).toList(),
                    ),
                  ),
                ),
          Text(':', style: style),
          const SizedBox(width: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 14, color: Colours.text),
          ),
        ],
      ),
    );
  }

  /// 价格信息
  Widget priceInfo(
    String title,
    double price, {
    double topSpace = 0,
    double bottomSpace = 16,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: topSpace, bottom: bottomSpace),
      child: Row(
        children: [
          Expanded(child: Text(title)),
          Text(
            '${price < 0 ? '-' : ''}¥${price.abs()}',
            style:
                TextStyle(fontSize: 14, fontWeight: FontWeight.w600).copyWith(
              color: price < 0 ? Colours.red : null,
            ),
          ),
        ],
      ),
    );
  }

  /// 商品信息
  Widget goodInfo() {
    return Column(
      children: [
        const SizedBox(height: 15),
        Row(
          children: [
            const LoadAssetImage(
              'order/icon_goods',
              width: 56,
              height: 56,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: ScreenUtils.width - 80 - 100,
                          minWidth: ScreenUtils.width - 80 - 100,
                        ),
                        child: Text(
                          '日本纳鲁火多橙饮'.text,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Text('x1'),
                      const Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '¥25',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  const Text(
                    '玫瑰香 520ml',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colours.textGray,
                    ),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 4,
                    children: [
                      tagItem('立减2.50元', Colours.red),
                      tagItem('折扣2.50元', Colours.appMain),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        const Divider(),
      ],
    );
  }

  Widget tagItem(
    String content,
    Color bgColor,
  ) {
    return UnconstrainedBox(
      child: Container(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 1),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(2),
          ),
        ),
        child: Text(
          content,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// 客户信息
  Widget userInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const LoadAssetImage('order/icon_avatar', width: 44, height: 44),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('郭李'),
                  SizedBox(height: 8),
                  Align(
                      alignment: Alignment.bottomLeft,
                      child: Text('13014795306')),
                ],
              ),
            ),
            const SizedBox(
              width: 1,
              height: 24,
              child: ColoredBox(color: Colours.bgGray),
            ),
            GestureDetector(
              onTap: () => Toast.show('打电话'),
              child: const Padding(
                padding: EdgeInsets.only(left: 16),
                child: LoadAssetImage(
                  'order/icon_phone',
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const LoadAssetImage('order/icon_address',
                  width: 16.0, height: 16.0),
              const SizedBox(width: 4),
              Container(
                constraints:
                    BoxConstraints(maxWidth: ScreenUtils.width - 36 - 32),
                child: Text(
                  '西安市 雁塔区 唐兴路唐兴数码3楼318'.text,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_right,
                size: 16,
                color: Colours.text,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
