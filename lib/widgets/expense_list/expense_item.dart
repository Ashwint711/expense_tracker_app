import 'package:expense_tracker_app/models/expense_model.dart';
import 'package:flutter/material.dart';

// Displaying expense item on the dashboard body

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expense, {super.key});
  final ExpenseModel expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              expense.title,
              // Using our own theme for styling Title Text
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("₹ ${expense.amount.toStringAsFixed(2)}"),
                const Spacer(), //This is same as using => MainAxisAlignment.spaceBetween
                Row(
                  children: [
                    Icon(categoryIconsMap[
                        expense.expenseCategory]), //For ExpenseCategory
                    const SizedBox(width: 10),
                    Text(expense.formattedDate),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/*
 Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            margin: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              "\$ ${expense.amount.toStringAsFixed(2)}",
              //.toStringAsFixed(2) : 12.2333 => 12.23
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.title,
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                ),
                const SizedBox(height: 6),
                Text(
                  DateFormat.yMMMEd().format(expense.date),
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                ),
              ],
            ),
          ),
        ]), */
