import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/navigator_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';

class MySearchBar extends StatefulWidget implements PreferredSizeWidget {
  final String backImg;

  final String hintText;

  final ValueChanged<String>? keywordChanged;

  final ValueChanged<String> onSearch;

  const MySearchBar({
    Key? key,
    required this.hintText,
    this.backImg = 'ic_back_black',
    this.keywordChanged,
    required this.onSearch,
  }) : super(key: key);

  @override
  State<MySearchBar> createState() => _MySearchBarState();

  @override
  Size get preferredSize => const Size.fromHeight(44);
}

class _MySearchBarState extends State<MySearchBar> {
  final editController = TextEditingController();

  @override
  void initState() {
    super.initState();

    editController.addListener(() {
      widget.keywordChanged?.call(editController.text);
    });
  }

  @override
  void dispose() {
    editController.dispose();
    super.dispose();
  }

  void searchAction() {
    NavigatorUtils.unfocus();
    final text = editController.text;
    widget.onSearch(text);
  }

  @override
  Widget build(BuildContext context) {
    final backButton = IconButton(
      onPressed: () => NavigatorUtils.pop(context),
      icon: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        child: LoadAssetImage(
          widget.backImg,
          width: 24,
          height: 24,
        ),
      ),
    );

    final textField = Expanded(
      child: Container(
        height: 32,
        decoration: const BoxDecoration(
            color: Colours.bgGray,
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: TextFormField(
          onEditingComplete: () {
            NavigatorUtils.unfocus();
            widget.onSearch(editController.text);
          },
          controller: editController,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: widget.hintText,
            contentPadding:
                const EdgeInsets.only(left: -8, right: -16, bottom: 14),
            border: const UnderlineInputBorder(borderSide: BorderSide.none),
            icon: const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8, left: 8),
              child: LoadAssetImage(
                'order/order_search',
                color: Colours.textGrayC,
              ),
            ),
            suffixIcon: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  editController.text = '';
                });
              },
              child: const Padding(
                padding: EdgeInsets.only(
                  top: 8,
                  bottom: 8,
                  left: 16,
                ),
                child: LoadAssetImage(
                  'order/order_delete',
                  color: Colours.textGrayC,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    final searchButton = MaterialButton(
      color: Colours.gradientBlue,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4))),
      elevation: 0,
      minWidth: 44,
      height: 32,
      onPressed: searchAction,
      child: const Text(
        '搜索',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
        child: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: SafeArea(
            child: Row(
              children: [
                backButton,
                textField,
                const SizedBox(width: 8),
                searchButton,
                const SizedBox(width: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
