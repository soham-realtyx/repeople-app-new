import 'dart:io';
import 'package:Repeople/Config/Helper/Logout.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/View/DashboardPage/BottomnavigationBar.dart';
import 'package:Repeople/View/LoginHistoryPage/LoginHistoryPage.dart';
import 'package:Repeople/View/ManagerScreensFlow/LoginScreens/ManagerLoginScreen.dart';
import 'package:Repeople/View/MyAccountPage/EditProfilePage.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:Repeople/Widgets/NotificationCustomDrawer/NotificationSettingCustomDrawer.dart';
import 'package:Repeople/Widgets/TextEditField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Helper/MoengageAnalyticsHandler.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:Repeople/Controller/MyAccountController/MyAccountController.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Config/utils/Strings.dart';
import '../../Config/utils/colors.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<MyAccountPage> {

  CommonHeaderController cntCommonHeader = Get.put(CommonHeaderController());
  MyAccountController cntAccount = Get.put(MyAccountController());



  @override
  void initState(){
    cntAccount.arrNoFoundListTheme.clear();
    cntAccount.CreateProjectWidgetTheme();
    cntAccount.getProfileData();
    isAlternateWSwitch.refresh();
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<MyAccountController>();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_WHITE,
      key: cntAccount.GlobalMyAccountPagekey,
      endDrawer: CustomDrawer(
        animatedOffset: const Offset(1.0, 0),
      ),
      drawer: CustomDrawer(
        animatedOffset: const Offset(-1.0, 0),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(child: firstAccount()),
            Positioned(top:70,child: accountHeaderData1(),),
            cntCommonHeader.commonAppBar(PROFILE, cntAccount.GlobalMyAccountPagekey, color: white)
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarClass(selectedIndex: 4),
    );
  }


  Widget firstAccount() {
    return ListView(
        physics: const ScrollPhysics(),
        clipBehavior: Clip.hardEdge,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(height: 220.w),
            myLoginDetailsData(),
            const SizedBox(height: 20),
            loginClickActionData(),
            // if( userLoginType.value!="4")  UserLayout(),
            //  SizedBox(height: 20),
            //  LogOutContainer(),
            const SizedBox(height: 50),
          ]),
        ]);
  }

  Widget accountHeaderData1() {
    return Container(
      height: 130.h,
      color: BACKGROUNG_GREYISH,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              color: APP_THEME_COLOR,
            ),
            height: 88.h,
            width: Get.width,
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  loginUserImage1(),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      MoengageAnalyticsHandler().track_event("edit_profile");
                      Get.to(() => const EditProfilePage());
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Obx(() => Stack(
                          clipBehavior: Clip.none,
                          children: <Widget>[
                            Text(
                              firstname.value,
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  fontSize: 22.sp,
                                  fontFamily: fontFamily,
                                  fontWeight: FontWeight.w900,
                                  height: 0.9.w,
                                  // letterSpacing: 0.8,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 6
                                    ..color = APP_THEME_COLOR,
                                ),
                              ),
                            ),
                            Text(firstname.value,
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                      fontFamily: fontFamily,
                                      // letterSpacing: 0.8,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 22.sp,
                                      color: white,
                                      height: 0.9.w),
                                )),
                          ],
                        )),
                        Obx(() => Stack(
                          clipBehavior: Clip.none,
                          children: <Widget>[
                            Text(
                              lastname.value,
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
                              ),
                            ),
                            Text(lastname.value,
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                      fontFamily: fontFamily,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 22.sp,
                                      color: white,
                                      height: 0.9.w),
                                )),
                          ],
                        )),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => const EditProfilePage())?.whenComplete(() => cntAccount.getProfileData());
                          },
                          child: Text(
                            lblEditProfile.toUpperCase(),
                            style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: 10.sp,
                                color: new_black_color,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(height: 12.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget loginUserImage1() {
    return Obx(
          () => Container(
        width: 70.w,
        height: 70.w,
        margin: const EdgeInsets.only(bottom: 9),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: white, width: 2),
            color: white),
        child: InkWell(
          onTap: () {
            if (Is_Login.isTrue) {
              Get.to(const EditProfilePage());
            } else {
              Get.back();
              //LoginDialog();
            }
          },
          child: Container(
            width: 70.h,
            height: 70.w,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.BACKGROUND_WHITE),
            child: !Is_Login.isTrue
                ? SvgPicture.asset(IMG_PROFILEDEFAULT_SVG_NEW)
                : cntAccount.image.value != ""
                ? Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.file(
                  File(cntAccount.image.value),
                  fit: BoxFit.cover,
                ))
                : Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image(
                    image: NetworkImage(profile_pic.value),
                    fit: BoxFit.cover)),
          ),
        ),
      ),
    );
  }

  Widget myLoginDetailsData() {
    return Container(
      width: Get.width,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: white,
        boxShadow: [
          BoxShadow(
            color: BLACK.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          myLoginDataDetailsWidget(title: "Customer ID", subtitle: customer_id.value),
          SizedBox(height: 20.h),
          myLoginDataDetailsWidget(title: "Name", subtitle: username.value),
          SizedBox(height: 20.h),
          myLoginDataDetailsWidget(
            title: "Email",
            subtitle: email.value,
          ),
          SizedBox(height: 20.h),
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              myLoginDataDetailsWidget(
                  title: "Mobile", subtitle: "${"+91"} ${mobile.value}"),
              isWhatsApp.value=="1"?Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    WHATSAPP_IMAGES,
                    width: 12.w,
                    height: 12.h,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "Enabled",
                    style: TextStyle(
                      color: new_green_color,
                      fontWeight: FontWeight.w500,
                      fontSize: 9.sp,
                      fontFamily: fontFamily,
                    ),
                  ),
                ],
              ):const SizedBox()
            ],
          )),
          SizedBox(height: 20.h),
      Obx(() =>Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              myLoginDataDetailsWidget(
                  title: "Alternate Mobile",
                  subtitle: "$countrycode ${alternate_mobile.value}"
              ),
             isAlternateWSwitch.value=="1"?Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    WHATSAPP_IMAGES,
                    width: 12.w,
                    height: 12.h,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "Enabled",
                    style: TextStyle(
                      color: new_green_color,
                      fontWeight: FontWeight.w500,
                      fontSize: 9.sp,
                      fontFamily: fontFamily,
                    ),
                  ),
                ],
              ):const SizedBox()
            ],
          )),
          SizedBox(height: 20.h),
         Obx(() =>  myLoginDataDetailsWidget(
            title: "Designation",
            subtitle:
            userProffessionName.value,

          )),
        ],
      ),
    );
  }

  Widget loginClickActionData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        loginActionListData(
            title: "Login History",
            icons: img_term_conditions_svg,
            onTap: () {
              MoengageAnalyticsHandler().track_event("login_history");
              Get.to(()=>const LoginHistoryPage());
            }),
        loginActionListData(
            title: "Notification Settings",
            icons: img_version_svg,
            onTap: () {
              MoengageAnalyticsHandler().track_event("notification_setting");
              Get.to(
                  const NotificationSettingCustomDrawer(
                    animatedOffset: Offset(1.0, 0),
                  )
              );
              // OpenDrawer();
            }),
        loginActionListData(
            title: "Manager Login",
            icons: userSvg,
            onTap: () {
              MoengageAnalyticsHandler().track_event("manager_login");
              Get.to(()=>const ManagerLoginPage());
            }),
        loginActionListData(
            title: "Logout",
            icons: img_logout_svg,
            onTap: () {
              Logoutdialog();
            }),
      ],
    );
  }

  Widget myLoginDataDetailsWidget({String? title, String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toString(),
          style: TextStyle(
            color: gray_color_1,
            fontWeight: FontWeight.w700,
            fontSize: 12.sp,
            fontFamily: fontFamily,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          subtitle.toString(),
          style: TextStyle(
            color: new_black_color,
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
            fontFamily: fontFamily,
          ),
        )
      ],
    );
  }

  Widget loginActionListData(
      {String? icons, String? title, GestureTapCallback? onTap}) {
    return ListTile(
        onTap: onTap,
        visualDensity: const VisualDensity(
            horizontal: VisualDensity.minimumDensity,
            vertical: VisualDensity.minimumDensity),
        contentPadding: const EdgeInsets.only(top: 2, bottom: 8, left: 30, right: 30),
        leading: SvgPicture.asset(
          icons ?? "",
          height: 24.h,
          width: 24.w,
          color: APP_FONT_COLOR,
        ),
        title: Text(
          title.toString(),
          style: TextStyle(
              fontFamily: fontFamily,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: APP_FONT_COLOR),
        ),
        trailing: SvgPicture.asset(
          "newassets/Icons/newchevron-right2.svg",
          height: 24.h,
          width: 24.w,
          color: APP_FONT_COLOR,
        ));
  }

}
