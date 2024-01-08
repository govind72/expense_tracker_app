import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'User Name',
                        hintText: 'Enter username'),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'email',
                        hintText: 'Enter valid mail id as abc@gmail.com'),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        hintText: 'Enter your  password'),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
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
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => HomePage()));
                  },
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
