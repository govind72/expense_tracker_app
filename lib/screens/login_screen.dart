import 'dart:convert';
import 'package:expense_tracker_app/screens/home_page.dart';
import 'package:expense_tracker_app/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> logIn() async{
    BuildContext localContext = context;
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/login'),
      body: {
        'email': emailController.text,
        'password': passwordController.text,
      },
    );
    if (response.statusCode == 200) {
      final token = json.decode(response.body)['token'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
      Navigator.pushNamed(localContext, HomePage.id);
    } else {
      print('Error: ${json.decode(response.body)['message']}');
    }
  }
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Flexible(
            fit: FlexFit.loose,
            child: Hero(
              tag: 'logo',
              child: Container(
                height: 100.0,
                child: Image.asset('asset/images/logo.png'),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
           Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: emailController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'email',
                  hintText: 'Enter valid mail id as abc@gmail.com'),
            ),
          ),
           Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Enter your secure password'),
            ),
          ),
          const SizedBox(
              height :25
          ),
          ElevatedButton(

            style:const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(Colors.green),
                fixedSize: MaterialStatePropertyAll(Size(140, 50))

            ),
            onPressed: logIn,
            child: const Center(
              child:  Text(
                'Login',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "New Here ?"
              ),
              TextButton(
                onPressed: (){
                  Navigator.pushNamed(context, SignUp.id);
                },
                child: const Center(
                  child: Text("Register"),
                ),

              )

            ],
          )

        ],
      ),
    );
  }
}
