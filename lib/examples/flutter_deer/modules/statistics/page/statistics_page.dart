import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/statistics/widgets/statistics_circle_chart.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/statistics/widgets/statistics_header_content.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/statistics/widgets/statistics_header_delegate.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/statistics/widgets/statistics_item.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/statistics/widgets/statistics_line_chart.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/statistics/widgets/statistics_line_painter.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/text_styles.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            _topHeader(),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 22.fit,
                  left: 16.fit,
                  bottom: 16.fit,
                ),
                child: const Text(
                  '数据走势',
                  style: TextStyles.textBold18,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: StatisticsItem(
                content: const StatisticsLineChart(
                  textColor: Color(0xFFD4E2FA),
                  lineColor: Color(0xFFAFCAFA),
                  datas: [0.6, 0.9, 0.3, 0.8, 0.3, 0.6, 0.8],
                  animationStyle: StatisticsLineAnimationStyle.horizontal,
                ),
                title: '订单统计',
                onTap: () {},
              ),
            ),
            SliverToBoxAdapter(
              child: StatisticsItem(
                content: const StatisticsLineChart(
                  textColor: Color(0xFFFFEACC),
                  lineColor: Color(0xFFFFDFB3),
                  datas: [0.9, 0.65, 0.3, 0.7, 0.6, 0.9, 0.6],
                  animationStyle: StatisticsLineAnimationStyle.vertical,
                ),
                title: '交易额统计',
                onTap: () {},
              ),
            ),
            SliverToBoxAdapter(
              child: StatisticsItem(
                content: const StatisticsCircleChart(
                  datas: [0.8, 0.5, 0.65],
                ),
                title: '商品统计',
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topHeader() {
    return const SliverPersistentHeader(
      delegate: StatisticsHeaderDelegate(
        content: StatisticsHeaderContent(),
      ),
      pinned: true,
      floating: false,
    );
  }
}
