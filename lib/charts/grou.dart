import 'dart:math';
import 'package:charts_painter/chart.dart';
import 'package:flutter/material.dart';

class GroupedBarChartsScreen extends StatefulWidget {
  const GroupedBarChartsScreen({Key? key}) : super(key: key);

  @override
  State<GroupedBarChartsScreen> createState() =>
      _GroupedBarChartsScreenState();
}

class _GroupedBarChartsScreenState extends State<GroupedBarChartsScreen> {
  List<List<double>> _groupedValues = [
    [1.0, 2.0, 3.0],
    [4.0, 5.0, 6.0],
    [7.0, 8.0, 9.0],
  ];

  double targetMax = 0;
  bool _showValues = false;
  int minItems = 30;
  int? _selected;

  @override
  void initState() {
    super.initState();
    _updateGroupedValues();
  }

  final _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final _chartState = ChartState(
      data: ChartData(
        _groupedValues.map((group) {
          return group
              .map((value) => BarValue<void>(value.toDouble()))
              .toList();
        }).toList(),
        axisMax: targetMax,
      ),
      itemOptions: BarItemOptions(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        minBarWidth: 36.0,
        barItemBuilder: (data) {
          return BarItem(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
            radius: const BorderRadius.vertical(
              top: Radius.circular(24.0),
            ),
          );
        },
      ),
      behaviour: ChartBehaviour(
        onItemClicked: (item) {
          print('Clicked');
          setState(() {
            _selected = item.itemIndex;
          });
        },
      ),
      foregroundDecorations: [
        SelectedItemDecoration(
          _selected,
          animate: true,
          selectedColor: Theme.of(context).colorScheme.secondary,
          topMargin: 40.0,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(),
                shape: BoxShape.circle,
              ),
              child: Text(
                  '${_selected != null ? _groupedValues[0][_selected!].toStringAsPrecision(2) : '...'}'),
            ),
          ),
          backgroundColor: Theme.of(context)
              .scaffoldBackgroundColor
              .withOpacity(0.8),
        ),
      ],
    );

    return Column(
      children: [
        SingleChildScrollView(
          controller: _controller,
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: AnimatedChart(
            duration: Duration(milliseconds: 450),
            width: MediaQuery.of(context).size.width - 24.0,
            height: MediaQuery.of(context).size.height * 0.4,
            state: _chartState,
          ),
        ),
      ],
    );
  }

  void _updateGroupedValues() {
    final Random _rand = Random();
    final double _difference = _rand.nextDouble() * 15;

    targetMax = 3 +
        ((_rand.nextDouble() * _difference * 0.75) - (_difference * 0.25))
            .roundToDouble();

    _groupedValues = List.generate(2, (groupIndex) {
      return List.generate(minItems, (index) {
        return 2 + _rand.nextDouble() * _difference;
      });
    });
  }
}
