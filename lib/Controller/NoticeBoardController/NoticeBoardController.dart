import 'dart:convert';
import 'dart:developer';
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Model/ReferralModal/ReferralModal.dart';
import 'package:Repeople/Model/Theme/WidgetThemeListClass.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Config/Helper/ApiResponse.dart';
import '../../Config/utils/Images.dart';
import '../../Config/utils/colors.dart';
import '../../Model/UpdateModelClass/UpdateModelClass.dart';

class NoticeBoardController extends GetxController {
  RxList<WidgetThemeListClass> arrAllTheme = RxList<WidgetThemeListClass>();
  RxList<WidgetThemeListClass> arrFAQTheme = RxList<WidgetThemeListClass>();
  RxList<WidgetThemeListClass> arrTCTheme = RxList<WidgetThemeListClass>();
  RxList<ReferralFAQ> arrReferralFAQList = RxList<ReferralFAQ>();
  RxInt selectedButton = 0.obs;
  RxInt selectedQuestion = (-1).obs; // initialValue


  GlobalKey<ScaffoldState> GlobalNoticePagekey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> GlobalNoticeDetailsPagekey = GlobalKey<ScaffoldState>();

  //RxList Declaration
  RxList<UpdateModelClass> arrNoticeLIst = RxList([]);

  // FUTURE Declaration
  Rx<Future<List<UpdateModelClass>>> futurearrNoticedatalist =
      Future.value(<UpdateModelClass>[]).obs;

  // Rx Variable Declaration
  RxInt _loadMore = 0.obs;
  RxInt _pageCount = 1.obs;
  RxString isFaqsEmptyMsg = "".obs;

  RxList<dynamic> jobList = RxList<dynamic>([]);

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    futurearrNoticedatalist.value = RetrieveNoticeListData();
  }


  //showDialogFunc(context, img, title, desc) {
  showDialogFunc(context) {
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Material(
              type: MaterialType.transparency,
              child: Stack(children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  margin: EdgeInsets.only(
                      left: 20.w, right: 20.w, top: 20.w, bottom: 20.w),
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  height: 100.w,
                  //width: MediaQuery.of(context).size.width * 0.7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 10.w,
                      ),

                      Text(
                        "You’re invited!! To our app! Visit your nearby store for offers😊",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // Container(
                      //   // width: 200,
                      //   child: Align(
                      //     alignment: Alignment.center,
                      //     child: Text(
                      //       desc,
                      //       maxLines: 3,
                      //       style: TextStyle(fontSize: 15, color: Colors.grey[500]),
                      //       textAlign: TextAlign.center,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Positioned(
                  right: 10.0,
                  top: 5,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Align(
                      alignment: Alignment.topRight,
                      child: CircleAvatar(
                        radius: 14.0,
                        backgroundColor: APP_THEME_COLOR,
                        child: Icon(Icons.close, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ])),
        );
      },
    );
  }

  OnClickHandler(int index) {
    // Get.to(()=>NewsDetailsPage(obj: obj,));
    // Get.bottomSheet(Notice_board_details(index), isScrollControlled: true);
  }


  //<editor-fold desc = "Api Calles ">

  Future<List<UpdateModelClass>> RetrieveNoticeListData() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      arrNoticeLIst = RxList([]);
      var data = {
        'action': 'listnotice',
        'nextpage': _pageCount.value,
        'perpage': "10"
      };
      var headers = {
        'userlogintype': sp.getString(SESSION_USERLOGINTYPE) ?? ""
      };

      ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_UPDATES,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers,
      );
      Map<String, dynamic>? responseData = await response.getResponse();
      log(responseData.toString());
      if (_pageCount.value == 1) {
        arrNoticeLIst.clear();
      }

      if (responseData!['status'] == 1) {
        List result = responseData['result'];

        List<UpdateModelClass> arrTempList = [];
        arrTempList = List<UpdateModelClass>.from(
            result.map((e) => UpdateModelClass.fromJson(e)));
        arrNoticeLIst.addAll(arrTempList);
        arrNoticeLIst.refresh();

        _loadMore.value = responseData['loadmore'] ?? 0;
      } else {
        isFaqsEmptyMsg.value = responseData['message'];
        futurearrNoticedatalist.refresh();
      }
    } catch (e) {
      print("Notice screen issue" + e.toString());
    }

    return arrNoticeLIst;
  }

//</editor-fold>

  String setImage(String extension) {
    if (extension == "txt") {
      return IMG_FILEICON;
    } else if (extension == "pdf") {
      return IMG_PDFICON;
    } else if (extension == "xls" || extension == "xlsx") {
      return IMG_XLSICON;
    } else if (extension == "doc" || extension == "docx") {
      return IMG_DOCICON;
    } else if (extension == "ppt" || extension == "pptx") {
      return IMG_PPTICON;
    } else {
      return IMG_FILEICON;
    }
  }

  scrollUpdate(ScrollController scrollController) {
    var maxScroll = scrollController.position.maxScrollExtent;
    var currentPosition = scrollController.position.pixels;
    print(currentPosition);
    if (maxScroll == currentPosition) {
      if (_loadMore.value == 1) {
        print(_pageCount);
        _pageCount.value++;
        RetrieveNoticeListData();
      }
    }
  }
}
