// import 'package:babyshophub/views/Chats/chats-details.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ChatListScreenR extends StatefulWidget {
//   @override
//   _ChatListScreenRState createState() => _ChatListScreenRState();
// }

// class _ChatListScreenRState extends State<ChatListScreenR> {
//   late String currentUserUid;

//   @override
//   void initState() {
//     super.initState();
//     final User? user = FirebaseAuth.instance.currentUser;
//     currentUserUid = user!.uid;
//     // fetchChatsData();
//   }

//   Stream<List<ChatMessage>> getChatMessagesStream() {
//     print(currentUserUid);
//     return FirebaseFirestore.instance
//         .collection('chats')
//         // .where('participants', arrayContains: currentUserUid)
//         // .orderBy('timestamp', descending: true)
//         .snapshots()
//         .asyncMap((snapshot) async {
//       List<ChatMessage> messages = [];

//       for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
//         // DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
//         //     .instance
//         //     .collection('users')
//         //     .doc(doc['message']['sender'])
//         //     .get();

//         messages.add(ChatMessage(
//           sender: "",
//           message: "",
//           timestamp: DateTime.now(),
//           userImage: "",
//         ));
//       }
// print(messages.length);
//       return messages;
//     });
//   }

// //   Future<List<Map<String, dynamic>>> fetchChatsData() async {
// //   try {
// //     QuerySnapshot<Map<String, dynamic>> chatsSnapshot =
// //         await FirebaseFirestore.instance.collection('chats').get();

// //     List<Map<String, dynamic>> chatsData = [];

// //     for (QueryDocumentSnapshot<Map<String, dynamic>> chatDocument
// //         in chatsSnapshot.docs) {
// //       Map<String, dynamic> chat = chatDocument.data();
// //       chatsData.add(chat);

// //       // Print fields and values for each document
// //       print('Document ID: ${chatDocument.id}');
// //       _printFieldsAndValues(chat);
// //       print('-----------------------------');
// //     }

// //     // Print the total number of documents fetched
// //     print('Total documents fetched: ${chatsSnapshot.size}');

// //     return chatsData;
// //   } catch (error) {
// //     // Handle any potential errors
// //     print('Error fetching chats: $error');
// //     return [];
// //   }
// // }

// // void _printFieldsAndValues(Map<String, dynamic> data) {
// //   data.forEach((key, value) {
// //     if (value is Map<String, dynamic>) {
// //       // If the value is a nested map, print its fields and values
// //       print('$key:');
// //       _printFieldsAndValues(value);
// //     } else {
// //       // If the value is not a map, print the field and value
// //       print('$key: $value');
// //     }
// //   });
// // }

  

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat List'),
//       ),
//       body: StreamBuilder<List<ChatMessage>>(
//         stream: chatMessages,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No chat messages available.'));
//           } else {
//             List<ChatMessage> messages = snapshot.data!;
//             return ListView.builder(
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 return GestureDetector(
//                   onTap: () {
//                     ChatScreen(
//                       currentUserUid: currentUserUid,
//                       recipientUid: messages[index].sender,
//                     );
//                   },
//                   child: ListTile(
//                     leading: CircleAvatar(
//                       backgroundImage: NetworkImage(messages[index].userImage),
//                     ),
//                     title: Text(messages[index].sender),
//                     subtitle: Text(messages[index].message),
//                     trailing: Text('${messages[index].timestamp}'),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
