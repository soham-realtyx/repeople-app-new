import 'dart:developer';

import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Model/Awards/AwardsModal.dart';
import 'package:Repeople/Model/Theme/WidgetThemeListClass.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Config/Helper/ApiResponse.dart';
import '../../Model/Awards/AwardsModalNew.dart';
import '../CommonHeaderController/CommenHeaderController.dart';

class AwardsController extends GetxController {
  RxList<WidgetThemeListClass> arrAllTheme = RxList<WidgetThemeListClass>();

  RxList<AwardsModal> arrAwardsDataList = RxList<AwardsModal>();

  RxList<AwardsNewModal> arrAwardsDataListNew = RxList<AwardsNewModal>();
  Rx<Future<List<AwardsNewModal>>> futureawardsDatalistnew =
      Future.value(<AwardsNewModal>[]).obs;

  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());
  GlobalKey<ScaffoldState> GlobalAwardsPagekey = GlobalKey<ScaffoldState>();

  RxString message = "".obs;
  String url = "";

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    futureawardsDatalistnew.value = RetrieveAwardsData();
    futureawardsDatalistnew.refresh();
    // RetrieveAwardsData();
  }


  Future<List<AwardsNewModal>> RetrieveAwardsData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    print("reached api function");
    arrAwardsDataListNew = RxList([]);
    Map<String, dynamic> data = {
      'action': 'listawards',
      'nextpage': "1",
      'perpage': "20",
      'ordby': "1",
      'ordbycolumnname': "id",
      'filter': "",
      // 'userlogintype': sp.getString(SESSION_USERLOGINTYPENAME),
    };

    var headers = {
      // "Authorization":"JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJ1c2VybmFtZSI6IjkxNjc4NzYwMjgiLCJleHAiOjE5MjkwOTkyMzUsImVtYWlsIjpudWxsLCJtb2JpbGVfbm8iOiI5MTY3ODc2MDI4Iiwib3JpZ19pYXQiOjE2MTM3MzkyMzUsImRldmljZV9pZCI6ImFiYyIsImJ1aWxkZXJfaWQiOiJyYXVuYWstZ3JvdXAiLCJndWVzdCI6ZmFsc2UsInVzZXJfdHlwZSI6Ik1hc3RlciBBZG1pbiIsInVzZXJfdHlwZV9pZCI6LTF9.oEqoeFWiljm6pylULqBL7IHzm1IJOHFh8xKJk1_TTKU",
      // "content-type":"application/json"
      //'userpagename': 'master',
      //'useraction': 'viewright',
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE) ?? "",

      // 'cmpid': "60549434a958c62f010daa2f"
    };

    ApiResponse response = ApiResponse(
      data: data,
      base_url: URL_AWARDS,
      apiHeaderType: ApiHeaderType.Content,
      headerdata: headers,
    );

    Map<String, dynamic>? responseData = await response.getResponse();
    log(responseData.toString());
    print("awards response");
    if (responseData!['status'] == 1) {
      List result = responseData['data'];

      try {
        arrAwardsDataListNew.value =
            List.from(result.map((e) => AwardsNewModal.fromJson(e)));
        arrAwardsDataListNew.refresh();
      } catch (e) {
        print(e);
      }
    } else {
      // print(message.value.toString()+"message");
      // message.value = responseData['message'];
    }
    return arrAwardsDataListNew;
  }

  showDialogFunc(context, img, title, desc) {
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
                  height: 400.w,
                  //width: MediaQuery.of(context).size.width * 0.7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 10.w,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: Image.asset(
                          img,
                          width: 200,
                          height: 200,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15,
                              color: gray_color,
                              fontWeight: FontWeight.w600,
                              fontFamily: fontFamily,
                              height: 1.5)),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        // width: 200,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            desc,
                            maxLines: 3,
                            style: TextStyle(
                                fontSize: 13,
                                color: gray_color_2,
                                fontFamily: fontFamily,
                                height: 1.5),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
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


}
