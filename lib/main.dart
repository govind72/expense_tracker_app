import 'package:expense_tracker_app/screens/edit_expense_page.dart';
import 'package:expense_tracker_app/screens/home_page.dart';
import 'package:expense_tracker_app/screens/login_screen.dart';
import 'package:expense_tracker_app/screens/new_expense_page.dart';
import 'package:expense_tracker_app/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check if the user is logged in
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getString('loggedIn') == 'yes';

  runApp(MyApp(initialRoute: isLoggedIn ? HomePage.id : LoginScreen.id));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({required this.initialRoute, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: {
        HomePage.id: (context) => const HomePage(),
        LoginScreen.id: (context) => const LoginScreen(),
        SignUp.id: (context) => const SignUp(),
        NewExpensePage.id: (context) => const NewExpensePage(),
        EditExpensePage.id: (context) => EditExpensePage(expenseDetails: {}),
      },
    );
  }
}
