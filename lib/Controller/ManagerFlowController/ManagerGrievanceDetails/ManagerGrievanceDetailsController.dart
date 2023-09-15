import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Helper/shared_prefrence.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Config/Constant.dart';
import '../../../Config/Helper/ApiResponse.dart';
import '../../../Model/CommonModal/CommonModal.dart';
import '../../../Model/ComplaintModel/ComplaintListModel.dart';
import '../../../Model/ComplaintModel/GrievanceDetailsModel.dart';
import '../../CommonHeaderController/CommenHeaderController.dart';

class ManagerGrievaceDetailsController extends GetxController{

  //RxList Declaration
  RxList<GrievanceListModel> arrGrievanceList = RxList<GrievanceListModel>([]);
  RxList<CommonModal> arrFillterList = RxList([]);

  //futureValue Declaration
  Rx<Future<List<GrievanceListModel>>> futureGrievanceData = Future.value(<GrievanceListModel>[]).obs;
  Rx<Future<List<dynamic>>> futuretablist = Future.value(<dynamic>[]).obs;

  //RxVariable Declartion
  RxString message = ''.obs;
  RxString projectid = ''.obs;
  RxInt loadmore = 0.obs;
  RxInt pagecount = 1.obs;

  //texteditingContoller
  TextEditingController txtSubject = TextEditingController();

  //Rx<type> declaration
  Rx<CommonModal> obj_subject = CommonModal().obs;

  //onInit
  @override
  void onInit() async{
    // ToDo: do your own code
    super.onInit();
    getGrievancefillterlist();
  }

  getGrievancefillterlist(){
    arrFillterList=RxList([]);
    arrFillterList.add(CommonModal(id: "",name: "All"));
    arrFillterList.add(CommonModal(id: "1",name: "Pending"));
    // arrFillterList.add(CommonModal(id: "Reopen",name: "Reopen"));
    arrFillterList.add(CommonModal(id: "2",name: "Colse"));


    obj_subject.value = arrFillterList[0];
    txtSubject.text = obj_subject.value.name!;
  }


  Future<List<GrievanceListModel>> RetrieveGrievanceListData() async {
    arrGrievanceList = RxList([]);
    SharedPreferences sp = await SharedPreferences.getInstance();
    var data = {
      'action': 'listraisegrievance',
      'nextpage': pagecount,
      'perpage': 10,
      'ordby': "1",
      'ordbycolumnname': "_id",
      "fltprojectid":projectid.value,
    if(obj_subject.value.id !=null && obj_subject.value.id !="")  "fltstatus":obj_subject.value.id.toString()
    };

    var headers = {'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??""};

    ApiResponse response = ApiResponse(
      data: data,
      base_url: URL_GRIEVANCE_LIST,
      apiHeaderType: ApiHeaderType.Content,
      headerdata: headers);
    Map<String, dynamic>? responseData = await response.getResponse();
    if (responseData!['status'] == 1) {
      List result = responseData['data'];
      loadmore.value = responseData['loadmore'];
      arrGrievanceList.value = List.from(result.map((e) => GrievanceListModel.fromJson(e)));
      arrGrievanceList.refresh();

    } else {
      message.value = responseData['message'];
    }
    return arrGrievanceList;
  }





}