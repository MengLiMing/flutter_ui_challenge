import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/statistics/widgets/statistics_calendar.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/statistics/widgets/statistics_order_item.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/my_app_bar.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/my_scroll_view.dart';

enum StatisticsInfoStyle {
  order,
  gmv,
}

extension on StatisticsInfoStyle {
  String get title {
    switch (this) {
      case StatisticsInfoStyle.order:
        return '订单统计';
      case StatisticsInfoStyle.gmv:
        return '交易额统计';
    }
  }
}

class StatisticsInfoPage extends StatelessWidget {
  final StatisticsInfoStyle style;

  const StatisticsInfoPage({
    Key? key,
    required this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: Text(style.title),
      ),
      body: MyScrollView(
        children: [
          const StatisticsCalendar(),
          _contentTitle(),
          const StatisticsOrderItem(
            bgColor: Colours.appMain,
            title: '全部订单',
            numbers: [500, 600, 400, 500, 300, 500, 600],
          ),
          // const StatisticsOrderItem(
          //   bgColor: Color(0xFFFFAA33),
          //   title: '完成订单',
          //   numbers: [650, 550, 300, 500, 400, 700, 550],
          // ),
          // const StatisticsOrderItem(
          //   bgColor: Colours.red,
          //   title: '取消订单',
          //   numbers: [400, 250, 400, 300, 550, 450, 350],
          // ),
        ],
      ),
    );
  }

  Widget _contentTitle() {
    return Container(
      padding: EdgeInsets.only(
        top: 32.fit,
        left: 16.fit,
        bottom: 16.fit,
      ),
      child: const Text(
        '订单走势',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
