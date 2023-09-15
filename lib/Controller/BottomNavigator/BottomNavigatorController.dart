import 'dart:convert';
import 'dart:developer';

import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/View/DashboardPage/DashboardPage.dart';
import 'package:Repeople/View/FavoritePage/FavoritePage.dart';
import 'package:Repeople/View/MyAccountPage/MyAccountPage.dart';
import 'package:Repeople/View/NoticeUpdatePage/NoticeUpdatePage.dart';
import 'package:Repeople/View/ProjectListPage/ProjectListPage.dart';
import 'package:Repeople/View/ReferaFriendPage/ReferAFriendFormPage.dart';
import 'package:Repeople/View/ReferaFriendPage/ReferAFriendPage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Helper/ApiResponse.dart';
import 'package:Repeople/Config/Helper/MoengageAnalyticsHandler.dart';
import 'package:Repeople/Config/Helper/NotificationHandler.dart';
import 'package:Repeople/Config/Helper/shared_prefrence.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Model/Dashbord/ExploreMoreListClass.dart';
import 'package:Repeople/Model/Theme/BottomNavigationIconList.dart';
import 'package:flutter/material.dart';
import 'package:Repeople/Model/Theme/WidgetThemeListClass.dart';
import 'package:Repeople/View/LoginPage/LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Config/utils/Images.dart';
import '../../Widgets/CommomBottomSheet.dart';

class BottomNavigatorController extends GetxController {
  Rx<UserrightsModal> arrUserRightsList=UserrightsModal().obs;
  RxList<MenuItemModel> arrBottomNavigationList = RxList<MenuItemModel>([]);
  RxList<BottomNavigationIconList> arrBottomnavigationList = RxList<BottomNavigationIconList>([]);
  RxList<WidgetThemeListClass> arrBottomNavigationSelectList = <WidgetThemeListClass>[].obs;
  Rx<Future<List<BottomNavigationIconList>>> futureData = Future.value(<BottomNavigationIconList>[]).obs;
  Rx<Future<List<WidgetThemeListClass>>> futurethemelist = Future.value(<WidgetThemeListClass>[]).obs;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  RxInt selectedIndex = 0.obs;
  String roleCode = "";


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    Is_Login.value=UserSimplePreference.getbool(ISLOGIN) ?? false;
    _getUserRoleCode();
    futureData.value= adddata();
    futurethemelist.value= addthemeaccordinglist();
    NotificationDataFetch();

