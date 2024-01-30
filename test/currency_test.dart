// Import the test package and Counter class
import 'package:travel_assist/currency.dart';
import 'package:travel_assist/transaction.dart';
import 'package:test/test.dart';

void main() {
  var eur = Currency(name: "€", value: 1);
  var dollar = Currency(name: "\$", value: 1.1);
  var cordoba = Currency(name: "C\$", value: 40);
  //List<Currency> currencies = [eur, dollar, cordoba];

  test('Currency.Currency', () {
    expect(Currency.convert(5, eur, dollar), 5.5);
    expect(eur.convertTo(5, dollar), 5.5);
    expect(eur.convertTo(5, cordoba), 200);
    expect(cordoba.convertTo(80, cordoba), 80);
    expect(cordoba.convertTo(100, eur), 2.5);
    expect(cordoba.convertTo(100, dollar), 2.75);
  });

  test('TransactionModel.sum', () {
    var t = BudgetModel();
    //t.initCurrencies(currencies);
    t.add(Transaction(
        currency: cordoba, value: 0.2, date: DateTime(2023, 1, 15)));
    t.add(Transaction(currency: dollar, value: 4, date: DateTime(2023, 1, 14)));
    t.add(Transaction(currency: eur, value: 2.3, date: DateTime(2023, 1, 15)));
    t.add(Transaction(currency: dollar, value: 3, date: DateTime(2023, 1, 15)));
    t.add(Transaction(currency: eur, value: 2, date: DateTime(2023, 1, 13)));
    t.add(
        Transaction(currency: cordoba, value: 30, date: DateTime(2023, 1, 15)));
    t.add(Transaction(
        currency: dollar,
        value: 30,
        type: TransactionTypeEnum.inpayment,
        date: DateTime(2023, 1, 13)));
    t.add(Transaction(
        currency: cordoba,
        value: 200,
        type: TransactionTypeEnum.inpayment,
        date: DateTime(2023, 1, 13)));
    t.add(Transaction(
        currency: cordoba,
        value: 100,
        type: TransactionTypeEnum.inpayment,
        date: DateTime(2023, 1, 15)));

    //for (final item in t.getSortedTransactions(DateTime(2024, 1, 14))) {
      //print(item);
    //}

    var result = t.calculate(eur, null);
    expect(result.sumInpayment, closeTo(34.7, 0.1));
    expect(result.sumExpense, closeTo(11.41, 0.1));
    expect(
        result.balance, closeTo(result.sumInpayment - result.sumExpense, 0.1));
    expect(result.days, 3);
    expect(result.expensePerDay, closeTo(result.sumExpense / result.days, 0.1));

    result = t.calculate(eur, DateTime(2023, 1, 14));
    expect(result.sumInpayment, closeTo(32.27, 0.1));
    expect(result.sumExpense, closeTo(5.63, 0.1));
    expect(
        result.balance, closeTo(result.sumInpayment - result.sumExpense, 0.1));
    expect(result.days, 2);
    expect(result.expensePerDay, closeTo(result.sumExpense / result.days, 0.1));

    /*
    t.calculate();
    t.dump();

    expect(t.getExpenses(cordoba), 30.2); // 0,755€
    expect(t.getExpenses(dollar), 7.0); // 6.36€
    expect(t.getExpenses(eur), 4.3);
    expect(t.getAllExpensesIn(eur), closeTo(11.41, 0.1));
*/
  });

/*  test('PackingListItem id should be incremented', () {
    var item = PackingListItem(name: "shirt");
    expect(item.name, 'shirt');
    expect(item.id, 0);
    item = PackingListItem(name: "hat");
    expect(item.name, 'hat');
    expect(item.id, 1);
  });


  test('Manipulate PackingList', () {
    var pl = PackingList("pl");
    expect(pl.cntItem(), 0);

    var shirt = PackingListItem(name: "shirt");
    pl.addItem(shirt);
    expect(pl.cntItem(), 1);

    var hat = PackingListItem(name: "hat");
    pl.addItem(hat);
    expect(pl.cntItem(), 2);

    var shirt2 = PackingListItem(name: "shirt2");
    shirt.update(shirt2);
    //pl.updateItem(shirt, shirt2);
    expect(pl.getItem(0).name, shirt2.name);

    pl.deleteItem(shirt);
    expect(pl.cntItem(), 1);
  });*/
}
