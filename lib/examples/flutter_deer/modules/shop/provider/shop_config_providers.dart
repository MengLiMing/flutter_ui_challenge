// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/model/shop_config_model/shop_config_model.dart';

mixin ShopConfigProviders {
  final manager =
      StateNotifierProvider<ShopConfigStateNotifier, ShopConfigState>(
          (ref) => ShopConfigStateNotifier());

  late final canCommit =
      Provider.autoDispose<bool>((ref) => ref.watch(manager).canCommit);

  late final isBusiness =
      Provider.autoDispose<bool>((ref) => ref.watch(manager).model.isBusiness);
}

class ShopConfigStateNotifier extends StateNotifier<ShopConfigState> {
  ShopConfigStateNotifier() : super(ShopConfigState());

  void resetModel(ShopConfigModel? model) {
    final newModel = model ?? state.model;
    bool canCommit = newModel.desc.isNotEmpty &&
        newModel.sevice.isNotEmpty &&
        newModel.phone.isNotEmpty &&
        newModel.address.isNotEmpty;

    if (canCommit) {
      if (newModel.isBusiness) {
        canCommit = newModel.freightScale.isNotEmpty;
      } else {
        canCommit = newModel.freightBreaks.isNotEmpty &&
            newModel.freightCost.isNotEmpty;
      }
    }

    state = state.copyWith(canCommit: canCommit, model: newModel);
  }

  void change({
    bool? isBusiness,
    String? desc,
    String? sevice,
    List<ShopPaymentStyle>? payment,
    ShopFreightConfig? freightConfig,
    String? freightScale,
    String? freightBreaks,
    String? freightCost,
    String? phone,
    String? address,
  }) {
    resetModel(state.model.copyWith(
      isBusiness: isBusiness,
      desc: desc,
      sevice: sevice,
      payment: payment,
      freightConfig: freightConfig,
      freightScale: freightScale,
      freightBreaks: freightBreaks,
      freightCost: freightCost,
      phone: phone,
      address: address,
    ));
  }
}

class ShopConfigState {
  final bool canCommit;

  final ShopConfigModel model;

  ShopConfigState({
    this.canCommit = false,
    this.model = const ShopConfigModel(),
  });

  ShopConfigState copyWith({
    bool? canCommit,
    ShopConfigModel? model,
  }) {
    return ShopConfigState(
      canCommit: canCommit ?? this.canCommit,
      model: model ?? this.model,
    );
  }

  @override
  bool operator ==(covariant ShopConfigState other) {
    if (identical(this, other)) return true;

    return other.canCommit == canCommit && other.model == model;
  }

  @override
  int get hashCode => canCommit.hashCode ^ model.hashCode;
}