    getData();
  }
  getData() async {

    getMenuData().then((value) async {
      if (value) {
        GetMenutList();
      }
      else{
        arrUserRightsList=await GetUserRights("");
        if(arrUserRightsList.value.bottomNavigation!=null){
          arrBottomNavigationList.value=arrUserRightsList.value.bottomNavigation!.where((e) =>GetCurrentOsViewRight(e).value==1).toList();
          arrBottomNavigationList.refresh();
        }
      }
    });
  }
 Future<void> GetMenutList() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    try {
      var data = {
        "action": "userrights"
      };
      Map<String,String> headerdata = {};
      if(sp.getString(SESSION_USERLOGINTYPE)!=null && sp.getString(SESSION_USERLOGINTYPE)!=""){
         headerdata.addAll( {
          'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"4",
        });
      }
      print("userrights * + * +* + *+ *+ $data");
      ApiResponse response = ApiResponse(
          data: data,
          base_url: URL_USERPROFILEDETAILS,
          headerdata: headerdata,
          apiHeaderType: ApiHeaderType.Content);
      Map<String, dynamic>? responseData = await response.getResponse();
      log(responseData.toString());
      print( "userrights responseData");
      if (responseData!['status'] == 1) {
        arrUserRightsList.value=UserrightsModal.fromJson(responseData);
        SharedPreferences sp = await SharedPreferences.getInstance();
          // sp.setString(SESSION_MENU, json.encode(arrUserRightsList));
          sp.setString(SESSION_MENU, json.encode(responseData));

        if(arrUserRightsList.value.bottomNavigation!=null){
        arrBottomNavigationList.value=arrUserRightsList.value.bottomNavigation!.where((e) =>GetCurrentOsViewRight(e).value==1).toList();
        arrBottomNavigationList.refresh();
        }
        else{
          GetBottomNavigation();
        }
      } else {
        GetBottomNavigation();
        print(responseData['message']);
      }
    } catch (error) {
      GetBottomNavigation();
      print(error);
    }
  }
  GetBottomNavigation()async{
    arrBottomNavigationList.clear();
    Rx<UserrightsModal> arrUserRightsList=UserrightsModal().obs;
    arrUserRightsList=await GetUserRights("");
    arrBottomNavigationList.value=arrUserRightsList.value.bottomNavigation!.where((e) =>GetCurrentOsViewRight(e).value==1).toList();
    arrBottomNavigationList.refresh();
  }
  Future<bool> getMenuData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool value =  sp.getString(SESSION_MENU) !=null && sp.getString(SESSION_MENU)!="" ? false : true;
    return value;
  }
  NotificationDataFetch()async{
    RemoteMessage? message = await firebaseMessaging.getInitialMessage();
    if(message != null){
      NotificationHandler().onNotificationClickListener(message.data,true);
    }
  }
  Future<List<BottomNavigationIconList>>  adddata() async{
    arrBottomnavigationList=RxList([]);
    arrBottomnavigationList.add(new BottomNavigationIconList(
        uniquename: HOMEMENU, name: "Home",
        image: IMG_HOME_SVG_NEW
    ));
    arrBottomnavigationList.add(new BottomNavigationIconList(
        uniquename: PROJECTMENU,
        name: "Projects",
        image: IMG_PROJECT_SVG_NEW
    ));
    arrBottomnavigationList.add(new BottomNavigationIconList(
        uniquename: REFERMENU, name: "Refer", image: "assets/bottomNavigatorImage/Rupee.png"));
    arrBottomnavigationList.add(new BottomNavigationIconList(
        uniquename: FAVMENU, name: "Favourites",
        image: IMG_LIKE_SVG_NEW,
        alias: FAVORITE_APPMENUNAME));
    arrBottomnavigationList.add(new BottomNavigationIconList(
        uniquename: ACCOUNTMENU,
        name: "Account",
        image: IMG_USER_SVG_NEW
    ));
    arrBottomnavigationList.refresh();
    arrBottomnavigationList.obs;

    return arrBottomnavigationList;


  }

  Future<List<WidgetThemeListClass>> addthemeaccordinglist() async{
    arrBottomNavigationSelectList=RxList([]);
    arrBottomNavigationSelectList.add(WidgetThemeListClass(BOTTOMNAV_1, wd_BottomNavigation1()));
    arrBottomNavigationSelectList.add(WidgetThemeListClass(BOTTOMNAV_4, wd_BottomNavigation4()));
    arrBottomNavigationSelectList.add(WidgetThemeListClass(BOTTOMNAV_5, wd_BottomNavigation5()));
    arrBottomNavigationSelectList.add(WidgetThemeListClass(BOTTOMNAV_5, wd_BottomNavigation6()));
    arrBottomNavigationSelectList.add(WidgetThemeListClass(BOTTOMNAV_2, wd_BottomNavigation5()));
    arrBottomNavigationSelectList.refresh();
    arrBottomNavigationSelectList.obs;
    return arrBottomNavigationSelectList;
  }

  _getUserRoleCode() async {
    roleCode = await getUserRoleCode();
  }
  // SelectIndex

  Future<String> getUserRoleCode()async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(SESSION_ROLECODE) ?? "";
  }
  
  SelectIndex(int index){
    if(index!=4){
      selectedIndex.value = index;
      selectedIndex.update((val) { });
      selectedIndex.refresh();
      selectedIndex.value = index;
      onInit();
    }
    else{
      if(Is_Login.isTrue){
        selectedIndex.value = index;
        selectedIndex.obs;
        selectedIndex.refresh();
        selectedIndex.value = index;
        onInit();
      }
    }

    onNavigation(index);
    arrBottomnavigationList.refresh();
    update();
  }

  onNavigation(int index){
    MenuItemModel obj = arrBottomNavigationList[index];
    switch(obj.alias){
      case HOMEMENU:
         Get.offAll(() => DashboardPage(),
           duration: Duration(milliseconds: 0),
         );
         break;
      case PROJECTMENU:
        isBottomPageNavigate = true;
        GotoPropertiesPage();
        break;
      case FAVMENU:
        GotoMyFavouritePage();
        break;
      case REFERMENU:
        isBottomPageNavigate = true;
        Get.offAll(() => NoticeUpdatePage(),duration: Duration(milliseconds: 10))?.then((value) => selectedIndex.value=0);
        break;
      case ACCOUNTMENU:
      if(Is_Login.isTrue){
        GotoMyProfilePage();
      }
      else{
        LoginDialog();
      }

    }
  }

  LoginDialog(){
    LoginDialoge(
        dialogtext: "You should login first to proceed further.",
        stackicon:
        SvgPicture.asset(
          IMG_APPLOGO1_SVG,
          width: 40,
          height: 40,
          fit: BoxFit.fill,
          color: white,
        ),
        firstbuttontap: (){
          Get.back();
        },
        secondbuttontap: (){
          Get.back();
          Get.to(LoginPage());
        },
        secondbuttontext: "Yes",
        firstbuttontext: "No"

    );
  }

  GotoMyFavouritePage() async {
    if(roleCode == GUEST_USER_ROLE_CODE){
      OpenGusetUserRestricationDialog();
    }else{
      var index = await Get.to(
        FavoritePage(),
        duration: Duration.zero,
      )?.then((value) => selectedIndex.value=0);
      if (index != null) {
        SelectIndex(index);
      }
    }
  }

  GotoPropertiesPage() async {
    if(roleCode == GUEST_USER_ROLE_CODE){
      OpenGusetUserRestricationDialog();
    }else{
      var index = await Get.to(
        ProjectListPage(),
        duration: Duration.zero,
      )?.then((value) => selectedIndex.value=0);

      if (index != null) {
        SelectIndex(index);
      }
    }
  }

  GotoMyProfilePage() async {
    MoengageAnalyticsHandler().track_event("profile_page");
    if(roleCode == GUEST_USER_ROLE_CODE){
      OpenGusetUserRestricationDialog();
    }else{
      var index = await Get.to(
          MyAccountPage(),
          duration: Duration.zero)?.then((value) => selectedIndex.value=0);

      if (index != null) {
        SelectIndex(index);
      }

    }

  }

  //<editor-fold desc = "Bottom Navigation 1, Bottom Navigation 2 , Bottom Navigation 3 , Bottom Navigation 4 , Bottom Navigation 5">

  // bottom navigation 1
  Widget wd_BottomNavigation1() {
    return   Container(
      height: 65,
      decoration: BoxDecoration(
          color: white,
          boxShadow:
          [
            BoxShadow(color:
            hex("266CB5").withOpacity(0.1),offset: Offset(1,1),blurRadius: 5,spreadRadius: 3),],
      ),
      width: Get.width,
      // color: WHITE,
      child: Obx((){
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, i) {
            return  Obx(() => _generateNavigationCell1(i));
            // return  Obx(() => _generateNavigationCellnew(i));
          },
          itemCount: arrBottomNavigationList.length > 0 ? arrBottomNavigationList.length : 0,
        );
      })
    );
  }

  Widget _generateNavigationCell1(int index) {
    MenuItemModel obj = arrBottomNavigationList[index];
    return obj.alias == "referral"
        ?Align(
      alignment: Alignment.topCenter,
      child: GestureDetector(
        onTap: (){
          MoengageAnalyticsHandler().SendAnalytics(
              {"menu_name":obj.alias},"bottom_menu");
          if(Is_Login.isTrue){
            selectedIndex=(-1).obs;
            Get.to(ReferAFriendFormPage());
          }
          else{
            LoginDialog();
          }
          },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
            height: Get.height,
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  color: BLACK,
                  shape: BoxShape.circle
              ),
              child: 
              Center(
                child: SvgPicture.asset(RUPPEY_SVG_ICONS,width: 24,height: 24,color: white),
              )
              // Center(child: Text('\u{20B9}',style: TextStyle(color: Colors.white,fontSize: 21,fontWeight: FontWeight.w500),),
              // ),
            ),
          ),
        ),
      ),
    ): Obx(() =>
        GestureDetector(
          onTap: () {
            MoengageAnalyticsHandler().SendAnalytics({"menu_name":obj.alias},"bottom_menu");
            SelectIndex(index);
          },
          child: Container(
                width: Get.width / 5,
                height: 40,
                padding: EdgeInsets.only(left: 13,right: 13,top: 15),
                child: Column(
            children: [
              obj.icon.toString().contains("svg") ?
              SvgPicture.network(
                obj.icon??"",
                height: 25,
                width: 25,
                color: selectedIndex.value == index ? DARK_BLUE : new_black_color,
              ):
              Image.network(
                obj.icon??"",
                color: selectedIndex.value == index ? DARK_BLUE : new_black_color,
                fit: BoxFit.contain,
                height: 25,
                width: 25,
              ),
              SizedBox(height: 5,),
              Text(
                selectedIndex.value == index?obj.name!.toUpperCase():obj.name??"",
                style: TextStyle(
                    fontSize: 7.sp, color:
                // selectedIndex.value == index?BLACK:
                // gray_color_1,
                selectedIndex.value == index ? new_black_color:
                new_black_color,fontFamily: fontFamily,
                    fontWeight:
                FontWeight.w700),
              )
                  // : Container()
            ],
          )),
        ));


  }

  Widget _generateNavigationCellnew(int index) {
    BottomNavigationIconList obj = arrBottomnavigationList[index];
    return obj.uniquename.toLowerCase() == "rupee"
        ?Align(
      alignment: Alignment.topCenter,
      child: GestureDetector(
        onTap: (){
          selectedIndex=(-1).obs;
          Get.to(ReferAFriendFormPage());
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
            height: Get.height,
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle
              ),
              child: Center(child: Text('\u{20B9}',style: TextStyle(color: Colors.white,fontSize: 21,fontWeight: FontWeight.w500),),),
            ),
          ),
        ),
      ),
    ): Obx(() =>
        Container(
        width: Get.width / 5,
        height: 40,
        padding: EdgeInsets.all(/*selectedIndex.value == index ? 10 : */15),
        child: Stack(
          children: [
            Column(
              children: [
                InkWell(
                  onTap: (){
                    SelectIndex(index);
                  },
                  child:
                  Column(
                    children: [
                      obj.image.toString().contains("svg")?
                      SvgPicture.asset(
                        obj.image,
                        // IMG_HOME_SVG_DASHBOARD,
                        height: 30,
                        // width: 20,
                        // By default our  icon color is white
                        color: selectedIndex.value == index ? APP_THEME_COLOR : APP_FONT_COLOR,
                      ):
                      Image.asset(
                        obj.image,
                        // obj.image,
                        color: selectedIndex.value == index ? APP_THEME_COLOR : APP_FONT_COLOR,
                        fit: BoxFit.contain,
                        height: 30,
                        width: 30,
                      ),
                    ],
                  ),
                ),
                selectedIndex.value == index
                    ? Text(
                  obj.name.toUpperCase(),
                  style: TextStyle(fontSize: 9, color: APP_THEME_COLOR),
                )
                    : Container()
              ],
            ),


          ],
        )));


  }

  // bottom navigation 6
  Widget wd_BottomNavigation6() {
    return   Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 10),
      child: Container(
          height: 55,
          width: Get.width,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(15)
          ),
          child: Obx((){
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, i) {
                return  Obx(() => _generateNavigationCell6(i));
              },
              itemCount: arrBottomnavigationList.length > 0 ? arrBottomnavigationList.length : 0,
            );
          })
      ),
    );
  }
  Widget _generateNavigationCell6(int index) {
    BottomNavigationIconList obj = arrBottomnavigationList[index];
    return obj.uniquename.toLowerCase() == "rupee"
        ?Align(
      alignment: Alignment.topCenter,
      child: GestureDetector(
        onTap: (){
          selectedIndex=(-1).obs;
          MoengageAnalyticsHandler().track_event("refer_a_friend");
          // Get.to(ReferalFriendPage());
        },
        // child: Image.asset(
        //   obj.image,
        //   fit: BoxFit.contain,
        // ),

        child: Container(

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              height: Get.height,
              width: 40,


              decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle
              ),
              child: Center(child: Text('\u{20B9}',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w500),),),
            ),
          ),
        ),


      ),
    ): Obx(() => Container(
        width: Get.width / 5,
        height: 40,
        padding: EdgeInsets.all(selectedIndex.value == index ? 5 : 10),

        child: Column(
          children: [
            InkWell(
              onTap: (){
                SelectIndex(index);
              },
              child: Image.asset(
                obj.image,
                color: selectedIndex.value == index ? APP_THEME_COLOR : APP_FONT_COLOR,
                fit: BoxFit.contain,
                height: 25,
                width: 25,
              ),
            ),
            selectedIndex.value == index
                ? Text(
                    obj.name,
                    style: TextStyle(fontSize: 12, color: APP_THEME_COLOR),
                  )
                : Container()
          ],
        )))
        ;

      // Image.asset(
      //   obj.image,
      //   color:  APP_THEME_COLOR ,
      //   fit: BoxFit.contain,
      //   height: 30,
      //   width: 30,
      // );
  }


  // bottom Navigation 2
  Widget wd_BottomNavigation2() {
    return Material(
      elevation: 5,
      color:white,
      child: Container(
        height: 65,
        // decoration: CustomDecorations().backgroundlocal(WHITE, 10, 0, WHITE),
        child: Obx((){
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, i) {
              return _generateNavigationCell2(i);
            },
            itemCount: arrBottomnavigationList.length > 0 ? arrBottomnavigationList.length : 0,
          );
        })
      ),
    );
  }

  Widget _generateNavigationCell2(int index) {
    BottomNavigationIconList obj = arrBottomnavigationList[index];
    return obj.uniquename != "rupee"
        ? InkWell(
      onTap: ()=> SelectIndex(index),
          child: Container(
              width: (Get.width - 8) / 5,
              padding: EdgeInsets.all(selectedIndex == index ? 10 : 15),
              child: Column(
                children: [
                  Image.asset(
                    obj.image,
                    color: selectedIndex == index ? APP_THEME_COLOR : APP_FONT_COLOR,
                    fit: BoxFit.contain,
                    height: 30,
                    width: 30,
                  ),
                  selectedIndex == index
                      ? Text(
                    obj.name,
                    style: TextStyle(fontSize: 12, color: APP_THEME_COLOR),
                  )
                      : Container()
                ],
              )),
        )
        : Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              obj.image,
              fit: BoxFit.contain,
            ),
          );
  }

  // bottom navigation 3
  Widget wd_BottomNavigation3() {
    return Container(
      height: 65,
      width: Get.width,
      color: LIGHT_GRAY_COLOR,
      child: Obx((){
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, i) {
            return _generateNavigationCell3(i);
          },
          itemCount: arrBottomnavigationList.length > 0 ? arrBottomnavigationList.length : 0,
        );
      })
    );
  }

  Widget _generateNavigationCell3(int index) {
    BottomNavigationIconList obj = arrBottomnavigationList[index];
    return obj.uniquename != "rupee"
        ? InkWell(
          onTap: () => SelectIndex(index),
          child: Container(
              width: Get.width / 5,
              padding: EdgeInsets.all(selectedIndex.value == index ?10  : 15),
              child: Column(
                children: [
                  Image.asset(
                    obj.image,
                    color: selectedIndex.value == index ? APP_THEME_COLOR : APP_FONT_COLOR,
                    fit: BoxFit.contain,
                    height: 30,
                    width: 30,
                  ),
                  selectedIndex.value == index
                      ? Text(
                    obj.name,
                    style: TextStyle(fontSize: 10, color: APP_THEME_COLOR),
                  )
                      : Container()
                ],
              )),
        )
        : Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              obj.image,
              fit: BoxFit.contain,
            ),
          );
  }

  // bottom navigation 4
  Widget wd_BottomNavigation4() {
    return Stack(
      children: [
        Obx((){
          return Container(
            height: 85,
            color: Colors.transparent,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: white,
                height: 65,
                child: Row(
                  children: [
                    _generateNavigationCell4(0),
                    _generateNavigationCell4(1),
                    _generateNavigationCell4(3),
                    _generateNavigationCell4(4),
                  ],
                ),
              ),
            ),
          );
        }),
        Positioned(
          top: 0,
          right: 0,
          child:
              Container(width: Get.width / 5, child: GestureDetector(
                  onTap: (){
                    MoengageAnalyticsHandler().track_event("refer_a_friend");
                    selectedIndex=(-1).obs;
                    Get.to(ReferAFriendPage());
                  },
                  // child: Image.asset(arrBottomnavigationList[2].image),
                child: Container(
                  height: 60,
                  width: 50,

                  decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle
                  ),
                  child: Center(child: Text('\u{20B9}',style:
                  TextStyle(color: Colors.white,fontSize: 23,fontWeight: FontWeight.w500),),),
                ),

              )),
        ),
      ],
    );
  }

  Widget _generateNavigationCell4(int index) {
    BottomNavigationIconList obj = arrBottomnavigationList[index];
    return InkWell(
      onTap: ()=>SelectIndex(index),
      child: Container(
          width: Get.width / 5,
          padding: EdgeInsets.all(selectedIndex == index ? 10 : 15),
          child: Column(
            children: [
               obj.image.toString().contains("svg")?
              SvgPicture.asset(
                obj.image,
                height: 30,
                // width: 20,
                // By default our  icon color is white
                color: selectedIndex.value == index ? APP_THEME_COLOR : APP_FONT_COLOR,
              ):
               Image.asset(
                 obj.image,
                 color: selectedIndex == index ? APP_THEME_COLOR : APP_FONT_COLOR,
                 fit: BoxFit.contain,
                 height: 30,
                 width: 30,
               ),
              // Image.asset(
              //   obj.image,
              //   color: selectedIndex == index ? APP_THEME_COLOR : APP_FONT_COLOR,
              //   fit: BoxFit.contain,
              //   height: 30,
              //   width: 30,
              // ),
              selectedIndex == index
                  ? Text(
                obj.name,
                style: TextStyle(fontSize: 12, color: APP_THEME_COLOR),
              )
                  : Container()
            ],
          )),
    );
  }

  // bottom navigation 4
  Widget wd_BottomNavigation5() {
    return Stack(
       clipBehavior: Clip.none,
      // fit: StackFit.loose,
      //overflow: Overflow.visible,
      children: [
        Obx((){
          return Container(
          height: 145,
            color: Colors.transparent,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: white,
                height: 65,
                child: Row(
                  children: [
                    _generateNavigationCell5(0),
                    _generateNavigationCell5(1),
                    _generateNavigationCell5(3),
                    _generateNavigationCell5(4),
                  ],
                ),
              ),
            ),
          );
        }),
        Positioned(
          top: 0,
          right: 0,
          // bottom: 90,
          child:
              Container(
                  width: Get.width / 5,
                  child:
              GestureDetector(
                  onTap: (){
                    selectedIndex=(-1).obs;
                    MoengageAnalyticsHandler().track_event("refer_a_friend");
                    Get.to(ReferAFriendPage());
                  },
                  // child: Image.asset(arrBottomnavigationList[2].image,),
                child: Container(
                  height: 60,
                  width: 50,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle
                  ),
                  child: Center(child:
                  Text('\u{20B9}',
                    style: TextStyle(color: Colors.white,fontSize: 23,fontWeight: FontWeight.w500),),),
                ),

              )),
        ),


      ],
    );
  }

  Widget _generateNavigationCell5(int index) {
    BottomNavigationIconList obj = arrBottomnavigationList[index];
    return InkWell(
      onTap: ()=>SelectIndex(index),
      child: Container(
          width: Get.width / 4,
          padding: EdgeInsets.all(selectedIndex == index ? 10 : 15),
          child: Column(
            children: [
              Image.asset(
                obj.image,
                color: selectedIndex == index ? APP_THEME_COLOR : APP_FONT_COLOR,
                fit: BoxFit.contain,
                height: 30,
                width: 30,
              ),
              selectedIndex == index
                  ? Text(
                obj.name,
                style: TextStyle(fontSize: 12, color: APP_THEME_COLOR),
              )
                  : Container()
            ],
          )),
    );
  }

//</editor-fold>

}
