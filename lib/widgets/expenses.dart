import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  var totalExpense = 1900.0;
  final List<Expense> _registeredExpenses = [
    Expense(
        title: 'Flutter Course',
        amount: 900,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: 'Movie',
        amount: 1000,
        date: DateTime.now(),
        category: Category.leisure),
  ];

  void _openAndExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return NewExpense(
          onAddExpense: _addExpense,
        );
      },
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      totalExpense += expense.amount;
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    int expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      if (totalExpense != 0) {
        totalExpense -= expense.amount;
      }

      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        duration: const Duration(seconds: 3),
        content: const Text(
          'Expense deleted',
          style: TextStyle(color: Colors.black87),
        ),
        action: SnackBarAction(
          textColor: Colors.blue,
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(child: Text('Add some expenses!'));

    var width = MediaQuery.of(context).size.width;

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Expenses Tracker'),
          actions: [
            IconButton(
              onPressed: _openAndExpenseOverlay,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: width < 600
            ? Column(
                children: [
                  Chart(expenses: _registeredExpenses),
                  Text('total expense :  $totalExpense'),
                  Expanded(
                    child: mainContent,
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: Chart(expenses: _registeredExpenses),
                  ),
                  Text('total expense :  $totalExpense'),
                  Expanded(
                    child: mainContent,
                  ),
                ],
              ));
  }
}
