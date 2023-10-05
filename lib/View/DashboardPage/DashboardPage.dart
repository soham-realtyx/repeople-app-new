
import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/Helper/HextoColor.dart';
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Controller/DashBoardHeaderController/DashboardHeaderController.dart';
import 'package:Repeople/Controller/DashboardController/DashboardController.dart';
import 'package:Repeople/Controller/MenuClickHandlerController/MenuClickHandler.dart';
import 'package:Repeople/Controller/ScheduleSiteController/ScheduleVisitController.dart';
import 'package:Repeople/Model/Dashbord/ExploreMoreListClass.dart';
import 'package:Repeople/Model/News/NewsModal.dart';
import 'package:Repeople/Model/ProjectListModal/ProjectListModal.dart';
import 'package:Repeople/Model/RedeemPointsModal/RedeemPointListModel.dart';
import 'package:Repeople/View/BuyAndSellPage/BuyAndSellPage.dart';
import 'package:Repeople/View/DashboardPage/BottomnavigationBar.dart';
import 'package:Repeople/View/FavoritePage/FavoritePage.dart';
import 'package:Repeople/View/MyAccountPage/EditProfilePage.dart';
import 'package:Repeople/View/NewsListPage/NewsPage.dart';
import 'package:Repeople/View/ProjectDetails/ProjectDetails.dart';
import 'package:Repeople/View/ProjectListPage/AddNewHomePage.dart';
import 'package:Repeople/View/ProjectListPage/ProjectListPage.dart';
import 'package:Repeople/View/RedeemPointPage/RedeemPointPage.dart';
import 'package:Repeople/View/ReferFriendTermsAndConditionPage/ReferFriendTermsAndConditionPage.dart';
import 'package:Repeople/View/ReferralStatusPage/ReferralStatusPage.dart';
import 'package:Repeople/View/ScheduleSitePage/ScheduleSitePage.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:Repeople/Widgets/ShimmerWidget.dart';
import 'package:Repeople/Widgets/TextEditField.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Helper/MoengageAnalyticsHandler.dart';
import 'dart:io';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Widgets/CommomBottomSheet.dart';
import 'package:Repeople/Widgets/CustomAppBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Config/Constant.dart';

class DashboardPage extends StatefulWidget {

