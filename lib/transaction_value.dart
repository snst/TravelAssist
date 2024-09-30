import 'currency.dart';
import 'travel_assist_utils.dart';

class TransactionValue {
  TransactionValue(this.value, this.currency);
  double value;
  Currency? currency;

  String get valueString => Currency.formatValue(value);
  String get currencyString => currency != null ? currency.toString() : "?";
  @override
  String toString() => "$valueString $currencyString";
  String toShortString() => "${removeTrailingZeros(valueString)}$currencyString";
  bool isZero() => value == 0;
  String roundToString() => "${Currency.roundToString(value)} $currencyString";


  void reset() {
    value = 0;
    currency = null;
  }

  TransactionValue convertTo(Currency? toCurrency) {
    if (currency == toCurrency || null == currency) {
      return this;
    } else {
      return TransactionValue(
          currency!.convertTo(value, toCurrency), toCurrency);
    }
  }

  TransactionValue operator +(TransactionValue other) {
    currency ??= other.currency;
    double sum = value + other.convertTo(currency).value;
    return TransactionValue(sum, currency);
  }

  TransactionValue operator -(TransactionValue other) {
    currency ??= other.currency;
    double sum = value - other.convertTo(currency).value;
    return TransactionValue(sum, currency);
  }

  void add(TransactionValue? other) {
    if (other != null) {
      currency ??= other.currency;
      value += other.convertTo(currency).value;
    }
  }

  void sub(TransactionValue? other) {
    if (other != null) {
      currency ??= other.currency;
      value -= other.convertTo(currency).value;
    }
  }
}
