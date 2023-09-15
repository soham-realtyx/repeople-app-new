import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:Repeople/Widgets/select_dailog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Config/Constant.dart';
import '../../Config/Helper/ApiResponse.dart';
import '../../Model/CommonModal/CommonModal.dart';
import '../../Model/MyBuildingDirectoryModel/MyBuildingDirectoryModel.dart';
import '../../Widgets/ShimmerWidget.dart';
import '../BottomNavigator/BottomNavigatorController.dart';

class MyBuildingDirectoryController extends GetxController{

   late TabController categoryTabController;

   GlobalKey<ScaffoldState> GlobalMyBUildingDirectorieskey = GlobalKey<ScaffoldState>();

  RxList<CommonModal> arrOccupationList = RxList<CommonModal>([]);
  Rx<Future<List<CommonModal>>> futureOccupationData = Future.value(<CommonModal>[]).obs;
  RxList<DirectoryListModal> arrDirectoryListList = RxList<DirectoryListModal>([]);
  Rx<Future<List<DirectoryListModal>>> futureDirectoryListData = Future.value(<DirectoryListModal>[]).obs;
  CommonModal obj_project = CommonModal();

  RxList<Color> colorList = RxList([
    Color(0xFF006CB5),
    Color(0xFF4DD0E1),
    Color(0xFF898989),
  ]);

  Rxn<CommonModal> obj_Occupation = Rxn<CommonModal>();
  RxList<CommonModal> arrProjectList = RxList([]);
  Rx<Future<List<CommonModal>>> futureProjectListData = Future.value(<CommonModal>[]).obs;
  // RxList<String> arrProjectList1 = RxList(['Shaligram Felicity',
  //   'The Persuit of Happiness','Shaligram Signature']);
  TextEditingController txtProject = TextEditingController();
  RxInt SelectedIndex=0.obs;
   RxInt Indexselected = 0.obs;
  ScrollController scrollController = ScrollController();
  RxInt _loadMore = 0.obs;
  RxInt _pageCount = 1.obs;
  RxString message = "".obs;
  RxString projectID = "".obs;
  RxString project_id = "".obs;

  Future<void> onRefresh() async {
    // restart();
  }

  restart() {
    _loadMore = 0.obs;
    _pageCount = 1.obs;
    arrProjectList.clear();
    futureProjectListData.value=RetrieveProjectListData().whenComplete(() {
      arrOccupationList.clear();
     futureOccupationData.value= RetrieveOccupationListData().whenComplete(() {
       arrDirectoryListList.clear();
       futureDirectoryListData.value=RetrieveBuildingDirectoryListData();
       futureDirectoryListData.refresh();
       arrDirectoryListList.refresh();
     });
     futureOccupationData.refresh();
      arrOccupationList.refresh();
    });
    futureProjectListData.refresh();
    arrProjectList.refresh();
    update();

  }




  Future<List<CommonModal>> RetrieveProjectListData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    arrProjectList = RxList([]);
    var data = {'action': 'fillproject'};

    var headers = {
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",
    };

    ApiResponse response = ApiResponse(
      data: data,
      base_url: URL_PROJECTLIST,
      apiHeaderType: ApiHeaderType.Content,
      headerdata: headers,
    );
    Map<String, dynamic>? responseData = await response.getResponse();

    if (responseData!['status'] == 1) {
      List result = responseData['result'];
      arrProjectList.value =
          List.from(result.map((e) => CommonModal.fromJson(e)));
      arrProjectList.refresh();
      obj_project = arrProjectList[0];
      txtProject.text = obj_project.name!;

    }

    return arrProjectList;
  }
  Future<List<CommonModal>> RetrieveOccupationListData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    arrOccupationList = RxList([]);
    var data = {
      'action': 'filloccupation',
      'projectid': obj_project.id??projectID.value,
    };
    var headers = {'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",};

    ApiResponse response = ApiResponse(
      data: data,
      base_url: URL_DIRECTORY,
      apiHeaderType: ApiHeaderType.Content,
      headerdata: headers,
    );
    Map<String, dynamic>? responseData = await response.getResponse();

    if (responseData!['status'] == 1) {
      List result = responseData['data'];
      arrOccupationList.value =
          List.from(result.map((e) => CommonModal.fromJson(e)));
      arrOccupationList.refresh();
      obj_Occupation.value = arrOccupationList[0];
    }

    return arrOccupationList;
  }


  Future<List<DirectoryListModal>> RetrieveBuildingDirectoryListData({bool callinfromtab=false,String? Occupation_id})async {

    arrDirectoryListList=RxList([]);
    SharedPreferences sp = await SharedPreferences.getInstance();
    if(_pageCount.value==1 || callinfromtab){
      arrDirectoryListList = RxList([]);}
    var data = {
      'action': 'listcustomerdirectory',
      'perpage': '10',
      "nextpage":_pageCount.value.toString(),
      'ordbycolumnname': '_id',
      'ordby': '1',
      'projectid': obj_project.id??projectID.value,
      'occupationid': Occupation_id??"%",
    };
    var headers = {
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",
    };

    ApiResponse response = ApiResponse(
      data: data,
      base_url: URL_DIRECTORY,
      apiHeaderType: ApiHeaderType.Content,
      headerdata: headers,
    );
    Map<String, dynamic>? responseData = await response.getResponse();
    try{
      if (responseData!['status'] == 1) {
        List result = responseData['result'];
        //_loadMore.value = responseData['loadmore'];
        //_loadMore.refresh();
        List<DirectoryListModal> arrTempList = [];
        arrTempList = List<DirectoryListModal>.from(result.map((e) => DirectoryListModal.fromJson(e)));
        arrDirectoryListList.addAll(arrTempList);
        arrDirectoryListList.refresh();
      }else{
        message.value=responseData['message'];
        refresh();
      }
    }catch(ex){
      print(ex.toString());
    }

    return arrDirectoryListList;
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

  SelectProject() {
    SelectProjectDialog((value) {
      obj_project=value;
      txtProject.text = obj_project.name??"";
      RetrieveOccupationListData();
    });
  }
  scrollUpdate(ScrollController scrollController) {
    var maxScroll = scrollController.position.maxScrollExtent;
    var currentPosition = scrollController.position.pixels;

    if (maxScroll == currentPosition) {
      if (_loadMore.value == 1) {
        _pageCount.value++;
        RetrieveBuildingDirectoryListData();
      }
    }
  }
  Future<dynamic> SelectProjectDialog(ValueChanged<dynamic> onChange) {
    return SelectDialog1.showModal<CommonModal>(
      Get.context!,
      label: "Select Project",
      items: arrProjectList,
      onChange: onChange,
      searchBoxDecoration:
      const InputDecoration(prefixIcon: Icon(Icons.search), hintText: "Search"),
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

  Future<void> makePhoneCall(String url) async {    try{
    if (await canLaunch('tel:'+url)) {
      await launch('tel:'+url);
    } else {
      throw 'Could not launch $url';
    }
  }catch(ex){
    Fluttertoast.showToast(msg: 'error in call');
    print(ex.toString());
  }
  }
}