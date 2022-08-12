import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/menu_filter.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';

class GoodsTypeChoose extends StatefulWidget {
  final bool isShow;
  final VoidCallback onDismiss;

  const GoodsTypeChoose({
    Key? key,
    required this.isShow,
    required this.onDismiss,
  }) : super(key: key);

  @override
  State<GoodsTypeChoose> createState() => _GoodsTypeChooseState();
}

class _GoodsTypeChooseState extends State<GoodsTypeChoose> {
  @override
  Widget build(BuildContext context) {
    return MenuFilter(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      contentHeight: ScreenUtils.height - 93 - ScreenUtils.topPadding - 360,
      isShow: widget.isShow,
      onDismiss: widget.onDismiss,
      builder: (context) {
        return ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(title: Text('$index'));
          },
        );
      },
    );
  }
}
