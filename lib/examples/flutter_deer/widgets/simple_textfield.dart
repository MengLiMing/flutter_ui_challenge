import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/text_styles.dart';

class SimpleTextField extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final int? maxLength;
  final bool isSecret;
  final String hintText;
  final TextStyle hintStyle;
  final Widget? hintWidget;
  final TextStyle style;
  final bool Function()? isShowHint;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final bool hasLine;
  final String? defaultText;
  final double height;
  final List<TextInputFormatter>? inputFormatters;
  final bool autofocus;

  const SimpleTextField({
    Key? key,
    this.controller,
    this.focusNode,
    this.maxLength,
    this.isSecret = false,
    this.hintWidget,
    this.isShowHint,
    this.keyboardType,
    this.onChanged,
    this.hasLine = true,
    this.height = 50,
    this.hintStyle = TextStyles.textHint14,
    this.style = TextStyles.text,
    this.defaultText,
    this.autofocus = false,
    this.inputFormatters,
    required this.hintText,
  }) : super(key: key);

  @override
  State<SimpleTextField> createState() => _SimpleTextFieldState();
}

class _SimpleTextFieldState extends State<SimpleTextField> {
  bool _hadShowHintWidget = false;

  TextEditingController? _controller;
  TextEditingController? get controller => widget.controller ?? _controller;

  @override
  void initState() {
    super.initState();

    conigController();

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

  void conigController() {
    if (widget.controller != null) {
      _controller?.dispose();
      _controller = null;
    } else {
      _controller ??= TextEditingController(text: widget.defaultText);
    }
    controller?.removeListener(_textChanged);
    controller?.addListener(_textChanged);
  }

  @override
  void didUpdateWidget(covariant SimpleTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.controller?.removeListener(_textChanged);
    oldWidget.focusNode?.removeListener(_textChanged);
    widget.focusNode?.addListener(_textChanged);
    conigController();
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
      inputFormatters: widget.inputFormatters ?? _getInputFormatters(),
      style: widget.style,
      controller: controller,
      focusNode: widget.focusNode,
      maxLength: widget.maxLength,
      obscureText: widget.isSecret,
      keyboardType: widget.keyboardType,
      autofocus: widget.autofocus,
      textInputAction: TextInputAction.done,
      onChanged: widget.onChanged,
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
        hintStyle: widget.hintStyle,
        counterText: '',
      ),
    );

    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: textField),
              _hadShowHintWidget ? widget.hintWidget! : const SizedBox(),
            ],
          ),
        ),
        if (widget.hasLine) const Divider(height: 1),
      ],
    );
  }

  List<TextInputFormatter>? _getInputFormatters() {
    if (widget.keyboardType ==
        const TextInputType.numberWithOptions(decimal: true)) {
      return <TextInputFormatter>[UsNumberTextInputFormatter()];
    }
    if (widget.keyboardType == TextInputType.number ||
        widget.keyboardType == TextInputType.phone) {
      return <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly];
    }
    return null;
  }
}

/// 数字、小数格式化（默认两位小数）
class UsNumberTextInputFormatter extends TextInputFormatter {
  UsNumberTextInputFormatter({this.digit = 2, this.max = 1000000});

  /// 允许输入的小数位数，-1代表不限制位数
  final int digit;

  /// 允许输入的最大值
  final double max;

  static const double _kDefaultDouble = 0.001;

  double _strToFloat(String str, [double defaultValue = _kDefaultDouble]) {
    try {
      return double.parse(str);
    } catch (e) {
      return defaultValue;
    }
  }

  ///获取目前的小数位数
  int _getValueDigit(String value) {
    if (value.contains('.')) {
      return value.split('.')[1].length;
    } else {
      return -1;
    }
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String value = newValue.text;
    int selectionIndex = newValue.selection.end;
    if (value == '.') {
      value = '0.';
      selectionIndex++;
    } else if (value != '' &&
            value != _kDefaultDouble.toString() &&
            _strToFloat(value) == _kDefaultDouble ||
        _getValueDigit(value) > digit ||
        _strToFloat(value) > max) {
      value = oldValue.text;
      selectionIndex = oldValue.selection.end;
    }
    return TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
