
import 'dart:io';

import 'package:Repeople/Config/Helper/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moengage_flutter/model/inapp/click_data.dart';
import 'package:moengage_flutter/model/inapp/inapp_data.dart';
import 'package:moengage_flutter/model/inapp/self_handled_data.dart';
import 'package:moengage_flutter/model/permission_result.dart';
import 'package:moengage_flutter/model/push/moe_push_service.dart';
import 'package:moengage_flutter/model/push/push_campaign_data.dart';
import 'package:moengage_flutter/model/push/push_token_data.dart';
import 'package:moengage_flutter/moe_core_controller.dart';
import 'package:moengage_flutter/moengage_flutter.dart';
import 'package:moengage_flutter/properties.dart';
import 'package:Repeople/Config/Constant.dart';

class MoengageAnalyticsHandler {

  late  MoEngageFlutter moengagePlugin = MoEngageFlutter(MOENGAGE_APP_ID);
  late CoreController _controller;

  final tag = "MoeRepeople_";
  MoengageAnalyticsHandler(){
    initMoengage();
  }
  Future<void> initMoengage() async {
    print("initMoengage");
     moengagePlugin = MoEngageFlutter(MOENGAGE_APP_ID);
     moengagePlugin.setPushClickCallbackHandler(onPushClick);
     moengagePlugin.setInAppClickHandler(_onInAppClick);
     moengagePlugin.setInAppShownCallbackHandler(_onInAppShown);
     moengagePlugin.setInAppDismissedCallbackHandler(_onInAppDismiss);
     moengagePlugin.setSelfHandledInAppHandler(_onInAppSelfHandle);
     moengagePlugin.setPushTokenCallbackHandler(_onPushTokenGenerated);
     moengagePlugin.setPermissionCallbackHandler(_permissionCallbackHandler);

     moengagePlugin.configureLogs(LogLevel.VERBOSE);
     moengagePlugin.registerForPushNotification();
    // moengagePlugin.passFCMPushPayload()


    moengagePlugin.initialise();
  }
  Future<void> track_event(String name) async {
    moengagePlugin.trackEvent(name);
  }
  Future<void> logout()async{
    moengagePlugin.logout();
  }
  Future<void> setFCMToken(String pushtoken)async{
    moengagePlugin.passFCMPushToken(pushtoken);
  }
  void passFCMPushPayload(Map<String, dynamic> payload) async {
    print('Push notification clicked: $payload');
    if (Platform.isAndroid) {
      _controller.moEAndroid.passPushPayload(payload, MoEPushService.fcm, MOENGAGE_APP_ID);
    }
  }
  Future<void> SendAnalytics(Map<String,dynamic> data1,String name)async{
        var properties = MoEProperties();
     data1.forEach((k, v) {
           properties.addAttribute(k, v);
     });
        moengagePlugin.trackEvent(name,properties);
  }
  Future<void> SetUserProfile(String userid,mobile,name,email1,avatar) async {
    moengagePlugin.setUserName(name);
    // moengagePlugin.setFirstName("FirstName");
    // moengagePlugin.setLastName("LastName");
    moengagePlugin.setEmail(email1);
    moengagePlugin.setPhoneNumber(mobile);
    moengagePlugin.setUserAttribute("\$avatar", avatar);
    moengagePlugin.setUserAttribute("userid", userid);
    // moengagePlugin.setGender(MoEGender.male); // Supported values also include MoEGender.female OR MoEGender.other
    // moengagePlugin.setLocation(new MoEGeoLocation(23.1, 21.2)); // Pass coordinates with MoEGeoLocation instance


  }
  Future<void> SetUserIdentify(String name) async {
    moengagePlugin.setAlias(name);
  }

  Future<void> SetAnalyticsCollectionEnabled() async {
    moengagePlugin.enableDataTracking();
  }
  Future<void> SetAnalyticsCollectionDisabled() async {
    moengagePlugin.disableDataTracking();
  }
  Future<void> onPushClick(PushCampaignData message) async{
    print(message.toString()+"my notification");
    debugPrint(
        "$tag Main : _onPushClick(): This is a push click callback from native to flutter. Payload " + message.toString()
    );
  }

  void _onInAppClick(ClickData message) {
    debugPrint(
        "$tag Main : _onInAppClick() : This is a inapp click callback from native to flutter. Payload " +
            message.toString());
  }

  void _onInAppShown(InAppData message) {
    debugPrint(
        "$tag Main : _onInAppShown() : This is a callback on inapp shown from native to flutter. Payload " +
            message.toString());
  }

  void _onInAppDismiss(InAppData message) {
    debugPrint(
        "$tag Main : _onInAppDismiss() : This is a callback on inapp dismiss from native to flutter. Payload " +
            message.toString());
  }

  void _onInAppSelfHandle(SelfHandledCampaignData message) async {
    debugPrint("$tag Main : _onInAppSelfHandle() : This is a callback on inapp self handle from native to flutter. Payload " +
            message.toString());
    final SelfHandledActions action =
    await asyncSelfHandledDialog(Get.context!);
    switch (action) {
      case SelfHandledActions.Shown:
        moengagePlugin.selfHandledShown(message);
        break;
      case SelfHandledActions.Clicked:
        moengagePlugin.selfHandledClicked(message);
        break;
      case SelfHandledActions.Dismissed:
        moengagePlugin.selfHandledDismissed(message);
        break;
    }
  }

  void _onPushTokenGenerated(PushTokenData pushToken) {
    debugPrint(
        "$tag Main : _onPushTokenGenerated() : This is callback on push token generated from native to flutter: PushToken: " +
            pushToken.toString());
  }

  void _permissionCallbackHandler(PermissionResultData data) {
    debugPrint("$tag Permission Result: " + data.toString());
  }
}