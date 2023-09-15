import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class DrawerModal {
  RxBool? isShow = false.obs;
  String? title;
  Widget? lblVersion;
  Color? backColor;
  String? images;
  GestureTapCallback? onTap;

  DrawerModal(
      {this.title,
        this.backColor,
        this.images,
        this.onTap,
        this.isShow,
        this.lblVersion,
      });

  DrawerModal.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    backColor = json['backColor'];
    images = json['images'];
    onTap = json['onTap'];
    lblVersion = json['lblVersion'];
    isShow?.value = json['isShow']=false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['backColor'] = this.backColor;
    data['images'] = this.images;
    data['onTap'] = this.onTap;
    data['lblVersion'] = this.lblVersion;
    data['isShow'] = this.isShow?.value=false;

    return data;
  }
}