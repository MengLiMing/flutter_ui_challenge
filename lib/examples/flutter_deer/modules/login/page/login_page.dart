import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/text_styles.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/simple_textfield.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pwdController = TextEditingController();
  final FocusNode phoneNode = FocusNode();
  final FocusNode pwdNode = FocusNode();

  ValueNotifier<bool> isSeret = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final List<Widget> _children = [
      const Text(
        '密码登录',
        style: TextStyles.textBold26,
      ),
      SizedBox(height: 16),
      SimpleTextField(
        key: const ValueKey('phone'),
        controller: phoneController,
        focusNode: phoneNode,
        maxLength: 11,
        hintText: '请输入账号',
        keyboardType: TextInputType.number,
        isShowHint: () {
          return phoneController.text.isNotEmpty && phoneNode.hasFocus;
        },
        hintWidget: GestureDetector(
          child: LoadAssetImage(
            'login/qyg_shop_icon_delete',
            width: 18.0,
            height: 40.0,
          ),
          onTap: () => phoneController.text = '',
        ),
      ),
      ValueListenableBuilder<bool>(
        valueListenable: isSeret,
        builder: (context, value, child) {
          return SimpleTextField(
            key: const ValueKey('pwd'),
            controller: pwdController,
            focusNode: pwdNode,
            hintText: '请输入密码',
            isSecret: value,
            keyboardType: TextInputType.number,
            isShowHint: () => true,
            hintWidget: GestureDetector(
              child: LoadAssetImage(
                value
                    ? 'login/qyg_shop_icon_hide'
                    : 'login/qyg_shop_icon_display',
                width: 18.0,
                height: 40.0,
              ),
              onTap: () {
                setState(() {
                  isSeret.value = !isSeret.value;
                });
              },
            ),
          );
        },
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: const CloseButton(),
        actions: [
          TextButton(
            onPressed: codeLogin,
            child: Text(
              '验证码登录',
              style: isDark ? TextStyles.textDark : TextStyles.text,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _children,
          ),
        ),
      ),
    );
  }

  void codeLogin() {}
}
