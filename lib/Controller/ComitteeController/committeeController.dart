
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Repeople/Widgets/select_dailog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Config/Constant.dart';
import '../../Config/Function.dart';
import '../../Config/Helper/ApiResponse.dart';
import '../../Config/utils/Images.dart';
import '../../Config/utils/colors.dart';
import '../../Model/ComitteeModel/committeeModel.dart';
import '../../Model/CommonModal/CommonModal.dart';
import '../../Model/Theme/WidgetThemeListClass.dart';
import '../BottomNavigator/BottomNavigatorController.dart';
import '../CommonHeaderController/CommenHeaderController.dart';

class CommitteController extends GetxController  {
  late TabController tabController;
  RxList<WidgetAppbarThemeListClass> arrHeaderThemeList = RxList<WidgetAppbarThemeListClass>();
  RxList<CommitteeListModel> arrCommiteeList = RxList<CommitteeListModel>([]);
  Rx<Future<List<CommitteeListModel>>> futureCommiteeListData = Future.value(<CommitteeListModel>[]).obs;
  // Rx<Future<List<ProjectDetailsModel>>> futuretablist = Future.value(<ProjectDetailsModel>[]).obs;
  RxList<CommonModal> arrProjectList = RxList([]);
  Rx<Future<List<CommonModal>>> futureProjectData = Future.value(<CommonModal>[]).obs;
  ScrollController scrollController = ScrollController();
  RxInt _loadMore = 0.obs;
  RxInt _pageCount = 1.obs;
  RxString message = "".obs;
  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());
  GlobalKey<ScaffoldState> GlobalCommiteePagekey = GlobalKey<ScaffoldState>();
  TextEditingController txtProject = TextEditingController();
  late Animation<Offset> offsetAnimation;
  AnimationController? controller;
  TextEditingController? searchController;
  FocusNode? searchFocusNode;
  RxBool showSearchView = false.obs;
  CommonModal obj_project = CommonModal();
  RxBool projectvisible=false.obs;

  @override
  void onInit() {super.onInit();}

  LoadData(){

    futureProjectData.value=RetrieveProjectListData().whenComplete(() {
      futureCommiteeListData.value = RetrieveCommitteeListData();
      projectvisible.value=true;
      arrCommiteeList.refresh();
      futureCommiteeListData.refresh();
    });
    // futureProjectData.refresh();

  }
  void launchWhatsapp(String numberWithCountryCode, String message) async {
    String url = "https://api.whatsapp.com/send?phone=" +
        numberWithCountryCode +
        "&text=" +
        message;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  void dispose() {super.dispose();}

  Restart(){
    _loadMore = 0.obs;
    _pageCount = 1.obs;
    arrCommiteeList.clear();
    futureProjectData.value=RetrieveProjectListData().whenComplete(() {
      futureCommiteeListData.value = RetrieveCommitteeListData();
      futureCommiteeListData.refresh();
    });

  }
  SelectProject() {
    SelectProjectDialog((value) {
      obj_project=value;
      txtProject.text = obj_project.name??"";
      futureCommiteeListData.value=RetrieveCommitteeListData();
      futureCommiteeListData.refresh();
    });
  }
  scrollUpdate(ScrollController scrollController) {
    var maxScroll = scrollController.position.maxScrollExtent;
    var currentPosition = scrollController.position.pixels;

    if (maxScroll == currentPosition) {
      if (_loadMore.value == 1) {
        print("load more"+_pageCount.toString());
        _pageCount.value++;
        RetrieveCommitteeListData();
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




  Future<void> onRefresh() async {
      Restart();
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
  Future<List<CommitteeListModel>> RetrieveCommitteeListData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if(_pageCount.value==1){
      arrCommiteeList = RxList([]);}
    var data = {
      'action': 'listrepeoplecommittees',
      'perpage': '10',
      "nextpage":_pageCount.value.toString(),
      'ordbycolumnname': '_id',
      //'filter': '',
      'ordby': '1',
      'projectid': obj_project.id??"",
    };

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
      base_url: URL_COMMITTEE,
      apiHeaderType: ApiHeaderType.Content,
      headerdata: headers,
    );
    Map<String, dynamic>? responseData = await response.getResponse();
print(responseData.toString());try{
    if (responseData!['status'] == 1) {
      List result = responseData['data'];
      _loadMore.value = responseData['loadmore'];
      _loadMore.refresh();
      List<CommitteeListModel> arrTempList = [];
      arrTempList = List<CommitteeListModel>.from(result.map((e) => CommitteeListModel.fromJson(e)));
      arrCommiteeList.addAll(arrTempList);
      arrCommiteeList.refresh();
    }else{
      message.value=responseData['message'];
      refresh();
    }
}catch(ex){
  print(ex.toString());
    }

    return arrCommiteeList;
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
                Row(
                  children: [
                    IconButton(onPressed: () => ClosePageCallback(), icon: Icon(Icons.arrow_back_ios)),
                    Text(
                      title,
                      style: TextStyle(color: APP_FONT_COLOR, fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),

                Container(
                  child: Row(
                    children: [
                      TrallingIconSearch(IMG_SEARCH, APP_FONT_COLOR,(){}),
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

  Widget SearchView() {
    return Container(
      alignment: Alignment.center,
      // height: Get.height,
      height: 50,
      margin: EdgeInsets.only(right:  90),
      // color: AppColors.GREEN,
      color: Colors.red,
      child: TextField(
        controller: searchController,
        onSubmitted: (value){

        },
        textInputAction: TextInputAction.search,
        focusNode: searchFocusNode,
        autofocus: false,
        onChanged: (value){

        },
        // style: TextStyles.textStyleNormal(AppColors.WHITE, 15.sp),
        decoration: InputDecoration(
          // contentPadding:
          //     EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
          focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
          enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color:Colors.blue)),
          errorBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
          focusedErrorBorder:
          OutlineInputBorder(borderSide: BorderSide(color:Colors.blue)),
          hintText: " search",
          // hintStyle: TextStyles.textStyleBold(AppColors.GREY, 15.sp),
          // prefixIcon: Icon(
          //   Icons.search,
          //   color: AppColors.WHITE,
          // )
        ),
        // cursorColor: AppColors.WHITE,
      ),
      //       ),
      //     ),
      //     // FilterButton(),
      //   ],
      // ),
    );
  }

  ClosePageCallback(){
    var getPageStringList = Get.currentRoute.split(" ");
    String pageName = getPageStringList.last;
    BottomNavigatorController cnt_bottom = Get.put(BottomNavigatorController());
    if(pageName == "ProjectListPage" || pageName == "FavoritePage"){
      cnt_bottom.SelectIndex(0);
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
    // Toast.show('error in call');
    print(ex.toString());
  }

  }



}