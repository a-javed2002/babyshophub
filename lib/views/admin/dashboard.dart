import 'package:babyshophub/consts/consts.dart';
import 'package:babyshophub/controllers/auth_controller.dart';
import 'package:babyshophub/views/admin/category/add-category.dart';
import 'package:babyshophub/views/admin/category/show-category.dart';
import 'package:babyshophub/views/admin/common/doughnut.dart';
import 'package:babyshophub/views/admin/common/horizontal_bar_chart.dart';
import 'package:babyshophub/views/admin/common/sales_table.dart';
import 'package:babyshophub/views/admin/common/vertical_bar_chart.dart';
import 'package:babyshophub/views/admin/product/add-product.dart';
import 'package:babyshophub/views/admin/product/show-product.dart';
import 'package:babyshophub/views/authentication/Login.dart';
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

  List<Data> myData1 = [
    Data('Sindh', 1600),
    Data('Punjab', 2000),
    Data('Balochistan', 1000),
    Data('KPK', 800),
  ];

  List<Data> myData2 = [
    Data('KARACHI', 1600),
    Data('LAHORE', 1000),
    Data('ISLAMABAD', 1200),
    Data('HYDERABAD', 800),
    Data('SIALKOT', 1000),
    Data('QUETTA', 1100),
    Data('DADU', 1000),
  ];

  //   List<ChartSampleData> chartData = [
  //   ChartSampleData(x: 'Error', y: 10),
  //   ChartSampleData(x: 'Contact', y: 20),
  //   ChartSampleData(x: 'Development', y: 30),
  //   ChartSampleData(x: 'Now', y: 40),
  // ];

    final List<String> columnNames = [
    'Customer No',
    'Material',
    'Quantity',
    'Price',
    'Value',
    'Sales',
  ];

    final List<Map<String, dynamic>> values = List.generate(
    15,
    (index) => {
      'Customer No': index + 1,
      'Material': 'Material ${index + 1}',
      'Quantity': (index + 1) * 10,
      'Price': (index + 1) * 5.0,
      'Value': (index + 1) * 50.0,
      'Sales': (index + 1) * 20,
    },
  );

  @override
  Widget build(BuildContext context) {
    return AdminCustomScaffold(
      context: context,
      appBarTitle: 'Dashboarde',
      body: Column(
        children: [
          Container(
            child: Center(
              child: Text('Welcome to the Dashboard'),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    print("Container tapped!");
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          insetPadding: EdgeInsets.zero,
                          child: Container(
                            // width: context.screenWidth,
                            // height: context.screenHeight,
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
                                    data: myData1,
                                    mainTitle:
                                        "Project's And There Gross Amount",
                                    legendTitle: "Project",
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
                        // width: context.screenWidth,
                        height: 300,
                        child: MyDoughnut(
                          data: myData1,
                          mainTitle: "Projects And There Gross Amount",
                          legendTitle: "Projects",
                        ),
                      ),
                      Positioned(
                        top: 8.0,
                        right: 8.0,
                        child: Icon(Icons.fit_screen, color: mainColor),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print("Container tapped!");
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          insetPadding: EdgeInsets.zero,
                          child: Container(
                            // width: context.screenWidth,
                            // height: context.screenHeight,
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
                                    data: myData2,
                                    mainTitle: "Top 10 Cities/Billed Quantity",
                                    legendTitle: "City",
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
                        // width: context.screenWidth,
                        height: 300,
                        child: MyDoughnut(
                          data: myData2,
                          mainTitle: "Top 10 Cities/Billed Quantity",
                          legendTitle: "City",
                        ),
                      ),
                      Positioned(
                        top: 8.0,
                        right: 8.0,
                        child: Icon(Icons.fit_screen, color: mainColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          MyHorizontalBarChart(),
          const Divider(),
          // MyVerticalBarChart(chartData: chartData),
          // const Divider(),
          SalesTable(
            columnNames: columnNames,
            values: values,
          ),
        ],
      ),
    );
  }
}
