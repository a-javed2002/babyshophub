import 'package:babyshophub/consts/consts.dart';
import 'package:babyshophub/controllers/auth_controller.dart';
import 'package:babyshophub/views/admin/category/show-category.dart';
import 'package:babyshophub/views/admin/common/doughnut.dart';
import 'package:babyshophub/views/admin/order/orders.dart';
import 'package:babyshophub/views/admin/product/show-product.dart';
import 'package:babyshophub/views/admin/users.dart';
import 'package:babyshophub/views/common/admin-scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyDashboard extends StatefulWidget {
  @override
  State<MyDashboard> createState() => _MyDashboardState();
}

class _MyDashboardState extends State<MyDashboard> {
  late AuthController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AuthController();
  }

  @override
  Widget build(BuildContext context) {
    return AdminCustomScaffold(
      context: context,
      appBarTitle: 'Dashboard',
      body: SafeArea(
        child: Column(
          children: [
            // Total Products Tile
            FutureBuilder<int>(
              future: fetchTotalProducts(),
              builder: (context, snapshot) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ShowProduct()),
                    );
                  },
                  child: DashboardTile(
                    title: 'Total Products',
                    count: snapshot.data ?? 0,
                    icon: Icons.shopping_cart,
                  ),
                );
              },
            ),

            // Total Categories Tile
            FutureBuilder<int>(
              future: fetchTotalCategories(),
              builder: (context, snapshot) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ShowCategory()),
                    );
                  },
                  child: DashboardTile(
                    title: 'Total Categories',
                    count: snapshot.data ?? 0,
                    icon: Icons.category,
                  ),
                );
              },
            ),

            // Total Users Tile
            FutureBuilder<int>(
              future: fetchTotalUsers(),
              builder: (context, snapshot) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyUsers()),
                    );
                  },
                  child: DashboardTile(
                    title: 'Total Users',
                    count: snapshot.data ?? 0,
                    icon: Icons.people,
                  ),
                );
              },
            ),

            // Total Orders Tile
            FutureBuilder<int>(
              future: fetchTotalOrders(),
              builder: (context, snapshot) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OrdersScreen()),
                    );
                  },
                  child: DashboardTile(
                    title: 'Total Orders',
                    count: snapshot.data ?? 0,
                    icon: Icons.shopping_basket,
                  ),
                );
              },
            ),
            // ... Existing Widgets ...
            // Fetch Order Per Month Data
            FutureBuilder(
              future: fetchOrderPerMonthData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error loading order per month data');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No data available for order per month');
                } else {
                  return GestureDetector(
                    onTap: () {
                      print("Container tapped!");
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            insetPadding: EdgeInsets.zero,
                            child: Container(
                              color: mainLightColor,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.close),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      print("Dialog closed");
                                    },
                                  ),
                                  Expanded(
                                    child: MyDoughnut(
                                      data: snapshot.data!,
                                      mainTitle: "Order Per Month",
                                      legendTitle: "Month",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: 300,
                          child: MyDoughnut(
                            data: snapshot.data!,
                            mainTitle: "Order Per Month",
                            legendTitle: "Month",
                          ),
                        ),
                        Positioned(
                          top: 8.0,
                          right: 8.0,
                          child: Icon(Icons.fit_screen, color: mainColor),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),

            // Fetch Top Selling Products Data
            FutureBuilder<List<Data>>(
              future: fetchTopSellingProductsData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error loading top selling products data');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No data available for top selling products');
                } else {
                  return GestureDetector(
                    onTap: () {
                      print("Container tapped!");
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            insetPadding: EdgeInsets.zero,
                            child: Container(
                              color: mainLightColor,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.close),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      print("Dialog closed");
                                    },
                                  ),
                                  Expanded(
                                    child: MyDoughnut(
                                      data: snapshot.data!,
                                      mainTitle: "Top Selling Products",
                                      legendTitle: "Products",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: 300,
                          child: MyDoughnut(
                            data: snapshot.data!,
                            mainTitle: "Top Selling Products",
                            legendTitle: "Products",
                          ),
                        ),
                        Positioned(
                          top: 8.0,
                          right: 8.0,
                          child: Icon(Icons.fit_screen, color: mainColor),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),

            // const Divider(),
            // MyHorizontalBarChart(),
            // const Divider(),
            // MyVerticalBarChart(chartData: chartData),
            // const Divider(),
            // SalesTable(
            //   columnNames: columnNames,
            //   col_2s: col_2s,
            // ),
          ],
        ),
      ),
    );
  }

  Future<int> fetchTotalProducts() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('products').get();
    return querySnapshot.size;
  }

  Future<int> fetchTotalCategories() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('categories').get();
    return querySnapshot.size;
  }

  Future<int> fetchTotalUsers() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    return querySnapshot.size;
  }

  Future<int> fetchTotalOrders() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('orders').get();
    return querySnapshot.size;
  }

  Future<List<Data>> fetchOrderPerMonthData() async {
    // Use Firestore query to get order per month data
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('orders').get();

    // Process data and return a List<Data>
    List<Data> result = [];

    // Create a Map to store order count for each month
    Map<String, int> monthOrderCountMap = {};

    // Process the querySnapshot to populate the monthOrderCountMap
    querySnapshot.docs.forEach((doc) {
      Timestamp timestamp = doc['timestamp'];
      DateTime dateTime = timestamp.toDate();

      // Extract month and year from the timestamp
      String monthYearKey = '${dateTime.month}-${dateTime.year}';

      // Update the order count for the corresponding month
      monthOrderCountMap.update(
        monthYearKey,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    });

    // Convert the monthOrderCountMap to a List<Data>
    monthOrderCountMap.forEach((monthYear, orderCount) {
      List<String> parts = monthYear.split('-');
      result.add(Data('${parts[0]}-${parts[1]}', orderCount));
    });

    // Sort the result list based on month and year
    result.sort((a, b) => a.col_1.compareTo(b.col_1));

    return result;
  }

  Future<List<Data>> fetchTopSellingProductsData() async {
    // Use Firestore query to get orders data
    QuerySnapshot<Map<String, dynamic>> ordersSnapshot =
        await FirebaseFirestore.instance.collection('orders').get();

    // Create a Map to store the sales count for each product
    Map<String, int> productSalesMap = {};

    // Process the ordersSnapshot to update the sales count for each product
    for (QueryDocumentSnapshot<Map<String, dynamic>> orderDoc
        in ordersSnapshot.docs) {
      List<dynamic> orderProducts = orderDoc['products'];
      if (orderProducts != null) {
        for (dynamic orderProduct in orderProducts) {
          String productId = orderProduct['productId'];
          String productName = await getProductName(productId);

          // Update the sales count for the corresponding product
          productSalesMap.update(
            productName,
            (value) => value + int.parse(orderProduct['quantity'].toString()),
            ifAbsent: () => int.parse(orderProduct['quantity'].toString()),
          );
        }
      }
    }

    // Convert the productSalesMap to a List<Data>
    List<Data> result = [];
    productSalesMap.forEach((productName, salesCount) {
      result.add(Data(productName, salesCount));
    });

    // Sort the result list based on sales count in descending order
    result.sort((a, b) => b.col_2.compareTo(a.col_2));

    // Take only the top 6 products
    result = result.take(6).toList();

    return result;
  }

  Future<String> getProductName(String productId) async {
    // Use Firestore query to get product name based on the productId
    DocumentSnapshot<Map<String, dynamic>> productSnapshot =
        await FirebaseFirestore.instance
            .collection('products')
            .doc(productId)
            .get();

    return productSnapshot['name'];
  }
}

class DashboardTile extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;

  DashboardTile({
    required this.title,
    required this.count,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        count.toString(),
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      leading: Icon(
        icon,
        size: 36,
      ),
    );
  }
}
