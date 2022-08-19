import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/widgets/flutter_table_view.dart';
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
      body: FlutterTableView(
        sectionCount: 10,
        rowCount: (sectionIndex) {
          if (sectionIndex % 2 == 0) {
            return 40;
          } else {
            return 20;
          }
        },
      ),
    );
  }
}
