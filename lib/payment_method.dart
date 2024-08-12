import 'package:isar/isar.dart';
// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';
part 'payment_method.g.dart';

@collection
@JsonSerializable()
class PaymentMethod {
  PaymentMethod({this.name = "", this.cash=false});

  @JsonKey(includeFromJson: false, includeToJson: false)
  Id id = Isar.autoIncrement;
  String name;
  bool cash;

  @override
  String toString() => name;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentMethodToJson(this);
}
