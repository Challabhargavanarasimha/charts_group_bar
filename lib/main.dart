import 'dart:convert';

import 'package:charts_painter/chart.dart';
import 'package:example/chart_types.dart';
import 'package:example/charts/bar_target_chart_screen.dart';
import 'package:example/charts/migration_chart_screen.dart';
import 'package:example/charts/scrollable_visible_items_chart_screen.dart';
import 'package:example/complex/complex_charts.dart';
import 'package:example/grouped/grouped_charts.dart';
import 'package:example/showcase/ios_charts.dart';
import 'package:example/showcase/showcase_charts.dart';
import 'package:example/summary_model.dart';
import 'package:flutter/material.dart';

import 'charts/line_chart_screen.dart';
import 'charts/scrollable_chart_screen.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.orange,
        colorScheme: ThemeData.light()
            .colorScheme
            .copyWith(
              primary: Color(0xFFd8262C),
              secondary: Color(0xFF353535),
              error: Colors.lightBlue,
            )
            .copyWith(secondary: Color(0xFFd8262C)),
      ),
      home: ChartDemo()));
}

class ChartDemo extends StatefulWidget {
  ChartDemo({Key? key}) : super(key: key);

  @override
  _ChartDemoState createState() => _ChartDemoState();
}

class _ChartDemoState extends State<ChartDemo> {
  List? data;

  // List<DailyActivitySummerData> userlist = [];
  // List<SummaryData>? usersavedlist =[];
  int? index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Charts showcase'),
      ),
      body: ShowList(),
    );
  }
}

class ShowList extends StatefulWidget {
  ShowList({Key? key}) : super(key: key);

  @override
  State<ShowList> createState() => _ShowListState();
}

