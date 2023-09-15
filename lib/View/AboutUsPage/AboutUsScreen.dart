import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Controller/AboutUsController/AboutUsController.dart';
import 'package:Repeople/View/DashboardPage/BottomnavigationBar.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:Repeople/Widgets/ShimmerWidget.dart';
import 'package:flutter/material.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {

  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());
  AboutUsController cnt_About_Us = Get.put(AboutUsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: cnt_About_Us.GlobalAboutkey,
      backgroundColor: AppColors.BACKGROUND_WHITE,
      endDrawer: CustomDrawer(animatedOffset: Offset(1.0,0),),
      drawer: CustomDrawer(animatedOffset: Offset(-1.0,0),),
      body: SafeArea(
        child: Stack(
          children: [
           SingleChildScrollView(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 SizedBox(height: APPBAR_HEIGHT,),
                 Title_1(),
                 SizedBox(height: APPBAR_HEIGHT,)
               ],
             ),
           ),
            cnt_CommonHeader.commonAppBar(ABOUT_US_APPMENUNAME, cnt_About_Us.GlobalAboutkey,color: AppColors.WHITE.withOpacity(0.0),),

            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: BottomNavigationBarClass(),
            // )
          ],
        ),
      ),
    );
  }

  Widget Title_1() {
    return Container(
        color: AppColors.BACKGROUND_WHITE,
        margin: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15.h),
            _repeopleLogo(),

            SizedBox(height: 20.h),
            FutureValueTitle1(),
            SizedBox(
              height: 50,
            ),
          ],
        )
    );
  }

  Widget _repeopleLogo(){
    return   SvgPicture.asset(
      REPEOPLE_APPLOGO_SVG,
      width: 126.w,
      color: hex("006CB5"),
      height: 20.h,
    );
  }

  Widget FutureValueTitle1(){
    return Obx(() {
      return FutureBuilder(
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasError) {
            return  Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ABOUT WORLDHOME GROUP",textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 10.sp,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w600,
                      color: gray_color_1,
                      fontFamily: fontFamily,
                    )),
                SizedBox(height: 12.h),
                Text("first CRISIL DA1+ rated developer in India",textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: DARK_BLUE,
                      fontWeight: FontWeight.w700,
                      fontFamily: fontFamily,
                    )),

                SizedBox(height: 12.h),

                Container(
                    child: Text(cnt_About_Us.about.value,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: gray_color_2,
                          fontFamily: fontFamily,
                        ))
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: Get.width,
                  // height: 327,
                  decoration: BoxDecoration(
                      color: BORDER_GREY,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: BORDER_GREY,width: 1)
                  ),
                  child: Image.network(
                    // MANAGE_About_PNG_IMAGE,
                    cnt_About_Us.icon.value,
                    width: Get.width,
                    // height: 327,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Vision",
                            style: TextStyle(color: gray_color_1, fontSize: 12.sp,fontWeight: FontWeight.w700),
                          ),
                          SizedBox(width: 8.h),
                          Expanded(
                              child: Container(
                                width: Get.width,
                                height: 1.h,
                                color: BORDER_GREY,
                              )
                          )
                        ],
                      ),
                      SizedBox(height: 10,),
                      Text(cnt_About_Us.vision.value, style: TextStyle(
                        fontSize: 10.sp,
                        color: new_black_color,
                        fontFamily: fontFamily,
                        fontWeight: FontWeight.w400,
                      )
                        // TextStyle(
                        //     fontWeight: FontWeight.w500,color: APP_FONT_COLOR.withOpacity(0.7),fontSize: 12,height: 1.5)
                      ),

                    ])),
                SizedBox(
                  height: 0,
                ),
                Divider(
                  thickness: 0.5,
                  color: APP_THEME_COLOR.withOpacity(0.1),
                ),
                SizedBox(
                  height: 0,
                ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Mission",
                        style: TextStyle(color: gray_color_1, fontSize: 12.sp,fontWeight: FontWeight.w700),
                      ),
                      SizedBox(width: 8.h),
                      Expanded(
                          child: Container(
                            width: Get.width,
                            height: 1.h,
                            color: BORDER_GREY,
                          )
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                      cnt_About_Us.mission.value,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: new_black_color,
                        fontFamily: fontFamily,
                        fontWeight: FontWeight.w400,
                      )
                  ),
                ]),

                SizedBox(
                  height: 30,
                )
              ],
            );
            //return LeadShimmerWidget();
          } else {
            return ShimmerEffect(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    shimmerWidget(width: Get.width, height: 200, radius: cornarradius),
                    SizedBox(height: 30,),
                    shimmerWidget(width: Get.width, height: 200, radius: cornarradius),
                    SizedBox(height: 30,),
                    shimmerWidget(width: Get.width, height: 220, radius: cornarradius),
                  ],
                )
            );
          }},
        future: cnt_About_Us.futureTermsAndCondition.value,

      );
    });
  }
}
