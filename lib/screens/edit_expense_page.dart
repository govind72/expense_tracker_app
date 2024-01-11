import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'home_page.dart';
import 'package:http/http.dart' as http;

class EditExpensePage extends StatefulWidget {
  static const String id = 'edit_expense_page';
  final Map<String, dynamic> expenseDetails;

  const EditExpensePage({Key? key, required this.expenseDetails}) : super(key: key);

  @override
  _EditExpensePageState createState() => _EditExpensePageState();
}

class _EditExpensePageState extends State<EditExpensePage> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  int isSpent = 0;

  @override
  void initState() {
    super.initState();
    // Initialize text controllers with existing expense details
    descriptionController.text = widget.expenseDetails['description'];
    amountController.text = widget.expenseDetails['amount']!.toString();
    dateController.text = widget.expenseDetails['date'] ?? '';
    categoryController.text = widget.expenseDetails['category'] ?? '';
    isSpent = widget.expenseDetails['spent']==1 ? 0 : 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: const Text('Edit Expense'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              keyboardType: TextInputType.text,
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
            ),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                icon: Icon(Icons.calendar_today),
                labelText: 'Enter Date',
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );

                if (pickedDate != null) {
                  String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                  setState(() {
                    dateController.text = formattedDate;
                  });
                } else {
                  print('Date is not selected');
                }
              },
            ),
            TextField(
              controller: categoryController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Spent:'),
                const SizedBox(width: 20),
                ToggleSwitch(
                  initialLabelIndex : isSpent,
                  customWidths: const [90.0, 90.0],
                  cornerRadius: 20.0,
                  activeBgColors: const [[Colors.red], [Colors.green]],
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.white,
                  totalSwitches: 2,
                  labels: const ['Spent', 'Credit'],
                  onToggle: (index) {
                    print('switched to: $index');
                    isSpent = index!;
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _updateExpense,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
      );
    }

  void _updateExpense() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final expenseId = widget.expenseDetails['id'];
    print(isSpent);
    final response = await http.patch(
      Uri.parse('http://10.0.2.2:8000/api/expenses/$expenseId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'amount': amountController.text,
        'description': descriptionController.text,
        'date': dateController.text,
        'category': categoryController.text,
        'spent': isSpent==0 ? '1' : '0',
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pushReplacementNamed(context, HomePage.id);

    } else {
      print('Error: ${json.decode(response.body)['message']}');
    }
  }
}
