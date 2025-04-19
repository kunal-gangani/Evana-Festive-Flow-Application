import 'dart:async';

import 'package:evana_event_management_app/Routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(
      Duration(
        seconds: 3,
      ),
      () {
        Get.offNamed(Routes.login);
      },
    );
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFD4AF37),
                    Color(0xFFF9D423),
                    Color(0xFFD4AF37),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFD4AF37).withOpacity(0.4),
                    blurRadius: 15,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Center(
                child: Container(
                  width: 190,
                  height: 190,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(
                        'lib/Views/SplashScreen/Assets/splash_bg.png',
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
            Text(
              'Luxury Redefined',
              style: TextStyle(
                fontSize: 18.sp,
                color: Colors.grey.shade400,
                fontStyle: FontStyle.italic,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(
              height: 50.h,
            ),
            SizedBox(
              width: 50.w,
              height: 50.h,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(
                    0xFFD4AF37,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
