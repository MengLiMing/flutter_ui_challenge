// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/model/shop_withdraw_models.dart';

mixin ShopWithdrawProviders {
  final manager = StateNotifierProvider.autoDispose<ShopWithdrawStateNotifier,
      ShopWithdrawState>(
    (ref) => ShopWithdrawStateNotifier(),
  );

  late final accountModel = Provider.autoDispose<ShopWithdrawAccountModel>(
      (ref) => ref.watch(manager).accountModel);

  late final canCommit =
      Provider.autoDispose<bool>((ref) => ref.watch(manager).canCommit);

  late final moneyIsNotEmpty =
      Provider.autoDispose<bool>((ref) => ref.watch(manager).money.isNotEmpty);

  late final withdrawStyle = Provider.autoDispose<ShopWithdrawStyle>(
      (ref) => ref.watch(manager).withdrawStyle);
}

class ShopWithdrawStateNotifier extends StateNotifier<ShopWithdrawState> {
  ShopWithdrawStateNotifier()
      : super(ShopWithdrawState(
          accountModel: ShopWithdrawAccountModel.samples.first,
        ));

  void change({
    ShopWithdrawAccountModel? accountModel,
    ShopWithdrawStyle? withdrawStyle,
    String? money,
  }) {
    final value = money ?? state.money;
    double price = double.tryParse(value) ?? 0;
    state = state.copyWith(
      accountModel: accountModel,
      withdrawStyle: withdrawStyle,
      money: money,
      canCommit: price > 0 && price <= 20000,
    );
  }
}

class ShopWithdrawState {
  final ShopWithdrawAccountModel accountModel;

  final ShopWithdrawStyle withdrawStyle;

  final String money;

  final bool canCommit;

  ShopWithdrawState({
    required this.accountModel,
    this.withdrawStyle = ShopWithdrawStyle.quick,
    this.canCommit = false,
    this.money = '',
  });

  ShopWithdrawState copyWith({
    ShopWithdrawAccountModel? accountModel,
    ShopWithdrawStyle? withdrawStyle,
    String? money,
    bool? canCommit,
  }) {
    return ShopWithdrawState(
      accountModel: accountModel ?? this.accountModel,
      withdrawStyle: withdrawStyle ?? this.withdrawStyle,
      money: money ?? this.money,
      canCommit: canCommit ?? this.canCommit,
    );
  }

  @override
  bool operator ==(covariant ShopWithdrawState other) {
    if (identical(this, other)) return true;

    return other.accountModel == accountModel &&
        other.withdrawStyle == withdrawStyle &&
        other.money == money &&
        other.canCommit == canCommit;
  }

  @override
  int get hashCode {
    return accountModel.hashCode ^
        withdrawStyle.hashCode ^
        money.hashCode ^
        canCommit.hashCode;
  }
}
