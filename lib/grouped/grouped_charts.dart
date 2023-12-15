import 'dart:convert';

import 'package:example/grouped/summary_model.dart';
import 'package:flutter/material.dart';

class GroupedCharts extends StatefulWidget {
  const GroupedCharts({Key? key}) : super(key: key);

  @override
  State<GroupedCharts> createState() => _GroupedChartsState();
}

class _GroupedChartsState extends State<GroupedCharts> {
  DailyActivitySummerModel? summaryData;

  Future<void> fetchData() async {
    String? data =
        await DefaultAssetBundle.of(context).loadString("assets/values.json");
    dynamic decodedData = jsonDecode(data);
    summaryData =
      await  DailyActivitySummerModel.fromJson(decodedData as Map<String, dynamic>);

    debugPrint('decodedData -------------------$summaryData');
  }

  @override
  void initState() {
    // TODO: implement initState
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
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
      )
      // ListView.builder(
      //   itemCount: summaryData?.data?.length ?? 0,
      //   itemBuilder:(context, index) {
      //
      //   return Text(summaryData?.data?[index].date.toString() ?? '');
      // }, ),
    );
  }
}
