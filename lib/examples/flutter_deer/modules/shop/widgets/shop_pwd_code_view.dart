import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';

class ShopPwdCodeView extends StatelessWidget {
  final double radius;
  final double lineWidth;
  final List<int> pwd;
  final int pwdLength;
  final double height;
  final EdgeInsetsGeometry margin;

  const ShopPwdCodeView({
    Key? key,
    this.radius = 0,
    this.lineWidth = 1,
    this.pwd = const [],
    this.pwdLength = 6,
    this.height = 40,
    this.margin = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colours.textGrayC, width: lineWidth),
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (int i = 0; i < pwdLength; i++) ...[
            if (i != 0)
              Container(
                width: 1,
                height: double.infinity,
                color: Colours.textGrayC,
              ),
            if (pwd.length > i)
              Expanded(
                child: Center(
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: Container(),
              )
          ]
        ],
      ),
    );
  }
}
