import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'home_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Future<void> signUp() async {
    BuildContext localContext = context; // Store the context in a local variable

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/register'), // Replace with your Laravel API endpoint

      body: {
        'name': usernameController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'password_confirmation': confirmPasswordController.text,
      },
    );


    if (response.statusCode == 200) {
      // Use the localContext variable instead of context
      Navigator.push(localContext, MaterialPageRoute(builder: (_) => HomePage()));
    } else {
      // Handle registration failure
      // You might want to show an error message or retry registration
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        title: const Text('SignUp Page'),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [

          SingleChildScrollView(
            child : Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                const SizedBox(
                  height: 50,
                ),
                 Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'User Name',
                        hintText: 'Enter username'),
                  ),
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
                  padding:const EdgeInsets.all(10),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration:const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        hintText: 'Enter your  password'),
                  ),
                ),
                 Padding(
                  padding:const  EdgeInsets.all(10),
                  child: TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Confirm Password',
                        hintText: 'Enter your password again'),
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
                  onPressed: signUp,
                  child: const Center(
                    child:  Text(
                      'Sign up',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
            
              ],
            ),
          ),
        ],
      ),

    );
  }
}
