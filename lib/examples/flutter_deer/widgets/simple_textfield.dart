import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/text_styles.dart';

class SimpleTextField extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final int? maxLength;
  final bool isSecret;
  final String hintText;
  final Widget? hintWidget;
  final bool Function()? isShowHint;
  final TextInputType? keyboardType;

  const SimpleTextField({
    Key? key,
    this.controller,
    this.focusNode,
    this.maxLength,
    this.isSecret = false,
    this.hintWidget,
    this.isShowHint,
    this.keyboardType,
    required this.hintText,
  }) : super(key: key);

  @override
  State<SimpleTextField> createState() => _SimpleTextFieldState();
}

class _SimpleTextFieldState extends State<SimpleTextField> {
  bool _hadShowHintWidget = false;

  @override
  void initState() {
    super.initState();

    _hadShowHintWidget = _canShowHintWidget;
    widget.controller?.addListener(_textChanged);
    widget.focusNode?.addListener(_textChanged);
  }

  void _textChanged() {
    if (_hadShowHintWidget != _canShowHintWidget) {
      _hadShowHintWidget = _canShowHintWidget;
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(covariant SimpleTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.controller?.removeListener(_textChanged);
    oldWidget.focusNode?.removeListener(_textChanged);
    widget.controller?.addListener(_textChanged);
    widget.focusNode?.addListener(_textChanged);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_textChanged);
    widget.focusNode?.removeListener(_textChanged);
    super.dispose();
  }

  bool get _canShowHintWidget =>
      widget.hintWidget != null && (widget.isShowHint?.call() ?? false);

  @override
  Widget build(BuildContext context) {
    // final themeData = Theme.of(context);

    final textField = TextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      maxLength: widget.maxLength,
      obscureText: widget.isSecret,
      keyboardType: widget.keyboardType,
      autofocus: false,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        border: InputBorder.none,
        // focusedBorder: UnderlineInputBorder(
        //   borderSide: BorderSide(
        //     color: themeData.primaryColor,
        //     width: 0.8,
        //   ),
        // ),
        // enabledBorder: UnderlineInputBorder(
        //   borderSide: BorderSide(
        //     color: Theme.of(context).dividerTheme.color!,
        //     width: 0.8,
        //   ),
        // ),
        hintText: widget.hintText,
        hintStyle: TextStyles.textHint14,
        counterText: '',
      ),
    );
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: textField),
              _hadShowHintWidget ? widget.hintWidget! : const SizedBox(),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}
