import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Controller/ReferAFriendFormController/ReferAFriendFormController.dart';
import 'package:Repeople/View/DashboardPage/BottomnavigationBar.dart';
import 'package:Repeople/View/ReferaFriendPage/ReferAFriendFormPage.dart';
import 'package:Repeople/View/ReferralPage/ReferralPage.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/Helper/HextoColor.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:Repeople/Model/ReferralModal/RefferralNewTermsAndCondition.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:Repeople/Widgets/ShimmerWidget.dart';


class ReferFriendTermsAndConditionPage extends StatefulWidget {
  const ReferFriendTermsAndConditionPage({Key? key}) : super(key: key);

  @override
  _ReferFriendTermsAndConditionPageState createState() => _ReferFriendTermsAndConditionPageState();
}

class _ReferFriendTermsAndConditionPageState extends State<ReferFriendTermsAndConditionPage> {

  ReferAFriendFormController cnt_ReferFriendForm = Get.put(ReferAFriendFormController());
  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());

  GlobalKey<ScaffoldState> Globalrefereafriendkey = GlobalKey<ScaffoldState>();

  Future<bool> ReferDialog(context) async {
    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            Get.back();
            Get.back();
            return false;
          },
          child: AlertDialog(
              insetPadding: EdgeInsets.all(20),
              title: Text(
                "Terms & Conditions",
                style: TextStyle(color: gray_color, fontSize: 18, fontWeight: FontWeight.w600,overflow: TextOverflow.ellipsis,),
                maxLines: 1,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
              content: Container(
                  width: Get.width,
                  child: SingleChildScrollView(
                      child: cnt_ReferFriendForm.Refer_a_friend_Theme_1())
              )),
        );
      },
    );
  }

  @override
  void initState() {

    cnt_ReferFriendForm.futureTermsAndCondition.value=
        cnt_ReferFriendForm.RetrieveTermsAndConditionData().whenComplete(() {
          // Future.delayed(Duration.zero, () {
          //
          //   // if(cnt_ReferFriendForm.arrTermsAndCondition.isNotEmpty){
          //   //   ReferDialog(context);
          //   // }
          //
          // });
        });

    //Future.delayed(Duration.zero, () => ReferDialog(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_WHITE,
      key: Globalrefereafriendkey,
      endDrawer: CustomDrawer(
        animatedOffset: Offset(1.0, 0),
      ),
      drawer: CustomDrawer(
        animatedOffset: Offset(-1.0, 0),
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
           SingleChildScrollView(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 SingleChildScrollView(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       SizedBox(height: 70),
                       TermAndConditionData(),
                       SizedBox(height: 70),
                     ],
                   ),
                 )
               ],
             ),
           ),
            cnt_CommonHeader.commonAppBar(
                REFER_A_FRIEND_APPBAR, Globalrefereafriendkey,
                isNotificationHide: true,
                color: AppColors.NEWAPPBARCOLOR,
                ismenuiconhide: true)
            // cnt_ReferFriendForm.CreateAppBarThemeList(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarClass(),
    );
  }

  Widget TermAndConditionData(){
    // RefferAFriendTermsAndConditionModel obj=cnt_ReferFriendForm.arrTermsAndCondition[index];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 24),
      child: Container(
        padding: EdgeInsets.only(top: 24,bottom: 24),
        decoration: BoxDecoration(
          color: AppColors.WHITE,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              // spreadRadius: 3,
              blurRadius: 6,
              offset: Offset(0, 4), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(right: 5,left: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              Center(
                child: SvgPicture.asset(
                  IMG_REFRE_A_FRIEND_SVG,
                  height: 177.w,
                  width: 173.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20.h),
              DataOfPopup(),
              Padding(
                padding: EdgeInsets.only(right: 6,left: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Read more ",
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: fontFamily,
                          fontWeight: FontWeight.w500,
                          color: gray_color_1
                      ),
                    ),
                    GestureDetector(
                      onTap: () {

                        Get.to(ReferralPage(
                          selectedvalue: 1,
                        ));
                      },
                      child: Text("Terms & Conditions " ,
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: fontFamily,
                            fontWeight: FontWeight.w600,
                            color: DARK_BLUE
                        ),
                      ),
                    ),
                    Text(
                      "before ",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: fontFamily,
                          fontWeight: FontWeight.w500,
                          color: gray_color_1
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 6,left: 6),
                child: Text(
                  "proceeding.",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: fontFamily,
                      fontWeight: FontWeight.w500,
                      color: gray_color_1
                  ),
                ),
              ),
              SizedBox(height: 60.h),
              Padding(
                padding: EdgeInsets.only(right: 5,left: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(ReferralPage(
                          selectedvalue: 0,
                        ));
                      },
                      child: Text(
                          faqText,
                          style:
                          TextStyle(
                            fontSize: 14,
                            color: HexColor("#006CB5"),
                            fontWeight: FontWeight.w500,
                            fontFamily: fontFamily,
                          )
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              OnTapButton(
                  text: lblReferFriendReferButton.toUpperCase(),
                  style: semiBoldTextStyle(
                      txtColor: white, fontSize: 12,fontWeight: FontWeight.w500),
                  // TextStyle(color: APP_FONT_COLOR, fontSize: 11,fontWeight: FontWeight.w600),
                  decoration: CustomDecorations().backgroundlocal(APP_THEME_COLOR, 6, 0, white),
                  height: 40.h,
                  onTap: () {
                    Get.to(ReferAFriendFormPage());
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget DataOfPopup(){
    return Obx(() {
      return FutureBuilder(
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            if(cnt_ReferFriendForm.arrTermsAndCondition.isNotEmpty){
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: cnt_ReferFriendForm.arrTermsAndCondition.length,
                  physics: BouncingScrollPhysics(),

                  itemBuilder: (context,index){
                    RefferAFriendTermsAndConditionModel obj=cnt_ReferFriendForm.arrTermsAndCondition[index];
                    return Html(data:obj.description);
                  });
            }
            else{
              return Container(
                height: 120.h,
                child: Center(child:
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Text(cnt_ReferFriendForm.IsTermsConditionEmpty.value,style:
                  semiBoldTextStyle(fontSize: 15)
                    // TextStyle(fontSize: 15,fontWeight:FontWeight.bold,),
                  ),
                ),),
              );
            }
          } else {
            return ShimmerEffect(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 8),
                itemBuilder: (_, index) {
                  return Padding(
                    padding:
                    const EdgeInsets.only(top: 5.0, bottom: 5, left: 1, right: 1),
                    child: shimmerWidget(width: 80, height: 50, radius: cornarradius),
                  );
                },
                itemCount: 3,
              ),
            );
          }
        },
        future: cnt_ReferFriendForm.futureTermsAndCondition.value,
      );
    });
  }
}
