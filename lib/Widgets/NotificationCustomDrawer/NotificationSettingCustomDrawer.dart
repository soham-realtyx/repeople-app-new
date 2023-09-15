import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:Repeople/Controller/NotificationController/NotificationDrawerController.dart';
import 'package:Repeople/Model/NotificationSettingModel/NotificationSettingModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';

import '../Animation/AnimatedDrawer.dart';

class NotificationSettingCustomDrawer extends StatefulWidget {
  final Offset? animatedOffset;
  const NotificationSettingCustomDrawer({super.key, this.animatedOffset});
  @override
  _NotificationSettingCustomDrawerState createState() =>
      _NotificationSettingCustomDrawerState();
}

class _NotificationSettingCustomDrawerState
    extends State<NotificationSettingCustomDrawer> {
  NotificationDrawerController drawerController =
  Get.put(NotificationDrawerController());
  CommonHeaderController cntHeaderController = Get.put(CommonHeaderController());

  @override
  void initState() {
    super.initState();
    drawerController.arrNotificationSettingList.clear();
    drawerController.notificationSettingData().whenComplete(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.8),
      key: drawerController.GlobalNotificationSettingkey,
      body:
      // AnimatedDrawer(
      //   offset: widget.animatedOffset,
      //   duration: const Duration(milliseconds: 800),
      //   child:
        SafeArea(child: drawer1()),
      // ),
    );
  }

  Widget drawer1() {
    
    return SafeArea(
      child: Align(
        alignment: Alignment.centerRight,
        child: Stack(
          children: [
            Container(
              // width: 320.w,
              width: Get.width,
              height: Get.height,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: APP_GRAY_COLOR,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(0),
                  bottomLeft: Radius.circular(0),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 90.w),
                    notificationSettingData()
                  ],
                ),
              ),
            ),
            cntHeaderController.commonAppBar("Notifications", drawerController.GlobalNotificationkey),
            // Positioned(
            //   top: 0,
            //   child: drawerHeader(),
            // )
          ],
        ),
      ),
    );
  }

  Widget drawerHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 0, right: 20, left: 20),
      decoration: BoxDecoration(
          color: APP_THEME_COLOR,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(0),
          )),
      height: 88.w,
      width: Get.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Notifications Settings",
            style: TextStyle(
              color: white,
              fontSize: 14.sp,
              fontFamily: fontFamily,
              fontWeight: FontWeight.w500,
            ),
          ),
          closeIcon()
        ],
      ),
    );
  }

  Widget notificationSettingData() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20, right: 20, left: 20, top: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  drawerController.notificatioSetting?.value =
                      CategorySelect.All;
                },
                child: Container(
                  padding: const EdgeInsets.all(5.5),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.5, color: DARK_BLUE),
                      shape: BoxShape.circle),
                  child: Center(
                    child: ClipOval(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                            color: drawerController
                                .notificatioSetting?.value ==
                                CategorySelect.All
                                ? DARK_BLUE
                                : white,
                            shape: BoxShape.circle),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text("All",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: drawerController.notificatioSetting?.value ==
                          CategorySelect.All
                          ? new_black_color
                          : gray_color_1,
                      fontFamily: fontFamily,
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp)),
            ],
          )),
          SizedBox(height: 20.h),
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  drawerController.notificatioSetting?.value =
                      CategorySelect.Custom;

                  drawerController.arrNotificationSettingList.refresh();
                },
                child: Container(
                  padding: const EdgeInsets.all(5.5),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.5, color: DARK_BLUE),
                      shape: BoxShape.circle),
                  child: Center(
                    child: ClipOval(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                            color: drawerController
                                .notificatioSetting?.value ==
                                CategorySelect.Custom
                                ? DARK_BLUE
                                : white,
                            shape: BoxShape.circle),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text("Custom",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: drawerController.notificatioSetting?.value ==
                          CategorySelect.Custom
                          ? new_black_color
                          : gray_color_1,
                      fontFamily: fontFamily,
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp)),
            ],
          )),
          Obx(() => drawerController.notificatioSetting?.value ==
              CategorySelect.Custom
              ? AnimatedContainer(
              margin: const EdgeInsets.only(top: 20),
              duration: const Duration(milliseconds: 80), child: customList())
              : const SizedBox()),

          SizedBox(height: 20.h),
          OnTapButton(
              onTap: () {
                drawerController.addNotificationSetting();
              },
              height: 40,
              decoration: CustomDecorations()
                  .backgroundlocal(APP_THEME_COLOR, cornarradius, 6, APP_THEME_COLOR),
              text: "save".toUpperCase(),
              style: TextStyle(
                  color: white,
                  fontSize: 14.sp,
                  fontFamily: fontFamily,
                  fontWeight: FontWeight.w700)),
          SizedBox(height: 50.h),
        ],
      ),
    );
  }

  Widget customList() {

    return Obx(() => ListView.separated(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: drawerController.arrNotificationSettingList!=null?drawerController.arrNotificationSettingList.length:0,
      itemBuilder: (BuildContext context, int index) {
        NotificationSettingModel obj =
        drawerController.arrNotificationSettingList[index];
        if(obj.isUserNotification=="1") {
           obj.isSelected?.value=true;
        }else{
          obj.isSelected?.value=false;
        }
        return Obx(() => Row(
          children: [
            Checkbox(
              value: obj.isSelected?.value,
              onChanged: (value) {
                obj.isSelected?.value = value!;
                if(obj.isSelected?.value==true){
                  drawerController.arrNotificationList2.add(obj.label??"");
                }
                // if(value!){
                //   drawerController.arrNotificationList2.add(obj.label??"");
                // }
              },
              activeColor: obj.isUserNotification=="1"?DARK_BLUE.withOpacity(0.5):DARK_BLUE,
              focusColor: LIGHT_GREY_COLOR,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
                side: BorderSide(
                    color: gray_color_1,
                    width: 0.4,
                    style: BorderStyle.solid
                ),
              ),
              visualDensity: VisualDensity.adaptivePlatformDensity,
              side: BorderSide(
                width: 1.2,
                color: gray_color_1,
                // strokeAlign: StrokeAlign.center,
                style: BorderStyle.solid,
              ),

            ),
            Text(
              capitalizeFirstLetter(drawerController.arrNotificationSettingList[index].label.toString()),
              style: TextStyle(
                color:obj.isSelected?.value == true
                    ? new_black_color
                    : gray_color_1,
                fontWeight: FontWeight.w700,
                fontFamily: fontFamily,
                fontSize: 14.sp,
              ),
            ),
          ],
        ));
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 4.h);
      },
    ),
    );
  }

  Widget customButton(
      {String? text, GestureTapCallback? onTap, Color? color}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 12),
        decoration: BoxDecoration(
          color: white,
        ),
        child: Text(
          text!.toUpperCase(),
          style: TextStyle(
              color: color,
              fontSize: 12.sp,
              fontFamily: fontFamily,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget closeIcon() {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Container(
          height: 24.w,
          width: 24.w,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.white.withOpacity(0.20),
          ),
          child: SvgPicture.asset(
            IMG_CLOSE_SVG_NEW,
            color: white,
            fit: BoxFit.cover,
            height: 24,
            width: 24,
          )),
    );
  }
}
