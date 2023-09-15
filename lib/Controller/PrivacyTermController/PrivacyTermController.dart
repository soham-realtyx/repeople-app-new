import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Model/Theme/WidgetThemeListClass.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Config/Helper/ApiResponse.dart';
import '../../Config/utils/styles.dart';
import '../../Model/PrivacyPolicyModel/PrivacyPolicyModal.dart';
import '../../Model/ReferralModal/RefferralNewTermsAndCondition.dart';
import '../../Widgets/ShimmerWidget.dart';
import '../CommonHeaderController/CommenHeaderController.dart';

class PrivacyTermController extends GetxController {
  RxList<WidgetThemeListClassWithTitle> arrAllTheme = RxList<WidgetThemeListClassWithTitle>();
  RxList<WidgetThemeListClassWithTitle> arrSelectedTheme = RxList<WidgetThemeListClassWithTitle>();

  GlobalKey<ScaffoldState> Globalprivacypolicykey = GlobalKey<ScaffoldState>();


  RxString pagetitle="".obs;

  //new RxList Declaration
  RxList<RefferAFriendTermsAndConditionModel> arrTermsAndCondition = RxList([]);
  RxList<RefferAFriendTermsAndConditionModel> arrPrivacyPolicy = RxList([]);

  //Future Declaration
  Rx<Future<List<RefferAFriendTermsAndConditionModel>>> futureTermsAndCondition = Future.value(<RefferAFriendTermsAndConditionModel>[]).obs;
  Rx<Future<List<RefferAFriendTermsAndConditionModel>>> futurePrivacyPolicy = Future.value(<RefferAFriendTermsAndConditionModel>[]).obs;

  // RxVariable Declaration
  RxString  IsTermsConditionEmpty = ''.obs;
  RxString  IsPrivacyEmpty = ''.obs;


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  LoadPage() {
    futureTermsAndCondition.value=RetrieveTermsAndConditionData();
    futurePrivacyPolicy.value=RetrievePrivacyPolicyData();
  }

  //<editor-fold desc = "Api Calls">
  Future<List<RefferAFriendTermsAndConditionModel>> RetrieveTermsAndConditionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    try{
      arrTermsAndCondition = RxList([]);
      var data = {'action': 'listtermscondition'};

      var headers = {'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",};

      ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_TERMS_AND_CONDITION,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers,
      );
      Map<String, dynamic>? responseData = await response.getResponse();

      if (responseData!['status'] == 1) {
        List result = responseData['data'];
        arrTermsAndCondition.value =
            List.from(result.map((e) => RefferAFriendTermsAndConditionModel.fromJson(e)));
        arrTermsAndCondition.refresh();
      }
      else{
        IsTermsConditionEmpty.value=responseData['message'] ?? "No Data Found";
      }


    }catch(e){
      IsTermsConditionEmpty.value= "No Data Found";
    }

    return arrTermsAndCondition;
  }

  Future<List<RefferAFriendTermsAndConditionModel>> RetrievePrivacyPolicyData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    try{
      arrPrivacyPolicy = RxList([]);
      var data = {'action': 'listprivacypolicy'};

      var headers = {'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",};

      ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_PRIVACYPLOICYLIST,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers,
      );
      Map<String, dynamic>? responseData = await response.getResponse();

      if (responseData!['status'] == 1) {
        List result = responseData['data'];
        arrPrivacyPolicy.value =
            List.from(result.map((e) => RefferAFriendTermsAndConditionModel.fromJson(e)));
        arrPrivacyPolicy.refresh();
      }
      else{
        IsPrivacyEmpty.value=responseData['message'] ?? "No Data Found";
      }


    }catch(e){
      IsPrivacyEmpty.value= "No Data Found";
    }

    return arrPrivacyPolicy;
  }


}
