import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyUsers extends StatefulWidget {
  @override
  _MyUsersState createState() => _MyUsersState();
}

class _MyUsersState extends State<MyUsers> {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: usersCollection.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Extract user data from Firestore
          List<DocumentSnapshot> users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var userData = users[index].data() as Map<String, dynamic>;
              return ListTile(
                onTap: () {
                  _showUserDetailsDialog(context, userData);
                },
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(userData['imageUrl'] ?? ''),
                ),
                title: Text(userData['username']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(userData['email']),
                    Text('Role: ${userData['role']}'),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showUserDetailsDialog(
      BuildContext context, Map<String, dynamic> userData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('User Details'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        userData['imageUrl'] ?? 'assets/images/profile.jpg'),
                  ),
                  Text('ID: ${userData['id']}'),
                  Text('Name: ${userData['previousDetails']['name']}'),
                  Text('Role: ${userData['previousDetails']['role']}'),
                  Text('Email: ${userData['previousDetails']['email']}'),
                  Text('CNIC: ${userData['cnic']}'),
                  Text('Orders: ${userData['orders'].length}'),
                  Text('Address: ${userData['address'].length}'),
                  GestureDetector(onTap: (){_showOrderDetailsDialog(context,userData['contact']);},child: Text('Contact: ${userData['contact'].length}')),
                  Text('Timestamp: ${userData['timestamp']}'),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    _changeRole(userData['id'], userData['role']);
                    Navigator.of(context).pop();
                  },
                  child: Text('Change Role'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _deactivateUser(userData['id']);
                    Navigator.of(context).pop();
                  },
                  child: Text('Deactivate User'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _changeRole(String userId, String currentRole) {
    // Implement logic to change the user's role
    String newRole = (currentRole == 'user') ? 'admin' : 'user';
    usersCollection.doc(userId).update({'role': newRole});
  }

  void _deactivateUser(String userId) {
    // Implement logic to deactivate the user
    usersCollection.doc(userId).update({'status': 0});
  }

  void _showOrderDetailsDialog(BuildContext context, List<dynamic> contact) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Contacts'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Contact Are:"),
              SizedBox(width: 8.0),
              Expanded(
                child: Container(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: contact.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          contact[index],
                          style: TextStyle(fontSize: 16.0),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
