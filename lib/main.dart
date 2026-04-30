import 'package:flutter/material.dart';
// 1. استيراد صفحة الـ Splash
import 'package:asu_career_system/features/student/screens/splash_screen.dart';

// 2. استيراد صفحة الـ Login (تأكدي من المسار الصحيح للملف عندك)

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  void main() {
    // هذا الكود يغير شكل الشاشة الحمراء لرسالة بسيطة بدلاً من انهيار التطبيق
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Material(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Text("Loading... or Error: ${details.exception}"),
          ),
        ),
      );
    };
    runApp(const MyApp());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ASU Career System',
      // التطبيق يبدأ بصفحة الـ Splash أولاً
      home: const SplashScreen(),
    );
  }
}
