import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/navigator_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/toast.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/common_dialog.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/simple_textfield.dart';

class ShopConfigPriceEditDialog extends StatefulWidget {
  final String title;
  final String content;
  final String hint;
  const ShopConfigPriceEditDialog({
    Key? key,
    required this.title,
    required this.content,
    this.hint = '0.0',
  }) : super(key: key);

  @override
  State<ShopConfigPriceEditDialog> createState() =>
      _ShopConfigPriceEditDialogState();
}

class _ShopConfigPriceEditDialogState extends State<ShopConfigPriceEditDialog> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textEditingController.text = widget.content;
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      isEdit: true,
      title: widget.title,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colours.bgGray_,
            borderRadius: BorderRadius.all(
              Radius.circular(2),
            ),
          ),
          margin:
              EdgeInsets.only(top: 16.fit, bottom: 8.fit, left: 16, right: 16),
          padding: EdgeInsets.symmetric(horizontal: 16.fit),
          child: SimpleTextField(
            controller: textEditingController,
            height: 34.fit,
            hasLine: false,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            hintText: widget.hint,
            hintStyle: const TextStyle(color: Colours.textGrayC),
          ),
        ),
      ],
      onEnsure: () {
        final value = textEditingController.text;
        if (value.isEmpty) {
          Toast.show('请输入${widget.title}');
          return;
        }
        NavigatorUtils.pop(context, result: value);
      },
    );
  }
}
