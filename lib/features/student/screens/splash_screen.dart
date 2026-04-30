import 'login_screen.dart'; // لأنهم الآن في نفس المجلد، لا داعي للمسار الطويل
import 'package:flutter/material.dart';
import 'dart:async';
import '../../../core/constants/app_strings.dart';
// استيراد صفحة اللوجن الحقيقية من مجلد features

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  // ... باقي الكود كما هو

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // المؤقت: ينتظر 3 ثوانٍ ثم ينتقل لصفحة تسجيل الدخول
    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEEF4),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              // اللوجو في الجزء العلوي
              const SizedBox(height: 100),
              // ... داخل الـ Column في صفحة الـ Splash
              Container(
                height: 200,
                width: 200,

                decoration: BoxDecoration(color: Colors.white),
                child: Image.asset(
                  'assets/image/logo image.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.broken_image,
                      size: 80,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
              // مساحة مرنة لدفع العناصر التالية للأسفل
              const Spacer(),

              // الجملة في منتصف الصفحة (أقرب للنهاية)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  AppStrings.splashSubTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 3, 60, 94),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // النقاط الثلاثة بألوان متدرجة في آخر الصفحة
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.circle, size: 10, color: Colors.black),
                  const SizedBox(width: 10),
                  Icon(Icons.circle, size: 10, color: Colors.grey[600]),
                  const SizedBox(width: 10),
                  Icon(Icons.circle, size: 10, color: Colors.grey[300]),
                ],
              ),

              const SizedBox(height: 40), // مسافة بسيطة عن حافة الشاشة السفلى
            ],
          ),
        ),
      ),
    );
  }
}
