import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'home_page.dart';

class NewExpensePage extends StatefulWidget {
  static const String id = 'new_expense_page';
  const NewExpensePage({Key? key});

  @override
  State<NewExpensePage> createState() => _NewExpensePageState();
}

class _NewExpensePageState extends State<NewExpensePage> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController categoryPasswordController = TextEditingController();
  var isSpent = 0; // Default value for spent

  Future<void> addExpense() async {
    print(isSpent);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    BuildContext localContext = context;
    final response = await http.post(

      Uri.parse('http://10.0.2.2:8000/api/expenses'),
      headers: {
        'Authorization': 'Bearer $token',
      },

      body: {
        'amount': amountController.text,
        'description': descriptionController.text,
        'date': dateController.text,
        'category': categoryPasswordController.text,
        'spent': isSpent==0 ? "1" : "0", // Convert boolean to string
      },
    );

    if (response.statusCode == 200) {
      // Navigator.pushNamed(localContext, HomePage.id);
      Navigator.pushReplacement(
        localContext,
        MaterialPageRoute(
          builder: (localContext) => const HomePage(),
        ),
      ).then((_) {
        Navigator.popUntil(context, (route) => route.isFirst);
      });

    } else {
      print('Error: ${json.decode(response.body)['message']}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Expense'),
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
              controller: categoryPasswordController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Spent:'),
                const SizedBox(width: 50,),
                ToggleSwitch(
                  customWidths: const [90.0, 90.0],
                  cornerRadius: 20.0,
                  activeBgColors: const [[Colors.red], [Colors.green]],
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.white,
                  totalSwitches: 2,
                  labels: const ['Spent', 'Credit'],
                  // icons: const [FontAwesomeIcons.yenSign, FontAwesomeIcons.times],
                  onToggle: (index) {
                    print('switched to: $index');
                    isSpent = index!;
                  },
                ),
              ],
            ),
            const SizedBox(height: 30,),
            ElevatedButton(
              onPressed: addExpense,
              child: const Text('Add Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
