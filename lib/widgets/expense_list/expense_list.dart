import 'package:expense_tracker_app/models/expense_model.dart';
import 'package:expense_tracker_app/providers/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_app/widgets/expense_list/expense_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseList extends ConsumerWidget {
  const ExpenseList({
    // required this.expenses,
    required this.onRemoved,
    super.key,
  });
  // final List<ExpenseModel> expenses;
  final void Function(ExpenseModel) onRemoved;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expenseProvider);
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (BuildContext context, int index) => Dismissible(
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(0.75),
          margin: EdgeInsets.symmetric(
            horizontal: Theme.of(context).cardTheme.margin!.horizontal,
          ),
        ),
        key: ValueKey(expenses[index]),
        onDismissed: (DismissDirection direction) {
          onRemoved(expenses[index]);

          if (!context.mounted) return;
        },
        child: ExpenseItem(expenses[index]),
      ),
    );
  }
}
