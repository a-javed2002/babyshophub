import 'package:babyshophub/views/Product/product-details.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:babyshophub/consts/consts.dart';

enum OrderStatus {
  pending,
  submitted,
  processing,
  shipped,
  delivered,
}

class MyOrderDetailsScreen extends StatefulWidget {
  final String orderId;
  final String orderNumber;

  MyOrderDetailsScreen(this.orderId, this.orderNumber);

  @override
  _MyOrderDetailsScreenState createState() => _MyOrderDetailsScreenState();
}

class _MyOrderDetailsScreenState extends State<MyOrderDetailsScreen> {
  final GlobalKey<_OrderStatusBarState> _orderStatusBarKey =
      GlobalKey<_OrderStatusBarState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.orderNumber}'),
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
                  // Inside the FutureBuilder's builder function
                  return ListView(
                    children: [
                      OrderStatusBar(
                          key: _orderStatusBarKey,
                          initialStatus: OrderStatusBar.getStatusEnum(
                              orderData['status'])),
                      ListTile(
                        title: Column(
                          children: [
                            Text('Order ID: ${widget.orderId}'),
                            const Divider(),
                            Text('Name: ${orderData['name']}'),
                            const Divider(),
                            Text('Status: ${orderData['status']}'),
                          ],
                        ),
                        subtitle: Column(
                          children: [
                            const Divider(),
                            Text('Address: ${orderData['address']}'),
                            const Divider(),
                            Text('Contact: ${orderData['contact']}'),
                            const Divider(),
                            Text(
                                'Date: ${(orderData['timestamp'] as Timestamp).toDate()}'),
                          ],
                        ),
                        // Add other order details as needed
                      ),
                      SizedBox(height: 10), // Add some spacing

                      // Display order items
                      ...List.generate(
                        (orderData['orderItems'] as List<dynamic>).length,
                        (index) {
                          final orderItem = orderData['orderItems'][index]
                              as Map<String, dynamic>;

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetails(
                                      productId: orderItem['productId']),
                                ),
                              );
                            },
                            child: Card(
                              child: ListTile(
                                title: Text('Product: ${orderItem['name']}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Quantity: ${orderItem['quantity']}'),
                                    Text(
                                        'Price: \$${orderItem['price']}'), // Assuming 'price' is a numeric field
                                  ],
                                ),
                                leading: Image.network(
                                  orderItem[
                                      'imageUrls'], // Assuming 'imageUrl' is a valid URL
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                                // Add other product details as needed
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }
              },
            ),
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
  final OrderStatus initialStatus;

  const OrderStatusBar({Key? key, this.initialStatus = OrderStatus.pending})
      : super(key: key);

  static OrderStatus getStatusEnum(String status) {
    print("in getStatusEnum $status");
    switch (status.toLowerCase()) {
      case 'pending':
        return OrderStatus.pending;
      case 'submitted':
        return OrderStatus.submitted;
      case 'processing':
        return OrderStatus.processing;
      case 'shipped':
        return OrderStatus.shipped;
      case 'delivered':
        return OrderStatus.delivered;
      default:
        return OrderStatus
            .pending; // Default to pending if status is unrecognized
    }
  }

  @override
  _OrderStatusBarState createState() => _OrderStatusBarState();
}

class _OrderStatusBarState extends State<OrderStatusBar> {
  double _statusBarHeight = 0.0;
  OrderStatus _currentStatus = OrderStatus.pending;

  @override
  void initState() {
    super.initState();
    // Set initial status
    _currentStatus = widget.initialStatus;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          height: _statusBarHeight,
          color: _getStatusColor(),
          child: Center(
            child: Text(
              _getStatusText(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  void toggleStatusBar(OrderStatus newStatus) {
    setState(() {
      _statusBarHeight = _statusBarHeight == 0.0 ? 100.0 : 0.0;
      _currentStatus = newStatus;
    });
  }

  Color _getStatusColor() {
    switch (_currentStatus) {
      case OrderStatus.pending:
        return Colors.yellow;
      case OrderStatus.submitted:
        return Colors.green;
      case OrderStatus.processing:
        return Colors.blue;
      case OrderStatus.shipped:
        return Colors.orange;
      case OrderStatus.delivered:
        return Colors.teal;
    }
  }

  String _getStatusText() {
    switch (_currentStatus) {
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.submitted:
        return 'Submitted Successfully!';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
    }
  }
}
