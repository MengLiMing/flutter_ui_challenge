import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/statistics/widgets/statistics_order_chart.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/image_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';

class StatisticsOrderItem extends StatelessWidget {
  final Color bgColor;
  final String title;
  final List<int> numbers;
  final TextSpan Function(int number) content;

  const StatisticsOrderItem({
    Key? key,
    required this.bgColor,
    required this.title,
    required this.numbers,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.fit,
      margin: EdgeInsets.only(left: 16.fit, right: 16.fit, bottom: 16.fit),
      padding: EdgeInsets.symmetric(vertical: 16.fit),
      decoration: BoxDecoration(
        color: bgColor,
        image: DecorationImage(
          image: ImageUtils.getAssetImage('statistic/chart_fg'),
          fit: BoxFit.fill,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(8.fit),
        ),
        boxShadow: [
          BoxShadow(
            color: bgColor.withOpacity(0.5),
            offset: Offset(0, 2.fit),
            blurRadius: 8.fit,
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DefaultTextStyle(
            style: const TextStyle(color: Colors.white, fontSize: 14),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.fit),
              child: Row(
                children: [
                  Expanded(child: Text(title)),
                  Text(
                      '${numbers.reduce((value, element) => value + element)}'),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.fit),
          Expanded(
            child: StatisticsOrderChart(
              numbers: numbers,
              bgColor: bgColor,
              horizontalSpace: 16.fit,
              content: (index) {
                return content(numbers[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
