import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/order/models/order_models.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/order/order_router.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/order/page/order_list_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/order/provider/order_header_provider.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/order/widgets/order_header.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/navigator_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/always_keep_alive.dart';

class OrderPage extends ConsumerStatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  ConsumerState<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends ConsumerState<OrderPage> {
  final _pageController = PageController();

  late final List<ScrollController?> _controllers;

  final items = OrderType.values.map((e) {
    var data = e.orderItemData;
    data.count = 10;
    return data;
  }).toList();

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(items.length, (index) => null);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void search() {
    NavigatorUtils.push(context, OrderRouter.search);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(HeaderProviders.tapIndex, (previous, next) {
      _pageController.jumpToPage(next as int);
    });

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: NestedScrollView(
          key: const Key('order_list'),
          physics: const ClampingScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverPersistentHeader(
                  delegate: OrderHeader(
                    maxHeight: 129.fit +
                        ScreenUtils.navBarHeight +
                        ScreenUtils.topPadding,
                    minHeight: 85.fit +
                        ScreenUtils.navBarHeight +
                        ScreenUtils.topPadding,
                    items: items,
                    onSearch: search,
                  ),
                  pinned: true,
                  floating: false,
                ),
              ),
            ];
          },
          body: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.depth == 0 &&
                  notification is ScrollEndNotification) {
                final index = _pageController.page?.round() ?? 0;
                if (index == _pageController.page &&
                    ref.read(HeaderProviders.stopIndex) != index) {
                  ref.read(HeaderProviders.stopIndex.state).state = index;
                  ref.read(HeaderProviders.tapIndex.state).state = index;
                }
              }
              return false;
            },
            child: PageView.builder(
              key: const Key('pageView'),
              itemBuilder: (_, index) {
                ScrollController scrollController;
                if (_controllers[index] != null) {
                  scrollController = _controllers[index]!;
                } else {
                  scrollController = ScrollController();
                  _controllers[index] = scrollController;
                }
                return AlwaysKeepAlive(
                    child: OrderListPage(
                  orderType: items[index].orderType,
                  controller: scrollController,
                  scrollOnTop: _scrolllToTop,
                ));
              },
              itemCount: items.length,
              controller: _pageController,
              onPageChanged: (index) {
                ref.read(HeaderProviders.pageIndex.state).state = index;
              },
            ),
          ),
        ),
      ),
    );
  }

  void _scrolllToTop(int index) {
    for (int i = 0; i < _controllers.length; i++) {
      if (i != index) {
        final controler = _controllers[i];
        if (controler != null && controler.hasClients) {
          controler.jumpTo(0);
        }
      }
    }
  }
}
