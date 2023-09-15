
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Helper/ApiResponse.dart';
import 'package:Repeople/Widgets/CommomBottomSheet.dart';
import 'package:Repeople/Widgets/Loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Config/Constant.dart';
import '../../Config/Function.dart';
import '../../Config/utils/Images.dart';
import '../../Config/utils/colors.dart';
import '../../Model/CoOwnerModel/CoOwnerMainPageModel.dart';
import '../../Widgets/ShimmerWidget.dart';
import '../BottomNavigator/BottomNavigatorController.dart';

class CoOwnerMainPageController extends GetxController{

  late TabController tabController;
  RxList<CoOwnerModel> arrProjectDetailsList = RxList<CoOwnerModel>([]);
  Rx<Future<List<CoOwnerModel>>> futureData = Future.value(<CoOwnerModel>[]).obs;
  Rx<Future<List<CoOwnerModel>>> futuretablist = Future.value(<CoOwnerModel>[]).obs;
  RxList<CoOwnerModel> responceuserlist = RxList<CoOwnerModel>([]);
  Rx<Future<List<CoOwnerModel>>> futureresponcelist = Future.value(<CoOwnerModel>[]).obs;
  RxBool ismainpage=true.obs;
  RxString Requestmessage="".obs;
  RxString Responsemessage="".obs;

  GlobalKey<ScaffoldState> GlobalCo_OwnerPagekey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = ScrollController();
  RxInt _loadMore = 0.obs;
  RxInt _pageCount = 1.obs;
  ScrollController scrollControllerresponse = ScrollController();
  RxInt _loadMoreresponse = 0.obs;
  RxInt _pageCountresponse = 1.obs;

  Future<void> onRefresh() async {
    Restart();
  }
  LoadData(){
    futureData.value = RetriveRequestUserData();
    futureData.refresh();
    futureresponcelist.value=RetriveResponseUserData();
    futureresponcelist.refresh();
  }
  Restart(){
    _loadMore = 0.obs;
    _loadMoreresponse = 0.obs;
    _pageCount = 1.obs;
    _pageCountresponse = 1.obs;
    futureData.value = RetriveRequestUserData();
    futureData.refresh();
    futureresponcelist.value=RetriveResponseUserData();
    futureresponcelist.refresh();
  }
  RefreshRequest(){
    _loadMore = 0.obs;
    _pageCount = 1.obs;
    futureData.value = RetriveRequestUserData();
    futureData.refresh();

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
    print(currentPosition);
    if (maxScroll == currentPosition) {
      if (_loadMore.value == 1) {
        print("load more"+_pageCount.toString());
        _pageCount.value++;
        RetriveRequestUserData();
      }
    }
  }
  scrollUpdateResponse(ScrollController scrollController) {
    var maxScroll = scrollController.position.maxScrollExtent;
    var currentPosition = scrollController.position.pixels;
    //  print(currentPosition);
    if (maxScroll == currentPosition) {
      print("hasemore");
      if (_loadMoreresponse.value == 1) {
        _pageCountresponse.value++;
        RetriveResponseUserData();
      }
    }
  }

  restart() {
    arrProjectDetailsList.clear();
    arrProjectDetailsList.refresh();
    update();
  }

  Future<List<CoOwnerModel>> RetriveRequestUserData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if(_pageCount.value==1){
      arrProjectDetailsList = RxList([]);}
    var data = {
      'action': 'listcowner',
      "request":"add",
      //"perpage":"10",
      //"nextpage":_pageCount.value.toString(),
    };
    print(URL_PROJECTLISTDASHBOARD+"baseurl");
    var headers = {
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",
      // 'userpagename': 'property',
      // 'useraction': 'viewright',
      // 'cmpid': "60549434a958c62f010daa2f"
    };

    ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_MEMBERS,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers);

    Map<String, dynamic>? responseData = await response.getResponse();
    print(responseData.toString());
    if (responseData!['status'] == 1) {
      List result = responseData['data'];
      // _loadMore.value = responseData['loadmore'];
      // _loadMore.refresh();
      List<CoOwnerModel> arrTempList = [];
      arrTempList = List<CoOwnerModel>.from(result.map((e) => CoOwnerModel.fromJson(e)));
      arrProjectDetailsList.addAll(arrTempList);
      arrProjectDetailsList.refresh();
      print(arrProjectDetailsList.length);
    } else {
      Requestmessage.value = responseData['message'];
    }
    return arrProjectDetailsList;

  }
  Future<void> RemoveAddCoWnerRequest(String requestid) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    appLoader(contextCommon);
    var data = {
      'action': 'clearrequest',
      "requestid":requestid.toString(),

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
        base_url: URL_MEMBERS,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers);

    Map<String, dynamic>? responseData = await response.getResponse();

    print("member status"+data.toString());
    print("member status"+responseData.toString());
    if (responseData!['status'] == 1) {
      RefreshRequest();
      removeAppLoader(contextCommon);
      SuccessMsg(responseData['message']);
    } else {
      removeAppLoader(contextCommon);
      validationMsg(responseData['message']);
    }
  }
  Future<List<CoOwnerModel>> RetriveResponseUserData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if(_pageCountresponse.value==1){
      responceuserlist = RxList([]);}
    var data = {
      'action': 'listcowner',
      "request":"response",
      //"perpage":"10",
      "nextpage":_pageCountresponse.value.toString(),
    };
    // if(visitor_id.value.isNotEmpty){
    //   data.addAll({'id': visitor_id.value.trim().toString(),});
    // }
    print(URL_PROJECTLISTDASHBOARD+"baseurl");
    var headers = {
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",
    };

    ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_MEMBERS,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers);
    Map<String, dynamic>? responseData = await response.getResponse();

    if (responseData!['status'] == 1) {
      List result = responseData['data'];
      // _loadMoreresponse.value = responseData['loadmore'];
      // _loadMoreresponse.refresh();
      List<CoOwnerModel> arrTempList = [];
      arrTempList = List<CoOwnerModel>.from(result.map((e) => CoOwnerModel.fromJson(e)));
      responceuserlist.addAll(arrTempList);
      responceuserlist.refresh();
    } else {
      Responsemessage.value = responseData['message'];
    }
    return responceuserlist;
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
        )
    );
  }



  Widget Commitee_header(String title, GlobalKey<ScaffoldState> scaffoldKey) {
    return SafeArea(
      child: Container(
        // height: APPBAR_HEIGHT,
        color: white,
        padding: EdgeInsets.only(left: 10,right: 10),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      IconButton(onPressed: () => ClosePageCallback(), icon: Icon(Icons.arrow_back_ios)),
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(color: APP_FONT_COLOR, fontSize: 20, fontWeight: FontWeight.w600,),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  child: Row(
                    children: [
                      TrallingIconDrawer(IMG_MENU2, APP_FONT_COLOR,(){
                        scaffoldKey.currentState!.openEndDrawer();
                      })
                    ],
                  ),
                ),

              ],
            ),


          ],
        ),
      ),
    );
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