import 'package:flutter/material.dart';

import 'package:expense_tracker/models/expense.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expense, {super.key});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              expense.title,
              //theme of is constructed to connection with context we can access texttheme we have set and which already exist
              style: Theme.of(context).textTheme.titleLarge, //you can also use .copyWith() here
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Text('\$${expense.amount.toStringAsFixed(2)}'
                    //12.34453536 => 12.34
                    ),
                const Spacer(),
                Row(
                  children: [
                    Icon(categoryIcons[expense.category]),
                    const SizedBox(
                      width: 8.0,
                    ),
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