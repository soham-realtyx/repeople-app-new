import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Helper/ApiResponse.dart';
import 'package:Repeople/Config/Helper/HextoColor.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Model/VisitorModel/VisitorRequestModel.dart';
import 'package:Repeople/Model/VisitorModel/VisitorResponseModel.dart';
import 'package:Repeople/Widgets/CommomBottomSheet.dart';
import 'package:Repeople/Widgets/Loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../Config/Constant.dart';
import '../../Config/Function.dart';
import '../../Config/utils/Images.dart';
import '../../Config/utils/Strings.dart';
import '../../Config/utils/colors.dart';
import '../../Widgets/CustomDecoration.dart';
import '../../Widgets/ShimmerWidget.dart';
import '../BottomNavigator/BottomNavigatorController.dart';
import '../CommonHeaderController/CommenHeaderController.dart';

class VisitorController extends GetxController{

  late TabController tabController;
  RxList<RequestUserList> arrProjectDetailsList = RxList<RequestUserList>([]);
  Rx<Future<List<RequestUserList>>> futureRequestData = Future.value(<RequestUserList>[]).obs;
  Rx<Future<List<RequestUserList>>> futuretablist = Future.value(<RequestUserList>[]).obs;
  RxList<VisitorResponseModel> responceuserlist = RxList<VisitorResponseModel>([]);
  Rx<Future<List<VisitorResponseModel>>> futureresponcelist = Future.value(<VisitorResponseModel>[]).obs;
  RxBool ismainpage=true.obs;
  RxString Requestmessage="".obs;
  RxString Responsemessage="".obs;
  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());
  GlobalKey<ScaffoldState> GlobalCo_OwnerPagekey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = ScrollController();
  RxInt _loadMore = 0.obs;
  RxInt _pageCount = 1.obs;
  RxBool ResponseTap = true.obs;
  RxBool RequestTap = true.obs;
  ScrollController scrollControllerresponse = ScrollController();
  RxInt _loadMoreresponse = 0.obs;
  RxInt _pageCountresponse = 1.obs;
  RxString visitor_id = "".obs;
  Future<void> onRefresh() async {
    Restart();
  }
