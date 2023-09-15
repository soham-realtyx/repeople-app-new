import 'dart:convert';
import 'dart:io';
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Controller/MenuClickHandlerController/MenuClickHandler.dart';
import 'package:Repeople/Model/UserProfileModel/UserProfileModel.dart';
import 'package:Repeople/View/AboutPage/AboutPage.dart';
import 'package:Repeople/View/AboutUsPage/AboutUsScreen.dart';
import 'package:Repeople/View/AwardsPage/AwardsPage.dart';
import 'package:Repeople/View/ContactUsPage/ContactUsPage.dart';
import 'package:Repeople/View/DashboardPage/DashboardPage.dart';
import 'package:Repeople/View/EmiCalculatorPage/EmiCalculatorPage.dart';
import 'package:Repeople/View/FavoritePage/FavoritePage.dart';
import 'package:Repeople/View/LoginPage/LoginPage.dart';
import 'package:Repeople/View/MyPropertiesListPage/MyPropertiesListPage.dart';
import 'package:Repeople/View/NewsListPage/NewsPage.dart';
import 'package:Repeople/View/OffersPage/OffersPage.dart';
import 'package:Repeople/View/PrivacyTermPage/PrivacyTermPage.dart';
import 'package:Repeople/View/ProjectListPage/ProjectListPage.dart';
import 'package:Repeople/View/ReferaFriendPage/ReferAFriendFormPage.dart';
import 'package:Repeople/View/ReferralPage/ReferralPage.dart';
import 'package:Repeople/View/ScheduleSitePage/ScheduleSitePage.dart';
import 'package:Repeople/View/TechnicalQueryPage/TechnicalQueryPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/Helper/MoengageAnalyticsHandler.dart';
import 'package:Repeople/Config/Helper/shared_prefrence.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Controller/BottomNavigator/BottomNavigatorController.dart';
import 'package:Repeople/Model/Dashbord/ExploreMoreListClass.dart';
import 'package:Repeople/Model/DrawerModal/DrawerModal.dart';
import 'package:Repeople/Model/DrawerModal/UserrightListClass.dart';
import 'package:Repeople/Model/Theme/WidgetThemeListClass.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;

import '../../Config/Helper/ApiResponse.dart';
import '../../Config/Helper/Logout.dart';
import '../../View/ManagerScreensFlow/LoginScreens/ManagerLoginScreen.dart';
import '../../View/ManagerScreensFlow/ManagerAccountScreen/ManagerAccountScreen.dart';
import '../../View/ManagerScreensFlow/ManagerDashboardScreens/ManagerDashBoardScreen.dart';
import '../../Widgets/CommomBottomSheet.dart';
import '../../Widgets/Loader.dart';

typedef void OnTaplogoutbutton();

class CustomDrawerController extends GetxController {
  RxList<WidgetThemeListClass> arrDrawerList = RxList<WidgetThemeListClass>();
  RxList<WidgetThemeListClass> arrfooterList = RxList<WidgetThemeListClass>();


  RxList<DrawerModal> arrNewDrawerList_1 = RxList<DrawerModal>();
  RxList<DrawerModal> arrNewDrawerList_2 = RxList<DrawerModal>();
  RxList<DrawerModal> arrNewDrawerOtherList = RxList<DrawerModal>();

