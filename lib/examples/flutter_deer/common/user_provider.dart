import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/common/deer_storage.dart';

class UserProviders {
  static final userInfo =
      StateNotifierProvider<DeerUserInfoState, DeerUserInfo?>(
          (ref) => throw UnimplementedError());

  static final isLogin = Provider<bool>((ref) {
    return ref.watch(userInfo) == null;
  });
}

class DeerUserInfoState extends StateNotifier<DeerUserInfo?> {
  DeerUserInfoState(DeerUserInfo? userInfo) : super(userInfo);

  void loginSuccess(DeerUserInfo userInfo) {
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
  final String id;

  final String name;

  final String token;

  const DeerUserInfo({
    required this.id,
    required this.name,
    required this.token,
  });

  @override
  List<Object?> get props => [id, name, token];

  factory DeerUserInfo.fromJson(Map<String, dynamic> json) {
    return DeerUserInfo(
      id: json['id'],
      name: json['name'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'token': token,
    };
  }
}
