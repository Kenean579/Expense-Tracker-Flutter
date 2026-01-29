import 'package:expensetrackingapp/services/database.dart';
import 'package:expensetrackingapp/services/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  TextEditingController amountController = TextEditingController();
  String? selectedCategory;
  final List<String> categories = ['Shopping', 'Grocery', 'Others'];
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Expense")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(controller: amountController, decoration: const InputDecoration(hintText: "Enter Amount"), keyboardType: TextInputType.number),
            DropdownButton<String>(
              value: selectedCategory,
              hint: const Text("Select Category"),
              isExpanded: true,
              items: categories.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => setState(() => selectedCategory = val),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String? id = await SharedPreferenceHelper().getUserId();
                Map<String, dynamic> data = {
                  "Amount": amountController.text,
                  "Category": selectedCategory,
                  "Date": DateFormat('dd-MM-yyyy').format(selectedDate),
                };
                await DatabaseMethods().addExpense(data, id!);
                Navigator.pop(context);
              },
              child: const Text("Submit"),
            )
          ],
        ),
      ),
    );
  }
}