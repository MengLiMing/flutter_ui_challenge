import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/goods/models/goods_type_model/goods_type_model.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/goods/providers/goods_edit_providers.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/goods/providers/goods_type_choose_providers.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/goods/widgets/goods_spec_edit.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/goods/widgets/goods_type_choose_sheet.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/text_styles.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/dialog_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/toast.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/custom_show_loading.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/my_app_bar.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/my_edit_scroll_view.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/simple_textfield.dart';
import 'package:image_picker/image_picker.dart';

class GoodsEditPage extends ConsumerStatefulWidget {
  /// 简单标记，实际开发应该是id -请求数据或者直接传入数据
  final bool isEdit;

  const GoodsEditPage({
    Key? key,
    required this.isEdit,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GoodsEditPageState();
}

class _GoodsEditPageState extends ConsumerState<GoodsEditPage>
    with GoodsEditProviders {
  final ImagePicker _picker = ImagePicker();

  final ScrollController controller = ScrollController();

  final GoodsTypeChooseStateNotifier goodChooseNotifier =
      GoodsTypeChooseStateNotifier();

  final CustomShowLoadingController loadingController =
      CustomShowLoadingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      ref.read(manager.notifier).changeGoodsData(
            name: '我是默认商品名称',
            desc: '默认简介',
            price: 1,
            reducePrice: 1,
            discountPrice: 1,
            imageUrl:
                'https://avatars.githubusercontent.com/u/19296728?s=400&u=7a099a186684090f50459c87176cf4d291a27ac7&v=4',
          );
    }
  }

  /// 提交
  void commitAction() {
    ref.read(manager.notifier).commit();
  }

  Future<void> chooseImage() async {
    try {
      final result = await _picker.pickImage(
          source: ImageSource.gallery, imageQuality: 10);
      if (result != null) {
        ref.read(manager.notifier).setImage(File(result.path));
      }
    } catch (e) {
      if (e is MissingPluginException) {
        Toast.show('当前平台暂不支持！');
      } else {
        Toast.show('没有权限，无法打开相册！');
      }
    }
  }

  /// 选择类型
  void chooseGoodsType() {
    DialogUtils.show(context, builder: (context) {
      return GoodsTypeChooseSheet(notifier: goodChooseNotifier);
    }).then((value) {
      if (value is GoodsTypeModel) {
        ref.read(manager.notifier).changeGoodsData(goodsType: value.name);
      }
    });
  }

  /// 选择规格
  void chooseGoodsSpec() {
    DialogUtils.show(context, builder: (context) {
      return GoodsSpecEdit(
        spec: ref.read(goodsSpecChange),
      );
    }).then((value) {
      if (value is String && value.isNotEmpty) {
        ref.read(manager.notifier).changeGoodsData(goodsSpec: value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final readNotifier = ref.read(manager.notifier);
    final readGoodData = ref.read(goodsData);
    ref.listen<bool>(isLoading, (_, next) {
      loadingController.isLoading = next;
    });
    return CustomShowLoading(
      controller: loadingController,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: MyAppBar(
          title: Text(widget.isEdit ? '编辑商品' : "添加商品"),
        ),
        body: MyEditScrollView(
          bottomHeight: 16 + max(ScreenUtils.bottomPadding, 8) + 44,
          bottom: Container(
            color: Colors.white,
            padding: EdgeInsets.only(
              top: 8,
              left: 16,
              right: 16,
              bottom: max(ScreenUtils.bottomPadding, 8),
            ),
            child: Consumer(
              builder: (context, ref, _) {
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
              },
            ),
          ),
          padding: const EdgeInsets.only(left: 16),
          children: [
            sectionTitle('基本信息', top: 21),
            selectedImage(),
            space(16),
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
              readGoodData.price == 0 ? '' : readGoodData.price.toString(),
              (value) {
                /// 实际开发还是封装一下价格处理
                readNotifier.changeGoodsData(
                    price: double.tryParse(value) ?? 0);
              },
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
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
                  padding: const EdgeInsets.only(right: 16, left: 16),
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
                  const TextInputType.numberWithOptions(decimal: true),
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
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
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
          ],
        ),
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
              Text(title),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    content ?? hintText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: style,
                  ),
                ),
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
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: chooseImage,
                child: Image(
                  fit: BoxFit.cover,
                  image: ref.watch(goodsImage),
                  width: 96,
                  height: 96,
                ),
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
