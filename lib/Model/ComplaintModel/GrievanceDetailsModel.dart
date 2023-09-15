class GrievanceDetailsModel {
  String? raiseId;
  String? statusstr;
  String? color;
  String? type;
  List<Data>? data;
  String? message;
  int? status;
  int? isreopen=1;
  int? isclose=1;
  int? isescalate=1;
  int? ischatbox=1;
  int? israteus=0;

  GrievanceDetailsModel(
      {this.raiseId,
        this.statusstr,
        this.color,
        this.type,
        this.data,
        this.message,
        this.status,
        this.isreopen,
        this.isclose,
        this.isescalate,
        this.ischatbox,
        this.israteus,
      });

  GrievanceDetailsModel.fromJson(Map<String, dynamic> json) {
    raiseId = json['raise_id'];
    statusstr = json['statusstr'];
    color = json['color'];
    type = json['type'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
    isreopen = json['isreopen'];
    isclose = json['isclose'];
    isescalate = json['isescalate'];
    ischatbox = json['ischatbox'];
    israteus = json['israteus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['raise_id'] = this.raiseId;
    data['statusstr'] = this.statusstr;
    data['color'] = this.color;
    data['type'] = this.type;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class Data {
  String? dateformatstr;
  List<Activity>? activity;

  Data({this.dateformatstr, this.activity});

  Data.fromJson(Map<String, dynamic> json) {
    dateformatstr = json['dateformatstr'];
    if (json['activity'] != null) {
      activity = <Activity>[];
      json['activity'].forEach((v) {
        activity!.add(new Activity.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dateformatstr'] = this.dateformatstr;
    if (this.activity != null) {
      data['activity'] = this.activity!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Activity {
  int? chattype;
  int? status;
  String? message;
  String? profile;
  List<String>? media;

  String? time;

  Activity({this.chattype, this.message, this.profile, this.media, this.time});

  Activity.fromJson(Map<String, dynamic> json) {
    chattype = json['chattype'];
    status = json['status'];
    message = json['message'];
    profile = json['profile'];
    media = json['media'].cast<String>();
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chattype'] = this.chattype;
    data['status'] = this.status;
    data['message'] = this.message;
    data['media'] = this.media;
    data['time'] = this.time;
    return data;
  }
}