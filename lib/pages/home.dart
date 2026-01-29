import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensetrackingapp/services/support_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// Import your other pages
import 'package:expensetrackingapp/pages/expenses.dart';
import 'package:expensetrackingapp/pages/income.dart';
import 'package:expensetrackingapp/pages/profile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Get the current logged-in user's ID
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      // --- SIDE DRAWER ---
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Color(0xFFE7634B)),
              accountName: Text("User Name", style: TextStyle(fontWeight: FontWeight.bold)),
              accountEmail: Text("user@example.com"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/images/girl1.png'),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Profile()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_shopping_cart),
              title: const Text("Add Expense"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Expenses()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text("Add Income"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Income()));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection("users").doc(currentUserId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Registering data..."));
          }

          var userData = snapshot.data!;
          double totalExp = (userData.get("TotalExpense") ?? 0.0).toDouble();
          double totalInc = (userData.get("TotalIncome") ?? 0.0).toDouble();
          
          // CALCULATE REMINDER (BALANCE)
          double reminder = totalInc - totalExp;

          return SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(top: 10.0, left: 20, right: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "welcome back",
                            style: TextStyle(
                                color: Color.fromARGB(146, 0, 0, 0),
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(userData.get("Name") ?? "User",
                              style: AppWidget.healineTextStyle(20.0)),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const Profile()));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.asset(
                            'assets/images/girl1.png',
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40.0),
                  Text("manage your \n expenses",
                      style: AppWidget.healineTextStyle(30.0)),
                  const SizedBox(height: 20.0),
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: const Color.fromARGB(48, 0, 0, 0), width: 2.0),
                        borderRadius: BorderRadius.circular(20.0)),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Expenses",
                                style: AppWidget.healineTextStyle(20.0)),
                            Text(
                              "\$${totalExp.toStringAsFixed(0)}",
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 238, 104, 5),
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Text(
                          "Current Balance Summary",
                          style: TextStyle(
                              color: Color.fromARGB(146, 0, 0, 0),
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          children: [
                            // PIE CHART WITH REMINDER IN CENTER
                            SizedBox(
                              height: 140,
                              width: 140,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  PieChart(
                                    PieChartData(
                                      sectionsSpace: 0,
                                      centerSpaceRadius: 40,
                                      sections: [
                                        PieChartSectionData(
                                            color: const Color(0xFFE23E3E), 
                                            value: totalExp == 0 ? 0.1 : totalExp, 
                                            showTitle: false, 
                                            radius: 25),
                                        PieChartSectionData(
                                            color: const Color(0xFF7AB844), 
                                            value: totalInc == 0 ? 0.1 : totalInc, 
                                            showTitle: false, 
                                            radius: 25),
                                      ],
                                    ),
                                  ),
                                  // DISPLAY REMINDER VALUE
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text("Balance", style: TextStyle(fontSize: 10, color: Colors.black54)),
                                      Text(
                                        "\$${reminder.toInt()}",
                                        style: TextStyle(
                                          fontSize: 16, 
                                          fontWeight: FontWeight.bold,
                                          color: reminder < 0 ? Colors.red : Colors.black
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(width: 20.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildLegendItem(const Color(0xFFE23E3E), "Expenses", "\$${totalExp.toInt()}"),
                                const SizedBox(height: 10.0),
                                buildLegendItem(const Color(0xFF7AB844), "Income", "\$${totalInc.toInt()}"),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildToggleBtn("This Month", true),
                      buildToggleBtn("This Year", false),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Income())),
                        child: buildSummaryCard("Income", "+ \$${totalInc.toStringAsFixed(0)}", const Color(0xFF7A86E7)),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Expenses())),
                        child: buildSummaryCard("Expenses", "- \$${totalExp.toStringAsFixed(0)}", const Color(0xFFE7634B)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40.0),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --- Helper Methods ---

  Widget buildLegendItem(Color color, String category, String amount) {
    return Row(
      children: [
        Container(height: 10, width: 10, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 10.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(category, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0)),
            Text(amount, style: const TextStyle(color: Colors.black38, fontSize: 12.0)),
          ],
        )
      ],
    );
  }

  Widget buildToggleBtn(String label, bool isSelected) {
    return Container(
      width: MediaQuery.of(context).size.width / 2.3,
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE7634B) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: isSelected ? null : Border.all(color: Colors.black26)),
      child: Center(
        child: Text(label,
            style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget buildSummaryCard(String title, String amount, Color barColor) {
    return Container(
      width: MediaQuery.of(context).size.width / 2.3,
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5.0),
          Text(amount, style: TextStyle(color: barColor == const Color(0xFFE7634B) ? const Color(0xFFE7634B) : Colors.blueAccent, fontSize: 18.0, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10.0),
          Container(
            height: 5, width: 70,
            decoration: BoxDecoration(color: barColor.withOpacity(0.5), borderRadius: BorderRadius.circular(10)),
          )
        ],
      ),
    );
  }
}