import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final Color primaryBlue = const Color(0xFF229BD8);
  final Color grayTextColor = const Color(0xFF7E848E);

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEEF4),
      appBar: AppBar(
        title: Text(
          "Password Reset",
          style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.orange),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment
                  .center, // إلغاء السكرول بجعل العناصر في المنتصف
              children: [
                // أيقونة قفل تفاعلية
                Icon(
                  Icons.mark_email_read_outlined,
                  size: 80,
                  color: primaryBlue,
                ),
                const SizedBox(height: 24),

                Text(
                  "Password Recovery",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: primaryBlue,
                  ),
                ),
                const SizedBox(height: 12),

                Text(
                  "Enter your registered email below to receive the reset link.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: grayTextColor),
                ),
                const SizedBox(height: 32),

                // حقل الإدخال مع الـ Validation الصارم
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: "name@example.com",
                    fillColor: Colors.white,
                    filled: true,
                    prefixIcon: Icon(Icons.email_outlined, color: primaryBlue),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    errorStyle: const TextStyle(height: 0.8),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    final email = value.toLowerCase().trim();

                    // 1. منع الأحرف العشوائية (تأكيد صيغة الإيميل)
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(email)) {
                      return 'Invalid email format (e.g. name@example.com)';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // زر الإرسال
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // هنا سيتم استدعاء Firebase لإرسال الرابط
                        _showSuccessDialog(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Send Reset Link",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // رسالة نجاح احترافية بدلاً من السناك بار البسيط
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Icon(Icons.check_circle, color: Colors.green, size: 60),
        content: const Text(
          "We have sent a password reset link to your email. Please check your inbox.",
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // إغلاق الديالوج
              Navigator.pop(context); // العودة لصفحة الـ Login
            },
            child: const Text("Back to Login"),
          ),
        ],
      ),
    );
  }
}
