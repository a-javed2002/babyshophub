import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                '1. Acceptance of Terms',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
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
                  color: Colors.black,
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
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'You are responsible for maintaining the confidentiality of your account and password and for restricting access to your account. You agree to accept responsibility for all activities that occur under your account or password.',
              ),
              SizedBox(height: 16.0),
              Text(
                '4. Prohibited Conduct',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'You agree not to engage in any conduct that may disrupt or interfere with the normal operation of the BabyShopHub platform.',
              ),
              SizedBox(height: 16.0),
              Text(
                '5. Termination',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'BabyShopHub reserves the right to terminate or suspend your account at any time without prior notice if it is determined that you have violated these terms and conditions.',
              ),
              // Add more sections based on your terms and conditions content
            ],
          ),
        ),
      ),
    );
  }
}
