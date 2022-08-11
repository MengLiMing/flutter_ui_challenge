import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/text_styles.dart';

class GoodsHeadTitle extends StatefulWidget {
  final String title;
  final bool unfold;

  const GoodsHeadTitle({
    Key? key,
    required this.title,
    required this.unfold,
  }) : super(key: key);

  @override
  State<GoodsHeadTitle> createState() => _GoodsHeadTitleState();
}

class _GoodsHeadTitleState extends State<GoodsHeadTitle> {
  final Matrix4 normal = Matrix4.identity();

  Matrix4 get unfold => () {
        var result = Matrix4.identity();
        const offset = 10.0;
        result.translate(offset, offset);
        result.rotateZ(pi * 0.6);
        result.translate(-offset, -offset);
        return result;
      }();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, bottom: 16, top: 3),
      height: 49,
      child: Row(
        children: [
          Text(widget.title, style: TextStyles.textBold24),
          AnimatedRotation(
            turns: widget.unfold ? 0.5 : 0,
            duration: const Duration(milliseconds: 300),
            child: const Icon(Icons.keyboard_arrow_down, color: Colours.text),
          ),
        ],
      ),
    );
  }
}
