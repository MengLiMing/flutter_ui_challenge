import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';

enum NumberKeyboardItemStyle {
  empty,
  number,
  delete,
  decimal,
}

class NumberKeyboardItem {
  final NumberKeyboardItemStyle style;
  final dynamic args;

  const NumberKeyboardItem({
    required this.style,
    this.args = null,
  });

  factory NumberKeyboardItem.number(int number) {
    return NumberKeyboardItem(
        style: NumberKeyboardItemStyle.number, args: number);
  }

  factory NumberKeyboardItem.decimal() {
    return const NumberKeyboardItem(style: NumberKeyboardItemStyle.decimal);
  }

  factory NumberKeyboardItem.delete() {
    return const NumberKeyboardItem(style: NumberKeyboardItemStyle.delete);
  }

  factory NumberKeyboardItem.empty() {
    return const NumberKeyboardItem(style: NumberKeyboardItemStyle.empty);
  }
}

class NumberKeyboard extends StatelessWidget {
  final VoidCallback onDelete;
  final ValueChanged<int> onTapNumber;
  final VoidCallback? onDecimal;

  late List<NumberKeyboardItem> items;

  NumberKeyboard({
    Key? key,
    required this.onDelete,
    required this.onTapNumber,
    this.onDecimal,
  }) : super(key: key) {
    items = List.generate(12, (index) {
      if (index < 9) {
        return NumberKeyboardItem.number(index + 1);
      } else if (index == 9) {
        if (onDecimal != null) {
          return NumberKeyboardItem.decimal();
        } else {
          return NumberKeyboardItem.empty();
        }
      } else if (index == 10) {
        return NumberKeyboardItem.number(0);
      } else {
        return NumberKeyboardItem.delete();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: true,
      child: Theme(
        data: ThemeData.dark(),
        child: Container(
          color: Colours.bgGray,
          padding: const EdgeInsets.only(top: 1),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
              childAspectRatio: 2,
            ),
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              switch (item.style) {
                case NumberKeyboardItemStyle.empty:
                  return Container();
                case NumberKeyboardItemStyle.number:
                  final number = item.args as int;
                  return Material(
                    color: Colors.white,
                    child: InkWell(
                      splashColor: Colours.bgGray,
                      highlightColor: Colours.bgGray,
                      onTap: () => onTapNumber(
                        number,
                      ),
                      child: Center(
                        child: Text(
                          '$number',
                          style: const TextStyle(
                            fontSize: 26,
                            color: Colours.text,
                          ),
                        ),
                      ),
                    ),
                  );
                case NumberKeyboardItemStyle.delete:
                  return InkWell(
                    onTap: () => onDelete(),
                    child: Container(
                      alignment: Alignment.center,
                      child: const LoadAssetImage('account/del', width: 32.0),
                    ),
                  );
                case NumberKeyboardItemStyle.decimal:
                  return InkWell(
                    onTap: () => onDecimal?.call(),
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.white,
                      child: const Text(
                        '·',
                        style: TextStyle(fontSize: 26),
                      ),
                    ),
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}
