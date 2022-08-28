import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/model/shop_withdraw_models.dart';

mixin ShopWithdrawAccountProviders {
  /// 没有人watch会autoDispose
  final manager = StateNotifierProvider.autoDispose<
      ShopWithdrawAccountStateNotifier, List<ShopWithdrawAccountModel>>(
    (ref) => ShopWithdrawAccountStateNotifier(),
  );
}

class ShopWithdrawAccountStateNotifier
    extends StateNotifier<List<ShopWithdrawAccountModel>> {
  ShopWithdrawAccountStateNotifier() : super([]);

  void config(List<ShopWithdrawAccountModel> accounts) {
    state = List.from(accounts);
  }

  void removeAt(int index) {
    state.removeAt(index);
  }

  void insertItem(ShopWithdrawAccountModel model) {
    state.insert(0, model);
  }
}
