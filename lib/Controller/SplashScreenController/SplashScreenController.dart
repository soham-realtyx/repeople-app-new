import 'dart:async';
import 'dart:developer';
import 'package:Repeople/Controller/BottomNavigator/BottomNavigatorController.dart';
import 'package:Repeople/View/DashboardPage/DashboardPage.dart';
import 'package:Repeople/View/OTPPage/OTPPage.dart';
import 'package:android_play_install_referrer/android_play_install_referrer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Repeople/View/LoginPage/LoginPage.dart';
import 'package:Repeople/View/ManagerScreensFlow/ManagerDashboardScreens/ManagerDashBoardScreen.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';

import '../../Config/Constant.dart';
import '../../Config/Helper/ApiResponse.dart';
import '../../Config/Helper/NotificationHandler.dart';
import '../../Config/Helper/shared_prefrence.dart';

class SplashScreenController extends GetxController {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  //final RemoteConfig _remoteConfig = RemoteConfig.instance;
  // LoginController cnt_Login = Get.put(LoginController());
  // bool isLogin = false;

  late Timer timer;
  double percent = 0;
  RxBool is_loginn=false.obs;
  // DeviceData deviceData = DeviceData();
  RxString redeemMessage="".obs;
  @override
  void onInit() async{
    super.onInit();
    fetchRedeemPointCall();
    whatsAppReferralDetails();
    SharedPreferences sharedPreferences= await  SharedPreferences.getInstance();
    is_loginn.value=sharedPreferences.getBool(ISLOGIN)??false;
    CURRENT_LOGIN_VAR.value = UserSimplePreference.getString(CURRENT_LOGIN) ?? "";
    is_loginn.refresh();
    RetrieveGenrelData();

    RemoteMessage? message = await firebaseMessaging.getInitialMessage();
    if (message != null) {
      NotificationHandler().onNotificationClickListener(message.data,true);
      int count = await getNotificationCount();
      if (count > 0) {
        setNotificationCount(count - 1);
      } else {
        setNotificationCount(0);
      }
    }else{
      initizeLinkWhatsapp();
    }
    Future.delayed(const Duration(seconds: 3), () {
      this.whatsAppLoginStatus();
    });
  }

  // Future<void> get_current_theme() async {
  //   await RemoteConfig.instance.setConfigSettings(RemoteConfigSettings(
  //     fetchTimeout: const Duration(
  //         seconds: 1), // a fetch will wait up to 10 seconds before timing out
  //     minimumFetchInterval: const Duration(
  //         seconds:
  //         0), // fetch parameters will be cached for a maximum of 1 hour
  //   ));
  // }

  SetTimerTOChangePage() {
    Future.delayed(Duration(seconds: 3), () {
      // FindLoginStatus();
    });
  }
  progress_timmer(){
    timer = Timer.periodic(Duration(milliseconds:30),(_){
      percent+=1;
      if(percent >= 100){
        timer.cancel();
      }
    });
  }




  Future<Timer> Loaddata() async {
    CURRENT_LOGIN_VAR.value = UserSimplePreference.getString(CURRENT_LOGIN) ?? "";
    return Timer(Duration(seconds: 4), onLoadDone);
  }

  _getRequests()async{
    // setState(() {
    percent=0;
    // });
    progress_timmer();

    Loaddata();
  }


  onLoadDone() async{
    print("completed");
    print(CURRENT_LOGIN_VAR.value.toString());
    SharedPreferences sharedPreferences= await  SharedPreferences.getInstance();
    // is_loginn.value=sharedPreferences.getBool(ISLOGIN)??false;
    if(CURRENT_LOGIN_VAR.value.trim()=="Manager_Access"){
      Get.offAll(ManagerDashboardPage());
      // Get.offAll(LoginPage());
    }else{
      // Get.offAll(LoginPage());
      Get.offAll(DashboardPage());
    }
  }

