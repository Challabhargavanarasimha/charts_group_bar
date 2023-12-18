
import 'package:charts_painter/chart.dart';
import 'package:example/grouped/custom_multi_bar_charts_screen.dart';
import 'package:example/grouped/summary_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupedCharts extends StatefulWidget {
  final DailyActivitySummerModel? summaryData;

  const GroupedCharts({Key? key, this.summaryData}) : super(key: key);

  @override
  State<GroupedCharts> createState() => _GroupedChartsState();
}

class _GroupedChartsState extends State<GroupedCharts> {
  DailyActivitySummerModel? summaryData;
  Map<int, List<BarValue<void>>> _values = <int, List<BarValue<void>>>{};
  double targetMax = 0;
  double targetMin = 0;
  bool _showValues = false;
  int minItems = 6;
  bool _legendOnEnd = true;
  bool _legendOnBottom = true;
  bool _stackItems = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Container(
        // height: MediaQuery.of(context).size.height,
        // width: MediaQuery.of(context).size.width,
        child: Center(
          child: ElevatedButton(onPressed: (){
            Get.to(()=>CustomMultiBarChartScreen(summaryData: widget.summaryData,));
          }, child: Text('Multi Bars Custom')),
        )
      ),
    );
  }
}
