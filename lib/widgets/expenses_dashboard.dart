import 'package:expense_tracker_app/models/expense_model.dart';
import 'package:expense_tracker_app/providers/expense_provider.dart';
import 'package:flutter/material.dart';

import 'package:expense_tracker_app/widgets/add_new_expense.dart';
import 'package:expense_tracker_app/widgets/expense_list/expense_list.dart';
import 'package:expense_tracker_app/widgets/chart/chart.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class Expenses extends ConsumerStatefulWidget {
  const Expenses({super.key});
  @override
  ConsumerState<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends ConsumerState<Expenses> {
  var _error = '';
  @override
  void initState() {
    loadExpenses();
    super.initState();
  }

  void loadExpenses() async {
    // Calling a function which is loading Data from the Database.
    final response = await ref.read(expenseProvider.notifier).loadExpenses();
    if (response != null) {
      setState(() {
        _error = response;
      });
    } else {}
  }

  void removeExpense(ExpenseModel expense) async {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense Removed'),
        action: SnackBarAction(label: 'Undo', onPressed: () {}),
      ),
    );
    final isRemoved =
        await ref.read(expenseProvider.notifier).removeExpense(expense);
    if (!isRemoved) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to remove expense!'),
        ),
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final expenses = ref.watch(expenseProvider);
    final width = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(
      child: CircularProgressIndicator(),
    );

    // If load expense fails
    if (_error.length >= 2) {
      mainContent = Center(
        child: Text(_error),
      );
    }
    if (expenses.isNotEmpty) {
      mainContent = ExpenseList(
        onRemoved: removeExpense,
      );
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
              Icons.add,
            ),
          ),
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: expenses),
                Expanded(child: mainContent),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Chart(expenses: expenses)),
                Expanded(child: mainContent),
              ],
            ),
    );
  }

  void _addExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      context: context,
      builder: (ctx) => const AddNewExpense(),
    );
  }
}