  final bool isRegistered;
  const DashboardPage({Key? key,this.isRegistered=false}) : super(key: key);
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  DashboardController cntDash = Get.put(DashboardController());
  // CustomDrawerController cnt_Drawer = Get.put(CustomDrawerController());
  ScheduleSiteController cntScheduleSite = Get.put(ScheduleSiteController());
  DashboardHeaderController cntDashHeader = Get.put(DashboardHeaderController());
  GlobalKey<ScaffoldState> dashBoardKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    cntScheduleSite.ClearData();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      checkForRegiStore();
      cntDashHeader.check.value=dashBoardKey;
      BottomNavigationBarClass().selectedIndex=0;
      cntDash.GetExploreMore();
    });
  }

  checkForRegiStore(){
    if(widget.isRegistered==true){
      Get.to(()=> EditProfilePage(isRegistered: widget.isRegistered));
    }
  }

  exitDialog() {
    LoginDialoge(
        dialogtext: "Do you want to exit App?",
        stackicon: Image.asset(
          IMG_PLAYSTORE_PNG,
          color: Colors.white,
          width: 40,
          height: 40,
        ),
        firstbuttontap: () {
          Get.back();
        },
        secondbuttontap: () {
          exit(0);
        },
        secondbuttontext: "Yes",
        firstbuttontext: "No");
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => exitDialog(),
        child: Scaffold(
            backgroundColor: AppColors.BACKGROUND_WHITE,
            key: dashBoardKey,
            endDrawer: CustomDrawer(
              animatedOffset: const Offset(1.0, 0),
              isRegistered: widget.isRegistered,
            ),
            drawer: CustomDrawer(
              animatedOffset: const Offset(-1.0, 0),
              isRegistered: widget.isRegistered,
            ),
            body: SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 90,
                      ),
                      homeScreenData(),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  )),
                  const dashBoardHeader(),

                ],
              ),
            ),
        bottomNavigationBar: BottomNavigationBarClass(selectedIndex: 0),
        ));
  }

  Widget homeScreenData(){
    return Obx(() => cntDash.islogin.isFalse ?Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      wdDashBoardTitle(),
      wdDashBoardProject(),
      wdExploreMore(),
      wdBookYourSiteToday(),
      wdRedeemBrands(),
      wdBuySellWidget(),
      wdNewsListData(),
      wdBookASiteVisitData(),
      wdAlreadyWorldHome(),
      wdSmartHomeBuyer(),
      otherMenuOption(),
      ],
    )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              wdDashBoardTitle(),
              referFriendData(),
              wdDashBoardProject(),
              wdExploreMore(),
              wdBookYourSiteToday(),
              wdRedeemBrands(),
              wdFavouriteListData(),
              wdBuySellWidget(),
              wdNewsListData(),
              wdBookASiteVisitData(),
              wdAlreadyWorldHome(),
              wdSmartHomeBuyer(),
              otherMenuOption(),
      ],
    ));
  }

  Widget wdDashBoardTitle() {
    return Container(
      padding: EdgeInsets.only(top: 0, left: 20, right: 20,bottom: cntDash.islogin.isTrue?0:20),
      child: RichText(
        text: TextSpan(
            text: "Hello,",
            style: regularTextStyle(
                fontSize: 20, txtColor: new_black_color,
                fontWeight: FontWeight.w400
            ),
            children: <TextSpan>[
              !cntDash.islogin.value
                  ? TextSpan(
                  text: '\nGuest User ',
                  style: boldTextStyle(txtColor: new_black_color, fontSize: 24,fontWeight: FontWeight.w700)
              )
                  : TextSpan(
                  text: '\n${cntDash.username.value}',
                  style: boldTextStyle(txtColor: new_black_color, fontSize: 24,fontWeight: FontWeight.w700)
              ),
            ]
        ),
      ),
    );
  }

  Widget referFriendData() {
    return Obx(() =>
        FutureBuilder(
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                !snapshot.hasError && snapshot.data!=null) {
              //if (arrRefferInfo.isNotEmpty) {
              return cntDash.usertype.value!="3"?
              Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 25, bottom: 20),
                  width: Get.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(cornarradius)),
                      color: white,
                      boxShadow: [fullcontainerboxShadow]
                  ),
                  child: Material(
                    color: Colors.white,
                    elevation: 0,
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, left: 0, right: 0, bottom: 0),
                      child: _generateReferFriend1(),
                    ),
                  )):const SizedBox();
            } else {
              return redeemReferShimmerWidget();
            }
          },
          future: cntDash.futureRefferInfo.value,
        ));
  }

  Widget _generateReferFriend1() {
    return Stack(
      children: [
        Obx(() => cntDash.arrRefferInfo.isNotEmpty?Positioned(
          right: 20,
          top : 0,
          child: InkWell(
            onTap: () {
              MoengageAnalyticsHandler().track_event('refer_a_friend_information');
              cntDash.RefferInfoBottomSheet();
            },
            child: const Icon(Icons.info_outline_rounded),
          ),
        ):const SizedBox(),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Text(redeemPoints.value.toString(),
                    style: mediumTextStyle(txtColor: new_black_color, fontSize: 40,fontWeight: FontWeight.w500)
                )),
                const SizedBox(
                  width: 2,
                ),
                Text("pts",
                    style: mediumTextStyle(txtColor: new_black_color, fontSize: 20,fontWeight: FontWeight.w400)
                )
              ],
            ),

            const SizedBox(
              height: 5,
            ),
            Text(lblReferFriendLabel.toUpperCase(),
                style: mediumTextStyle(txtColor: gray_color_1, fontSize: 10,fontWeight: FontWeight.w400)
            ),
            const SizedBox(
              height: 10,
            ),
            Divider(
              thickness: 1,
              color: hex("E8E8E8"),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Row(

                children: [
                  Expanded(
                    child: OnTapButton(
                        text: lblReferFriendReferButton,
                        style: semiBoldTextStyle(txtColor: white, fontSize: 10,fontWeight: FontWeight.w500),
                        icon:
                        SvgPicture.asset(
                          IMG_RIGHTARROW_SVG_NEW,height: 10,
                          width: 10,color: white,
                        ),
                        decoration: CustomDecorations().backgroundlocal(APP_THEME_COLOR, 6, 0, white),
                        height: 40,
                        onTap: () {
                          MoengageAnalyticsHandler().track_event("refer_a_friend_terms_and_condition");
                          Get.to(const ReferFriendTermsAndConditionPage());
                          // Get.to(ReferAFriendFormPage());
                        }),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: OnTapButton(
                        text: lblReferFriendRedeemButton,
                        style: semiBoldTextStyle(
                            txtColor: APP_FONT_COLOR, fontSize: 10,fontWeight: FontWeight.w500),
                        icon:
                        SvgPicture.asset(IMG_RIGHTARROW_SVG_NEW,height: 10,width: 10,color: APP_FONT_COLOR,),

                        decoration: CustomDecorations()
                            .backgroundlocal(white, 8, 1, hex("e8e8e8")),
                        height: 40,
                        onTap: () {
                          Get.to(()=>RedeemPointPage());
                        }),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ReferFriendFavoiteButton(
                    height: 40,
                    width: 40,
                    color: new_black_color,
                    decoration: CustomDecorations()
                        .backgroundlocal(white, 8, 1,hex("e8e8e8")),
                    onTap: () {
                      MoengageAnalyticsHandler().track_event('referral_status');
                      Get.to(const ReferralStatusPage());
                    },
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ],
    );
  }

  Widget wdDashBoardProject() {
    return Obx(() {
      return FutureBuilder(
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasError && snapshot.data!=null) {
            if (cntDash.arrProjectList.isNotEmpty) {
              return
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(lblProject,
                              style: TextStyle(color: gray_color_1, fontSize: 12.sp,fontFamily: fontFamily,fontWeight: FontWeight.w700),
                            ),
                            InkWell(
                              child: Text(lblViewmore.toUpperCase(),
                                  style: semiBoldTextStyle(
                                      fontSize: 10, txtColor: APP_THEME_COLOR)
                              ),
                              onTap: () {
                                Get.to(()=>const ProjectListPage());
                              },
                            )
                          ],
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 160.w,
                      child: ListView.builder(
                          padding: const EdgeInsets.only(left: 20, right: 10),
                          scrollDirection: Axis.horizontal,
                          itemCount: cntDash.arrProjectList.length,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, i) {
                            return _generateProjectCell1(i);
                          }),
                    )
                  ],
                );

            } else {
              return Container();
            }
          } else {
            return projectShimmerWidget();
          }
        },
        future: cntDash.futureprojectlist.value,
      );
    });

  }

  Widget _generateProjectCell1(int index) {
    ProjectListModal objProject = cntDash.arrProjectList[index];
    return
      cntDash.arrProjectList.isNotEmpty?
      InkWell(
        onTap: () {
          MoengageAnalyticsHandler().SendAnalytics({"project_id" : objProject.sId, "project_name": objProject.projectname},"project_details");
          Get.to(() => ProjectDetails(projectid: objProject.sId.toString(),));
        },
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(right: index!=cntDash.arrProjectList.length-1?10:10,left: index!=0?0:0),
          width: 90.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(cornarradius),
                child: CachedNetworkImage(
                  width: 84.w, height: 84.w,
                  placeholder: (context, url) => shimmerWidget(  width: 84.w, height: 84.w,radius:8 ),
                  fadeInDuration: Duration.zero,
                  fadeOutDuration: Duration.zero,
                  placeholderFadeInDuration: Duration.zero,
                  imageUrl:  objProject.featureimg??"",
                  fit: BoxFit.fill,
                  errorWidget: (context, url, error) {
                    return SvgPicture.network(
                        objProject.featureimg??"",
                        width: 84.w, height: 84.w, fit: BoxFit.fill
                    );
                  },
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Center(
                child: Text(
                  objProject.projectname??"",
                  style: mediumTextStyle(fontSize: 10, txtColor: new_black_color,fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Center(
                child: Text(
                  objProject.area??"",
                  style: regularTextStyle(txtColor: gray_color_1, fontSize: 9,fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      )
          : const SizedBox();
  }

  Widget wdExploreMore() {
    return  Obx(() {
      return FutureBuilder(
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasError && snapshot.data!=null) {
            if (cntDash.arrExploreMore.isNotEmpty) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: (){
                          // Get.to(LoginPage());
                        },
                        child: Container(
                            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                            child: Text(lblExploreMore, style: TextStyle(color: gray_color_1, fontSize: 12.sp,fontFamily: fontFamily,fontWeight: FontWeight.w600),
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                      height: 210,
                      child: Obx(() => GridView.builder(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        controller: cntDash.scrollController,
                        physics: const BouncingScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, childAspectRatio: 0.4),
                        itemBuilder: (context, i) {
                          return Obx(() =>  _generateExploreMoreCell(i));
                        },
                        itemCount: cntDash.arrExploreMore.isNotEmpty ? cntDash.arrExploreMore.length : 0,
                      )))
                ],
              );
            } else {
              return Container();
            }
          } else {
            return exploreMoreShimmerWidget();
          }
        },
        future: cntDash.futurearrexploremorelist.value,
      );
    });
  }

  Widget _generateExploreMoreCell(int index) {
    MenuItemModel obj = cntDash.arrExploreMore[index];
    return InkWell(
      onTap: () {
        if (obj.alias != null) ClickHandler(obj.alias.toString(), 0);
        MoengageAnalyticsHandler().SendAnalytics({"explore_more_alias":obj.alias},"explore_more");
      },
      child: SizedBox(
        width: 110,
        height: 50,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cornarradius),
          ),
          shadowColor: hex("266CB5").withOpacity(0.2),
          color: white,
          elevation: 1,
          clipBehavior: Clip.hardEdge,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                // padding: EdgeInsets.all(12),
                decoration:
                CustomDecorations().background(obj.color??"", 8, 0, obj.color??""),
                child: CachedNetworkImage(
                  width: 24, height: 24,
                  placeholder: (context, url) => shimmerWidget(width: 40.w, height: 40.w,radius: 6),
                  fadeInDuration: Duration.zero,
                  fadeOutDuration: Duration.zero,
                  placeholderFadeInDuration: Duration.zero,
                  imageUrl:  obj.icon??"",
                  color: white,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) {
                    return SvgPicture.network(
                        obj.icon??"",color: white,
                        width: 24, height: 24,fit: BoxFit.cover
                    );
                  },
                ),
              ),
              SizedBox(
                width: 65.w,
                child: Text(
                  obj.name??"",
                  style:
                  mediumTextStyle(fontSize: 12, txtColor: new_black_color,fontWeight: FontWeight.w500),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(width: 10,)
            ],
          ),
        ),
      ),
    );
  }

  Widget wdBookYourSiteToday() {
    return GestureDetector(
      onTap: () {
        MoengageAnalyticsHandler().track_event("schedule_a_site_visit");
        Get.to(()=>const ScheduleSitePage());
      },
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Container(
              margin: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 0),
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 25),
              decoration: CustomDecorations()
                  .backgroundwithoutborder(APP_THEME_COLOR, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lblBookYourSite_a,
                              style: mediumTextStyle(fontSize: 16, txtColor: white,fontWeight: FontWeight.w400),
                            ),
                            Text(
                              lblBookYourSite_b,
                              style: boldTextStyle(fontSize: 16, txtColor: white,fontWeight: FontWeight.w700),
                            ),
                          ]),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 220.w,
                            child: Text(lblBookYourSiteDescNEw,
                                maxLines: 2,
                                style:
                                TextStyle(
                                    fontSize: 12.sp,
                                    color: white,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: fontFamily,height: 1.3
                                )
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Get.to(()=>const ScheduleSitePage());
                        },
                        child: Container(
                            height: 30,
                            width: 30,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 9,vertical: 6),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: white,
                            ),
                            child:
                            Center(
                                child: SvgPicture.asset(
                                  IMG_RIGHTARROW_SVG_NEW,
                                  height: 12.h,
                                  width: 6.w,
                                  color: AppColors.BLACK,
                                ))
                        ),
                      ),
                    ],
                  ),
                ],
              )),
          Positioned(
              right: 30,
              bottom: -40,
              child: Image.asset(IMG_BACKGROUND_ELLIPSE,width: 137,height: 137,fit: BoxFit.cover,))
        ],
      ),
    );
  }

  Widget wdRedeemBrands() {
    return Obx(() =>  cntDash.usertype.value!="3"?  Container(
      margin:const  EdgeInsets.only(left: 20,right: 20, bottom: 20,top: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(cornarradius)),
          color: AppColors.WHITE,
          boxShadow: [fullcontainerboxShadow]
      ),
      child: Column(
        children: [
          SizedBox(height: 24.w),
          SvgPicture.asset(
            IMG_REFRE_A_FRIEND_SVG,
            height: 177.w,
            width: 173.h,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 8.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  lblReferaFriendText,
                  maxLines: 2,
                  style:
                  TextStyle(
                    fontSize: 12.sp,
                    color: HexColor("#333333"),
                    fontWeight: FontWeight.w500,
                    fontFamily: fontFamily,
                  )
              ),
              SizedBox(width: 4.w),
              Obx(() =>  Is_Login.value?Text(
                  referralFriendsPoints.value,
                  maxLines: 2,
                  style:
                  TextStyle(
                    fontSize: 14.sp,
                    color: HexColor("#333333"),
                    fontWeight: FontWeight.w700,
                    fontFamily: fontFamily,
                  )
              ):const SizedBox()),
            ],
          ),
          Obx(() =>SizedBox(height: referralCode.value!=null&&referralCode.value!=""?8.w:0)),
          Obx(() => Is_Login.value?referralCode.value!=null&&referralCode.value!=""?Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding:const  EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: HexColor("#F5F6FA"),
                      borderRadius:const  BorderRadius.only(topLeft:  Radius.circular(6),bottomLeft:  Radius.circular(6)),
                      border: Border.all(color: HexColor("#F5F6FA"),width: 1)

                  ),
                  child:
                  Text(
                      referralCode.value,
                      maxLines: 2,
                      style:
                      TextStyle(
                        fontSize: 12.sp,
                        color: HexColor("#333333"),
                        fontWeight: FontWeight.w600,
                        fontFamily: fontFamily,
                      )
                  )),
              // SizedBox(width: 8.w),
              GestureDetector(
                onTap: (){
                  copyToClipboard(contextCommon,referralCode.value);
                },
                child: Container(
                  padding:const  EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: DARK_BLUE,
                      borderRadius:const  BorderRadius.only(topRight: Radius.circular(6),bottomRight: Radius.circular(6))

                  ),
                  child: Text(
                      "Copy Code",
                      style:
                      TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.WHITE,
                        fontWeight: FontWeight.w700,
                        fontFamily: fontFamily,
                      )
                  ),
                ),
              ),
            ],
          ):const SizedBox():const SizedBox()),
          SizedBox(height: 12.w),
          OnLoginTapButton(
              height: 32.h,
              width: 135.w,
              onTap: (){
                if (cntDash.islogin.isTrue) {
                  WALunchUrl("whatsapp://send?&text=${Uri.encodeFull("${referralText.value} ${referralCode.value}")}");
                } else {
                  cntDash.LoginDialog();
                }
              },
              decoration: CustomDecorations()
                  .backgroundlocal(APP_THEME_COLOR, 6, 0, APP_THEME_COLOR),
              text: "REFER NOW",
              icon: Image.asset(WHATSAPP_IMAGES,height: 18.w,width: 18.h),
              style:
              TextStyle(color: AppColors.WHITE, fontSize: 10,fontFamily: fontFamily, fontWeight: FontWeight.w500)),
          SizedBox(height: 8.h),
          Text(
              lblReferDescriptionText,
              maxLines: 2,
              style:
              TextStyle(
                fontSize: 10.sp,
                color: HexColor("#707070"),
                fontWeight: FontWeight.w500,
                fontFamily: fontFamily,
              )
          ),
          SizedBox(height: 24.w),
          Material(
            elevation: 0,
            color: AppColors.WHITE,
            // color: AppColors.RED,
            borderRadius: BorderRadius.circular(10),
            child: ListView(
              padding:const  EdgeInsets.only(top: 0,bottom: 0),
              physics:const  NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                GestureDetector(
                  onTap: (){
                    if (cntDash.islogin.isTrue) {
                      Get.to(()=>RedeemPointPage());
                    } else {
                      cntDash.LoginDialog();
                    }

                  },
                  child: Container(
                      margin:const  EdgeInsets.only(
                          top: 0, left: 10, right: 10, bottom: 0),
                      padding:const  EdgeInsets.all(15),
                      decoration: BoxDecoration(color: HexColor("#F5F6FA"),
                          borderRadius: BorderRadius.circular(cornarradius)
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Text(

                                  lblRedeemYourPoint,
                                  maxLines: 2,
                                  style:
                                  TextStyle(
                                      fontSize: 10.sp,
                                      color: new_black_color,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: fontFamily,
                                      height: 1.3
                                  )
                              )),
                          const  SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                              onTap: () {
                                if (cntDash.islogin.isTrue) {
                                  Get.to(RedeemPointPage());
                                } else {
                                  cntDash.LoginDialog();
                                }
                              },
                              child: CommanContainer.arrowContainer(
                                NEWORANGE_COLOR, WHITE_COLOR,6)),
                        ],
                      )),
                ),
                wdBrands(),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    ):const SizedBox());
  }

  Widget wdBrands() {
    return Container(
        padding: const EdgeInsets.only(
          left: LEFT_PADDING,
          right: RIGHT_PADDING,
        ),
        child: Column(
          children: [
            brandData()
            //SizedBox(height: 20,)
          ],
        ));
  }
  Widget brandData(){
    return Obx(() {
      return FutureBuilder(
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            if(cntDash.arrRedeemPoints.isNotEmpty){
              return  GridView.builder(
                padding: const EdgeInsets.only(top: 15,bottom: 15),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 5,
                    crossAxisCount: 3,
                    childAspectRatio: 1.5),
                itemBuilder: (context, i) {
                  return _generateBrandCell1(i);
                },
                itemCount: cntDash.arrRedeemPoints.length,
              );
            }
            else{
              return Center(child:
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text(cntDash.IsRedeemPointEmpty.value,style:
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
        future: cntDash.futureRedeemPoint.value,
      );
    });
  }

  Widget _generateBrandCell1(int index) {
    Vouchers obj = cntDash.arrRedeemPoints[index];
    return GestureDetector(
      onTap: () {
        cntDash.OnRedeemBrangListForm(obj);
      },
      child: Container(
        height: 70,
        padding: const EdgeInsets.all(5),
        child:
        obj.image != null && obj.image!=""
            ? CachedNetworkImage(
          // width: Get.width-10,
          placeholder: (context, url) => ClipRRect(
            borderRadius: BorderRadius.circular(35),
            child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                enabled: true,
                child: shimmerWidget(height: 180, width: Get.width, radius: 0)),
          ),
          fadeInDuration: Duration.zero,
          fadeOutDuration: Duration.zero,
          placeholderFadeInDuration: Duration.zero,
          imageUrl: obj.image ?? "",
          fit: BoxFit.fill,
          errorWidget: (context, url, error) {
            return SvgPicture.network(
              obj.image ?? "",
              fit: BoxFit.fill,
            );
          },
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
    );
  }

  Widget wdFavouriteListData() {
    return Obx(() {
      return FutureBuilder(
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasError && snapshot.data!=null) {
            if (cntDash.arrfavProjectlist.isNotEmpty) {
              return
                Column(
                  children: [
                    Container(
                        padding: const EdgeInsets.only(left: 20, right: 20, top: 0  ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(lblFavorite,
                              style: TextStyle(color: gray_color_1, fontSize: 12.sp,fontWeight: FontWeight.w700),
                            ),
                            InkWell(
                              child: Text(
                                  lblViewmore.toUpperCase(),
                                  style: semiBoldTextStyle(
                                      fontSize: 11, txtColor: APP_THEME_COLOR,fontWeight: FontWeight.w600)
                              ),
                              onTap: () {
                                MoengageAnalyticsHandler().track_event(("favourite_list"));
                                Get.to(()=>const FavoritePage());
                              },
                            )
                          ],
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 190.w,
                      child: ListView.builder(
                          padding: const EdgeInsets.only(left: 20, right: 10),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: cntDash.arrfavProjectlist.length,
                          itemBuilder: (context, i) {
                            return _generateFavoriteProjectCell1(i);
                          }),
                    )
                  ],
                );

            } else {
              return Container();
            }
          } else {
            return favoriteProjectShimmerWidget();
          }
        },
        future: cntDash.futurearrfavprojectlist.value,
      );
    });

  }

  Widget _generateFavoriteProjectCell1(int index) {
    ProjectListModal objFavProject = cntDash.arrfavProjectlist[index];
    return
      cntDash.arrfavProjectlist.isNotEmpty?
      InkWell(
        onTap: () {
          MoengageAnalyticsHandler().SendAnalytics({"project_id" : objFavProject.sId, "project_name": objFavProject.projectname},"project_details");
          Get.to(() => ProjectDetails(projectid: objFavProject.sId.toString(),));
        },
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(right: index!=cntDash.arrfavProjectlist.length-1?10:10,left: index!=0?0:0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      width: 190.w, height: 142.w,
                      placeholder: (context, url) => shimmerWidget(width: 190.w, height: 142.h,radius: 10),
                      fadeInDuration: Duration.zero,
                      fadeOutDuration: Duration.zero,
                      placeholderFadeInDuration: Duration.zero,
                      imageUrl:  objFavProject.featureimg??"",
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) {
                        return SvgPicture.network(
                            objFavProject.featureimg??"",
                            width: 190.w, height: 142.w,fit: BoxFit.cover
                        );
                      },
                    ),
                  ),
                  Positioned(
                    right: 6,
                    top: 10,
                    child: GestureDetector(
                      onTap: (){
                        MoengageAnalyticsHandler().SendAnalytics({"project_id" : objFavProject.sId, "project_name": objFavProject.projectname},"project_unfavorite");
                        cntDash.RemoveFavouriteBottomSheet(index);
                      },
                      child: Container(
                          height: 35,
                          width: 35,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: HexColor("#FFFFFF").withOpacity(0.8),
                          ),
                          child: SvgPicture.asset(IMG_FAVORITE_SVG_2,
                            width: 24.h,
                            height: 24.w,
                          )

                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: 190.w,
                child: Text(
                  objFavProject.projectname??"",
                  maxLines: 2,
                  style: mediumTextStyle(fontSize: 14, txtColor: new_black_color,fontWeight: FontWeight.w500),
                  textAlign: TextAlign.left,
                ),
              ),

              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: 190.w,
                child: Text(
                  objFavProject.area??"",
                  maxLines: 2,
                  style: regularTextStyle(txtColor: gray_color_1, fontSize: 10,fontWeight: FontWeight.w400),
                  textAlign: TextAlign.left,
                ),
              )
            ],
          ),
        ),
      )
          :
      const SizedBox();
  }

  Widget wdBuySellWidget() {
    return Obx(() =>  cntDash.usertype.value!="3"?  Container(
      margin: const EdgeInsets.only(left: 20,right: 20, bottom: 0,top: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(cornarradius)),
          color: white,
          boxShadow: [fullcontainerboxShadow]
      ),
      height: 183,
      width: Get.width,
      clipBehavior: Clip.hardEdge,
      child: GestureDetector(
        onTap: (){
          Get.to(()=>const BuyAndSellPage());
        },
        child: CachedNetworkImage(
          placeholder: (context, url) =>  shimmerWidget(height: 183, width: Get.width, radius: 0),
          errorWidget: (context, url, error) {
            return Image.asset(buy_sell_rent_png,height: 183,width: Get.width,fit: BoxFit.fill,);
          },
          fadeInDuration: Duration.zero,
          fadeOutDuration: Duration.zero,
          placeholderFadeInDuration: Duration.zero,
          imageUrl: buy_sell_rent_png,
          fit: BoxFit.fill,
        ),
      ),
    ):const SizedBox());
  }

  // News List
  Widget wdNewsListData() {
    return Obx(() {
      return FutureBuilder(
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasError && snapshot.data!=null) {
            if (cntDash.arrNewsListnew.isNotEmpty) {
              return
                Column(
                  children: [
                    Container(
                        padding: const EdgeInsets.only(left: 20, right: 20, top: 24  ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(lblNews,
                              style: TextStyle(color: gray_color_1, fontSize: 12.sp,fontWeight: FontWeight.w700),
                            ),
                            InkWell(
                              child: Text(lblViewmore.toUpperCase(),
                                  style: semiBoldTextStyle(
                                      fontSize: 11, txtColor: APP_THEME_COLOR,fontWeight: FontWeight.w600)
                              ),
                              onTap: () {
                                MoengageAnalyticsHandler().track_event("news");
                                Get.to(()=>const NewsListPage());
                              },
                            )
                          ],
                        )),
                    SizedBox(
                      height: 10.h,
                    ),
                    // ProjectShimmerWidget(),
                    SizedBox(
                      height: 230.w,
                      child: ListView.builder(
                          padding: const EdgeInsets.only(left: 20, right: 10),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: cntDash.arrNewsListnew.isNotEmpty ? cntDash.arrNewsListnew.length : 0,
                          itemBuilder: (context, i) {
                            return Obx(() => _generateNewsListCell1(i));
                          }),
                    )
                  ],
                );

            } else {
              return Container();
            }
          } else {
            return newsListShimmerWidget();
          }
        },
        future: cntDash.futurenewsDatanew.value,
      );
    });

  }

  Widget _generateNewsListCell1(int index) {
    NewsListModal objNews = cntDash.arrNewsListnew[index];
    return
      cntDash.arrNewsListnew.isNotEmpty?
      // SizedBox()
      InkWell(
        onTap: () => cntDash.OnClickHandler(objNews),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(right: index!=cntDash.arrNewsListnew.length-1?10:10,left: index!=0?0:0),
          // width: 110,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      width: 300.w, height: 169.w,
                      fadeInDuration: Duration.zero,
                      fadeOutDuration: Duration.zero,
                      placeholderFadeInDuration: Duration.zero,
                      placeholder: (context, url) => shimmerWidget( width: 300.w, height: 169.h,radius: 10),
                      imageUrl:  objNews.newsimage??"",
                      fit: BoxFit.fill,
                      errorWidget: (context, url, error) {
                        return SvgPicture.network(
                            objNews.newsimage??"",
                            width: 300.w, height: 169.w,fit: BoxFit.fill
                          // height: 20, width: 20
                        );
                      },
                    ),
                  ),
                  objNews.newscategory!.isNotEmpty?Positioned(
                      top: 10,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.only(top: 6,bottom: 6,left: 8,right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: APP_FONT_COLOR.withOpacity(0.8),
                        ),
                        child: Center(
                          child: Text(
                            objNews.newscategory??"",
                            maxLines: 2,
                            style: mediumTextStyle(fontSize: 9, txtColor: white,fontWeight: FontWeight.w600),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      )):const SizedBox()
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Center(
                child: SizedBox(
                  width: 300.w,
                  child: Text(
                    capitalizeFirstLetter(objNews.title??""),
                    maxLines: 2,
                    style: mediumTextStyle(fontSize: 12, txtColor: new_black_color,fontWeight: FontWeight.w500),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Center(
                child: SizedBox(
                  width: 190.w,
                  child: Text(
                    objNews.newspublishdate!,
                    maxLines: 2,
                    style: regularTextStyle(txtColor: gray_color_1, fontSize: 10,fontWeight: FontWeight.w600),
                    textAlign: TextAlign.left,
                  ),
                ),
              )
            ],
          ),
        ),
      )
          : const SizedBox();
  }

  Widget wdBookASiteVisitData() {
    return Obx(() =>  cntDash.usertype.value!="3"?  AnimatedContainer(
      clipBehavior: Clip.hardEdge,
      curve: Curves.fastOutSlowIn,
      height: cntDash.openContainer.value == true ? 340.w : 1120.h,
      width: Get.width,
      margin: const EdgeInsets.only(left: 20, right:20, bottom: 35, top: 5),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: white,
          boxShadow: [fullcontainerboxShadow]
      ),
      duration: const Duration(milliseconds: 400),
      child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: bookSiteWidgetData()),
    ):const SizedBox());
  }

  Widget bookSiteWidgetData(){
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: 30.h),
          SvgPicture.asset(
            IMG_BOOK_A_SITE_SVG,
            height: 173.h,
            width: 173.w,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 12.w),
          SizedBox(
            width: 260,
            child: Text(
                lblBookASiteText,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: HexColor("#333333"),
                  fontWeight: FontWeight.w500,
                  fontFamily: fontFamily,
                )
            ),
          ),
          SizedBox(height: 20.w),

          OnBookSiteVisitButton(
              height: 32.w,
              width: 135.w,
              onTap: (){
                cntDash.openContainer.value = !cntDash.openContainer.value;
              },
              decoration: CustomDecorations()
                  .backgroundlocal(APP_THEME_COLOR, 6, 0, APP_THEME_COLOR),
              text: lblBookASiteText2,
              icon: Image.asset(cntDash.openContainer.value == true ?UP_ARROW_IMAGE:DOWN_ARROW_IMAGE,width: 12,height: 15,color: AppColors.WHITE),
              style: TextStyle(color : white, fontSize: 10.sp,fontFamily: fontFamily, fontWeight: FontWeight.w500)),

          cntDash.openContainer.value == true ? Container() : siteVisitTheme(false),
          SizedBox(height: 22.h),
          cntDash.openContainer.value == true ? Container() : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: submitButton(),
          )
        ],
      ),
    );
  }

  Widget siteVisitTheme([bool isShow=false]) {
    return Obx(() =>  Padding(
      padding:  const EdgeInsets.symmetric(horizontal: 8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 0, right: 0),
              child: Form(
                key: cntDash.formkey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    simpleTextFieldNewWithCustomization(
                      inputFormat: [
                        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                        UpperCaseTextFormatter()],
                      hintText: "John",
                      imageIcon: IMG_USER_SVG_NEW,
                      textCapitalization: TextCapitalization.sentences,
                      controller: cntScheduleSite.txtFirstNameNew,
                      textInputType: TextInputType.name,
                      labelText: "First Name*",
                      maxLength: 72,
                      noAutoValidation: true,
                      validator: (value) =>
                          validation(value, "Please enter first name"),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    simpleTextFieldNewWithCustomization(
                        hintText: "Doe",
                        inputFormat: [
                          FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                          UpperCaseTextFormatter()],
                        maxLength: 72,
                        noAutoValidation: true,
                        imageIcon: IMG_USER_SVG_NEW,
                        textCapitalization: TextCapitalization.sentences,
                        controller: cntScheduleSite.txtLastNameNew,
                        textInputType: TextInputType.name,
                        labelText: "Last Name*",
                        validator: (value) =>
                            validation(value, "Please enter last name")),
                    const SizedBox(height: 16,),
                    simpleTextFieldNewWithCustomization(
                        hintText: "johndoe@example.com",
                        imageIcon: IMG_EMAIL_SVG_NEW,
                        controller: cntScheduleSite.txtEmailNew,
                        textInputType: TextInputType.emailAddress,
                        labelText: "Email*",
                        noAutoValidation: true,
                        inputFormat: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z@.]")),
                        ],
                        validator: (value) => emailvalidation(value)),
                    const SizedBox(
                      height: 16,
                    ),
                    //ContactTextField(txtContactNew),
                    PhoneNumberTextField(cntScheduleSite.txtContactNew),
                    const SizedBox(
                      height: 16,
                    ),
                    CommonDropDownTextField(
                      labelText: "Project*",
                      onTap: () {
                        cntScheduleSite.SelectProject();
                      },
                      // imageIcon: IMG_PROJECT_SVG_DASHBOARD,
                      imageIcon: IMG_PROJECT_SVG_NEW,
                      controller: cntScheduleSite.txtProject,
                      hintText: cntScheduleSite.txtProject.text,
                    ),

                    const SizedBox(
                      height: 16,
                    ),
                    CommonDropDownTextField(
                      labelText: "Budget*",
                      onTap: () {
                        cntScheduleSite.SelectBudget();
                      },
                      // imageIcon: IMG_DOLLAR_SVG,
                      imageIcon: IMG_BUDGET_SVG_NEW,
                      controller: cntScheduleSite.txtBudget,
                      hintText: cntScheduleSite.arrBudgetList[0].toString(),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ScheduleSiteVisite(/*IMG_CALENDERDATE_SVG*/ IMG_DATE_SVG_NEW,
                        "Schedule Date*", "Select", cntScheduleSite.txtScheduleDateNew),
                    const SizedBox(
                      height: 16,
                    ),
                    // DropDownTime(IMG_CALENDAR, "Schedule Time*", "Select", txtscheduletime,),z
                    // DropDownTimeSelect(
                    //   /*IMG_TIME_SVG*/ IMG_TIME_SVG_NEW,
                    //   "Schedule Time*",
                    //   "Select",
                    //   cnt_ScheduleSite.txtScheduleTimeNew,
                    // ),
                    CommonDropDownTextField(
                        labelText: "Schedule Time*",
                        onTap: () {
                          selectTime_with_no2(contextCommon, 0, cntScheduleSite.txtScheduleTimeNew,);
                        },
                        // imageIcon: IMG_DOLLAR_SVG,
                        validator: (value) => validation(value, "Please select time"),
                        imageIcon: IMG_BUDGET_SVG_NEW,
                        controller: cntScheduleSite.txtScheduleTimeNew.value,
                        hintText: cntScheduleSite.txtScheduleTimeNew.value?.text==""?"Select Time":""
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    cntScheduleSite.QueryTextField_1(cntScheduleSite.txtQueryNew),
                    SizedBox(
                      height: isShow?40:0,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    ));
  }

  Widget submitButton() {
    return OnTapButton(
        onTap: () {
          MoengageAnalyticsHandler().track_event("schedule_a_site_visit");
          if (cntScheduleSite.formkey.currentState!.validate() ) {
            cntScheduleSite.ConfirmSiteVisiteCall();
          }
        },
        height: 40,
        decoration: CustomDecorations().backgroundlocal(APP_THEME_COLOR, cornarradius, 0, APP_THEME_COLOR),
        text: "Submit".toUpperCase(),
        style: TextStyle(color: white, fontSize: 12.sp, fontWeight: FontWeight.w500));
  }

  Widget wdAlreadyWorldHome() {
    return GestureDetector(
      onTap: () {
        if (cntDash.islogin.isTrue) {
          Get.to(()=>AddNewHomePage(title: ""));
        } else {
          cntDash.LoginDialog();
        }
      },
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Container(
              margin: const EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 25),
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 25),
              decoration: CustomDecorations().backgroundwithoutborder(NEWORANGE_COLOR, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Already ",
                              style: mediumTextStyle(fontSize: 13, txtColor: white),
                            ),
                            Text(
                              "World Home?",
                              style: boldTextStyle(fontSize: 13, txtColor: white),
                            ),
                          ]),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 220.h,
                            child: Text(
                                "Register and avail lots of benefits",
                                maxLines: 2,
                                style:
                                TextStyle(
                                    fontSize: 12.sp,
                                    color: white,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: fontFamily,height: 1.3
                                )
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Get.to(const ScheduleSitePage());
                        },
                        // child: CommanContainer.arrowContainer(WHITE, APP_FONT_COLOR)
                        child: Container(
                            height: 30,
                            width: 30,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.white),
                            child:
                            Center(child: SvgPicture.asset(IMG_RIGHTARROW_SVG_NEW,height: 10,width: 10,))
                        ),
                      ),
                    ],
                  ),
                ],
              )),
          Positioned(
              right: 15,
              bottom: -40,
              child: Image.asset(IMG_BACKGROUND_ELLIPSE,width: 137,height: 137,fit: BoxFit.cover,))
        ],
      ),
    );
  }

  Widget wdSmartHomeBuyer() {
    return  Obx(
            () => cntDash.arrSmartHomeBuyer.isNotEmpty ?
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Text(lblSmartHomeBuyer, style: TextStyle(color: gray_color_1, fontSize: 14,fontWeight: FontWeight.w600),
                    )),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
                height: 70,
                child: Obx(() => GridView.builder(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  // controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, childAspectRatio: 0.4),
                  itemBuilder: (context, i) {
                    return Obx(() =>  _generateSmartHomeBuyer(i));
                  },
                  itemCount: cntDash.arrSmartHomeBuyer.isNotEmpty ? cntDash.arrSmartHomeBuyer.length : 0,
                ))),
            const SizedBox(
              height: 20,
            ),
          ],
        )
            :const SizedBox()
    );
  }

  Widget _generateSmartHomeBuyer(int index) {
    MenuItemModel obj = cntDash.arrSmartHomeBuyer[index];
    return InkWell(
      onTap: () async{
        SharedPreferences sp = await SharedPreferences.getInstance();
        if(obj.alias==PROJECT_CHECKLIST){
          var url= sp.getString(PROJECT_CHECKLIST);
          await launchUrl(Uri.parse(url ?? ""),mode: LaunchMode.externalApplication);
        }
        else if(obj.alias==PLACE_ANALIYSIS){
          var url= sp.getString(PLACE_ANALIYSIS);
          await launchUrl(Uri.parse(url ?? ""),mode: LaunchMode.externalApplication);
        }
        else if(obj.alias==PLACE_AREA_CALCULATOR){
          var url= sp.getString(PLACE_AREA_CALCULATOR);
          await launchUrl(Uri.parse(url ?? ""),mode: LaunchMode.externalApplication);
        }
        else if(obj.alias==ONLINE_MEETING_SCHEDULE){
          var url= sp.getString(ONLINE_MEETING_SCHEDULE);
          await launchUrl(Uri.parse(url ?? ""),mode: LaunchMode.externalApplication);
        }
        else {

        }
      },
      child: SizedBox(
        width: 110,
        height: 50,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cornarradius),
          ),
          shadowColor: hex("266CB5").withOpacity(0.1),
          color: white,
          elevation: 1,
          clipBehavior: Clip.hardEdge,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                // height: 40,
                // width: 40,
                // margin: EdgeInsets.only(left: 10),
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                // padding: EdgeInsets.all(12),
                decoration:
                CustomDecorations().background(obj.color??"", 8, 0, obj.color??""),
                child: obj.icon.toString().contains("svg")
                    ? SvgPicture.network(
                  obj.icon??"",
                  height: 23,
                  // width: 24,
                  color: white,
                )
                    : Image.network(
                  obj.icon??"",
                  width: 24,
                  height: 24,
                  color: white,
                ),
              ),
              // SizedBox(
              //   width: 5,
              // ),
              SizedBox(
                width: 90,
                child: Text(
                  obj.name??"",
                  style:
                  mediumTextStyle(fontSize: 12, txtColor: BLACK),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(width: 10,)
            ],
          ),
        ),
      ),
    );
  }

  Widget otherMenuOption() {
    return  Obx(
            () => cntDash.arrOtherMenuOption.isNotEmpty ?
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Text(lblExtraFeature, style: TextStyle(color: gray_color_1, fontSize: 14,fontWeight: FontWeight.w600),
                    )),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
                height: 70,
                child: Obx(() => GridView.builder(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  // controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, childAspectRatio: 0.4),
                  itemBuilder: (context, i) {
                    return Obx(() =>  _generateOtherMenuOption(i));
                  },
                  itemCount: cntDash.arrOtherMenuOption.isNotEmpty ? cntDash.arrOtherMenuOption.length : 0,
                ))),
            const SizedBox(
              height: 20,
            ),
          ],
        )
            : const SizedBox()
    );
  }

  Widget _generateOtherMenuOption(int index) {
    MenuItemModel obj = cntDash.arrOtherMenuOption[index];
    return InkWell(
      onTap: () {
        print("${obj.alias} this is  alias");
        if (obj.alias != null) ClickHandler(obj.alias.toString(), 0);
      },
      child: SizedBox(
        width: 110,
        height: 50,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cornarradius),
          ),
          shadowColor: hex("266CB5").withOpacity(0.1),
          color: white,
          elevation: 1,
          clipBehavior: Clip.hardEdge,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                decoration:
                CustomDecorations().background(obj.color??"", 8, 0, obj.color??""),
                child: obj.icon.toString().contains("svg")
                    ? SvgPicture.network(
                  obj.icon??"",
                  height: 23,
                  color: white,
                )
                    : Image.network(
                  obj.icon??"",
                  width: 24,
                  height: 24,
                  color: white,
                ),
              ),
              // SizedBox(
              //   width: 5,
              // ),
              SizedBox(
                width: 90,
                child: Text(
                  obj.name??"",
                  style:
                  mediumTextStyle(fontSize: 12, txtColor: BLACK),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(width: 10,)
            ],
          ),
        ),
      ),
    );
  }

  Widget exploreMoreShimmerWidget() {
    return ShimmerEffect(
        child: Container(
            padding: const EdgeInsets.only(top: 0, left: 20, right: 0),
            child:     SizedBox(
                height: 210,
                child: GridView.builder(
                  // padding: EdgeInsets.only(left: 15, right: 15),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, childAspectRatio: 0.4),
                  itemBuilder: (context, i) {
                    return SizedBox(
                      width: 110,
                      height: 50,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(cornarradius),
                        ),
                        shadowColor: hex("266CB5").withOpacity(0.1),
                        color: APP_GRAY_COLOR,
                        elevation: 1,
                        clipBehavior: Clip.hardEdge,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                              // padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: APP_GRAY_COLOR,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: 10,
                ))));
  }

  Widget projectShimmerWidget() {
    return ShimmerEffect(
        child: Container(
            padding: const EdgeInsets.only(top: 0, left: 20, right: 0),
            child: SizedBox(
              height: 200,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: 6,
                  itemBuilder: (context, i) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(cornarradius),
                          ),
                          shadowColor: white,
                          color: white,
                          elevation: 5,
                          clipBehavior: Clip.hardEdge,
                          child: Container(
                            width: 100,
                            height: 90,
                            color: APP_GRAY_COLOR,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 90,
                          height: 15,
                          color: APP_GRAY_COLOR,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 80,
                          height: 15,
                          color: APP_GRAY_COLOR,
                        ),
                      ],
                    );
                  }),
            )));
  }

  Widget favoriteProjectShimmerWidget() {
    return ShimmerEffect(
        child: Container(
            padding: const EdgeInsets.only(left: 20, right: 10),
            child:SizedBox(
              height: 190.w,
              child: ListView.builder(
                // padding: EdgeInsets.only(left: 20, right: 10),
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemBuilder: (context, i) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(cornarradius),
                          ),
                          shadowColor: white,
                          color: white,
                          elevation: 5,
                          clipBehavior: Clip.hardEdge,
                          child: Container(
                            width: 192.h, height: 142.w,
                            color: APP_GRAY_COLOR,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: 90,
                          height: 15,
                          color: APP_GRAY_COLOR,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: 80,
                          height: 15,
                          color: APP_GRAY_COLOR,
                        ),
                      ],
                    );
                  }),
            )));
  }

  Widget redeemReferShimmerWidget() {
    return ShimmerEffect(
        child: Container(
          padding: const EdgeInsets.only(top: 0, left: 20, right: 20),
          margin: const EdgeInsets.only(left: 20, right: 20, top: 25, bottom: 20),
          width: Get.width,
          height: 156,
          decoration: BoxDecoration(
            color: APP_GRAY_COLOR,
            borderRadius: BorderRadius.all(Radius.circular(cornarradius)),
          ),

        ));
  }

  Widget newsListShimmerWidget() {
    return ShimmerEffect(
        child: Container(
            padding: const EdgeInsets.only(left: 20, right: 10),
            child:SizedBox(
              height: 230.h,
              child: ListView.builder(
                // padding: EdgeInsets.only(left: 20, right: 10),
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  itemBuilder: (context, i) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(cornarradius),
                          ),
                          shadowColor: white,
                          color: white,
                          elevation: 5,
                          clipBehavior: Clip.hardEdge,
                          child: Container(
                            width: 300.w, height: 169.h,
                            color: APP_GRAY_COLOR,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: 300.w,
                          height: 15,
                          color: APP_GRAY_COLOR,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: 200.w,
                          height: 15,
                          color: APP_GRAY_COLOR,
                        ),
                      ],
                    );
                  }),
            )));
  }

}
