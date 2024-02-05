import 'package:travel_assist/currency.dart';

class TransactionValue {
  TransactionValue(this.value, this.currency);
  double value;
  Currency? currency;

  String get valueString => Currency.formatValue(value);
  String get currencyString => currency != null ? currency.toString() : "?";
  @override
  String toString() => "$valueString $currencyString";

  TransactionValue convertTo(Currency? toCurrency) {
    if (currency == toCurrency || null == currency) {
      return this;
    } else {
      return TransactionValue(
          currency!.convertTo(value, toCurrency), toCurrency);
    }
  }

  TransactionValue operator +(TransactionValue other) {
    double sum = value + other.convertTo(currency).value;
    return TransactionValue(sum, currency);
  }

  TransactionValue operator -(TransactionValue other) {
    double sum = value - other.convertTo(currency).value;
    return TransactionValue(sum, currency);
  }

  void add(TransactionValue? other) {
    if (other != null) {
      value += other.convertTo(currency).value;
    }
  }

  void sub(TransactionValue? other) {
    if (other != null) {
      value -= other.convertTo(currency).value;
    }
  }
}
