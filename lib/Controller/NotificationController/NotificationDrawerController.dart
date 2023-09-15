
import 'dart:convert';
import 'dart:developer';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Helper/ApiResponse.dart';
import 'package:Repeople/Model/NotificationSettingModel/NotificationSettingModel.dart';
import 'package:Repeople/Widgets/CommomBottomSheet.dart';
import 'package:Repeople/Widgets/Loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Repeople/Model/Theme/WidgetThemeListClass.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef void OnTaplogoutbutton();

class NotificationDrawerController extends GetxController {
  RxList<WidgetThemeListClass> arrDrawerList = RxList<WidgetThemeListClass>();
  RxList<WidgetThemeListClass> arrFooterList = RxList<WidgetThemeListClass>();


  RxList<CustomListModel> arrnotificationCustomList = RxList<CustomListModel>();
  RxString notificationName="".obs;
  RxString notificationMessage="".obs;
  RxString fetchNotificationMessage="".obs;

  GlobalKey<ScaffoldState> GlobalNotificationkey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> GlobalNotificationSettingkey = GlobalKey<ScaffoldState>();

  Rx<CategorySelect>? notificatioSetting = CategorySelect.All.obs;
  RxList<String> arrNotificationList2 = RxList<String>();
  List<bool> checkedItems = List.generate(4, (index) => false);
  RxList<NotificationSettingModel> arrNotificationSettingList = RxList([]);
  RxList<NotificationSettingModel> arrFetchNotificationSetting = RxList([]);
  Rx<NotificationSettingModel> objNotificationSetting = NotificationSettingModel().obs;
  Rx<NotificationSettingModel> objNotification = NotificationSettingModel().obs;
  Rx<Future<List<NotificationSettingModel>>> futureNotificationSetting = Future.value(<NotificationSettingModel>[]).obs;


  var customValue = '';
  RxBool? isSelected=false.obs;
  @override
  void onInit() async {
    super.onInit();
    CustomList();
    // notificationSettingData().whenComplete(() {});
    // fetchNotificationSetting();
  }

  Future<RxList<NotificationSettingModel>> notificationSettingData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    arrNotificationSettingList = RxList([]);
    var data = {
      'action': 'listcustomnotification',
    };
    var headers = {
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE) ?? ""
    };

    ApiResponse response = ApiResponse(
      data: data,
      base_url: notificationSettingURL,
      apiHeaderType: ApiHeaderType.Content,
      headerdata: headers,
    );

    Map<String, dynamic>? responseData = await response.getResponse();
    log("$responseData listCustomNotification");
    try{
      if (responseData!['status'] == 1) {
        List<dynamic> result = responseData['data'];
        arrNotificationSettingList.value = List.from(result.map((e) => NotificationSettingModel.fromJson(e)));
        arrNotificationSettingList.refresh();

        // objNotificationSetting.value=responseData['notificationcategory'];
        // fillNotification(arrNotificationSettingList);
      }else{
        return notificationMessage.value = responseData['message'];
      }
    }catch(e){
      print(e.toString()+" my propertiesDetails error");
    }
    return arrNotificationSettingList;
  }

  Future<void> addNotificationSetting() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    appLoader(contextCommon);
    Map<String, dynamic> data = {};//json.encode(arrNotificationSettingList.toJson())
    data['action'] = 'insertcustomnotification';
    data['customnotification'] = notificatioSetting?.value == CategorySelect.All?"%":json.encode(arrNotificationList2.toJson());
    var headerdata = {
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",
    };
    debugPrint("add notificationSetting data * *  $data");
    ApiResponse response = ApiResponse(
        data: data,
        base_url: notificationSettingURL,
        headerdata: headerdata,
        apiHeaderType: ApiHeaderType.Content);
    Map<String, dynamic>? responseData = await response.getResponse();

    if (responseData!['status'] == 1) {
      removeAppLoader(contextCommon);
      Get.back();
      SuccessMsg(responseData['message']);
      arrNotificationSettingList.clear();
    } else {
      removeAppLoader(contextCommon);
      validationMsg(responseData['message']);
    }
  }

  fillNotification(NotificationSettingModel obj)async{
    objNotificationSetting.value.isSelected = obj.isSelected;
    // if(obj.notificationCategory!=null && obj.notificationCategory!=""){
      // fetchNotificationSetting().whenComplete(() {
      //   objNotificationSetting.value = arrNotificationSettingList.singleWhere((element) =>
      //   element.isSelected ==
      //       obj.isSelected,
      //       orElse: () => NotificationSettingModel());
      //   print(obj.notificationCategory);
      //   print(objNotificationSetting.value.notificationCategory);
      //   print("obj.notificationCategory");
      //
      //
      //   // arrNotificationSettingList.value = objNotificationSetting.value.notificationCategory ?? "";
      //   arrNotificationSettingList.refresh();
      // });
    // }
  }

  Future<RxList<NotificationSettingModel>> fetchNotificationSetting() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    try{
      arrNotificationSettingList = RxList([]);
      var data = {
        'action': 'fetchcustomnotification',
      };

      var headers = {
        'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",
      };

      ApiResponse response = ApiResponse(
        data: data,
        base_url: notificationSettingURL,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers,
      );
      Map<String, dynamic>? responseData = await response.getResponse();
      log("$responseData fetchNotificationSetting");
      if (responseData!['status'] == 1) {
        List<dynamic> result = responseData['data']['customnotification'];
        arrNotificationSettingList.value = List.from(result.map((e) => NotificationSettingModel.fromJson(e)));
        print(responseData['data']['customnotification']);
        arrNotificationSettingList.refresh();

        objNotificationSetting.value=arrNotificationSettingList[0];
        fillNotification(objNotificationSetting.value);
      }
      else{
        fetchNotificationMessage.value=responseData['message'] ?? "No Data Found";
      }
    }catch(e){
      print(e.toString()+" fetchNotificationMessage");
      fetchNotificationMessage.value= "No Data Found";
    }
    futureNotificationSetting.refresh();
    return arrNotificationSettingList;
  }

  CustomList(){
    arrnotificationCustomList = RxList([
      CustomListModel(title: "Critical Update",isSelected: true.obs),
      CustomListModel(title: "New Project Addition",isSelected: false.obs),
      CustomListModel(title: "Favorite Project Update",isSelected: false.obs),
      CustomListModel(title: "Favorite Project Update",isSelected: false.obs),
      CustomListModel(title: "My Project Update",isSelected: false.obs),
      CustomListModel(title: "New Offer Update",isSelected: false.obs),
      CustomListModel(title: "Demand Update",isSelected: false.obs),
      CustomListModel(title: "New Notice",isSelected: false.obs),
      CustomListModel(title: "Grievance Update",isSelected: false.obs),
    ]);
  }

}
enum CategorySelect { All, Custom }

class CustomListModel {
  String? title;
  Color? color;
  RxBool? isSelected=false.obs;
  CustomListModel({
    this.title,this.color,this.isSelected
  });
}