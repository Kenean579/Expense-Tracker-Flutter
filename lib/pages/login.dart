import 'package:expensetrackingapp/pages/home.dart';
import 'package:expensetrackingapp/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = "", password = "";

  TextEditingController mailcontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();

  userLogin() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: mailcontroller.text, password: passwordcontroller.text);
      Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
    } on FirebaseAuthException catch (e) {
      String message = "An error occurred";
      if (e.code == 'user-not-found') {
        message = "No user found for that Email";
      } else if (e.code == 'wrong-password') {
        message = "Wrong Password provided by the user";
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            message,
            style: const TextStyle(fontSize: 18.0, color: Colors.white),
          )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // This ensures the screen adjusts when the keyboard opens
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // 1. Fixed Background Image
          Image.asset(
            "assets/images/login.png",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          // 2. Scrollable Foreground Content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 90.0), // Gap for the top
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 20.0),
                      Text(
                        "Welcome\nBack!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 120.0), // Spacing before form
                  const Text(
                    "Email",
                    style: TextStyle(
                        color: Color(0xFFff8d62),
                        fontSize: 24.0,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    padding: const EdgeInsets.only(left: 10.0),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 250, 249, 249),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: mailcontroller,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.mail_outline,
                            size: 28.0,
                            color: Color(0xff904c6e),
                          ),
                          hintText: "Enter Email",
                          hintStyle: TextStyle(fontSize: 18.0)),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  const Text(
                    "Password",
                    style: TextStyle(
                        color: Color(0xFFff8d62),
                        fontSize: 24.0,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    padding: const EdgeInsets.only(left: 10.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: passwordcontroller,
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.password,
                            size: 28.0,
                            color: Color(0xff904c6e),
                          ),
                          hintText: "Enter Password",
                          hintStyle: TextStyle(fontSize: 18.0)),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Next",
                        style: TextStyle(
                            color: Color.fromARGB(255, 100, 7, 7),
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (mailcontroller.text != "" &&
                              passwordcontroller.text != "") {
                            userLogin();
                          }
                        },
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              color: const Color(0xFFff8d62),
                              borderRadius: BorderRadius.circular(40)),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Colors.black, fontSize: 18.0),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUp()));
                        },
                        child: const Text(
                          "SignUp",
                          style: TextStyle(
                              color: Color.fromARGB(255, 100, 7, 7),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0), // Bottom padding
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}