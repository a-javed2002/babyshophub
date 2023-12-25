import 'package:babyshophub/views/authentication/Login.dart';
import 'package:babyshophub/views/authentication/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDIJTzGJEDHB74iCWIcDGdFb_bfu8sf4xI",
      appId: "1:352086438099:android:b8bcd2059a3d5651f7a426",
      projectId: "babyshophub-c9c2f",
      messagingSenderId: "352086438099",
      storageBucket: "gs://babyshophub-c9c2f.appspot.com"
    ),
  );
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}








// class MyMain extends StatefulWidget {
//   @override
//   _MyMainState createState() => _MyMainState();
// }

// class _MyMainState extends State<MyMain> implements MySpecificWidgetUpdater {
//   int counter = 0;

//   // Reference to the updater interface
//   MySpecificWidgetUpdater? _specificWidgetUpdater;

//   @override
//   void initState() {
//     super.initState();
//     _specificWidgetUpdater = MySpecificWidgetUpdater(this);
//   }

//   void _incrementCounter() {
//     setState(() {
//       counter++;
//     });

//     // Access and call a method on the specific widget to refresh only that part
//     _specificWidgetUpdater?.updateFunction();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Specific Widget Refresh'),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Text(
//             'Counter: $counter',
//             style: TextStyle(fontSize: 20),
//           ),
//           MySpecificWidget(
//             updater: _specificWidgetUpdater,
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }