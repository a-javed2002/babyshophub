import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:babyshophub/consts/consts.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String orderId;

  OrderDetailsScreen(this.orderId);

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final GlobalKey<_OrderStatusBarState> _orderStatusBarKey =
      GlobalKey<_OrderStatusBarState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<DocumentSnapshot<Object?>?>(
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
                  final orderData =
                      snapshot.data!.data() as Map<String, dynamic>;

                  // Extract and display order details as needed
                  return ListView(
                    children: [
                      ListTile(
                        title: Text('Order ID: ${widget.orderId}'),
                        subtitle: Text('Date: ${orderData['timestamp']}'),
                        // Add other order details as needed
                      ),
                    ],
                  );
                }
              },
            ),
          ),
          // Add the animated status bar
          OrderStatusBar(key: _orderStatusBarKey),

          // Add a button to toggle the status bar
          ElevatedButton(
            onPressed: () {
              // Call toggleStatusBar on the existing OrderStatusBar instance
              _orderStatusBarKey.currentState?.toggleStatusBar();
            },
            child: const Text('Toggle Status Bar'),
          ),
        ],
      ),
    );
  }

  Future<DocumentSnapshot<Object?>?> getOrderDetails() async {
    try {
      final CollectionReference orders =
          FirebaseFirestore.instance.collection(ordersCollection);

      // Fetch order details using orderId
      DocumentSnapshot orderSnapshot = await orders.doc(widget.orderId).get();

      return orderSnapshot;
    } catch (e) {
      print('Error fetching order details: $e');
      // Return an empty DocumentSnapshot in case of an error
      return null;
    }
  }
}


class OrderStatusBar extends StatefulWidget {
  const OrderStatusBar({Key? key}) : super(key: key);

  @override
  _OrderStatusBarState createState() => _OrderStatusBarState();
}

class _OrderStatusBarState extends State<OrderStatusBar> {
  double _statusBarHeight = 0.0;

  void toggleStatusBar() {
    setState(() {
      _statusBarHeight = _statusBarHeight == 0.0 ? 100.0 : 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: _statusBarHeight,
      color: Colors.green, // You can customize the color
      child: Center(
        child: Text(
          _statusBarHeight == 0.0
              ? 'No Order Submitted'
              : 'Order Submitted Successfully!',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final GlobalKey<_OrderStatusBarState> _orderStatusBarKey =
      GlobalKey<_OrderStatusBarState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Screen'),
      ),
      body: Column(
        children: [
          // Your order content goes here
          // ...

          // Add the animated status bar
          OrderStatusBar(key: _orderStatusBarKey),

          // Add a button to toggle the status bar
          ElevatedButton(
            onPressed: () {
              // Call toggleStatusBar on the existing OrderStatusBar instance
              _orderStatusBarKey.currentState?.toggleStatusBar();
            },
            child: const Text('Toggle Status Bar'),
          ),
        ],
      ),
    );
  }
}