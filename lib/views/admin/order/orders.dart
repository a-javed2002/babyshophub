// import 'package:babyshophub/views/admin/order/order-details.dart';
// import 'package:babyshophub/views/common/highlight_text.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class OrdersScreen extends StatefulWidget {
//   @override
//   _OrdersScreenState createState() => _OrdersScreenState();
// }

// class _OrdersScreenState extends State<OrdersScreen> {
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
//                     backgroundColor: Colors.red,
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
//                             color: Colors.white,
//                             fontSize: 16,
//                           ),
//                         ),
//                         subtitle: Text('Timestamp: ${orderIds[index]}'),
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => OrderDetailsScreen(orderId),
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
//       final CollectionReference orders = FirebaseFirestore.instance.collection('orders');

//       // Fetch all orders, ordered by timestamp in descending order
//       QuerySnapshot orderSnapshot = await orders.orderBy('timestamp', descending: true).get();

//       List<String> orderIds = orderSnapshot.docs.map((doc) => doc.id).toList();
//       return orderIds;
//     } catch (e) {
//       print('Error fetching orderIds: $e');
//       return [];
//     }
//   }

//   void filterOrders(String searchTerm) async {
//     List<String> orderIds = await getOrderIds();

//     setState(() {
//       filteredOrderIds = orderIds
//           .where((orderId) =>
//               orderId.toLowerCase().contains(searchTerm.toLowerCase()))
//           .toList();
//     });
//   }
// }


import 'package:babyshophub/views/admin/order/order-details.dart';
import 'package:babyshophub/views/common/highlight_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController searchController = TextEditingController();
  List<String> filteredOrderIds = [];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History (Admin)'),
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
                hintText: 'Search by Order ID or Timestamp',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          TabBar(
            controller: _tabController,
            unselectedLabelColor: Color.fromARGB(255, 230, 130, 255),
            indicatorColor: Color.fromARGB(255, 230, 130, 255),
            labelColor: Colors.white,
            isScrollable: true, // Set this property to true for horizontal scrolling
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Pending'),
              Tab(text: 'Submitted'),
              Tab(text: 'Processing'),
              Tab(text: 'Shipped'),
              Tab(text: 'Delivered'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab 0: All Orders
                buildOrderList(),
                // Tab 1: Pending
                buildOrderList(status: 'pending'),
                // Tab 2: Submitted
                buildOrderList(status: 'submitted'),
                // Tab 3: Processing
                buildOrderList(status: 'processing'),
                // Tab 4: Shipped
                buildOrderList(status: 'shipped'),
                // Tab 5: Delivered
                buildOrderList(status: 'delivered'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOrderList({String? status}) {
    return FutureBuilder<List<String>>(
      future: getOrderIds(status: status),
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
              child: Text('No $status orders found'),
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
                  text: 'Order-$count',
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderDetailsScreen(orderId,"Order-${count}"),
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

  Future<List<String>> getOrderIds({String? status}) async {
    try {
      final CollectionReference orders = FirebaseFirestore.instance.collection('orders');

      print(status);

      // Fetch orders based on status or fetch all orders
      QuerySnapshot orderSnapshot;
      if (status != null) {
        orderSnapshot = await orders
            .where('status', isEqualTo: status)
            .orderBy('timestamp', descending: true)
            .get();
      } else {
        orderSnapshot = await orders.orderBy('timestamp', descending: true).get();
      }

      List<String> orderIds = orderSnapshot.docs.map((doc) => doc.id).toList();
      return orderIds;
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
