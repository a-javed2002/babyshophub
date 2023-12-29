import 'package:babyshophub/views/Chats/chats-details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String sender;
  final String message;
  final DateTime timestamp;
  final String userImage; // Added userImage field

  ChatMessage({
    required this.sender,
    required this.message,
    required this.timestamp,
    required this.userImage,
  });
}

class ChatListScreen extends StatefulWidget {
  // ChatListScreen({required this.currentUserUid});

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late Future<List<ChatMessage>> chatMessages;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    late String currentUserUid ;
  @override
  void initState() {
    super.initState();
    final User? user = _auth.currentUser;
    currentUserUid = user!.uid;
    chatMessages = getChatMessages();
  }

  Future<List<ChatMessage>> getChatMessages() async {

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('chats')
        .where('participants', arrayContains: currentUserUid)
        .orderBy('timestamp', descending: true)
        .get();

    List<ChatMessage> messages = [];

    for (QueryDocumentSnapshot<Map<String, dynamic>> doc
        in querySnapshot.docs) {
      // Fetch user details using sender's UID from the 'users' collection
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(doc['sender'])
          .get();

      messages.add(ChatMessage(
        sender: doc['sender'],
        message: doc['message'],
        timestamp: doc['timestamp'].toDate(),
        userImage: userDoc[
            'userImage'], // Assuming there's a 'userImage' field in the 'users' collection
      ));
    }

    return messages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat List'),
      ),
      body: FutureBuilder<List<ChatMessage>>(
        future: chatMessages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No chat messages available.'));
          } else {
            List<ChatMessage> messages = snapshot.data!;
            return ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    ChatScreen(
                      currentUserUid: currentUserUid,
                      recipientUid: 'recipient_user_uid',
                    );
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(messages[index].userImage),
                    ),
                    title: Text(messages[index].sender),
                    subtitle: Text(messages[index].message),
                    trailing: Text('${messages[index].timestamp}'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
