// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/model/city_model/city_model.dart';

class ShopCityStateNotifier extends StateNotifier<ShopCityState> {
  ShopCityStateNotifier() : super(ShopCityState());

  void initDatas() async {
    state = state.copyWith(isLoading: true);
    final jsonString = await rootBundle.loadString('assets/data/city.json');
    final jsonList = json.decode(jsonString) as List<dynamic>;
    Map<String, List<CityModel>> datas = {};
    for (final item in jsonList) {
      final cityModel = CityModel.fromJson(item);

      var list = datas[cityModel.firstCharacter] ?? [];
      list.add(cityModel);
      datas[cityModel.firstCharacter] = list;
    }

    var letters = datas.keys.toList();
    letters.sort();

    state = state.copyWith(
      datas: datas,
      letters: letters,
      isLoading: false,
    );
  }
}

class ShopCityState {
  final bool isLoading;

  final Map<String, List<CityModel>> datas;

  final List<String> letters;
  ShopCityState({
    this.isLoading = false,
    this.datas = const {},
    this.letters = const [],
  });

  ShopCityState copyWith({
    bool? isLoading,
    Map<String, List<CityModel>>? datas,
    List<String>? letters,
  }) {
    return ShopCityState(
      isLoading: isLoading ?? this.isLoading,
      datas: datas ?? this.datas,
      letters: letters ?? this.letters,
    );
  }

  @override
  bool operator ==(covariant ShopCityState other) {
    if (identical(this, other)) return true;

    return other.isLoading == isLoading &&
        mapEquals(other.datas, datas) &&
        listEquals(other.letters, letters);
  }

  @override
  int get hashCode => isLoading.hashCode ^ datas.hashCode ^ letters.hashCode;
}
