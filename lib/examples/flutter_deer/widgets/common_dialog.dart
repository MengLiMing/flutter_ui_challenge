import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/text_styles.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/navigator_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/input_dialog.dart';

class CommonDialog extends StatelessWidget {
  final List<Widget> children;
  final String title;

  final VoidCallback onEnsure;
  final VoidCallback? onCancel;
  final double horizontalSpace;

  /// 是否是编辑弹窗
  final bool isEdit;

  /// isEdit 为true有用 弹出后距离键盘的距离 默认为0
  final double keyboardSpace;

  const CommonDialog({
    Key? key,
    required this.title,
    required this.children,
    required this.onEnsure,
    this.onCancel,
    this.keyboardSpace = 0,
    this.isEdit = false,
    this.horizontalSpace = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget result = _content(context);
    if (isEdit) {
      return InputDialog(
        keyboardSpace: keyboardSpace,
        child: result,
      );
    }
    return Center(child: result);
  }

  Widget _content(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalSpace),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(top: 24.fit),
            child: Text(title, style: TextStyles.textBold18),
          ),
          ...children,
          const Divider(),
          Row(
            children: [
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    NavigatorUtils.pop(context);
                    onCancel?.call();
                  },
                  child: const Text(
                    '取消',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colours.textGray,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 0.8,
                height: 50,
                child: ColoredBox(color: Colours.line),
              ),
              Expanded(
                child: MaterialButton(
                  onPressed: onEnsure,
                  child: const Text(
                    '确定',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colours.appMain,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
