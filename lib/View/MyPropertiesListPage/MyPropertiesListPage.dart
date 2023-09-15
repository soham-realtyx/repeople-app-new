
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Model/AddProperty/MyPropertyModel.dart';
import 'package:Repeople/View/DashboardPage/BottomnavigationBar.dart';
import 'package:Repeople/View/ProjectListPage/AddNewHomePage.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/Helper/MoengageAnalyticsHandler.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:Repeople/Controller/MyPropertiesController/MyPropertiesController.dart';
import 'package:Repeople/View/MyPropertiesDetailsPage/MyPropertiesDetailsPage.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:Repeople/Widgets/ShimmerWidget.dart';

class MyPropertiesListPage extends StatefulWidget {
  String projectid;
  MyPropertiesListPage({required this.projectid});

  @override
  _MyPropertiesListPageState createState() => _MyPropertiesListPageState();
}

class _MyPropertiesListPageState extends State<MyPropertiesListPage> {
  MyPropertiesController cnt_Myproperties = Get.put(MyPropertiesController());
  CommonHeaderController cnt_HeaderController =
  Get.put(CommonHeaderController());
  GlobalKey<ScaffoldState> GlobalMyPropertiesListPagekey =
  GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    cnt_Myproperties.futurearrMyPropertiesList.value=cnt_Myproperties.RetrieveMyPropertyListData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.BACKGROUND_WHITE,
      key: GlobalMyPropertiesListPagekey,
      endDrawer: CustomDrawer(
        animatedOffset: Offset(1.0, 0),
      ),
      drawer: CustomDrawer(
        animatedOffset: Offset(-1.0, 0),
      ),
      body: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 70),
                  MyPropertiesListData(),
                  SizedBox(height: 20),
                  AddNewPropertiesButton_1(),
                  SizedBox(height: 80),
                ],
              ),
            ),
            cnt_HeaderController.commonAppBar("My Properties",
                GlobalMyPropertiesListPagekey),
            Align(
              alignment: Alignment.bottomCenter,
              child: BottomNavigationBarClass(),
            )
          ],
        ),
      ),
    );
  }

  Widget MyPropertiesListData() {
    return Obx(() {
      return FutureBuilder(
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasError &&
              snapshot.data != null) {
            if (cnt_Myproperties.arrMyPropertiesList.isNotEmpty) {
              return ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: cnt_Myproperties.arrMyPropertiesList.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return Obx(() =>  _MyPropertiesData(index));
                },
              );
            } else {
              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10.h),
                    SvgPicture.asset(
                      IMG_MYPROPERTIES_HOUSE_SVG,
                      width: 173.w,
                      height: 170.h,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      "No properties linked yet.",
                      style: mediumTextStyle(
                          fontSize: 12, txtColor: new_black_color),
                    ),
                    SizedBox(height: 10.h),
                    SizedBox(
                        width: 250,
                        child: Center(
                          child: Text(
                            "Click below and link your current properties to manage.",
                            textAlign: TextAlign.center,
                            style: mediumTextStyle(
                                fontSize: 12, txtColor: new_black_color),
                          ),
                        )),
                    SizedBox(height: 20.h),
                    // AddNewPropertiesButton_1()
                  ],
                ),
              );
            }
          } else {
            return MypropertiesListShimmerWidget();
          }
        },
        future: cnt_Myproperties.futurearrMyPropertiesList.value,
      );
    });
  }

  Widget _MyPropertiesData(int index) {
    MyPropertyList obj_MypropertiesList =
    cnt_Myproperties.arrMyPropertiesList[index];
    return GestureDetector(
      onTap: () {
        MoengageAnalyticsHandler().SendAnalytics({"properties_id":obj_MypropertiesList.projectid??"","properties_name":obj_MypropertiesList.project??""}, "properties_details");
        Get.to(()=>MyPropertiesDetailsPage(projectId: obj_MypropertiesList.projectid??"",inventoryType: obj_MypropertiesList.inventorytype,inventoryTypeId: obj_MypropertiesList.inventorytypeid,));
      },
      child: Container(
        height: 287.w,
        width: Get.width,
        margin: EdgeInsets.only(bottom: 20),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 211.w,
                width: Get.width,
                color: AppColors.APP_BLACK_38,
                child: CarouselSlider.builder(
                  //carouselController: cnt_Myproperties.controller_propertiesList,
                  itemCount:
                  obj_MypropertiesList.gallery!=null && obj_MypropertiesList.gallery!.gallaryListdata!=null && obj_MypropertiesList.gallery!.gallaryListdata!.isNotEmpty?
                  obj_MypropertiesList.gallery!.gallaryListdata!.length:0,
                  itemBuilder: (context, index2, realIndex) {
                    if(obj_MypropertiesList.gallery!=null && obj_MypropertiesList.gallery!.gallaryListdata!=null && obj_MypropertiesList.gallery!.gallaryListdata!.isNotEmpty)
                      return InkWell(
                        onTap: () {
                          // Get.to(FullImageViewPage(
                          //     list: projectsliderimages, index: index));
                        },
                        child: ClipRRect(
                            child: CachedNetworkImage(
                              height: 211.w,
                              width: Get.width,
                              placeholder: (context, url) => shimmerWidget(
                                height: 211.w,
                                width: Get.width,
                              ),
                              fadeInDuration: Duration.zero,
                              fadeOutDuration: Duration.zero,
                              placeholderFadeInDuration: Duration.zero,
                              imageUrl:
                              obj_MypropertiesList.gallery?.gallaryListdata?[index2].icon.toString() ?? "",
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) {
                                return Image.asset(
                                  IMG_BUILD4,
                                  width: Get.width,
                                  fit: BoxFit.cover,
                                );
                              },
                            )),
                      );
                    else return SizedBox.shrink();
                  },
                  options: CarouselOptions(
                      autoPlay: true,
                      height: 211.w,
                      viewportFraction: 1,
                      onPageChanged: (index, _) {
                        cnt_Myproperties.current.value = index;
                        cnt_Myproperties.current.refresh();
                      }),
                ),
                //Image.asset(BUILDING_IMAGE, fit: BoxFit.cover),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Stack(
                children: [
                  Container(
                    height: 211.w,
                    width: Get.width,
                    color: DARK_BLUE.withOpacity(0.5),
                    child: Center(
                      child: Text(
                          obj_MypropertiesList.unitroletype ?? "",
                          style: boldTextStyle(
                              fontSize: 20,
                              txtColor: white)),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Stack(
                      // alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          width: Get.width,
                          height: 100.w,
                          margin: EdgeInsets.only(left: 20,right: 20),
                          padding: EdgeInsets.only(
                              top: 8.w, bottom: 8.w, right: 8.w, left: 8.w),
                          decoration: CustomDecorations()
                              .backgroundlocal(white, 10, 0, white),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // if(obj_MypropertiesList.logosvg!=null)
                                  Container(
                                    color: BACKGROUNG_GREYISH,
                                    child:
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child:
                                      // Image.network(obj_MypropertiesList.featureimg??"")

                                      CachedNetworkImage(
                                        width: 84.w, height: 84.w,
                                        placeholder: (context, url) => shimmerWidget(  width: 90, height: 85,radius:8 ),
                                        fadeInDuration: Duration.zero,
                                        fadeOutDuration: Duration.zero,
                                        placeholderFadeInDuration: Duration.zero,
                                        imageUrl:  obj_MypropertiesList.featureimg??"",
                                        fit: BoxFit.fill,
                                        errorWidget: (context, url, error) {
                                          return SvgPicture.network(
                                              obj_MypropertiesList.featureimg??"",
                                              width: 84.w, height: 85.w, fit: BoxFit.fill
                                            // height: 20, width: 20
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.h,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      if(obj_MypropertiesList.inventorytypeid=="1")
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text("${obj_MypropertiesList.plot?.replaceAll(" ", "")}${","}",
                                                style: boldTextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    txtColor: new_black_color)),
                                            SizedBox(
                                              height: 2.w,
                                            ),
                                            Text(
                                                obj_MypropertiesList.inventorytype??"",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12.sp,
                                                    fontFamily: fontFamily,
                                                    color: new_black_color)),
                                          ],
                                        ),
                                      if(obj_MypropertiesList.inventorytypeid=="2")
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text("${obj_MypropertiesList.villa?.replaceAll(" ", "")}${","}",
                                                style: boldTextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    txtColor: new_black_color)),
                                            SizedBox(
                                              width: 2.w,
                                            ),
                                            Text(
                                                obj_MypropertiesList.inventorytype??"",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12.sp,
                                                    fontFamily: fontFamily,
                                                    color: new_black_color)),
                                          ],
                                        ),

                                      if(obj_MypropertiesList.inventorytypeid=="3")
                                        Column(
                                          crossAxisAlignment:  CrossAxisAlignment.start,
                                          children: [
                                            Text(obj_MypropertiesList.unit.toString().replaceAll(" ", ""),
                                                style: boldTextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    txtColor: DARK_BLUE)),
                                            SizedBox(
                                              height: 5.h,
                                            ),
                                            Text(
                                                obj_MypropertiesList.floor??"",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12.sp,
                                                    fontFamily: fontFamily,
                                                    color: new_black_color)),
                                          ],
                                        ),

                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Text(
                                          obj_MypropertiesList.project??"",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12.sp,
                                              fontFamily: fontFamily,
                                              color: new_black_color)),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      Text(obj_MypropertiesList.area ?? "",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12.sp,
                                              fontFamily: fontFamily,
                                              color: new_black_color)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                            top: 8.h,
                            right: 30.w,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: DARK_BLUE),
                                child: Text("3BHK",
                                    style: semiBoldTextStyle(
                                        fontSize: 10, txtColor: white)),
                              ),
                            ))
                      ],
                    ),
                  )

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget AddNewPropertiesButton_1() {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 20.0),
      child: OnTapButton(
          onTap: () {
            Get.to(AddNewHomePage(title: "",));
            MoengageAnalyticsHandler().track_event("add_new_property_page");
          },
          height: 40,
          decoration: CustomDecorations()
              .backgroundlocal(APP_THEME_COLOR, cornarradius, 6, APP_THEME_COLOR),
          text: "Add New Property".toUpperCase(),
          style: TextStyle(
              color: white,
              fontSize: 12.sp,
              fontFamily: fontFamily,
              fontWeight: FontWeight.w500)),
    );
  }

  Widget MypropertiesListShimmerWidget() {
    return ShimmerEffect(
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),

        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: 4,
          itemBuilder: (context, i) {
            return Container(
              margin: EdgeInsets.only(bottom: 14),
              height: 200.w,
              width: Get.width,
              decoration: BoxDecoration(
                  color: APP_GRAY_COLOR,
                  borderRadius: BorderRadius.circular(10)
              ),
            );
          },
        ),
      ),
    );
  }
}
