
import 'dart:convert';

import 'package:charts_painter/chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/activity_summary_model.dart';
import 'custom_multi_bar_charts_screen.dart';

class GroupedCharts extends StatefulWidget {

  const GroupedCharts({Key? key}) : super(key: key);

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
  Future<void> fetchData() async {
    String? data =
    await DefaultAssetBundle.of(context).loadString("assets/values.json");
    dynamic decodedData = jsonDecode(data);
    summaryData = await DailyActivitySummerModel.fromJson(
        decodedData as Map<String, dynamic>);

    debugPrint('decodedData -------------------$summaryData');
  }
  @override
  void initState() {
    fetchData();
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
            Get.to(()=>CustomMultiBarChartScreen(summaryData:summaryData,height: MediaQuery.of(context).size.height*0.4,));
          }, child: const Text('Multi Bars Custom')),
        )
      ),
    );
  }
}
