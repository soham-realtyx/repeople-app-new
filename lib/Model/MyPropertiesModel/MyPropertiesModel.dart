
import 'package:flutter/material.dart';

class MyPropertiesModel {

  String? title;
  Color? color;
  String? icon;
  String? ID;
  GestureTapCallback? onTap;

  MyPropertiesModel({
        this.title,
        this.color,
        this.icon,
        this.ID,
     this.onTap,
      });
  MyPropertiesModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    color = json['color'];
    icon = json['icon'];
    ID = json['id'];
    onTap = json['onTap'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['color'] = this.color;
    data['icon'] = this.icon;
    data['id'] = this.ID;
    data['onTap'] = this.onTap;

    return data;
  }
}