import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Config/utils/colors.dart';

Widget CommonBackButton5Theme(String title,{Color? maincontainercolor}){
  return Container(
    // color: maincontainercolor??,
    child: Row(
      children: [
      Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.shade200,
        ),
        child: InkWell(
          onTap: (){
            Get.back();
          },
          child: Center(
            child: Icon(Icons.arrow_back_ios_new_outlined,size: 17,),
          ),
        ),
      ),
      SizedBox(width: 15,),
      Text(title,style: TextStyle(color: APP_FONT_COLOR, fontSize: 20, fontWeight: FontWeight.w600,),)
    ],),
  );

}