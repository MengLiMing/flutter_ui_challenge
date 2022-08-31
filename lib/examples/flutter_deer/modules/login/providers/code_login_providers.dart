import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/common/deer_storage.dart';

mixin CodeLoginProviders {
  final manager =
      StateNotifierProvider.autoDispose<CodeLoginStateNotifier, CodeLoginState>(
          (ref) {
    return CodeLoginStateNotifier();
  });

  late final canSendCode = Provider.autoDispose<bool>((ref) {
    final state = ref.watch(manager);
    return state.phone.length == 11;
  });

  late final canLogin = Provider.autoDispose<bool>((ref) {
    final state = ref.watch(manager);
    return state.phone.length == 11 && state.code.isNotEmpty;
  });

  late final timeCount = Provider.autoDispose<int>((ref) {
    return ref.watch(manager).timeCount;
  });

  late final hadSendCode = Provider.autoDispose<bool>((ref) {
    return ref.watch(manager).hadSendCode;
  });
}

class CodeLoginStateNotifier extends StateNotifier<CodeLoginState> {
  CodeLoginStateNotifier()
      : super(
          CodeLoginState(phone: DeerStorage.phone),
        );
  Timer? _timer;

  final int maxTimeCount = 60;

  void change({String? phone, String? code}) {
    state = state.copyWith(phone: phone, code: code);
  }

  set _hadSendCode(bool value) {
    state = state.copyWith(hadSendCode: value);
  }

  set _timeCount(int value) {
    state = state.copyWith(timeCount: value);
  }

  void sendCode() {
    _startTimer();
  }

  void _startTimer() {
    _stopTimer();
    _hadSendCode = true;

    _timeCount = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.timeCount == 1) {
        _stopTimer();
      } else {
        _timeCount = state.timeCount - 1;
      }
    });
  }

  void _stopTimer() {
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

class CodeLoginState extends Equatable {
  final String phone;
  final String code;
  final int timeCount;
  final bool hadSendCode;

  const CodeLoginState({
    required this.phone,
    this.code = '',
    this.timeCount = 0,
    this.hadSendCode = false,
  });

  @override
  List<Object> get props => [phone, code, timeCount, hadSendCode];

  CodeLoginState copyWith({
    String? phone,
    String? code,
    int? timeCount,
    bool? hadSendCode,
  }) {
    return CodeLoginState(
      phone: phone ?? this.phone,
      code: code ?? this.code,
      timeCount: timeCount ?? this.timeCount,
      hadSendCode: hadSendCode ?? this.hadSendCode,
    );
  }
}