  RxString lblVersion = "".obs;
  RxBool  isRegistered = false.obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    NewDrawerListData_1();
    NewDrawerListData_2();
    OtherListData();
    GetProfileData();
    Is_Login.value = UserSimplePreference.getbool(ISLOGIN) ?? false;
    CURRENT_MANAGER_STATUS.value =
        UserSimplePreference.getbool(IS_MANAGER_DATA_AVAILABLE) ?? false;
    CURRENT_CUSTMER_STATUS.value =
        UserSimplePreference.getbool(IS_CUSTOMER_DATA_AVAILABLE) ?? false;
    CURRENT_LOGIN_VAR.value =
        UserSimplePreference.getString(CURRENT_LOGIN) ?? "";
    username.value = UserSimplePreference.getString(SESSION_PERSONNAME) ?? "";
    profile_pic.value =
        UserSimplePreference.getString(SESSION_PROFILEPIC) ?? "";
    print(Is_Login.value);
    PackageInfo info = await PackageInfo.fromPlatform();
    lblVersion.value = info.version;
    print(lblVersion);
  }

  //<editor-fold desc = " CREATE DRAWER LIST ">
  GetProfileData() {
    Is_Login.value = UserSimplePreference.getbool(ISLOGIN) ?? false;
    username.value = UserSimplePreference.getString(SESSION_PERSONNAME) ?? "";
    profile_pic.value =
        UserSimplePreference.getString(SESSION_PROFILEPIC) ?? "";
    firstname.value = UserSimplePreference.getString(SESSION_FIRSTNAME) ?? "";
    lastname.value = UserSimplePreference.getString(SESSION_LASTNAME) ?? "";
    mobile.value = UserSimplePreference.getString(SESSION_CONTACT) ?? "";
    alternate_mobile.value = UserSimplePreference.getString(SESSION_ALTERNATE_MOBILE) ?? "";
    customer_id.value = UserSimplePreference.getString(SESSION_CUSTOMER_ID) ?? "";
    email.value = UserSimplePreference.getString(SESSION_EMAIL) ?? "";
    userLoginType.value =
        UserSimplePreference.getString(SESSION_USERLOGINTYPE) ?? "";
    customerID.value = UserSimplePreference.getString(SESSION_CMPID) ?? "";
  }
  void CreateDrawerListTileItem() async {
    arrDrawerListTile = RxList([]);
    Rx<UserrightsModal> arrUserRightsList = UserrightsModal().obs;
    arrUserRightsList = await GetUserRights("");
    arrDrawerListTile.value = arrUserRightsList.value.sidebar!
        .where((e) => GetCurrentOsViewRight(e).value == 1)
        .toList();
    arrDrawerListTile.refresh();
    arrDrawerListTile.refresh();
  }

  void CreateDrawerFooterListTileItem() {
    arrDrawerFooterListTile = RxList([]);
    if (Is_Login.value == false) {
      arrDrawerFooterListTile.add(UserrightListClass.Drawer(
          "Login / Sign Up", LOGIN_SIGNUP_APPMENUNAME, IMG_ACCOUNT));
    }
    arrDrawerFooterListTile.add(UserrightListClass.Drawer(
        "Technical Query", PROJECT_APPMENUNAME, IMG_PROJECT));
    arrDrawerFooterListTile.add(
        UserrightListClass.Drawer("Contact", FAVORITE_APPMENUNAME, IMG_HEART));
    arrDrawerFooterListTile
        .add(UserrightListClass.Drawer("About", OFFER_APPMENUNAME, OFFERS_PNG));
    arrDrawerFooterListTile.refresh();
  }

  NavigatiScreen_1(int i){
    if(i==1){
      Is_Login.value==false ? MoengageAnalyticsHandler().track_event("login_page") : MoengageAnalyticsHandler().track_event("properties_page");
      Is_Login.value==false ? Get.to(()=>LoginPage()) : Get.to(()=>MyPropertiesListPage(projectid: '',));
    }else if(i==2){
      MoengageAnalyticsHandler().track_event(("favourite_list"));
      Get.to(()=>FavoritePage());
    }else if(i==3){
      MoengageAnalyticsHandler().track_event("offer");
      Get.to(()=>OffersPage());
    }
  }

  NavigatiScreen_2(int i){
    if(i==0){
      MoengageAnalyticsHandler().track_event("news");
      Get.to(()=>NewsListPage());
    }else if(i==1){
      MoengageAnalyticsHandler().track_event("awards");
      Get.to(()=>AwardsPage());
    }else if(i==2){
      MoengageAnalyticsHandler().track_event("contact_us");
      Get.to(()=>ContactUsPage());
    }
  }

  NavigateProjectScreen_1(int i){
    if(i==0){
      MoengageAnalyticsHandler().track_event('project_list');
      Get.to(()=>ProjectListPage());
    }
  }

  NavigateEmiCalculatorScreen_1(int i){
    if(i==3){
      MoengageAnalyticsHandler().track_event("emi_calculator");
      Get.to(()=>EmiCalculatorPage());
    }
  }

  String? loginClickData(){
    if(Is_Login.value==false) {
      "Login";
    }else if(isRegistered.value){
      "Link My Properties";
    }else{
      "My Properties";
    }
    return null;
  }
  
  NewDrawerListData_1() {
    arrNewDrawerList_1 = RxList([
      DrawerModal(
          title: "Projects",
          backColor: white,
          images: project_image_png,
          onTap: () {MoengageAnalyticsHandler().track_event('project_list');Get.to(()=>ProjectListPage());}),
      DrawerModal(
          title:
          Is_Login.value==false?"Login": isRegistered.value?"Link My Properties":"My Properties",
          backColor: ACCOUNT_STATEMENT_COLOR,
          images: Is_Login.value==false?img_login_key_svg :img_myProperties_svg,
          onTap: () {
            Is_Login.value==false?Get.to(()=>LoginPage()):Get.to(()=>MyPropertiesListPage(projectid: ""));
          }),
      DrawerModal(
          title: "Favourites",
          backColor: DEMANDS_COLOR,
          images: img_favourite_svg,
          onTap: () {MoengageAnalyticsHandler().track_event(("favourite_list"));Get.to(()=>FavoritePage());}),
      DrawerModal(
          title: "Offers",
          backColor: OFFER_COLOR,
          images: img_offers_svg,
          onTap: () { MoengageAnalyticsHandler().track_event("offer");Get.to(()=>OffersPage());}),
    ]);
  }

  NewDrawerListData_2() {
    arrNewDrawerList_2 = RxList([
      DrawerModal(
          title: "News",
          backColor: NEWS_COLOR,
          images: img_news_svg,
          onTap: () {MoengageAnalyticsHandler().track_event("news");Get.to(()=>NewsListPage());}),
      DrawerModal(
          title: "Awards",
          backColor: AWARDS_COLOR,
          images: img_awards_svg,
          onTap: () { MoengageAnalyticsHandler().track_event("awards");Get.to(()=>AwardsPage());}),
      DrawerModal(
          title: "Contact US",
          backColor: CONTACT_US_COLOR,
          images: img_contactUS_svg,
          onTap: () {MoengageAnalyticsHandler().track_event("contact_us");Get.to(()=>ContactUsPage());}),
      DrawerModal(
          title: "EMI Calculator",
          backColor: white,
          images: emi_calculator_image_png,
          onTap: () {MoengageAnalyticsHandler().track_event("emi_calculator");Get.to(()=>EmiCalculatorPage());}),
    ]);
  }

  OtherListData(){
    arrNewDrawerOtherList = RxList([
      DrawerModal(
        onTap: (){MoengageAnalyticsHandler().track_event("about");Get.to(()=>AboutPage());},
        images: img_about_svg,
        title: "About",
      ),
      DrawerModal(
        onTap: (){NavigatePrivacyPolicy();},
        images: img_privacy_policy_svg,
        title: "Privacy Policy",
      ),
      DrawerModal(
        onTap: (){NavigateTermCondition();},
        images: img_term_conditions_svg,
        title: "Terms & Conditions",
      ),
      DrawerModal(
        onTap: (){
          MoengageAnalyticsHandler().track_event("technical_query");
          Get.to(()=>TechnicalQueryPage());
          },
        images: img_contactUS_svg,
        title: "Technical Query",
      ),
      DrawerModal(
        onTap: (){
          MoengageAnalyticsHandler().track_event("version");
        },
        images: img_version_svg,
        // title:  "v" + lblVersion.value,
          lblVersion: Obx(() => Text(
            "${"v"} ${lblVersion.value.toString()}",
            style: TextStyle(
                fontFamily: fontFamily,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: BLACK
            ),
          ))
      ),
      DrawerModal(
        onTap: (){
          MoengageAnalyticsHandler().track_event("logout");
          Logoutdialog();
          },
        images: img_logout_svg,
        title: "Logout",
      )
    ]);
  }

  //</editor-fold>

  //<editor-fold desc = "Navigation Handler">

  NavigationHandler(int index) {
    Get.back();
    MenuItemModel obj = arrDrawerListTile[index];
    switch (obj.alias) {
      case LOGIN_SIGNUP_APPMENUNAME:
        NavigateLoginSignupPage();
        break;
      case PROJECTMENU:
        NavigateProjectPage();
        break;
      case FAVORITE_APPMENUNAME:
        NavigateFavoritePage();
        break;
      case REFER_FRIEND_APPMENUNAME:
        NavigateReferAFriendPage();
        break;
      case OFFER_APPMENUNAME:
        NavigateOfferPage();
        break;
      case SCHEDULE_SITE_VISIT_APPMENUNAME:
        NavigateScheduleASiteVistPage();
        break;
      case EMI_CALCULATOR_APPMENUNAME:

        NavigateEMICalculatorPage();
        break;
      case NEWS_APPMENUNAME:
        NavigateNewsPage();
        break;
      case AWARDS_APPMENUNAME:
        NavigateAwardsPage();
        break;
      case REFERRAL_APPMENUNAME:
        NavigateReferralPage();
        break;
      case TECHNICAL_QUERY_APPMENUNAME:
        NavigateTechnicalQueryPage();
        break;
      case ABOUT_APPMENUNAME:
        NavigateAboutPage();
        break;
      case CONTACT_APPMENUNAME:
        NavigateContactPage();
        break;
      case MANAGER_ACCOUNT:
        NavigateManagerAccount();
        break;
      case MANAGER_LOGIN:
        NavigateManagerLogin();
        break;
      case CUSTOMER_LOGIN:
        NavigateCustomerLogin();
        break;
      case CUSTOMER_SWITCH:
        SwitchtoCustomer();
        break;
      case MANAGER_SWITCH:
        SwitchtoManager();
        break;
    }
  }

  NavigationDrawerHandler(int index) {
    Get.back();
    UserrightListClass obj = arrDrawerFooterListTile[index];

    switch (obj.appmenuname) {
      case TECHNICAL_QUERY_APPMENUNAME:
        NavigateTechnicalQueryPage();
        break;
      case ABOUT_APPMENUNAME:
        NavigateAboutPage();
        break;
      case CONTACT_APPMENUNAME:
        NavigateContactPage();
        break;
    }
  }

  //</editor-fold>
  // <editor-fold desc="Navigation Method">

  BottomNavigatorController cnt_bottom = Get.put(BottomNavigatorController());

  NavigateLoginSignupPage() {
    Get.to(LoginPage());
  }

  NavigateTechnicalQueryPage() {
    Get.to(TechnicalQueryPage());
  }

  NavigateContactPage() {
    MoengageAnalyticsHandler().track_event("contact_us");
    Get.to(ContactUsPage());
  }

  NavigateManagerAccount() {
    Get.to(ManagerAccountScreen());
  }

  NavigateManagerLogin() {
    Get.to(ManagerLoginPage());
  }

  NavigateCustomerLogin() {
    Get.to(LoginPage());
  }

  SwitchtoCustomer() {
    SwitchToCustomer();
  }

  SwitchtoManager() {
    SwitchToManager();
  }
  NavigatePrivacyPolicy() {
    MoengageAnalyticsHandler().track_event('privacy');
    Get.back();
    Get.to(
        PrivacyTermPage(
          title: "Privacy Policy",
        ),
        preventDuplicates: false);
  }

  NavigateProjectPage() {
    MoengageAnalyticsHandler().track_event('project_list');
    Get.to(ProjectListPage());
    int index = cnt_bottom.arrBottomnavigationList
        .indexWhere((element) => element.uniquename == PROJECTMENU);
    cnt_bottom.selectedIndex.value = index;
  }

  NavigateFavoritePage() {
    MoengageAnalyticsHandler().track_event(("favourite_list"));
    Get.to(FavoritePage());
    int index = cnt_bottom.arrBottomnavigationList
        .indexWhere((element) => element.uniquename == FAVMENU);
    cnt_bottom.selectedIndex.value = index;
  }

  NavigateReferAFriendPage() {
    MoengageAnalyticsHandler().track_event("refer_a_friend");
    // Get.to(ReferAFriendPage());
    Get.to(ReferAFriendFormPage());
  }

  NavigateOfferPage() {
    MoengageAnalyticsHandler().track_event("offer");
    Get.to(OffersPage());
  }

  NavigateScheduleASiteVistPage() {
    Get.to(ScheduleSitePage());
  }

  NavigateEMICalculatorPage() {
    MoengageAnalyticsHandler().track_event("emi_calculator");
    Get.to(EmiCalculatorPage());
  }

  NavigateNewsPage() {
    MoengageAnalyticsHandler().track_event("news");
    Get.to(NewsListPage());
  }

  NavigateAwardsPage() {
    MoengageAnalyticsHandler().track_event("awards");
    Get.to(AwardsPage());
  }

  NavigateTechnicalPage() {
    Get.back();
    Get.to(TechnicalQueryPage());
  }

  NavigatecontactUsPage() {
    MoengageAnalyticsHandler().track_event("contact_us");
    Get.back();
    Get.to(ContactUsPage());
  }

  NavigateTermCondition() {
    MoengageAnalyticsHandler().track_event("terms&conditions");
    Get.back();
    Get.to(
        PrivacyTermPage(
          title: "Terms & Conditions",
        ),
        preventDuplicates: false);
  }

  NavigateAboutPage() {
    Get.back();
    //Get.to(AboutPage());
    Get.to(AboutUsPage());
  }

  NavigateReferralPage() {
    MoengageAnalyticsHandler().track_event("referral_page");
    Get.back();
    Get.to(ReferralPage());
    //Get.to(AppInfoPage());
  }

  Widget ShareButton(double size, MaterialColor color,
      {OnTaplogoutbutton? ontap}) {
    return InkWell(
      onTap: ontap,
      child: SvgPicture.asset(
        // IMG_LOGOUT_SVG,
        IMG_LOGOUT_SVG_DRAWER,
        height: 20,
        // width: 20,
        // By default our  icon color is white
        color: color,
      ),
    );
  }

  // Close Button
  Widget CloseIcon() {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Container(
          height: 24,
          width: 24,
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.white.withOpacity(0.20),),
          child: SvgPicture.asset(
            IMG_CLOSE_SVG_NEW,
            color: white,
            fit: BoxFit.cover,
            height: 24,
            width: 24,
          )
      ),
    );
  }

  Widget CloseButton(MaterialColor color, MaterialColor iconColor,
      [MaterialColor? borderColor, double borderWidth = 0]) {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Container(
        height: 30,
        width: 30,
        decoration: CustomDecorations().backgroundlocal(
            color, 20, borderWidth, borderColor ?? TRANSPARENT),
        child: Icon(
          Icons.clear,
          color: iconColor,
          size: 25,
        ),
      ),
    );
  }



  Widget DrawerListData_1() {
    return Expanded(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 0),
                    Obx(() {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return DrawerListTile_1(index);
                        },
                        itemCount: arrDrawerListTile.length,
                      );
                    }),
                    SizedBox(
                      height: 60,
                    ),
                    // Footer_1()
                  ],
                ),
              ),
            ),
            Positioned(bottom: 0, left: 0, right: 0, child: Footer_1())
          ],
        ));
  }

  Widget DrawerListTile_1(int index) {
    MenuItemModel objList = arrDrawerListTile[index];
    return CURRENT_LOGIN_VAR.value != "" &&
        CURRENT_LOGIN_VAR.value != null &&
        CURRENT_LOGIN_VAR.value != "null"
        ? (objList.alias == "switchcustomer" ||
        objList.alias == "customerlogin")
        ? (objList.alias == "switchcustomer" &&
        CURRENT_CUSTMER_STATUS.isTrue)
        ? DrawerListtileWidget(objList, index)
        : (objList.alias == "customerlogin" &&
        CURRENT_CUSTMER_STATUS.isFalse)
        ? DrawerListtileWidget(objList, index)
        : Container()
        : (objList.alias == "switchmanager" ||
        objList.alias == "managerlogin")
        ? (objList.alias == "switchmanager" &&
        CURRENT_MANAGER_STATUS.isTrue)
        ? DrawerListtileWidget(objList, index)
        : (objList.alias == "managerlogin" &&
        CURRENT_MANAGER_STATUS.isFalse)
        ? DrawerListtileWidget(objList, index)
        : Container()
        : DrawerListtileWidget(objList, index)
        : DrawerListtileWidget(objList, index);
  }

  Widget DrawerListtileWidget(MenuItemModel objList, int index) {
    bool isTrue = objList.isselected ?? false;
    return GestureDetector(
      onTap: () {
        print(objList.alias!);
        SelectMenu(objList.alias!);
        NavigationHandler(index);
      },
      child: Column(
        children: [
          Container(
            color: isTrue ? white : APP_GRAY_COLOR,
            child: ListTile(
                visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity),
                // contentPadding: EdgeInsets.symmetric(vertical: 2,horizontal: 5),
                contentPadding:
                EdgeInsets.only(top: 2, bottom: 2, left: 5, right: 15),
                leading: objList.icon!.toString().contains("svg")
                    ? Container(
                  width: 50,
                  height: 50,
                  // margin: EdgeInsets.only(right: 0),
                  padding: const EdgeInsets.all(10.0),
                  // decoration: CustomDecorations().backgroundlocal(
                  //     APP_GRAY_COLOR, cornarradius, 0, APP_GRAY_COLOR),
                  child: SvgPicture.network(
                    objList.icon!.toString(),
                    height: 25,
                    color: BLACK,
                    // width: 20,
                    // By default our  icon color is white
                    // color: selectedIndex.value == index ? APP_THEME_COLOR : APP_FONT_COLOR,
                  ),
                )
                    : Image.asset(
                  objList.icon!.toString(),
                  width: 30,
                  height: 30,
                  color: BLACK,
                ),
                title: Text(
                  objList.name!,
                ),
                trailing: SvgPicture.asset(
                  IMG_RIGHTARROW_SVG_NEW,
                  height: 15,
                  width: 15,
                )
              // Icon(
              //   Icons.keyboard_arrow_right_sharp,
              // ),
            ),
          ),
          objList.alias == REFERRAL_APPMENUNAME
              ? Divider(
            thickness: 1,
            color: Colors.grey.shade300,
          )
              : SizedBox()
        ],
      ),
    );
  }

  Widget DrawerFooterListData_1() {
    return Expanded(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return DrawerFooterListTile_1(index);
                  },
                  itemCount: arrDrawerFooterListTile.length,
                );
              }),
              SizedBox(
                height: 10,
              ),
              Footer_1()
            ],
          ),
        ));
  }

  Widget DrawerFooterListTile_1(int index) {
    UserrightListClass objList = arrDrawerFooterListTile[index];
    bool isTrue = objList.isselected!;
    return GestureDetector(
      onTap: () {
        SelectMenu(objList.appmenuname!);
        NavigationHandler(index);
      },
      child: Container(
        color: isTrue ? white : APP_GRAY_COLOR,
        child: ListTile(
          leading: Image.asset(
            objList.iconImage!.toString(),
            width: 25,
            height: 25,
          ),
          title: Text(
            objList.pagename!,
          ),
          trailing: Icon(
            Icons.keyboard_arrow_right_sharp,
          ),
        ),
      ),
    );
  }

  Widget Footer_1() {
    return Container(
      color: APP_GRAY_COLOR,
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => Visibility(
                //visible: !CURRENT_MANAGER_STATUS.value,
                visible: CURRENT_LOGIN_VAR.value.trim() != "Manager_Access",
                child: TextButton(
                    onPressed: () => NavigatePrivacyPolicy(),
                    child: Text("Privacy")),
              )),
              Obx(() => Visibility(
                  visible: CURRENT_LOGIN_VAR.value.trim() != "Manager_Access",
                  child: Container(
                    height: 30,
                    child: VerticalDivider(
                      thickness: 1,
                      color: hex("f1f1f1"),
                    ),
                  ))),
              Obx(() => Visibility(
                  visible: CURRENT_LOGIN_VAR.value.trim() != "Manager_Access",
                  child: TextButton(
                      onPressed: () => NavigateTermCondition(),
                      child: Text("T&C")))),
              Obx(() => Visibility(
                  visible: CURRENT_LOGIN_VAR.value.trim() != "Manager_Access",
                  child: Container(
                    height: 30,
                    child: VerticalDivider(
                      thickness: 1,
                      color: hex("f1f1f1"),
                    ),
                  ))),
              TextButton(onPressed: () {
                Get.back();
                Get.to(AboutPage());
              }, child: Obx(() {
                return Text(
                  "v " + lblVersion.value,
                );
              }))
            ],
          )
        ],
      ),
    );
  }

  //</editor-fold>
  //<editor-fold desc ="Account Switch Dialoge">
  SwitchToCustomer() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    LoginDialoge(
        dialogtext: "Are you sure you want Switch to Customer Account?",
        stackicon: SvgPicture.asset(
          IMG_LOGOUT_SVG_NEW,
          color: white,
          height: 35,
        ),
        firstbuttontap: () {
          Get.back();
        },
        secondbuttontap: () async {
          appLoader(contextCommon);
          var sessionmenu = sp.getString(REPEOPLE_CUSTOMER_CREDENTIAL);
          var responseData = json.decode(sessionmenu ?? "");
          storeCustomerLoginSessionData(responseData).then((value) {
            cnt_Bottom.GetMenutList().then((value) {
              Get.deleteAll(force: true).then((value) {
                cnt_Bottom.selectedIndex.value = 0;
                Get.offAll(DashboardPage());
              });
            });
          });
        },
        secondbuttontext: "Yes",
        firstbuttontext: "No");
  }

  SwitchToManager() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    LoginDialoge(
        dialogtext: "Are you sure you want Switch to Manager Account?",
        stackicon: SvgPicture.asset(
          IMG_LOGOUT_SVG_NEW,
          color: white,
          height: 35,
        ),
        firstbuttontap: () {
          Get.back();
        },
        secondbuttontap: () async {
          appLoader(contextCommon);
          var sessionmenu = sp.getString(REPEOPLE_MANAGER_CREDENTIAL);
          var responseData = json.decode(sessionmenu ?? "");
          //StoreCustomerLoginSessionData(responseData).then((value) {
          storeManagerLoginSessionData(responseData).then((value) {
            cnt_Bottom.GetMenutList().then((value) {
              Get.deleteAll(force: true).then((value) {
                Get.offAll(ManagerDashboardPage());
              });
            });
          });
        },
        secondbuttontext: "Yes",
        firstbuttontext: "No");
  }

  LoginDialog() {
    LoginDialoge(
        dialogtext: "You should login first to proceed further.",
        // stackicon: Icon(Icons.exit_to_app,size: 40.0,color:Colors.white,),
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
          Get.back();
          Get.to(LoginPage());
        },
        secondbuttontext: "Yes",
        firstbuttontext: "No");
  }

  ImagePicker imagePicker = ImagePicker();
  RxString image = "".obs;

  profileimagepicker() {
    showCupertinoModalPopup(
        context: Get.context!,
        builder: (context) {
          return CupertinoActionSheet(
            cancelButton: CupertinoActionSheetAction(
              child: Text("Close"),
              onPressed: () {
                Get.back();
              },
            ),
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  Get.back();
                  CheckCameraPermission();
                },
                child: Text(
                  "Camera",
                  style: TextStyle(
                      color: APP_FONT_COLOR,
                      fontSize: 16,
                      fontWeight: FontWeight.normal),
                ),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Get.back();
                  ChooseImage();
                },
                child: Text(
                  "Choose Photo",
                  style: TextStyle(
                      color: APP_FONT_COLOR,
                      fontSize: 16,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ],
          );
        });
  }

  Future<void> CheckCameraPermission() async {
    if (Platform.isAndroid) {
      bool status = await Permission.camera.isGranted;
      if (status) {
        // further process
        CameraSelect();
      } else if (await Permission.camera.isDenied) {
        await Permission.camera.request().then((value) {
          if (value == PermissionStatus.granted) {
            // further process
            CameraSelect();
          } else if (value == PermissionStatus.denied) {
            print("you can not access camera");
          }
        });
      }
    } else {
      CameraSelect();
    }
  }

  void CameraSelect() async {
    print("reached camera select");
    try {
      var response = await imagePicker.pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.front);
      if (response != null) {
        print("response not null");
        File file = File(response.path);
        print("file path");
        print(file);
        _cropImage(file);
      } else {
        print("No image selected");
      }
    } catch (e) {
      print("Error :--- \n $e");
    }
  }

  Future<void> _cropImage(File _pickedFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: _pickedFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      // uiSettings: buildUiSettings(context),
    );
    if (croppedFile != null) {
      image.value = croppedFile.path;
      Edit_Profile();
      print("photo update succesfully");
    }
  }

  Future<void> CheckStoargePermission() async {
    if (Platform.isAndroid) {
      bool status = await Permission.storage.isGranted;
      if (status) {
        // further process
        ChooseImage();
      } else if (await Permission.storage.isDenied) {
        await Permission.storage.request().then((value) {
          if (value == PermissionStatus.granted) {
            // further process
            ChooseImage();
          } else if (value == PermissionStatus.denied) {
            print("you can not access gallery");
          }
        });
      }
    } else {
      ChooseImage();
    }
  }

  void ChooseImage() async {
    try {
      var response = await imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (response != null) {
        File file = File(response.path);
        _cropImage(file);
        // SendUpdatedProfile(file);
      } else {
        print("No Image Selected");
      }
    } catch (e) {
      print("Error :--- \n $e");
    }
  }

  Edit_Profile() async {
    print(image.value);

    SharedPreferences sp = await SharedPreferences.getInstance();
    appLoader(contextCommon);

    Map<String, dynamic> data = {};

    data['action'] = "userprofileupdate";

    if (image.value.isNotEmpty) {
      data['profileimg'] = await dio.MultipartFile.fromFile(image.value);
    }
    var headers = {'userlogintype': sp.getString(SESSION_USERLOGINTYPE) ?? ""};
    print("updateprofiledata**********" + data.toString());

    ApiResponse response = ApiResponse(
      data: data,
      base_url: URL_USERPROFILEDETAILS,
      apiHeaderType: ApiHeaderType.Content,
      headerdata: headers,
    );
    Map<String, dynamic>? responseData = await response.getResponse();

    if (responseData!['status'] == 1) {
      RetrieveUserProfileDetails();
      removeAppLoader(contextCommon);
      SuccessMsg(responseData['message'], title: "Success");
    } else {
      removeAppLoader(contextCommon);
      validationMsg(responseData['message']);
      print(responseData['message']);
    }

    ///  RemoveAppLoader(contextCommon);
  }

  RetrieveUserProfileDetails() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      var data = {
        'action': 'filluserprofile',
      };
      var headers = {
        'userlogintype': sp.getString(SESSION_USERLOGINTYPE) ?? "",
      };
      print(data);
      print(headers);
      ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_USERPROFILEDETAILS,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers,
      );

      Map<String, dynamic>? responseData = await response.getResponse();
      if (responseData!['status'] == 1) {
        print(responseData['data']);
        print(responseData);
        UserProfileModel obj_userprofiledetails =
        UserProfileModel.fromJson(responseData['data']);

        sp.setString(SESSION_EMAIL, obj_userprofiledetails.email ?? "");
        sp.setString(
            SESSION_PERSONNAME, obj_userprofiledetails.personname ?? "");
        sp.setString(SESSION_PROFILEPIC, obj_userprofiledetails.profile ?? "");
      } else {}
    } catch (e) {}
  }
}
