import 'package:expensetrackingapp/pages/login.dart';
import 'package:flutter/material.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/onboard.png",
      "title": "manage your daily\nlife expenses",
      "desc": "Track every penny simply and efficiently with our intuitive interface."
    },
    {
      "image": "assets/images/onboard.png", 
      "title": "save your money\nwisely",
      "desc": "See where your money goes and identify areas where you can save more."
    },
    {
      "image": "assets/images/onboard.png",
      "title": "reach your financial\nfreedom",
      "desc": "Plan for the future by managing your income and expenses in one place."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Matching the image background exactly
      backgroundColor: const Color(0xFFFBF5E5), 
      body: Stack(
        children: [
          // 1. SLIDING CONTENT
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: onboardingData.length,
            itemBuilder: (context, index) {
              return buildSlide(
                image: onboardingData[index]['image']!,
                title: onboardingData[index]['title']!,
                desc: onboardingData[index]['desc']!,
              );
            },
          ),

          // 2. SKIP BUTTON (Positioned over the top half)
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
              child: const Text(
                "Skip",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // 3. DOT INDICATORS (Positioned relative to the bottom content)
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.18,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingData.length,
                (index) => buildDot(index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSlide({required String image, required String title, required String desc}) {
    return Column(
      children: [
        // --- TOP HALF (50% of the screen) ---
        Expanded(
          flex: 1, 
          child: SizedBox(
            width: double.infinity,
            child: Image.asset(
              image,
              fit: BoxFit.cover, // Ensures the image fills the entire top half
              alignment: Alignment.topCenter, // Anchors the image to the top
            ),
          ),
        ),
        // --- BOTTOM HALF (50% of the screen) ---
        Expanded(
          flex: 1,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(70),
                topRight: Radius.circular(70),
              ),
            ),
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 20.0),
                Text(
                  desc,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black45,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                // BUTTON
                GestureDetector(
                  onTap: () {
                    if (_currentIndex == 2) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Login()),
                      );
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEE6855),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: Text(
                        _currentIndex == 2 ? "Get Started" : "Next",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 10,
      width: _currentIndex == index ? 25 : 10,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEE6855),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}