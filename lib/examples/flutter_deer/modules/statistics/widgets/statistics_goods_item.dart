import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/statistics/models/statistics_goods_model.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/image_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';

class StatisticsGoodsItem extends StatelessWidget {
  final int index;
  final StatisticsGoodsItemModel model;

  const StatisticsGoodsItem({
    Key? key,
    required this.index,
    required this.model,
  }) : super(key: key);

  List<String> get levelImages => [
        'statistic/champion',
        'statistic/runnerup',
        'statistic/thirdplace',
      ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68.fit,
      margin: EdgeInsets.only(
        left: 16.fit,
        right: 16.fit,
        bottom: 8.fit,
      ),
      padding: EdgeInsets.only(right: 16.fit, top: 16.fit, bottom: 16.fit),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8.fit)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDCE7FA).withOpacity(0.5),
            offset: Offset(0, 2.fit),
            blurRadius: 8.fit,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _level(),
          Container(
            height: 36.fit,
            width: 36.fit,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.fit),
              border: Border.all(color: const Color(0xFFF7F8FA), width: 0.6),
              image: DecorationImage(
                image: ImageUtils.getAssetImage('order/icon_goods'),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          SizedBox(width: 16.fit),
          DefaultTextStyle(
            style: const TextStyle(fontSize: 12, color: Colours.textGray),
            child: Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          '饮料',
                          style: TextStyle(color: Colours.text),
                        ),
                        Text('250ml'),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('100件'),
                      Text('未支付'),
                    ],
                  ),
                  SizedBox(width: 24.fit),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('400件'),
                      Text('已支付'),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _level() {
    Widget content;
    if (levelImages.length > index) {
      content = LoadAssetImage(
        levelImages[index],
      );
    } else {
      content = Container(
        alignment: Alignment.center,
        width: 18.fit,
        height: 18.fit,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: model.color,
        ),
        child: Text(
          '${index + 1}',
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      );
    }
    return Container(
      alignment: Alignment.center,
      width: 60.fit,
      child: content,
    );
  }
}
