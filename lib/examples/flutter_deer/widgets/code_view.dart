import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef CodeInputedBuilder = Widget Function(
  BuildContext context,
  String value,
  int index,
);

typedef CodeItemBuilder = Widget Function(
  BuildContext context,
  int index,
);

class CodeView extends StatefulWidget {
  final int length;

  /// 已经输入的
  final CodeInputedBuilder hadInputBuilder;

  /// 正在输入的
  final CodeItemBuilder inputtingBuilder;

  /// 未输入
  final CodeItemBuilder noInputBuilder;

  /// 间隔
  final CodeItemBuilder? spaceBuilder;

  final ValueChanged<String>? codeChanged;

  /// 是否输入完成后自动unfocus
  final bool autofocus;

  final bool autoUnfocus;

  const CodeView({
    Key? key,
    required this.length,
    this.autofocus = false,
    this.autoUnfocus = true,
    required this.hadInputBuilder,
    required this.inputtingBuilder,
    required this.noInputBuilder,
    this.spaceBuilder,
    this.codeChanged,
  }) : super(key: key);

  @override
  State<CodeView> createState() => _CodeViewState();
}

class _CodeViewState extends State<CodeView> {
  late TextEditingController _textEditingController;

  final FocusNode _focusNode = FocusNode();

  String _currentValue = "";

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();

    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inputTexts = _currentValue.split('');
    List<Widget> children = [];

    for (int i = 0; i < widget.length; i++) {
      if (i != 0) {
        final space = widget.spaceBuilder?.call(context, i);
        if (space != null) {
          children.add(space);
        }
      }

      if (inputTexts.length > i) {
        children.add(Expanded(
          child: widget.hadInputBuilder(context, inputTexts[i], i),
        ));
      } else {
        if (inputTexts.length == i) {
          children.add(Expanded(child: widget.inputtingBuilder(context, i)));
        } else {
          children.add(Expanded(child: widget.noInputBuilder(context, i)));
        }
      }
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Opacity(
          opacity: 0,
          child: EditableText(
            autofocus: widget.autofocus,
            controller: _textEditingController,
            focusNode: _focusNode,
            style: TextStyle(
              color: Colors.transparent,
            ),
            cursorColor: Colors.transparent,
            backgroundCursorColor: Colors.transparent,
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(widget.length),
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (value) {
              widget.codeChanged?.call(value);
              setState(() {
                _currentValue = value;
                if (value.split('').length == widget.length &&
                    widget.autoUnfocus) {
                  _focusNode.unfocus();
                }
              });
            },
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            final focusScope = FocusScope.of(context);
            if (focusScope.hasFocus) {
              focusScope.unfocus();
            } else {
              Future.delayed(
                  Duration.zero, () => focusScope.requestFocus(_focusNode));
            }
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        ),
      ],
    );
  }
}
