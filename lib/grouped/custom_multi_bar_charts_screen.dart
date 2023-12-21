import 'dart:math';

import 'package:charts_painter/chart.dart';
import 'package:flutter/material.dart';

import '../group.dart';
import '../model/activity_summary_model.dart';
import 'grouped_charts.dart';
import 'old_custom_bar_chart.dart';

class CustomMultiBarChartScreen extends StatefulWidget {
  final double? height;
  final DailyActivitySummerModel? summaryData;

  CustomMultiBarChartScreen({Key? key, this.summaryData, this.height})
      : super(key: key);

  @override
  _CustomMultiBarChartScreenState createState() =>
      _CustomMultiBarChartScreenState();
}

class _CustomMultiBarChartScreenState extends State<CustomMultiBarChartScreen> {
  Map<int, List<BarValue<void>>> _values = <int, List<BarValue<void>>>{};
  double targetMax = 0;
  double targetMin = 0;
  int minItems = 6;
  List? xLables = [];
  double highestValue = 0.0;
  double axisStep = 0.0;

  @override
  void initState() {
    super.initState();
    xLables!.clear();
    getHighestValue(widget.summaryData!.data!);
    axisStep = calculateAxisStep(highestValue, widget.height!);
    xLables = xAxisValues(widget.summaryData!.data!);
    // _updateValues();
  }

  double getHighestValue(List<DailyActivitySummerData> responseData) {
    for (var entry in responseData) {
      List<SummaryData>? summaryData = entry.summaryData;
      for (var summary in summaryData!) {
        double activityValue = double.parse(summary.activityValue.toString());
        if (activityValue > highestValue) {
          highestValue = activityValue;
        }
      }
    }

    return highestValue;
  }

  List<String>? xAxisValues(List<DailyActivitySummerData?> values) {
    List<String>? xLabels = values.map((e) => e!.date).cast<String>().toList();
    return xLabels;
  }

  double calculateAxisStep(double highestValue, double graphHeight) {
    // Customize the number of divisions on the Y-axis
    int divisions = 8; // Adjust this value based on your requirement

    // Calculate the step to divide the range into equal parts
    double step = highestValue / divisions;

    // Ensure that the step is at least 1 to avoid division by zero
    return step > 0 ? step : 1;
  }

  static List<List<BarValue<void>>> _getMap() {
    return [
      [BarValue<void>(100), BarValue<void>(200)],
      [
        BarValue<void>(150),
        BarValue<void>(250),
        // BarValue<void>(150),
      ],
      [BarValue<void>(100), BarValue<void>(200)],
      [
        BarValue<void>(150),
        BarValue<void>(250),
        // BarValue<void>(150),
        // BarValue<void>(250),
      ],
      [BarValue<void>(100), BarValue<void>(200)],
      [
        BarValue<void>(150),
        BarValue<void>(250),
        BarValue<void>(150),
        BarValue<void>(250),
        BarValue<void>(150),
        BarValue<void>(250),
        BarValue<void>(150),
        BarValue<void>(250),
        BarValue<void>(150),
        BarValue<void>(250),
        BarValue<void>(150),
        BarValue<void>(250)
      ],
    ];
  }

