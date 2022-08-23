import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/custon_back_button.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/my_app_bar.dart';

class ShopCityPage extends StatefulWidget {
  const ShopCityPage({Key? key}) : super(key: key);

  @override
  State<ShopCityPage> createState() => _ShopCityPageState();
}

class _ShopCityPageState extends State<ShopCityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: const [
            CustomBackButton(),
            Text('开户城市'),
          ],
        ),
      ),
    );
  }
}
