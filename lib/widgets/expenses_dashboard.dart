import 'package:flutter/material.dart';

import 'package:expense_tracker_app/models/expense_model.dart';
import 'package:expense_tracker_app/widgets/add_new_expense.dart';
import 'package:expense_tracker_app/widgets/expense_list/expense_list.dart';
import 'package:expense_tracker_app/widgets/chart/chart.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  void _addExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      context: context,
      builder: (ctx) => AddNewExpense(populateExpenseList: _addNewExpense),
    );
  }

  void _addNewExpense(expenseObject) {
    setState(() {
      _expenses.add(expenseObject);
    });
  }

  void _removeExpense(expenseObject) {
    final index = _expenses.indexOf(expenseObject);
    setState(() {
      _expenses.remove(expenseObject);
    });
    /*------------------------------*/
    //       THIS ALSO WORKS
    // _expenses.remove(expenseObject);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense removed!'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _expenses.insert(index, expenseObject);
            });
          },
        ),
      ),
    );
  }

  final List<ExpenseModel> _expenses = [
    ExpenseModel(
      title: "Flutter Course",
      amount: 499,
      date: DateTime.now(),
      expenseCategory: ExpenseCategory.work,
    ),
    ExpenseModel(
      title: "Cinema",
      amount: 220,
      date: DateTime.now(),
      expenseCategory: ExpenseCategory.leisure,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    Widget mainContent = const Center(
      child: Text('No expense found, Start adding some.'),
    );
    if (_expenses.isNotEmpty) {
      mainContent = ExpenseList(expenses: _expenses, onRemoved: _removeExpense);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Flutter ExpenseTracker",
        ),
        actions: [
          IconButton(
            onPressed: _addExpenseOverlay, //Add new expense modal
            icon: const Icon(
              Icons.add, // +
            ),
          ),
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                // Container(
                //   height: 200,
                //   width: double.infinity,
                //   color: Colors.blue,
                //   padding: const EdgeInsets.only(top: 100),
                //   child: const Text(
                //     "Chart",
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                Chart(expenses: _expenses),
                Expanded(child: mainContent),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Chart(expenses: _expenses)),
                Expanded(child: mainContent),
              ],
            ),
    );
  }
}
