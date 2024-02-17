import 'package:isar/isar.dart';
import 'package:travel_assist/currency.dart';
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';
part 'transaction.g.dart';

// flutter packages pub run build_runner build

enum TransactionTypeEnum {
  cashPayment,
  cardPayment,
  electronicPayment,
  withdrawal,
  balance;
}

@collection
@JsonSerializable()
class Transaction {
  Transaction({
    this.name = "",
    this.value = 0.0,
    this.currency = "",
    this.type = TransactionTypeEnum.cashPayment,
    required this.date,
    this.categoryKey = 0,
    this.comment = "",
    this.exlcudeFromAverage = false,
  });

  @JsonKey(includeFromJson: false, includeToJson: false)
  Id id = Isar.autoIncrement;
  String name;
  double value;
  String currency;
  DateTime date;
  int categoryKey;
  String comment;
  @enumerated
  TransactionTypeEnum type;
  bool exlcudeFromAverage;

  @override
  String toString() {
    return "$date $type: $value $currency $name";
  }

  @ignore
  bool get isWithdrawal => type == TransactionTypeEnum.withdrawal;

  @ignore
  String get dateString => DateFormat('EEEE, d MMMM y').format(date);

  @ignore
  String get valueString => Currency.formatValue(value);

  @ignore
  String get currencyString => currency.toString();

  @ignore
  String get valueCurrencyString =>
      Currency.formatValueCurrency(value, currency);

  @ignore
  DateTime get groupDate {
    return date.copyWith(
        hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
  }

  void update(Transaction other) {
    name = other.name;
    value = other.value;
    type = other.type;
    date = other.date;
    categoryKey = other.categoryKey;
    comment = other.comment;
    currency = other.currency;
    exlcudeFromAverage = other.exlcudeFromAverage;
  }

  Transaction clone() {
    var item = Transaction(date: date);
    item.update(this);
    return item;
  }

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}
