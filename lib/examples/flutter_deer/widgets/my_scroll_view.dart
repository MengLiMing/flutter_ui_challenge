import 'package:flutter/material.dart';

/// 总是能滑动
class MyScrollView extends StatelessWidget {
  final List<Widget> children;

  final EdgeInsetsGeometry? padding;

  const MyScrollView({
    Key? key,
    this.children = const [],
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        padding: padding,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight - (padding?.vertical ?? 0),
            minWidth: constraints.maxWidth - (padding?.horizontal ?? 0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      );
    });
  }
}
