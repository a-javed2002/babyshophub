import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Terms and Conditions'),
        ),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to BabyShopHub Terms and Conditions!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  '1. Acceptance of Terms',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'By accessing or using the BabyShopHub website or mobile application, you agree to comply with and be bound by these terms and conditions.',
                ),
                SizedBox(height: 16.0),
                Text(
                  '2. Registration',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'To access certain features of the BabyShopHub platform, you may be required to register for an account. You agree to provide accurate and complete information during the registration process.',
                ),
                SizedBox(height: 16.0),
                Text(
                  '3. User Account and Security',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'You are responsible for maintaining the confidentiality of your account and password and for restricting access to your account. You agree to accept responsibility for all activities that occur under your account or password.',
                ),
                // Add more sections based on your terms and conditions content
              ],
            ),
          ),
        ),
      ),
    );
  }
}
