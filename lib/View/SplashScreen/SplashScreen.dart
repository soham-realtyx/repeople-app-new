import 'dart:async';
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Helper/HextoColor.dart';
import 'package:Repeople/Config/Helper/MoengageAnalyticsHandler.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Config/Constant.dart';
import '../../Controller/SplashScreenController/SplashScreenController.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  // bool? themevalue;

  SplashScreenController cnt_Splash = Get.put(SplashScreenController());
  late Timer timer;
  double percent = 0;

  @override
  void dispose() {
    timer.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // cnt_Splash.get_current_theme();
    cnt_Splash.Loaddata();
    getNotificationCount();
    WidgetsBinding.instance.addObserver(this);
    progress_timmer();
    MoengageAnalyticsHandler moengageAnalyticsHandler = MoengageAnalyticsHandler();
    moengageAnalyticsHandler.initMoengage();
    MoengageAnalyticsHandler().track_event("app_open");
    MoengageAnalyticsHandler().track_event("splashscreen");
  }

  getNotificationCount() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var count = sp.getInt(NOTIFICATION_COUNT) ?? 0;
    isbadgeshow.value = count > 0 ? true : false;
  }

  progress_timmer() async {
    timer = Timer.periodic(Duration(milliseconds: 40), (_) {
      percent += 1;
      setState(() {
        if (percent >= 100) {
          timer.cancel();
          // percent=0;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#F5F6FA'),
      body: SafeArea(child: SplashWidget()),
    );
  }

  Widget SplashWidget() {
    return Stack(
      children: [
        SizedBox(
            height: Get.height,
            width: Get.width,
            child: Image.asset(
              SPLASH_BACK_IMAGES,
              height: Get.height,
              width: Get.width,
              fit: BoxFit.cover,
            )),
        Padding(
          padding:  EdgeInsets.only(left: 20.h,right: 20.h,bottom: 63.w,top: 180.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(height: 155.w),
              SvgPicture.asset(
                REPEOPLE_APPLOGO_SVG,
                height: 34.w,
                width: 210.h,
                fit: BoxFit.cover,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(height: 250.w),
                  Text(
                    "WELCOME TO REPEOPLE",
                    style: TextStyle(
                        letterSpacing: 0.8,
                        color: NewAppColors.GREY_COLOR,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 9.w),
                  Text(
                    "Browse Projects.",
                    style: TextStyle(
                        color: NewAppColors.GREY_COLOR,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Schedule Site Visit.",
                    style: TextStyle(
                        color: NewAppColors.GREY_COLOR,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Refer and Earn. ",
                    style: TextStyle(
                        color: NewAppColors.GREY_COLOR,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 100.w),
                  Text(
                    "Powered by",
                    style: TextStyle(
                        color: hex("#898989"),
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "TOTALITY",
                    style: TextStyle(
                        color: hex("#453D97"),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w900),
                  ),
                ],
              ),


            ],
          ),
        )
      ],
    );
  }
}
