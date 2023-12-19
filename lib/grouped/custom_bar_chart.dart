import 'package:charts_painter/chart.dart';
import 'package:flutter/material.dart';

import '../model/activity_summary_model.dart';

typedef DataToValue<T> = double Function(T item);
typedef DataToAxis<T> = String Function(int item);

/// Short-hand to easier create several bar charts
class CustomBarChart<T> extends StatefulWidget {
  CustomBarChart({
    required List<T> data,
    required DataToValue<T> dataToValue,
    this.height = 240.0,
    this.backgroundDecorations = const [],
    this.foregroundDecorations = const [],
    this.chartBehaviour = const ChartBehaviour(),
    this.itemOptions = const BarItemOptions(),
    this.stack = false,
    Key? key, this.summaryData,
  })  : _mappedValues = [data.map((e) => BarValue<T>(dataToValue(e))).toList()],
        super(key: key);

  const CustomBarChart.map(
    this._mappedValues, {
    this.height = 240.0,
    this.backgroundDecorations = const [],
    this.foregroundDecorations = const [],
    this.chartBehaviour = const ChartBehaviour(),
    this.itemOptions = const BarItemOptions(),
    this.stack = false,
    Key? key, this.summaryData,
  }) : super(key: key);
  final DailyActivitySummerModel? summaryData;
  final List<List<BarValue<T>>> _mappedValues;
  final double height;
  final bool stack;
  final ItemOptions itemOptions;
  final ChartBehaviour chartBehaviour;
  final List<DecorationPainter> backgroundDecorations;
  final List<DecorationPainter> foregroundDecorations;

  @override
  State<CustomBarChart<T>> createState() => _CustomBarChartState<T>();
}

class _CustomBarChartState<T> extends State<CustomBarChart<T>> {
  final _controller = ScrollController();
  double max = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    getHighestValue(widget.summaryData!.data!.cast<Map<String, dynamic>>());
    debugPrint(
        'widget._mappedValues ----------------- ${widget._mappedValues}');
    super.initState();
  }

  double findHighestValue(List<Map<String, dynamic>> dataList) {
    for (var entry in dataList) {
      if (entry.containsKey('summaryData')) {
        List<Map<String, dynamic>>? summaryDataList =
            entry['summaryData'] as List<Map<String, dynamic>>;
        // List.castFrom(entry['summaryData']);

        for (var summaryData in summaryDataList) {
          if (summaryData.containsKey('activityValue')) {
            double activityValue =
                double.parse(summaryData['activityValue'].toString());

            if (activityValue > max) {
              max = activityValue;
            }
          }
        }
      }
    }
    debugPrint('max ------------------------------------ $max');
    return max;
  }
  double getHighestValue(List<Map<String, dynamic>> responseData) {
    double highestValue = 0.0;

    for (var entry in responseData) {
      List<Map<String, dynamic>> summaryData = entry['summaryData'] as  List<Map<String, dynamic>>;
      for (var summary in summaryData) {
        double activityValue = double.parse(summary['activityValue'].toString());
        if (activityValue > highestValue) {
          highestValue = activityValue;
        }
      }
    }

    return highestValue;
  }
  @override
  Widget build(BuildContext context) {
    final _data = ChartData<T>(
      widget._mappedValues,
      axisMax: max,
      valueAxisMaxOver: 1,
      dataStrategy: widget.stack
          ? StackDataStrategy()
          : DefaultDataStrategy(stackMultipleValues: false),
    );

    return Row(
      children: [
        Container(
          child: AnimatedContainer(
// padding: EdgeInsets.only(top: 20,bottom: 0),
            duration: Duration(milliseconds: 0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                  ],
                  stops: [
                    0.1,
                    0.5
                  ]),
            ),
            width: 40.0,
            height: widget.height,
            child: DecorationsRenderer(
              [
                HorizontalAxisDecoration(
                  legendPosition: HorizontalLegendPosition.start,
                  // valuesPadding: EdgeInsets.zero,
                  asFixedDecoration: true,
                  lineWidth: 10.0,
                  showTopValue: true,
                  axisStep: 80,
                  showValues: true,
                  showLineForValue: (value) {
                    return false;
                  },
                  showLines: false,
                  endWithChart: false,
                  axisValue: (value) {
                    // if (value > 0) {
                    //   // If it's the first label, display "0", otherwise use the actual label
                    //   return '$value' ?? '';
                    // }
                    // return '0';
                    debugPrint('values ----------------------$value');
                    return '$value';
                  },
                  legendFontStyle: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.blueAccent
                          : Colors.blueAccent,
                      fontWeight: FontWeight.w800),
                  valuesAlign: TextAlign.end,
                  lineColor: Colors.transparent,
                  valuesPadding:
                      const EdgeInsets.only(right: 8.0, top: 21, bottom: 0),
                  // dashArray: yLabelsDoubles
                )
              ],
              ChartState<T>(
                data: _data,
                itemOptions: widget.itemOptions,
                behaviour: ChartBehaviour(scrollSettings: ScrollSettings()),
                foregroundDecorations: widget.foregroundDecorations,
                backgroundDecorations: [
                  ...widget.backgroundDecorations,
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              SingleChildScrollView(
                // physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                controller: _controller,
                child: Container(
                  // width: MediaQuery.of(context).size.width - 24.0,
                  child: AnimatedChart<T>(
                    duration: Duration(milliseconds: 450),
                    width: MediaQuery.of(context).size.width - 24,
                    height: MediaQuery.of(context).size.height * 0.4,
                    state: ChartState<T>(
                      data: _data,
                      itemOptions: widget.itemOptions,
                      behaviour:
                          ChartBehaviour(scrollSettings: ScrollSettings()),
                      foregroundDecorations: widget.foregroundDecorations,
                      backgroundDecorations: [
                        ...widget.backgroundDecorations,
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: widget.height - 5,
                width: 1.8,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.blueAccent
                    : Colors.blueAccent,
              ),
              Positioned(
                  left: 0,
                  bottom: 24,
                  child: Container(
                    height: 1.8,
                    width: MediaQuery.of(context).size.width - 24.0,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.blueAccent
                        : Colors.blueAccent,
                  ))
            ],
          ),
        ),
      ],
    );
  }
}
