import 'package:babyshophub/views/Orders/order-status.dart';
import 'package:babyshophub/views/Product/product-details.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:babyshophub/consts/consts.dart';

enum OrderStatus {
  Pending,
  Submitted,
  Processing,
  Shipped,
  Delivered,
}

class OrderDetailsScreen extends StatefulWidget {
  final String orderId;

  OrderDetailsScreen(this.orderId);

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  List<OrderStatus> orderStatuses = OrderStatus.values;

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .update({'status': newStatus});

      print('Order status updated successfully.');
    } catch (error) {
      print('Error updating order status: $error');
      // Handle error as needed
    }
  }

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
                  String selectedOrderStatus = orderData['status'];
                  // Find the index of the selected status
                  int selectedIndex = orderStatuses.indexOf(OrderStatus.values
                      .firstWhere((status) =>
                          status.toString() == selectedOrderStatus));

                  // Create a sublist of statuses ahead of the selected status
                  List<OrderStatus> aheadStatuses =
                      orderStatuses.sublist(selectedIndex + 1);
                  // Extract and display order details as needed
                  // Inside the FutureBuilder's builder function
                  return ListView(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DropdownButton<String>(
                              value: selectedOrderStatus,
                              items: aheadStatuses.map((status) {
                                return DropdownMenuItem<String>(
                                  value: status.toString(),
                                  child:
                                      Text(status.toString().split('.').last),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedOrderStatus = newValue!;
                                });
                              },
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                // Replace 'your_order_id' with the actual order ID
                                updateOrderStatus(
                                    'widget.orderId', selectedOrderStatus);
                              },
                              child: Text('Update Order Status'),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        title: Text('Order ID: ${widget.orderId}'),
                        subtitle: Text('Date: ${orderData['timestamp']}'),
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
