import 'package:flutter/material.dart';

class CompanyProfileScreen extends StatelessWidget {
  const CompanyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEEF4),
      appBar: AppBar(
        title: const Text("Company Profile"),
        backgroundColor: const Color(0xFF229BD8),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.orange),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text(
          "Welcome to Company Profile",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