LoadData(){

  futureRequestData.value = RetriveRequestUserData();
  futureRequestData.refresh();
  futureresponcelist.value=RetriveResponseUserData();
  futureresponcelist.refresh();
}

  Restart(){

    _loadMoreresponse = 0.obs;
    _pageCountresponse = 1.obs;



    futureresponcelist.value=RetriveResponseUserData();
    futureresponcelist.refresh();
  }
  RequestRestart(){
    _loadMore = 0.obs;
    _pageCount = 1.obs;
    futureRequestData.value = RetriveRequestUserData();
    futureRequestData.refresh();
  }
  RefreshRequest(){
    _loadMore = 0.obs;
    _pageCount = 1.obs;
    futureRequestData.value = RetriveRequestUserData();
    futureRequestData.refresh();

  }
  RefreshResponse(){
    _loadMoreresponse = 0.obs;
    _pageCountresponse = 1.obs;
    futureresponcelist.value=RetriveResponseUserData();
    futureresponcelist.refresh();
  }
  scrollUpdate(ScrollController scrollController) {
    var maxScroll = scrollController.position.maxScrollExtent;
    var currentPosition = scrollController.position.pixels;
    if (maxScroll == currentPosition) {
      if (_loadMore.value == 1) {
        _pageCount.value++;
        RetriveRequestUserData();
      }
    }
  }
  scrollUpdateResponse(ScrollController scrollController) {
    var maxScroll = scrollController.position.maxScrollExtent;
    var currentPosition = scrollController.position.pixels;

    if (maxScroll == currentPosition) {

      if (_loadMoreresponse.value == 1) {
        _pageCountresponse.value++;
        RetriveResponseUserData();
      }
    }
  }
  Future<List<RequestUserList>> RetriveRequestUserData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if(_pageCount.value==1){
    arrProjectDetailsList = RxList([]);}
    var data = {
      'action': 'listuservisitor',
      "perpage":"10",
      "nextpage":_pageCount.value.toString(),

    };
    if(visitor_id.value.isNotEmpty){
      data.addAll({'id': visitor_id.value.trim().toString(),});
    }

    var headers = {
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",
    };

    ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_USERPROFILEDETAILS,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers);

    Map<String, dynamic>? responseData = await response.getResponse();

    if (responseData!['status'] == 1) {
      List result = responseData['data'];
      _loadMore.value = responseData['loadmore'];
      _loadMore.refresh();
      List<RequestUserList> arrTempList = [];
      arrTempList = List<RequestUserList>.from(result.map((e) => RequestUserList.fromJson(e)));
      arrProjectDetailsList.addAll(arrTempList);
      arrProjectDetailsList.refresh();

      RequestTap.value=true;
    } else {
      Requestmessage.value = responseData['message'];
      RequestTap.value=true;
    }
    return arrProjectDetailsList;

  }
  Future<void> UpdateVisitorRequest(int status,String visitorid) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    appLoader(contextCommon);
    var data = {
      'action': 'editvisitorrequest',
      "accept_request":status.toString(),
      "visitorid":visitorid.toString(),

     // 'ordbycolumnname': "id",
      //"filter":"",
     // "favourite":"true"

    };
    var headers = {
      // 'userpagename': 'master',
      // 'useraction': 'viewright',
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",
      // 'cmpid': "60549434a958c62f010daa2f"
    };

    ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_USERPROFILEDETAILS,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers);

    Map<String, dynamic>? responseData = await response.getResponse();

    if (responseData!['status'] == 1) {
      RefreshRequest();
       removeAppLoader(contextCommon);

   SuccessMsg(responseData['message']);
    } else {
       removeAppLoader(contextCommon);
      validationMsg(responseData['message']);
    }
  }

  Future<List<VisitorResponseModel>> RetriveResponseUserData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if(_pageCountresponse.value==1){
      responceuserlist = RxList([]);}
    var data = {
      'action': 'listvisitorrequest',
      "perpage":"10",
      "nextpage":_pageCountresponse.value.toString(),
    };

    var headers = {
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",
    };

    ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_USERPROFILEDETAILS,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers);

    Map<String, dynamic>? responseData = await response.getResponse();
    if (responseData!['status'] == 1) {
      List result = responseData['data'];
      _loadMoreresponse.value = responseData['loadmore'];
      _loadMoreresponse.refresh();
      List<VisitorResponseModel> arrTempList = [];
      arrTempList = List<VisitorResponseModel>.from(result.map((e) => VisitorResponseModel.fromJson(e)));
      responceuserlist.addAll(arrTempList);
      responceuserlist.refresh();
      ResponseTap.value=true;
    } else {
      Responsemessage.value = responseData['message'];
      ResponseTap.value=true;
    }

    return responceuserlist;
  }



  restart() {
    arrProjectDetailsList.clear();
    arrProjectDetailsList.refresh();
    update();
  }

  AcceptBottomSheet(int index){
    bottomSheetDialog(
        backgroundColor: APP_THEME_COLOR,
        child: AlertDialogButton(
          "Are you sure you want to accept visitor?",
          TotalButton.TWO,
          "Yes",
          "No",
              () => {
            Get.back(),

                UpdateVisitorRequest(1, arrProjectDetailsList[index].id??"")

            // arrFavProjectDataList.refresh(),

            // Get.back(),
            // Get.back(),
          },
              () => {
            Get.back(),
          },
          APP_THEME_COLOR,
          AppColors.APP_GRAY_COLOR,
          mediumTextStyle(txtColor: Colors.white),
          // TextStyle(color:Colors.white),
          mediumTextStyle(txtColor: Colors.black),
          // TextStyle(color: Colors.black)
        ),
        // TextStyles.textStyleDark14(AppColors.WHITE),
        // TextStyles.textStyleDark14(AppColors.BLACK)),
        // context: context,
        message: "Visitor");

  }

  Widget TabShimmerEffect() {
    return Container(
        height: 50,
        margin: EdgeInsets.only(left: 10, right: 10, top: 5),
        child: ShimmerEffect(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (_, index) {
              return Padding(
                padding:
                const EdgeInsets.only(top: 5.0, bottom: 5, left: 1, right: 1),
                child: shimmerWidget(width: 80, height: 50, radius: 0),
              );
            },
            itemCount: 1,
          ),
        ));
  }


  ClosePageCallback(){
    var getPageStringList = Get.currentRoute.split(" ");
    String pageName = getPageStringList.last;
    BottomNavigatorController cntBottom = Get.put(BottomNavigatorController());
    if(pageName == "ProjectListPage" || pageName == "FavoritePage"){
      cntBottom.SelectIndex(0);
    }
    else{
      Get.back();
    }

  }





}