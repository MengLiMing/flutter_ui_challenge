import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/text_styles.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/common_dialog.dart';

class AlertView extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onTap;

  const AlertView({
    Key? key,
    required this.title,
    required this.message,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      horizontalSpace: 40,
      title: title,
      children: [
        Container(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 10,
            bottom: 14,
          ),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyles.textSize16,
          ),
        ),
      ],
      onEnsure: onTap,
    );
  }
}
