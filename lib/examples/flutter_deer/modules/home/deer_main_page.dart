import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/common/user_provider.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/goods/page/goods_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/home/providers/home_providers.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/order/page/order_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/page/shop_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/statistics/page/statistics_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/navigator_interpector.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/navigator_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/always_keep_alive.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';

class DeerMainPage extends ConsumerStatefulWidget {
  const DeerMainPage({Key? key}) : super(key: key);

  @override
  ConsumerState<DeerMainPage> createState() => _DeerMainPageState();
}

class _DeerMainPageState extends ConsumerState<DeerMainPage> {
  static const _tabImageSize = 25.0;
  final PageController _pageController = PageController();

  late List<Widget> _pageList;
  final List<BottomNavigationBarItem> _tabbarItems = const [
    BottomNavigationBarItem(
      icon: LoadAssetImage('home/icon_order', width: _tabImageSize),
      activeIcon: LoadAssetImage('home/icon_order',
          width: _tabImageSize, color: Colours.appMain),
      label: '订单',
      tooltip: '',
    ),
    BottomNavigationBarItem(
      icon: LoadAssetImage('home/icon_commodity', width: _tabImageSize),
      activeIcon: LoadAssetImage('home/icon_commodity',
          width: _tabImageSize, color: Colours.appMain),
      label: '商品',
      tooltip: '',
    ),
    BottomNavigationBarItem(
      icon: LoadAssetImage('home/icon_statistics', width: _tabImageSize),
      activeIcon: LoadAssetImage('home/icon_statistics',
          width: _tabImageSize, color: Colours.appMain),
      label: '统计',
      tooltip: '',
    ),
    BottomNavigationBarItem(
      icon: LoadAssetImage('home/icon_shop', width: _tabImageSize),
      activeIcon: LoadAssetImage('home/icon_shop',
          width: _tabImageSize, color: Colours.appMain),
      label: '店铺',
      tooltip: '',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _pageList = [
      const OrderPage(),
      const GoodsPage(),
      const StatisticsPage(),
      const ShopPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(UserProviders.isLogin, (previous, next) {
      if (next == false) {
        _pageController.jumpToPage(0);
        NavigatorUtils.popToRoot(context);
      }
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: Consumer(builder: (context, ref, _) {
        final index = ref.watch(homeIndexProvider);
        return BottomNavigationBar(
          items: _tabbarItems,
          onTap: (index) {
            if (index == 3) {
              /// 假装需要拦截登录
              LoginInterpector().interpector(context, () {
                _pageController.jumpToPage(index);
              });
            } else {
              _pageController.jumpToPage(index);
            }
          },
          type: BottomNavigationBarType.fixed,
          currentIndex: index,
          elevation: 5,
          iconSize: 21,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colours.unselectedItemColor,
        );
      }),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) =>
            ref.read(homeIndexProvider.state).state = index,
        children: _pageList.map((e) => AlwaysKeepAlive(child: e)).toList(),
      ),
    );
  }

  Future<Widget> userInfo() async {
    Completer<Widget> completer = Completer();
    final future = completer.future;

    /// 处理保存触发刷新的bug
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final widget = Consumer(
        builder: (context, ref, _) {
          final userinfo = ref.watch(UserProviders.userInfo);
          if (userinfo == null) {
            return const Text('未登录');
          } else {
            return Text('用户信息：${userinfo.name}');
          }
        },
      );
      completer.complete(widget);
    });

    return future;
  }
}
