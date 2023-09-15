import 'dart:convert';
import 'dart:io';
import 'package:Repeople/View/DashboardPage/DashboardPage.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Helper/ApiResponse.dart';
import 'package:Repeople/Config/Helper/Logout.dart';
import 'package:Repeople/Config/Helper/shared_prefrence.dart';
import 'package:flutter/material.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Controller/MyAccountController/EditProfileController.dart';
import 'package:Repeople/Model/AddProperty/MyPropertyModel.dart';
import 'package:Repeople/Model/Dashbord/ProjectListClass.dart';
import 'package:Repeople/Model/Theme/WidgetThemeListClass.dart';
import 'package:Repeople/Widgets/CommomBottomSheet.dart';
import 'package:Repeople/Widgets/Loader.dart';
import 'package:Repeople/Widgets/NotificationCustomDrawer/NotificationSettingCustomDrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../CommonHeaderController/CommenHeaderController.dart';

class MyAccountController extends GetxController {
  RxList<WidgetThemeListClass> arrNoFoundListTheme =
      RxList<WidgetThemeListClass>();
  RxList<WidgetThemeListClass> arrAllTheme = RxList<WidgetThemeListClass>();
  RxList<ProjectListClass> arrProjectDataList = RxList<ProjectListClass>();
  RxList<MyPropertyList> propertylist = RxList<MyPropertyList>([]);
  Rx<Future<List<MyPropertyList>>> futurepropertylist =
      Future.value(<MyPropertyList>[]).obs;
  RxInt selectedProjectIndex = 0.obs;
  RxBool Is_Login = false.obs;
  RxString image = "".obs;
  RxString countryCode = "+91".obs;
  RxString firstName = "".obs;
  RxString lastName = "".obs;
  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());
  EditProfileController cnt_edit_profile = Get.put(EditProfileController());
  GlobalKey<ScaffoldState> GlobalMyAccountPagekey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> GlobalMyAccountPagekey2 = GlobalKey<ScaffoldState>();
  @override
  void onInit() {
    super.onInit();

    CreateProjectWidgetTheme();
    futurepropertylist.value = RetrieveMyPropertyListData();
    futurepropertylist.refresh();
    cnt_edit_profile.LoadData();
    getProfileData();
    firstName.value = UserSimplePreference.getString(SESSION_FIRSTNAME) ?? "";
    lastName.value = UserSimplePreference.getString(SESSION_LASTNAME) ?? "";
  }

  @override
  void dispose() {
    Get.delete<EditProfileController>();
    super.dispose();
  }

  UpdateData() {
    cnt_edit_profile.retrieveUserProfileDetails().whenComplete(() {
      getProfileData();
    });
  }

  Future<List<MyPropertyList>> RetrieveMyPropertyListData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    propertylist = RxList([]);
    var data = {'action': 'fillcustomerflat'};

    var headers = {'userlogintype': sp.getString(SESSION_USERLOGINTYPE) ?? ""};

    ApiResponse response = ApiResponse(
      data: data,
      base_url: URL_PROJECTLIST,
      apiHeaderType: ApiHeaderType.Content,
      headerdata: headers,
    );

    Map<String, dynamic>? responseData = await response.getResponse();
    if (responseData!['status'] == 1) {
      List result = responseData['owner_unitdetails'];
      propertylist.value =
          List.from(result.map((e) => MyPropertyList.fromJson(e)));
      propertylist.refresh();
    }
    return propertylist;
  }

  Future<void> UpdateDefaultPropertyData(MyPropertyList obj) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    Apploader(contextCommon);
    var data = {
      'action': 'setdefaultproperty',
      'unitdetails': jsonEncode(obj.toJson()).toString(),
    };
    print(data.toString());
    var headers = {'userlogintype': sp.getString(SESSION_USERLOGINTYPE) ?? ""};

    ApiResponse response = ApiResponse(
      data: data,
      base_url: URL_USERPROFILEDETAILS,
      apiHeaderType: ApiHeaderType.Content,
      headerdata: headers,
    );

    Map<String, dynamic>? responseData = await response.getResponse();
    if (responseData!['status'] == 1) {
      removeAppLoader(contextCommon);
      SuccessMsg(responseData['message']);
      futurepropertylist.value = RetrieveMyPropertyListData();
      futurepropertylist.refresh();
    } else {
      removeAppLoader(contextCommon);
      validationMsg(responseData['message']);
    }
  }

  getProfileData() {
    Is_Login.value = UserSimplePreference.getbool(ISLOGIN) ?? false;
    username.value = UserSimplePreference.getString(SESSION_PERSONNAME) ?? "";
    profile_pic.value =
        UserSimplePreference.getString(SESSION_PROFILEPIC) ?? "";
    firstname.value = UserSimplePreference.getString(SESSION_FIRSTNAME) ?? "";
    firstname.refresh();
    lastname.value = UserSimplePreference.getString(SESSION_LASTNAME) ?? "";
    lastname.refresh();
    mobile.value = UserSimplePreference.getString(SESSION_CONTACT) ?? "";
    alternate_mobile.value = UserSimplePreference.getString(SESSION_ALTERNATE_MOBILE) ?? "";

    customer_id.value = UserSimplePreference.getString(SESSION_CUSTOMER_ID) ?? "";
    email.value = UserSimplePreference.getString(SESSION_EMAIL) ?? "";
    userLoginType.value =
        UserSimplePreference.getString(SESSION_USERLOGINTYPE) ?? "";
    customerID.value = UserSimplePreference.getString(SESSION_CMPID) ?? "";
    userProffessionName.value = UserSimplePreference.getString(SESSION_USERPROFESSIONNAME)??"";
    userProffessionName.refresh();
    isWhatsApp.value = UserSimplePreference.getString(IS_WHATSAPP_KEY) ?? "";
    isAlternateWSwitch.value = UserSimplePreference.getString(ALTERNATE_WHATSAPP_KEY)?? "";
    isAlternateWSwitch.refresh();
  }



  CreateProjectList() {
    arrProjectDataList.add(ProjectListClass(
        "Worldhome Hudson", "Andheri(E)", IMG_BUILD1, ["1 BHK"], false));
    arrProjectDataList.add(ProjectListClass("Worldhome FLorence",
        "Vile Parle(W)", IMG_BUILD2, ["1 BHK", "2 BHK"], false));
    arrProjectDataList.add(ProjectListClass(
        "Worldhome Savannah", "Malad (E)", IMG_BUILD1, ["2 BHK"], false));
    arrProjectDataList.add(ProjectListClass(
        "Worldhome Victoria", "Pokhran Road", IMG_BUILD2, ["3 BHK"], false));
  }

  CreateProjectWidgetTheme() {
    CreateProjectList();
    arrAllTheme.refresh();
  }





  _set_data() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    // setState(() {
    //   delete_all();
    //   sharedPreferences.setString(TOKEN, "");
    //   sharedPreferences.setString("email",null);
    //   sharedPreferences.setString("mobile", null);
    //   sharedPreferences.setString("id", null);
    //   sharedPreferences.setString("is_guest_user", null);
    //   sharedPreferences.setString("user_flat_relations", null);
    //   sharedPreferences.setString("data", null);
    Get.offAll(DashboardPage());
    //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => DashboardPage()));
    //Sign_in
    // });
  }

  Widget LogOutContainer() {
    return GestureDetector(
      onTap: () {
        Logoutdialog();
      },
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "Logout",
            style: semiBoldTextStyle(txtColor: gray_color_1, fontSize: 14),
            // TextStyle(
            //   color: Colors.black,
            //   fontSize: 14,
            //   fontWeight: FontWeight.w600,
            //   //fontFamily: "Poppins-Medium"
            // ),
            textAlign: TextAlign.center,
          )),
    );
  }

  Widget OpenDrawer(){
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_WHITE,
      key: GlobalMyAccountPagekey,
      endDrawer: const NotificationSettingCustomDrawer(
        animatedOffset: Offset(1.0, 0),
      ),
      drawer: const NotificationSettingCustomDrawer(
        animatedOffset: Offset(-1.0, 0),
      ),
    );
  }

}
