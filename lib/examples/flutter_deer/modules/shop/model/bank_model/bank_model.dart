import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bank_model.g.dart';

@JsonSerializable()
class BankModel extends Equatable {
  final int id;
  final String bankName;
  final String firstLetter;

  const BankModel(
      {required this.id, required this.bankName, required this.firstLetter});

  factory BankModel.fromJson(Map<String, dynamic> json) {
    return _$BankModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$BankModelToJson(this);

  @override
  List<Object?> get props => [id, bankName, firstLetter];
}