  // List<List<BarValue<void>>> _getMap() {
  //   List<List<BarValue<void>>> result = [];
  //   for (int seriesIndex = 0;
  //   seriesIndex < widget.summaryData!.data!.length;
  //   seriesIndex++) {
  //     List<BarValue<void>>? seriesValues =
  //     widget.summaryData!.data![seriesIndex].summaryData!.map((data) {
  //       return BarValue<void>(
  //         double.parse(data.activityValue.toString()),
  //         // y: double.parse(data.activityValue.toString()),
  //         // x: data.activityName,
  //       );
  //     }).toList();
  //     result.add(seriesValues);
  //   }
  //
  //   debugPrint('result -----------------------------------------$result');
  //   return result;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Multi bar chart',
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        child: Container(
            padding: const EdgeInsets.all(12.0),
            child:
            /*GroupedBarChart(
              groupedData: _getMap(),
              dataToValue: (Object? item) {
                return 20;
              },
              dataToAxis: (int index) {
                if (index >= 0 && index < xLables!.length) {
                  return xLables![index] ?? '';
                }
                return '';
              },
              chartBehaviour:
              const ChartBehaviour(scrollSettings: ScrollSettings()),
              height: MediaQuery.of(context).size.height * 0.4,
              itemOptions: BarItemOptions(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                minBarWidth: 250.0,
                multiValuePadding: const EdgeInsets.symmetric(horizontal: 12.0),
                barItemBuilder: (data) {
                  return const BarItem(
                    color: Colors.blue,
                    radius: BorderRadius.vertical(
                      top: Radius.circular(24.0),
                    ),
                  );
                },
              ),
              // summaryData: widget.summaryData,

              backgroundDecorations: [
                VerticalAxisDecoration(
                    lineWidth: 2,
                    showLines: false,
                    valuesPadding: const EdgeInsets.only(top: 10),
                    showValues: true,
                    legendFontStyle: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.blueAccent,
                        fontWeight: FontWeight.w800),
                    valuesAlign: TextAlign.center,
                    valueFromIndex: (value) {
                      int index = value.toInt();
                      // debugPrint('index1 --------------------------- $index');

                      // var xLables = xAxisValues(widget.values);
                      if (index >= 0 && index < xLables!.length) {
                        return xLables![index] ?? '';
                      }
                      return '';
                    }),
                GridDecoration(
                  verticalValuesPadding: EdgeInsets.only(top: 10),
                  verticalAxisStep: 1,
                  // Adjust this value to control the spacing between vertical grid lines
                  horizontalAxisStep: axisStep,
                  // Adjust this value to control the spacing between horizontal grid lines
                  textStyle: Theme.of(context).textTheme.caption,
                  gridColor: Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withOpacity(1),
                ),
                // targetArea,
              ],
              foregroundDecorations: [
                ValueDecoration(
                  alignment: Alignment.topCenter,
                  textStyle: Theme.of(context).textTheme.button!.copyWith(
                      color: Colors.blueAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.w800),
                ),
                BorderDecoration(
                  sidesWidth: const Border(
                    top: BorderSide.none,
                    right: BorderSide.none,
                    left: BorderSide.none,
                    bottom: BorderSide.none,
                  ),
                  endWithChart: true,
                ),
              ],
            )*/

            OldCustomBarChart.map(
              _getMap(),
              // stack: _stackItems,
              chartBehaviour:
                  const ChartBehaviour(scrollSettings: ScrollSettings()),
              height: MediaQuery.of(context).size.height * 0.4,
              itemOptions: BarItemOptions(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                minBarWidth: 80.0,
                multiValuePadding: const EdgeInsets.symmetric(horizontal: 12.0),
                barItemBuilder: (data) {
                  return const BarItem(
                    color: Colors.blue,
                    radius: BorderRadius.vertical(
                      top: Radius.circular(24.0),
                    ),
                  );
                },
              ),
              summaryData: widget.summaryData,

              backgroundDecorations: [
                VerticalAxisDecoration(
                    lineWidth: 2,
                    showLines: false,
                    valuesPadding: const EdgeInsets.only(top: 10),
                    showValues: true,
                    legendFontStyle: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.blueAccent,
                        fontWeight: FontWeight.w800),
                    valuesAlign: TextAlign.center,
                    valueFromIndex: (value) {
                      int index = value.toInt();
                      // debugPrint('index1 --------------------------- $index');

                      // var xLables = xAxisValues(widget.values);
                      if (index >= 0 && index < xLables!.length) {
                        return xLables![index] ?? '';
                      }
                      return '';
                    }),
                GridDecoration(
                  verticalValuesPadding: EdgeInsets.only(top: 10),
                  verticalAxisStep: 1,
                  // Adjust this value to control the spacing between vertical grid lines
                  horizontalAxisStep: axisStep,
                  // Adjust this value to control the spacing between horizontal grid lines
                  textStyle: Theme.of(context).textTheme.caption,
                  gridColor: Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withOpacity(1),
                ),
                // targetArea,
              ],
              foregroundDecorations: [
                ValueDecoration(
                  alignment: Alignment.topCenter,
                  textStyle: Theme.of(context).textTheme.button!.copyWith(
                      color: Colors.blueAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.w800),
                ),
                BorderDecoration(
                  sidesWidth: const Border(
                    top: BorderSide.none,
                    right: BorderSide.none,
                    left: BorderSide.none,
                    bottom: BorderSide.none,
                  ),
                  endWithChart: true,
                ),
              ],
            ),
            ),
      ),
    );
  }
}
