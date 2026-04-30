import 'package:flutter/material.dart';
import 'complete_profile.dart';

class StudentRegisterScreen extends StatefulWidget {
  const StudentRegisterScreen({super.key});

  @override
  State<StudentRegisterScreen> createState() => _StudentRegisterScreenState();
}

class _StudentRegisterScreenState extends State<StudentRegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isSubmitted = false;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool isArabic = false; // متغير التحكم في اللغة

  final Color primaryBlue = const Color(0xFF229BD8);
  final Color grayTextColor = const Color(0xFF7E848E);

  // خريطة النصوص للترجمة
  Map<String, String> get texts => {
    'nameLabel': isArabic ? "الاسم الكامل" : "Full Name",
    'nameHint': isArabic ? "أدخل اسمك" : "Enter your full name",
    'emailLabel': isArabic ? "البريد الإلكتروني" : "Email",
    'passLabel': isArabic ? "كلمة المرور" : "Password",
    'confirmPassLabel': isArabic ? "تأكيد كلمة المرور" : "Confirm Password",
    'btnCreate': isArabic ? "إنشاء الحساب" : "Create Account",
    'alreadyHave': isArabic
        ? "لديك حساب بالفعل؟ "
        : "Already have an account? ",
    'login': isArabic ? "سجل دخول" : "Login",
    'req': isArabic ? "مطلوب" : "Required",
    'emailErr': isArabic ? "خطأ في الإيميل" : "Invalid email",
    'matchErr': 'كلمتا السر غير متطابقتين',
  };

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEEF4),
      // إضافة زر تغيير اللغة في الأعلى
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,

        actions: [
          TextButton(
            onPressed: () => setState(() => isArabic = !isArabic),
            child: Text(
              isArabic ? "English" : "العربية",
              style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 5.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 10),
                        Column(
                          children: [
                            _buildFieldSection(
                              // السطر 92 يصبح:
                              texts['nameLabel'] ?? 'Name',
                              // السطر 93 يصبح:
                              texts['nameHint'] ?? 'Enter name',
                              Icons.person_outline,
                              controller: _nameController,
                            ),
                            const SizedBox(height: 12),
                            _buildFieldSection(
                              texts['emailLabel'] ?? 'Email',
                              "name@example.com",
                              Icons.email_outlined,
                              controller: _emailController,
                              isEmail: true,
                            ),
                            const SizedBox(height: 12),
                            _buildPasswordFieldSection(
                              texts['passLabel'] ?? 'Password',
                              _isPasswordVisible,
                              () => setState(
                                () => _isPasswordVisible = !_isPasswordVisible,
                              ),
                              controller: _passwordController,
                            ),
                            const SizedBox(height: 12),
                            _buildPasswordFieldSection(
                              texts['confirmPassLabel'] ?? 'ConfirmPassword',
                              _isConfirmPasswordVisible,
                              () => setState(
                                () => _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible,
                              ),
                              controller: _confirmPasswordController,
                              isConfirm: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: [
                            _buildActionButton(),
                            const SizedBox(height: 10),
                            _buildLoginLink(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 5, bottom: 5),
          height: 85, // Reduced size to prevent scrolling
          width: 85,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Image.asset(
            'assets/image/logo image.jpg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.broken_image,
                size: 50,
                color: Colors.grey,
              );
            },
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildFieldSection(
    String label,
    String hint,
    IconData icon, {
    TextEditingController? controller,
    bool isEmail = false,
  }) {
    String? errorText;
    if (_isSubmitted) {
      if (controller?.text.isEmpty ?? true) {
        errorText = texts['req'];
      } else if (isEmail) {
        final email = controller!.text.toLowerCase().trim();
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
          errorText = texts['emailErr'];
        }
      }
    }

    return Column(
      crossAxisAlignment: isArabic
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: grayTextColor,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
            if (errorText != null)
              Text(
                ' - $errorText',
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          textAlign: isArabic ? TextAlign.right : TextAlign.left,
          decoration: _inputDecoration(hint, icon),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return ""; // Error is shown above the field
            }

            if (isEmail) {
              final bool emailValid = RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
              ).hasMatch(value);

              if (!emailValid) {
                return ""; // Error is shown above the field
              }
            }

            return null;
          },
          onChanged: (v) {
            if (_isSubmitted) setState(() {});
          },
        ),
      ],
    );
  }

  Widget _buildPasswordFieldSection(
    String label,
    bool isVisible,
    VoidCallback toggle, {
    TextEditingController? controller,
    bool isConfirm = false,
  }) {
    String? errorText;
    if (_isSubmitted) {
      if (controller?.text.isEmpty ?? true) {
        errorText = texts['req'];
      } else if (isConfirm && controller!.text != _passwordController.text) {
        errorText = isArabic ? "غير متطابق" : "No match";
      }
    }

    return Column(
      crossAxisAlignment: isArabic
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: grayTextColor,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
            if (errorText != null)
              Text(
                ' - $errorText',
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          obscureText: !isVisible,
          textAlign: isArabic ? TextAlign.right : TextAlign.left,
          decoration: _passwordInputDecoration(
            isConfirm ? "••••••••" : "••••••••",
            isVisible,
            toggle,
          ),
          validator: (value) => errorText != null ? "" : null,
          onChanged: (v) {
            if (_isSubmitted) setState(() {});
          },
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      errorStyle: const TextStyle(height: 0),
      prefixIcon: isArabic ? null : Icon(icon, color: primaryBlue, size: 20),
      suffixIcon: isArabic ? Icon(icon, color: primaryBlue, size: 20) : null,
      fillColor: Colors.white,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  InputDecoration _passwordInputDecoration(
    String hint,
    bool isVisible,
    VoidCallback toggle,
  ) {
    return InputDecoration(
      hintText: hint,
      errorStyle: const TextStyle(height: 0),
      prefixIcon: isArabic
          ? null
          : Icon(Icons.lock_outline, color: primaryBlue, size: 20),
      fillColor: Colors.white,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      suffixIcon: InkWell(
        onTap: toggle,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            isVisible ? '👀' : '🫣',
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
      // في العربي نعكس مكان أيقونة القفل لتكون يميناً
      prefixIconConstraints: isArabic
          ? const BoxConstraints(minWidth: 50)
          : null,
      counterText: isArabic ? "" : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _isSubmitted = true;
          });
          if (_formKey.currentState!.validate()) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CompleteProfileScreen(userName: _nameController.text),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          // This will never crash
          texts['btnCreate'] ?? 'Create',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          texts['alreadyHave'] ?? 'Already have an account?',
          style: const TextStyle(fontSize: 13),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Text(
            texts['login'] ?? 'Login',
            style: TextStyle(
              color: primaryBlue,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}
