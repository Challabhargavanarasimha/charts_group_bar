import 'package:charts_painter/chart.dart';
import 'package:flutter/material.dart';

import '../model/activity_summary_model.dart';

typedef DataToValue<T> = double Function(T item);
// typedef DataToAxis<T> = String Function(int item);

/// Short-hand to easier create several bar charts
class CustomBarChart extends StatefulWidget {
  // CustomBarChart({
  //   required List<T> data,
  //   required DataToValue<T> dataToValue,
  //   this.height = 240.0,
  //   this.backgroundDecorations = const [],
  //   this.foregroundDecorations = const [],
  //   this.chartBehaviour = const ChartBehaviour(),
  //   this.itemOptions = const BarItemOptions(),
  //   this.stack = false,
  //   Key? key,
  //   this.summaryData,
  // })  : _mappedValues = [data.map((e) => BarValue<T>(dataToValue(e))).toList()],
  //       super(key: key);

  const CustomBarChart({
    Key? key, this.summaryData, this.height,
  }) : super(key: key);

   final DailyActivitySummerModel? summaryData;
   // final List? data;
   final double? height;
  // final double height;
  // final bool stack;
  // final ItemOptions itemOptions;
  // final ChartBehaviour chartBehaviour;
  // final List<DecorationPainter> backgroundDecorations;
  // final List<DecorationPainter> foregroundDecorations;

  @override
  State<CustomBarChart> createState() => _CustomBarChartState();
}

class _CustomBarChartState extends State<CustomBarChart> {
   List<List<BarValue>>? _mappedValues;
  final _controller = ScrollController();
  double highestValue = 0.0;
  double axissStep = 0.0;
  late ChartData _data;

  List? xLables = [];
   // typedef DataToAxis<T> = String Function(int item);
   List<double>? dataToValue(double item) {
     // Your logic to convert item to double
     // For example, assuming T is int
     return [item.toDouble()];
   }
  List<List<BarValue<double>>> _getMap() {
    List<List<BarValue<double>>> result = [];
    for (int seriesIndex = 0;
    seriesIndex < widget.summaryData!.data!.length;
    seriesIndex++) {
      List<BarValue<double>>? seriesValues =
      widget.summaryData!.data![seriesIndex].summaryData!.map((data) {
        return BarValue<double>(
          double.parse(data.activityValue.toString()),
          // y: double.parse(data.activityValue.toString()),
          // x: data.activityName,
        );
      }).toList();
      result.add(seriesValues);
    }

    debugPrint('result -----------------------------------------$result');
    return result;
  }

  List<String>? xAxisValues(List<DailyActivitySummerData?> values) {
    List<String>? xLabels = values.map((e) => e!.date).cast<String>().toList();
    return xLabels;
  }

  @override
  void initState() {
    // TODO: implement initState
    getHighestValue(widget.summaryData!.data!);
    axissStep = calculateAxisStep(highestValue, widget.height!);
    List<List<BarValue<double>>> data = _getMap();

    xLables = xAxisValues(widget.summaryData!.data!);
    // _mappedValues = [data.expand((e) => e.map((barValue) => BarValue(barValue.max!))).toList()];
    _mappedValues = [data.map((e) => BarValue(200)).toList()];

    _data = ChartData(
      _mappedValues!,
      axisMax: highestValue,
      valueAxisMaxOver: 1,

    );
    super.initState();
  }

  ChartState chartsState() {
    // List<String?> xLabels = values.map((e) => e.date).toList();
    return ChartState(
      data: _data,
      itemOptions: BarItemOptions(
        multiValuePadding: const EdgeInsets.symmetric(vertical: 200.0),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        minBarWidth: 20.0,
        barItemBuilder: (data) {
          return BarItem(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.blueAccent
                : Colors.blueAccent,
            radius: const BorderRadius.vertical(
              top: Radius.circular(24.0),
            ),
          );
        },
      ),
      behaviour: ChartBehaviour(
        scrollSettings: const ScrollSettings.none(),
        onItemClicked: (item) {
          print('Clciked');
        },
        onItemHoverEnter: (_) {
          print('Hover Enter');
        },
        onItemHoverExit: (_) {
          print('Hover Enter');
        },
      ),
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
          horizontalAxisStep: axissStep,
          // Adjust this value to control the spacing between horizontal grid lines
          textStyle: Theme.of(context).textTheme.caption,
          gridColor:
              Theme.of(context).colorScheme.primaryContainer.withOpacity(1),
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
    );
  }

  double calculateAxisStep(double highestValue, double graphHeight) {
    // Customize the number of divisions on the Y-axis
    int divisions = 8; // Adjust this value based on your requirement

    // Calculate the step to divide the range into equal parts
    double step = highestValue / divisions;

    // Ensure that the step is at least 1 to avoid division by zero
    return step > 0 ? step : 1;
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

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height*0.4;

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: const EdgeInsets.only(top: 50),
        height: height,
        child: Row(
          children: [
            AnimatedContainer(
// padding: EdgeInsets.only(top: 20,bottom: 0),
              duration: const Duration(milliseconds: 0),
              decoration: const BoxDecoration(
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
              height:height,
              child: DecorationsRenderer(
                [
                  HorizontalAxisDecoration(
                    legendPosition: HorizontalLegendPosition.start,
                    // valuesPadding: EdgeInsets.zero,
                    asFixedDecoration: true,
                    lineWidth: 10.0,
                    showTopValue: true,
                    axisStep: axissStep,
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
                        const EdgeInsets.only(right: 8.0, top: 12, bottom: 0),
                    // dashArray: yLabelsDoubles
                  )
                ],
                chartsState()
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    // physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    controller: _controller,
                    child: AnimatedChart(
                      duration: const Duration(milliseconds: 100),
                      width: MediaQuery.of(context).size.width - 24,
                      height: MediaQuery.of(context).size.height * 0.4,
                      state: chartsState(),
                    ),
                  ),
                  Container(
                    height: height-24,
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
                        width: MediaQuery.of(context).size.width - 30.0,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.blueAccent
                            : Colors.blueAccent,
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



}
