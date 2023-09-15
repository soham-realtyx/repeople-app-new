import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/Helper/Logout.dart';
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:Repeople/Model/LoginHistoryModel/LoginHistoryModel.dart';
import 'package:Repeople/View/DashboardPage/BottomnavigationBar.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:Repeople/Widgets/ShimmerWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Controller/LoginHistoryController/LoginHistoryController.dart';

class LoginHistoryPage extends StatefulWidget {
  const LoginHistoryPage({Key? key}) : super(key: key);

  @override
  State<LoginHistoryPage> createState() => _LoginHistoryPageState();
}

class _LoginHistoryPageState extends State<LoginHistoryPage> {
  LoginHistoryController cnt_LoginHistory = Get.put(LoginHistoryController());
  CommonHeaderController cnt_HeaderController = Get.put(CommonHeaderController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.BACKGROUND_WHITE,
      key: cnt_LoginHistory.GlobalMyLoginHistoryPagekey,
      endDrawer: CustomDrawer(animatedOffset: Offset(1.0,0),),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 70),
                  loginHistoryList()
                ],
              ),
            ),
            cnt_HeaderController.commonAppBar("Login History",
                cnt_LoginHistory.GlobalMyLoginHistoryPagekey,isNotificationHide: false),
            Align(
              alignment: Alignment.bottomCenter,
              child: BottomNavigationBarClass(),
            )
          ],
        ),
      ),
    );
  }

  Widget loginHistoryList() {
    return Obx(() {
      return FutureBuilder(
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasError &&
              snapshot.data != null) {
            if (cnt_LoginHistory.arrLoginHistoryList.isNotEmpty) {
              return loginHistoryListData();
            } else {
              return SizedBox(
                height: 500,
                child: Center(
                  child: Text(
                    cnt_LoginHistory.message.value,
                    style: mediumTextStyle(fontSize: 14,fontWeight: FontWeight.w600,txtColor: BLACK),
                  ),
                ),
              );
            }
          } else {
            return historyListShimmerWidget();
          }
        },
        future: cnt_LoginHistory.futurePropertiesDetailsList.value,
      );
    });
  }

  Widget loginHistoryListData(){
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: cnt_LoginHistory.arrLoginHistoryList.length,
        itemBuilder: (context, index) {
          return _loginHistoryData(index);
        },
      ),
    );
  }

  Widget _loginHistoryData(int index){
    LoginHistoryModel objLoginHistory = cnt_LoginHistory.arrLoginHistoryList[index];
    return Container(
      padding: EdgeInsets.all(8.h),
      margin: const EdgeInsets.only(left: 20,bottom: 12,top: 0,right: 20),
      decoration: BoxDecoration(
        color: AppColors.WHITE,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                objLoginHistory.devicemodelname??"",
                style: TextStyle(
                  color: new_black_color,
                  fontWeight: FontWeight.w600,
                  fontFamily: fontFamily,
                  fontSize: 12.sp,
                ),
              ),
              //SvgPicture.asset(IMG_DOTS_MENU_SVG)
              moreMenuButton(index),
            ],
          ),
          const SizedBox(height: 4),
          Text(//${obj_LoginHistory.address??""}
            newsdate(objLoginHistory.date??""),
            // "${obj_LoginHistory.datetime??""}",
            style: TextStyle(
              color: gray_color_1,
              fontWeight: FontWeight.w400,
              fontFamily: fontFamily,
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget moreMenuButton(int index) => PopupMenuButton<int>(
    color: Colors.white,
    offset: const Offset(10, -20),
    padding: const EdgeInsets.only(top: 20),
    onSelected: (value) async {
      if (value == 1) {
        Logoutdialog();
      } else if (value == 2) {
      }
    },
    child: Container(
      alignment: Alignment.center,
      child:SvgPicture.asset(IMG_DOTS_MENU_SVG,
        height: 20,
        width: 20,
      ),
    ),
    itemBuilder: (context) => [
      wd_menuchild(img_logout_svg, "Logout", () {}, 1),
    ],
    // onSelected: (item) => More_SelectedItem(item),
  );
  PopupMenuItem<int> wd_menuchild(
      String image, String title, VoidCallback ontap, int id,
      [bool svg = true]) {
    return PopupMenuItem<int>(
      value: id,
      height: 30,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          svg
              ? SvgPicture.asset(
            image,
            height: 20,
            width: 20,
            color: BLACK,
          )
              : Image.asset(
            image,
            height: 20,
            width: 20,
            color: BLACK,
          ),
          SizedBox(
            width: 8.w,
          ),
          Text(
            title,
            style: mediumTextStyle(txtColor: BLACK,fontSize: 12),
          )
        ],
      ),
    );
  }

  Widget historyListShimmerWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20,top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerEffect(
            child: Container(
              height: 100.w,width: Get.width,
              decoration: BoxDecoration(
                  color: APP_GRAY_COLOR,
                  borderRadius: BorderRadius.circular(10)
              ),
            ),
          ),
          SizedBox(height: 10),
          ShimmerEffect(
            child: Container(
              height: 100.w,width: Get.width,
              decoration: BoxDecoration(
                  color: APP_GRAY_COLOR,
                  borderRadius: BorderRadius.circular(10)
              ),
            ),
          ),
          SizedBox(height: 10),
          ShimmerEffect(
            child: Container(
              height: 100.w,width: Get.width,
              decoration: BoxDecoration(
                  color: APP_GRAY_COLOR,
                  borderRadius: BorderRadius.circular(10)
              ),
            ),
          ),
        ],
      ),
    );
  }
}
