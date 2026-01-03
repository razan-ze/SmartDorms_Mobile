import 'package:flutter/material.dart';
import 'dart:async';
import './landing_page.dart';
import '../pages/home/student_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:shimmer/shimmer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    navigateNext();
  }

  Future<void> navigateNext() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final userDataString = prefs.getString('userData');

    // Wait 3 seconds for splash effect
    await Future.delayed(const Duration(seconds: 3));

    if (isLoggedIn && userDataString != null) {
      // Navigate to Dashboard if logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => StudentDashboard(
            userData: jsonDecode(userDataString),
          ),
        ),
      );
    } else {
      // Navigate to Landing if not logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LandingPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3F4F1A),
      body: Center(
        child: Shimmer.fromColors(
          baseColor: Colors.white,
          highlightColor: Colors.yellowAccent,
          period: const Duration(seconds: 2),
          child: const Text(
            'UniStay',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}