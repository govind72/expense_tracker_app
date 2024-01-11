import 'dart:convert';
import 'package:expense_tracker_app/screens/edit_expense_page.dart';
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
        centerTitle: true,
        title: const Text('Expense Tracker'),
        leading: IconButton(
          onPressed: () {
            _logout();
          },
          icon: const Icon(Icons.exit_to_app),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, NewExpensePage.id);
                  },
                  icon: const Icon(Icons.add_box_outlined),
                ),
              ],
            ),
          )
        ],
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
                  color: const Color(0xFFEC35E8).withOpacity(0.3),
                  title: 'Spent',
                  amount: calculateSpent(),
                ),
                const SizedBox(width: 20),
                ExpenseContainer(
                  color: const Color(0xFF92A3FD).withOpacity(0.3),
                  title: 'Income',
                  amount: calculateIncome(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListView.builder(
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    final reversedIndex = expenses.length - 1 - index;
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(expenses[reversedIndex]['description']),
                        subtitle: Text(
                          'Amount: \$${expenses[reversedIndex]['amount']}',
                          style: TextStyle(
                            color: expenses[reversedIndex]['spent'] == 1
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                        onTap: () {
                          _showExpenseDetails(expenses[reversedIndex]);
                        },
                        trailing: IconButton(
                          onPressed: () {
                            _deleteExpense(expenses[reversedIndex]['id']);
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('token');
    final response = await http.post(

      Uri.parse('http://10.0.2.2:8000/api/logout'),
      headers: {
        'Authorization': 'Bearer $token',
      },

    );

    if (response.statusCode == 200) {
      prefs.remove('token');
      prefs.remove('loggedIn');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (localContext) => const LoginScreen(),
        ),
      ).then((_) {
        Navigator.popUntil(context, (route) => route.isFirst);
      });

    } else {
      print('Error: ${json.decode(response.body)['message']}');
    }

  }

  void _showExpenseDetails(Map<String, dynamic> expenseDetails) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Expense Details',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          contentPadding: const EdgeInsets.all(16.0),
          content: Container(
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDetailRow('Description', expenseDetails['description']),
                _buildDetailRow('Amount', '\$${expenseDetails['amount']}'),
                _buildDetailRow('Date', expenseDetails['date']),
                _buildDetailRow('Category', expenseDetails['category']),
                _buildDetailRow('Spent', expenseDetails['spent'] == 1 ? 'Yes' : 'No'),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditExpensePage(expenseDetails: expenseDetails),
                  ),
                );

              },
              child: const Text('Edit'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            '$label:',
            style:const  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
              value != null ? value.toString() : 'N/A',
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }


  double calculateSpent() {
    // Filter expenses where 'spent' is true (1) and sum up the 'amount' field
    double spentAmount = expenses
        .where((expense) => expense['spent'] == 1)
        .fold(0, (sum, expense) => sum + double.parse(expense['amount']));
    return spentAmount;
  }

  double calculateIncome() {
    // Filter expenses where 'spent' is false (0) and sum up the 'amount' field
    double incomeAmount = expenses
        .where((expense) => expense['spent'] == 0)
        .fold(0, (sum, expense) => sum + double.parse(expense['amount']));
    return incomeAmount;
  }

  // Function to delete an expense
  void _deleteExpense(int expenseId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.delete(
      Uri.parse('http://10.0.2.2:8000/api/expenses/$expenseId'), // Replace with your endpoint
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Reload expenses after deletion
      loadExpenses();

    } else {
      // Handle error
      print('Error: ${response.statusCode}');
    }
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
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: title.toLowerCase() == 'spent' ? Colors.red : Colors.green,
            ),
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