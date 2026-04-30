import 'package:flutter/material.dart';

class CompanyRegisterScreen extends StatelessWidget {
  const CompanyRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEEF4),
      appBar: AppBar(
        title: const Text("Company Registration"),
        backgroundColor: const Color(0xFF229BD8),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.orange),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text(
          "Company Registration Page\n(We will design the fields next!)",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Color(0xFF7E848E)),
        ),
      ),
    );
  }
}
