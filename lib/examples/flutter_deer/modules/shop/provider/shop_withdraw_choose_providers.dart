// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/model/shop_withdraw_models.dart';

mixin ShopWithdrawChooseProviders {
  final manager = StateNotifierProvider.autoDispose<
      ShopWithdrawChooseStateNotifier,
      ShopWithdrawChooseState>((ref) => ShopWithdrawChooseStateNotifier());

  late final datas = Provider.autoDispose<List<ShopWithdrawAccountModel>>(
      (ref) => ref.watch(manager).datas);

  late final selectedModel = Provider.autoDispose<ShopWithdrawAccountModel?>(
      (ref) => ref.watch(manager).selectedModel);
}

class ShopWithdrawChooseStateNotifier
    extends StateNotifier<ShopWithdrawChooseState> {
  ShopWithdrawChooseStateNotifier() : super(ShopWithdrawChooseState());

  void change({
    ShopWithdrawAccountModel? selectedModel,
    List<ShopWithdrawAccountModel>? datas,
  }) {
    state = state.copyWith(datas: datas, selectedModel: selectedModel);
  }

  void addAccount(ShopWithdrawAccountModel model) {
    state = state.copyWith(datas: [...state.datas, model]);
  }
}

class ShopWithdrawChooseState {
  final ShopWithdrawAccountModel? selectedModel;

  final List<ShopWithdrawAccountModel> datas;
  ShopWithdrawChooseState({
    this.selectedModel,
    this.datas = const [],
  });

  @override
  bool operator ==(covariant ShopWithdrawChooseState other) {
    if (identical(this, other)) return true;

    return other.selectedModel == selectedModel &&
        listEquals(other.datas, datas);
  }

  @override
  int get hashCode => selectedModel.hashCode ^ datas.hashCode;

  ShopWithdrawChooseState copyWith({
    ShopWithdrawAccountModel? selectedModel,
    List<ShopWithdrawAccountModel>? datas,
  }) {
    return ShopWithdrawChooseState(
      selectedModel: selectedModel ?? this.selectedModel,
      datas: datas ?? this.datas,
    );
  }
}
