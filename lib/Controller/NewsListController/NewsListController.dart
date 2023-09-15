

import 'dart:developer';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Model/News/NewsListModal.dart';
import 'package:Repeople/Model/Theme/WidgetThemeListClass.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Config/Helper/ApiResponse.dart';
import '../../Model/News/NewsModal.dart';
import '../CommonHeaderController/CommenHeaderController.dart';

class NewsListController extends GetxController {
  RxList<WidgetThemeListClass> arrAllTheme = RxList<WidgetThemeListClass>();
  RxList<WidgetThemeListClass> arrSetTheme = RxList<WidgetThemeListClass>();

  RxList<NewsListClass> arrImportantNews = RxList<NewsListClass>();

  RxList<NewsListClass> arrNewsList = RxList<NewsListClass>();
  Rx<Future<List<NewsListClass>>> futurenewsData = Future.value(<NewsListClass>[]).obs;

  RxList<NewsListModal> arrNewsListnew = RxList<NewsListModal>();
  Rx<Future<List<NewsListModal>>> futurenewsDatanew = Future.value(<NewsListModal>[]).obs;


  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());
  GlobalKey<ScaffoldState> GlobalNewsPagekey = GlobalKey<ScaffoldState>();

  RxString message = "".obs;
  String url = "";

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    // futurenewsData.value = RetrieveNewsData();
    // futurenewsData.refresh();
    futurenewsDatanew.value = RetrieveNewsData();
    futurenewsDatanew.refresh();

    //
  }

  CreateImportantNews() {
    // arrImportantNews.add(NewsListModal(IMG_BUILD3, "$lblBookYourSiteDesc ", "05 june, 2021"));
    //
    // arrImportantNews.refresh();
  }

  Future<List<NewsListModal>> RetrieveNewsData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    arrNewsListnew = RxList([]);
    print("test");
    Map<String,dynamic> data = {
      'action': 'listnews',
      'nextpage': "1",
      'perpage': "20",
      'ordby': "1",
      'ordbycolumnname': "id",
      //'filter':''
    };

    var headers = {
      // "Authorization":"JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJ1c2VybmFtZSI6IjkxNjc4NzYwMjgiLCJleHAiOjE5MjkwOTkyMzUsImVtYWlsIjpudWxsLCJtb2JpbGVfbm8iOiI5MTY3ODc2MDI4Iiwib3JpZ19pYXQiOjE2MTM3MzkyMzUsImRldmljZV9pZCI6ImFiYyIsImJ1aWxkZXJfaWQiOiJyYXVuYWstZ3JvdXAiLCJndWVzdCI6ZmFsc2UsInVzZXJfdHlwZSI6Ik1hc3RlciBBZG1pbiIsInVzZXJfdHlwZV9pZCI6LTF9.oEqoeFWiljm6pylULqBL7IHzm1IJOHFh8xKJk1_TTKU",
      // "content-type":"application/json"
      //'userpagename': 'master',
      //  'useraction': 'viewright',
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",

      // 'cmpid': "60549434a958c62f010daa2f"
    };
    print("headeers");
    ApiResponse response = ApiResponse(
      data: data,
      base_url: URL_NEWSS,
      apiHeaderType: ApiHeaderType.Content,
      headerdata: headers,
    );

    print(headers);

    Map<String, dynamic>?  responseData = await response.getResponse();
    print("responseData");
    log(responseData.toString());

    if (responseData!['status'] == 1) {

      List result = responseData['data'];
      arrNewsListnew.value = List.from(result.map((e) => NewsListModal.fromJson(e)));
      arrNewsListnew.refresh();

      print(arrNewsListnew.length);

      // RetrieveConstructionData();
      // RetrievePlotVillaData();

    } else {
      // print(message.value.toString()+"message");
      message.value = responseData['message'];

    }
    return arrNewsListnew;

  }
}
