import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
   HomePage({super.key});
  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                height: 175,
                width: 150,
                decoration: BoxDecoration(
                    color: const Color(0xffec35e8).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20)
                ),
              ),
              const SizedBox(width: 20,),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                height: 175,
                width: 150,
                decoration: BoxDecoration(
                    color: const Color(0xff92A3FD).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20)
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
