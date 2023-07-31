// import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

final dateFormatter = DateFormat.yMd();

// const uuid = Uuid();

// Enum
enum ExpenseCategory { food, travel, leisure, work }

const categoryIconsMap = {
  ExpenseCategory.food: Icons.lunch_dining,
  ExpenseCategory.leisure: Icons.movie,
  ExpenseCategory.work: Icons.work,
  ExpenseCategory.travel: Icons.flight_takeoff,
};

class ExpenseModel {
  ExpenseModel({
    required this.title,
    required this.amount,
    required this.date,
    required this.expenseCategory,
    required this.id,
  });
  // : id = uuid.v4(); //Initializer
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final ExpenseCategory expenseCategory;

  String get formattedDate {
    return dateFormatter.format(date);
  }
}

class ExpenseBucket {
  const ExpenseBucket({required this.category, required this.expenses});

  // Used Initializer method because expense is a final data container which must be initialized
  // at the time of object creation
  ExpenseBucket.forCategory(List<ExpenseModel> allExpenses, this.category)
      : expenses = allExpenses
            .where((expenseItem) => expenseItem.expenseCategory == category)
            .toList();

  final ExpenseCategory category;
  final List<ExpenseModel> expenses;

  double get totalExpenses {
    double sum = 0;
    for (final expenseItem in expenses) {
      sum += expenseItem.amount;
    }
    return sum;
  }
}
