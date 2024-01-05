import 'package:babyshophub/views/home/landingPage.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class MyEmail extends StatelessWidget {

Future<void> sendOrderConfirmationEmail(String userEmailAddress) async {
  final smtpServer = gmail('a.javed0202@gmail.com', '');

  final message = Message()
    ..from = Address('a.javed0202@gmail.com', 'Abdullah Javed')
    ..recipients.add(userEmailAddress)
    ..subject = 'Order Confirmation'
    ..text = 'Thank you for your order! Your order has been confirmed.';

  try {
    final sendReport = await send(message, smtpServer);
    print('Email sent: ${sendReport.toString()}');
  } on MailerException catch (e) {
    print('Failed to send email: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Email Example'),
        ),
        body: Column(
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _sendEmail(
                    sender:
                        'your-email@example.com', // Replace with sender email
                    receiver:
                        'customer@example.com', // Replace with customer email
                  );
                },
                child: Text('Compose Email'),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async{
                  // Replace 'user@example.com' with the actual user's email address
                  await sendOrderConfirmationEmail('abdjav2002@gmail.com');
                },
                child: Text('Send Email'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendEmail({required String sender, required String receiver}) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: receiver,
      queryParameters: {
        'subject': 'Hello',
        'body': 'Dear recipient,\n\nSincerely,\n$sender'
      },
    );

    if (await canLaunch(emailLaunchUri.toString())) {
      await launch(emailLaunchUri.toString());
    } else {
      throw 'Could not launch $emailLaunchUri';
    }
  }
}
