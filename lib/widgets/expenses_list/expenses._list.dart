import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

import 'package:expense_tracker/widgets/expenses_list/expense_item.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({
    super.key,
    required this.expenses,
    required this.onRemoveExpense,
  });

  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;

  @override
  Widget build(context) {
    return ListView.builder(
      itemCount: expenses.length,
      //dismissible is a widget that makes the content swipeable
      itemBuilder: (ctx, index) => Dismissible(
        //just to show red color while swiping the element
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(0.75),
          margin: EdgeInsets.symmetric(
              horizontal: Theme.of(context).cardTheme.margin!.horizontal),
        ),
        key: ValueKey(expenses[index]),
        //a key is needed to make the widgets uniquely identifiable
        //and the data associated with it
        onDismissed: (direction) {
          onRemoveExpense(
              expenses[index]); //trigger a function when a thing is dismissed
        },
        child: ExpenseItem(
          expenses[index],
        ),
      ),
    );
  }
}