class _ShowListState extends State<ShowList> {
  Future<void> fetchData() async {
    String? data =
        await DefaultAssetBundle.of(context).loadString("assets/values.json");
    dynamic decodedData = jsonDecode(data);
    debugPrint('decodedData -------------------$decodedData');
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: 8.0,
        ),
        ListTile(
          title: Text(
            'Custom Group Bar Charts',
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 18.0,
                ),
          ),
          trailing: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              width: 100.0,
              child: Chart(
                state: ChartState<void>(
                  data: ChartData.fromList(
                    [1, 3, 4, 2, 7, 6, 2, 5, 4]
                        .map((e) => BarValue<void>(e.toDouble()))
                        .toList(),
                    axisMax: 8,
                  ),
                  itemOptions: BarItemOptions(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    barItemBuilder: (_) => BarItem(
                      color: Theme.of(context).colorScheme.secondary,
                      radius: BorderRadius.vertical(top: Radius.circular(12.0)),
                    ),
                  ),
                  backgroundDecorations: [
                    GridDecoration(
                      verticalAxisStep: 1,
                      horizontalAxisStep: 4,
                      gridColor: Theme.of(context).dividerColor,
                    ),
                    SparkLineDecoration(
                      lineColor: Theme.of(context).colorScheme.secondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
          onTap: () {
            Navigator.of(context)
                .push<void>(MaterialPageRoute(builder: (_) => GroupedCharts()));
          },
        ),
        SizedBox(
          height: 80.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Chart types',
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.0,
                ),
          ),
        ),
        Divider(),
        ChartTypes(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Chart Decorations',
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.0,
                ),
          ),
        ),
        Divider(),
        ListTile(
          title: Text('Migration from 2.0'),
          onTap: () {
            Navigator.of(context).push<void>(
                MaterialPageRoute(builder: (_) => MigrationChartScreen()));
          },
        ),
        Divider(),
        ListTile(
          title: Text('Sparkline decoration'),
          trailing: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              width: 100.0,
              child: Chart(
                state: ChartState<void>(
                  data: ChartData.fromList(
                    [2, 7, 2, 4, 7, 6, 2, 5, 4]
                        .map((e) => BubbleValue<void>(e.toDouble()))
                        .toList(),
                    axisMax: 9,
                  ),
                  itemOptions: BubbleItemOptions(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    bubbleItemBuilder: (_) => BubbleItem(
                        color: Theme.of(context).colorScheme.secondary),
                    maxBarWidth: 1.0,
                  ),
                  backgroundDecorations: [
                    GridDecoration(
                      showVerticalGrid: false,
                      horizontalAxisStep: 3,
                      gridColor: Theme.of(context).dividerColor,
                    ),
                    SparkLineDecoration(
                      lineWidth: 2.0,
                      lineColor: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),
          ),
          onTap: () {
            Navigator.of(context).push<void>(
                MaterialPageRoute(builder: (_) => LineChartScreen()));
          },
        ),
        Divider(),
        ListTile(
          title: Text('Target line decoration'),
          trailing: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              width: 100.0,
              child: Chart(
                state: ChartState<void>(
                    data: ChartData.fromList(
                      [1, 3, 4, 2, 7, 6, 2, 5, 4]
                          .map((e) => BarValue<void>(e.toDouble()))
                          .toList(),
                      axisMax: 8,
                    ),
                    itemOptions: BarItemOptions(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      barItemBuilder: (_) => BarItem(
                          color: Theme.of(context).colorScheme.secondary),
                      maxBarWidth: 4.0,
                    ),
                    backgroundDecorations: [
                      GridDecoration(
                        verticalAxisStep: 1,
                        horizontalAxisStep: 2,
                        gridColor: Theme.of(context).dividerColor,
                      ),
                    ],
                    foregroundDecorations: [
                      TargetLineDecoration(
                        target: 6,
                        colorOverTarget: Theme.of(context).colorScheme.error,
                        targetLineColor:
                            Theme.of(context).colorScheme.secondary,
                      ),
                      BorderDecoration(
                        borderWidth: 1.5,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ]),
              ),
            ),
          ),
          onTap: () {
            Navigator.of(context).push<void>(
                MaterialPageRoute(builder: (_) => BarTargetChartScreen()));
          },
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Chart Interactions',
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.0,
                ),
          ),
        ),
        Divider(),
        ListTile(
          title: Text('Scrollable chart'),
          trailing: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              width: 100.0,
              child: Chart(
                state: ChartState<void>(
                  data: ChartData.fromList(
                    [1, 3, 4, 2, 7, 6, 2, 5, 4]
                        .map((e) => BarValue<void>(e.toDouble()))
                        .toList(),
                    axisMax: 8,
                  ),
                  itemOptions: BarItemOptions(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    barItemBuilder: (_) => BarItem(
                      color: Theme.of(context).colorScheme.secondary,
                      radius: BorderRadius.vertical(top: Radius.circular(12.0)),
                    ),
                  ),
                  backgroundDecorations: [
                    GridDecoration(
                      verticalAxisStep: 1,
                      horizontalAxisStep: 4,
                      gridColor: Theme.of(context).dividerColor,
                    ),
                    SparkLineDecoration(
                      lineColor: Theme.of(context).colorScheme.secondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
          onTap: () {
            Navigator.of(context).push<void>(
                MaterialPageRoute(builder: (_) => ScrollableChartScreen()));
          },
        ),
        Divider(),
        ListTile(
          title: Text('Scrollable with visible items'),
          trailing: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              width: 100.0,
              child: Chart(
                state: ChartState<void>(
                  data: ChartData.fromList(
                    [1, 3, 4, 2, 7, 6, 2, 5, 4, 2, 9, 10, 2, 4, 8, 7, 7, 6, 1]
                        .map((e) =>
                            CandleValue<void>(e.toDouble() + 6, e.toDouble()))
                        .toList(),
                    axisMax: 15,
                  ),
                  itemOptions: BarItemOptions(
                    barItemBuilder: (_) {
                      return BarItem(
                        radius: BorderRadius.all(Radius.circular(12.0)),
                        color: Theme.of(context).colorScheme.secondary,
                      );
                    },
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  ),
                  backgroundDecorations: [
                    GridDecoration(
                      verticalAxisStep: 1,
                      horizontalAxisStep: 3,
                      gridColor: Theme.of(context).dividerColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
          onTap: () {
            Navigator.of(context).push<void>(MaterialPageRoute(
                builder: (_) => ScrollableVisibleItemsChartScreen()));
          },
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Complex charts',
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.0,
                ),
          ),
        ),
        Divider(),
        ComplexCharts(),
        ShowcaseCharts(),
        IosCharts(),
        SizedBox(
          height: 24.0,
        ),
      ],
    );
  }
}
