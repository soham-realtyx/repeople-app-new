import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Controller/PrivacyTermController/PrivacyTermController.dart';
import 'package:Repeople/Model/ReferralModal/RefferralNewTermsAndCondition.dart';
import 'package:Repeople/View/DashboardPage/BottomnavigationBar.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:Repeople/Widgets/ShimmerWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';

class PrivacyTermPage extends StatefulWidget {
  final String? title;
  PrivacyTermPage({this.title});
  @override
  _PrivacyTermPageState createState() => _PrivacyTermPageState();
}

class _PrivacyTermPageState extends State<PrivacyTermPage> {
  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());
  PrivacyTermController cnt_PrivacyPolicy = Get.put(PrivacyTermController());

  var height = Get.height - APPBAR_HEIGHT - Get.mediaQuery.padding.top - 90;
  ScrollController scrollController =
  ScrollController(initialScrollOffset: 0, keepScrollOffset: true);
  @override
  void initState(){
    //todo:implementing code here
    super.initState();
    // MoengageAnalyticsHandler().track_event("privacy");
    cnt_PrivacyPolicy.pagetitle.value=widget.title??"";
    cnt_PrivacyPolicy.LoadPage();
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<PrivacyTermController>();
    Get.delete<CommonHeaderController>();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_WHITE,
      key: cnt_PrivacyPolicy.Globalprivacypolicykey,
      endDrawer: CustomDrawer(
        animatedOffset: Offset(1.0, 0),
      ),
      drawer: CustomDrawer(
        animatedOffset: Offset(-1.0, 0),
      ),
      body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: APPBAR_HEIGHT,),
                     Theme_4(""),
                    
                    SizedBox(height: 60,)
                  ],
                ),
              ),
              cnt_CommonHeader.commonAppBar(widget.title??"", cnt_PrivacyPolicy.Globalprivacypolicykey,color: white),
              Align(
                alignment: Alignment.bottomCenter,
                child: BottomNavigationBarClass(),
              ),
            ],
          )),
    );
  }
  Widget Theme_1() {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
      child: Container(
          height: height,
          padding: EdgeInsets.all(10),
          decoration: CustomDecorations().backgroundlocal(white, cornarradius, 0, white),
          width: Get.width,
          child: Scrollbar(
            child: SingleChildScrollView(
              primary: true,
              scrollDirection: Axis.vertical,
              child: Text(
                "$lblBookYourSiteDesc \n\n$lblBookYourSiteDesc \n\n$lblBookYourSiteDesc \n\n$lblBookYourSiteDesc \n\n$lblBookYourSiteDesc \n\n",
                style: TextStyle(fontSize: 14),
              ),
            ),
            thumbVisibility: true,
          )),
    );
  }
  Widget Theme_4(String title){
    return Container(
        color: AppColors.BACKGROUND_WHITE,
        padding: EdgeInsets.only(left: 20,right: 20,top: 10),
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(cnt_PrivacyPolicy.pagetitle.value=="Privacy Policy")PrivacyPolicy(),
            if(cnt_PrivacyPolicy.pagetitle.value=="Terms & Conditions") TermsAndConditions()

          ],
        )

    );
  }

  Widget TermsAndConditions(){
    return Obx(() {
      return FutureBuilder(
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            if(cnt_PrivacyPolicy.arrTermsAndCondition.isNotEmpty){
              return ListView.builder(
                itemCount:cnt_PrivacyPolicy.arrTermsAndCondition.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  RefferAFriendTermsAndConditionModel obj= cnt_PrivacyPolicy.arrTermsAndCondition[index];
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          obj.title ?? "",
                            style: TextStyle(
                                fontSize: 15,
                                color: gray_color,
                                fontWeight: FontWeight.w600,
                                fontFamily: fontFamily,
                                height: 1.5),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Html(
                          data: obj.description ??"",
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  );
                },

              );
            }
            else{
              return Center(child:
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text(cnt_PrivacyPolicy.IsTermsConditionEmpty.value,style:
                semiBoldTextStyle(fontSize: 15)
                  // TextStyle(fontSize: 15,fontWeight:FontWeight.bold,),
                ),
              ),);
            }
          } else {
            return ShimmerEffect(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                physics: BouncingScrollPhysics(),
                itemBuilder: (_, index) {
                  return Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                    child: shimmerWidget(width: Get.width, height: 100, radius: cornarradius),
                  );
                },
                itemCount: 6,
              ),
            );
          }
        },
        future: cnt_PrivacyPolicy.futureTermsAndCondition.value,
      );
    });
  }

  Widget PrivacyPolicy(){
    return Obx(() {
      return FutureBuilder(
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            if(cnt_PrivacyPolicy.arrPrivacyPolicy.isNotEmpty){
              return ListView.builder(
                itemCount:cnt_PrivacyPolicy.arrPrivacyPolicy.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  RefferAFriendTermsAndConditionModel obj= cnt_PrivacyPolicy.arrPrivacyPolicy[index];
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(obj.title ?? "",
                            style: TextStyle(
                                fontSize: 15,
                                color: gray_color,
                                fontWeight: FontWeight.w600,
                                fontFamily: fontFamily,
                                height: 1.5)),
                        SizedBox(
                          height: 10,
                        ),
                        Html(
                          data: obj.description ??"",
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  );
                },

              );
            }
            else{
              return Center(child:
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text(cnt_PrivacyPolicy.IsTermsConditionEmpty.value,style:
                semiBoldTextStyle(fontSize: 15)
                  // TextStyle(fontSize: 15,fontWeight:FontWeight.bold,),
                ),
              ),);
            }
          } else {
            return ShimmerEffect(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                physics: BouncingScrollPhysics(),
                itemBuilder: (_, index) {
                  return Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                    child: shimmerWidget(width: Get.width, height: 100, radius: cornarradius),
                  );
                },
                itemCount: 6,
              ),
            );
          }
        },
        future: cnt_PrivacyPolicy.futurePrivacyPolicy.value,
      );
    });
  }
}
