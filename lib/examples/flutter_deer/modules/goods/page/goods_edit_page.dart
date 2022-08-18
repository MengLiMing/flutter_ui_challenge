import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/goods/providers/goods_edit_providers.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/text_styles.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/toast.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/custon_back_button.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/simple_textfield.dart';

class GoodsEditPage extends ConsumerStatefulWidget {
  const GoodsEditPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GoodsEditPageState();
}

class _GoodsEditPageState extends ConsumerState<GoodsEditPage>
    with GoodsEditProviders, WidgetsBindingObserver {
  final ValueNotifier<bool> showKeyboard = ValueNotifier(false);
  final ScrollController controller = ScrollController();

  final ValueNotifier<double> keyboardHeight = ValueNotifier(0);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    ref.read(manager.notifier).changeGoodsData(name: '我是默认商品名称');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  double _lastKeyboard = 0;

  @override
  void didChangeMetrics() {
    if (_lastKeyboard != ScreenUtils.keyboardHeight) {
      // SchedulerBinding.instance.addPostFrameCallback((timeStamp) {

      // });
      if (_lastKeyboard < ScreenUtils.keyboardHeight) {
        // 弹出键盘
        showKeyboard.value = true;
        showKeyboardAction();
      } else {
        // 隐藏键盘
        showKeyboard.value = false;
      }
    }
    keyboardHeight.value = ScreenUtils.keyboardHeight;
    _lastKeyboard = ScreenUtils.keyboardHeight;
  }

  /// 修改高度
  bool _showedKeyboard = false;
  void showKeyboardAction() {
    if (_showedKeyboard) return;

    _showedKeyboard = true;
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _showedKeyboard = false;
      print('键盘弹出了');
    });
  }

  /// 提交
  void commitAction() {
    ref.read(manager.notifier).commit();
  }

  /// 选择类型
  void chooseGoodsType() {}

  /// 选择规格
  void chooseGoodsSpec() {}

  @override
  Widget build(BuildContext context) {
    final readNotifier = ref.read(manager.notifier);
    final readGoodData = ref.read(goodsData);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: const Text('编辑商品'),
      ),
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Scaffold(
                  resizeToAvoidBottomInset: true,
                  body: SingleChildScrollView(
                    controller: controller,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(left: 16),
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sectionTitle('基本信息', top: 21),
                          selectedImage(),
                          textField(
                            '商品名称',
                            '填写商品名称',
                            readGoodData.name,
                            (value) {
                              readNotifier.changeGoodsData(name: value);
                            },
                          ),
                          textField(
                            '商品简介',
                            '填写简短描述',
                            readGoodData.desc,
                            (value) {
                              readNotifier.changeGoodsData(desc: value);
                            },
                          ),
                          textField(
                            '折后价格',
                            '填写商品单品折后价格',
                            readGoodData.price == 0
                                ? ''
                                : readGoodData.price.toString(),
                            (value) {
                              /// 实际开发还是封装一下价格处理
                              readNotifier.changeGoodsData(
                                  price: double.tryParse(value) ?? 0);
                            },
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                          ),
                          textField(
                            '商品条码',
                            '选填',
                            readGoodData.code,
                            (value) {
                              readNotifier.changeGoodsData(code: value);
                            },
                            rightWidgt: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () => Toast.show('扫描'),
                              child: Container(
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.only(right: 16, left: 16),
                                child: const LoadAssetImage('goods/scanning',
                                    width: 16.0, height: 16.0),
                              ),
                            ),
                          ),
                          textField(
                            '商品说明',
                            '选填',
                            readGoodData.remark,
                            (value) {
                              readNotifier.changeGoodsData(remark: value);
                            },
                          ),
                          sectionTitle('折扣立减', top: 32, bottom: 16),
                          textField(
                            '立减金额',
                            '0.0',
                            readGoodData.reducePrice == 0
                                ? ''
                                : readGoodData.reducePrice.toString(),
                            (value) {
                              readNotifier.changeGoodsData(
                                  reducePrice: double.tryParse(value) ?? 0);
                            },
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                          ),
                          textField(
                            '折扣金额',
                            '0.0',
                            readGoodData.discountPrice == 0
                                ? ''
                                : readGoodData.discountPrice.toString(),
                            (value) {
                              readNotifier.changeGoodsData(
                                  discountPrice: double.tryParse(value) ?? 0);
                            },
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                          ),
                          sectionTitle('类型规格', top: 32, bottom: 16),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: chooseGoodsType,
                            child: Consumer(builder: (context, ref, _) {
                              return typeChooseView(
                                '商品类型',
                                hintText: '选择商品类型',
                                content: ref.watch(goodsTypeChange),
                              );
                            }),
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: chooseGoodsSpec,
                            child: Consumer(builder: (context, ref, _) {
                              return typeChooseView(
                                '商品规格',
                                hintText: '对规格进行分类',
                                content: ref.watch(goodsSpecChange),
                              );
                            }),
                          ),
                          space(16),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: showKeyboard,
            builder: (context, value, child) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: 0, maxHeight: value ? 0 : double.infinity),
                child: child,
              );
            },
            child: Container(
              padding: EdgeInsets.only(
                top: 8,
                left: 16,
                right: 16,
                bottom: max(ScreenUtils.bottomPadding, 8),
              ),
              child: Consumer(builder: (context, ref, _) {
                final value = ref.watch(canCommit);
                return MaterialButton(
                  color: value ? Colours.appMain : Colours.buttonDisabled,
                  minWidth: double.infinity,
                  elevation: 0,
                  height: 44,
                  onPressed: () {
                    if (value == false) return;
                    commitAction();
                  },
                  child:
                      const Text('点击', style: TextStyle(color: Colors.white)),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget space(double height) {
    return SizedBox(height: height);
  }

  Widget typeChooseView(
    String title, {
    required String hintText,
    String? content,
  }) {
    final style = TextStyle(
        fontSize: 14,
        color: content == null ? Colours.textGrayC : Colours.text);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 50,
          child: Row(
            children: [
              Expanded(child: Text(title)),
              Text(
                content ?? hintText,
                style: style,
              ),
              const LoadAssetImage('ic_arrow_right', height: 16.0, width: 16.0),
              const SizedBox(width: 16),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget textField(
    String title,
    String hintText,
    String defaultText,
    ValueChanged<String> onChanged, {
    TextInputType keyboardType = TextInputType.text,
    Widget? rightWidgt,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 50,
          child: Row(
            children: [
              Text(title),
              const SizedBox(width: 16),
              Expanded(
                child: SimpleTextField(
                  defaultText: defaultText,
                  keyboardType: keyboardType,
                  hintText: hintText,
                  onChanged: onChanged,
                  hasLine: false,
                  hintStyle: TextStyles.textHint14.copyWith(
                    color: Colours.textGrayC,
                  ),
                ),
              ),
              if (rightWidgt != null) rightWidgt else const SizedBox(width: 16),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget sectionTitle(
    String title, {
    double top = 16,
    double bottom = 16,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: top, bottom: bottom),
      child: Text(
        title,
        style: TextStyles.textBold18,
      ),
    );
  }

  Widget selectedImage() {
    return Consumer(
      builder: (_, ref, __) {
        return SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                fit: BoxFit.contain,
                image: ref.watch(goodsImage),
                width: 96,
                height: 96,
              ),
              space(8),
              const Text(
                '点击添加商品图片',
                style: TextStyle(
                  fontSize: 14,
                  color: Colours.textGray,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
