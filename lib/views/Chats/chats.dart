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
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late String currentUserUid;
  late Stream<List<ChatMessage>> chatMessages;

  @override
  void initState() {
    super.initState();
    final User? user = FirebaseAuth.instance.currentUser;
    currentUserUid = user!.uid;
    chatMessages = getChatMessagesStream();
  }

  Stream<List<ChatMessage>> getChatMessagesStream() {
    print(currentUserUid);
    return FirebaseFirestore.instance
        .collection('chats')
        .where('participants', arrayContains: currentUserUid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          List<ChatMessage> messages = [];

          for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
            DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
                .instance
                .collection('users')
                .doc(doc['sender'])
                .get();

            messages.add(ChatMessage(
              sender: doc['sender'],
              message: doc['message'],
              timestamp: doc['timestamp'].toDate(),
              userImage: userDoc['userImage'],
            ));
          }

          return messages;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat List'),
      ),
      body: StreamBuilder<List<ChatMessage>>(
        stream: chatMessages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
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
                      recipientUid: messages[index].sender,
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
