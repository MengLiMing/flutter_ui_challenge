// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/common/user_provider.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/login/providers/code_login_providers.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/text_styles.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/my_app_bar.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/simple_textfield.dart';

class CodeLoginPage extends ConsumerStatefulWidget {
  const CodeLoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CodeLoginPageState();
}

class _CodeLoginPageState extends ConsumerState<CodeLoginPage>
    with CodeLoginProviders {
  final phoneControler = TextEditingController();
  final codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    phoneControler.text = ref.read(manager).phone;

    phoneControler.addListener(_editChanged);

    codeController.addListener(_editChanged);
  }

  @override
  void dispose() {
    phoneControler.dispose();
    codeController.dispose();
    super.dispose();
  }

  void _editChanged() {
    ref.read(manager.notifier).change(
          phone: phoneControler.text,
          code: codeController.text,
        );
  }

  void _login() {
    final phone = ref.read(manager).phone;

    /// 保存用户信息
    ref.read(UserProviders.userInfo.notifier).loginSuccess(DeerUserInfo(
          phone: phone,
          name: '刚刚好',
          token: "token",
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
            left: 16, right: 16, bottom: MediaQuery.of(context).padding.bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              alignment: Alignment.centerLeft,
              height: 32,
              child: const Text(
                '验证码登录',
                style: TextStyles.textBold26,
              ),
            ),
            const SizedBox(height: 16),
            SimpleTextField(
              hintText: '请输入手机号',
              controller: phoneControler,
              maxLength: 11,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 9),
            SimpleTextField(
              hintText: '请输入验证码',
              isShowHint: () => true,
              controller: codeController,
              keyboardType: TextInputType.number,
              hintWidget: SizedBox(
                height: 24,
                width: 76.fit,
                child: _sendCodeButton(),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8),
              height: 16,
              alignment: Alignment.centerLeft,
              child: const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '提示：未注册账号的手机号，请先',
                      style: TextStyle(color: Colours.textGray, fontSize: 12),
                    ),
                    TextSpan(
                      text: '注册',
                      style: TextStyle(color: Colours.red, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: _loginButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loginButton() {
    return Consumer(builder: (context, ref, _) {
      return MaterialButton(
        onPressed: ref.watch(canLogin) ? _login : null,
        color: Theme.of(context).primaryColor,
        disabledColor: Colours.buttonDisabled,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.zero),
        ),
        child: const Text(
          '登录',
          style: TextStyle(color: Colors.white),
        ),
      );
    });
  }

  Widget _sendCodeButton() {
    return Consumer(builder: (context, ref, _) {
      final timeCount = ref.watch(this.timeCount);
      if (timeCount != 0) {
        return Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              color: Colours.textGrayC,
              borderRadius: BorderRadius.all(Radius.circular(2))),
          child: Text(
            '已发送(${timeCount}s)',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        );
      } else {
        return GestureDetector(
          onTap: ref.read(manager.notifier).sendCode,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colours.appMain, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(2)),
            ),
            child: Text(
              ref.watch(hadSendCode) ? '重新获取' : '获取验证码',
              style: const TextStyle(
                color: Colours.appMain,
                fontSize: 12,
              ),
            ),
          ),
        );
      }
    });
  }
}
