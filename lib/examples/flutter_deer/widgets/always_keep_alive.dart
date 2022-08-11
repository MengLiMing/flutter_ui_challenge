import 'package:flutter/material.dart';

class AlwaysKeepAlive extends StatefulWidget {
  final Widget child;

  const AlwaysKeepAlive({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<AlwaysKeepAlive> createState() => _AlwaysKeepAliveState();
}

class _AlwaysKeepAliveState extends State<AlwaysKeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
