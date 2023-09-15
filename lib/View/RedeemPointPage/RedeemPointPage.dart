import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/Helper/HextoColor.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:Repeople/Model/RedeemPointsModal/RedeemHistoryModel.dart';
import 'package:Repeople/Model/RedeemPointsModal/RedeemPointListModel.dart';
import 'package:Repeople/Model/RedeemPointsModal/RedeemPointsModal.dart';
import 'package:Repeople/View/DashboardPage/BottomnavigationBar.dart';
import 'package:Repeople/View/ReferaFriendPage/ReferAFriendFormPage.dart';
import 'package:Repeople/View/ReferralStatusPage/ReferralStatusPage.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:Repeople/Widgets/ShimmerWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Helper/MoengageAnalyticsHandler.dart';
import 'package:Repeople/Controller/RedeemPointController/RedeemPointController.dart';
import 'package:shimmer/shimmer.dart';
import '../../Config/Constant.dart';
import '../../Config/utils/colors.dart';
import '../../Controller/Drawer/DrawerController.dart';

class RedeemPointPage extends StatefulWidget {
  RedeemPointPage({Key? key}) : super(key: key);
  @override
  State<RedeemPointPage> createState() => _RedeemPointPageState();
}

class _RedeemPointPageState extends State<RedeemPointPage> with TickerProviderStateMixin {

