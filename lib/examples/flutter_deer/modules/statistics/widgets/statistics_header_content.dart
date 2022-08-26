import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';

class StatisticsHeaderContent extends StatelessWidget {
  const StatisticsHeaderContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        children: [
          Expanded(child: _item('statistic/xdd', '新订单(单)', '80')),
          Expanded(child: _item('statistic/dps', '待配送(单)', '80')),
          Expanded(child: _item('statistic/jrjye', '今日交易额(元)', '8000.00')),
        ],
      ),
    );
  }

  Widget _item(String image, String title, String content) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LoadAssetImage(
          image,
          width: 40.fit,
          height: 40.fit,
        ),
        SizedBox(height: 6.fit),
        Text(
          title,
          style: TextStyle(color: Colours.textGray, fontSize: 12),
        ),
        SizedBox(height: 6.fit),
        Text(
          content,
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}
