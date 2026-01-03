import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../pages/home/student_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  _LoginFormWidgetState createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
Future<void> login() async {
  setState(() => isLoading = true);

  try {
    final response = await http.post(
      Uri.parse("https://unistay-server-rm0e.onrender.com/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": usernameController.text.trim(),
        "password": passwordController.text.trim(),
      }),
    );

    final data = jsonDecode(response.body);

    // Inside your login function:
if (response.statusCode == 200) {
  // Login successful
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Login successful!")),
  );

  // Save user info locally to remember login
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', true);
  await prefs.setString('userData', jsonEncode(data));

  // Navigate to Student Dashboard
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => StudentDashboard(userData: data),
    ),
  );

  print("User data: $data");
} 
 else {
      // Login failed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data["message"] ?? "Login failed")),
      );
    }
  } catch (e) {
    // Network or other error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $e")),
    );
  } finally {
    setState(() => isLoading = false); // always stop loading
  }
}


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: usernameController,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF5F2E7),
            hintText: "Username",
            prefixIcon: const Icon(Icons.person, color: Color(0xFF4A5328)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF5F2E7),
            hintText: "Password",
            prefixIcon: const Icon(Icons.lock, color: Color(0xFF4A5328)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),

        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: isLoading ? null : login,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4A5328),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    
                  ),
                ),
        ),
      ],
    );
  }
}