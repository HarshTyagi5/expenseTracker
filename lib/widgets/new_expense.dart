import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;
  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  // here is the variable and function for the onChanged function

  // var _enteredTitle = '';

  // void _saveTitleInput(String inputValue) {
  //   _enteredTitle = inputValue;
  // }

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;
  // to dispose the controller when the widget is no longer visible on UI.
  // dispose method automatically called by flutter like build or init methods.

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void validateSubmittedExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (amountIsInvalid ||
        _titleController.text.trim().isEmpty ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Values!'),
          content:
              const Text('Please make sure all the entered values are valid.'),
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
      return;
    } else {
      widget.onAddExpense(
        Expense(
            amount: enteredAmount,
            date: _selectedDate!,
            title: _titleController.text,
            category: _selectedCategory),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return Expanded(
      child: SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace+16),
            child: Column(
              children: [
                TextField(
                  // 'onChanged is used to handle or storing user input with the help of
                  // variable and a function.'
        
                  // onChanged: _saveTitleInput,
        
                  controller: _titleController,
                  maxLength: 50,
                  decoration: const InputDecoration(
                    label: Text('Title'),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        controller: _amountController,
                        maxLength: 12,
                        decoration: const InputDecoration(
                          prefixText: 'Rs. ',
                          label: Text('Enter Amount'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              _selectedDate == null
                                  ? 'No Date Selected'
                                  : formatter.format(_selectedDate!),
                            ),
                          ),
                          IconButton(
                            onPressed: _presentDatePicker,
                            icon: const Icon(Icons.calendar_month_rounded),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    DropdownButton(
                      value: _selectedCategory,
                      items: Category.values
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
                        if (value == null) return;
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                    ),
                    const Spacer(),
                    // saving expense Button
                    ElevatedButton(
                      onPressed: () {
                        validateSubmittedExpenseData();
                      },
                      child: const Text('save expense'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('cancel'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
