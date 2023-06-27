import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/navigator_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/toast.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/common_dialog.dart';

class GoodsSpecEdit extends StatefulWidget {
  final String? spec;

  const GoodsSpecEdit({
    Key? key,
    this.spec,
  }) : super(key: key);

  @override
  State<GoodsSpecEdit> createState() => _GoodsSpecEditState();
}

class _GoodsSpecEditState extends State<GoodsSpecEdit> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget.spec ?? '';
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void ensureAction() {
    if (controller.text.isEmpty) {
      Toast.show('请输入文字');
      return;
    }
    NavigatorUtils.pop(context, result: controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: '规格名称',
      isEdit: true,
      keyboardSpace: 20,
      onEnsure: ensureAction,
      children: [
        const SizedBox(height: 16),
        Container(
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colours.bgGray_,
            borderRadius: BorderRadius.circular(2.0),
          ),
          margin: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
          child: TextFormField(
            onEditingComplete: ensureAction,
            autofocus: true,
            controller: controller,
            decoration: const InputDecoration(
              isCollapsed: true,
              border: InputBorder.none,
              hintText: '输入文字',
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
