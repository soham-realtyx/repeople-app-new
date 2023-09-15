import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

// double getDisplayWidth({double? mobile , double? tablet , double? web}){
//   double width = Get.width;
//
//   if(width < 600){
//     return mobile!;
//   }
//   else if(width > 600 || width < 1024){
//     return tablet!;
//   }
//   else{
//     return web!;
//   }
// }
//
//
// double getWidth(double width){
//   return (Get.width / 414 ) * width;
// }
//
// double getHeight(double height){
//   return (Get.height / 846) * height;
// }
//
// TextStyle getTextStyle(TextStyle smallDevice , TextStyle mediumDevice){
//   if(Get.width > 400){
//     return mediumDevice;
//   }
//   else{
//     return smallDevice;
//   }
// }
//
// String getDeviceText(String smallDevice , String mediumText){
//   if(Get.width > 400){
//     return mediumText;
//   }
//   else{
//     return smallDevice;
//   }
// }
//
// double pixelDeviceRatio(double smalldevice , double mediumdevice){
//   return Get.height < 600 ? smalldevice : mediumdevice;
// }


// ScreenSizeConfig(BuildContext context){
//   ScreenUtil.init(BoxConstraints(maxWidth: Get.width,maxHeight: Get.height),context: context,minTextAdapt: true);
// }


class SizeConfig{
  final Size defaultSize = const Size(360,690); // 320 568 375 667
  double screenHeight = Get.height;
  double screenWidth = Get.width;

  double get scaleWidth => screenWidth / defaultSize.width;
  double get scaleHeight => screenHeight / defaultSize.height;
  double get scaleText => min(scaleWidth, scaleHeight);

  double setWidth(num width) => width * scaleWidth;
  double setHeight(num height) => height * scaleHeight;
  double setSp(num fontSize) => fontSize * scaleText;
}

extension numExtension on num{
  double get w => SizeConfig().setWidth(this);
  double get h => SizeConfig().setHeight(this);
  double get sp => SizeConfig().setSp(this);
}

