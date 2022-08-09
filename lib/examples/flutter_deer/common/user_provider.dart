import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/common/deer_storage.dart';

class UserProviders {
  static final userInfo =
      StateNotifierProvider<DeerUserInfoState, DeerUserInfo?>(
          (ref) => DeerUserInfoState(DeerStorage.userInfo));

  static final isLogin = Provider.autoDispose<bool>((ref) {
    return ref.watch(userInfo) != null;
  }, dependencies: [userInfo]);
}

class DeerUserInfoState extends StateNotifier<DeerUserInfo?> {
  DeerUserInfoState(DeerUserInfo? userInfo) : super(userInfo);

  void loginSuccess(DeerUserInfo userInfo) {
    DeerStorage.phone = userInfo.phone;
    DeerStorage.userInfo = userInfo;
    state = userInfo;
  }

  void logOut() {
    DeerStorage.userInfo = null;
    state = null;
  }
}

@immutable
class DeerUserInfo extends Equatable {
  final String phone;

  final String name;

  final String token;

  const DeerUserInfo({
    required this.phone,
    required this.name,
    required this.token,
  });

  @override
  List<Object?> get props => [phone, name, token];

  factory DeerUserInfo.fromJson(Map<String, dynamic> json) {
    return DeerUserInfo(
      phone: json['phone'],
      name: json['name'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'name': name,
      'token': token,
    };
  }
}
