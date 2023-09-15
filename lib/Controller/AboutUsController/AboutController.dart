
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info/package_info.dart';
import 'package:Repeople/Model/Theme/WidgetThemeListClass.dart';
import '../CommonHeaderController/CommenHeaderController.dart';

class AboutController extends GetxController {
  RxList<WidgetThemeListClass> arrThemeList = RxList<WidgetThemeListClass>();
  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());
  GlobalKey<ScaffoldState> GlobalAboutkey = GlobalKey<ScaffoldState>();

  RxString lblVersion = "".obs;

  @override
  void onInit() async{
    // TODO: implement onInit
    super.onInit();
    PackageInfo info = await PackageInfo.fromPlatform();
    // appVersion = info.version;
    lblVersion.value=info.version;
    print(lblVersion);
  }



}
