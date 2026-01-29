import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  
  // 1. Add/Update basic user info
  Future addUserInfo(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  // 2. Add individual Expense AND update the running TotalExpense in the user document
  Future addExpense(Map<String, dynamic> userExpenseMap, String id) async {
    // Save the record to the sub-collection
    await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("Expense")
        .add(userExpenseMap);

    // Update the 'TotalExpense' field in the main user document by incrementing it
    // Note: We parse the String amount to a double for the math to work
    return await FirebaseFirestore.instance.collection("users").doc(id).update({
      "TotalExpense": FieldValue.increment(double.parse(userExpenseMap["Amount"])),
    });
  }

  // 3. Add individual Income AND update the running TotalIncome in the user document
  Future addIncome(Map<String, dynamic> userIncomeMap, String id) async {
    // Save the record to the sub-collection
    await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("Income")
        .add(userIncomeMap);

    // Update the 'TotalIncome' field in the main user document
    return await FirebaseFirestore.instance.collection("users").doc(id).update({
      "TotalIncome": FieldValue.increment(double.parse(userIncomeMap["Amount"])),
    });
  }

  // 4. Get the User's Summary (This contains the pre-calculated totals for the Home screen)
  Stream<DocumentSnapshot> getUserSummary(String id) {
    return FirebaseFirestore.instance.collection("users").doc(id).snapshots();
  }

  // 5. Streams for history lists
  Stream<QuerySnapshot> getExpense(String id) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("Expense")
        .snapshots();
  }

  Stream<QuerySnapshot> getIncome(String id) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("Income")
        .snapshots();
  }
}