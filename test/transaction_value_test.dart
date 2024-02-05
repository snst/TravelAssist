// Import the test package and Counter class
import 'package:travel_assist/currency.dart';
import 'package:travel_assist/transaction_value.dart';
import 'package:test/test.dart';

void main() {
  var eur = Currency(name: "€", value: 1);
  var cordoba = Currency(name: "C\$", value: 40);

  test('TransactionValue.format', () {
    var val = TransactionValue(4.3, eur);
    expect(val.valueString, "4.30");
    expect(val.currencyString, "€");
    expect(val.toString(), "4.30 €");
  });

  test('TransactionValue.convert', () {
    var val = TransactionValue(4.3, eur);
    var val2 = val.convertTo(cordoba);
    expect(val2.value, 4.3 * 40);
    expect(val2.valueString, "172.00");
    expect(val2.currencyString, "C\$");
    expect(val2.toString(), "172.00 C\$");
  });

  test('TransactionValue.add', () {
    var val1 = TransactionValue(2, eur);
    var val2 = TransactionValue(20, cordoba);
    val1.add(val2);

    expect(val1.value, 2.5);
    expect(val1.valueString, "2.50");
    expect(val1.currencyString, "€");
    expect(val1.toString(), "2.50 €");
  });

  test('TransactionValue.operator_plus', () {
    var val1 = TransactionValue(2, eur);
    var val2 = TransactionValue(20, cordoba);
    var val3 = val1 + val2;

    expect(val3.value, 2.5);
    expect(val3.valueString, "2.50");
    expect(val3.currencyString, "€");
    expect(val3.toString(), "2.50 €");
  });

  test('TransactionValue.add_null_currency', () {
    var val1 = TransactionValue(2.5, eur);
    var val2 = TransactionValue(20, null);
    val1.add(val2);

    expect(val1.value, 22.5);
    expect(val1.valueString, "22.50");
    expect(val1.currencyString, "€");
    expect(val1.toString(), "22.50 €");

    val2.add(val1);

    expect(val2.value, 42.5);
    expect(val2.valueString, "42.50");
    expect(val2.currencyString, "?");
    expect(val2.toString(), "42.50 ?");
  });
}
