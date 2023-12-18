import 'dart:math';

import 'package:charts_painter/chart.dart';
import 'package:example/grouped/summary_model.dart';
import 'package:example/widgets/chart_options.dart';
import 'package:example/widgets/toggle_item.dart';
import 'package:flutter/material.dart';

import '../widgets/bar_chart.dart';
import 'custom_bar_chart.dart';

class CustomMultiBarChartScreen extends StatefulWidget {
  final DailyActivitySummerModel? summaryData;

  CustomMultiBarChartScreen({Key? key, this.summaryData}) : super(key: key);

  @override
  _CustomMultiBarChartScreenState createState() =>
      _CustomMultiBarChartScreenState();
}

class _CustomMultiBarChartScreenState extends State<CustomMultiBarChartScreen> {
  Map<int, List<BarValue<void>>> _values = <int, List<BarValue<void>>>{};
  double targetMax = 0;
  double targetMin = 0;
  bool _showValues = true;
  int minItems = 6;
  bool _legendOnEnd = true;
  bool _legendOnBottom = true;
  bool _stackItems = false;

  @override
  void initState() {
    super.initState();
    _updateValues();
  }

  void _updateValues() {
    final Random _rand = Random();
    final double _difference = _rand.nextDouble() * 10;
    targetMax = 5 +
        ((_rand.nextDouble() * _difference * 0.75) - (_difference * 0.25))
            .roundToDouble();
    _values.addAll(
        Map<int, List<BarValue<void>>>.fromEntries(List.generate(3, (key) {
      return MapEntry(
          key,
          List.generate(minItems, (index) {
            return BarValue<void>(
                targetMax * 0.4 + _rand.nextDouble() * targetMax * 0.9);
          }));
    })));
    targetMin = targetMax - ((_rand.nextDouble() * 3) + (targetMax * 0.2));
  }

  void _addValues() {
    _values = Map.fromEntries(List.generate(3, (key) {
      return MapEntry(
          key,
          List.generate(minItems, (index) {
            if (_values[key]!.length > index) {
              return _values[key]![index];
            }

            return BarValue<void>(
                targetMax * 0.4 + Random().nextDouble() * targetMax * 0.9);
          }));
    }));
  }

