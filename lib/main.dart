import 'package:babyshophub/Notifiers/theme_notifier.dart';
import 'package:babyshophub/views/authentication/splashScreen.dart';
import 'package:babyshophub/views/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyDIJTzGJEDHB74iCWIcDGdFb_bfu8sf4xI",
        appId: "1:352086438099:android:b8bcd2059a3d5651f7a426",
        projectId: "babyshophub-c9c2f",
        messagingSenderId: "352086438099",
        storageBucket: "gs://babyshophub-c9c2f.appspot.com"),
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(false),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      theme: themeNotifier.currentTheme,
      home: SplashScreen(),
    );
  }
}
