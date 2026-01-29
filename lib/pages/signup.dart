import 'package:expensetrackingapp/pages/home.dart';
import 'package:expensetrackingapp/pages/login.dart';
import 'package:expensetrackingapp/services/database.dart';
import 'package:expensetrackingapp/services/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController mailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  // Helper for Email Validation
  bool isValidEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  registration() async {
    String name = namecontroller.text.trim();
    String email = mailcontroller.text.trim();
    String password = passwordcontroller.text.trim();

    // 1. Validation Checks
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("Please fill all fields")));
      return;
    }

    if (!isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text("The email address is badly formatted.")));
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text("Password must be at least 6 characters long.")));
      return;
    }

    try {
      // 2. Create user in Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // 3. GET THE REAL UID FROM FIREBASE
      String uid = userCredential.user!.uid;

      // 4. Initialize the Map with 0.0 values to prevent "Field does not exist" errors
      Map<String, dynamic> userInfoMap = {
        "Name": name,
        "Email": email,
        "Id": uid,
        "TotalExpense": 0.0, 
        "TotalIncome": 0.0,
      };

      // 5. Save to Firestore using UID as Document Name
      await DatabaseMethods().addUserInfo(userInfoMap, uid);
      
      // 6. Save to local storage for the Profile page to read
      await SharedPreferenceHelper().saveUserId(uid);
      await SharedPreferenceHelper().saveUserName(name);
      await SharedPreferenceHelper().saveUserEmail(email);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Registered Successfully", style: TextStyle(fontSize: 20.0))));

      // 7. Navigate to Home
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Home()));

    } on FirebaseAuthException catch (e) {
      String message = "Registration failed";
      if (e.code == 'weak-password') {
        message = "The password provided is too weak.";
      } else if (e.code == "email-already-in-use") {
        message = "An account already exists for that email.";
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(message, style: const TextStyle(fontSize: 18.0))));
    }
  }


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Image.asset(
            'assets/images/signup.png',
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 50.0, right: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Create\nAccount!",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 35.0,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 70.0),
                  const Text(
                    "Name",
                    style: TextStyle(
                        color: Colors.white,
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
                      controller: namecontroller,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.person_outline, color: Color(0xff904c6e)),
                          hintText: "Enter Name"),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    "Email",
                    style: TextStyle(
                        color: Colors.white,
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
                      controller: mailcontroller,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.mail_outline, color: Color(0xff904c6e)),
                          hintText: "Enter Email"),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    "Password",
                    style: TextStyle(
                        color: Colors.white,
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
                          prefixIcon: Icon(Icons.password, color: Color(0xff904c6e)),
                          hintText: "Enter Password"),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Next",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () => registration(),
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 95, 27, 2),
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
                  const SizedBox(height: 40.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const Login()));
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                              color: Color.fromARGB(255, 160, 44, 2),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}