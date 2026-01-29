import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensetrackingapp/pages/login.dart';
import 'package:expensetrackingapp/services/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? name, email;
  final Color primaryColor = const Color.fromARGB(255, 154, 55, 40);

  gettheUserDataFromFirebase() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Fallback: Set email from Auth immediately in case Firestore is slow
        email = currentUser.email;

        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            name = userDoc.get("Name");
            email = userDoc.get("Email");
          });
        } else {
          // If Firestore doc doesn't exist, try getting from Shared Prefs
          name = await SharedPreferenceHelper().getUserName();
          email = await SharedPreferenceHelper().getUserEmail();
          setState(() {});
        }
      }
    } catch (e) {
      print("Error fetching profile: $e");
      setState(() {
        name = "Error Loading";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    gettheUserDataFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: Text("Profile", textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
              const SizedBox(height: 30.0),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.asset("assets/images/girl1.png", height: 120, width: 120, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 40.0),

              // NAME BOX
              buildInfoBox(Icons.person_outline, "Name", name ?? "Loading..."),
              const SizedBox(height: 20.0),

              // EMAIL BOX
              buildInfoBox(Icons.mail_outline, "Email", email ?? "Loading..."),
              const SizedBox(height: 40.0),

              buildNavItem(Icons.logout, "LogOut", () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Login()), (route) => false);
              }),
              const SizedBox(height: 20.0),
              buildNavItem(Icons.delete_outline, "Delete Account", () async {
                try {
                  User? user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    await FirebaseFirestore.instance.collection("users").doc(user.uid).delete();
                    await user.delete();
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Login()), (route) => false);
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please login again to delete account")));
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoBox(IconData icon, String label, String value) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: 35.0),
          const SizedBox(width: 20.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.black54, fontSize: 14.0)),
                Text(value, style: const TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildNavItem(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
        decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 28.0),
            const SizedBox(width: 20.0),
            Expanded(child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold))),
            const Icon(Icons.chevron_right, color: Colors.white, size: 30.0),
          ],
        ),
      ),
    );
  }
}