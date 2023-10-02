import 'package:flutter/material.dart';

import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

//final uuid = Uuid();
//final uuid = const Uuid();
//the above method is also valid
//making it const

const uuid = Uuid();

//because of using const it will get stored
// in memory and thus fast retrieval and cant
// be assigned later

//in this class we don't want to initialize the id and hence we
//install the package uuid and  use it to generate random
//id and for that we put a semi colon after the constructor and use the
//initializer
//in dart initializer lists can be used to initialize class
//properties like id with values that are not received as
//constructor function arguments.

enum Category { food, travel, leisure, work }

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work,
};

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  //v4 generates a unique string id and is initiliazed to id
  //this initializer is the dart feature and uuid is a flutter packager
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }
}

class ExpenseBucket {
  const ExpenseBucket({required this.category, required this.expenses});

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  //where is a method provided by dart to filter a list
  //takes a function as argument and get individual list item as input

  //filters the expenses that belong to specific category, it is a utility function
  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    //this sums up all the expense we have here
    double sum = 0;
    //for(var i = 0; i < expenses.length; i++) or we can use below syntax
    for (final expense in expenses)
    //we tell dart we wan to go through every item in the expenses, every iteration a new item will be picked and will be stored in
    //a newly created final variable called expense.
    {
      sum += expense.amount;
    }
    return sum;
  }
}
