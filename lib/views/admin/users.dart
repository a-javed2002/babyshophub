import 'package:babyshophub/consts/firestore_consts.dart';
import 'package:babyshophub/views/admin/order/order-details.dart';
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
              String lowerCaseSignInMethods =
                  userData['provider'].toString().toLowerCase();
              String abc = "assets/icons/email_icon.png";
              if (lowerCaseSignInMethods == 'google') {
                abc = "assets/icons/google_logo.png";
              } else if (lowerCaseSignInMethods == 'facebook') {
                abc = "assets/icons/facebook_logo.png";
              } else if (lowerCaseSignInMethods == 'github') {
                abc = "assets/icons/github_logo.png";
              }
              return ListTile(
                onTap: () {
                  _showUserDetailsDialog(context, userData, abc);
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
                trailing: CircleAvatar(
                  backgroundImage: AssetImage(abc),
                ),
                // trailing: abc != ""
                //     ? CircleAvatar(
                //         backgroundImage: AssetImage(abc),
                //       )
                //     : Container(),
              );
            },
          );
        },
      ),
    );
  }

  void _showUserDetailsDialog(
      BuildContext context, Map<String, dynamic> userData, String pImage) {
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
                  // Text('ID: ${userData['id']}',style: TextStyle(color: Colors.black),),
                  Text(
                    'Name: ${userData['name']}',
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(
                    'Role: ${userData['role']}',
                    style: TextStyle(color: Colors.black),
                  ),
                  CircleAvatar(
                    backgroundImage: AssetImage(pImage),
                  ),
                  Text(
                    'Email: ${userData['email']}',
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(
                    'CNIC: ${userData['cnic']}',
                    style: TextStyle(color: Colors.black),
                  ),
                  GestureDetector(
                      onTap: () {
                        _showOrdersDetailsDialog(context, userData['orders']);
                      },
                      child: Text(
                        'Orders: ${userData['orders'].length}',
                        style: TextStyle(color: Colors.black),
                      )),
                  GestureDetector(
                      onTap: () {
                        _showAddressDetailsDialog(context, userData['address']);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Address: ${userData['address'].length}',
                            style: TextStyle(color: Colors.black),
                          ),
                          Icon(
                            Icons.search,
                            color: Colors.deepPurple,
                          )
                        ],
                      )),

                  GestureDetector(
                      onTap: () {
                        _showContactDetailsDialog(context, userData['contact']);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Contact: ${userData['contact'].length}',
                            style: TextStyle(color: Colors.black),
                          ),
                          Icon(
                            Icons.search,
                            color: Colors.deepPurple,
                          )
                        ],
                      )),
                  Text(
                    'Timestamp: ${userData['timestamp']}',
                    style: TextStyle(color: Colors.black),
                  ),
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

  void _showContactDetailsDialog(BuildContext context, List<dynamic> contact) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Contacts'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
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

  void _showAddressDetailsDialog(BuildContext context, List<dynamic> address) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Address'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Address Are:"),
              SizedBox(width: 8.0),
              Expanded(
                child: Container(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: address.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          address[index],
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
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

  void _showOrdersDetailsDialog(BuildContext context, List<dynamic> order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int count=0;
        return AlertDialog(
          title: Text('Orders'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Orders Are:"),
              SizedBox(width: 8.0),
              Expanded(
                child: Container(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: order.length,
                    itemBuilder: (BuildContext context, int index) {
                      count++;
                      return ListTile(
                        title: Text("Order-$count"),
                        subtitle: Text('Order ID: ${order[index]}'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OrderDetailsScreen(order[index], "Order-${count}"),
                            ),
                          );
                        },
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
