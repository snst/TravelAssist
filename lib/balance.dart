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

  final Map<String, TransactionValue> haveCashByCurrency =
      HashMap<String, TransactionValue>();

  final Map<String, TransactionValue> depositByCurrency =
      HashMap<String, TransactionValue>();

  final Map<String, TransactionValue> withdrawalByMethod =
      HashMap<String, TransactionValue>();
  final Map<String, TransactionValue> withdrawalByMethodCurrencyCard =
      HashMap<String, TransactionValue>();
  final Map<String, TransactionValue> cashDepositByCurrency =
      HashMap<String, TransactionValue>();

  final Map<String, TransactionValue> balanceByCurrency =
      HashMap<String, TransactionValue>();

  late TransactionValue expenseAll;
  late TransactionValue expenseCash;
  late TransactionValue expenseCard;
  late TransactionValue withdrawalAll;
  late TransactionValue cashDeposit;
  late TransactionValue haveCash;
  late TransactionValue balanceCash;
  int days = 1;

  TransactionValue initTransaction() {
    return TransactionValue(0, currencyProvider.getHomeCurrency());
  }

  Balance({required this.currencyProvider}) {
    expenseAll = initTransaction();
    expenseCash = initTransaction();
    expenseCard = initTransaction();
    haveCash = initTransaction();
    withdrawalAll = initTransaction();
    cashDeposit = initTransaction();
    balanceCash = initTransaction();
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
    if (transaction.isExpense || transaction.isBalance) {
      if (transaction.isCash) {
        haveCash.sub(tv);
        expenseCash.add(tv);

        initMap(haveCashByCurrency, transaction);
        haveCashByCurrency[transaction.currency]!.sub(tv);
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
      return transaction.isExpense;
    }
    return false;
  }

  bool processDeposit(
      final Transaction transaction, final TransactionValue tv) {
    if (transaction.isWithdrawal || transaction.isCashDeposit) {
      initMap(depositByCurrency, transaction);
      depositByCurrency[transaction.currency]!.add(tv);

      haveCash.add(tv);

      initMap(haveCashByCurrency, transaction);
      haveCashByCurrency[transaction.currency]!.add(tv);

      if (transaction.isWithdrawal) {
        withdrawalAll.add(tv);
        initMap(withdrawalByMethod, transaction, key: transaction.method);
        withdrawalByMethod[transaction.method]!.add(tv);

        String key = '${transaction.method} ${transaction.currencyString}';
        initMap(withdrawalByMethodCurrencyCard, transaction, key: key);
        withdrawalByMethodCurrencyCard[key]!.add(tv);
      } else if (transaction.isCashDeposit) {
        cashDeposit.add(tv);
        initMap(cashDepositByCurrency, transaction,
            key: transaction.currencyString);
        cashDepositByCurrency[transaction.currencyString]!.add(tv);
      }
      return true;
    }
    return false;
  }

  bool processBalance(
      final Transaction transaction, final TransactionValue tv) {
    if (transaction.isBalance) {
      balanceCash.add(tv);

      initMap(balanceByCurrency, transaction);
      balanceByCurrency[transaction.currency]!.add(tv);

      return true;
    }
    return false;
  }

  void add(final Transaction transaction) {
    final tv = currencyProvider.getTransactionValue(transaction);
    if (!processExpense(transaction, tv)) {
      if (!processDeposit(transaction, tv)) {
        processBalance(transaction, tv);
      }
    }
  }
}