  Future<void> initReferrerDetails() async {
    String referrerDetailsString;
    try {
      ReferrerDetails referrerDetails = await AndroidPlayInstallReferrer.installReferrer;
      referrerDetailsString = referrerDetails.toString();
      callLinkOpen(referrerDetails.installReferrer);
    } catch (e) {
      referrerDetailsString = 'Failed to get referrer details: $e';
      // checkLoginOrNot();
    }
    print("_referrerDetails $referrerDetailsString");

  }
  Future<String> initizeLinkWhatsapp()async{
    //https://www.prestigeconstructions.com/whatsapp-login/64df4daacb9e80d5aea75ce4/
    String link = "";

    try{
      print("whatsapp_login_data_is: $link");
      var initLink = await getInitialLink();
        bool? isContains =initLink?.contains("/whatsapp-login/");


      if(isContains!=null&&isContains){//whatsapp-login/
        var data = initLink?.split("/whatsapp-login/");
        link = data![1];

      }else{
        link = "";
      }
      print("whatsapp_login_data_is:"+link);
    }catch(e){
      print(e.toString() + " whatsApp Login error");
    }

    return link;

  }

  Future<void> initlizeLink() async {
    var initLink = await getInitialLink();
    if (initLink != null){
      callLinkOpen(initLink);
    }else{
      print("initlink");
      initReferrerDetails();
    }
    print(initLink.toString());
  }

  whatsAppLoginStatus() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool isLogin = sp.getBool(ISLOGIN) ?? false;
    // String roleCode = await getUserRoleCode();
    RemoteMessage? message = await firebaseMessaging.getInitialMessage();

    String urlWA = await initizeLinkWhatsapp();
      if(isLogin){
        if(urlWA != ""){
          Get.off(const OTPPage(/*wtspdata:urlWA,*/));
        }
        else{
          Get.off(const DashboardPage());
        }
      }else{
        Get.off(const DashboardPage());
      }
  }

  fetchRedeemPointCall() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    try{
      var data = {
        'action': 'fetchrepeoplepoint',
      };
      var headers = {
        'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",
      };
      ApiResponse response = ApiResponse(
        data: data,
        base_url: redeemPointsURL,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers,
      );
      Map<String, dynamic>? responseData = await response.getResponse();
      log( "fetch Repeople PointCall $responseData");
      if (responseData!['status'] == 1) {
        redeemPoints.value=responseData['remainingpoints'];
      }
      else{
        redeemMessage.value=responseData['message'];
      }
    }catch(e){
      print("$e my fetch redeem point error");
    }
  }

  whatsAppReferralDetails() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    try{
      var data = {
        'action': 'fetchreferraldetail',
      };
      var headers = {
        'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",
      };
      ApiResponse response = ApiResponse(
        data: data,
        base_url: whatsAppReferral,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers,
      );
      Map<String, dynamic>? responseData = await response.getResponse();
      log("whatsApp referral call $responseData");
      if (responseData!['status'] == 1) {
        referralCode.value=responseData['referralcode'];
        referralLink.value=responseData['link'];
      }
      else{
        // redeemMessage.value=responseData['message'];
      }
    }catch(e){
      print(e.toString()+" my fetch redeem point error");
    }
  }

  Future<void> RetrieveGenrelData() async {
    try{
      SharedPreferences sp = await SharedPreferences.getInstance();

      var data = {
        'action': 'generaldetails',
      };

      var headers = {'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",};

      ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_DETAILS,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers,
      );
      Map<String, dynamic>? responseData = await response.getResponse();

      if (responseData!['status'] == 1) {
        sp.setString(PROJECT_CHECKLIST, responseData['checklisturl'] ?? "");
        sp.setString(PLACE_ANALIYSIS, responseData['analysisurl'] ?? "");
        sp.setString(ONLINE_MEETING_SCHEDULE, responseData['scheduleurl'] ?? "");
        sp.setString(PLACE_AREA_CALCULATOR, responseData['areacalcurl'] ?? "");
      }
      else{

      }

    }catch(e){

    }
  }

}
