import 'dart:developer';

import 'package:Repeople/View/ProjectDetails/ProjectDetails.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Helper/MoengageAnalyticsHandler.dart';
import 'package:Repeople/Config/Helper/shared_prefrence.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Model/Dashbord/ProjectListClass.dart';
import 'package:Repeople/Model/ProjectDetails/Project_model.dart';
import 'package:Repeople/Model/Theme/WidgetThemeListClass.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Config/Helper/ApiResponse.dart';
import '../../Model/ProjectListModal/ProjectListModal.dart';
import '../../View/LoginPage/LoginPage.dart';
import '../../Widgets/CommomBottomSheet.dart';
import '../CommonHeaderController/CommenHeaderController.dart';

class ProjectController extends GetxController {
  RxList<ProjectModal> arrProjectDataList = RxList<ProjectModal>();
  RxList<TredingMOdel> arrTredingList = RxList<TredingMOdel>();
  RxList<ProjectListClass> arrProjectDataListnew = RxList<ProjectListClass>();
  RxList<ProjectModal> arrProjectDataSearchList = RxList<ProjectModal>();
  RxList<WidgetThemeListClass> arrProjectThemeWidget =
  RxList<WidgetThemeListClass>();
  RxList<WidgetThemeListClass> arrSelectedThemeWidget =
  RxList<WidgetThemeListClass>();
  ScrollController scrollController = ScrollController();
  Rx<Future<List<ProjectModal>>> futureprojectlist =
      Future.value(<ProjectModal>[]).obs;
  RxInt selectedProjectIndex = 0.obs;
  TextEditingController searchtxt = TextEditingController();
  FocusNode fcm_search = FocusNode();

  //new modal lists
  RxList<ProjectListModal> arrProjectlist = RxList<ProjectListModal>();

  RxList trendingList=RxList([]);
  Rx<Future<List<ProjectListModal>>> futurearrprojectlist =
      Future.value(<ProjectListModal>[]).obs;
  Rx<Future<List<ProjectListModal>>> futurearrprojectlistnew =
      Future.value(<ProjectListModal>[]).obs;
  CarouselController controller_event = CarouselController();
  RxInt current = 0.obs;
  int loadmore = 0;
  int pagecount = 1;
  bool isFilter = false;
  RxString message = "".obs;
  String url = "";
  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());

  // Rx Variable Declaration
  RxInt _loadMore = 0.obs;
  RxInt _pageCount = 1.obs;
  RxInt isTreding = 0.obs;
  RxBool islogin = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    islogin.value = UserSimplePreference.getbool(ISLOGIN) ?? false;
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  scrollUpdate(ScrollController? scrollController) {
    var maxScroll = scrollController?.position.maxScrollExtent;
    var currentPosition = scrollController?.position.pixels;

    if (maxScroll == currentPosition) {
      if (_loadMore.value == 1) {
        print("load more" + _pageCount.toString());
        _pageCount.value++;
        RetrieveProjectData();
      }
    }
  }

  LoginDialog() {
    LoginDialoge(
        dialogtext: "You should login first to proceed further.",
        stackicon: SvgPicture.asset(
          IMG_APPLOGO1_SVG,
          width: 40,
          height: 40,
          fit: BoxFit.fill,
          color: white,
        ),
        firstbuttontap: () {
          Get.back();
        },
        secondbuttontap: () {
          MoengageAnalyticsHandler().track_event("login");
          Get.back();
          Get.to(LoginPage());
        },
        secondbuttontext: "Yes",
        firstbuttontext: "No");
  }

  onSearch() {
    futurearrprojectlist.refresh();
  }

  onSearchTextChanged(String text) async {
    print("text" + text);
    pagecount = 1;
    arrProjectlist = RxList([]);
    if (text.isEmpty) {
      futurearrprojectlist.value = RetrieveProjectData();
      return;
    }
    futurearrprojectlist.value = RetrieveProjectData(filtter: text,trendingName: text);
  }

  LoadPage() {
    scrollController.addListener(() {
      scrollUpdate(scrollController);
    });
  }



  Future<List<ProjectListModal>> RetrieveProjectData(
      {String filtter = '', String? trendingName = 'false'}) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (_pageCount.value == 1) {
      arrProjectlist = RxList([]);
    }
    var data = {
      'action': 'listproject',
      'nextpage': _pageCount.value,
      'perpage': "10",
      'ordby': "1",
      'ordbycolumnname': "id",
      if (trendingName != null && trendingName != "")
        'trendingflt': trendingName ?? "false",


      if (filtter != null && filtter != "" && !filtter.contains("┤"))
        "filter": filtter ?? "",
      if (filtter != null && filtter != "" && filtter.contains("┤"))
        'filter':
        filtter.substring(filtter.indexOf("┤") + 1, filtter.indexOf("├")),
      "favourite": "false"
    };


    print(data.toString() + "my project Data");
    var headers = {
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE) ?? "",
    };

    ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_PROJECTLISTDASHBOARD,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers);

    Map<String, dynamic>? responseData = await response.getResponse();
    log(responseData.toString() + "project response");
    if (responseData!['status'] == 1) {
      List result = responseData['data'];
      arrProjectlist.value = List.from(result.map((e) => ProjectListModal.fromJson(e)));


      trendingList.value = responseData['listtrending'];
      // arrProjectlist.value = List.from(trendingList1.map((e) => ProjectListModal.fromJson(e)));

      arrProjectlist.refresh();
      _loadMore.value = responseData['loadmore'] ?? 0;
    } else {
      message.value = responseData['message'];
    }
    return arrProjectlist;
  }

  Future<void> AddFavoriteProjectData(
      ProjectListModal objProject, int index) async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    Map<String, dynamic> data = {};
    data['action'] = 'addprojectfavourite';
    data['projectid'] = objProject.sId;
    data['favourite'] = objProject.isfavorite == "1" ? "0" : "1";

    var headerdata = {
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE) ?? ""
    };

    print(data);
    print(headerdata);
    print("favourite data");
    ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_PROJECTLISTDASHBOARD,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headerdata);
    Map<String, dynamic>? responseData = await response.getResponse();

    if (responseData!['status'] == 1) {
      if (arrProjectlist[index].isfavorite.toString() == "1") {
        arrProjectlist[index].isfavorite = "0";
      } else {
        arrProjectlist[index].isfavorite = "1";
      }

      arrProjectlist.refresh();
      futurearrprojectlist.refresh();
      // bookmarkedCount.refresh();

      // restart();
    } else {
      print("add Fav-----" + responseData['message']);
    }
  }

  onNavigator(ProjectModal obj) {
    Get.to(ProjectDetails(projectid: obj.sId.toString()),
        duration: Duration(milliseconds: 0));
  }

  onNavigatornew(ProjectListModal obj) async {
    var result = await Get.to(
      ProjectDetails(projectid: obj.sId.toString()),
      duration: Duration(milliseconds: 0),
    );
    print('result');
    print(result);
    if (result == '1') {
      futurearrprojectlist.value = RetrieveProjectData();
      futurearrprojectlist.refresh();
    }
  }
}

class TredingMOdel {
  String? image;
  String? title;
  TredingMOdel({this.title, this.image});
}
