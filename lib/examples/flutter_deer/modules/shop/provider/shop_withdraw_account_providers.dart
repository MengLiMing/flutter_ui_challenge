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

  void removeAt(int index) {
    if (state.length > index) {
      final oldList = state;
      oldList.removeAt(index);
      state = oldList;
    }
  }

  void insertItem(ShopWithdrawAccountModel model) {
    final oldList = state;
    oldList.insert(0, model);
    state = oldList;
  }
}
