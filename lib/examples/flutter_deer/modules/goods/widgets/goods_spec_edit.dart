import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/text_styles.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/navigator_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/toast.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/easy_segment/easy_segment.dart';

class GoodsSpecEdit extends StatefulWidget {
  final String? spec;

  const GoodsSpecEdit({
    Key? key,
    this.spec,
  }) : super(key: key);

  @override
  State<GoodsSpecEdit> createState() => _GoodsSpecEditState();
}

class _GoodsSpecEditState extends State<GoodsSpecEdit>
    with WidgetsBindingObserver {
  TextEditingController controller = TextEditingController();

  double itemHeight = 0;
  double keyBoardHeight = 0;

  final ValueNotifier<double> bottomOffset = ValueNotifier(0);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    controller.text = widget.spec ?? '';
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();

    keyBoardHeight = ScreenUtils.keyboardHeight;
  }

  void dealOffset() {
    bottomOffset.value =
        max(30, keyBoardHeight - (ScreenUtils.height - itemHeight) / 2);
  }

  @override
  void dispose() {
    controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ValueListenableBuilder<double>(
        valueListenable: bottomOffset,
        builder: (context, value, child) {
          return AnimatedPadding(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInCubic,
            padding: EdgeInsets.only(bottom: value),
            child: child,
          );
        },
        child: LayoutAfter(
          handler: (renderBox) {
            itemHeight = renderBox.size.height;
            dealOffset();
          },
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(left: 56, right: 56),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                )),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 24),
                const Text('规格名称', style: TextStyles.textBold18),
                const SizedBox(height: 16),
                Container(
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colours.bgGray_,
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                  margin: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
                  child: TextField(
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
                const Divider(),
                SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      Expanded(
                        child: MaterialButton(
                          onPressed: () {
                            NavigatorUtils.pop(context);
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
                        width: 1,
                        height: double.infinity,
                        child: ColoredBox(color: Colours.bgGray),
                      ),
                      Expanded(
                        child: MaterialButton(
                          onPressed: () {
                            if (controller.text.isEmpty) {
                              Toast.show('请输入文字');
                              return;
                            }
                            NavigatorUtils.pop(context,
                                result: controller.text);
                          },
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
