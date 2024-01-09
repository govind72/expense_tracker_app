import 'dart:convert';

import 'package:expense_tracker_app/screens/login_screen.dart';
import 'package:expense_tracker_app/screens/new_expense_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  static const String id = 'home_screen';
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> expenses = [];

  @override
  void initState() {
    super.initState();
    // Fetch and load expenses when the widget is first created
    loadExpenses();
  }

  Future<void> loadExpenses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/expenses'), // Replace with your endpoint
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        expenses = json.decode(response.body)['expenses']['data'];
        print(expenses);
      });
    } else {
      // Handle error
      print('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ExpenseContainer(
                  color: const Color(0xffec35e8).withOpacity(0.3),
                  title: 'Spent',
                  amount: calculateSpent(),
                ),
                const SizedBox(width: 20),
                ExpenseContainer(
                  color: const Color(0xff92A3FD).withOpacity(0.3),
                  title: 'Income',
                  amount: calculateIncome(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                // Display the list of expenses
                child: ListView.builder(
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(expenses[index]['description']),
                        subtitle: Text('Amount: \$${expenses[index]['amount']}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {

                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: () {
                // Navigate to the NewExpensePage
                Navigator.pushNamed(context, NewExpensePage.id);
              },
              backgroundColor: Colors.green,
              child: const Icon(Icons.add),
            ),

          ],
        ),
      ),
    );
  }

  double calculateSpent() {
    // Implement your logic to calculate total spent
    // For example, you can sum up the 'amount' field from expenses list
    return 0.0;
  }

  double calculateIncome() {
    // Implement your logic to calculate total income
    // For example, you can sum up the 'amount' field from expenses list
    return 0.0;
  }
}

class ExpenseContainer extends StatelessWidget {
  final Color color;
  final String title;
  final double amount;

  const ExpenseContainer({
    Key? key,
    required this.color,
    required this.title,
    required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 175,
      width: 160,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            '\$$amount',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
