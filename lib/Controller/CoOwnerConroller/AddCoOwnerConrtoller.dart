
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Helper/ApiResponse.dart';
import 'package:Repeople/Model/Flat%20ListModal/FlatListModal.dart';
import 'package:Repeople/Widgets/Loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Model/CoOwnerModel/AddCoOwnerModel.dart';
import '../../Widgets/CommomBottomSheet.dart';
import '../../Widgets/TextEditField.dart';
import '../CommonHeaderController/CommenHeaderController.dart';

class AddCoOwnerController extends GetxController {
  TextEditingController txt_building = TextEditingController();
  TextEditingController txt_mobile = TextEditingController();
  Rxn<TextEditingController> txtContactNew = Rxn(TextEditingController());
  var formkey = GlobalKey<FormState>();
  AddCoOwner? dropdownvalue;
  late Rx<AddCoOwner?> dropdownvalue1 = dropdownvalue.obs;
  AddCoOwner? dropdownvaluet;
  FlatListModal? dropdownvaluetnew;
  FlatListModal? dropdownvaluenew;
  late Rx<FlatListModal?> dropdownvalue1new = dropdownvaluenew.obs;
  late Rx<AddCoOwner?> dropdownvaluet1 = dropdownvaluet.obs;
  late Rx<FlatListModal?> dropdownvaluet1new = dropdownvaluetnew.obs;
  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());
  GlobalKey<ScaffoldState> GlobalAddCo_OwnerPagekey = GlobalKey<ScaffoldState>();
  RxList<FlatListModal> arrflatdataList = RxList<FlatListModal>([]);
  Rx<Future<List<FlatListModal>>> futureGrievanceData = Future.value(<FlatListModal>[]).obs;

  TextEditingController txtflat = TextEditingController();
  FlatListModal obj_flatlist = FlatListModal();
  AddCoOwner obj_phase = AddCoOwner();

  // RxList<AddCoOwner> arrphase = RxList([]);

  RxList<AddCoOwner> arrBrandList = RxList([
    AddCoOwner(buildingname: "Kalindi", flatno: "404", wing: "E"),
    AddCoOwner(buildingname: "Annpurna", flatno: "401", wing: "E"),
    AddCoOwner(buildingname: "Shalibhadra", flatno: "409", wing: "K"),
    AddCoOwner(buildingname: "Kalindi", flatno: "404", wing: "E"),
  ]);

  Future<void> onRefresh() async {
    update();
  }

  @override
  void onClose() {
    // TODO: implement dispose
    super.onClose();
    isocode1.value="";
    isocode1.obs;
    // isocode="";
    ccode="";
    //Get.delete<DashboardController>();
  }

  @override
  void onInit() {
    super.onInit();


  }

  Future<void> AddConerData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    appLoader(contextCommon);
    Map<String, dynamic> data = {};
    data['action'] = 'insertcowner';
    data['mobile'] = txtContactNew.value?.text.trim().toString();
    data['countrycodestr'] = "in";
    data['countrycode'] = "+91";
    data['unitdetails'] =  jsonEncode(obj_flatlist).toString();

    var headerdata = {
      //"useraction": "viewright",
      //"masterlisting": "false",
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",
    };
    debugPrint("insertcowner data * *  $data");
    ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_MEMBERS,
        headerdata: headerdata,
        apiHeaderType: ApiHeaderType.Content);
    Map<String, dynamic>? responseData = await response.getResponse();
    if (responseData!['status'] == 1) {
      removeAppLoader(contextCommon);
      Get.back(result: "1");
      SuccessMsg(responseData['message'], title: "Success");
     // restart();
      //SuccessMsg(responseData['message']);

    } else {
      removeAppLoader(contextCommon);
      validationMsg(responseData['message']);

    }
  }
  Future<List<FlatListModal>> RetrieveFlatListData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    arrflatdataList = RxList([]);
    var data = {'action': 'fillcustomerflat'};

    var headers = {
      // "Authorization":"JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJ1c2VybmFtZSI6IjkxNjc4NzYwMjgiLCJleHAiOjE5MjkwOTkyMzUsImVtYWlsIjpudWxsLCJtb2JpbGVfbm8iOiI5MTY3ODc2MDI4Iiwib3JpZ19pYXQiOjE2MTM3MzkyMzUsImRldmljZV9pZCI6ImFiYyIsImJ1aWxkZXJfaWQiOiJyYXVuYWstZ3JvdXAiLCJndWVzdCI6ZmFsc2UsInVzZXJfdHlwZSI6Ik1hc3RlciBBZG1pbiIsInVzZXJfdHlwZV9pZCI6LTF9.oEqoeFWiljm6pylULqBL7IHzm1IJOHFh8xKJk1_TTKU",
      // "content-type":"application/json"
      // 'userpagename': 'master',
      // 'useraction': 'viewright',
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",
      // 'cmpid': "60549434a958c62f010daa2f"
    };

    ApiResponse response = ApiResponse(
      data: data,
      base_url: URL_PROJECTLIST,
      apiHeaderType: ApiHeaderType.Content,
      headerdata: headers,
    );
    Map<String, dynamic>? responseData = await response.getResponse();



    if (responseData!['status'] == 1) {

      List result = responseData['owner_unitdetails'];
      arrflatdataList.value =
          List.from(result.map((e) => FlatListModal.fromJson(e)));
      arrflatdataList.refresh();
      obj_flatlist = arrflatdataList[0];
      for(int i=0;i<arrflatdataList.length;i++){
        if(arrflatdataList[i].projectid.toString()==dropdownvalue1new.value?.projectid){
          dropdownvaluenew=FlatListModal();
          dropdownvaluenew = arrflatdataList[i];
          dropdownvalue1new.value = arrflatdataList[i];
          dropdownvalue1new.update((val) { });
        }
      }
      update();

    }

    return arrflatdataList;
  }
}
