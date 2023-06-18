import 'package:expense_tracker_app/models/expense_model.dart';
import 'package:expense_tracker_app/widgets/chart/chart_bar.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  const Chart({required this.expenses, super.key});

  final List<ExpenseModel> expenses;

  List<ExpenseBucket> get buckets {
    return [
      ExpenseBucket.forCategory(expenses, ExpenseCategory.food),
      ExpenseBucket.forCategory(expenses, ExpenseCategory.leisure),
      ExpenseBucket.forCategory(expenses, ExpenseCategory.travel),
      ExpenseBucket.forCategory(expenses, ExpenseCategory.work),
    ];
  }

  double get maxTotalExpense {
    double max = 0;
    for (ExpenseBucket bucket in buckets) {
      max = bucket.totalExpenses > max ? bucket.totalExpenses : max;
    }
    return max;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.only(top: 16),
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.onPrimary,
            Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: buckets
                      .map(
                        (bucket) => ChartBar(
                            fill: maxTotalExpense == 0
                                ? 0
                                : bucket.totalExpenses / maxTotalExpense),
                      )
                      .toList(),
                ),
              ),
            ),
            Row(
              children: [
                for (ExpenseBucket bucket in buckets)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 8.0),
                      child: Icon(
                        categoryIconsMap[bucket.category],
                        color: isDark
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.5),
                      ),
                    ),
                  )
              ],
            )
          ],
        ),
      ),
    );
  }
}
