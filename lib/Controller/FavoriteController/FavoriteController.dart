
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Model/Dashbord/ProjectListClass.dart';
import 'package:Repeople/Model/ProjectDetails/ProjectBasicInfo.dart';
import 'package:Repeople/Model/Theme/WidgetThemeListClass.dart';
import 'package:Repeople/Widgets/CommomBottomSheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Config/Helper/ApiResponse.dart';
import '../../Model/FavoritesModal/FvoritesModal.dart';
import '../../Model/ProjectListModal/ProjectListModal.dart';
import '../CommonHeaderController/CommenHeaderController.dart';

class FavoriteController extends GetxController {
  RxList<ProjectBasicInfo> arrProjectList = RxList<ProjectBasicInfo>();
  RxList<WidgetThemeListClass> arrNoFoundListTheme = RxList<WidgetThemeListClass>();
  RxList<WidgetThemeListClass> arrAllTheme = RxList<WidgetThemeListClass>();
  RxList<WidgetThemeListClass> arrfavprojectTheme = RxList<WidgetThemeListClass>();
  RxList<ProjectListClass> arrProjectDataList = RxList<ProjectListClass>();
  RxList<FavoritesProjectListClass> arrFavProjectDataList = RxList<FavoritesProjectListClass>();
  Rx<Future<List<ProjectListClass>>> futurearrprojectdatalist = Future.value(<ProjectListClass>[]).obs;
  RxInt selectedProjectIndex = 0.obs;
  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());



  int loadmore = 0;
  int pagecount = 1;
  bool isFilter = false;
  RxString message = "".obs;
  String url = "";

  //new modal lists
  RxList<ProjectListModal> arrfavProjectlist = RxList<ProjectListModal>();
  Rx<Future<List<ProjectListModal>>> futurearrfavprojectlist = Future.value(<ProjectListModal>[]).obs;


  CarouselController controller_event = CarouselController();
  RxInt current = 0.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

  }

  Future<List<ProjectListModal>> RetrieveFavouritesProjectData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    arrfavProjectlist = RxList([]);
    var data = {
      'action': 'listproject',
      'nextpage': "1",
      'perpage': "10",
      'ordby': "1",
      'ordbycolumnname': "id",
      "filter":"",
      "favourite":"true"
    };
    print("data");
    print(data);
    print(URL_PROJECTLISTDASHBOARD+"baseurl");
    var headers = {'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??""};

    ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_PROJECTLISTDASHBOARD,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers);

    print(headers);

    Map<String, dynamic>? responseData = await response.getResponse();

    if (responseData!['status'] == 1) {
      List result = responseData['data'];
      arrfavProjectlist.value =
          List.from(result.map((e) => ProjectListModal.fromJson(e)));
      arrfavProjectlist.refresh();
    } else {
      message.value = responseData['message'];
    }
    return arrfavProjectlist;

  }

  // from widget 2
  Widget notificationicon(){
    return Container(
      color: white,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 5,
                child: Text(FAVORITE_APPNAME,style: TextStyle(color: APP_FONT_COLOR, fontSize: 20, fontWeight: FontWeight.w600,),textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 20,top: 5,bottom: 5),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15),bottomLeft: Radius.circular(15))
                ),
                child: TrallingIconNotification(APP_FONT_COLOR),
              )
            ],
          ),
          SizedBox(height: 30,),
        ],
      ),
    );
  }

  RemoveFavouriteBottomSheet(int index){
    bottomSheetDialog(
        backgroundColor: APP_THEME_COLOR,
        child: AlertDialogButton(
          "Are you sure you want to remove this project from favourites?",
          TotalButton.TWO,
          "Yes",
          "No",
              () => {
            Get.back(),
            RemoveFavoriteProjectData(index),
          },
              () => Get.back(),APP_THEME_COLOR,
          AppColors.APP_GRAY_COLOR,mediumTextStyle(txtColor: Colors.white),mediumTextStyle(txtColor: Colors.black),),message: "Remove from favourites");

  }

  Future<void> RemoveFavoriteProjectData(int index) async {
    ProjectListModal objProject=arrfavProjectlist[index];
    SharedPreferences sp = await SharedPreferences.getInstance();

    Map<String, dynamic> data = {};
    data['action'] = 'addprojectfavourite';
    data['projectid'] = objProject.sId;
    data['favourite'] = "0";

    var headerdata = {'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??""};
    ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_PROJECTLISTDASHBOARD,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headerdata);
    Map<String, dynamic>? responseData = await response.getResponse();

    if (responseData!['status'] == 1) {
      futurearrfavprojectlist.value = RetrieveFavouritesProjectData();
    } else {
      print("add Fav-----" + responseData['message']);
    }
  }
}
