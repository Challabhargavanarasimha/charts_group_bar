

class DailyActivitySummerModel {
  bool? status;
  String? message;
  List<DailyActivitySummerData>? data;

  DailyActivitySummerModel({this.status, this.message, this.data});

  DailyActivitySummerModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] as bool ;
    message = json['message'] as String;
    if (json['data'] != null) {
      data = <DailyActivitySummerData>[];
      json['data'].forEach(( List<DailyActivitySummerData> v) {
        data!.add(DailyActivitySummerData.fromJson(v as Map<String, dynamic> ));
      });
    }
  }
}

class DailyActivitySummerData {
  String? date;
  List<SummaryData>? summaryData;

  DailyActivitySummerData({this.date, this.summaryData});

  DailyActivitySummerData.fromJson(Map<String, dynamic> json) {
    date = json['date'] as String;
    if (json['summaryData'] != null) {
      summaryData = <SummaryData>[];
      json['summaryData'].forEach(( List<SummaryData> v) {
        summaryData!.add(SummaryData.fromJson(v as Map<String, dynamic>));
      });
    }
  }
}

class SummaryData {
  String? activityType;
  String? activityName;
  String? activityValue;
  String? activityValue1;

  SummaryData({
    this.activityType,
    this.activityName,
    this.activityValue,
    this.activityValue1,
  });

  SummaryData.fromJson(Map<String, dynamic> json) {
    activityType = json['activityType'] as String;
    activityName = json['activityName'] as String;
    activityValue = json['activityValue'] as String;
    activityValue1 = json['activityValue1'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['activityType'] = activityType;
    data['activityName'] = activityName;
    data['activityValue'] = activityValue;
    data['activityValue1'] = activityValue1;
    return data;
  }
}