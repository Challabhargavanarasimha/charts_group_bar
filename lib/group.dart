import 'package:charts_painter/chart.dart';
import 'package:flutter/material.dart';
import 'grouped/old_custom_bar_chart.dart';

class GroupedBarChart<T> extends StatefulWidget {
  final List<List<T>> groupedData;
  final DataToValue<T> dataToValue;
  final DataToAxis<T> dataToAxis;
  final double height;
  final List<DecorationPainter> backgroundDecorations;
  final List<DecorationPainter> foregroundDecorations;
  final ChartBehaviour chartBehaviour;
  final ItemOptions itemOptions;

  GroupedBarChart({
    required this.groupedData,
    required this.dataToValue,
    required this.dataToAxis,
    this.height = 240.0,
    this.backgroundDecorations = const [],
    this.foregroundDecorations = const [],
    this.chartBehaviour = const ChartBehaviour(),
    this.itemOptions = const BarItemOptions(),
    Key? key,
  }) : super(key: key);

  @override
  State<GroupedBarChart<T>> createState() => _GroupedBarChartState<T>();
}

class _GroupedBarChartState<T> extends State<GroupedBarChart<T>> {
  double highestValue = 0.0;
  double axisStep = 0.0;

  @override
  void initState() {
    super.initState();
    calculateHighestValue();
    axisStep = calculateAxisStep(highestValue, widget.height);
  }

  void calculateHighestValue() {
    for (var dataSet in widget.groupedData) {
      for (var item in dataSet) {
        double value = widget.dataToValue(item);
        if (value > highestValue) {
          highestValue = value;
        }
      }
    }
  }

  double calculateAxisStep(double highestValue, double graphHeight) {
    int divisions = 8;
    double step = highestValue / divisions;
    return step > 0 ? step : 1;
  }

  @override
  Widget build(BuildContext context) {
    final _data = ChartData(
      widget.groupedData.map((dataSet) {
        return dataSet.map((item) => BarValue<T>(widget.dataToValue(item))).toList();
      }).toList(),
      axisMax: highestValue,
      valueAxisMaxOver: 1,
      dataStrategy: const DefaultDataStrategy(stackMultipleValues: false),
    );

    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 0),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [Colors.transparent, Colors.transparent],
              stops: [0.1, 0.5],
            ),
          ),
          width: 40.0,
          height: widget.height,
          child: DecorationsRenderer(
            [
              HorizontalAxisDecoration(
                legendPosition: HorizontalLegendPosition.start,
                asFixedDecoration: true,
                lineWidth: 10.0,
                showTopValue: true,
                axisStep: axisStep,
                showValues: true,
                showLineForValue: (_) => false,
                showLines: false,
                endWithChart: false,
                axisValue: (value) => '$value',
                legendFontStyle: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.blueAccent
                      : Colors.blueAccent,
                  fontWeight: FontWeight.w800,
                ),
                valuesAlign: TextAlign.end,
                lineColor: Colors.transparent,
                valuesPadding: const EdgeInsets.only(right: 8.0, top: 12, bottom: 0),
              ),
            ],
            ChartState<T>(
              data: _data,
              itemOptions: widget.itemOptions,
              behaviour: const ChartBehaviour(scrollSettings: ScrollSettings()),
              foregroundDecorations: widget.foregroundDecorations,
              backgroundDecorations: [...widget.backgroundDecorations],
            ),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: AnimatedChart<T>(
                  duration: const Duration(milliseconds: 450),
                  width: MediaQuery.of(context).size.width - 24,
                  height: MediaQuery.of(context).size.height * 0.4,
                  state: ChartState<T>(
                    data: _data,
                    itemOptions: widget.itemOptions,
                    behaviour: const ChartBehaviour(scrollSettings: ScrollSettings()),
                    foregroundDecorations: widget.foregroundDecorations,
                    backgroundDecorations: [...widget.backgroundDecorations],
                  ),
                ),
              ),
              Container(
                height: widget.height - 48,
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
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
