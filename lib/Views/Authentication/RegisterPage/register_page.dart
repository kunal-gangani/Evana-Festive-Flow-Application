import 'package:evana_event_management_app/Routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final gold = const Color(0xFFD4AF37);
    final goldAccent = const Color(0xFFF9D423);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.black,
                  Color(0xFF1C1C1C),
                ],
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo
                  SizedBox(
                    height: 100,
                    child: Image.asset(
                      'lib/Views/SplashScreen/Assets/splash_bg.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title
                  Text(
                    "Create Account",
                    style: TextStyle(
                      color: goldAccent,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      shadows: [
                        Shadow(
                          color: gold.withAlpha(100),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Name Field
                  _buildTextField(
                    label: 'Full Name',
                    icon: Icons.person_outline,
                    gold: gold,
                    goldAccent: goldAccent,
                  ),
                  const SizedBox(height: 20),

                  // Email Field
                  _buildTextField(
                    label: 'Email',
                    icon: Icons.email_outlined,
                    gold: gold,
                    goldAccent: goldAccent,
                  ),
                  const SizedBox(height: 20),

                  // Password Field
                  _buildTextField(
                    label: 'Password',
                    icon: Icons.lock_outline,
                    obscure: true,
                    gold: gold,
                    goldAccent: goldAccent,
                  ),
                  const SizedBox(height: 20),

                  // Confirm Password
                  _buildTextField(
                    label: 'Confirm Password',
                    icon: Icons.lock_person_outlined,
                    obscure: true,
                    gold: gold,
                    goldAccent: goldAccent,
                  ),
                  const SizedBox(height: 30),

                  // Register Button
                  _buildRegisterButton(gold, goldAccent),

                  const SizedBox(height: 20),

                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.offNamed(Routes.login);
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: gold,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required Color gold,
    required Color goldAccent,
    bool obscure = false,
  }) {
    return TextField(
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: gold),
        prefixIcon: Icon(icon, color: gold),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: gold),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: goldAccent, width: 2),
        ),
      ),
    );
  }

  Widget _buildRegisterButton(Color gold, Color goldAccent) {
    return GestureDetector(
      onTap: () {
        // TODO: Register Logic
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: gold,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: goldAccent.withAlpha(120),
              blurRadius: 18,
              spreadRadius: 1,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.person_add_alt_1, color: Colors.black87),
              SizedBox(width: 10),
              Text(
                'REGISTER',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
