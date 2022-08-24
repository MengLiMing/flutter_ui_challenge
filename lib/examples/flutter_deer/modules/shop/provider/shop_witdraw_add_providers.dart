// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/model/shop_withdraw_models.dart';

mixin ShopWithdrawAddProviders {
  final manager = StateProvider.autoDispose<ShopWithdrawAddState>((ref) {
    return ShopWithdrawAddState(
      accontType: ShopAccontType.public,
      bankEditModel: ShopWithdrawBankEditModel.empty(),
    );
  });

  late final canCommit = Provider.autoDispose<bool>((ref) {
    final model = ref.watch(manager);
    if (model.accontType == ShopAccontType.wechat) {
      return true;
    }
    return model.bankEditModel.name.isNotEmpty &&
        model.bankEditModel.cardNumber.isNotEmpty &&
        model.bankEditModel.city.isNotEmpty &&
        model.bankEditModel.bankName.isNotEmpty &&
        model.bankEditModel.branchName.isNotEmpty;
  });
}

class ShopWithdrawAddState {
  final ShopAccontType accontType;

  final ShopWithdrawBankEditModel bankEditModel;

  ShopWithdrawAddState({
    required this.accontType,
    required this.bankEditModel,
  });

  ShopWithdrawAddState copyWith({
    ShopAccontType? accontType,
    String? name,
    String? cardNumber,
    String? city,
    String? bankName,
    String? branchName,
  }) {
    return ShopWithdrawAddState(
      accontType: accontType ?? this.accontType,
      bankEditModel: bankEditModel.copyWith(
          name: name,
          city: city,
          cardNumber: cardNumber,
          bankName: bankName,
          branchName: branchName),
    );
  }
}

class ShopWithdrawBankEditModel {
  final String name;
  final String cardNumber;
  final String city;
  final String bankName;
  final String branchName;

  const ShopWithdrawBankEditModel({
    required this.name,
    required this.cardNumber,
    required this.city,
    required this.bankName,
    required this.branchName,
  });

  factory ShopWithdrawBankEditModel.empty() {
    return const ShopWithdrawBankEditModel(
        bankName: '', cardNumber: '', city: '', branchName: '', name: '');
  }

  ShopWithdrawBankEditModel copyWith({
    String? name,
    String? cardNumber,
    String? city,
    String? bankName,
    String? branchName,
  }) {
    return ShopWithdrawBankEditModel(
      name: name ?? this.name,
      cardNumber: cardNumber ?? this.cardNumber,
      city: city ?? this.city,
      bankName: bankName ?? this.bankName,
      branchName: branchName ?? this.branchName,
    );
  }

  @override
  bool operator ==(covariant ShopWithdrawBankEditModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.cardNumber == cardNumber &&
        other.city == city &&
        other.bankName == bankName &&
        other.branchName == branchName;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        cardNumber.hashCode ^
        city.hashCode ^
        bankName.hashCode ^
        branchName.hashCode;
  }
}
