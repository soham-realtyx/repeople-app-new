import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Controller/ReferralController/ReferralController.dart';
import 'package:Repeople/Model/ReferralModal/RefferralNewTermsAndCondition.dart';
import 'package:Repeople/View/DashboardPage/BottomnavigationBar.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:Repeople/Widgets/ShimmerWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:Repeople/Widgets/CommonBackButtonFor5theme.dart';

class ReferralPage extends StatefulWidget {
  late int? selectedvalue=0;
  ReferralPage({Key? key, this.selectedvalue}) : super(key: key);

  @override
  _ReferralPageState createState() => _ReferralPageState();
}

class _ReferralPageState extends State<ReferralPage> with TickerProviderStateMixin {

  ReferralController cnt_Referral = Get.put(ReferralController());
  CommonHeaderController cnt_Header = Get.put(CommonHeaderController());



  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    cnt_Referral.futuretablist.value = cnt_Referral.adddata();
    cnt_Referral.tabController = TabController(length: cnt_Referral.arrProjectDetailsList.length != null ? cnt_Referral.arrProjectDetailsList.length : 0, vsync: this);
    cnt_Referral.selectedvalue.value = widget.selectedvalue??0;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      cnt_Referral.tabController.addListener(() {
        if (cnt_Referral.tabController.indexIsChanging) {
          if (cnt_Referral.tabController.index == 0) {
            cnt_Referral.ismainpage = true.obs;
            setState(() {});
          } else {
            cnt_Referral.ismainpage = false.obs;
            setState(() {});
          }
        } else {
          // cnt_coowner.restart();
        }
      });
      cnt_Referral.futuretablist.value.then((value) {});
    });
  }

  @override
  Widget build(BuildContext context) {

    cnt_Referral.CreateReferralFAQList();
    return Obx(() {
      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: DefaultTabController(
          initialIndex: widget.selectedvalue??0,
          length: 2,
          child: Scaffold(
            key: cnt_Referral.Globalreferralpagekey,
            backgroundColor: AppColors.BACKGROUND_WHITE,
            endDrawer: CustomDrawer(
              animatedOffset: Offset(1.0, 0),
            ),
            drawer: CustomDrawer(
              animatedOffset: Offset(-1.0, 0),
            ),
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: Container(
                color: AppColors.BACKGROUND_WHITE,
                // color:Colors.grey.shade200,
                child: Stack(
                  children: [
                    NotificationListener<OverscrollIndicatorNotification>(
                      child: RefreshIndicator(
                        displacement: 60,
                        onRefresh: cnt_Referral.onRefresh,
                        child:SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: APPBAR_HEIGHT),
                              FilterTabView1(),
                              SizedBox(height: APPBAR_HEIGHT),
                            ],
                          ),
                        )
                      ),
                      onNotification: (overscroll) {
                        overscroll.disallowIndicator();
                        return true;
                      },
                    ),

              cnt_Header.commonAppBar(REFERRAL, cnt_Referral.Globalreferralpagekey,
                  color: white)
                  ],
                ),
              ),

            ),
            bottomNavigationBar:BottomNavigationBarClass(),
          ),
        ),
      );
    });
  }

  Widget FilterTabView1() {
    return cnt_Referral.arrProjectDetailsList.length > 0
        ? Obx(() {
      return FutureBuilder(
        builder: (_, index) {
          return Container(
            height: Get.height,
            color: white,
            // color: Colors.red,
            child:  DefaultTabController(
              initialIndex: cnt_Referral.selectedvalue.value,
              length: 2,
              child: Scaffold(
                backgroundColor: AppColors.BACKGROUND_WHITE,
                appBar:  PreferredSize(
                  preferredSize: Size.fromHeight(50.0), // here the desired height
                  child: DecoratedBox(decoration:  BoxDecoration(
                    color: Colors.white.withOpacity(0.0),
                    border: Border(bottom: BorderSide(color: APP_THEME_COLOR.withOpacity(0.1), width: 2.sp)),),
                    child:Center(
                      child:
                      Padding(padding: EdgeInsets.only(left: 0),child:  TabBar(
                          labelColor: APP_THEME_COLOR,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorColor: APP_THEME_COLOR,
                          onTap:(val){
                            print(val);
                          },
                          unselectedLabelColor: Colors.grey[500],
                          tabs:
                          cnt_Referral.arrProjectDetailsList.map((e) =>
                              Tab(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 5, right: 5),
                                  child: Text(
                                    e.title ?? "", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
                                ),
                              )).toList()
                      ),),),

                  ),

                ),
                body: TabBarView(
                  children:  [
                    Container(child: FAQ_1(),),
                    Container(child: Terms(),),
                  ],
                ),

              ),
            ),


          );
        },
        future: cnt_Referral.futuretablist.value,
      );
    })
        : Container();
  }

  Widget Terms()
  {
    return Container(
        padding: EdgeInsets.all(20),
        child:
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                TermsAndConditions(),

              ]),
        ));
  }
  Widget TermsAndConditions(){
    return Obx(() {
      return FutureBuilder(
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            if(cnt_Referral.arrTermsAndCondition.isNotEmpty){
              return Container(
                width: Get.width,
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 24),
                decoration: BoxDecoration(
                  color: AppColors.WHITE,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      // spreadRadius: 2,
                      blurRadius: 6,
                      offset: Offset(0, 4), // changes position of shadow
                    ),
                  ],

                ),
                child: ListView.builder(
                  itemCount:cnt_Referral.arrTermsAndCondition.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    RefferAFriendTermsAndConditionModel obj= cnt_Referral.arrTermsAndCondition[index];
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(obj.title ?? "",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: gray_color,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: fontFamily,
                                  height: 1.5)),
                          SizedBox(
                            height: 6,
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

                ),
              );
            }
            else{
              return Center(child:
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text(cnt_Referral.IsTermsConditionEmpty.value,style:
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
                itemCount: 10,
              ),
            );
          }
        },
        future: cnt_Referral.futureTermsAndCondition.value,
      );
    });
  }

  Widget FAQ_1() {
    return Container(
      // height: Get.height - 300.h,
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              FAQ_1_Data()
            ],
          ),
        ));
  }

  Widget FAQ_1_Data(){
    return Obx(() {
      return FutureBuilder(
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            if(cnt_Referral.arrFAQS.isNotEmpty){
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.WHITE,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      // spreadRadius: 3,
                      blurRadius: 6,
                      offset: Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: ListView.builder(
                  itemCount:cnt_Referral.arrFAQS.length,
                  // padding: EdgeInsets.only(left: 20,right: 20,bottom: 10,top: 10),
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    RefferAFriendTermsAndConditionModel obj= cnt_Referral.arrFAQS[index];
                    return
                      Obx(() => Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Theme(
                              data: ThemeData().copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                backgroundColor:white,
                                tilePadding: EdgeInsets.only(left: 20,right: 20),
                                maintainState: false,
                                initiallyExpanded: false,

                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(obj.title ?? "",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color:  LIGHT_GREY_COLOR,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: fontFamily,
                                            height: 1.5)),

                                  ],
                                ),
                                onExpansionChanged: (value) {
                                  obj.isOpen!.value=value;
                                  print(value);
                                  print(obj.isOpen!.value);
                                },
                                trailing:Obx(() => obj.isOpen?.value!=true?SvgPicture.asset(IMG_PLUS_SVG):SvgPicture.asset(IMG_MINUS_SVG)),
                                // trailing:Obx(() => obj.isOpen?.value!=true?Icon(Icons.add):Icon(Icons.minimize_rounded)),
                                children: [
                                  FAQ_DATA(index)
                                ],
                              ),
                            ),
                            Container(
                              width: Get.width,
                              height: 1,
                              color: BORDER_GREY,
                            )
                          ],
                        ),
                      ));
                  },

                ),
              );
            }
            else{
              return Center(child:
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text(cnt_Referral.IsFAQSEmpty.value,style:
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
                    child: Container(
                      width: Get.width, height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: APP_GRAY_COLOR,
                      ),
                    ),
                  );
                },
                itemCount: 5,
              ),
            );
          }
        },
        future: cnt_Referral.futureFAQS.value,
      );
    });
  }

  Widget FAQ_DATA(int index){
    RefferAFriendTermsAndConditionModel obj= cnt_Referral.arrFAQS[index];
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 12.0,left: 12,bottom: 12,right: 20),
          decoration: BoxDecoration(
              color: BACKGROUNG_GREYISH,
              border: Border(left: BorderSide(width: 4,color: DARK_BLUE))
          ),
          child: Html(
            data: obj.description ??"",
          ),
        ),
        Positioned(
            left: 0,
            child: Container(
              decoration: BoxDecoration(
                  border: Border(left: BorderSide(width: 3,color: DARK_BLUE))
              ),
            )
        )
      ],
    );
  }
}

