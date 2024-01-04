import 'package:flutter/material.dart';

class PaymentSecurityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment and Security'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment and Security Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Secure Payment Methods',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'BabyShopHub uses secure payment methods to ensure the safety of your transactions. We accept major credit cards, debit cards, and other secure payment options. Our payment processes are compliant with industry standards for security.',
              ),
              SizedBox(height: 16.0),
              Text(
                'Payment Process',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'When you make a purchase, your payment information is securely processed through our payment gateway. We do not store sensitive payment details on our servers. Our payment gateway employs encryption and tokenization to safeguard your financial information.',
              ),
              SizedBox(height: 16.0),
              Text(
                'Security Measures',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'BabyShopHub employs robust security measures to protect your personal and financial information. We use encryption, secure protocols, and regularly update our security practices. Our security team monitors for potential threats and takes proactive measures to prevent unauthorized access.',
              ),
              SizedBox(height: 16.0),
              Text(
                'Your Account Security',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'To enhance account security, we recommend using a strong and unique password. Do not share your account credentials, and ensure you log out after each session. Enable two-factor authentication for an added layer of protection.',
              ),
              SizedBox(height: 16.0),
              Text(
                'Security Certifications',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'BabyShopHub holds industry-recognized security certifications to demonstrate our commitment to protecting your information. Our compliance with these standards ensures a secure and trustworthy shopping experience for our users.',
              ),
              // Add more sections based on your payment and security content
            ],
          ),
        ),
      ),
    );
  }
}
