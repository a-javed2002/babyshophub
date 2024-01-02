import 'package:flutter/material.dart';

class FaqScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('FAQs'),
        ),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Frequently Asked Questions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                FaqItem(
                  question: '1. How can I place an order?',
                  answer:
                      'To place an order, simply browse our products, select the items you want, and proceed to checkout. Follow the steps to provide shipping information and payment details.',
                ),
                FaqItem(
                  question: '2. What payment methods do you accept?',
                  answer:
                      'We accept major credit cards, debit cards, and other secure payment options. You can find the complete list of accepted payment methods during the checkout process.',
                ),
                FaqItem(
                  question: '3. Can I modify or cancel my order?',
                  answer:
                      'Once an order is placed, it undergoes processing immediately. Therefore, modifications or cancellations may not be possible. Please review your order carefully before confirming.',
                ),
                FaqItem(
                  question: '4. How can I track my order?',
                  answer:
                      'Once your order is shipped, you will receive a tracking number and a link to track your order. You can use this information to monitor the status and location of your package.',
                ),
                FaqItem(
                  question: '5. Do you ship internationally?',
                  answer:
                      'Yes, we offer international shipping. Shipping fees and delivery times may vary based on the destination. Please check the shipping information during the checkout process.',
                ),
                FaqItem(
                  question: '6. What is your return policy?',
                  answer:
                      'Our return policy allows you to return items within 30 days of delivery. Please ensure the items are in their original condition. Refer to our Returns page for detailed instructions.',
                ),
                FaqItem(
                  question: '7. How do I contact customer support?',
                  answer:
                      'You can contact our customer support team by emailing support@babyshophub.com or using the Contact Us form on our website. We aim to respond to inquiries within 24 hours.',
                ),
                FaqItem(
                  question: '8. Are my personal details secure?',
                  answer:
                      'Yes, we prioritize the security of your personal information. Our website and payment processes use encryption and secure protocols to protect your data.',
                ),
                FaqItem(
                  question: '9. Do you have a loyalty program?',
                  answer:
                      'Yes, we offer a loyalty program for our valued customers. Earn points with every purchase and redeem them for discounts on future orders. Check our Loyalty Program page for details.',
                ),
                FaqItem(
                  question: '10. How can I provide feedback?',
                  answer:
                      'We appreciate your feedback! You can share your thoughts by emailing feedback@babyshophub.com or using the Feedback form on our website. Your input helps us improve our services.',
                ),
                FaqItem(
                  question: '11. Is there a minimum order amount?',
                  answer:
                      'No, there is no minimum order amount. You can place orders for any quantity of items based on your preferences and needs.',
                ),
                FaqItem(
                  question: '12. How are shipping costs calculated?',
                  answer:
                      'Shipping costs are calculated based on the weight of your order and the shipping destination. You can view the shipping costs during the checkout process before completing your purchase.',
                ),
                FaqItem(
                  question: '13. What do I do if I receive a damaged item?',
                  answer:
                      'If you receive a damaged item, please contact our customer support immediately. Provide photos of the damaged item and packaging, and our team will assist you in resolving the issue.',
                ),
                FaqItem(
                  question: '14. Are there any promotions or discounts available?',
                  answer:
                      'Yes, we frequently offer promotions and discounts. Stay updated by subscribing to our newsletter and checking our Promotions page for the latest deals and offers.',
                ),
                FaqItem(
                  question: '15. Can I change my shipping address after placing an order?',
                  answer:
                      'Unfortunately, we cannot change the shipping address once the order is placed. Please double-check your address during the checkout process to ensure accurate delivery.',
                ),
                FaqItem(
                  question: '16. Do you offer gift wrapping services?',
                  answer:
                      'Yes, we offer gift wrapping services. During the checkout process, you can select the gift wrapping option and add a personalized message for the recipient.',
                ),
                FaqItem(
                  question: '17. How can I unsubscribe from newsletters?',
                  answer:
                      'To unsubscribe from newsletters, click the "Unsubscribe" link at the bottom of any newsletter you receive from us. Alternatively, you can update your communication preferences in your account settings.',
                ),
                FaqItem(
                  question: '18. Can I return personalized or customized items?',
                  answer:
                      'Unfortunately, we do not accept returns for personalized or customized items unless they are damaged or defective. Please review product details before placing a customized order.',
                ),
                FaqItem(
                  question: '19. Are there any restrictions on international orders?',
                  answer:
                      'Some international orders may be subject to customs duties or import taxes. Check with your local customs office to understand any potential charges that may apply to your order.',
                ),
                FaqItem(
                  question: '20. How do I reset my password?',
                  answer:
                      'To reset your password, click the "Forgot Password" link on the login page. Follow the instructions sent to your email to create a new password and regain access to your account.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FaqItem extends StatelessWidget {
  final String question;
  final String answer;

  const FaqItem({
    Key? key,
    required this.question,
    required this.answer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        Text(answer),
        SizedBox(height: 16.0),
      ],
    );
  }
}
