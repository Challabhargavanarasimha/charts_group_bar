class DailyActivitySummerModel {
  bool? status;
  String? message;
  List<DailyActivitySummerData>? data;

  DailyActivitySummerModel({this.status, this.message, this.data});

  DailyActivitySummerModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DailyActivitySummerData>[];
      json['data'].forEach((v) {
        data!.add(new DailyActivitySummerData.fromJson(v));
      });
    }
  }


}

class DailyActivitySummerData {
  String? date;
  List<SummaryData>? summaryData;

  DailyActivitySummerData({this.date, this.summaryData});

  DailyActivitySummerData.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    if (json['summaryData'] != null) {
      summaryData = <SummaryData>[];
      json['summaryData'].forEach((v) {
        summaryData!.add(new SummaryData.fromJson(v));
      });
    }
  }


}

class SummaryData {
  String? activityType;
  String? activityName;
  String? activityValue;
  String? activityValue1;

  SummaryData(
      {this.activityType,
        this.activityName,
        this.activityValue,
        this.activityValue1});

  SummaryData.fromJson(Map<String, dynamic> json) {
    activityType = json['activityType'];
    activityName = json['activityName'];
    activityValue = json['activityValue'];
    activityValue1 = json['activityValue1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['activityType'] = this.activityType;
    data['activityName'] = this.activityName;
    data['activityValue'] = this.activityValue;
    data['activityValue1'] = this.activityValue1;
    return data;
  }
}