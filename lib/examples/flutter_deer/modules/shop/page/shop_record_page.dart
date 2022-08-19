import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/custon_back_button.dart';

class ShopRecordPage extends StatefulWidget {
  const ShopRecordPage({Key? key}) : super(key: key);

  @override
  State<ShopRecordPage> createState() => _ShopRecordPageState();
}

class _ShopRecordPageState extends State<ShopRecordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: const Text('账户流水'),
      ),
    );
  }
}
