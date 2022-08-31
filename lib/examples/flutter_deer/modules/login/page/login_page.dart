import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/common/deer_storage.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/common/user_provider.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/login/login_route.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/text_styles.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/navigator_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/my_app_bar.dart';
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

  ValueNotifier<bool> isChecked = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    phoneController.text = DeerStorage.phone;

    phoneController.addListener(_editChanged);

    pwdController.addListener(_editChanged);
  }

  void _editChanged() {
    isChecked.value = (phoneController.text.trim().length == 11) &
        pwdController.text.isNotEmpty;
  }

  @override
  void dispose() {
    phoneController.dispose();
    pwdController.dispose();
    super.dispose();
  }

  void _login() {
    _unfocus();

    final phone = phoneController.text.trim();

    /// 保存用户信息
    ref.read(UserProviders.userInfo.notifier).loginSuccess(DeerUserInfo(
          phone: phone,
          name: '刚刚好',
          token: "token",
        ));
  }

  void _forgetPwd() {
    _unfocus();
  }

  void _register() {
    _unfocus();
  }

  void _codeLogin() {
    _unfocus();
    NavigatorUtils.push(context, LoginRouter.codeLogin);
  }

  void _unfocus() {
    NavigatorUtils.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final isDark = themeData.brightness == Brightness.dark;

    /// 退出登录所有页面
    ref.listen(UserProviders.isLogin, (previous, next) {
      if (next == true) {
        NavigatorUtils.popTo(context, LoginRouter.login);
        NavigatorUtils.pop(context, result: true);
      }
    });

    final children = [
      Container(
        margin: const EdgeInsets.only(top: 20),
        alignment: Alignment.centerLeft,
        height: 32,
        child: const Text(
          '密码登录',
          style: TextStyles.textBold26,
        ),
      ),
      const SizedBox(height: 16),
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
          child: const LoadAssetImage(
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
      const SizedBox(height: 25),
      SizedBox(
        height: 44,
        width: double.infinity,
        child: ValueListenableBuilder<bool>(
          valueListenable: isChecked,
          builder: (context, value, child) {
            return MaterialButton(
              onPressed: value ? _login : null,
              color: themeData.primaryColor,
              disabledColor: Colours.buttonDisabled,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.zero),
              ),
              child: Text(
                '登录',
                style: TextStyle(
                  color: value ? Colors.white : Colours.textDisabled,
                ),
              ),
            );
          },
        ),
      ),
      Container(
        height: 40,
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: _forgetPwd,
          child: Text(
            '忘记密码',
            style: themeData.textTheme.subtitle2,
          ),
        ),
      ),
      Container(
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: _register,
          child: Text(
            '还没账号？快去注册',
            style: TextStyle(
              color: themeData.primaryColor,
            ),
          ),
        ),
      )
    ];
    return Scaffold(
      appBar: MyAppBar(
        elevation: 0,
        leading: const CloseButton(),
        actions: [
          TextButton(
            onPressed: _codeLogin,
            child: Text(
              '验证码登录',
              style: isDark ? TextStyles.textDark : TextStyles.text,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ),
    );
  }
}