  List<List<BarValue<void>>> _getMap() {
    return [
      _values[0]!
          .asMap()
          .map<int, BarValue<void>>((index, e) {
            return MapEntry(index, BarValue<void>(e.max ?? 0.0));
          })
          .values
          .toList(),
      _values[1]!
          .asMap()
          .map<int, BarValue<void>>((index, e) {
            return MapEntry(index, BarValue<void>(e.max ?? 0.0));
          })
          .values
          .toList(),
      _values[2]!.toList()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Multi bar chart',
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: Container(
                padding: const EdgeInsets.all(12.0),
                child: CustomBarChart.map(
                  _getMap(),
                  stack: _stackItems,
                  chartBehaviour:
                      ChartBehaviour(scrollSettings: ScrollSettings()),
                  height: MediaQuery.of(context).size.height * 0.4,
                  itemOptions: BarItemOptions(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    minBarWidth: 80.0,
                    multiValuePadding:
                        const EdgeInsets.symmetric(horizontal: 12.0),
                    barItemBuilder: (data) {
                      return BarItem(
                        color: Colors.blue,
                        radius: const BorderRadius.vertical(
                          top: Radius.circular(24.0),
                        ),
                      );
                    },
                  ),
                  backgroundDecorations: [
                    VerticalAxisDecoration(
                        lineWidth: 2,
                        showLines: false,
                        valuesPadding: EdgeInsets.only(top: 10),
                        showValues: true,
                        legendFontStyle: TextStyle(
                            fontSize: 12,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.blueAccent
                                    : Colors.blueAccent,
                            fontWeight: FontWeight.w800),
                        valuesAlign: TextAlign.center,
                        valueFromIndex: (value) {
                          int index = value.toInt();
                          // debugPrint('index1 --------------------------- $index');

                          // var xLables = xAxisValues(widget.values);
                          // if (index >= 0 && index < xLables.length) {
                          //   return xLables[index] ?? '';
                          // }
                          return '$value';
                        }),
                    GridDecoration(
                      verticalAxisStep: 1,
                      // Adjust this value to control the spacing between vertical grid lines
                      horizontalAxisStep: 20,
                      // Adjust this value to control the spacing between horizontal grid lines
                      textStyle: Theme.of(context).textTheme.caption,
                      gridColor: Theme.of(context)
                          .colorScheme
                          .primaryContainer
                          .withOpacity(0.08),
                    ),
                    // targetArea,
                    // SparkLineDecoration(
                    //   fill: true,
                    //   lineColor: Theme.of(context)
                    //       .primaryColor
                    //       .withOpacity( 0.0),
                    //   smoothPoints: true,
                    // ),
                    SparkLineDecoration(
                      fill: true,
                      lineColor: Theme.of(context)
                          .primaryColor
                          .withOpacity(0.0),
                      smoothPoints: true,
                    ),
                  ],
                  foregroundDecorations: [

                    ValueDecoration(
                      alignment: Alignment.topCenter,
                      textStyle: Theme.of(context).textTheme.button!.copyWith(
                          color:Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.red
                              .withOpacity(1.0),
                          fontSize: 12,
                          fontWeight: FontWeight.w800),
                    ),
                    // SparkLineDecoration(
                    //   fill: false,
                    //   lineWidth: 1.2,
                    //   lineColor: Theme.of(context).brightness == Brightness.dark
                    //       ? Colors.white.withOpacity(1.0)
                    //       : Colors.red.withOpacity(1.0),
                    //   smoothPoints: false,
                    // ),
                    BorderDecoration(
                      sidesWidth: Border(
                        top: BorderSide.none,
                        right: BorderSide.none,
                        left: BorderSide.none,
                        bottom: BorderSide.none,
                      ),
                      endWithChart: true,
                    ),
                    ValueDecoration(
                      alignment: Alignment.bottomCenter,
                      textStyle: Theme.of(context).textTheme.button!.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimary
                              .withOpacity(_stackItems ? 1.0 : 0.0)),
                    ),
                    ValueDecoration(
                      listIndex: 1,
                      alignment: Alignment.bottomCenter,
                      textStyle: Theme.of(context).textTheme.button!.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondary
                              .withOpacity(_stackItems ? 1.0 : 0.0)),
                    ),
                    ValueDecoration(
                      listIndex: 2,
                      alignment: Alignment.bottomCenter,
                      textStyle: Theme.of(context).textTheme.button!.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimary
                              .withOpacity(_stackItems ? 1.0 : 0.0)),
                    ),
                    BorderDecoration(
                      sidesWidth: Border(
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
          ),
          Flexible(
            child: ChartOptionsWidget(
              onRefresh: () {
                setState(() {
                  _values.clear();
                  _updateValues();
                });
              },
              onAddItems: () {
                setState(() {
                  minItems += 4;
                  _addValues();
                });
              },
              onRemoveItems: () {
                setState(() {
                  if (minItems > 6) {
                    minItems -= 4;
                    _values = _values.map((key, value) {
                      return MapEntry(key,
                          value..removeRange(value.length - 4, value.length));
                    });
                  }
                });
              },
              toggleItems: [
                ToggleItem(
                  title: 'Axis values',
                  value: _showValues,
                  onChanged: (value) {
                    setState(() {
                      _showValues = value;
                    });
                  },
                ),
                ToggleItem(
                  value: _legendOnEnd,
                  title: 'Legend on end',
                  onChanged: (value) {
                    setState(() {
                      _legendOnEnd = value;
                    });
                  },
                ),
                ToggleItem(
                  value: _legendOnBottom,
                  title: 'Legend on bottom',
                  onChanged: (value) {
                    setState(() {
                      _legendOnBottom = value;
                    });
                  },
                ),
                ToggleItem(
                  value: _stackItems,
                  title: 'Stack items',
                  onChanged: (value) {
                    setState(() {
                      _stackItems = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
