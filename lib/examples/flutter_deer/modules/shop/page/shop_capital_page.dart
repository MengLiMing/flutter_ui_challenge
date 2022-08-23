import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/my_app_bar.dart';

class ShopCapitalPage extends StatelessWidget {
  const ShopCapitalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: Text('资金管理'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildCard() {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: 375.fit, height: 204.fit),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            padding: EdgeInsets.only(left: 6, right: 6, top: 3),
            child: const LoadAssetImage(
              'account/bg',
              fit: BoxFit.fill,
            ),
          ),
          DefaultTextStyle(
            style: const TextStyle(
              fontSize: 12,
              color: Colours.textDisabled,
            ),
            child: Column(
              children: [
                SizedBox(height: 24.fit),
                const Text('当前余额(元)'),
                const SizedBox(height: 8),
                const Text(
                  '30.12',
                  style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: _priceColumn('累计结算金额', '20000.00'),
                      ),
                      Expanded(
                        child: _priceColumn('累计结算金额', '20000.00'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceColumn(String title, String price) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title),
        const SizedBox(height: 8),
        Text(
          price,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
