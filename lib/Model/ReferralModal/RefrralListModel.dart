class RefrralMainListModel {
  String? name;
  String? icon;
  String? color;
  int? count;
  List<Data>? data;

  RefrralMainListModel({this.name, this.icon, this.color, this.count, this.data});

  RefrralMainListModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    icon = json['icon'];
    color = json['color'];
    count = json['count'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) { data!.add(new Data.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['color'] = this.color;
    data['count'] = this.count;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? name;
  String? shortname;
  String? contact;
  String? email;
  String? status;
  String? class1;
  List<ReferStepList>? refersteplist;

  Data({this.name, this.shortname, this.contact, this.email, this.status, this.class1, this.refersteplist});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    shortname = json['shortname'];
    contact = json['contact'];
    email = json['email'];
    status = json['status'];
    class1 = json['class'];
    if (json['refersteplist'] != null) {
      refersteplist = <ReferStepList>[];
      json['refersteplist'].forEach((v) { refersteplist!.add(new ReferStepList.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['shortname'] = this.shortname;
    data['contact'] = this.contact;
    data['email'] = this.email;
    data['status'] = this.status;
    data['class'] = this.class1;
    if (this.refersteplist != null) {
      data['refersteplist'] = this.refersteplist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReferStepList {
  String? name;
  String? icon;
  String? description;
  int? points;
  String? color;
  int? status;
  String? statusstr;
  String? date;

  ReferStepList({this.name, this.icon,this.description,this.points,this.color,this.status,this.statusstr,this.date});

  ReferStepList.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    icon = json['icon'];
    description = json['description'];
    points = json['points'];
    color = json['color'];
    status = json['status'];
    statusstr = json['statusstr'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['description'] = this.description;
    data['points'] = this.points;
    data['color'] = this.color;
    data['status'] = this.status;
    data['statusstr'] = this.statusstr;
    data['date'] = this.date;
    return data;
  }

}

