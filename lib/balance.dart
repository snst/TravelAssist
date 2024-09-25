import 'dart:collection';
import 'package:travel_assist/currency_provider.dart';
import 'package:travel_assist/transaction.dart';
import 'package:travel_assist/transaction_value.dart';

class Balance {
  CurrencyProvider currencyProvider;
  final Map<String, TransactionValue> expenseByMethod =
      HashMap<String, TransactionValue>();
  final Map<String, TransactionValue> expenseByMethodCurrencyCard =
      HashMap<String, TransactionValue>();
  final Map<String, TransactionValue> expenseByMethodCurrencyCash =
      HashMap<String, TransactionValue>();

  final Map<String, TransactionValue> balanceByCurrency =
      HashMap<String, TransactionValue>();

  final Map<String, TransactionValue> depositByCurrency =
      HashMap<String, TransactionValue>();

  final Map<String, TransactionValue> withdrawalByMethod =
      HashMap<String, TransactionValue>();
  final Map<String, TransactionValue> withdrawalByMethodCurrencyCard =
      HashMap<String, TransactionValue>();
  final Map<String, TransactionValue> cashFundsByCurrency =
      HashMap<String, TransactionValue>();

  late TransactionValue expenseAll;
  late TransactionValue expenseCash;
  late TransactionValue expenseCard;
  late TransactionValue withdrawalAll;
  late TransactionValue cashFunds;
  late TransactionValue balanceCash;
  int days = 1;

  TransactionValue initTransaction() {
    return TransactionValue(0, currencyProvider.getHomeCurrency());
  }

  Balance({required this.currencyProvider}) {
    expenseAll = initTransaction();
    expenseCash = initTransaction();
    expenseCard = initTransaction();
    balanceCash = initTransaction();
    withdrawalAll = initTransaction();
    cashFunds = initTransaction();
  }

  void initMap(Map<String, TransactionValue> map, final Transaction transaction,
      {var key}) {
    key ??= transaction.currency;
    if (!map.containsKey(key)) {
      map[key] = TransactionValue(
          0, currencyProvider.getCurrencyByName(transaction.currency));
    }
  }

  bool processExpense(
      final Transaction transaction, final TransactionValue tv) {
    if (transaction.isExpense) {
      if (transaction.isCash) {
        balanceCash.sub(tv);
        expenseCash.add(tv);

        initMap(balanceByCurrency, transaction);
        balanceByCurrency[transaction.currency]!.sub(tv);
      } else {
        expenseCard.add(tv);
      }

      String key = '${transaction.method} ${transaction.currencyString}';
      if (transaction.isCash) {
        initMap(expenseByMethodCurrencyCash, transaction, key: key);
        expenseByMethodCurrencyCash[key]!.add(tv);
      } else {
        initMap(expenseByMethodCurrencyCard, transaction, key: key);
        expenseByMethodCurrencyCard[key]!.add(tv);

        if (!expenseByMethod.containsKey(transaction.method)) {
          expenseByMethod[transaction.method] = initTransaction();
        }
        expenseByMethod[transaction.method]!.add(tv);
      }

      expenseAll.add(tv);
      return true;
    }
    return false;
  }

  bool processDeposit(
      final Transaction transaction, final TransactionValue tv) {
    if (transaction.isWithdrawal || transaction.isCashDeposit) {
      initMap(depositByCurrency, transaction);
      depositByCurrency[transaction.currency]!.add(tv);

      balanceCash.add(tv);

      initMap(balanceByCurrency, transaction);
      balanceByCurrency[transaction.currency]!.add(tv);

      if (transaction.isWithdrawal) {
        withdrawalAll.add(tv);
        initMap(withdrawalByMethod, transaction, key: transaction.method);
        withdrawalByMethod[transaction.method]!.add(tv);

        String key = '${transaction.method} ${transaction.currencyString}';
        initMap(withdrawalByMethodCurrencyCard, transaction, key: key);
        withdrawalByMethodCurrencyCard[key]!.add(tv);
      } else if (transaction.isCashDeposit) {
        cashFunds.add(tv);
        initMap(cashFundsByCurrency, transaction,
            key: transaction.currencyString);
        cashFundsByCurrency[transaction.currencyString]!.add(tv);
      }
      return true;
    }
    return false;
  }

  void add(final Transaction transaction) {
    final tv = currencyProvider.getTransactionValue(transaction);
    if (!processExpense(transaction, tv)) {
      processDeposit(transaction, tv);
    }
  }
}
