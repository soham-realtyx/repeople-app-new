import 'dart:convert';
// grievance
// GRIEVANCE
class GrievanceListModel {
  String? raiseId;
  String? id;
  String? project;
  String? status;
  String? color;
  String? message;
  String? reply;
  String? time;
  String? raisedby;
  String? senderType;
  List<String>? raiseimage;
  String? grievancedate;
  String? grievancetypename;
  String? resolvedbyname;
  String? resolveddate;

  GrievanceListModel(
      {this.raiseId,
        this.id,
        this.project,
        this.status,
        this.color,
        this.message,
        this.reply,
        this.raisedby,
        this.senderType,
        this.raiseimage,
        this.grievancedate,
        this.grievancetypename,
        this.resolvedbyname,
        this.resolveddate,
        this.time});

  GrievanceListModel.fromJson(Map<String, dynamic> json) {
    raiseId = json['raise_id'];
    id = json['id'];
    project = json['project'];
    status = json['status'];
    color = json['color'];

    message = json['message'];
    reply = json['reply'];
    time = json['time'];
    senderType = json['senderType'];
    raiseimage = json['raiseimage'].cast<String>();
    raisedby = json['raisedby'];
    grievancedate = json['grievancedate'];
    grievancetypename = json['grievancetypename'];
    resolvedbyname = json['resolvedbyname'];
    resolveddate = json['resolveddate'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['raise_id'] = this.raiseId;
    data['id'] = this.id;
    data['project'] = this.project;
    data['status'] = this.status;
    data['color'] = this.color;
    data['message'] = this.message;
    data['reply'] = this.reply;
    data['time'] = this.time;
    data['senderType'] = this.senderType;
    data['raiseimage'] = this.raiseimage;
    data['raisedby'] = this.raisedby;
    return data;
  }
}

class ComplaintDetailsModel {
  String? id;
  String? msged_by_id;
  String? status;
  String? action;
  String? msg;
  String? profile_image;
  String? created_at;
  String? created_by;
  List<String>? images=[];


  ComplaintDetailsModel(
      {this.id,
        this.msged_by_id,
        this.status,
        this.action,
        this.msg,
        this.profile_image,
        this.created_at,
        this.created_by,
        this.images,
      });

  ComplaintDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    msged_by_id = json['msged_by_id'];
    status = json['status'];
    action = json['action'];
    msg = json['msg'];
    profile_image = json['profile_image'];
    created_at = json['created_at'];
    created_by = json['created_by'];
    images =json['images']!=null? List.from(json['images']):[];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['msged_by_id'] = msged_by_id;
    data['status'] = status;
    data['action'] = action;
    data['msg'] = msg;
    data['profile_image'] = profile_image;
    data['created_at'] = created_at;
    data['created_by'] = created_by;
    data['images'] =jsonEncode(images);


    return data;
  }
}


class NewGrievanceDetailsModel {
  String? id;
  String? title;
  String? status;
  String? userName;
  String? msg;
  String? date;
  String? senderType;
  String? created_by;
  List<String>? images=[];
  List<String>? mylist=[];


  NewGrievanceDetailsModel(
      {this.id,
        this.title,
        this.status,
        this.userName,
        this.msg,
        this.date,
        this.senderType,
        this.created_by,
        this.images,
        this.mylist,
      });

  NewGrievanceDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    status = json['status'];
    userName = json['userName'];
    msg = json['msg'];
    date = json['date'];
    senderType = json['senderType'];
    created_by = json['created_by'];
    images =json['images']!=null? List.from(json['images']):[];
    mylist =json['mylist']!=null? List.from(json['mylist']):[];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['status'] = status;
    data['userName'] = userName;
    data['msg'] = msg;
    data['date'] = date;
    data['senderType'] = senderType;
    data['created_by'] = created_by;
    data['images'] =jsonEncode(images);
    data['mylist'] =jsonEncode(mylist);


    return data;
  }
}