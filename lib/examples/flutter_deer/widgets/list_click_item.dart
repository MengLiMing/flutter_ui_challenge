import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';

class ListClickItem extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  const ListClickItem({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(left: 16.fit),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 52.fit,
              child: Row(
                children: [
                  Expanded(child: Text(title)),
                  LoadAssetImage('ic_arrow_right',
                      height: 16.fit, width: 16.fit),
                  SizedBox(width: 16.fit),
                ],
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
