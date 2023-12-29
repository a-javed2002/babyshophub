import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserUid;
  final String recipientUid;

  ChatScreen({required this.currentUserUid, required this.recipientUid});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isEmojiPickerVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with User'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(_getChatId())
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData) {
                  return Center(child: Text('No messages available.'));
                } else {
                  QuerySnapshot<Map<String, dynamic>> querySnapshot = snapshot.data as QuerySnapshot<Map<String, dynamic>>;
                  List<DocumentSnapshot<Map<String, dynamic>>> messages = querySnapshot.docs;

                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      var message = messages[index].data()!;
                      return ListTile(
                        title: Text(message['sender']),
                        subtitle: message['imageUrl'] != null
                            ? Image.network(message['imageUrl'])
                            : Text(message['text']),
                      );
                    },
                  );
                }
              },
            ),
          ),
          _isEmojiPickerVisible ? buildEmojiPicker() : Container(),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.emoji_emotions),
                  onPressed: () {
                    setState(() {
                      _isEmojiPickerVisible = !_isEmojiPickerVisible;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.camera),
                  onPressed: () {
                    _pickImage(ImageSource.camera);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.photo),
                  onPressed: () {
                    _pickImage(ImageSource.gallery);
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEmojiPicker() {
    return EmojiPicker(
      onEmojiSelected: (Category? category, Emoji emoji) {
        _messageController.text += emoji.emoji;
      },
      config: Config(
        columns: 7,
        emojiSizeMax: 32.0,
        verticalSpacing: 0,
        horizontalSpacing: 0,
        initCategory: Category.RECENT,
        bgColor: Color(0xFFF2F2F2),
        indicatorColor: Colors.blue,
        iconColor: Colors.grey,
        iconColorSelected: Colors.blue,
        // progressIndicatorColor: Colors.blue,
        backspaceColor: Colors.blue,
        // showRecentsTab: true,
        recentsLimit: 28,
        // noRecents: Text('No Recents'),
        // noRecentsStyle: TextStyle(fontSize: 20, color: Colors.black26),
        tabIndicatorAnimDuration: Duration(milliseconds: 1000),
        categoryIcons: CategoryIcons(),
        buttonMode: ButtonMode.MATERIAL,
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    // final pickedFile = await ImagePicker().getImage(source: source);

    // if (pickedFile != null) {
    //   File imageFile = File(pickedFile.path);
    //   String imageUrl = await _uploadImageToStorage(imageFile);

    //   _sendMessage(imageUrl: imageUrl);
    // }
  }

  Future<String> _uploadImageToStorage(File imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child('chat_images/$fileName.jpg');
    UploadTask uploadTask = reference.putFile(imageFile);

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    return await taskSnapshot.ref.getDownloadURL();
  }

  void _sendMessage({String? imageUrl}) async {
    String messageText = _messageController.text.trim();
    if (messageText.isNotEmpty || imageUrl != null) {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(_getChatId())
          .collection('messages')
          .add({
            'sender': widget.currentUserUid,
            'text': messageText,
            'imageUrl': imageUrl,
            'timestamp': FieldValue.serverTimestamp(),
          });

      _messageController.clear();
      setState(() {
        _isEmojiPickerVisible = false;
      });
    }
  }

  String _getChatId() {
    // Create a unique chat ID based on user UIDs
    List<String> participantUids = [widget.currentUserUid, widget.recipientUid];
    participantUids.sort();
    return participantUids.join('_');
  }
}
