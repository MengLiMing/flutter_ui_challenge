import 'package:flutter/material.dart';

class OverlayUtils {
  static OverlayEntry showEntry(
    BuildContext context,
    WidgetBuilder builder,
  ) {
    final entry = OverlayEntry(builder: builder);
    Overlay.of(context)?.insert(entry);
    return entry;
  }
}