  var directorykey = GlobalKey<ScaffoldState>();
  RedeemPointController cnt_point = Get.put(RedeemPointController());
  CustomDrawerController cnt_Drawer = Get.put(CustomDrawerController());
  ScrollController scrollController = ScrollController();
  CommonHeaderController cnt_header = Get.put(CommonHeaderController());
  @override
  void initState() {
    super.initState();
    MoengageAnalyticsHandler().track_event('redeem_point');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      cnt_point.TotalRedeemablePoints();
      cnt_point.GetBrandList();
      cnt_point.futuretablist.value = cnt_point.adddata();
      cnt_point.futureRedeemPoint.value=cnt_point.RetrieveRedeemPointsData();
      cnt_point.futureRedeemHistory.value=cnt_point.RetrieveRedeemHistoryData();
      cnt_point.GetRedeemList();
      cnt_point.tabController = TabController(
          length: cnt_point.arrProjectDetailsList.length != null
              ? cnt_point.arrProjectDetailsList.length
              : 0,
          vsync: this);

      cnt_point.futuretablist.value.then((value) {
        cnt_point.tabController.addListener(() {

        });
      });
    });

  }

  @override
  void dispose() {
    cnt_point.tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: AppColors.BACKGROUND_WHITE,
            key: cnt_point.Globalreedmkey,
            endDrawer: CustomDrawer(animatedOffset: Offset(1.0,0),),
            drawer: CustomDrawer(animatedOffset: Offset(-1.0,0),),
            body: SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: APPBAR_HEIGHT),
                        wd_ReferFriend1(),
                        FilterTabView1(),
                        SizedBox(height: APPBAR_HEIGHT),
                      ],
                    ),
                  ),
                  cnt_header.commonAppBar(REDEEM_POINT, cnt_point.Globalreedmkey,color: AppColors.NEWAPPBARCOLOR.withOpacity(0.0),)

                ],
              ),
              // ),
            ),
            bottomNavigationBar:BottomNavigationBarClass(),
          ),
        ),
      );
    });
  }
  Widget wd_ReferFriend1() {
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 25, bottom: 20),
        width: Get.width,
        decoration:
        BoxDecoration(
          color: white,
          boxShadow: [fullcontainerboxShadow],
          borderRadius: BorderRadius.all(Radius.circular(cornarradius)),),
        // CustomDecorations().backgroundlocal(WHITE, 10, 0, WHITE),
        child: Padding(
          padding:
          const EdgeInsets.only(top: 20, left: 0, right: 0, bottom: 10),
          child: _generateReferFriend1(),
        ));
  }

  Widget _generateReferFriend1() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() =>    Text(redeemPoints.value.toString(),
           style: mediumTextStyle(txtColor: new_black_color, fontSize: 40)
            )),
            SizedBox(
              width: 5,
            ),
            Text("pts", style: semiBoldTextStyle(fontSize: 13)
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),

        Text(lblReferFriendLabel.toUpperCase(),
            style: mediumTextStyle(txtColor: gray_color_1, fontSize: 10)
        ),
        SizedBox(
          height: 10,
        ),
        Divider(
          thickness: 1,
          color: APP_BLACK_38.withOpacity(0.1),
        ),
        SizedBox(
          height: 3,
        ),
        Container(
          padding: EdgeInsets.only(left: 10,right: 10),
          child: Row(
            children: [
              Expanded(
                child: OnTapButton(
                    text: lblReferFriendReferButton,
                    style: semiBoldTextStyle(fontSize: 12, txtColor: white),
                    // TextStyle(color: WHITE, fontSize: 12,fontWeight: FontWeight.w600),
                    icon:
                    SvgPicture.asset(
                      IMG_RIGHTARROW_SVG_NEW/*,height: 13*/,
                      width: 12,color: white,
                      // alignment: Alignment.center,
                    ),
                    decoration: CustomDecorations()
                        .backgroundlocal(APP_THEME_COLOR, 8, 0, white),
                    height: 40,
                    onTap: () {
                      Get.to(ReferAFriendFormPage());
                    }),
              ),
              SizedBox(
                width: 10,
              ),
              ReferFriendFavoiteButton(
                height: 40,
                width: 40,
                decoration: CustomDecorations()
                    .backgroundlocal(white, 8, 1, hex("e8e8e8")),
                onTap: () {
                  Get.back();
                  Get.to(ReferralStatusPage());
                },
              )
            ],
          ),
        )
      ],
    );
  }

  Widget FilterTabView1() {
    return  Obx(() {
      return FutureBuilder(
        builder: (_, index) {
          return Container(
            height: Get.height - 230,
            color: AppColors.BLACK,
            // color: Colors.red,
            child: DefaultTabController(
              length: 2,
              child: Scaffold(
                backgroundColor: AppColors.BACKGROUND_WHITE,
                appBar: PreferredSize(
                  preferredSize:
                  Size.fromHeight(60.0), // here the desired height
                  child: Container(
                    // width: MediaQuery.of(context).size.width,
                    padding:
                    EdgeInsets.only(left: 0.0, top: 10, right: 0,),
                    margin: EdgeInsets.only(bottom: 0),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.0),
                            border: Border(bottom: BorderSide(color: APP_THEME_COLOR.withOpacity(0.1), width: 2.sp)),
                          ),
                          child: TabBar(
                              labelColor: APP_THEME_COLOR,
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicatorColor: APP_THEME_COLOR,
                              onTap: (val) {
                                print(val);
                              },
                              // controller: cnt_point.tabController,
                              unselectedLabelColor: Colors.grey[500],
                              tabs: cnt_point.arrredeemList
                                  .map((e) => Tab(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 5, right: 5),
                                  child: Text(
                                    e.name,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ))
                                  .toList()
                          ),
                        ),
                      ),
                    ),

                  ),
                ),
                body: TabBarView(
                  children: [
                    CategoryView(),
                    redeemhistoryview(),
                  ],
                ),
              ),
            ),

          );
        },
        future: cnt_point.futuretablist.value,
      );
    });

  }


  Widget redeemhistoryview() {
    return  ListView(
      shrinkWrap: true,
      children: [
        ReedemHistory(),
        SizedBox(
          height: 150.h,
        )
      ],
    );
  }

  Widget ReedemHistory(){
    return Obx(() {
      return FutureBuilder(
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {

            print(cnt_point.arrRedeemHistory.length.toString());
            if(cnt_point.arrRedeemHistory.isNotEmpty){

              return  Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),

                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [fullcontainerboxShadow],
                        borderRadius: BorderRadius.circular(cornarradius)),
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child:Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          SizedBox(height: 20,),
                          ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: cnt_point.arrRedeemHistory.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, ind2) {
                                RedeemHistoryModel obj = cnt_point.arrRedeemHistory[ind2];
                                return GestureDetector(
                                  onTap: () {
                                    MoengageAnalyticsHandler().track_event("redeem_history_view");
                                    cnt_point.RedeemHistoryBottomsheeet(obj);
                                  },
                                  child: Container(
                                    width: Get.width,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      color: APP_THEME_COLOR,
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: INDICATOR_SLIDER_COLOR,
                                                          width: 1)
                                                  ),
                                                ),
                                                SizedBox(width: 40,),
                                                ind2!=cnt_point.arrRedeemHistory.length-1?
                                                IntrinsicHeight(
                                                  child: Row(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Center(
                                                        child: Container(
                                                          width: 1,
                                                          height: 83,
                                                          // height: double.infinity,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                // color: APP_THEME_COLOR,
                                                                  color: INDICATOR_SLIDER_COLOR,
                                                                  width: 0.5)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ):SizedBox(),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(obj.date ?? "", style: regularTextStyle(txtColor: gray_color_1,fontSize: 11),),
                                                SizedBox(
                                                  height: 5.0,
                                                ),
                                                SizedBox(
                                                  width: 130,
                                                  child: Text(obj.name ?? "", style: TextStyle(fontSize: 15, color: gray_color, fontWeight: FontWeight.w600, fontFamily: fontFamily,height: 1.3)),
                                                ),
                                                SizedBox(height: 5.0,),
                                                Text(obj.redeemamountstr ?? "", style: TextStyle(color: gray_color_1, fontSize: 12,fontWeight: FontWeight.w500),),
                                                // SizedBox(height: 15.0,),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(15),
                                                      border: Border.all(color: hex(obj.class1 ?? "#000000"),width: 0.5)
                                                  ),
                                                  child: Padding(padding: EdgeInsets.only(top: 5,bottom: 6,right: 8,left: 8),
                                                    child:Text(obj.status ?? "",style: mediumTextStyle(fontSize: 10,txtColor: hex(obj.class1 ?? "#000000")),maxLines: 1,overflow: TextOverflow.ellipsis,),),

                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        // SizedBox(width: 50,),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                          SizedBox(height: 20,),
                        ],
                      ),
                    )),
              );
            }
            else{
              return Center(child:
              Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: Text(cnt_point.IsRedeemPointEmpty.value,style:
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
                    child: shimmerWidget(width: Get.width, height: 60, radius: cornarradius),
                  );
                },
                itemCount: 10,
              ),
            );
          }
        },
        future: cnt_point.futureRedeemPoint.value,
      );
    });
  }

  Widget CategoryView() {
    return
      Container(
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 80,
                  ),
                  ReedemPoints(),
                  SizedBox(
                    height: 150.h,
                  ),
                ],
              ),
            ),
            Positioned(

              child: SearchProjectTextField(),
              left: 0,
              right: 0,
              top: 0,)
          ],
        ),
      );
  }

  Widget ReedemPoints(){
    return Obx(() {
      return FutureBuilder(
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {

            print(cnt_point.arrRedeemPoints.length.toString());
            if(cnt_point.arrRedeemPoints.isNotEmpty){

              return  ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: cnt_point.arrRedeemPoints.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, ind2) {
                    RedeemListModel obj = cnt_point.arrRedeemPoints[ind2];
                    return   Padding(
                      padding: const EdgeInsets.only(left: 20.0,right: 20),
                      child: GestureDetector(
                        onTap: (){
                          MoengageAnalyticsHandler().track_event("redeem_brands_view");
                          cnt_point.BrandBottomsheeet(obj);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: white,
                              boxShadow: [fullcontainerboxShadow],
                              borderRadius: BorderRadius.circular(cornarradius)),
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          margin: EdgeInsets.only(left: 0, bottom: ind2==
                              cnt_point.arrRedeemPoints.length-1?20:0,right: 0,top: 20,),
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 0.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(left: 0),
                                    child: ClipOval(
                                      child: obj.icon != null && obj.icon!=""
                                          ? CachedNetworkImage(
                                        // width: Get.width-10,
                                        placeholder: (context, url) => Container(
                                          height: 40,
                                          width: 40,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(35),
                                            child: Shimmer.fromColors(
                                                baseColor: Colors.grey.shade300,
                                                highlightColor: Colors.grey.shade100,
                                                enabled: true,
                                                child: shimmerWidget(height: 180, width: Get.width, radius: 0)),
                                          ),
                                        ),
                                        fadeInDuration: Duration.zero,
                                        fadeOutDuration: Duration.zero,
                                        placeholderFadeInDuration: Duration.zero,
                                        imageUrl: obj.icon ?? "",
                                        fit: BoxFit.fill,
                                      )
                                          : Container(
                                        height: 40,
                                        width: 40,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          color: Colors.grey,
                                        ),
                                        child: Text(
                                            obj.name!
                                                .substring(0, 1)
                                                .toString()
                                                .toUpperCase(),
                                            style: semiBoldTextStyle(
                                                txtColor: Colors.white,
                                                fontSize: 25)
                                          // TextStyle(
                                          //     fontSize: 25,
                                          //     color: Colors.white,
                                          //     fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 0, top: 0, bottom: 3),
                                          child: Text(
                                            obj.name!.toString(),
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: gray_color,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: fontFamily,
                                                height: 1.5
                                            ),
                                            // TextStyle(
                                            //   fontSize: 15,
                                            //   fontWeight: FontWeight.bold,
                                            // ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  /*for this changes*/
                                ]),
                          ),
                        ),
                      ),
                    );
                    // )
                    // ;
                  });
            }
            else{
              return Center(child:
              Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: Text(cnt_point.IsRedeemPointEmpty.value,style:
                semiBoldTextStyle(fontSize: 15)
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
                    child: shimmerWidget(width: Get.width, height: 60, radius: cornarradius),
                  );
                },
                itemCount: 10,
              ),
            );
          }
        },
        future: cnt_point.futureRedeemPoint.value,
      );
    });
  }

  Widget FilterTabView() {
    return cnt_point.arrProjectDetailsList.length > 0
        ? Obx(() {
      return FutureBuilder(
        builder: (_, index) {
          return Container(
            color: Colors.white,
            child: TabBar(
                controller: cnt_point.tabController,
                //isScrollable: true,
                labelColor: Colors.blueAccent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: Colors.blueAccent,
                indicatorWeight: 3.0,
                // labelPadding: EdgeInsets.all(0),
                unselectedLabelColor: Colors.grey,
                tabs: cnt_point.arrProjectDetailsList.map((element) {
                  return Tab(
                    child: Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: Text(
                        element.project_name!,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  );
                }).toList()),
          );
        },
        future: cnt_point.futuretablist.value,
      );
    })
        : Container();
  }

  Widget Commitee_header(String title, GlobalKey<ScaffoldState> scaffoldKey) {
    return SafeArea(
      child: Container(
        // height: APPBAR_HEIGHT,
        color: white,
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () => cnt_point.ClosePageCallback(),
                        icon: Icon(Icons.arrow_back_ios)),
                    Text(
                      title,
                      style: TextStyle(
                          color: APP_FONT_COLOR,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Container(
                  child: Row(
                    children: [
                      //TrallingIconSearch(IMG_SEARCH, APP_FONT_COLOR,(){}),
                      TrallingIconDrawer(IMG_MENU2, APP_FONT_COLOR, () {
                        scaffoldKey.currentState!.openEndDrawer();
                      })
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget SearchProjectTextField() {
    return Container(
      width: Get.width,
      padding: EdgeInsets.only(bottom: 20,top: 20,left: 20,right: 20),
      color: AppColors.BACKGROUND_WHITE,
      child: Autocomplete<RedeemListDetailsModel>(
        optionsBuilder: (value) {
          List<RedeemListDetailsModel> filter = [];
          if (value.text.isNotEmpty) {
            filter = [];
          }
          return filter;
        },
        initialValue: TextEditingValue.empty,
        onSelected: (value) {print(value);},
        optionsMaxHeight: Get.height / 3,
        fieldViewBuilder: (context, textcontroller, focusnode, onsubmit) {
          return Container(
            decoration: BoxDecoration(
                boxShadow: [fullcontainerboxShadow]
            ),
            child: Material(
              color: Colors.white,
              // elevation: 1,
              borderRadius: BorderRadius.circular(cornarradius),
              child: TextField(
                controller: textcontroller,
                focusNode: focusnode,
                onSubmitted: (value) {
                  cnt_point.onSearchTextChanged(textcontroller.text);
                },
                onChanged: (value) {
                  cnt_point.onSearchTextChanged(textcontroller.text);
                },
                onTap: (){
                  MoengageAnalyticsHandler().track_event("redeem_list_search");
                },
                decoration: InputDecoration(
                    hintText: 'Search here....',
                    hintStyle: regularTextStyle(
                        txtColor: HexColor("#b4b4b4"), fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 20,right: 20,top: 15,bottom: 15),
                    suffixIcon: InkWell(
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          print("im tapping");
                          cnt_point.onSearchTextChanged(textcontroller.text);
                        },
                        child: Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(
                                horizontal: 6, vertical: 5),
                            height: 30,
                            width: 30,
                            decoration: CustomDecorations().backgroundlocal(
                                APP_THEME_COLOR,
                                cornarradius,
                                0,
                                APP_THEME_COLOR),
                            child: SvgPicture.asset(
                              IMG_SEARCH_SVG_NEW,
                              color: white,
                            )
                        ))
                ),
                cursorColor: Colors.black54,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget TabShimmerEffect() {
    return Container(
        height: 50,
        margin: EdgeInsets.only(left: 10, right: 10, top: 5),
        child: ShimmerEffect(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (_, index) {
              return Padding(
                padding: const EdgeInsets.only(
                    top: 5.0, bottom: 5, left: 1, right: 1),
                child: shimmerWidget(width: 80, height: 50, radius: 0),
              );
            },
            itemCount: 1,
          ),
        ));
  }
}
