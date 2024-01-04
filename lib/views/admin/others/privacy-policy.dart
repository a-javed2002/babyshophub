import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BabyShopHub Privacy Policy',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Last updated: [Date]',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.black
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                '1. Information We Collect',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'We collect information you provide directly to us, such as when you create an account, make a purchase, or contact customer support.',
              ),
              SizedBox(height: 16.0),
              Text(
                '2. How We Use Your Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'We use the information we collect for various purposes, including to provide and improve our services, personalize content, and communicate with you.',
              ),
              SizedBox(height: 16.0),
              Text(
                '3. Security',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'We prioritize the security of your personal information and take measures to protect it. However, no method of transmission over the internet is completely secure.',
              ),
              SizedBox(height: 16.0),
              Text(
                '4. Cookies',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'We use cookies to collect information and improve our services. You can choose to disable cookies in your browser settings, but this may affect the functionality of the site.',
              ),
              // Add more sections based on your privacy policy content
            ],
          ),
        ),
      ),
    );
  }
}
