import 'package:flutter/material.dart';

class NotificationModal {
  String? id;
  String? title;
  String? notificationdate;
  String? description;
  String? notificationimage;
  Color? backgroundcolor;

  NotificationModal(
      {this.id,
        this.title,
        this.notificationdate,
        this.description,
        this.notificationimage,
        this.backgroundcolor,
      });

  // NewsListClass.Drawer(this.pagename,this.appmenuname,this.iconImage);

  NotificationModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    notificationdate = json['notificationdate'];
    description = json['description'];
    notificationimage = json['notificationimage'];
    backgroundcolor = json['backgroundcolor'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['notificationdate'] = this.notificationdate;
    data['description'] = this.description;
    data['notificationimage'] = this.notificationimage;
    data['backgroundcolor'] = this.backgroundcolor;


    return data;
  }
}