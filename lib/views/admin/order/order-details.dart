import 'package:babyshophub/views/Orders/order-status.dart';
import 'package:babyshophub/views/Product/product-details.dart';
import 'package:babyshophub/views/common/pop-up.dart';
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
          .update({'status': newStatus.toString().split('.').last});

      setState(() {});

      print('Order status updated successfully.');
      CustomPopup(message: "Order status updated successfully.", isSuccess: true);
    } catch (error) {
      print('Error updating order status: $error');
      CustomPopup(message: "Error updating order status.", isSuccess: false);
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
                  bool temp = orderStatuses.last.toString().toLowerCase().split('.').last ==
                      orderData['status'].toString().toLowerCase();
                  String selectedOrderStatus =
                      orderData['status'].toString().toLowerCase();
                  //     print(orderStatuses.last.toString().toLowerCase());
                  //     print(orderData['status'].toString().toLowerCase());
                  // print("hello $temp");
                  // Find the index of the selected status
                  // print(selectedOrderStatus);
                  // print(OrderStatus.values);
                  late List<OrderStatus> aheadStatuses;
                  if (!temp) {
                    int selectedIndex = orderStatuses.indexOf(OrderStatus.values
                        .firstWhere((a) =>
                            a.toString().split('.')[1] == selectedOrderStatus));

                    // Create a sublist of statuses ahead of the selected status
                    aheadStatuses = orderStatuses.sublist(selectedIndex + 1);
                    selectedOrderStatus =
                        OrderStatus.values[selectedIndex + 1].toString();
                  }
                  print("$selectedOrderStatus last");
                  // Extract and display order details as needed
                  // Inside the FutureBuilder's builder function
                  return ListView(
                    children: [
                      Center(
                        child: temp
                            ? Text("Status Changed Finished")
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  DropdownButton<String>(
                                    value: selectedOrderStatus,
                                    items: aheadStatuses.map((status) {
                                      return DropdownMenuItem<String>(
                                        value: status.toString(),
                                        child: Text(
                                            status.toString().split('.').last),
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
                                      updateOrderStatus('${widget.orderId}',
                                          selectedOrderStatus);
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
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => ProductDetails(
                              //         productId: orderItem['productId']),
                              //   ),
                              // );
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
