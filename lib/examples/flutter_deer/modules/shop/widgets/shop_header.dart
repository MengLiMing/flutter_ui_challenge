import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';

class ShopHeader extends StatelessWidget {
  const ShopHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 16, top: 12, bottom: 24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ming - 刚刚好',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  children: const [
                    LoadAssetImage(
                      'shop/zybq',
                      width: 40.0,
                      height: 16.0,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '店铺账号:15236489562',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                )
              ],
            ),
          ),
          const ClipOval(
            child: LoadImage(
              'https://avatars.githubusercontent.com/u/19296728?s=400&u=7a099a186684090f50459c87176cf4d291a27ac7&v=4',
              holderImg: 'shop/tx',
              width: 56,
              height: 56,
            ),
          ),
        ],
      ),
    );
  }
}
