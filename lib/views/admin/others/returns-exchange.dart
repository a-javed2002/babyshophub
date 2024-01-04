import 'package:flutter/material.dart';

class ReturnAndExchangeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Return and Exchange'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Return and Exchange Policy',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'We want you to be satisfied with your purchase from BabyShopHub. If you are not completely satisfied, you may return or exchange eligible items within [number of days] days of purchase.',
              ),
              SizedBox(height: 16.0),
              Text(
                '1. Eligibility Criteria',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'To be eligible for a return or exchange, items must be unused and in the same condition as received. They must also be in the original packaging. Certain items, such as perishable goods, gift cards, and personalized items, are not eligible for return or exchange.',
              ),
              SizedBox(height: 16.0),
              Text(
                '2. How to Initiate a Return or Exchange',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Please follow these steps to initiate a return or exchange:',
              ),
              SizedBox(height: 8.0),
              Text(
                '   a. Contact our customer support team within [number of days] days of receiving your order.',
              ),
              Text(
                '   b. Provide your order number, details about the item you would like to return or exchange, and the reason for return or exchange.',
              ),
              Text(
                '   c. Our customer support team will guide you through the return or exchange process, including providing a return shipping label, if necessary.',
              ),
              SizedBox(height: 16.0),
              Text(
                '3. Refunds',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Once your return is received and inspected, we will process your refund. Refunds will be issued to the original payment method within [number of days] days.',
              ),
              SizedBox(height: 16.0),
              Text(
                '4. Exchanges',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'If you would like to exchange an item, please follow the return process and place a new order for the desired item.',
              ),
              // Add more sections based on your return and exchange policy content
            ],
          ),
        ),
      ),
    );
  }
}
