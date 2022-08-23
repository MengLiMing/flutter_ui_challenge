import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/my_scroll_view.dart';

/// 使用请关闭外部scaffold - resizeToAvoidBottomInset = false
class MyEditScrollView extends StatelessWidget {
  final List<Widget> children;

  final EdgeInsetsGeometry? padding;

  final Widget bottom;

  final double bottomHeight;

  const MyEditScrollView({
    Key? key,
    required this.children,
    this.padding,
    required this.bottom,
    required this.bottomHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Scaffold(
          resizeToAvoidBottomInset: true,
          body: MyScrollView(
            padding: padding,
            children: [
              ...children,
              SizedBox(
                height: bottomHeight,
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          bottom: 0,
          right: 0,
          height: bottomHeight,
          child: bottom,
        )
      ],
    );
  }
}
