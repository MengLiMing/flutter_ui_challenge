import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';

class StatisticsItem extends StatelessWidget {
  final String title;
  final Widget content;
  final VoidCallback onTap;

  const StatisticsItem({
    Key? key,
    required this.title,
    required this.content,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16.fit, right: 16.fit, bottom: 8.fit),
      padding: EdgeInsets.all(16.fit),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10.fit),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xffDCE7FA).withOpacity(0.5),
            offset: Offset(0, 2.fit),
            blurRadius: 8.fit,
            spreadRadius: 2.fit,
          ),
        ],
      ),
      height: 160.fit,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              LoadAssetImage(
                'statistic/icon_selected',
                height: 16.fit,
                width: 16.fit,
              ),
            ],
          ),
          SizedBox(height: 16.fit),
          Expanded(child: content),
        ],
      ),
    );
  }
}
