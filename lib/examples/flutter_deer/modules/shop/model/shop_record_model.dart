import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ShopRecordSectionModel {
  final String date;
  final List<ShopRecordModel> models;

  ShopRecordSectionModel({
    required this.date,
    required this.models,
  });

  ShopRecordSectionModel copyWith({
    String? date,
    List<ShopRecordModel>? models,
  }) {
    return ShopRecordSectionModel(
      date: date ?? this.date,
      models: models ?? this.models,
    );
  }

  @override
  bool operator ==(covariant ShopRecordSectionModel other) {
    if (identical(this, other)) return true;

    return other.date == date && listEquals(other.models, models);
  }

  @override
  int get hashCode => date.hashCode ^ models.hashCode;
}

class ShopRecordModel {
  final bool isIncome;
  final String price;
  final String time;
  final String balance;

  ShopRecordModel({
    required this.isIncome,
    required this.price,
    required this.time,
    required this.balance,
  });

  @override
  bool operator ==(covariant ShopRecordModel other) {
    if (identical(this, other)) return true;

    return other.isIncome == isIncome &&
        other.price == price &&
        other.time == time &&
        other.balance == balance;
  }

  @override
  int get hashCode {
    return isIncome.hashCode ^
        price.hashCode ^
        time.hashCode ^
        balance.hashCode;
  }

  @override
  String toString() {
    return 'ShopRecordModel(isIncome: $isIncome, price: $price, time: $time, balance: $balance)';
  }
}
