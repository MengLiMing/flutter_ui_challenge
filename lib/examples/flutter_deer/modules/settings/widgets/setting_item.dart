import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';

class SettingItem extends StatelessWidget {
  final String title;

  final VoidCallback onTap;

  final String? content;

  const SettingItem({
    Key? key,
    required this.title,
    required this.onTap,
    this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        padding: const EdgeInsets.only(left: 16),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colours.text, fontSize: 14),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        content ?? '',
                        style: const TextStyle(
                            color: Colours.textGray, fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const LoadAssetImage(
                    'ic_arrow_right',
                    width: 14,
                    height: 14,
                  ),
                  const SizedBox(width: 16),
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
