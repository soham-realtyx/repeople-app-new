
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info/package_info.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Model/Theme/WidgetThemeListClass.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Config/Helper/ApiResponse.dart';
import '../CommonHeaderController/CommenHeaderController.dart';

class AboutUsController extends GetxController {
  RxList<WidgetThemeListClass> arrThemeList = RxList<WidgetThemeListClass>();
  RxList<AboutModel> arrAboutDataList = RxList<AboutModel>();
  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());
  GlobalKey<ScaffoldState> GlobalAboutkey = GlobalKey<ScaffoldState>();

  RxString lblVersion = "".obs;

  //Future Declaration
  Rx<Future<dynamic>> futureTermsAndCondition = Future.value().obs;

  // RxVariable Declaration
  RxString  IsTermsConditionEmpty = ''.obs;
  RxString  IsPrivacyEmpty = ''.obs;
  RxString  icon = ''.obs;
  RxString  about = ''.obs;
  RxString  vision = ''.obs;
  RxString  mission = ''.obs;

  @override
  void onInit() async{
    // TODO: implement onInit
    super.onInit();
    // MoengageAnalyticsHandler().track_event("about");
    PackageInfo info = await PackageInfo.fromPlatform();
    futureTermsAndCondition.value=RetrieveTermsAndConditionData();
    lblVersion.value=info.version;
    print(lblVersion);
  }

  //<editor-fold desc="Api Calls">

  AboutProjectData(){
    arrAboutDataList = RxList([
      AboutModel(icon: "",count: "",name: ""),
      AboutModel(icon: "",count: "",name: ""),
      AboutModel(icon: "",count: "",name: ""),
      AboutModel(icon: "",count: "",name: ""),
    ]);
  }

 Future<dynamic> RetrieveTermsAndConditionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    try{
      print("im reach in api calles");
      var data = {'action': 'listaboutdetails'};
      var headers = {'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",};
      ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_ABOUT_US,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers,
      );
      Map<String, dynamic>? responseData = await response.getResponse();
      log(responseData.toString());
      if (responseData!['status'] == 1) {
        icon.value=responseData['icon'] ?? "";
        about.value=responseData['about'] ?? "";
        vision.value=responseData['vision'] ?? "";
        mission.value=responseData['mission'] ?? "";
      }

      else{
        IsTermsConditionEmpty.value=responseData['message'] ?? "No Data Found";
      }

    }catch(e){
      IsTermsConditionEmpty.value= "No Data Found";
    }

    return 'data received';
  }

}

class AboutModel{
  String? name;
  String? icon;
  String? count;
  AboutModel({this.icon,this.name,this.count});
}
