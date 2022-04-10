import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LiveSPLineChart extends StatelessWidget {
  LiveSPLineChart(
      {required this.cmdId,
      required this.title,
      this.color1 = Colors.red,
      this.color2 = Colors.blue,
      this.xCount = 7});

  List<_ChartData> chartData = [];
  List<_ChartData> chartData2 = [];
  late int count;
  ChartSeriesController? _chartSeriesController;
  ChartSeriesController? _chartSeriesController2;
  int cmdId;
  int xCount;
  Color color1 = Colors.red;
  Color color2 = Colors.blue;
  String title;
  late SfCartesianChart chart;

  @override
  Widget build(BuildContext context) {
    setVals();
    return _buildLiveLineChart(MediaQuery.of(context).size);
  }

  void setVals() {
    count = xCount;
  }

  Widget _buildLiveLineChart(Size size) {
    chart = createChart();
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Container(
        padding: const EdgeInsets.all(9),
        color: Colors.blueGrey[900],
        height: (size.width / 2) / 1.5,
        child: Column(children: [
          Container(
            alignment: Alignment.topCenter,
            child: Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            child: chart,
          ),
        ]),
      ),
    );
  }

  SfCartesianChart createChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
          dateFormat: DateFormat.ms(),
          labelStyle: TextStyle(fontSize: 11),
          majorTickLines: const MajorTickLines(width: 0),
          axisLine: const AxisLine(width: 0),
          majorGridLines: const MajorGridLines(width: 0),
          isVisible: true),
      primaryYAxis: NumericAxis(
          labelStyle: TextStyle(fontSize: 11),
          minimum: -8,
          axisLine: const AxisLine(width: 0),
          majorGridLines: const MajorGridLines(width: 0),
          majorTickLines: const MajorTickLines(width: 0),
          isVisible: true),
      series: <SplineSeries<_ChartData, DateTime>>[
        SplineSeries<_ChartData, DateTime>(
          onRendererCreated: (ChartSeriesController controller) {
            _chartSeriesController = controller;
          },
          dataSource: chartData,
          color: color1,
          xValueMapper: (_ChartData data, _) => data.x,
          yValueMapper: (_ChartData data, _) => data.y,
        ),
        SplineSeries<_ChartData, DateTime>(
          onRendererCreated: (ChartSeriesController controller) {
            _chartSeriesController2 = controller;
          },
          dataSource: chartData2,
          color: color2,
          xValueMapper: (_ChartData data, _) => data.x,
          yValueMapper: (_ChartData data, _) => data.y,
        ),
      ],
    );
  }

  void addLine(int x1, int x2, DateTime ts) {
    chartData.add(_ChartData(ts, x1));
    chartData2.add(_ChartData(ts, x2));
    if (chartData.length == xCount) {
      chartData.removeAt(0);
      chartData2.removeAt(0);
      _chartSeriesController?.updateDataSource(
        addedDataIndexes: <int>[chartData.length - 1],
        removedDataIndexes: <int>[0],
      );
      _chartSeriesController2?.updateDataSource(
        addedDataIndexes: <int>[chartData2.length - 1],
        removedDataIndexes: <int>[0],
      );
    } else {
      _chartSeriesController?.updateDataSource(
        addedDataIndexes: <int>[chartData.length - 1],
      );
      _chartSeriesController2?.updateDataSource(
        addedDataIndexes: <int>[chartData2.length - 1],
      );
    }
    count++;
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final DateTime x;
  final int y;
}
