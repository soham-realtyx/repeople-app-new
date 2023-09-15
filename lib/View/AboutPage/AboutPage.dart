import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/Helper/HextoColor.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Controller/AboutUsController/AboutController.dart';
import 'package:Repeople/View/AboutPage/LicenceScreen.dart';
import 'package:Repeople/View/DashboardPage/BottomnavigationBar.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {

  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());
  AboutController cnt_About = Get.put(AboutController());


  @override
  Widget build(BuildContext context) {
    cnt_About.arrThemeList.clear();
    return Scaffold(

      key: cnt_About.GlobalAboutkey,
      backgroundColor: AppColors.BACKGROUND_WHITE,
      endDrawer: CustomDrawer(animatedOffset: Offset(1.0,0),),
      drawer: CustomDrawer(animatedOffset: Offset(-1.0,0),),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: APPBAR_HEIGHT),
                  Title_1(),
                  Licenses_1(),
                  Rate_Us_1(),
                  PowerBy_1(),
                  SizedBox(height: APPBAR_HEIGHT),
                ],
              ),
            ),
            cnt_CommonHeader.commonAppBar("", cnt_About.GlobalAboutkey,color: AppColors.WHITE.withOpacity(0.0),),
            Align(
              alignment: Alignment.bottomCenter,
              child: BottomNavigationBarClass(),
            )
          ],
        ),
      ),
    );
  }
  Widget Title_1() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              decoration: CustomDecorations().backgroundlocal(white, 100, 0, white),
              padding: EdgeInsets.all(10),
              child:
              SvgPicture.asset(
                IMG_APPLOGO1_SVG,
                width: 100,
                height: 100,
                fit: BoxFit.fill,
                color: hex("332B67"),
              )
          ),
          SizedBox(
            height: 20,
          ),
          Obx((){
            return Text(
                cnt_About.lblVersion.value,
                style:
                semiBoldTextStyle(fontSize: 15,txtColor: HexColor("#333333"))
              // TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: HexColor("#333333")),
            );
          }),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  Widget Licenses_1() {
    return Container(
      decoration:
      CustomDecorations().backgroundlocal(hex("006cb5"), cornarradius, 0, APP_THEME_COLOR),
      padding: EdgeInsets.all(10),
      // margin: EdgeInsets.only(left: LEFT_PADDING, right: RIGHT_PADDING),
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        children: [
          ImageWithBackGround(
            // image: IMG_OPENSOURCELIENCE,
            image: IMG_OPENSOURCELIENCE_SVG,
            backgroundColor: white,
            borderColor: white,
            radius: cornarradius,
            height: 50,
            imageheight: 30,
            // imgColor: APP_THEME_COLOR
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    lblAboutLicensesTitle,
                    style:
                    mediumTextStyle(fontSize: 15,txtColor: white)
                ),
                Text(
                    lblAboutLicensesText,
                    style:
                    mediumTextStyle(fontSize: 10,txtColor: white)
                )
              ],
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          GestureDetector(
              onTap: (){
                Get.to(()=> const LicenceScreen());
              },
              child: CommanContainer.arrowContainer(YELLOW_COLOR, white,0)),
        ],
      ),
    );
  }

  Widget Rate_Us_1() {
    return Container(
      margin: const EdgeInsets.only(left: LEFT_PADDING, right: RIGHT_PADDING, top: 30,bottom: 70),
      child: Column(

        children: [
          Text(
              lblAboutRateUsTitle,
              style:
              semiBoldTextStyle(fontSize: 14,txtColor: HexColor("#333333"))
            // TextStyle(color: APP_FONT_COLOR, fontSize: 15,fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
              lblAboutRateUsText,
              style:
              semiBoldTextStyle(fontSize: 10,txtColor: HexColor("#666666").withOpacity(0.7))
            // TextStyle(color: HexColor("#666666").withOpacity(0.7), fontSize: 10,fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: (){
              urlLauncher("https://play.google.com/store/apps/details?id=com.totalityre.app");
            },
            child: Container(
              //alignment: Alignment.center,
              width: Get.width*0.36,
              padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(cornarradius)),
                  // border: Border.all(
                  //   // color:bordercolor,
                  //   //   width: 10
                  // ),
                  color: white,
                  boxShadow: [fullcontainerboxShadow]
                // [
                //   BoxShadow(
                //       color: Colors.black.withOpacity(0.03),
                //       blurRadius: 4,
                //       offset: Offset(0,6),
                //       spreadRadius: 2
                //   )
                // ]
              ),
              // decoration: CustomDecorations().backgroundlocal(APP_GRAY_COLOR,
              //     cornarradius, 0.2, APP_FONT_COLOR),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImageWithBackGround(
                    // image: IMG_RATE_US,
                      image: IMG_RATEUS_SVG_NEW,
                      height: 50,
                      width: 50,
                      backgroundColor: hex("e8ab06"),
                      imgColor: white
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    lblRateUsButton,
                    style:
                    semiBoldTextStyle(fontSize: 13,txtColor: HexColor("#333333")
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget PowerBy_1(){
    return Container(
      margin: EdgeInsets.only(top: 20,bottom: 40),
      // height: 60,
      color: AppColors.BACKGROUND_WHITE,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Powered By",style: TextStyle(
              color: Colors.grey
          ),),
          SizedBox(width: 5,),
          Image.asset(IMG_APPLOGO,height: 30,color: Colors.grey,)
        ],
      ),
    );
  }
}
