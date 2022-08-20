import 'package:flutter/material.dart';
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
    return SliverGrid(
      delegate: SliverChildBuilderDelegate((context, index) {
        return ShopActionItem(itemData: actions[index]);
      }, childCount: actions.length),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        crossAxisSpacing: 16,
        maxCrossAxisExtent: 70,
        childAspectRatio: 70 / 88,
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
          const SizedBox(height: 12),
          LoadAssetImage(
            itemData.image,
            width: 32,
            height: 32,
          ),
          const SizedBox(height: 4),
          Text(itemData.title),
        ],
      ),
    );
  }
}
