import 'dart:math';
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
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/my_app_bar.dart';

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
        appBar: MyAppBar(
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
                    '????????????',
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
            Container(
              height: 44,
              margin: EdgeInsets.only(
                  top: 10,
                  left: 16,
                  right: 16.0,
                  bottom: max(10, ScreenUtils.bottomPadding)),
              child: Row(children: [
                if (_items.isNotEmpty) ...[
                  Expanded(child: _refuseButton()),
                  const SizedBox(width: 17),
                  Expanded(child: _startButton()),
                ],
              ]),
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
        Toast.show('??????');
      },
      child: const Text('??????', style: TextStyle(color: Colours.gradientBlue)),
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
      child: const Text('????????????', style: TextStyle(color: Colors.white)),
    );
  }
}

extension on _OrderDetailPageState {
  void loadSuccess() {
    /// ??????????????????????????????????????????????????????????????????
    _items = [
      (context) =>
          sectionTitle('????????????', topSpace: 3, style: TextStyles.textBold24),
      (context) => sectionTitle('????????????'),
      (context) => userInfo(
            name: '??????',
            phone: '13014795306',
            address: '????????? ????????? ?????????????????????3???318',
          ),
      (context) => space(16),
      (context) => sectionTitle('????????????', bottomSpace: 0),
      for (int i = 0; i < 2; i++) (context) => goodInfo(),
      (context) => space(16),
      (context) => Column(children: [
            priceInfo('???2?????????', 50),
            priceInfo('?????????', 5),
            priceInfo('??????', -2.5),
            priceInfo('?????????', -2.5),
            priceInfo('???????????????', -2.5),
            priceInfo('??????', -1),
            const Divider(),
            priceInfo('??????', 46.5, topSpace: 16),
            const Divider(),
          ]),
      (context) => sectionTitle('????????????', topSpace: 32),
      (context) => Column(
            children: [
              labelInfo('????????????', '1212312321235435'),
              labelInfo('????????????', '2018/08/26 12:20'),
              labelInfo('????????????', '????????????/?????????'),
              labelInfo('????????????', '????????????'),
              labelInfo('????????????', '???'),
            ],
          ),
      (context) => sectionTitle('????????????', topSpace: 32),
      (context) => Column(
            children: [
              labelInfo('????????????', '????????????', width: 75),
              labelInfo('????????????', '????????????', width: 75),
              labelInfo('????????????', '????????????', width: 75),
              labelInfo('???????????????', '??????', width: 75),
              labelInfo('???????????????', '13000000000', width: 75),
              labelInfo('???????????????', '13014795306@163.com', width: 75),
            ],
          ),
    ];
  }

  /// ????????????
  Widget space(double height) {
    return SizedBox(height: height);
  }

  /// ??????
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

  /// ????????????
  Widget labelInfo(
    String title,
    String content, {
    double bottomSpace = 8,
    double? width,
  }) {
    const style = TextStyle(
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
                  width: width.fit,
                  child: DefaultTextStyle(
                    style: style,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: title.split('').map((e) => Text(e)).toList(),
                    ),
                  ),
                ),
          const Text(':', style: style),
          SizedBox(width: 8.fit),
          Text(
            content,
            style: const TextStyle(fontSize: 14, color: Colours.text),
          ),
        ],
      ),
    );
  }

  /// ????????????
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
            '${price < 0 ? '-' : ''}??${price.abs()}',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)
                .copyWith(
              color: price < 0 ? Colours.red : null,
            ),
          ),
        ],
      ),
    );
  }

  /// ????????????
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
                          '????????????????????????'.text,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Text('x1'),
                      const Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '??25',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '????????? 520ml',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colours.textGray,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 4,
                    children: [
                      tagItem('??????2.50???', Colours.red),
                      tagItem('??????2.50???', Colours.appMain),
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

  /// ????????????
  Widget userInfo({
    required String name,
    required String phone,
    required String address,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LoadAssetImage('order/icon_avatar', width: 44.fit, height: 44.fit),
            SizedBox(width: 8.fit),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name),
                  SizedBox(height: 8.fit),
                  Align(alignment: Alignment.bottomLeft, child: Text(phone)),
                ],
              ),
            ),
            SizedBox(
              width: 1,
              height: 24.fit,
              child: const ColoredBox(color: Colours.bgGray),
            ),
            GestureDetector(
              onTap: () => Toast.show('?????????'),
              child: Padding(
                padding: EdgeInsets.only(left: 16.fit),
                child: LoadAssetImage(
                  'order/icon_phone',
                  width: 24.fit,
                  height: 24.fit,
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
              LoadAssetImage('order/icon_address',
                  width: 16.fit, height: 16.fit),
              SizedBox(width: 4.fit),
              Container(
                constraints: BoxConstraints(
                    maxWidth: ScreenUtils.width - 36.fit - 32.fit),
                child: Text(
                  address.text,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_right,
                size: 16.fit,
                color: Colours.text,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
