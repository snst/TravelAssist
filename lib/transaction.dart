import 'package:isar/isar.dart';
import 'package:travel_assist/currency.dart';
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';
part 'transaction.g.dart';

// flutter packages pub run build_runner build

enum TransactionTypeEnum {
  expense,
  deposit,
  balance;
}

final List<String> transactionTypeList = ["Expense", "Withdrawal", "Balance"];
TransactionTypeEnum transactionTypeStringToEnum(String name) {
  if (name == transactionTypeList[0])
    return TransactionTypeEnum.expense;
  else if (name == transactionTypeList[1])
    return TransactionTypeEnum.deposit;
  else
    return TransactionTypeEnum.balance;
}

String transactionTypeEnumToString(TransactionTypeEnum type) {
  if (type == TransactionTypeEnum.expense)
    return transactionTypeList[0];
  else if (type == TransactionTypeEnum.deposit)
    return transactionTypeList[1];
  else
    return transactionTypeList[2];
}

String getHint(TransactionTypeEnum type) {
  switch (type) {
    case TransactionTypeEnum.expense:
      return "Expense";
    case TransactionTypeEnum.deposit:
      return "Deposit";
    case TransactionTypeEnum.balance:
      return "Balance";
  }
}

@collection
@JsonSerializable()
class Transaction {
  Transaction(
      {this.name = "",
      this.value = 0.0,
      this.currency = "",
      this.type = TransactionTypeEnum.expense,
      required this.date,
      this.category = "",
      this.exlcudeFromAverage = false,
      this.method = ""});

  @JsonKey(includeFromJson: false, includeToJson: false)
  Id id = Isar.autoIncrement;
  String name;
  String category;
  String method;
  double value;
  String currency;
  DateTime date;
  bool exlcudeFromAverage;
  @enumerated
  TransactionTypeEnum type;

  @override
  String toString() {
    return "$date $type: $value $currency $name";
  }

  @ignore
  bool get isCash => method.isEmpty || method == "Cash";

  @ignore
  bool get isWithdrawal => type == TransactionTypeEnum.deposit && !isCash;

  @ignore
  bool get isDeposit => type == TransactionTypeEnum.deposit;

  @ignore
  bool get isExpense => type == TransactionTypeEnum.expense;

  @ignore
  bool get isCashDeposit => type == TransactionTypeEnum.deposit && isCash;

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
    category = other.category;
    currency = other.currency;
    exlcudeFromAverage = other.exlcudeFromAverage;
    method = other.method;
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
