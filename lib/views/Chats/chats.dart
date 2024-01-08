import 'package:babyshophub/views/Chats/chats-details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _chats = [];
  late Map<String, dynamic>? userData;
  late String currentUserUid;
  late String secondUserUid;
  int count = 0;

  @override
  void initState() {
    super.initState();
    _fetchChats();
    final User? user = FirebaseAuth.instance.currentUser;
    currentUserUid = user!.uid;
  }

  Future<void> _fetchChats() async {
    try {
      QuerySnapshot chatsSnapshot = await _firestore.collection('chats').get();

      List<Map<String, dynamic>> chatsData = [];

      for (QueryDocumentSnapshot chatDoc in chatsSnapshot.docs) {
        String chatId = chatDoc.id;
        dynamic chatStatus = chatDoc.data() ?? ['chatStatus'];

        QuerySnapshot messagesSnapshot = await _firestore
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .get();

        List<Map<String, dynamic>> messagesData =
            messagesSnapshot.docs.map((messageDoc) {
          return {
            'messageId': messageDoc.id,
            'messageText': messageDoc.data() ?? ['text'],
            'timestamp': messageDoc.data() ?? ['timestamp'],
          };
        }).toList();

        print(chatDoc.id);

        String first = chatDoc.id.split("_")[0];
        String second = chatDoc.id.split("_")[1];
        count = 0;

        if (first != currentUserUid) {
          secondUserUid = first;
          userData = await getUserById(first);
          print("in first $secondUserUid");
        } else {
          secondUserUid = second;
          userData = await getUserById(second);
          print("in second $secondUserUid");
        }

        // Sort messages by timestamp to get the latest message first
        // messagesData.sort(
        //     (a, b) => (b['timestamp'] as Timestamp).compareTo(a['timestamp']));

        for (var v = 0; v < messagesData.length; v++) {
          // print("Before ${messagesData[v]['messageText']['status']}");
          if (messagesData[v]['messageText']['status'].toString() == '1') {
            // print("After ${messagesData[v]['messageText']['status']}");
            count++;
          }
        }
        // print("--------------------------------------------------------");

        chatsData.add({
          'counted': count,
          'chatId': chatId,
          'secondUserUid': secondUserUid,
          'userData': userData,
          'chatStatus': chatStatus,
          'latestMessage': messagesData.isNotEmpty ? messagesData[0] : null,
        });
      }

      setState(() {
        _chats = chatsData;
      });
    } catch (error) {
      print('Error fetching chats: $error');
      // Handle error as needed
    }
  }

  Future<Map<String, dynamic>?> getUserById(String userId) async {
    try {
      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(userId).get();

      if (userSnapshot.exists) {
        // Return user data if the document exists
        return userSnapshot.data() as Map<String, dynamic>?;
      } else {
        // Return null if the document does not exist
        return null;
      }
    } catch (error) {
      print('Error fetching user data: $error');
      // Handle error as needed
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
      ),
      body: _buildChatList(),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      itemCount: _chats.length,
      itemBuilder: (context, index) {
        final chat = _chats[index];
        final latestMessage = chat['latestMessage'];
        final user = chat['userData'];

        return GestureDetector(
            onTap: () {
              print("tile clicked.....");

              print(currentUserUid);
              print(secondUserUid);
              
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatScreen(
                currentUserUid: currentUserUid,
                recipientUid: chat['secondUserUid'],
              )),
            );
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user['imageUrl']),
              ),
              title: Text(user['username']),
              subtitle: Text(
                  "${latestMessage['messageText']['text'].toString().substring(0, 22)}...."),
              trailing: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Text(
                  "${chat['counted']}",
                  style: TextStyle(
                    color:
                        Colors.deepPurple, // You can adjust the text color as needed
                  ),
                ),
              ),
            )
            );

        // return ListTile(
        //   title: Text('Chat ID: ${chat['chatId'] ?? 'N/A'}'),
        //   subtitle: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Text('Chat Status: ${chat['chatStatus'] ?? 'N/A'}'),
        //       Text("user data${user}"),
        //       if (latestMessage != null)
        //         Text(
        //             'Latest Message: ${latestMessage['messageText']['text'] ?? 'N/A'}'),
        //     ],
        //   ),
        // );
      },
    );
  }
}
