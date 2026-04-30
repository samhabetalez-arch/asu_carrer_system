import 'package:flutter/material.dart';

class JobDetailsScreen extends StatelessWidget {
  const JobDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEEF4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.orange),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Job Details",
          style: TextStyle(
            color: Color(0xFF1E3A5F),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          "Job Details Screen Placeholder",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
