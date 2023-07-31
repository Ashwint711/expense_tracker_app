import 'dart:convert';

import 'package:expense_tracker_app/models/expense_model.dart';
import 'package:expense_tracker_app/providers/expense_provider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:http/http.dart' as http;

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
      // Posting expense to the Database
      final url = Uri.https('expense-tracker-80f99-default-rtdb.firebaseio.com',
          'expense-list.json');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'title': title,
          'amount': amount,
          'date': _selectedDate!.toString(),
          'expenseCategory': _selectedCategory.name,
        }),
      );

      // Converting Json Id data to Map
      final itemId = json.decode(response.body);

      ref.read(expenseProvider.notifier).addExpense(
            ExpenseModel(
              id: itemId['name'],
              title: title,
              amount: amount,
              date: _selectedDate!,
              expenseCategory: _selectedCategory,
            ),
          );
      if (!context.mounted) return;
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


/*
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_app/models/expense_model.dart';

class AddNewExpense extends StatefulWidget {
  const AddNewExpense({required this.populateExpenseList, super.key});
  final Function populateExpenseList;
  @override
  State<AddNewExpense> createState() => _AddNewExpenseState();
}

class _AddNewExpenseState extends State<AddNewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  ExpenseCategory _selectedItem = ExpenseCategory.leisure;
  final List<DropdownMenuItem<Object>> dropDownItems = [];

  void _presentDatePicker() async {
    final now = DateTime.now();
    var date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1, now.month, now.day),
      lastDate: now,
    );
    setState(() {
      _selectedDate = date;
    });
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('Invalid Input'),
          content: const Text(
              'Please enter valid title, amount , date and category.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text(
              'Please enter valid title, amount , date and category.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    }
  }

  // Method for submitting the modal
  void _submitExpenseData() {
    final enteredAmount = double.tryParse(
        _amountController.text); //'11.12' => 11.12 , 'hello' => null
    final isAmountInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        isAmountInvalid ||
        _selectedDate == null) {
      // display an error message
      _showDialog();
      //and exit from this function
      return;
    }
    // if Correct data is entered then...
    Navigator.pop(context);
    widget.populateExpenseList(
      ExpenseModel(
          title: _titleController.text,
          amount: enteredAmount,
          date: _selectedDate!,
          expenseCategory: _selectedItem),
    );
  }

  //Executed at the time of removing/deleting _AddNewExpenseState object
  @override
  void dispose() {
    _titleController.dispose(); //removing this object from the memory
    _amountController.dispose(); //removing this object from the memory
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // viewInsets object contains information about UI elements that might be overlapping in the widget tree
    final keyboardOverlappingSpace = MediaQuery.of(context).viewInsets.bottom;
    /* MODAL */
    return LayoutBuilder(builder: (ctx, constraints) {
      // print(constraints.minWidth);
      // print(constraints.maxWidth);
      // print(constraints.minHeight);
      // print(constraints.maxHeight);
      final width = constraints.maxWidth;
      return SizedBox(
        // width: double.infinity, //Not working
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.fromLTRB(16, 16, 16, keyboardOverlappingSpace + 16),
            child: Column(
              children: [
                if (width >= 600)
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
                      const SizedBox(width: 24),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: '₹ ',
                            label: Text('Amount'),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    controller: _titleController,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text('Title'),
                    ),
                  ),
                if (width >= 600)
                  Row(
                    children: [
                      DropdownButton(
                        value: _selectedItem,
                        items: ExpenseCategory.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(
                                  category.name.toUpperCase(),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _selectedItem = value;
                          });
                        },
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _selectedDate == null
                                  ? 'No date selected'
                                  : dateFormatter.format(_selectedDate!),
                            ),
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(
                                Icons.calendar_month,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: '₹ ',
                            label: Text('Amount'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _selectedDate == null
                                  ? 'No date selected'
                                  : dateFormatter.format(_selectedDate!),
                            ),
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(
                                Icons.calendar_month,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (width >= 600)
                      const Spacer()
                    else
                      DropdownButton(
                        value: _selectedItem,
                        items: ExpenseCategory.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(
                                  category.name.toUpperCase(),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _selectedItem = value;
                          });
                        },
                      ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: _submitExpenseData,
                      child: const Text('Save Expense'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
 */