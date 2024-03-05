// Import the test package and Counter class
import 'package:flutter/material.dart';
import 'package:travel_assist/currency.dart';
import 'package:test/test.dart';
import 'package:travel_assist/currency_provider.dart';
import 'package:travel_assist/transaction.dart';
import 'package:travel_assist/transaction_provider.dart';

void main() {
  test('TransactionProvider.1', () {
    WidgetsFlutterBinding.ensureInitialized();

    var cp = CurrencyProvider(useDb: false);
    cp.add(Currency(name:'€', value: 1));
    cp.add(Currency(name:'\$', value: 2));

    var tp = TransactionProvider(useDb: false);
    var l = tp.getSortedTransactions(null);
    expect(l.length, 0);

    tp.add(Transaction(name: 'atm', value:100, currency: '€', type:TransactionTypeEnum.withdrawal, date: DateTime.now()));
    tp.add(Transaction(name: 'atm', value:100, currency: '\$', type:TransactionTypeEnum.withdrawal, date: DateTime.now()));
    l = tp.getSortedTransactions(null);
    expect(l.length, 2);

    tp.caluculateAll(cp);
    expect(tp.allWithdraws.toString(), '150.00€');
    expect(tp.withdrawPerCurrency['€'].toString(), '100.00€');
    expect(tp.withdrawPerCurrency['\$'].toString(), '100.00\$');
    expect(tp.allBalance.toString(), '150.00€');
    expect(tp.balancePerCurrency['€'].toString(), '100.00€');
    expect(tp.balancePerCurrency['\$'].toString(), '100.00\$');
    expect(tp.allExpenses.toString(), '0.00€');
    expect(tp.expensePerCurrency['€'].toString(), '0.00€');
    expect(tp.expensePerCurrency['\$'].toString(), '0.00\$');

    tp.add(Transaction(name: 'pay', value:10, currency: '€', type:TransactionTypeEnum.cashPayment, date: DateTime.now()));
    tp.caluculateAll(cp);
    expect(tp.allWithdraws.toString(), '150.00€');
    expect(tp.allBalance.toString(), '140.00€');
    expect(tp.balancePerCurrency['€'].toString(), '90.00€');
    expect(tp.balancePerCurrency['\$'].toString(), '100.00\$');
    expect(tp.expensePerCurrency['€'].toString(), '10.00€');
    expect(tp.expensePerCurrency['\$'].toString(), '0.00\$');

  });
}
