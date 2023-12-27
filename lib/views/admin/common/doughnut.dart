import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyDoughnut extends StatelessWidget {
  final List<Data> data;
  final String legendTitle;
  final String mainTitle;

  const MyDoughnut({
    Key? key,
    required this.data,
    required this.legendTitle,
    required this.mainTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      title: ChartTitle(text: mainTitle),
      series: <CircularSeries>[
        DoughnutSeries<Data, String>(
          dataSource: data,
          xValueMapper: (Data data, _) => data.col_1,
          yValueMapper: (Data data, _) => data.col_2,
          dataLabelSettings: DataLabelSettings(isVisible: true),
          enableTooltip: true,
        ),
      ],
      legend: Legend(
        isVisible: true,
        overflowMode: LegendItemOverflowMode.wrap,
        position: LegendPosition.bottom,
        title: LegendTitle(
          text: legendTitle,
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        height: '100',
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }
}

class Data {
  Data(this.col_1, this.col_2);
  String col_1;
  dynamic col_2;
}
