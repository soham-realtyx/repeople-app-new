
import 'package:flutter/material.dart';

class MyPropertiesListModel {

  String? title;
  Color? color;
  String? projectImage;
  String? futureImage;
  String? projectAddress;
  String? projectName;
  String? userType;
  String? address;
  String? ID;
  GestureTapCallback? onTap;

  MyPropertiesListModel({
    this.title,
    this.color,
    this.projectImage,
    this.ID,
    this.onTap,
    this.futureImage,
    this.projectAddress,
    this.projectName,
    this.address,
    this.userType,
  });
  MyPropertiesListModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    color = json['color'];
    projectImage = json['projectImage'];
    ID = json['id'];
    onTap = json['onTap'];
    futureImage = json['futureImage'];
    projectAddress = json['projectAddress'];
    projectName = json['projectName'];
    address = json['address'];
    userType = json['userType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['color'] = this.color;
    data['projectImage'] = this.projectImage;
    data['id'] = this.ID;
    data['onTap'] = this.onTap;
    data['futureImage'] = this.futureImage;
    data['projectAddress'] = this.projectAddress;
    data['projectName'] = this.projectName;
    data['address'] = this.address;
    data['userType'] = this.userType;

    return data;
  }
}