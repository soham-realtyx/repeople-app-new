import 'dart:developer';

import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Helper/ApiResponse.dart';
import 'package:Repeople/Model/LoginHistoryModel/LoginHistoryModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Repeople/Model/Theme/WidgetThemeListClass.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginHistoryController extends GetxController{
  RxList<WidgetThemeListClass> arrAllTheme = RxList<WidgetThemeListClass>();

  RxList<LoginHistoryModel> arrLoginHistoryList = RxList<LoginHistoryModel>();
  Rx<Future<List<LoginHistoryModel>>> futurePropertiesDetailsList =
      Future.value(<LoginHistoryModel>[]).obs;
  RxString message="".obs;

  GlobalKey<ScaffoldState> GlobalMyLoginHistoryPagekey = GlobalKey<ScaffoldState>();


  @override
  void onInit() {
    super.onInit();
    futurePropertiesDetailsList.value=loginHistoryData();
  }

  Future<RxList<LoginHistoryModel>> loginHistoryData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    arrLoginHistoryList = RxList([]);
    var data = {
      'action': 'listloginhistory',
      'uid': sp.getString(SESSION_UID)!,
    };

    var headers = {
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE) ?? ""
    };
    try{
      ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_loginHistory,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers,
      );

      Map<String, dynamic>? responseData = await response.getResponse();

      if (responseData!['status'] == 1) {
        List result = responseData['data'];
        arrLoginHistoryList.value = List.from(result.map((e) => LoginHistoryModel.fromJson(e)));
        arrLoginHistoryList.refresh();
      }else{
        return message.value = responseData['message'];
      }
    }catch(e){
      print(e.toString()+"my loginHistoryDetails error");
    }
    return arrLoginHistoryList;
  }

}


