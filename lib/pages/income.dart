import 'package:expensetrackingapp/services/database.dart';
import 'package:expensetrackingapp/services/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Income extends StatefulWidget {
  const Income({super.key});

  @override
  State<Income> createState() => _IncomeState();
}

class _IncomeState extends State<Income> {
  TextEditingController amountController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Income")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(controller: amountController, decoration: const InputDecoration(hintText: "Enter Amount"), keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String? id = await SharedPreferenceHelper().getUserId();
                Map<String, dynamic> data = {
                  "Amount": amountController.text,
                  "Date": DateFormat('dd-MM-yyyy').format(selectedDate),
                };
                await DatabaseMethods().addIncome(data, id!);
                Navigator.pop(context);
              },
              child: const Text("Submit Income"),
            )
          ],
        ),
      ),
    );
  }
}