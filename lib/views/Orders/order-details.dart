import 'package:babyshophub/views/Orders/order-status.dart';
import 'package:babyshophub/views/Product/product-details.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:babyshophub/consts/consts.dart';

class MyOrderDetailsScreen extends StatefulWidget {
  final String orderId;

  MyOrderDetailsScreen(this.orderId);

  @override
  _MyOrderDetailsScreenState createState() => _MyOrderDetailsScreenState();
}

class _MyOrderDetailsScreenState extends State<MyOrderDetailsScreen> {


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
                  // Inside the FutureBuilder's builder function
                  return ListView(
                    children: [
                      OrderStatusBar(),
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
                                  builder: (context) =>
                                      ProductDetails(productId: orderItem['productId']),
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