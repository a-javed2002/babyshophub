// import 'package:babyshophub/views/Orders/order-details.dart';
// import 'package:babyshophub/views/common/highlight_text.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// // Import the HighlightedText class here

// class MyOrdersScreen extends StatefulWidget {
//   @override
//   _MyOrdersScreenState createState() => _MyOrdersScreenState();
// }

// class _MyOrdersScreenState extends State<MyOrdersScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   TextEditingController searchController = TextEditingController();
//   List<String> filteredOrderIds = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Order History'),
//         actions: [
//           FutureBuilder<List<String>>(
//             future: getOrderIds(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return SizedBox();
//               } else if (snapshot.hasError) {
//                 return SizedBox();
//               } else {
//                 final orderIds = snapshot.data ?? [];
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: CircleAvatar(
//                     backgroundColor: Colors.red, // You can customize the color
//                     child: Text(
//                       orderIds.length.toString(),
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 );
//               }
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: searchController,
//               onChanged: (value) {
//                 filterOrders(value);
//               },
//               decoration: InputDecoration(
//                 hintText: 'Search by Order ID or Timestamp',
//                 prefixIcon: Icon(Icons.search),
//               ),
//             ),
//           ),
//           Expanded(
//             child: FutureBuilder<List<String>>(
//               future: getOrderIds(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 } else if (snapshot.hasError) {
//                   return Center(
//                     child: Text('Error loading order history'),
//                   );
//                 } else {
//                   final orderIds = filteredOrderIds.isNotEmpty ? filteredOrderIds : snapshot.data ?? [];

//                   if (orderIds.isEmpty) {
//                     return Center(
//                       child: Text('No order history'),
//                     );
//                   }

//                   return ListView.builder(
//                     itemCount: orderIds.length,
//                     itemBuilder: (context, index) {
//                       final orderId = orderIds[index];
//                       return ListTile(
//                         title: HighlightedText(
//                           text: 'Order ID: $orderId',
//                           query: searchController.text,
//                           highlightStyle: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.red,
//                             backgroundColor: Colors.yellow,
//                             fontSize: 16,
//                           ),
//                           textStyle: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                             fontSize: 16,
//                           ),
//                         ),
//                         subtitle: Text('Timestamp: ${orderIds[index]}'),
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => MyOrderDetailsScreen(orderId),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   );
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<List<String>> getOrderIds() async {
//     try {
//       final User? user = _auth.currentUser;

//       if (user != null) {
//         final CollectionReference users = FirebaseFirestore.instance.collection('users');

//         // Fetch user's orderIds
//         DocumentSnapshot userSnapshot = await users.doc(user.uid).get();

//         if (userSnapshot.exists) {
//           List<String> orderIds = List<String>.from(userSnapshot['orders']);
//           return orderIds;
//         }
//       }

//       return [];
//     } catch (e) {
//       print('Error fetching orderIds: $e');
//       return [];
//     }
//   }

//   void filterOrders(String searchTerm) async {
//   List<String> orderIds = await getOrderIds();

//   setState(() {
//     filteredOrderIds = orderIds
//         .where((orderId) =>
//             orderId.toLowerCase().contains(searchTerm.toLowerCase()))
//         .toList();
//   });
// }

// }



import 'package:babyshophub/views/Orders/order-details.dart';
import 'package:babyshophub/views/common/highlight_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyOrdersScreen extends StatefulWidget {
  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController searchController = TextEditingController();
  List<String> filteredOrderIds = [];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
        actions: [
          FutureBuilder<List<String>>(
            future: getOrderIds(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox();
              } else if (snapshot.hasError) {
                return SizedBox();
              } else {
                final orderIds = snapshot.data ?? [];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Text(
                      orderIds.length.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Pending Orders'),
            Tab(text: 'Completed Orders'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                filterOrders(value);
              },
              decoration: InputDecoration(
                hintText: 'Search by Order ID',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: All Orders
                buildOrderList(),
                // Tab 2: Completed Orders
                buildOrderList(completed: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOrderList({bool completed = false}) {
    return FutureBuilder<List<String>>(
      future: getOrderIds(completed: completed),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error loading order history'),
          );
        } else {
          final orderIds =
              filteredOrderIds.isNotEmpty ? filteredOrderIds : snapshot.data ?? [];

          if (orderIds.isEmpty) {
            return Center(
              child: Text('No order history'),
            );
          }

          int count=0;

          return ListView.builder(
            itemCount: orderIds.length,
            itemBuilder: (context, index) {
              final orderId = orderIds[index];
              count++;
              return ListTile(
                title: HighlightedText(
                  text: 'Order-${count}',
                  query: searchController.text,
                  highlightStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    backgroundColor: Colors.yellow,
                    fontSize: 16,
                  ),
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                subtitle: HighlightedText(
                  text: 'Order ID: ${orderIds[index]}',
                  query: searchController.text,
                  highlightStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    backgroundColor: Colors.yellow,
                    fontSize: 16,
                  ),
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                // subtitle: Text('Order ID: ${orderIds[index]}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyOrderDetailsScreen(orderId,"Order-${count}"),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }

  Future<List<String>> getOrderIds({bool completed = false}) async {
  try {
    final User? user = _auth.currentUser;

    if (user != null) {
      final CollectionReference orders = FirebaseFirestore.instance.collection('orders');

      QuerySnapshot ordersSnapshot = await orders
          .where('userId', isEqualTo: user.uid)
          .get();

      List<String> orderIds = [];

      ordersSnapshot.docs.forEach((orderDoc) {
        String orderId = orderDoc.id;
        String orderStatus = orderDoc['status'] ?? '';

        if (completed) {
          // Check if the order is completed (you may need to adjust this logic)
          if (orderStatus.toLowerCase() == 'delivered') {
            orderIds.add(orderId);
          }
        } else {
          // Add all orders without checking status
          orderIds.add(orderId);
        }
      });

      return orderIds;
    }

    return [];
  } catch (e) {
    print('Error fetching orderIds: $e');
    return [];
  }
}

  void filterOrders(String searchTerm) async {
    List<String> orderIds = await getOrderIds();

    setState(() {
      filteredOrderIds = orderIds
          .where((orderId) =>
              orderId.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    });
  }
}
