import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Config/Constant.dart';
import '../../Config/Helper/ApiResponse.dart';
import '../../Config/Helper/NotificationListManager.dart';
import '../../Model/NotificationsModal/NotificationNewModel.dart';
import '../../Model/NotificationsModal/NotificationsModal.dart';
import '../CommonHeaderController/CommenHeaderController.dart';

class NotificationController extends GetxController{

  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());
  GlobalKey<ScaffoldState> GlobalNotificationPagekey = GlobalKey<ScaffoldState>();

  RxList<NotificationModal> arrnotificationList = RxList<NotificationModal>();
  Rx<Future<List<NotificationModal>>> futurenotificationData = Future.value(<NotificationModal>[]).obs;


  //Rx List Declaration
  RxList<NotificationApiCall> arrNotificationMainList = RxList<NotificationApiCall>();
  RxList<dynamic> arrNotificationUnreadList = RxList<dynamic>();

  //Future Declaration
  Rx<Future<List<NotificationApiCall>>> futureNotificationData = Future.value(<NotificationApiCall>[]).obs;

  //ScrollController
  ScrollController scrollController = ScrollController();


  // Rx Variable Declaration
  RxInt _loadMore = 0.obs;
  RxInt _pageCount = 1.obs;
  RxString isFaqsEmptyMsg = "".obs;


  @override
  void onInit(){
    super.onInit();

    notificationListReader();
  }

  notificationListReader()async{

    GetPendingNotificationList().then((value) {
      if(value != null && value !="" ){
        List<dynamic> pendinglist=json.decode(value);
        arrNotificationUnreadList.addAll(pendinglist);
        GetReadAllNotificationLists();
      }
      futureNotificationData.value=RetrieveNotificationListData();

    });
  }

  scrollUpdate(ScrollController scrollController) {
    var maxScroll = scrollController.position.maxScrollExtent;
    var currentPosition = scrollController.position.pixels;

    if (maxScroll == currentPosition) {
      if (_loadMore.value == 1) {
        _pageCount.value++;
        RetrieveNotificationListData();
      }
    }
  }




  Future<List<NotificationApiCall>> RetrieveNotificationListData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if(_pageCount.value==1){
      arrNotificationMainList = RxList([]);
    }

    try{

      var data = {
        'action': 'listnotification',
        'nextpage':_pageCount.value,
        'perpage': '10'
      };

      var headers = {'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??""};

      ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_NOTIFICATION,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers,
      );
      Map<String, dynamic>? responseData = await response.getResponse();
      if (responseData!['status'] == 1) {
        List result = responseData['result'];


        List<NotificationApiCall> arrTempList = [];
        arrTempList = List<NotificationApiCall>.from(result.map((e) => NotificationApiCall.fromJson(e)));
        arrNotificationMainList.addAll(arrTempList);
        arrNotificationMainList.refresh();

        _loadMore.value = responseData['loadmore'] ?? 0;

      }
      else{
        isFaqsEmptyMsg.value = responseData['message'];
        futureNotificationData.refresh();
      }

    }catch(e){
      isFaqsEmptyMsg.value='No Data Found';
    }

    return arrNotificationMainList;
  }



  
  
  
  
  
}