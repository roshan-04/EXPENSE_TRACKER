import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:expense_tracker/models/expense.dart';
//we have imported expense.dart just because it have date formatter uutil adn to use it

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  /*
  in the above case while declaring _selectedDate we dont put
  var or final because it DateTime is a type
  and we should put a questions mark after
  DateTime because it will not initially hold a value and
  and to tell dart that _selectedDate hold a value of type DateTime
  or a null
  */

  //this is the object that cna be passed to textfield for handling the input and it is a object;
  //also we have to delete the controller after the widget is not in use
  /*
  var _enteredTitle = '';
  void _saveTitleInput(String inputValue) {
    _enteredTitle = inputValue;
    //no need to use setState because we don't have to use it inside.
  }
  */

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now, //initial date selected
      firstDate: firstDate, //lowest possible date that can be selected
      lastDate: now, // maximum date that can be selected
    );
    //showDatePicker return the date but it is wrapped in the future, a value of type future
    //it is object that wraps for a value that we don't have yet, but will have in the future
    //so for that date picker of store the selected date
    //so we can use a then method to which we can pass a function will be executed once the date is picked
    //First method is : showDatePicker().then((value) {});
    //Second method is : use async and await keyword
    //void _presentDatePicker() async {
    //     await showDatePicker()
    //   }
    //you cant use await, async in the build method
    //while using await keyword you get the date in a vairable
    //await tells the flutter that teh value in the variable pickedDate is not available now but will be available in the future
    //

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _showDialog() {
    //you can use showCupertinoDialog to show alert dialog
    //on iOS
    //showCupertinoDialog(context: context, builder: builder)
    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
                title: const Text('Invalid Input'),
                content: const Text(
                    'Please make sure a valid title, amount, date and category was entered'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: const Text('Ok'),
                  ),
                ],
              ));
    }
    //show error message
    else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text(
              'Please make sure a valid title, amount, date and category was entered'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Ok'),
            ),
          ],
        ),
      );
    }
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    //try parse is something that takes string as a input and return double if it is able to convert that string into double, or else return null
    //tryParse 'Hello' => null and tryParse '1.22' = 1.22
    //trim is a built in function that trims the string removes even white spaces
    //isEmpty is a built in function that can be called on list and string to check whether it is empty.
    final amountIsValid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsValid ||
        _selectedDate ==
            null) //this will be true if we have empty string or blank spaces
    {
      _showDialog();
      return;
    }
    //you can write anything here
    widget.onAddExpense(Expense(
      title: _titleController.text,
      amount: enteredAmount,
      category: _selectedCategory,
      date: _selectedDate!,
    ));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    //after declaring controller we also have to
    //have to delete it otherwise it will take space and app will crash.
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    final keyboardSpace = MediaQuery.of(context)
        .viewInsets
        .bottom; //this bottom here gets any extra UI elements that are overlay the UI form the bottom
    //i an get the amount of space taken by keyboard
    return LayoutBuilder(
      builder: (ctx, constraints) {
        //because of this we come to know how much space is
        //available you can then decide which layout should be rendered
        //and this allows you to build a widget that can be used anywhere in your widget tree
        //and it does not care about the screen orientation but only cares about the width and height is available to this specific
        //widget here, we can also use media query
        //we can also use this expense widget anywhere else in our widget tree
        //and it would only care about the constraints set by the parent widget
        //it would not care about the available screen width or height
        // print(constraints.minWidth);
        // print(constraints.maxWidth);
        // print(constraints.minHeight);
        // print(constraints.maxHeight);
        //hence we use, width to get maximum width based on available width
        final width = constraints.maxWidth;
        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
              //the 48 is not ideal approach
              child: Column(
                children: [
                  if (width >= 600)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _titleController,
                            //onChanged: _saveTitleInput,
                            maxLength: 50,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              label: Text('Title'),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              prefixText: '\$ ',
                              label: Text('Amount'),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    TextField(
                      controller: _titleController,
                      //onChanged: _saveTitleInput,
                      maxLength: 50,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        label: Text('Title'),
                      ),
                    ),
                  if (width >= 600)
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
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(_selectedDate == null
                                  ? 'No date selected'
                                  : formatter.format(_selectedDate!)),
                              //we put exclamation mark after _selectedDate because formatter wants value that cannot be null and hence to make assure dart that it wont be null we put it.
                              IconButton(
                                onPressed: _presentDatePicker,
                                icon: const Icon(Icons.calendar_month),
                              ),
                            ],
                          ),
                        )
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
                              prefixText: '\$ ',
                              label: Text('Amount'),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(_selectedDate == null
                                  ? 'No date selected'
                                  : formatter.format(_selectedDate!)),
                              //we put exclamation mark after _selectedDate because formatter wants value that cannot be null and hence to make assure dart that it wont be null we put it.
                              IconButton(
                                onPressed: _presentDatePicker,
                                icon: const Icon(Icons.calendar_month),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  //we have 2 ways to store the data entered in the textfield
                  //add another parameter called onChanged parameter which allows
                  //us to register a function which will be triggered whenever the value
                  //in that textfield changes, for example when  user press a key
                  //onChanged wants a function that will receive a string
                  //and that string will be the value entered in the textfield
                  //but using this approach it is cumbersome to do this for each testfield adn
                  //hence we use another approach using Controller
                  const SizedBox(
                    height: 16,
                  ),

                  if (width >= 600)
                    Row(
                      children: [
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
                    )
                  else
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
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _selectedCategory = value;
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
      },
    );
  }
}
