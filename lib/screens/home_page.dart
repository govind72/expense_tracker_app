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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 175,
                  width: 160,
                  decoration: BoxDecoration(
                      color: const Color(0xffec35e8).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),
                const SizedBox(width: 20,),
                Container(
                  height: 175,
                  width: 160,
                  decoration: BoxDecoration(
                      color: const Color(0xff92A3FD).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20,),
            Container(
              height: 490,
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(20)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
