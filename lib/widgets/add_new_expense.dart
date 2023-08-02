import 'package:expense_tracker_app/models/expense_model.dart';
import 'package:expense_tracker_app/providers/expense_provider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddNewExpense extends ConsumerStatefulWidget {
  const AddNewExpense({
    super.key,
  });

  @override
  ConsumerState<AddNewExpense> createState() => _AddNewExpenseState();
}

class _AddNewExpenseState extends ConsumerState<AddNewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate = DateTime.now();
  ExpenseCategory _selectedCategory = ExpenseCategory.leisure;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _datePicker() async {
    final now = DateTime.now();
    var currentDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(now.year - 1, now.month, now.day),
        lastDate: now);
    setState(() {
      _selectedDate = currentDate;
    });
  }

  void _addNewExpense() async {
    String title = _titleController.text.trim();
    double? amount = double.tryParse(_amountController.text);
    if (title.isEmpty || title.length <= 1 || amount == null || amount <= 0) {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text('Invalid Details!'),
              content: const Text(
                  'Please enter valid title,amount,category and date'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Okay'),
                ),
              ],
            );
          });
    } else {
      setState(() {
        _isSending = true;
      });

      ref.read(expenseProvider.notifier).addExpense(
            title: title,
            amount: amount,
            date: _selectedDate!,
            category: _selectedCategory,
          );

      Navigator.of(context).pop();
    }
  }

  var _isSending = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final overflow = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx, constraints) {
      return Padding(
        padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, overflow + 16.0),
        child: ListView(
          children: [
            if (constraints.maxWidth > 600)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _titleController,
                      maxLength: 50,
                      decoration: const InputDecoration(
                        label: Text('Title'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        label: Text('Amount'),
                        prefix: Text('₹'),
                      ),
                    ),
                  ),
                ],
              )
            else
              Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    label: Text('Title'),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 150,
                      child: TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text('Amount'),
                          prefix: Text('₹'),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _selectedDate == null
                              ? 'No date selected'
                              : dateFormatter.format(_selectedDate!),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          onPressed: () {
                            _datePicker();
                          },
                          icon: const Icon(Icons.calendar_month),
                        ),
                      ],
                    )
                  ],
                ),
              ]),
            if (width > 600)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton(
                    value: _selectedCategory,
                    items: [
                      for (final category in ExpenseCategory.values)
                        DropdownMenuItem(
                          value: category,
                          child: Text(category.name.toUpperCase()),
                        ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _selectedDate == null
                            ? 'No date selected'
                            : dateFormatter.format(_selectedDate!),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        onPressed: () {
                          _datePicker();
                        },
                        icon: const Icon(Icons.calendar_month),
                      ),
                    ],
                  )
                ],
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton(
                    value: _selectedCategory,
                    items: [
                      for (final category in ExpenseCategory.values)
                        DropdownMenuItem(
                          value: category,
                          child: Text(category.name.toUpperCase()),
                        ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: _isSending
                            ? null
                            : () {
                                Navigator.of(context).pop();
                              },
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 4),
                      ElevatedButton(
                        onPressed: _isSending
                            ? null
                            : () {
                                _addNewExpense();
                              },
                        child: _isSending
                            ? const SizedBox(
                                height: 20,
                                width: 60,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : const Text('Add Expense'),
                      ),
                    ],
                  ),
                ],
              ),
            if (width > 600)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 4),
                  ElevatedButton(
                    onPressed: () {
                      _addNewExpense();
                    },
                    child: const Text('Add Expense'),
                  ),
                ],
              ),
          ],
        ),
      );
    });
  }
}
