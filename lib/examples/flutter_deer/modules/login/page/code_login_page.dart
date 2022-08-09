// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/common/deer_storage.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/common/user_provider.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/text_styles.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/toast.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/simple_textfield.dart';

class CodeLoginPage extends ConsumerStatefulWidget {
  const CodeLoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CodeLoginPageState();
}

class _CodeLoginPageState extends ConsumerState<CodeLoginPage> {
  final phoneControler = TextEditingController();
  final codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    phoneControler.text = ref.read(_codeLoginProvider.notifier).state.phone;

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
    final notifier = ref.read(_codeLoginProvider.notifier);

    notifier.phone = phoneControler.text;
    notifier.code = codeController.text;
  }

  void _login() {
    final phone = ref.read(_codeLoginProvider).phone;

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
      appBar: AppBar(
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
              child: Text(
                '验证码登录',
                style: TextStyles.textBold26,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            SimpleTextField(
              hintText: '请输入手机号',
              controller: phoneControler,
              maxLength: 11,
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 9,
            ),
            SimpleTextField(
              hintText: '请输入验证码',
              isShowHint: () => true,
              controller: codeController,
              keyboardType: TextInputType.number,
              hintWidget: SizedBox(
                height: 24,
                width: 76,
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
            SizedBox(
              height: 24,
            ),
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
      final config = ref.watch(_codeLoginProvider);

      final notifier = ref.read(_codeLoginProvider.notifier);
      return MaterialButton(
        onPressed: notifier.canLogin ? _login : null,
        child: const Text(
          '登录',
          style: TextStyle(color: Colors.white),
        ),
        color: Theme.of(context).primaryColor,
        disabledColor: Colours.buttonDisabled,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.zero),
        ),
      );
    });
  }

  Widget _sendCodeButton() {
    return Consumer(builder: (context, ref, _) {
      final config = ref.watch(_codeLoginProvider);

      final notifier = ref.read(_codeLoginProvider.notifier);
      if (config.timeCount != 0) {
        return Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colours.textGrayC,
              borderRadius: BorderRadius.all(Radius.circular(2))),
          child: Text(
            '已发送(${config.timeCount}s)',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        );
      } else {
        return GestureDetector(
          onTap: notifier.sendCode,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colours.appMain, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(2)),
            ),
            child: Text(
              config.hadSendCode ? '重新获取' : '获取验证码',
              style: TextStyle(
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

final _codeLoginProvider =
    StateNotifierProvider.autoDispose<_CodeLoginConfigState, _CodeLoginConfig>(
        (ref) {
  return _CodeLoginConfigState();
});

class _CodeLoginConfigState extends StateNotifier<_CodeLoginConfig> {
  _CodeLoginConfigState()
      : super(
          _CodeLoginConfig(
              phone: DeerStorage.phone,
              code: '',
              timeCount: 0,
              hadSendCode: false),
        );
  Timer? _timer;

  final int maxTimeCount = 60;

  set phone(String phone) {
    state = state.copyWith(phone: phone);
  }

  set code(String code) {
    state = state.copyWith(code: code);
  }

  set _hadSendCode(bool value) {
    state = state.copyWith(hadSendCode: value);
  }

  set _timeCount(int value) {
    state = state.copyWith(timeCount: value);
  }

  void sendCode() {
    if (canSendCode) {
      _startTimer();
    } else {
      Toast.show('请输入手机号');
    }
  }

  /// 是否发送过
  bool get hadSendCode => state.hadSendCode;

  /// 当前倒计时
  int get timeCount => state.timeCount;

  /// 是否能够发送验证码
  bool get canSendCode => state.phone.length == 11;

  /// 是否可以登录
  bool get canLogin => state.phone.length == 11 && state.code.isNotEmpty;

  void _startTimer() {
    stopTimer();
    _hadSendCode = true;

    _timeCount = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.timeCount == 1) {
        stopTimer();
      } else {
        _timeCount = state.timeCount - 1;
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    state = state.copyWith(timeCount: 0);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }
}

class _CodeLoginConfig extends Equatable {
  final String phone;
  final String code;

  final int timeCount;

  final bool hadSendCode;

  const _CodeLoginConfig({
    required this.phone,
    required this.code,
    required this.timeCount,
    required this.hadSendCode,
  });

  @override
  List<Object> get props => [phone, code, timeCount, hadSendCode];

  _CodeLoginConfig copyWith({
    String? phone,
    String? code,
    int? timeCount,
    bool? hadSendCode,
  }) {
    return _CodeLoginConfig(
      phone: phone ?? this.phone,
      code: code ?? this.code,
      timeCount: timeCount ?? this.timeCount,
      hadSendCode: hadSendCode ?? this.hadSendCode,
    );
  }
}
