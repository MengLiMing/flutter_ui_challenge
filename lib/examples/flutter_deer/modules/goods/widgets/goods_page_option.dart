import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';

enum GoodsPageOption {
  scan,
  add,
}

extension GoodsPageOptionExtension on GoodsPageOption {
  String get title => ['扫码添加', '添加商品'][index];

  String get imgae => ['goods/scanning', 'goods/add2'][index];
}

class GoodsPageOptionView extends StatelessWidget {
  final ValueChanged<GoodsPageOption> onTap;

  const GoodsPageOptionView({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  List<GoodsPageOption> get values => GoodsPageOption.values;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        height: 68.fit,
        width: 120.fit,
        child: ListView.separated(
          padding: EdgeInsets.only(left: 16.fit, right: 16.fit),
          itemBuilder: (context, index) {
            final option = values[index];
            return GestureDetector(
              onTap: () => onTap(option),
              child: _OptionItemView(
                option: option,
              ),
            );
          },
          separatorBuilder: (_, __) => const Divider(),
          itemCount: values.length,
        ),
      ),
    );
  }
}

class _OptionItemView extends StatelessWidget {
  final GoodsPageOption option;

  const _OptionItemView({
    Key? key,
    required this.option,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34.fit,
      child: Row(
        children: [
          LoadAssetImage(
            option.imgae,
            width: 16.fit,
            height: 16.fit,
          ),
          SizedBox(width: 6.fit),
          Expanded(child: Text(option.title)),
        ],
      ),
    );
  }
}
