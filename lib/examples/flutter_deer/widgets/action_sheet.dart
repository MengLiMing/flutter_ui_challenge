import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/navigator_utils.dart';

class ActionSheet extends StatelessWidget {
  final List<Widget> items;

  const ActionSheet({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ColoredBox(
        color: Colors.white,
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: items,
          ),
        ),
      ),
    );
  }
}

extension ActionSheetItemProvider on Widget {
  static Widget actionText({
    required String text,
    Color textColor = Colours.text,
    double fontSize = 18,
    double height = 54,
    bool hadLine = true,
    EdgeInsets padding = const EdgeInsets.only(left: 16, right: 16),
    required ValueChanged<BuildContext>? onTap,
  }) {
    return Builder(builder: (context) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => onTap?.call(context),
        child: Container(
          height: height,
          padding: padding,
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              Center(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: textColor,
                  ),
                ),
              ),
              if (hadLine)
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Divider(),
                ),
            ],
          ),
        ),
      );
    });
  }

  static Widget actionTitle({
    required String title,
  }) {
    return ActionSheetItemProvider.actionText(
      text: title,
      fontSize: 16,
      height: 52,
      textColor: Colours.textGray,
      onTap: null,
    );
  }

  static Widget destructive({
    required String text,
    required ValueChanged<BuildContext> onTap,
  }) {
    return ActionSheetItemProvider.actionText(
      text: text,
      textColor: Colours.red,
      onTap: onTap,
    );
  }

  static Widget cancel({
    ValueChanged<BuildContext>? onTap,
  }) {
    return ActionSheetItemProvider.actionText(
      text: '取消',
      hadLine: false,
      padding: EdgeInsets.zero,
      onTap: (context) {
        if (onTap == null) {
          NavigatorUtils.pop(context);
        } else {
          onTap(context);
        }
      },
    );
  }
}
