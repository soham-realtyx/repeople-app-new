import 'dart:convert';
import 'dart:io';
import 'package:Repeople/Config/Helper/Logout.dart';
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Controller/MyAccountController/EditProfileController.dart';
import 'package:Repeople/View/MyAccountPage/EditProfilePage.dart';
import 'package:Repeople/View/ProjectListPage/AddNewHomePage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Helper/ApiResponse.dart';
import 'package:Repeople/Config/Helper/shared_prefrence.dart';
import 'package:flutter/material.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Model/AddProperty/MyPropertyModel.dart';
import 'package:Repeople/Model/Dashbord/ProjectListClass.dart';
import 'package:Repeople/Model/ProjectDetails/ProjectBasicInfo.dart';
import 'package:Repeople/Model/Theme/WidgetThemeListClass.dart';
import 'package:Repeople/Widgets/CommomBottomSheet.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:Repeople/Widgets/Loader.dart';
import 'package:Repeople/Widgets/ShimmerWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';




class ManagerAccountController extends GetxController {

  RxList<WidgetThemeListClass> arrNoFoundListTheme = RxList<WidgetThemeListClass>();
  RxList<WidgetThemeListClass> arrAllTheme = RxList<WidgetThemeListClass>();
  RxList<ProjectListClass> arrProjectDataList = RxList<ProjectListClass>();
  RxList<MyPropertyList> propertylist = RxList<MyPropertyList>([]);
  Rx<Future<List<MyPropertyList>>> futurepropertylist = Future.value(<MyPropertyList>[]).obs;
  RxInt selectedProjectIndex = 0.obs;
  RxBool Is_Login = false.obs;
  RxString image = "".obs;
  EditProfileController cnt_edit_profile = Get.put(EditProfileController());

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    GetProfileData();
    CreateProjectWidgetTheme();

