import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/menu_filter.dart';

const double _itemHeight = 42;

class GoodsTypeChoose extends StatelessWidget {
  final bool isShow;
  final VoidCallback onDismiss;
  final int selectedIndex;

  final ValueChanged<int> onChoose;

  final List<GoodsTypeItem> datas;

  const GoodsTypeChoose({
    Key? key,
    required this.isShow,
    required this.onDismiss,
    required this.selectedIndex,
    required this.onChoose,
    required this.datas,
  }) : super(key: key);

  double get maxHeight =>
      ScreenUtils.height - 93 - ScreenUtils.topPadding - 360;

  @override
  Widget build(BuildContext context) {
    return MenuFilter(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      contentHeight: min(
          maxHeight,
          (datas.length - 0) * _itemHeight +
              8), // 感兴趣的可以修改此处的高度 (datas.length - some)，看看动画效果，对于电商类搜索框弹出，切换选项分类时，这样处理动画不会很僵硬
      isShow: isShow,
      onDismiss: onDismiss,
      builder: (context) {
        return ListView.builder(
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 8),
          itemBuilder: (context, index) {
            return InkWell(
              key: ValueKey(index),
              onTap: () => onChoose(index),
              child: _GoodsTypeChooseItem(
                data: datas[index],
                isSelected: index == selectedIndex,
              ),
            );
          },
          itemCount: datas.length,
        );
      },
    );
  }
}

class _GoodsTypeChooseItem extends StatelessWidget {
  final GoodsTypeItem data;
  final bool isSelected;

  const _GoodsTypeChooseItem({
    Key? key,
    required this.data,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        color: isSelected ? Colours.appMain : Colours.text,
        fontSize: 14,
      ),
      child: Container(
        height: _itemHeight,
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(data.title),
            ),
            Text('(${data.count})')
          ],
        ),
      ),
    );
  }
}

class GoodsTypeItem {
  final String title;
  final int count;

  const GoodsTypeItem({
    required this.title,
    required this.count,
  });
}
