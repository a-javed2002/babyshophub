import 'package:babyshophub/views/authentication/Login.dart';
import 'package:babyshophub/views/authentication/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

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
  runApp(MyApp());
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

// class MyImage extends StatefulWidget {
//   @override
//   State<MyImage> createState() => _MyImageState();
// }

// class _MyImageState extends State<MyImage> {
//   List<FilePickerResult>? results;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         ElevatedButton(
//           onPressed: () {
//             selectFiles();
//           },
//           child: Text("Select Files"),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             if (results != null && results!.isNotEmpty) {
//               uploadFiles();
//             } else {
//               print("Please select files first");
//             }
//           },
//           child: Text("Upload Files"),
//         ),
//         results != null && results!.isNotEmpty
//             ? Column(
//                 children: results!
//                     .map((result) => Text(result.files.single.name))
//                     .toList(),
//               )
//             : Container(),
//       ],
//     );
//   }

//   Future<void> selectFiles() async {
//     try {
//       List<FilePickerResult>? pickedFiles =
//           await FilePicker.platform.pickFiles(allowMultiple: true);
//       if (pickedFiles != null) {
//         results = pickedFiles;
//         print("Files Selected!");
//         setState(() {}); // Add setState to update the UI after selecting files
//       }
//     } catch (e) {
//       print("Error picking files: $e");
//     }
//   }

//   Future<void> uploadFiles() async {
//     try {
//       await Firebase.initializeApp();
//       List<Future<void>> uploadTasks = [];

//       for (FilePickerResult result in results!) {
//         String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
//         String uniqueFileName =
//             '$timestamp${result.files.single.name.replaceAll(" ", "_")}';

//         firebase_storage.Reference storageReference = firebase_storage
//             .FirebaseStorage.instance
//             .ref()
//             .child("uploads/${uniqueFileName}");

//         uploadTasks.add(storageReference.putData(result.files.single.bytes!));
//       }

//       await Future.wait(uploadTasks);

//       List<String> downloadURLs = await Future.wait(
//         results!.map((result) async {
//           firebase_storage.Reference storageReference =
//               firebase_storage.FirebaseStorage.instance.ref().child(
//                     "uploads/${DateTime.now().millisecondsSinceEpoch.toString()}${result.files.single.name.replaceAll(" ", "_")}",
//                   );

//           await storageReference.putData(result.files.single.bytes!);

//           return storageReference.getDownloadURL();
//         }),
//       );

//       CollectionReference tab =
//           FirebaseFirestore.instance.collection("Employees");

//       for (String downloadURL in downloadURLs) {
//         Map<String, dynamic> data = {
//           'Emp_Name': 'sana',
//           'Emp_Age': 12,
//           'Emp_City': 'karachi',
//           'File_Path': downloadURL,
//         };
//         await tab.add(data);
//       }

//       print("Files uploaded successfully!");
//     } catch (e) {
//       print("Error uploading files: $e");
//       print("Error uploading files. Please try again.");
//     }
//   }
// }
