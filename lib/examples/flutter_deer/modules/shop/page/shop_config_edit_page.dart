import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/navigator_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/custon_back_button.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/my_app_bar.dart';

class ShopConfigEditPage extends StatefulWidget {
  final String title;
  final String content;
  final String hint;
  final int maxLength;
  final TextInputType keyboardType;
  const ShopConfigEditPage({
    Key? key,
    required this.title,
    required this.content,
    required this.hint,
    required this.maxLength,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  State<ShopConfigEditPage> createState() => _ShopConfigEditPageState();
}

class _ShopConfigEditPageState extends State<ShopConfigEditPage> {
  final TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    editingController.text = widget.content;
  }

  void complete() {
    if (editingController.text.isEmpty) return;
    NavigatorUtils.pop(context, result: editingController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            const CustomBackButton(),
            Text(widget.title),
          ],
        ),
        actions: [
          TextButton(
            onPressed: complete,
            child: const Text(
              '完成',
              style: TextStyle(color: Colours.text),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 21, left: 16, right: 16),
        child: Column(
          children: [
            TextFormField(
              maxLines: 5,
              maxLength: widget.maxLength,
              autofocus: true,
              controller: editingController,
              keyboardType: widget.keyboardType,
              decoration: InputDecoration(
                hintText: widget.hint,
                border: InputBorder.none,
              ),
              onEditingComplete: complete,
            ),
            SizedBox(height: 21),
          ],
        ),
      ),
    );
  }
}
