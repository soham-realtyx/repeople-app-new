
import 'dart:io';

import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/Helper/HextoColor.dart';
import 'package:Repeople/Config/Helper/MoengageAnalyticsHandler.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Controller/Drawer/DrawerController.dart';
import 'package:Repeople/Model/DrawerModal/DrawerModal.dart';
import 'package:Repeople/View/LoginPage/LoginPage.dart';
import 'package:Repeople/View/MyAccountPage/MyAccountPage.dart';
import 'package:Repeople/View/ScheduleSitePage/ScheduleSitePage.dart';
import 'package:Repeople/Widgets/Animation/AnimatedDrawer.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDrawer extends StatefulWidget {
  final Offset? animatedOffset;
  final bool? isRegistered;
  CustomDrawer({super.key,this.animatedOffset,this.isRegistered});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  CustomDrawerController cntDrawer = Get.put(CustomDrawerController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cntDrawer.isRegistered.value=widget.isRegistered??false;
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedDrawer(
        offset: widget.animatedOffset,
        duration: const Duration(milliseconds: 800),
    child: SafeArea(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            drawerData()
          ],
        ),
      ),
    )
    );
  }
  //<editor-fold desc= "Drawer 1">
  Widget drawerData() {
    print(Is_Login.value);
    return SafeArea(
      child: Container(
        width: 320.w,
        height: Get.height,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            color: APP_GRAY_COLOR,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10))),
        child: Stack(
          children: [
            Column(
              children: [
                drawerHeader1(),
                // DrawerListData_1(),
                newDrawerAllData(),
              ],
            ),

          ],
        ),
      ),
    );
  }

  Widget newDrawerAllData(){
    return  Expanded(
      child: ListView(
        physics: const ScrollPhysics(),
        clipBehavior: Clip.hardEdge,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              newDrawerListData1(),
              SizedBox(height: 12.w),
              Is_Login.value==false?_redeemPointData():const SizedBox(),
              SizedBox(height: 20.w),
              newDrawerOtherListData(),
              const SizedBox(height: 50,)
            ],
          ),

        ],
      ),
    );
  }

  Widget newDrawerOtherListData(){
    return Obx(() => ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: cntDrawer.arrNewDrawerOtherList.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        DrawerModal objList = cntDrawer.arrNewDrawerOtherList[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: GestureDetector(
            onTap:objList.onTap??(){},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      objList.images??"",
                      color: BLACK,
                      height: 24.h,width: 24.w, fit: BoxFit.cover,),
                    SizedBox(
                      width: 12.w,
                    ),
                    Text(
                      objList.title??"",
                      style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: BLACK
                      ),
                    ),
                    objList.lblVersion??const SizedBox(),
                  ],
                ),
                SvgPicture.asset(
                  IMG_RIGHTARROW_SVG_NEW,
                  height: 15.h,
                  width: 15.w,
                  color: BLACK,
                ),
              ],
            ),
          ),
        );
      },
    ));
  }

  Widget drawerHeader1() {
    return SizedBox(
      height: 130.w,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: APP_THEME_COLOR,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                )),
            height: 88.w,
            width: Get.width,
          ),
          Padding(
            padding: EdgeInsets.only(top: 24.0.w,right: 24.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                cntDrawer.CloseIcon(),
              ],
            ),
          ),
          loginUserImage1(),

        ],
      ),
    );
  }

  Widget loginUserImage1() {
    return Positioned(
      top: 55.w,
      left: 20,
      child: Row(
        crossAxisAlignment: !Is_Login.isTrue?CrossAxisAlignment.center:CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            child: InkWell(
              onTap: () {
                if (Is_Login.isTrue) {
                  const MyAccountPage();
                } else {
                  Get.back();
                  cntDrawer.LoginDialog();
                }
              },
              child: Container(
                width: 74,
                height: 74,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: white, width: 2),
                    color: white),
                child: !Is_Login.isTrue
                    ? Image.asset(  width: 74,
                  height: 74,LOGIN_KEY_PNG_IMAGE, fit: BoxFit.fill,)
                    : cntDrawer.image.value != ""
                    ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(cntDrawer.image.value),
                      fit: BoxFit.fill,
                      width: 74,
                      height: 74,
                    ))
                    : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image(
                        image: NetworkImage(profile_pic.value),
                        fit: BoxFit.fill)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: (){
              Is_Login.isFalse ? MoengageAnalyticsHandler().track_event("login_page") :  MoengageAnalyticsHandler().track_event("profile_page");
              Is_Login.isFalse ? Get.to(()=>const LoginPage()) :  Get.to(()=>const MyAccountPage());
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    Text(
                        Is_Login.isFalse
                            ? lblAppMenu
                            : firstname.value,
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            fontSize: 22.sp,
                            fontFamily: fontFamily,
                            fontWeight: FontWeight.w900,
                            height: 0.9.w,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 6
                              ..color = APP_THEME_COLOR,
                          ),
                        )),
                    Text(
                        Is_Login.isFalse
                            ? lblAppMenu
                            : firstname.value,
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                              fontFamily: fontFamily,
                              fontWeight: FontWeight.w900,
                              fontSize: 22.sp,
                              color: white,
                              height: 1.w),
                        )),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(bottom: Is_Login.isFalse
                      ?10:0),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      Text(
                          Is_Login.isFalse
                              ? lblAppMenuLoginSignUp
                              : lastname.value,
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              fontSize: 22.sp,
                              fontFamily: fontFamily,
                              fontWeight: FontWeight.w900,
                              height: 1.w,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 6
                                ..color = APP_THEME_COLOR,
                            ),
                          )),
                      Text(
                          Is_Login.isFalse
                              ? lblAppMenuLoginSignUp
                              : lastname.value,
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                fontFamily: fontFamily,
                                fontWeight: FontWeight.w900,
                                fontSize: 22.sp,
                                color: white,
                                height: 1.w),
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    MoengageAnalyticsHandler().track_event("profile_page");
                    Get.to(()=>const MyAccountPage());
                  },
                  child: Text(
                    Is_Login.isFalse ? "" : lblViewProfile.toUpperCase(),
                    style: TextStyle(
                        fontFamily: fontFamily,
                        fontSize: 10.sp,
                        color: gray_color_1,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          // SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget newDrawerListData1() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: const ScrollPhysics(),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() =>  ListView.builder(
            itemCount: cntDrawer.arrNewDrawerList_1.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Obx(() => _newDrawerListData1(index));
            },
          )),
          SizedBox(height: 10.h),
          GestureDetector(
            onTap: (){
              Get.to(()=>const ScheduleSitePage());
            },
            child: Container(
              width:Get.width,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: white,
                boxShadow: [
                  BoxShadow(
                    color: BLACK.withOpacity(0.1),
                    // spreadRadius: 0,
                    blurRadius: 4,
                    offset: const Offset(
                        0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment:
                CrossAxisAlignment.center,
                children: [
                  Container(
                      padding: const EdgeInsets.only(
                          left: 8,
                          right: 8,
                          top: 8,
                          bottom: 8),
                      decoration: BoxDecoration(
                          color: SCHEDULE_SITE_VISIT_COLOR,
                          borderRadius:
                          BorderRadius.circular(6)),
                      child:
                      SvgPicture.asset(
                        img_schedule_site_svg,
                        height: 24.w,
                        width: 24.h,
                        color: white,
                      )),
                  const SizedBox(width: 8),
                  Text(
                    "Schedule Site Visit",
                    style: mediumTextStyle(
                        fontSize: 12, txtColor: BLACK),
                    textAlign: TextAlign.left,
                  ),

                ],
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Obx(() => ListView.builder(
            itemCount: cntDrawer.arrNewDrawerList_2.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return _newDrawerListData2(index);
            },
          ))
        ],
      ),
    );
  }

  Widget _newDrawerListData1(int index) {
    DrawerModal objDrawerList_1 = cntDrawer.arrNewDrawerList_1[index];
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.only(left: 20,right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            index == 0
                ? Expanded(
              child: GestureDetector(
                onTap: (){
                  cntDrawer.NavigateProjectScreen_1(index);
                },
                child: Container(
                  height: 192.w,
                  width: 140.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(

                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          height: 192.w,
                          width: 140.w,
                          fadeInDuration: Duration.zero,
                          fadeOutDuration: Duration.zero,
                          placeholderFadeInDuration: Duration.zero,
                          imageUrl: objDrawerList_1.images ?? "",
                          fit: BoxFit.fill,
                          errorWidget: (context, value, error) {
                            return Image.asset(
                              objDrawerList_1.images ?? "",
                              fit: BoxFit.fill,
                              height: 192.w,
                              width: 140.w,
                            );
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 14.w,bottom: 10.h),
                          child: Text(
                            objDrawerList_1.title!.toUpperCase(),
                            // textAlign: TextAlign.end,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: white,
                                fontSize: 12.sp,
                                fontFamily: fontFamily),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
                : const SizedBox(),
            SizedBox(width: 12.h),
            index == 0
                ? Expanded(
              child: Wrap(
                direction: Axis.vertical,
                runAlignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: [
                  for (int i = 0; i < cntDrawer.arrNewDrawerList_1.length; i++)
                    i == 1 || i == 2 || i == 3
                        ? GestureDetector(
                      onTap: (){
                        cntDrawer.NavigatiScreen_1(i);
                      },
                      child: Padding(
                        padding:  EdgeInsets.only(bottom: i==2?13.w:0,top: i==2?13.w:0),
                        child: Container(
                          // height: 56.h,
                          width:134.w,
                          padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 8.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: white,
                            boxShadow: [
                              BoxShadow(
                                color: BLACK.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            children: [
                              Container(
                                  padding: const EdgeInsets.only(
                                      left: 8,
                                      right: 8,
                                      top: 8,
                                      bottom: 8),
                                  decoration: BoxDecoration(
                                      color: cntDrawer.arrNewDrawerList_1[i]
                                          .backColor ??
                                          white,
                                      borderRadius:
                                      BorderRadius.circular(6)),
                                  child:
                                  SvgPicture.asset(
                                    cntDrawer.arrNewDrawerList_1[i].images ?? "",
                                    height: 24.w,
                                    width: 24.h,
                                    color: white,
                                  )),
                              SizedBox(width: 8.w),
                              SizedBox(
                                width: 65.w,
                                child: Text(
                                  cntDrawer.arrNewDrawerList_1[i].title ?? "",
                                  style: TextStyle(
                                      fontSize: 12.sp,fontFamily: fontFamily,fontWeight: FontWeight.w500, color: new_black_color),
                                  textAlign: TextAlign.left,
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    )
                        : const SizedBox(),
                ],
              ),
            )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget newDrawerListData2() {
    return ListView.builder(
      itemCount: cntDrawer.arrNewDrawerList_2.length,
      physics: const ScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return _newDrawerListData2(index);
      },
    );
  }

  Widget _newDrawerListData2(int index) {
    DrawerModal objDrawerList_2 = cntDrawer.arrNewDrawerList_2[index];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          index == 3
              ? Expanded(
            child: Wrap(
              direction: Axis.vertical,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                for (int i = 0; i < cntDrawer.arrNewDrawerList_2.length; i++)
                  i == 0 || i == 1 || i == 2
                      ? GestureDetector(
                    onTap: (){
                      cntDrawer.NavigatiScreen_2(i);
                    },
                    child: Padding(
                      padding:  EdgeInsets.only(bottom: i==1?13.w:0,top: i==1?13.w:0),
                      child: Container(
                        width:134.w,
                        // margin: EdgeInsets.only(right: 10),
                        padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 8.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: white,
                          boxShadow: [
                            BoxShadow(
                              color: BLACK.withOpacity(0.1),
                              // spreadRadius: 0,
                              blurRadius: 4,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: [
                            Container(
                                padding: const EdgeInsets.only(
                                    left: 8,
                                    right: 8,
                                    top: 8,
                                    bottom: 8),
                                decoration: BoxDecoration(
                                    color: cntDrawer.arrNewDrawerList_2[i]
                                        .backColor ??
                                        white,
                                    borderRadius:
                                    BorderRadius.circular(6)),
                                child:
                                // objMyProperties.icon.toString().contains("svg")
                                //     ?
                                SvgPicture.asset(
                                  cntDrawer.arrNewDrawerList_2[i].images ?? "",
                                  height: 24.w,
                                  width: 24.h,
                                  color: white,
                                )),
                            SizedBox(width: 8.w),
                            SizedBox(
                              width: 65.w,
                              child: Text(
                                cntDrawer.arrNewDrawerList_2[i].title ?? "",
                                style: mediumTextStyle(
                                    fontSize: 12, txtColor: BLACK),
                                textAlign: TextAlign.left,
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  )
                      : const SizedBox(),
              ],
            ),
          )
              : const SizedBox(),

          SizedBox(width: 12.w),
          index == 3
              ? Expanded(
            child: GestureDetector(
              onTap: (){
                cntDrawer.NavigateEmiCalculatorScreen_1(index);
              },
              child: Container(
                height: 192.w,
                width: 140.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        height: 192.w,
                        width: 140.w,
                        fadeInDuration: Duration.zero,
                        fadeOutDuration: Duration.zero,
                        placeholderFadeInDuration: Duration.zero,
                        imageUrl: objDrawerList_2.images ?? "",
                        fit: BoxFit.fill,
                        errorWidget: (context, value, error) {
                          return Image.asset(
                            objDrawerList_2.images ?? "",
                            height: 192.w,
                            width: 140.w,
                            fit: BoxFit.fill  ,
                          );
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 14.w,bottom: 8.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "EMI".toUpperCase(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: white,
                                  fontSize: 12.sp,
                                  fontFamily: fontFamily),
                            ),
                            Text(
                              "Calculator".toUpperCase(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: white,
                                  fontSize: 12.sp,
                                  fontFamily: fontFamily),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget _redeemPointData() {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: AppColors.WHITE,
        boxShadow: [
          BoxShadow(
            color: BLACK.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset(
            IMG_REFRE_A_FRIEND_SVG,
            height: 89.w,
            width: 89.h,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(lblReferaFriendText,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: HexColor("#333333"),
                    fontWeight: FontWeight.w500,
                    fontFamily: fontFamily,
                  )),
              SizedBox(height: 8.w),
              Obx(() =>  Text("${"₹"} ${referralFriendsPoints.value}",
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: HexColor("#333333"),
                    fontWeight: FontWeight.w700,
                    fontFamily: fontFamily,
                  ))),
              SizedBox(height: 12.w),
              OnLoginTapButton(
                  height: 32.h,
                  width: 135.w,
                  onTap: () {
                    MoengageAnalyticsHandler().track_event("refer_a_friend");
                    // NavigateReferAFriendPage();
                    // if (islogin.isTrue) {
                    WALunchUrl("whatsapp://send?&text=${Uri.encodeFull("${referralText.value} ${referralCode.value}")}");
                    // } else {
                    //   LoginDialog();
                    // }
                  },
                  decoration: CustomDecorations()
                      .backgroundlocal(APP_THEME_COLOR, 6, 0, APP_THEME_COLOR),
                  text: "REFER NOW",
                  icon: Image.asset(WHATSAPP_IMAGES, height: 18.w, width: 18.h),
                  style: TextStyle(
                      color: AppColors.WHITE,
                      fontSize: 10.sp,
                      fontFamily: fontFamily,
                      fontWeight: FontWeight.w600)),
            ],
          )
        ],
      ),
    );
  }
}
