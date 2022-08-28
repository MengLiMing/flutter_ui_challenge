import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';

class ShopAction {
  final String title;
  final String image;
  final VoidCallback onTap;

  const ShopAction({
    required this.title,
    required this.image,
    required this.onTap,
  });
}

class ShopActions extends StatelessWidget {
  final List<ShopAction> actions;

  const ShopActions({
    Key? key,
    required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(
        left: 8.fit,
        right: 8.fit,
      ),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          return ShopActionItem(itemData: actions[index]);
        }, childCount: actions.length),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          crossAxisSpacing: 0,
          maxCrossAxisExtent: 80.fit,
          childAspectRatio: 80 / 88,
        ),
      ),
    );
  }
}

class ShopActionItem extends StatelessWidget {
  final ShopAction itemData;
  const ShopActionItem({
    Key? key,
    required this.itemData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: itemData.onTap,
      child: Column(
        children: [
          SizedBox(height: 12.fit),
          LoadAssetImage(
            itemData.image,
            width: 32.fit,
            height: 32.fit,
          ),
          SizedBox(height: 4.fit),
          Text(itemData.title),
        ],
      ),
    );
  }
}
