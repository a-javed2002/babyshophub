import 'package:babyshophub/controllers/auth_controller.dart';
import 'package:babyshophub/views/OnBoarding/onBoarding.dart';
import 'package:babyshophub/views/Profile/reset-password.dart';
import 'package:babyshophub/views/authentication/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:babyshophub/Notifiers/theme_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final AuthController _authController = AuthController();

    Future<void> _setOnboardingStatus({required status}) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboardingDone', status);
      print("set OnBoarding To False");
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('SettingsScreen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text('Dark Theme',style: TextStyle(color: Colors.white)),
              trailing: Switch(
                value: themeNotifier.isDarkTheme,
                onChanged: (value) {
                  themeNotifier.toggleTheme();
                },
              ),
            ),
            GestureDetector(
              onTap: () async {
                await _setOnboardingStatus(status: false);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OnBoardingScreen(),
                  ),
                );
              },
              child: ListTile(
                title: Text('See Intro',style: TextStyle(color: Colors.white)),
              ),
            ),
            GestureDetector(
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResetPasswordScreen(),
                  ),
                );
              },
              child: ListTile(
                title: Text('Change Password',style: TextStyle(color: Colors.white),),
              ),
            ),
            GestureDetector(
              onTap: () async {
                await _authController.logout(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
              child: ListTile(
                title: Text('Logout',style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
