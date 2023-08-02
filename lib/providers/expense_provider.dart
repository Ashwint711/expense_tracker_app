import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/expense_model.dart';

import 'package:http/http.dart' as http;

class ExpenseNotifier extends StateNotifier<List<ExpenseModel>> {
  ExpenseNotifier() : super([]);
  //Loading Expenses from the Firebase Realtime Database
  Future<String?> loadExpenses() async {
    final url = Uri.https('expense-tracker-80f99-default-rtdb.firebaseio.com',
        'expense-list.json');
    final response = await http.get(url);
    if (response.statusCode >= 400) {
      return 'Oops... Something went wrong!';
    }
    if (response.body != 'null') {
      // print('Response.body is not null');
      // print(response.body);
      final Map<String, dynamic> loadedData = json.decode(response.body);
      List<ExpenseModel> loadedExpenses = [];

      for (final item in loadedData.entries) {
        // print(item);
        String title = item.value['title'];
        double? amount = item.value['amount'];
        DateTime date = DateTime.parse(item.value['date']);
        ExpenseCategory category = ExpenseCategory.values.firstWhere(
            (enumValue) => enumValue.name == item.value['expenseCategory']);
        loadedExpenses.add(
          ExpenseModel(
            title: title,
            amount: amount!,
            date: date,
            expenseCategory: category,
            id: item.key,
          ),
        );
      }
      state = loadedExpenses;
    } else {
      return 'No expense found, Start adding some.';
    }
    return null;
  }

  void addExpense(
      {required String title,
      required double amount,
      required DateTime date,
      required ExpenseCategory category}) async {
    // Posting expense to the Database
    final url = Uri.https('expense-tracker-80f99-default-rtdb.firebaseio.com',
        'expense-list.json');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': title,
        'amount': amount,
        'date': date.toString(),
        'expenseCategory': category.name,
      }),
    );
    // Fetching the id of the expense Item
    final itemId = json.decode(response.body);

    // Creating Expense Object using passed data
    ExpenseModel expense = ExpenseModel(
        title: title,
        amount: amount,
        date: date,
        expenseCategory: category,
        id: itemId['name']);

    // Converting Json Id data to Map
    state = [...state, expense];
  }

  late int index;
  Future<bool> removeExpense(ExpenseModel expense) async {
    index = state.indexOf(expense);
    state = state.where((element) {
      return element != expense;
    }).toList();
    // Deleting from the Database
    final url = Uri.https('expense-tracker-80f99-default-rtdb.firebaseio.com',
        'expense-list/${expense.id}.json');
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      insertExpense(expense);
      return false;
    }
    return true;
  }

  void insertExpense(ExpenseModel expense) {
    List<ExpenseModel> expenses = List.of(state);
    expenses.insert(index, expense);
    state = expenses;
    // Posting expense to the Database
    final url = Uri.https('expense-tracker-80f99-default-rtdb.firebaseio.com',
        'expense-list.json');
    http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': expense.title,
        'amount': expense.amount,
        'date': expense.date.toString(),
        'expenseCategory': expense.expenseCategory.name,
      }),
    );
    // Fetching the id of the expense Item
    // final itemId = json.decode(response.body);
  }
}

final expenseProvider =
    StateNotifierProvider<ExpenseNotifier, List<ExpenseModel>>((ref) {
  return ExpenseNotifier();
});
