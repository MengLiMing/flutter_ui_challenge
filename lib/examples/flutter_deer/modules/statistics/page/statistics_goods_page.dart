// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/statistics/provider/statistics_goods_providers.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/statistics/widgets/statistics_goods_circle_chart.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/statistics/widgets/statistics_goods_item.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/text_styles.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/custon_back_button.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/my_app_bar.dart';

class StatisticsGoodsPage extends ConsumerStatefulWidget {
  const StatisticsGoodsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<StatisticsGoodsPage> createState() =>
      _StatisticsGoodsPageState();
}

class _StatisticsGoodsPageState extends ConsumerState<StatisticsGoodsPage>
    with StatisticsGoodsProviders {
  @override
  void initState() {
    super.initState();
    ref.read(manager.notifier).initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        leading: const CustomBackButton(),
        actions: [
          Consumer(builder: (_, ref, __) {
            final style = ref.watch(this.style);
            return TextButton(
              onPressed: () {
                ref.read(manager.notifier).changeStyle(
                    style == StatisticsGoodsStyle.complete
                        ? StatisticsGoodsStyle.wating
                        : StatisticsGoodsStyle.complete);
              },
              child: Text(
                style == StatisticsGoodsStyle.complete ? "待配送" : "已配送",
                style: const TextStyle(color: Colours.text),
              ),
            );
          }),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  EdgeInsets.only(left: 16.fit, bottom: 16.fit, top: 3.fit),
              child: Consumer(
                builder: (_, ref, __) {
                  return Text(
                    ref.watch(style) == StatisticsGoodsStyle.wating
                        ? "待配送"
                        : "已配送",
                    style: TextStyles.textBold24,
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.fit),
              child: AspectRatio(
                aspectRatio: 1.5,
                child: Consumer(
                  builder: (_, ref, __) {
                    final state = ref.watch(manager);
                    return StatisticsGoodsCircleChart(
                      goodsModels: state.itemModels,
                      style: state.style,
                    );
                  },
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  EdgeInsets.only(left: 16.fit, bottom: 16.fit, top: 32.fit),
              child: const Text(
                '热销商品排行',
                style: TextStyles.textBold18,
              ),
            ),
          ),
          Consumer(builder: (_, ref, __) {
            final datas = ref.watch(itemModels);
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return StatisticsGoodsItem(
                    index: index,
                    model: datas[index],
                  );
                },
                childCount: datas.length,
              ),
            );
          }),
          SliverPadding(
            padding: EdgeInsets.only(
              bottom: max(20, ScreenUtils.bottomPadding),
            ),
          ),
        ],
      ),
    );
  }
}
