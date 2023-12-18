import 'package:flutter/material.dart';
import 'package:charts_painter/chart.dart';

import '../widgets/bar_chart.dart';

class MultipleBarChartsScreen1 extends StatelessWidget {
  final List<List<double>> chartData = [
    [10, 15, 20, 25],
    [5, 10, 15, 20],
    [8, 12, 18, 22],
    // Add more data sets as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multiple Bar Charts'),
      ),
      body: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: chartData.length,
        itemBuilder: (context, index) {
          return Container(
            width: MediaQuery.of(context).size.width - 24.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BarCharts<double>(
                data: chartData[index],
                dataToValue: (value) => value,
                height: 200.0, // Adjust the height as needed
                backgroundDecorations: [
                  GridDecoration(
                    showVerticalGrid: true,
                    showHorizontalValues: true,
                    showVerticalValues: true,
                    showTopHorizontalValue: true,
                    textStyle: Theme.of(context).textTheme.caption,
                    gridColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
                  ),
                ],
                foregroundDecorations: [
                  BorderDecoration(),
                  ValueDecoration(
                    alignment: Alignment.bottomCenter,
                    textStyle: Theme.of(context).textTheme.button!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
