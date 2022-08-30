// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class StatisticsGoodsItemModel {
  final int number;
  final Color color;

  StatisticsGoodsItemModel({
    required this.number,
    required this.color,
  });

  @override
  bool operator ==(covariant StatisticsGoodsItemModel other) {
    if (identical(this, other)) return true;

    return other.number == number && other.color == color;
  }

  @override
  int get hashCode => number.hashCode ^ color.hashCode;
}
