import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nanotech/consts/consts.dart';
import 'package:nanotech/views/Home/home.dart';
import 'package:nanotech/views/Sales/r.dart';
import 'package:nanotech/widgets_common/bg_widget.dart';
import 'package:nanotech/widgets_common/custom_textField.dart';
import 'package:nanotech/widgets_common/our_button.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'components/doughnut.dart';

import 'package:flutter/material.dart';
import 'package:nanotech/consts/colors.dart';
import 'package:nanotech/views/Sales/components/doughnut.dart';
import 'package:nanotech/views/Sales/components/horizontal_bar_chart.dart';
import 'package:nanotech/views/Sales/components/vertical_bar_chart.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:nanotech/views/Sales/components/checkbox.dart';
import 'package:nanotech/views/Sales/components/radiobox.dart';
import 'package:nanotech/views/Sales/components/dropdown.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  @override
  Widget build(BuildContext context) {
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
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    // Checkbox states
    bool checkbox1 = false;
    bool checkbox2 = false;

    // Radio button states
    int? selectedRadio;

    List<String> cat = ["All", "cat-1", "cat-2"];
    List<String> subCat = ["All", "subCat-1", "subCat-2"];

    // Dropdown states
    String? selectedDropdown1 = cat[0];
    String? selectedDropdown2 = subCat[0];

    String valueChoose;
    List listItem = ['item-1', 'item-2', 'item-3', 'item-4'];

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

    // TextEditingController yearController = TextEditingController();
    // TextEditingController monthController = TextEditingController();

    // Future<void> _selectYear(BuildContext context) async {
    //   final DateTime? picked = await showDatePicker(
    //     context: context,
    //     initialDate: DateTime.now(),
    //     firstDate: DateTime(1900),
    //     lastDate: DateTime(2100),
    //   );
    //   if (picked != null && picked != DateTime.now()) {
    //     setState(() {
    //       yearController.text = picked.year.toString();
    //     });
    //   }
    // }

    // Future<void> _selectMonth(BuildContext context) async {
    //   final DateTime? picked = await showDatePicker(
    //     context: context,
    //     initialDate: DateTime.now(),
    //     firstDate: DateTime(1900),
    //     lastDate: DateTime(2100),
    //   );
    //   if (picked != null && picked != DateTime.now()) {
    //     setState(() {
    //       monthController.text = picked.month.toString();
    //     });
    //   }
    // }

    TextEditingController yearController = TextEditingController();
    TextEditingController monthController = TextEditingController();

    Future<void> _selectYear(BuildContext context) async {
      showDialog(
        context: context,
        builder: (context) {
          int year = DateTime.now().year;
          int minYear = 2000;
          int maxYear = DateTime.now().year;
          return AlertDialog(
            title: Text('Select Year'),
            content: Container(
              height: 200,
              child: CupertinoPicker(
                itemExtent: 32,
                onSelectedItemChanged: (index) {
                  year = minYear + index;
                },
                children: List.generate(maxYear - minYear + 1, (index) {
                  return Center(
                    child: Text('${minYear + index}'),
                  );
                }),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    yearController.text = year.toString();
                  });
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }

    Future<void> _selectMonth(BuildContext context) async {
      showDialog(
        context: context,
        builder: (context) {
          int month = DateTime.now().month;
          return AlertDialog(
            title: Text('Select Month'),
            content: Container(
              height: 200,
              child: CupertinoPicker(
                itemExtent: 32,
                onSelectedItemChanged: (index) {
                  month = index + 1;
                },
                children: List.generate(12, (index) {
                  return Center(
                    child: Text('${index + 1}'),
                  );
                }),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    monthController.text = month.toString();
                  });
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: whiteColor,
      appBar: AppBar(
          title: "Sales Dashbaord".text.fontFamily(bold).white.make(),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          automaticallyImplyLeading: false),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        "INVOICES"
            .text
            .fontFamily(bold)
            .make()
            .box
            .padding(const EdgeInsets.symmetric(vertical: 5, horizontal: 24))
            .color(mainColor)
            .make(),
        const SizedBox(width: 10), // Add some gap between texts
        "2270"
            .text
            .fontFamily(bold)
            .color(mainColor)
            .make()
            .box
            .padding(const EdgeInsets.symmetric(vertical: 5, horizontal: 16))
            .make(),
      ],
    ).box.border(color: mainColor, width: 2).margin(const EdgeInsets.only(left: 10)).make(),
    IconButton(
      icon: const Icon(Icons.filter_list,color:mainColor),
      onPressed: () {
        // Open the drawer using the scaffold key
        _scaffoldKey.currentState!.openDrawer();
      },
    ),
  ],
),

            20.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectYear(context),
                    child: IgnorePointer(
                      child: TextField(
                        controller: yearController,
                        decoration: InputDecoration(
                            isDense: true,
                            labelText: 'Year',
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: mainColor)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: mainColor)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: mainColor)),
                            hintStyle: const TextStyle(color: lightGrey)),
                      )
                          .box
                          .padding(const EdgeInsets.symmetric(horizontal: 16))
                          .make(),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectMonth(context),
                    child: IgnorePointer(
                      child: TextField(
                        controller: monthController,
                        decoration: InputDecoration(
                            isDense: true,
                            labelText: 'Month',
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: mainColor)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: mainColor)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: mainColor)),
                            hintText: "",
                            hintStyle: const TextStyle(color: lightGrey)),
                      )
                          .box
                          .padding(const EdgeInsets.symmetric(horizontal: 16))
                          .make(),
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: mainColor, padding: const EdgeInsets.all(16)),
                    onPressed: () {
                      Get.off(() => const Home());
                    },
                    child:
                        "Search".text.color(whiteColor).fontFamily(bold).make())
                .box
                .width(context.screenWidth - 50)
                .roundedFull
                .padding(const EdgeInsets.symmetric(vertical: 16))
                .makeCentered(),
            10.heightBox,
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
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
                                      width: context.screenWidth,
                                      height: context.screenHeight,
                                      color: mainLightColor,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
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
                                                  "Region/Billed Quantity",
                                              legendTitle: "Region",
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
                                  width: context.screenWidth,
                                  height: 300,
                                  child: MyDoughnut(
                                    data: myData1,
                                    mainTitle: "Region/Billed Quantity",
                                    legendTitle: "Region",
                                  ),
                                ),
                                Positioned(
                                  top: 8.0,
                                  right: 8.0,
                                  child: Icon(Icons.fit_screen,
                                      color: mainColor),
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
                                      width: context.screenWidth,
                                      height: context.screenHeight,
                                      color: mainLightColor,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
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
                                              mainTitle:
                                                  "Top 10 Cities/Billed Quantity",
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
                                  width: context.screenWidth,
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
                                  child: Icon(Icons.fit_screen,
                                      color: mainColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    MyHorizontalBarChart(),
                    MyVerticalBarChart(),

                    // SalesTable(
                    //   columnNames: columnNames,
                    //   values: values,
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: mainColor,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.filter_list,
                          size: 50,
                          color: mainColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Filters',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SmoothDropdown(
                title: 'Plant',
                items: ['ALL', 'Plant 1', 'Plant 2', 'Plant 3', 'Plant 4'],
              ),
              SmoothDropdown(
                title: 'Sold To Party',
                items: ['Mutiple', 'Single', 'etc'],
              ),
              SmoothDropdown(
                title: 'Group',
                items: ['ALL', 'Group 1', 'Group 2', 'Group 3', 'Group 4'],
              ),
              SmoothDropdown(
                title: 'Sub Group',
                items: [
                  'ALL',
                  'Sub Group 1',
                  'Sub Group 2',
                  'Sub Group 3',
                  'Sub Group 4'
                ],
              ),
              SmoothDropdown(
                title: 'Category',
                items: [
                  'ALL',
                  'category 1',
                  'category 2',
                  'category 3',
                  'category 4'
                ],
              ),

              // Row(
              //   children: [
              //     Expanded(
              //       child: Align(
              //         alignment: Alignment.centerLeft,
              //         child: Text(
              //           'Category: ',
              //           style: TextStyle(fontSize: 16, color: Colors.black),
              //         ),
              //       ),
              //     ),
              //     Expanded(
              //       child: DropdownButtonFormField<String>(
              //         value: selectedDropdown1,
              //         onChanged: (String? value) {
              //           // setState(() {
              //           //   selectedDropdown1 = value;
              //           // });
              //         },
              //         items: cat.map((String value) {
              //           return DropdownMenuItem<String>(
              //             value: value,
              //             child: Text(value),
              //           );
              //         }).toList(),
              //         decoration: InputDecoration(
              //           labelText: '',
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: Align(
              //         alignment: Alignment.centerLeft,
              //         child: Text(
              //           'Sub-Category: ',
              //           style: TextStyle(fontSize: 16, color: Colors.black),
              //         ),
              //       ),
              //     ),
              //     Expanded(
              //       child: DropdownButtonFormField<String>(
              //         value: selectedDropdown1,
              //         onChanged: (String? value) {
              //           // setState(() {
              //           //   selectedDropdown1 = value;
              //           // });
              //         },
              //         items: subCat.map((String value) {
              //           return DropdownMenuItem<String>(
              //             value: value,
              //             child: Text(value),
              //           );
              //         }).toList(),
              //         decoration: InputDecoration(
              //           labelText: '',
              //         ),
              //       ),
              //     ),
              //   ],
              // ),

              10.heightBox,
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                spacing: 2.0,
                runSpacing: 2.0,
                children: [
                  Container(
                    width: double.infinity,
                    color: mainColor,
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                      child: Text(
                        'Material Type',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  CustomCheckBoxBtn(title: 'LAMINATION'),
                  CustomCheckBoxBtn(title: 'PLYWOOD'),
                  CustomCheckBoxBtn(title: 'CHEMICAL'),
                  CustomCheckBoxBtn(title: 'MTW'),
                  CustomCheckBoxBtn(title: 'VENEERED PANEL'),
                  CustomCheckBoxBtn(title: 'DOOR SKIN'),
                  CustomCheckBoxBtn(title: 'EDGE BANDING'),
                  CustomCheckBoxBtn(title: 'SOFTWOOD LUMBER'),
                ],
              ),
              10.heightBox,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double
                        .infinity, // Set the width to fill the available space
                    color: mainColor,
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                      child: Text(
                        'Division',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors
                              .white, // Set text color to contrast with background
                        ),
                      ),
                    ),
                  ),
                  CustomRadioBoxBtn(
                    options: ['Select All', 'Wood'],
                    selectFirstOption: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SalesScreenR extends StatefulWidget {
  const SalesScreenR({super.key});

  @override
  State<SalesScreenR> createState() => _SalesScreenRState();
}

class _SalesScreenRState extends State<SalesScreenR> {
  final List<Chart> dataShow = [
    Chart('1', 5),
    Chart('2', 25),
    Chart('4', 100),
    Chart('5', 75),
    Chart('7', 90),
    Chart('11', 20),
    Chart('14', 50),
    Chart('17', 70),
    Chart('20', 40),
  ];

  final List<Chart> dataShow2 = [
    Chart('M-1', 15),
    Chart('M-2', 125),
    Chart('M-3', 110),
    Chart('M-4', 75),
    Chart('M-5', 90),
    Chart('M-6', 20),
    Chart('M-7', 50),
    Chart('M-8', 70),
    Chart('M-9', 10),
  ];

  TextEditingController monthController = TextEditingController();
  TextEditingController yearController = TextEditingController();

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
    return bgWidget(
      child: Scaffold(
        appBar: AppBar(
          title: "Sales".text.fontFamily(bold).white.make(),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                child: Column(
                  children: [
                    CustomTextField(title: "Month", hint: "10"),
                    CustomTextField(title: "Year", hint: "2023"),
                    5.heightBox,
                    ourButton(
                        color: Colors.blue.shade300,
                        textColor: whiteColor,
                        title: "Search",
                        onPress: () {
                          Get.off(() => const Home());
                        }).box.width(context.screenWidth - 50).make(),
                  ],
                )
                    .box
                    .white
                    .rounded
                    .padding(const EdgeInsets.all(16))
                    .width(context.screenWidth - 70)
                    .shadowSm
                    .make(),
              ),
              10.heightBox,
              BarChart(data: dataShow, title: "Sales Per Day"),
              10.heightBox,
              LineChart(data: dataShow, title: "Sales Per Day"),
              10.heightBox,
              SalesTable(
                columnNames: columnNames,
                values: values,
              ),
              10.heightBox,
              BarChart(data: dataShow2, title: "Material Per Rate"),
              Container(
                width: 150,
                height: 150,
                child: "Go".text.makeCentered(),
              ).onTap(() {
                Get.to(() => const SalesScreen());
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class Chart {
  final String day;
  final int sales;

  Chart(this.day, this.sales);

  // Add a getter to convert the day property to an integer
  int get numericDay => int.parse(day); //bounding line chart for int only
}

class BarChart extends StatelessWidget {
  final List<Chart> data;
  String? title;

  BarChart({required this.data, required this.title});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<Chart, String>> series = [
      charts.Series(
        id: 'Sales',
        data: data,
        domainFn: (Chart sales, _) => sales.day,
        measureFn: (Chart sales, _) => sales.sales,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      )
    ];

    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                title!,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              Expanded(
                child: charts.BarChart(
                  series,
                  animate: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LineChart extends StatelessWidget {
  final List<Chart> data;
  String? title;

  LineChart({required this.data, required this.title});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<Chart, int>> series = [
      charts.Series(
        id: 'Sales',
        data: data,
        domainFn: (Chart sales, _) => sales.numericDay,
        measureFn: (Chart sales, _) => sales.sales,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      )
    ];

    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                title!,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              Expanded(
                child: charts.LineChart(
                  series,
                  animate: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SalesTable extends StatefulWidget {
  final List<String> columnNames;
  final List<Map<String, dynamic>> values;
  final bool showActionsColumn;

  const SalesTable({
    Key? key,
    required this.columnNames,
    required this.values,
    this.showActionsColumn = false,
  }) : super(key: key);

  @override
  _SalesTableState createState() => _SalesTableState();
}

class _SalesTableState extends State<SalesTable> {
  int _rowsPerPage = 5;
  int _currentSortColumn = 0;
  bool _sortAscending = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: SingleChildScrollView(
        child: PaginatedDataTable(
          header: Text('Sales Data'),
          columns: [
            ...widget.columnNames
                .asMap()
                .map((index, name) => MapEntry(
                      index,
                      DataColumn(
                        label: Text(name),
                        onSort: (columnIndex, ascending) {
                          setState(() {
                            _currentSortColumn = columnIndex;
                            _sortAscending = ascending;
                            widget.values.sort((a, b) =>
                                a[name].compareTo(b[name]) *
                                (ascending ? 1 : -1));
                          });
                        },
                      ),
                    ))
                .values
                .toList(),
            if (widget.showActionsColumn)
              DataColumn(
                label: Text('Actions'),
              ),
          ],
          sortColumnIndex: _currentSortColumn,
          sortAscending: _sortAscending,
          source: SalesDataSource(widget.values,
              showActionsColumn: widget.showActionsColumn),
          rowsPerPage: _rowsPerPage,
          availableRowsPerPage: [5, 10, 20],
          onRowsPerPageChanged: (value) {
            setState(() {
              _rowsPerPage = value!;
            });
          },
          showCheckboxColumn: false,
        ),
      ),
    );
  }
}

class SalesDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  final bool showActionsColumn;

  SalesDataSource(this.data, {this.showActionsColumn = false});

  @override
  DataRow? getRow(int index) {
    final item = data[index];
    return DataRow(
      cells: [
        ...item.values.map((e) => DataCell(Text(e.toString()))).toList(),
        if (showActionsColumn)
          DataCell(
            Row(
              children: [
                _CustomCheckbox(
                  borderColor: Colors.green,
                  checkedIcon: Icons.check,
                  checkedColor: Colors.green,
                ),
                SizedBox(width: 8), // Add some spacing between the checkboxes
                _CustomCheckbox(
                  borderColor: Colors.red,
                  checkedIcon: Icons.close,
                  checkedColor: Colors.red,
                ),
              ],
            ),
          ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}

class _CustomCheckbox extends StatefulWidget {
  final Color borderColor;
  final IconData checkedIcon;
  final Color checkedColor;

  _CustomCheckbox({
    required this.borderColor,
    required this.checkedIcon,
    required this.checkedColor,
  });

  @override
  State<_CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<_CustomCheckbox> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isChecked = !_isChecked;
        });
      },
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          border: Border.all(color: widget.borderColor),
          borderRadius: BorderRadius.circular(4),
        ),
        child: _isChecked
            ? Icon(
                widget.checkedIcon,
                color: widget.checkedColor,
              )
            : null,
      ),
    );
  }
}