    futurepropertylist.refresh();
    cnt_edit_profile.LoadData();
  }

  @override
  void dispose() {
    Get.delete<EditProfileController>();
    super.dispose();
  }
  UpdateData(){
    cnt_edit_profile.retrieveUserProfileDetails().whenComplete(() {
      GetProfileData();
      CreateProjectWidgetTheme();
    });
  }



  Future<void> UpdateDefaultPropertyData(MyPropertyList obj) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    Apploader(contextCommon);
    var data = {
      'action': 'setdefaultproperty',
      'unitdetails':jsonEncode( obj.toJson()).toString(),

    };
    print(data.toString());
    var headers = {'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??""};

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
      futurepropertylist.refresh();
    }else{
      removeAppLoader(contextCommon);
      validationMsg(responseData['message']);
    }

  }

  GetProfileData(){
    Is_Login.value = UserSimplePreference.getbool(ISLOGIN) ?? false;
    username.value = UserSimplePreference.getString(SESSION_PERSONNAME) ?? "";
    profile_pic.value = UserSimplePreference.getString(SESSION_PROFILEPIC) ?? "";
    firstname.value = UserSimplePreference.getString(SESSION_FIRSTNAME) ?? "";
    lastname.value = UserSimplePreference.getString(SESSION_LASTNAME) ?? "";
    mobile.value = UserSimplePreference.getString(SESSION_CONTACT) ?? "";
    email.value = UserSimplePreference.getString(SESSION_EMAIL) ?? "";
    userLoginType.value = UserSimplePreference.getString(SESSION_USERLOGINTYPE) ?? "";
    customerID.value = UserSimplePreference.getString(SESSION_CMPID) ?? "";
  }

  CreateNoDataFoundTheme() {
    if (GLOBAL_THEME_INDEX.value == 0) {
      arrNoFoundListTheme.add(WidgetThemeListClass(NODATAFOUND_5, FirstAccount()));
    } else if (GLOBAL_THEME_INDEX.value == 1) {
      arrNoFoundListTheme.add(WidgetThemeListClass(NODATAFOUND_5, SecondAccount()));
    } else if (GLOBAL_THEME_INDEX.value == 2) {
      arrNoFoundListTheme.add(WidgetThemeListClass(NODATAFOUND_5, ThirdAccount()));
    } else if (GLOBAL_THEME_INDEX.value == 3) {
      arrNoFoundListTheme.add(WidgetThemeListClass(NODATAFOUND_5, FourAccount()));
    } else {
      arrNoFoundListTheme.add(WidgetThemeListClass(NODATAFOUND_5, FifthAccount()));
    }

    arrAllTheme = arrNoFoundListTheme;

    CreateProjectList();

    arrNoFoundListTheme.refresh();
    arrAllTheme.refresh();
  }

  CreateProjectList() {
    arrProjectDataList.add(new ProjectListClass(
        "Worldhome Hudson", "Andheri(E)", IMG_BUILD1, ["1 BHK"], false));
    arrProjectDataList.add(new ProjectListClass("Worldhome FLorence",
        "Vile Parle(W)", IMG_BUILD2, ["1 BHK", "2 BHK"], false));
    arrProjectDataList.add(new ProjectListClass(
        "Worldhome Savannah", "Malad (E)", IMG_BUILD1, ["2 BHK"], false));
    arrProjectDataList.add(new ProjectListClass(
        "Worldhome Victoria", "Pokhran Road", IMG_BUILD2, ["3 BHK"], false));
  }

  CreateProjectWidgetTheme() {
    CreateProjectList();
    arrAllTheme.refresh();
  }

  Widget Edit() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(left: 20, right: 20, top: 30),
      padding: const EdgeInsets.only(left: 2, right: 5),
      child: EditButton_1(),
    );
  }

  Widget EditButton_1() {
    return OnTapButton(
        onTap: () {
          Get.to(EditProfilePage())?.then((value) {
            GetProfileData();
          });
        },
        width: Get.width - 32,
        height: 50,
        decoration: CustomDecorations()
            .backgroundlocal(APP_THEME_COLOR, cornarradius, 0, APP_THEME_COLOR),
        text: "Edit",
        style: semiBoldTextStyle(txtColor: white, fontSize: 14)
    );
  }

  Widget LogOutContainer() {
    return GestureDetector(
      onTap: () {

        LogoutManagerdialog();
      },
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "Logout",
            style: semiBoldTextStyle(txtColor: gray_color_1, fontSize: 14),
            textAlign: TextAlign.center,
          )),
    );
  }


  Widget propertyistwidget(){
    return       Obx((){
      return  FutureBuilder(
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            if(propertylist.isNotEmpty)
              return  Container(
                  height: 230.h,
                  child: Obx(() => ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: propertylist.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Card(
                          margin: EdgeInsets.only(left: index==0?20:0 , right: 15, top: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(cornarradius)),
                          ),
                          elevation: 3,
                          shadowColor: hex("266CB5").withOpacity(0.03),
                          child: propertylist[index].inventorytype.toString().toLowerCase()=="unit"?Container(

                              width: Get.width -50,
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                              //margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                              //padding: EdgeInsets.all(kpadding15.w),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Owner",
                                              style:
                                              boldTextStyle(txtColor: Colors.black, fontSize: 16),
                                              // TextStyle(
                                              //   color: Colors.black,
                                              //   fontSize: 15,
                                              //   fontWeight: FontWeight.w700,
                                              //   //fontFamily: "Poppins-Medium"
                                              // ),

                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(width: 8,),
                                            if( index==0 )
                                              InkWell(
                                                hoverColor: AppColors.TRANSPARENT,
                                                highlightColor: AppColors.TRANSPARENT,
                                                splashColor: AppColors.TRANSPARENT,
                                                child: Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 8, vertical: 3),
                                                    decoration: CustomDecorations()
                                                        .backgroundlocal(TRANSPARENT, cornarradius, 0, GREEN),
                                                    child: Text(
                                                      "Default",
                                                      style: regularTextStyle(
                                                          txtColor: GREEN, fontSize: 10),
                                                    )),
                                              ),
                                            if(index!=0)
                                              InkWell(
                                                hoverColor: AppColors.TRANSPARENT,
                                                highlightColor: AppColors.TRANSPARENT,
                                                splashColor: AppColors.TRANSPARENT,
                                                onTap: (){
                                                  UpdateDefaultPropertyData(propertylist[index]);
                                                },
                                                child: Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 8, vertical: 3),
                                                    decoration: CustomDecorations()
                                                        .backgroundlocal
                                                      (TRANSPARENT, cornarradius,
                                                        0, APP_THEME_COLOR),
                                                    child: Text(
                                                      "Set as default",
                                                      style: regularTextStyle(
                                                          txtColor: APP_THEME_COLOR, fontSize: 10),
                                                    )),
                                              ),

                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            // if( index==0 )
                                            //   InkWell(
                                            //     hoverColor: AppColors.TRANSPARENT,
                                            //     highlightColor: AppColors.TRANSPARENT,
                                            //     splashColor: AppColors.TRANSPARENT,
                                            //     child: Container(
                                            //         padding: EdgeInsets.symmetric(
                                            //             horizontal: 10, vertical: 5),
                                            //         decoration: CustomDecorations()
                                            //             .backgroundlocal(TRANSPARENT, 20, 0, GREEN),
                                            //         child: Text(
                                            //           "Default",
                                            //           style: regularTextStyle(
                                            //               txtColor: GREEN, fontSize: 13),
                                            //         )),
                                            //   ),
                                            SizedBox(width: 10,),
                                            // InkWell(
                                            //   hoverColor: AppColors.TRANSPARENT,
                                            //   highlightColor: AppColors.TRANSPARENT,
                                            //   splashColor: AppColors.TRANSPARENT,
                                            //   onTap: (){
                                            //     Get.to(AddNewHomePage(title: "Edit Home"));
                                            //   },
                                            //   child: Container(
                                            //       padding: EdgeInsets.symmetric(
                                            //           horizontal: 10, vertical: 5),
                                            //       decoration: CustomDecorations()
                                            //           .backgroundlocal(TRANSPARENT, cornarradius, 0, DARK_BLUE),
                                            //       child: Text(
                                            //         "Edit",
                                            //         style: semiBoldTextStyle(
                                            //             txtColor: DARK_BLUE, fontSize: 11),
                                            //       )),
                                            // ),

                                          ],
                                        ),

                                      ],
                                    ),
                                    // SizedBox(height: 5,),
                                    // Text(
                                    //   "soham@insomniacs.com",
                                    //   style: TextStyle(
                                    //     color: Colors.grey,
                                    //     fontSize: 14,
                                    //     fontWeight: FontWeight.w600,
                                    //     //fontFamily: "Poppins-Medium"
                                    //   ),
                                    //   textAlign: TextAlign.center,
                                    // ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Project",
                                      style: TextStyle(
                                          color: gray_color_1,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                      // TextStyle(
                                      //   color: Colors.grey,
                                      //   fontSize: 14,
                                      //   fontWeight: FontWeight.w600,
                                      //   //fontFamily: "Poppins-Medium"
                                      // ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      propertylist[index].project??"",
                                      style: boldTextStyle(txtColor: Colors.black, fontSize: 16),
                                      // TextStyle(
                                      //   color: Colors.black,
                                      //   fontSize: 15,
                                      //   fontWeight: FontWeight.w700,
                                      //   //fontFamily: "Poppins-Medium"
                                      // ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Building",
                                      style: TextStyle(
                                          color: gray_color_1,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                      // TextStyle(
                                      //   color: Colors.grey,
                                      //   fontSize: 14,
                                      //   fontWeight: FontWeight.w600,
                                      //   //fontFamily: "Poppins-Medium"
                                      // ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      propertylist[index].building??"",
                                      style: boldTextStyle(txtColor: Colors.black, fontSize: 16),
                                      // TextStyle(
                                      //   color: Colors.black,
                                      //   fontSize: 15,
                                      //   fontWeight: FontWeight.w700,
                                      //   //fontFamily: "Poppins-Medium"
                                      // ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Unit No.",
                                      style: TextStyle(
                                          color: gray_color_1,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                      // TextStyle(
                                      //   color: Colors.grey,
                                      //   fontSize: 14,
                                      //   fontWeight: FontWeight.w600,
                                      //   //fontFamily: "Poppins-Medium"
                                      // ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      propertylist[index].name??"",
                                      style: boldTextStyle(txtColor: Colors.black, fontSize: 16),
                                      // TextStyle(
                                      //   color: Colors.black,
                                      //   fontSize: 15,
                                      //   fontWeight: FontWeight.w700,
                                      //   //fontFamily: "Poppins-Medium"
                                      // ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ])):Container(
                            // decoration: BoxDecoration(
                            //   color: Colors.white,
                            //   borderRadius: BorderRadius.circular(8),
                            //   boxShadow: [
                            //     BoxShadow(
                            //       color: Colors.black12,
                            //       offset: const Offset(
                            //         5.0,
                            //         5.0,
                            //       ),
                            //       blurRadius: 10.0,
                            //       spreadRadius: 2.0,
                            //     ), //BoxShadow
                            //     BoxShadow(
                            //       color: Colors.white,
                            //       offset: const Offset(0.0, 0.0),
                            //       blurRadius: 0.0,
                            //       spreadRadius: 0.0,
                            //     ), //BoxShadow
                            //   ],
                            // ),
                            //alignment: Alignment.bottomCenter,
                              width: Get.width -50,
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                              //margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                              //padding: EdgeInsets.all(kpadding15.w),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Owner",
                                              style:
                                              boldTextStyle(txtColor: Colors.black, fontSize: 16),
                                              // TextStyle(
                                              //   color: Colors.black,
                                              //   fontSize: 15,
                                              //   fontWeight: FontWeight.w700,
                                              //   //fontFamily: "Poppins-Medium"
                                              // ),

                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(width: 8,),
                                            if( index==0 )
                                              InkWell(
                                                hoverColor: AppColors.TRANSPARENT,
                                                highlightColor: AppColors.TRANSPARENT,
                                                splashColor: AppColors.TRANSPARENT,
                                                child: Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 8, vertical: 3),
                                                    decoration: CustomDecorations()
                                                        .backgroundlocal(TRANSPARENT, cornarradius, 0, GREEN),
                                                    child: Text(
                                                      "Default",
                                                      style: regularTextStyle(
                                                          txtColor: GREEN, fontSize: 10),
                                                    )),
                                              ),
                                            if(index!=0)
                                              InkWell(
                                                hoverColor: AppColors.TRANSPARENT,
                                                highlightColor: AppColors.TRANSPARENT,
                                                splashColor: AppColors.TRANSPARENT,
                                                onTap: (){
                                                  UpdateDefaultPropertyData(propertylist[index]);
                                                },
                                                child: Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 8, vertical: 3),
                                                    decoration: CustomDecorations()
                                                        .backgroundlocal
                                                      (TRANSPARENT, cornarradius,
                                                        0, APP_THEME_COLOR),
                                                    child: Text(
                                                      "Set as default",
                                                      style: regularTextStyle(
                                                          txtColor: APP_THEME_COLOR, fontSize: 10),
                                                    )),
                                              ),

                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            // if( index==0 )
                                            //   InkWell(
                                            //     hoverColor: AppColors.TRANSPARENT,
                                            //     highlightColor: AppColors.TRANSPARENT,
                                            //     splashColor: AppColors.TRANSPARENT,
                                            //     child: Container(
                                            //         padding: EdgeInsets.symmetric(
                                            //             horizontal: 10, vertical: 5),
                                            //         decoration: CustomDecorations()
                                            //             .backgroundlocal(TRANSPARENT, 20, 0, GREEN),
                                            //         child: Text(
                                            //           "Default",
                                            //           style: regularTextStyle(
                                            //               txtColor: GREEN, fontSize: 13),
                                            //         )),
                                            //   ),
                                            SizedBox(width: 10,),
                                            // InkWell(
                                            //   hoverColor: AppColors.TRANSPARENT,
                                            //   highlightColor: AppColors.TRANSPARENT,
                                            //   splashColor: AppColors.TRANSPARENT,
                                            //   onTap: (){
                                            //     Get.to(AddNewHomePage(title: "Edit Home"));
                                            //   },
                                            //   child: Container(
                                            //       padding: EdgeInsets.symmetric(
                                            //           horizontal: 10, vertical: 5),
                                            //       decoration: CustomDecorations()
                                            //           .backgroundlocal(TRANSPARENT, cornarradius, 0, DARK_BLUE),
                                            //       child: Text(
                                            //         "Edit",
                                            //         style: semiBoldTextStyle(
                                            //             txtColor: DARK_BLUE, fontSize: 11),
                                            //       )),
                                            // ),

                                          ],
                                        ),

                                      ],
                                    ),
                                    // SizedBox(height: 5,),
                                    // Text(
                                    //   "soham@insomniacs.com",
                                    //   style: TextStyle(
                                    //     color: Colors.grey,
                                    //     fontSize: 14,
                                    //     fontWeight: FontWeight.w600,
                                    //     //fontFamily: "Poppins-Medium"
                                    //   ),
                                    //   textAlign: TextAlign.center,
                                    // ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Project",
                                      style: TextStyle(
                                          color: gray_color_1,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                      // TextStyle(
                                      //   color: Colors.grey,
                                      //   fontSize: 14,
                                      //   fontWeight: FontWeight.w600,
                                      //   //fontFamily: "Poppins-Medium"
                                      // ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      propertylist[index].project??"",
                                      style: boldTextStyle(txtColor: Colors.black, fontSize: 16),
                                      // TextStyle(
                                      //   color: Colors.black,
                                      //   fontSize: 15,
                                      //   fontWeight: FontWeight.w700,
                                      //   //fontFamily: "Poppins-Medium"
                                      // ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Inventory Type",
                                      style: TextStyle(
                                          color: gray_color_1,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                      // TextStyle(
                                      //   color: Colors.grey,
                                      //   fontSize: 14,
                                      //   fontWeight: FontWeight.w600,
                                      //   //fontFamily: "Poppins-Medium"
                                      // ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      propertylist[index].inventorytype??"",
                                      style: boldTextStyle(txtColor: Colors.black, fontSize: 16),
                                      // TextStyle(
                                      //   color: Colors.black,
                                      //   fontSize: 15,
                                      //   fontWeight: FontWeight.w700,
                                      //   //fontFamily: "Poppins-Medium"
                                      // ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Details",
                                      style: TextStyle(
                                          color: gray_color_1,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                      // TextStyle(
                                      //   color: Colors.grey,
                                      //   fontSize: 14,
                                      //   fontWeight: FontWeight.w600,
                                      //   //fontFamily: "Poppins-Medium"
                                      // ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      propertylist[index].unitdetails??"",
                                      style: boldTextStyle(txtColor: Colors.black, fontSize: 16),
                                      // TextStyle(
                                      //   color: Colors.black,
                                      //   fontSize: 15,
                                      //   fontWeight: FontWeight.w700,
                                      //   //fontFamily: "Poppins-Medium"
                                      // ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ])));


                    },)));
            else
              return Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //SizedBox(height: 20.h,),
                  //Image(image: AssetImage("assets/images/nodatafound.png"),height: 150),
                  // Padding(padding: EdgeInsets.only(top:15,bottom: 5,),
                  //   child:Text('No Data Found',style:
                  //   semiBoldTextStyle(fontSize: 15)
                  //     // TextStyle(fontSize: 15,fontWeight:FontWeight.bold,),
                  //   ),),
                ],
              ),);
          } else {
            return ProjectShimmerEffect();
          }
        },
        future: futurepropertylist.value,
      );
    });
  }

  Widget ProjectShimmerEffect() {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        enabled: true,
        child: Container(
          height: 255.h,
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(cornarradius),
            ),),
          child: ListView.builder(
              itemCount: 2,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder:(_,index){
                return   Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(cornarradius),
                    ),),
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      shimmerWidget(height: 250.h, width: Get.width, radius: 0),
                    ],
                  ),
                );
              } ),
        )


    );
  }

  Widget UserLayout() {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 20,bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() =>Visibility(
                  visible: propertylist.isNotEmpty
                  ,child:  Text("Properties",style: mediumTextStyle(txtColor: BLACK,fontSize: 16)))),
              Add_New_Home(),
            ],
          ),
        ),
        propertyistwidget(),


      ],
    );

  }

  Widget FirstAccount() {
    return Obx(() => Container(
      child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AccountLayout1(),
            if( userLoginType.value!="4")  UserLayout(),
            SizedBox(height: 20),
            LogOutContainer(),
            SizedBox(height: 20),
          ]),
    ));
  }
  Widget SecondAccount() {
    return Container(
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AccountLayout2(),
            UserLayout(),
            Edit(),
            LogOutContainer(),
            SizedBox(height: 70),
          ]),
    );
  }
  Widget ThirdAccount() {
    return Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AccountLayout3(),
            UserLayout(),
            Edit(),
            LogOutContainer(),
            SizedBox(
              height: 70,
            ),
          ]),
    );
  }
  Widget FourAccount() {
    return Container(
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AccountLayout4(),
            UserLayout(),
            Edit(),
            LogOutContainer(),
            SizedBox(
              height: 70,
            ),
          ]),
    );
  }
  Widget FifthAccount() {
    return Container(
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Row(
                children: [
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey.shade300,
                    ),
                    child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Center(
                        child: Icon(
                          Icons.arrow_back_ios_new_outlined,
                          size: 17,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    ACCOUNTMENU,
                    style: TextStyle(
                      color: APP_FONT_COLOR,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
            AccountLayout5(),
            UserLayout(),
            Edit(),
            LogOutContainer(),
            SizedBox(
              height: 70,
            ),
          ]),
    );
  }



  Widget Add_New_Home() {
    return OnTapButton(
        onTap: () {
          Get.to(AddNewHomePage(title: '',));
        },
        width: 130,
        height: 30,
        decoration: CustomDecorations().backgroundlocal(APP_THEME_COLOR, cornarradius, 0, APP_THEME_COLOR),
        text: "Add New Property",
        style:
        semiBoldTextStyle(txtColor: white,fontSize: 11)
      // TextStyle(color: WHITE, fontWeight: FontWeight.w600, fontSize: 11)
    );
  }



  Widget EditButton(){
    return OnTapButton(
      onTap: () async{
        Get.to(EditProfilePage())?.then((value) {
          GetProfileData();
        });
      },
      width: 100,
      height: 30,
      decoration: CustomDecorations().backgroundlocal(TRANSPARENT, cornarradius, 0, DARK_BLUE),
      text: "Edit",
      style:  semiBoldTextStyle(
          txtColor: DARK_BLUE, fontSize: 11),);

  }

  Widget AccountLayout1() {

    return   Obx(() =>  Stack(
        clipBehavior: Clip.none,
        children: [
          Card(
              margin: EdgeInsets.only(left: 20, right: 20, top: 80),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(cornarradius)),
              ),
              elevation: 3,
              shadowColor: hex("266CB5").withOpacity(0.03),
              child: Container(
                  alignment: Alignment.bottomCenter,
                  width: double.infinity,
                  padding:
                  EdgeInsets.only(bottom: 60, top: 80, left: 30, right: 30),
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(username.value , style:
                        boldTextStyle(txtColor: Colors.black, fontSize: 16), textAlign: TextAlign.center,),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          email.value,
                          style: TextStyle(
                              color: gray_color_1,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "+91 ",
                              style: TextStyle(
                                  color: gray_color_1,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              mobile.value,
                              style: TextStyle(
                                  color: gray_color_1,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          UserSimplePreference.getString(SESSION_USERLOGINTYPENAME)??"",
                          style: TextStyle(
                              color: gray_color_1,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10,
                        ),

                      ]))),
          Positioned(
              left: 0,
              right: 0,
              bottom: 170,
              child: Align(
                  alignment: Alignment.bottomCenter, child: LoginUserImage_1())),
          Positioned(
              right: 0,
              left: 0,
              bottom: 23,
              child: Align(
                  alignment: Alignment.bottomCenter, child:EditButton()))
        ]));
  }

  Widget AccountLayout2() {
    return Stack(clipBehavior: Clip.none, children: [
      Card(
          margin: EdgeInsets.only(left: 20, right: 20, top: 80),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(cornarradius)),
          ),
          elevation: 5,
          shadowColor: white,
          child: Container(
            // decoration: BoxDecoration(
            //   color: Colors.white,
            //   borderRadius: BorderRadius.circular(8),
            //   boxShadow: [
            //     BoxShadow(
            //       color: Colors.black12,
            //       offset: const Offset(
            //         5.0,
            //         5.0,
            //       ),
            //       blurRadius: 10.0,
            //       spreadRadius: 2.0,
            //     ), //BoxShadow
            //     BoxShadow(
            //       color: Colors.white,
            //       offset: const Offset(0.0, 0.0),
            //       blurRadius: 0.0,
            //       spreadRadius: 0.0,
            //     ), //BoxShadow
            //   ],
            // ),
              alignment: Alignment.bottomCenter,
              width: double.infinity,
              padding:
              EdgeInsets.only(bottom: 20, top: 70, left: 30, right: 30),
              //margin: EdgeInsets.only(left: 20, right: 20, top: 80),
              //padding: EdgeInsets.all(kpadding15.w),
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      UserSimplePreference.getString(SESSION_PERSONNAME).toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        //fontFamily: "Poppins-Medium"
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      UserSimplePreference.getString(SESSION_EMAIL).toString(),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        //fontFamily: "Poppins-Medium"
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "+91 "+ UserSimplePreference.getString(SESSION_CONTACT).toString(),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        //fontFamily: "Poppins-Medium"
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      UserSimplePreference.getString(SESSION_USERLOGINTYPENAME)??"",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        //fontFamily: "Poppins-Medium"
                      ),
                      textAlign: TextAlign.center,
                    ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                  ]))),
      Positioned(
          left: 0,
          right: 0,
          bottom: 120,
          child: Align(
              alignment: Alignment.bottomCenter, child: LoginUserImage_2()))
    ]);
  }

  Widget AccountLayout3() {
    return Stack(clipBehavior: Clip.none, children: [
      Card(
          margin: EdgeInsets.only(left: 20, right: 20, top: 80),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(cornarradius)),
          ),
          elevation: 5,
          shadowColor: white,
          child: Container(
            // decoration: BoxDecoration(
            //   color: Colors.white,
            //   borderRadius: BorderRadius.circular(8),
            //   boxShadow: [
            //     BoxShadow(
            //       color: Colors.black12,
            //       offset: const Offset(
            //         5.0,
            //         5.0,
            //       ),
            //       blurRadius: 10.0,
            //       spreadRadius: 2.0,
            //     ), //BoxShadow
            //     BoxShadow(
            //       color: Colors.white,
            //       offset: const Offset(0.0, 0.0),
            //       blurRadius: 0.0,
            //       spreadRadius: 0.0,
            //     ), //BoxShadow
            //   ],
            // ),
              alignment: Alignment.bottomCenter,
              width: double.infinity,
              padding:
              EdgeInsets.only(bottom: 20, top: 70, left: 30, right: 30),
              //margin: EdgeInsets.only(left: 20, right: 20, top: 80),
              //padding: EdgeInsets.all(kpadding15.w),
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      UserSimplePreference.getString(SESSION_PERSONNAME).toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        //fontFamily: "Poppins-Medium"
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      UserSimplePreference.getString(SESSION_EMAIL).toString(),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        //fontFamily: "Poppins-Medium"
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "+91 "+UserSimplePreference.getString(SESSION_CONTACT).toString(),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        //fontFamily: "Poppins-Medium"
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      UserSimplePreference.getString(SESSION_USERLOGINTYPENAME)??"",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        //fontFamily: "Poppins-Medium"
                      ),
                      textAlign: TextAlign.center,
                    ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                  ]))),
      Positioned(
          left: 0,
          right: 0,
          bottom: 120,
          child: Align(
              alignment: Alignment.bottomCenter, child: LoginUserImage_3()))
    ]);
  }

  Widget AccountLayout4() {
    return Stack(clipBehavior: Clip.none, children: [
      Card(
          margin: EdgeInsets.only(left: 20, right: 20, top: 80),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(cornarradius)),
          ),
          elevation: 5,
          shadowColor: white,
          child: Container(
            // decoration: BoxDecoration(
            //   color: Colors.white,
            //   borderRadius: BorderRadius.circular(8),
            //   boxShadow: [
            //     BoxShadow(
            //       color: Colors.black12,
            //       offset: const Offset(
            //         5.0,
            //         5.0,
            //       ),
            //       blurRadius: 10.0,
            //       spreadRadius: 2.0,
            //     ), //BoxShadow
            //     BoxShadow(
            //       color: Colors.white,
            //       offset: const Offset(0.0, 0.0),
            //       blurRadius: 0.0,
            //       spreadRadius: 0.0,
            //     ), //BoxShadow
            //   ],
            // ),
              alignment: Alignment.bottomCenter,
              width: double.infinity,
              padding:
              EdgeInsets.only(bottom: 20, top: 70, left: 30, right: 30),
              //margin: EdgeInsets.only(left: 20, right: 20, top: 80),
              //padding: EdgeInsets.all(kpadding15.w),
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      UserSimplePreference.getString(SESSION_PERSONNAME).toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        //fontFamily: "Poppins-Medium"
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      UserSimplePreference.getString(SESSION_EMAIL).toString(),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        //fontFamily: "Poppins-Medium"
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "+91 "+UserSimplePreference.getString(SESSION_CONTACT).toString(),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        //fontFamily: "Poppins-Medium"
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      UserSimplePreference.getString(SESSION_USERLOGINTYPENAME)??"",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        //fontFamily: "Poppins-Medium"
                      ),
                      textAlign: TextAlign.center,
                    ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                  ]))),
      Positioned(
          left: 0,
          right: 0,
          bottom: 120,
          child: Align(
              alignment: Alignment.bottomCenter, child: LoginUserImage_4()))
    ]);
  }

  Widget AccountLayout5() {
    return Stack(clipBehavior: Clip.none, children: [
      Card(
          margin: EdgeInsets.only(left: 20, right: 20, top: 80),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(cornarradius)),
          ),
          elevation: 5,
          shadowColor: white,
          child: Container(
            // decoration: BoxDecoration(
            //   color: Colors.white,
            //   borderRadius: BorderRadius.circular(8),
            //   boxShadow: [
            //     BoxShadow(
            //       color: Colors.black12,
            //       offset: const Offset(
            //         5.0,
            //         5.0,
            //       ),
            //       blurRadius: 10.0,
            //       spreadRadius: 2.0,
            //     ), //BoxShadow
            //     BoxShadow(
            //       color: Colors.white,
            //       offset: const Offset(0.0, 0.0),
            //       blurRadius: 0.0,
            //       spreadRadius: 0.0,
            //     ), //BoxShadow
            //   ],
            // ),
              alignment: Alignment.bottomCenter,
              width: double.infinity,
              padding:
              EdgeInsets.only(bottom: 20, top: 70, left: 30, right: 30),
              //margin: EdgeInsets.only(left: 20, right: 20, top: 80),
              //padding: EdgeInsets.all(kpadding15.w),
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      UserSimplePreference.getString(SESSION_PERSONNAME).toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        //fontFamily: "Poppins-Medium"
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      UserSimplePreference.getString(SESSION_EMAIL).toString(),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        //fontFamily: "Poppins-Medium"
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "+91 "+ UserSimplePreference.getString(SESSION_CONTACT).toString(),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        //fontFamily: "Poppins-Medium"
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      UserSimplePreference.getString(SESSION_USERLOGINTYPENAME)??"",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        //fontFamily: "Poppins-Medium"
                      ),
                      textAlign: TextAlign.center,
                    ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                  ]))),
      Positioned(
          left: 0,
          right: 0,
          bottom: 120,
          child: Align(
              alignment: Alignment.bottomCenter, child: LoginUserImage_5()))
    ]);
  }



  Widget LoginUserImage_1() {
    return Obx(
          () => Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:AppColors.BACKGROUND_WHITE
            ),
            //shape: RoundedRectangleBorder(
            //borderRadius: BorderRadius.all(Radius.circular(60))
            //),
            //elevation: 5,
            //shadowColor: WHITE,
            child: InkWell(
              onTap: (){

                if(Is_Login.isTrue){

                  Get.to(EditProfilePage());
                }
                else{
                  Get.back();
                  //LoginDialog();
                }
              },
              child: Container(
                width: 120,
                height: 120,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(shape: BoxShape.circle,color: AppColors.BACKGROUND_WHITE),
                //CustomDecorations().backgroundlocal(WHITE, 50, 0, WHITE),
                padding: EdgeInsets.all(5),
                child:   !Is_Login.isTrue?
                SvgPicture.asset(IMG_PROFILEDEFAULT_SVG_NEW)
                // Image.asset(
                //   IMG_USER_LOGIN,
                //   color: Colors.blue.shade200,
                // )
                    :
                image.value!="" ?
                Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle
                      //borderRadius: BorderRadius.circular(10)
                    ),
                    child: Image.file(File(image.value),fit: BoxFit.cover,)):
                Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle
                      //borderRadius: BorderRadius.circular(10)
                    ),
                    child: Image(image: NetworkImage(
                        profile_pic.value),
                        fit: BoxFit.cover)),
              ),
            ),
          ),
          Container(
            width: 130,
            height: 120,
            color: Colors.transparent,
          ),
          /* GestureDetector(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              elevation: 0,
              shadowColor: WHITE,
              child: InkWell(
                onTap: () {
                  // print("yes reach");
                  // if(Is_Login.isTrue){
                  //   print("yes reach");
                  //   MyAccountPage();}
                  // else{
                  //   Get.back();
                  //   LoginDialog();
                  //
                  // }
                },
                child: Container(
                  width: 110,
                  height: 120,
                  clipBehavior: Clip.hardEdge,
                  decoration:
                      CustomDecorations().backgroundlocal(WHITE, 10, 0, WHITE),
                  padding: EdgeInsets.all(12),
                  child: !Is_Login.isTrue
                      ? GestureDetector(
                          onTap: () {
                            // Get.back();
                            //LoginDialog();
                            Get.to(EditProfilePage());
                          },
                          child: Image.asset(
                            IMG_USER_LOGIN,
                            color: Colors.blue.shade200,
                          ))
                      : image.value != null && image.value != ""
                          ? Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Image.file(
                                File(image.value),
                                fit: BoxFit.cover,
                              ))
                          : Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Image(
                                  image: NetworkImage(
                                      "https://images.indianexpress.com/2017/12/kartik-aaryan-7591.jpg"),
                                  fit: BoxFit.cover)),
                ),
              ),
            ),
          ),*/
        ],
      ),
    );
  }

  Widget LoginUserImage_2() {
    return Obx(() => Stack(
      children: [
        Container(
          width: 130,
          height: 120,
          color: Colors.transparent,
        ),
        Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(60))),
          elevation: 5,
          shadowColor: white,
          child: GestureDetector(
            onTap: () {
              // if(Is_Login.isTrue){   MyAccountPage();}
              // else{
              // Get.back();
              // LoginDialog();
              // }
            },
            child: Container(
              width: 100,
              height: 100,
              clipBehavior: Clip.hardEdge,
              decoration:
              CustomDecorations().backgroundlocal(white, 60, 0, white),
              padding: EdgeInsets.all(8),
              child: Is_Login.isFalse
                  ? GestureDetector(
                  onTap: () {
                    // Get.back();
                    //LoginDialog();
                    Get.to(EditProfilePage());
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      IMG_USER_LOGIN,
                      color: Colors.blue.shade200,
                    ),
                  ))
                  : image.value != ""
                  ? Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.file(
                    File(image.value),
                    fit: BoxFit.cover,
                  ))
                  : Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image(
                      image: NetworkImage(
                          profile_pic.value),
                      fit: BoxFit.cover)),
            ),
          ),
        ),
      ],
    ));
  }

  Widget LoginUserImage_3() {
    return Stack(
      children: [
        Container(
          width: 130,
          height: 120,
          color: Colors.transparent,
        ),
        Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(60))),
          elevation: 5,
          child: Container(
            width: 100,
            height: 100,
            decoration:
            CustomDecorations().backgroundlocal(white, 60, 0, white),
            padding: EdgeInsets.all(10),
            child: Is_Login.isFalse
                ? GestureDetector(
                onTap: () {
                  // Get.back();
                  //LoginDialog();
                  Get.to(EditProfilePage());
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    IMG_USER_LOGIN,
                    color: Colors.blue.shade100,
                  ),
                ))
                : image.value != ""
                ? Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: Image.file(
                  File(image.value),
                  fit: BoxFit.cover,
                ))
                : Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: Image(
                    image: NetworkImage(
                        profile_pic.value),
                    fit: BoxFit.cover)),
          ),
        ),
        // Positioned(
        //   right: 20,
        //   bottom: 25,
        //   child: GestureDetector(
        //     onTap: (){
        //       if(Is_Login.isTrue){ profileimagepicker();}
        //       else{
        //         Get.back();
        //         LoginDialog();
        //
        //       }
        //     },
        //     child: Container(
        //       height: 25,
        //       width: 25,
        //       decoration:
        //       BoxDecoration(color: Colors.blue.shade900, borderRadius: BorderRadius.circular(50)),
        //       child: Icon(
        //         Icons.camera_alt,
        //         color: WHITE,
        //         size: 15,
        //       ),
        //     ),
        //   ),
        // )
      ],
    );
  }

  Widget LoginUserImage_4() {
    return Obx(() => Stack(
      children: [
        Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          elevation: 2,
          shadowColor: APP_FONT_COLOR,
          clipBehavior: Clip.hardEdge,
          child: Container(
            width: 100,
            height: 100,
            decoration: CustomDecorations()
                .backgroundlocal(white, cornarradius, 0, white),
            padding: EdgeInsets.all(10),
            child: Is_Login.isFalse
                ? GestureDetector(
                onTap: () {
                  // Get.back();
                  //LoginDialog();
                  Get.to(EditProfilePage());
                },
                child: Image.asset(IMG_USER_LOGIN,
                    color: DARK_BLUE_WITH_OPACITY))
                : image.value != ""
                ? Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(cornarradius)),
                child: Image.file(
                  File(image.value),
                  fit: BoxFit.cover,
                ))
                : Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(cornarradius)),
                child: Image(
                    image: NetworkImage(
                        profile_pic.value),
                    fit: BoxFit.cover)),
          ),
        ),
        // Positioned(
        //   right: 5,
        //   bottom: 5,
        //   child: GestureDetector(
        //     onTap: (){
        //       if(Is_Login.isTrue){ profileimagepicker();}
        //       else{
        //         Get.back();
        //         LoginDialog();
        //
        //       }
        //     },
        //     child: Container(
        //       height: 25,
        //       width: 25,
        //       decoration:
        //       CustomDecorations().backgroundlocal(APP_THEME_COLOR, 50, 0, APP_THEME_COLOR),
        //       child: Icon(
        //         Icons.camera_alt,
        //         color: WHITE,
        //         size: 15,
        //       ),
        //     ),
        //   ),
        // )
      ],
    ));
  }

  Widget LoginUserImage_5() {
    return Obx(() => Stack(
      children: [
        Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            elevation: 2,
            shadowColor: APP_FONT_COLOR,
            clipBehavior: Clip.hardEdge,
            child: Container(
                width: 100,
                height: 100,
                decoration: CustomDecorations()
                    .backgroundlocal(white, cornarradius, 0, white),
                padding: EdgeInsets.all(10),
                child: Is_Login.isFalse
                    ? GestureDetector(
                    onTap: () {
                      // Get.back();
                      //LoginDialog();
                      Get.to(EditProfilePage());
                    },
                    child: Image.asset(IMG_USER_LOGIN,
                        color: DARK_BLUE_WITH_OPACITY))
                    : GestureDetector(
                  onTap: () {
                    Get.back();
                    //Get.to(MyAccountPage());
                  },
                  child: Container(
                    child: image.value != ""
                        ? Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                cornarradius)),
                        child: Image.file(
                          File(image.value),
                          fit: BoxFit.cover,
                        ))
                        : Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                cornarradius)),
                        child: Image(
                            image: NetworkImage(
                                profile_pic.value),
                            fit: BoxFit.cover)),
                  ),
                ))),

      ],
    ));
  }
}
