import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderId;

  OrderDetailsScreen(this.orderId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: FutureBuilder<DocumentSnapshot<Object?>?>(
        future: getOrderDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Text('Error loading order details'),
            );
          } else {
            final orderData = snapshot.data!.data() as Map<String, dynamic>;

            // Extract and display order details
            return ListView(
              children: [
                ListTile(
                  title: Text('Order ID: $orderId'),
                  subtitle: Text('Date: ${orderData['timestamp']}'),
                  // Add other order details as needed
                ),
                Divider(), // Add a divider for better readability
                ListTile(
                  title: Text('User ID: ${orderData['userId']}'),
                  // Fetch and display user details
                  subtitle: FutureBuilder<DocumentSnapshot<Object?>?>(
                    future: getUserDetails(orderData['userId']),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (userSnapshot.hasError || !userSnapshot.hasData) {
                        return Text('Error loading user details');
                      } else {
                        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                        return Text('User Name: ${userData['userName']}');
                        // Add other user details as needed
                      }
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

Future<DocumentSnapshot<Object?>?> getOrderDetails() async {
  try {
    final CollectionReference orders = FirebaseFirestore.instance.collection('ordersCollection');

    // Fetch order details using orderId
    DocumentSnapshot<Object?> orderSnapshot = await orders.doc(orderId).get();

    return orderSnapshot;
  } catch (e) {
    print('Error fetching order details: $e');
    // Return null in case of an error
    return null;
  }
}


  Future<DocumentSnapshot<Object?>?> getUserDetails(String userId) async {
    try {
      final CollectionReference users = FirebaseFirestore.instance.collection('users');

      // Fetch user details using userId
      DocumentSnapshot userSnapshot = await users.doc(userId).get();

      return userSnapshot;
    } catch (e) {
      print('Error fetching user details: $e');
      // Return an empty DocumentSnapshot in case of an error
      return null;
    }
  }
}
