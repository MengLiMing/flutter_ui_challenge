// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_table_list_view/flutter_table_list_view.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/model/bank_model/bank_model.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/model/city_model/city_model.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/page/shop_info_choose_page.dart';

mixin ShopInfoChooseProviders {
  final manager = StateNotifierProvider.autoDispose<ShopInfoChooseStateNotifier,
      ShopInfoChooseState>((ref) => ShopInfoChooseStateNotifier());

  late final isLoading =
      Provider.autoDispose<bool>((ref) => ref.watch(manager).isLoading);

  /// 当前下标
  late final sectionIndex =
      Provider.autoDispose<int?>((ref) => ref.watch(manager).section);

  late final letters =
      Provider.autoDispose<List<String>>((ref) => ref.watch(manager).letters);

  /// 当前展示的字母
  late final showLetter = Provider.autoDispose<String?>((ref) {
    final state = ref.watch(manager);
    final sectionIndex = state.section;
    if (sectionIndex != null && state.letters.length > sectionIndex) {
      return state.letters[sectionIndex];
    }
    return null;
  });
}

class ShopInfoChooseStateNotifier extends StateNotifier<ShopInfoChooseState> {
  ShopInfoChooseStateNotifier() : super(ShopInfoChooseState());

  late ShopInfoChooseStyle style;

  Future<void> cofigData(ShopInfoChooseStyle style) async {
    this.style = style;

    await initDatas();
  }

  int sectionCount() {
    return state.letters.length;
  }

  int rowCount({required int section}) {
    if (state.letters.length > section) {
      final letter = state.letters[section];
      final citys = state.datas[letter];
      return citys?.length ?? 0;
    }
    return 0;
  }

  void showLetterAtIndex(int? index) {
    state = state.copyWith(section: index);
  }

  ShopInfoChooseModel? infoChooseModel({required IndexPath indexPath}) {
    if (state.letters.length > indexPath.section) {
      final letter = state.letters[indexPath.section];
      final citys = state.datas[letter];
      if (citys != null && citys.length > indexPath.row) {
        return citys[indexPath.row];
      }
    }
    return null;
  }

  Future<void> initDatas() async {
    state = state.copyWith(isLoading: true);

    await Future.delayed(const Duration(milliseconds: 300));
    String path;
    switch (style) {
      case ShopInfoChooseStyle.city:
        path = 'assets/data/city.json';
        break;
      case ShopInfoChooseStyle.bankName:
        path = 'assets/data/bank.json';
        break;
      case ShopInfoChooseStyle.branchName:
        path = 'assets/data/bank_2.json';
        break;
    }
    final jsonString = await rootBundle.loadString(path);
    final jsonList = json.decode(jsonString) as List<dynamic>;
    Map<String, List<ShopInfoChooseModel>> datas = {};
    for (final item in jsonList) {
      final chooseModel = createModel(item);

      var list = datas[chooseModel.firstLetter] ?? [];
      list.add(chooseModel);
      datas[chooseModel.firstLetter] = list;
    }

    var letters = datas.keys.toList();
    letters.sort();

    /// 开户银行 添加常用
    if (style == ShopInfoChooseStyle.bankName) {
      List<ShopInfoCommonModel> commonList = [];
      for (int i = 0; i < commonBankModels.length; i++) {
        final model = commonBankModels[i];
        commonList.add(
          ShopInfoCommonModel(
            image: commonBankLogos[i],
            bankModel: model,
          ),
        );
      }
      datas['常用'] = commonList;

      letters.insert(0, '常用');
    }

    state = state.copyWith(
      datas: datas,
      letters: letters,
      isLoading: false,
    );
  }

  ShopInfoChooseModel createModel(dynamic item) {
    ShopInfoChooseModel result;
    switch (style) {
      case ShopInfoChooseStyle.city:
        final cityModel = CityModel.fromJson(item);
        result = ShopInfoChooseModel(
          firstLetter: cityModel.firstCharacter,
          name: cityModel.name,
          origin: cityModel,
        );
        break;
      case ShopInfoChooseStyle.bankName:
      case ShopInfoChooseStyle.branchName:
        final bankModel = BankModel.fromJson(item);
        result = ShopInfoChooseModel(
          firstLetter: bankModel.firstLetter,
          name: bankModel.bankName,
          origin: bankModel,
        );
        break;
    }
    return result;
  }

  List<BankModel> get commonBankModels => const [
        BankModel(id: 0, bankName: '工商银行', firstLetter: 'G'),
        BankModel(id: 0, bankName: '建设银行', firstLetter: 'J'),
        BankModel(id: 0, bankName: '中国银行', firstLetter: 'Z'),
        BankModel(id: 0, bankName: '农业银行', firstLetter: 'N'),
        BankModel(id: 0, bankName: '招商银行', firstLetter: 'Z'),
        BankModel(id: 0, bankName: '交通银行', firstLetter: 'J'),
        BankModel(id: 0, bankName: '中信银行', firstLetter: 'Z'),
        BankModel(id: 0, bankName: '民生银行', firstLetter: 'M'),
        BankModel(id: 0, bankName: '兴业银行', firstLetter: 'X'),
        BankModel(id: 0, bankName: '浦发银行', firstLetter: 'P'),
      ];

  List<String> get commonBankLogos => const [
        'gongshang',
        'jianhang',
        'zhonghang',
        'nonghang',
        'zhaohang',
        'jiaohang',
        'zhongxin',
        'minsheng',
        'xingye',
        'pufa'
      ];
}

class ShopInfoChooseModel extends Equatable {
  final String firstLetter;
  final String name;

  /// 原始数据
  final dynamic origin;

  const ShopInfoChooseModel({
    required this.firstLetter,
    required this.name,
    required this.origin,
  });

  @override
  List<Object?> get props => [firstLetter, name];
}

class ShopInfoCommonModel extends ShopInfoChooseModel {
  final String image;

  ShopInfoCommonModel({
    required this.image,
    required BankModel bankModel,
  }) : super(
          firstLetter: '常用',
          name: bankModel.bankName,
          origin: bankModel,
        );
}

class ShopInfoChooseState {
  final bool isLoading;

  final Map<String, List<ShopInfoChooseModel>> datas;

  final List<String> letters;

  /// 当前选中的下标
  final int? section;

  ShopInfoChooseState({
    this.isLoading = false,
    this.datas = const {},
    this.letters = const [],
    this.section,
  });

  ShopInfoChooseState copyWith({
    bool? isLoading,
    Map<String, List<ShopInfoChooseModel>>? datas,
    List<String>? letters,
    int? section,
  }) {
    return ShopInfoChooseState(
      isLoading: isLoading ?? this.isLoading,
      datas: datas ?? this.datas,
      letters: letters ?? this.letters,
      section: section,
    );
  }

  @override
  bool operator ==(covariant ShopInfoChooseState other) {
    if (identical(this, other)) return true;

    return other.isLoading == isLoading &&
        mapEquals(other.datas, datas) &&
        listEquals(other.letters, letters) &&
        other.section == section;
  }

  @override
  int get hashCode {
    return isLoading.hashCode ^
        datas.hashCode ^
        letters.hashCode ^
        section.hashCode;
  }
}
