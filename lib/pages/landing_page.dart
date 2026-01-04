import 'package:flutter/material.dart';
import './auth/login_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
          
            Stack(
              children: [
                // Background Image
                Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/DL1.webp'), // Ghayer l isem hasab l asset 3ndak
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Overlay Content
                Positioned.fill(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0.7),
                          Colors.white.withOpacity(0.7),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 100),
                        const Text(
                          'Welcome to UniStay',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A5D23), // Olive green color
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Smart, safe, and stylish dorm living for university students.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF555555),
                          ),
                        ),
                        const SizedBox(height: 40),
                        
                        // Single Login Button
                        SizedBox(
                          width: 200,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4A5D23),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const LoginPage()),
                              );
                            },
                            child: const Text(
                              'Get Started',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // --- BOTTOM SECTION (About Us) ---
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image below the main section
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/Dorm1.jpg', // Sura lal room mtl l bl design
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'About UniStay',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A5D23),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'UniStay is designed to help students easily find and rent high-quality dorm rooms with modern amenities and a safe environment.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}