import 'package:evana_event_management_app/Routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color gold = const Color(0xFFD4AF37);
    final Color goldAccent = const Color(0xFFF9D423);
    final Color textFieldFill =
        const Color(0x0DFFFFFF); // ~5% white with opacity

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Gradient
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

          // Content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  SizedBox(
                    height: 120,
                    child: Image.asset(
                      'lib/Views/SplashScreen/Assets/splash_bg.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Welcome
                  Text(
                    "Welcome Back",
                    style: TextStyle(
                      color: goldAccent,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      shadows: [
                        Shadow(
                          color: gold.withAlpha(100), // translucent shadow
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Access your account below",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Email Field
                  _buildTextField(
                    label: 'Email',
                    icon: Icons.email_outlined,
                    gold: gold,
                    goldAccent: goldAccent,
                    fillColor: textFieldFill,
                  ),
                  const SizedBox(height: 20),

                  // Password Field
                  _buildTextField(
                    label: 'Password',
                    icon: Icons.lock_outline,
                    obscure: true,
                    gold: gold,
                    goldAccent: goldAccent,
                    fillColor: textFieldFill,
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  _buildLoginButton(gold, goldAccent),
                  SizedBox(
                    height: 20.h,
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: gold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: gold.withAlpha(100),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          'OR CONNECT WITH',
                          style: TextStyle(
                            color: gold,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: gold.withAlpha(100),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton(
                        icon: Icons.g_mobiledata,
                        color: gold,
                      ),
                      const SizedBox(width: 30),
                      _buildSocialButton(
                        icon: Icons.facebook,
                        color: gold,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.offNamed(Routes.register);
                        },
                        child: Text(
                          "Sign Up",
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
    required Color fillColor,
    bool obscure = false,
  }) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: gold),
        prefixIcon: Icon(icon, color: gold),
        filled: true,
        fillColor: fillColor,
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

  Widget _buildSocialButton({required IconData icon, required Color color}) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: () {},
      child: CircleAvatar(
        radius: 26,
        backgroundColor: Color.alphaBlend(color.withAlpha(25), Colors.black),
        child: Icon(icon, color: color, size: 30),
      ),
    );
  }
}

Widget _buildLoginButton(Color gold, Color goldAccent) {
  return GestureDetector(
    onTap: () {
      Get.offNamed(Routes.home);
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
            Icon(Icons.lock_open, color: Colors.black87),
            SizedBox(width: 10),
            Text(
              'LOGIN',
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
