import 'package:expense_tracker_app/screens/home_page.dart';
import 'package:flutter/material.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
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
          const Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
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
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => HomePage()));
            },
            child: const Center(
              child:  Text(
                'Login',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
