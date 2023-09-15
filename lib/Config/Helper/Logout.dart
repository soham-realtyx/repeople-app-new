//<editor-fold desc = "Logout">

import 'dart:convert';
import 'dart:io';


import 'package:Repeople/Controller/MenuClickHandlerController/MenuClickHandler.dart';
import 'package:Repeople/View/DashboardPage/DashboardPage.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Helper/MoengageAnalyticsHandler.dart';
import 'package:Repeople/Config/Helper/SessionData.dart';
import 'package:Repeople/Config/Helper/shared_prefrence.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Widgets/CommomBottomSheet.dart';
import 'package:Repeople/Widgets/Loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../View/ManagerScreensFlow/ManagerDashboardScreens/ManagerDashBoardScreen.dart';
import 'ApiResponse.dart';

Future<void> LogoutServie(BuildContext context) async {
  appLoader(context);
  String macAddress = "";
  String os = "";

  try {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      os = "i";
      macAddress = iosInfo.identifierForVendor!;
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      os = "a";
      macAddress = androidInfo.id!;
    }
    SharedPreferences? _preferences=await SharedPreferences.getInstance();
    Map<String, dynamic> data = {};
    data['action'] = 'logout';
    data['macaddress'] = macAddress;
    data['os'] = os;

    var headerdata = {
      "userpagename": 'master',
      "useraction": "viewright",
      "masterlisting": "false",
      "userlogintype":  _preferences.get(SESSION_USERLOGINTYPE).toString(),
    };

    ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_LOGOUT,
        headerdata: headerdata,
        apiHeaderType: ApiHeaderType.Content);
    Map<String, dynamic>? responseData = await response.getResponse();
    // if (responseData!['status'] == 1) {
    // MoengageAnalyticsHandler().track_event('logout');
    MoengageAnalyticsHandler().track_event("logout");MoengageAnalyticsHandler().SendAnalytics({"log_out":"logout"},"logout");
    ClearSession().whenComplete(() =>  Get.offAll(DashboardPage()) );
      removeAppLoader(context);

      StoreIsUpdateNotNowSessionData(false);
    // } else {
    //   RemoveAppLoader(context);
    // }
  } catch (e) {
    print(e);
  }
}

Future<void> ClearSession() async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  sp.clear();
}

Logoutdialog() {
  LoginDialoge(
      dialogtext: "Are you sure you want to logout?",
      stackicon:SvgPicture.asset(IMG_LOGOUT_SVG_NEW,color: white,height: 35,),
      firstbuttontap: () {
        Get.back();
      },
      secondbuttontap: () async{
        MoengageAnalyticsHandler().SendAnalytics({"log_out":"logout"},"logout");
        // MoengageAnalyticsHandler().track_event("logout");
        appLoader(contextCommon);
        LogOutFromCustomer();
      },
      secondbuttontext: "Yes",
      firstbuttontext: "No");
}

LogoutManagerdialog() {

  LoginDialoge(
      dialogtext: "Are you sure you want to logout?",
      stackicon:SvgPicture.asset(IMG_LOGOUT_SVG_NEW,color: white,height: 35,),
      firstbuttontap: () {
        Get.back();
      },
      secondbuttontap: () async{
        MoengageAnalyticsHandler().SendAnalytics({"log_out":"logout"},"logout");
        appLoader(contextCommon);
        LogOutFromManager();

      },
      secondbuttontext: "Yes",
      firstbuttontext: "No");
}

LogOutFromManager()async{
  SharedPreferences sp = await SharedPreferences.getInstance();
  CURRENT_CUSTMER_STATUS.value = sp.getBool(IS_CUSTOMER_DATA_AVAILABLE) ?? false;
  if(CURRENT_CUSTMER_STATUS.isTrue){
    sp.setBool(IS_MANAGER_DATA_AVAILABLE, false);
    sp.setString(REPEOPLE_MANAGER_CREDENTIAL, "");
    var sessionmenu=sp.getString(REPEOPLE_CUSTOMER_CREDENTIAL);
    var responseData=json.decode(sessionmenu ?? "");
    storeCustomerLoginSessionData(responseData).then((value) {
      cnt_Bottom.GetMenutList().then((value) {
        Get.deleteAll(force: true).then((value) {
          cnt_Bottom.selectedIndex.value=0;
          // MoengageAnalyticsHandler().track_event("logout");
          Get.offAll(DashboardPage());
        });
      });
    });
  }
  else{
    ClearSession().whenComplete(() {
      cnt_Bottom.GetMenutList().then((value) {
        Get.deleteAll(force: true).then((value) {
          cnt_Bottom.selectedIndex.value=0;
          MoengageAnalyticsHandler().track_event("logout");MoengageAnalyticsHandler().SendAnalytics({"log_out":"logout"},"logout");
          Get.offAll(DashboardPage());
        });
      });
    } );
  }
}

LogOutFromCustomer()async{
  SharedPreferences sp = await SharedPreferences.getInstance();
  CURRENT_MANAGER_STATUS.value = sp.getBool(IS_MANAGER_DATA_AVAILABLE) ?? false;
  if(CURRENT_MANAGER_STATUS.isTrue){
    var sessionmenu=sp.getString(REPEOPLE_MANAGER_CREDENTIAL);
    sp.setBool(IS_CUSTOMER_DATA_AVAILABLE, false);
    sp.setString(REPEOPLE_CUSTOMER_CREDENTIAL, "");
    var responseData=json.decode(sessionmenu ?? "");
    storeManagerLoginSessionData(responseData).then((value) {
      cnt_Bottom.GetMenutList().then((value) {
        Get.deleteAll(force: true).then((value) {
          MoengageAnalyticsHandler().SendAnalytics({"log_out":"logout"},"logout");
          // MoengageAnalyticsHandler().track_event("logout");
          Get.offAll(ManagerDashboardPage());
        });
      });
    });
  }
  else{
    ClearSession().whenComplete(() {
      cnt_Bottom.GetMenutList().then((value) {
        Get.deleteAll(force: true).then((value) {
          cnt_Bottom.selectedIndex.value=0;
          Get.offAll(DashboardPage());
        });
      });
    } );
  }
}


