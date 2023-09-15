import 'dart:async';

import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/View/DashboardPage/BottomnavigationBar.dart';
import 'package:Repeople/View/FullImageViewPage/FullImageViewPage.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Helper/MoengageAnalyticsHandler.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:Repeople/Controller/MyPropertiesController/MyPropertiesController.dart';
import 'package:Repeople/Model/MyPropertiesModel/MyPropertiesModel.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:Repeople/Widgets/ShimmerWidget.dart';

class MyPropertiesDetailsPage extends StatefulWidget {
  final String projectId;
  final String? inventoryType;
  final String? inventoryTypeId;

  final String? plotId;
  final String? villaId;
  final String? buildingId;

  const MyPropertiesDetailsPage({super.key,
    required this.projectId,
    this.inventoryType,
    this.inventoryTypeId,
    this.buildingId,
    this.plotId,
    this.villaId
  });

  @override
  _MyPropertiesDetailsPageState createState() =>
      _MyPropertiesDetailsPageState();
}

class _MyPropertiesDetailsPageState extends State<MyPropertiesDetailsPage> {
  MyPropertiesController cntMyProperties = Get.put(MyPropertiesController());
  CommonHeaderController cntHeaderController =
      Get.put(CommonHeaderController());
  late final ScrollController? controller = ScrollController();
  RxBool isVal = false.obs;
  late StreamSubscription<bool> keyboardSubscription;
  GlobalKey<ScaffoldState> globalScheduleSiteVisitKey =
      GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    cntMyProperties.projectID.value=widget.projectId;
    cntMyProperties.inventoryType.value=widget.inventoryType??"";
    cntMyProperties.inventoryTypeId.value=widget.inventoryTypeId??"";
    cntMyProperties.buildingId.value=widget.buildingId??"";
    cntMyProperties.plotId.value=widget.plotId??"";
    cntMyProperties.villaId.value=widget.villaId??"";

    cntMyProperties.futurearrPropertiesDetailsList.value =
        cntMyProperties.retrievePropertiesDetails();

    cntMyProperties.futureDocMainData.value=  cntMyProperties.retrieveMainDocumentListData().whenComplete(() {
      cntMyProperties.futureDocCategoryMainData.value=cntMyProperties.retrieveDocumentListData().whenComplete((){
        // cntMyProperties.RetrieveDocumentSubListData( id: '', name: '', categoryid: '');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.BACKGROUND_WHITE,
      key: cntMyProperties.GlobalMyPropertiesPagekey,
      endDrawer: CustomDrawer(
        animatedOffset: const Offset(1.0, 0),
      ),
      drawer: CustomDrawer(
        animatedOffset: const Offset(-1.0, 0),
      ),
      body: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    myPropertiesListData(),
                    SizedBox(height: 20.h),
                    _liveChatData(),
                    SizedBox(height: 20.h),
                    myPropertiesExploreMore(),
                    SizedBox(height: 20.h),
                    myPropertiesSiteListData(),
                    const SizedBox(height: 100),
                  ],
                )),
        cntHeaderController.commonAppBar(
        "My Properties", cntMyProperties.GlobalMyPropertiesPagekey),
            Align(
              alignment: Alignment.bottomCenter,
              child: BottomNavigationBarClass(),
            )
          ],
        ),
      ),
    );
  }

  Widget myPropertiesListData() {
    return Obx(() {
      return FutureBuilder(
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasError &&
              snapshot.data != null) {
            if (cntMyProperties.arrPropertiesDetailsList.isNotEmpty) {
              return Column(
                children: [
                  const SizedBox(height: 70),
                  myPropertiesHeaderData(),
                ],
              );
            } else {
              return Column(
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
              );
            }
          } else {
            return myPropertiesListShimmerWidget();
          }
        },
        future: cntMyProperties.futurearrPropertiesDetailsList.value,
      );
    });
  }

  Widget myPropertiesHeaderData() {
    return Stack(
      children: [
        Obx(() => Container(
              height: 287.w,
              width: Get.width,
              margin: const EdgeInsets.only(bottom: 0),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                        height: 211.w,
                        width: Get.width,
                        color: AppColors.APP_BLACK_38,
                        child: Obx(
                          () => CarouselSlider.builder(
                            carouselController:
                                cntMyProperties.controller_propertiesDetail,
                            itemCount: cntMyProperties
                                        .arrPropertiesDetailsList.isNotEmpty &&
                                    cntMyProperties.arrPropertiesDetailsList[0]
                                            .gallery !=
                                        null &&
                                    cntMyProperties.arrPropertiesDetailsList[0]
                                            .gallery!.galleryListdata !=
                                        null &&
                                    cntMyProperties.arrPropertiesDetailsList[0]
                                        .gallery!.galleryListdata!.isNotEmpty
                                ? cntMyProperties.arrPropertiesDetailsList[0]
                                    .gallery!.galleryListdata!.length
                                : 0,
                            itemBuilder: (context, index2, realIndex) {
                              return GestureDetector(
                                onTap: () {
                                  Get.to(
                                    FullImageViewPage(
                                        list: cntMyProperties.galleryList,
                                        index: index2),
                                  );
                                },
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
                                  imageUrl: cntMyProperties
                                          .arrPropertiesDetailsList[0]
                                          .gallery
                                          ?.galleryListdata?[index2]
                                          .icon
                                          .toString() ??
                                      "",
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) {
                                    return Image.network(
                                      cntMyProperties
                                              .arrPropertiesDetailsList[0]
                                              .gallery
                                              ?.galleryListdata?[index2]
                                              .icon
                                              .toString() ??
                                          "",
                                      width: Get.width,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              );
                            },
                            options: CarouselOptions(
                                autoPlay: true,
                                height: 211.w,
                                viewportFraction: 1,
                                onPageChanged: (index, _) {
                                  cntMyProperties.current.value = index;
                                  cntMyProperties.current.refresh();
                                }),
                          ),
                        )
                        //Image.asset(BUILDING_IMAGE,fit: BoxFit.cover),
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
                                cntMyProperties
                                    .arrPropertiesDetailsList[0].unitroletype
                                    .toString(),
                                style: boldTextStyle(
                                    fontSize: 20, txtColor: white)),
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
                                margin:
                                    const EdgeInsets.only(left: 20, right: 20),
                                padding: EdgeInsets.only(
                                    top: 8.w,
                                    bottom: 8.w,
                                    right: 8.w,
                                    left: 8.w),
                                decoration: CustomDecorations()
                                    .backgroundlocal(white, 10, 0, white),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          color: BACKGROUNG_GREYISH,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: CachedNetworkImage(
                                              width: 84.w,
                                              height: 84.w,
                                              placeholder: (context, url) =>
                                                  shimmerWidget(
                                                      width: 90,
                                                      height: 85,
                                                      radius: 8),
                                              fadeInDuration: Duration.zero,
                                              fadeOutDuration: Duration.zero,
                                              placeholderFadeInDuration:
                                                  Duration.zero,
                                              imageUrl: cntMyProperties
                                                      .arrPropertiesDetailsList
                                                      .isNotEmpty
                                                  ? cntMyProperties
                                                          .arrPropertiesDetailsList[
                                                              0]
                                                          .featureimg ??
                                                      ""
                                                  : "",
                                              fit: BoxFit.fill,
                                              errorWidget:
                                                  (context, url, error) {
                                                return SvgPicture.network(
                                                    cntMyProperties
                                                            .arrPropertiesDetailsList
                                                            .isNotEmpty
                                                        ? cntMyProperties
                                                                .arrPropertiesDetailsList[
                                                                    0]
                                                                .featureimg ??
                                                            ""
                                                        : "",
                                                    width: 84.w,
                                                    height: 85.w,
                                                    fit: BoxFit.fill
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
                                            if (cntMyProperties
                                                    .arrPropertiesDetailsList[0]
                                                    .inventorytypeid ==
                                                "1")
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      "${cntMyProperties.arrPropertiesDetailsList[0].plot?.replaceAll(" ", "")}${","}",
                                                      style: boldTextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          txtColor:
                                                              new_black_color)),
                                                  SizedBox(
                                                    height: 2.w,
                                                  ),
                                                  Text(
                                                      cntMyProperties
                                                              .arrPropertiesDetailsList[
                                                                  0]
                                                              .inventorytype ??
                                                          "",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 12.sp,
                                                          fontFamily:
                                                              fontFamily,
                                                          color:
                                                              new_black_color)),
                                                ],
                                              ),
                                            if (cntMyProperties
                                                    .arrPropertiesDetailsList[0]
                                                    .inventorytypeid ==
                                                "2")
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      "${cntMyProperties.arrPropertiesDetailsList[0].villa?.replaceAll(" ", "")}${","}",
                                                      style: boldTextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          txtColor:
                                                              new_black_color)),
                                                  SizedBox(
                                                    width: 2.w,
                                                  ),
                                                  Text(
                                                      cntMyProperties
                                                              .arrPropertiesDetailsList[
                                                                  0]
                                                              .inventorytype ??
                                                          "",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 12.sp,
                                                          fontFamily:
                                                              fontFamily,
                                                          color:
                                                              new_black_color)),
                                                ],
                                              ),
                                            if (cntMyProperties
                                                    .arrPropertiesDetailsList[0]
                                                    .inventorytypeid ==
                                                "3")
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      cntMyProperties
                                                          .arrPropertiesDetailsList[
                                                              0]
                                                          .unit
                                                          .toString()
                                                          .replaceAll(" ", ""),
                                                      style: boldTextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          txtColor: DARK_BLUE)),
                                                  SizedBox(
                                                    height: 5.h,
                                                  ),
                                                  Text(
                                                      cntMyProperties
                                                              .arrPropertiesDetailsList[
                                                                  0]
                                                              .floor ??
                                                          "",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 12.sp,
                                                          fontFamily:
                                                              fontFamily,
                                                          color:
                                                              new_black_color)),
                                                ],
                                              ),
                                            SizedBox(
                                              height: 5.h,
                                            ),
                                            Text(
                                                cntMyProperties
                                                        .arrPropertiesDetailsList[
                                                            0]
                                                        .project ??
                                                    "",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 12.sp,
                                                    fontFamily: fontFamily,
                                                    color: new_black_color)),
                                            SizedBox(
                                              height: 2.h,
                                            ),
                                            Text(
                                                cntMyProperties
                                                        .arrPropertiesDetailsList[
                                                            0]
                                                        .area ??
                                                    "",
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
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 4),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
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
            )),
      ],
    );
  }

  Widget myPropertiesExploreMore() {
    return Obx(() {
      return FutureBuilder(
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasError &&
              snapshot.data != null) {
            if (cntMyProperties.arrMyPropertiesMore.isNotEmpty) {
              return Column(
                children: [
                  Obx(() => GridView.builder(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        // controller: scrollController,
                        physics: const BouncingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12.w,
                            crossAxisSpacing: 12.h,
                            childAspectRatio: 2.8),
                        itemBuilder: (context, i) {
                          return Obx(() => _generateMyPropertiesExploreMore(i));
                        },
                        itemCount:
                            cntMyProperties.arrMyPropertiesMore.isNotEmpty
                                ? cntMyProperties.arrMyPropertiesMore.length
                                : 0,
                      ))
                ],
              );
            } else {
              return Container();
            }
          } else {
            return exploreMoreShimmerWidget();
          }
        },
        future: cntMyProperties.futurearrexploremorelist.value,
      );
    });
  }

  Widget _generateMyPropertiesExploreMore(int index) {
    MyPropertiesModel objMyProperties =
        cntMyProperties.arrMyPropertiesMore[index];
    return GestureDetector(
      onTap: objMyProperties.onTap ?? () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: white,
          boxShadow: [
            BoxShadow(
              color: BLACK.withOpacity(0.05),
              // spreadRadius: 0,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(8.w),
                padding: EdgeInsets.only(
                    left: 8.w, right: 8.w, top: 8.w, bottom: 8.w),
                decoration: BoxDecoration(
                    color: objMyProperties.color ?? white,
                    borderRadius: BorderRadius.circular(6)),
                child: SvgPicture.asset(
                  objMyProperties.icon ?? "",
                  height: 24.w,
                  width: 24.w,
                  color: white,
                )),
            SizedBox(
              width: 95,
              child: Text(
                objMyProperties.title ?? "",
                style: mediumTextStyle(
                    fontSize: 12,
                    txtColor: new_black_color,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _liveChatData() {
    return GestureDetector(
      onTap: () {
        MoengageAnalyticsHandler().track_event("live_chat");
      },
      child: Container(
        height: 136.w,
        width: Get.width,
        padding: const EdgeInsets.only(right: 24, top: 20, left: 24),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              // spreadRadius: 5,
              blurRadius: 6,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SvgPicture.asset(LIVE_CHAT_SVG_IMG,
                width: 109.w, height: 112.w, fit: BoxFit.cover),
            SizedBox(width: 20.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Live Chat",
                      style: TextStyle(
                          color: DARK_BLUE,
                          fontWeight: FontWeight.w700,
                          fontFamily: fontFamily,
                          fontSize: 16.sp),
                    ),
                    SizedBox(height: 12.h),
                    SizedBox(
                        width: 130.w,
                        child: Text(
                          "Customer Support How may we help you?",
                          style: TextStyle(
                              color: new_black_color,
                              fontWeight: FontWeight.w400,
                              fontFamily: fontFamily,
                              fontSize: 11.sp),
                        )),
                    SizedBox(height: 12.h),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 9.w, vertical: 6.h),
                      decoration: BoxDecoration(
                          color: DARK_BLUE,
                          borderRadius: BorderRadius.circular(6)),
                      child: SvgPicture.asset(RIGHT_ARROW_SVG_IMG),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget myPropertiesSiteListData() {
    return Obx(() {
      return FutureBuilder(
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasError &&
              snapshot.data != null) {
            if (cntMyProperties.arrPropertiesDetailsList[0].siteProgress !=
                null) {
              return _myPropertiesSiteProgress();
            } else {
              return Container();
            }
          } else {
            return siteProgressListShimmerWidget();
          }
        },
        future: cntMyProperties.futurearrPropertiesDetailsList.value,
      );
    });
  }

  Widget _myPropertiesSiteProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          child: Row(
            children: [
              Text("Site Progress",
                  style: TextStyle(
                      color: gray_color_1,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700)),
              SizedBox(width: 10.w),
              Expanded(
                child: Container(
                  height: 1.h,
                  width: Get.width,
                  color: BORDER_GREY,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        SizedBox(
          height: 140.w,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 20.h, right: 10.h),
            physics: const ScrollPhysics(),
            itemCount: cntMyProperties.arrPropertiesDetailsList[0].siteProgress
                        ?.SiteProgressListdata?.length !=
                    0
                ? cntMyProperties.arrPropertiesDetailsList[0].siteProgress
                    ?.SiteProgressListdata?.length
                : 0,
            itemBuilder: (context, index) {
              return _siteProgressData(index);
            },
          ),
        ),
      ],
    );
  }

  Widget _siteProgressData(int index) {
    return Container(
      margin: EdgeInsets.only(right: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            focusColor: AppColors.TRANSPARENT,
            highlightColor: AppColors.TRANSPARENT,
            hoverColor: AppColors.TRANSPARENT,
            splashColor: AppColors.TRANSPARENT,
            onTap: () {
              Get.to(
                FullImageViewPage(
                    list: cntMyProperties.siteProgressList, index: index),
              );
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: CachedNetworkImage(
                    width: 190.w,
                    height: 107.w,
                    placeholder: (context, url) => shimmerWidget(
                        width: 190.w,
                        height: 107.w,
                        radius: 7,
                        color: APP_GRAY_COLOR),
                    fadeInDuration: Duration.zero,
                    fadeOutDuration: Duration.zero,
                    placeholderFadeInDuration: Duration.zero,
                    imageUrl: cntMyProperties.arrPropertiesDetailsList[0]
                            .siteProgress?.SiteProgressListdata?[index].icon ??
                        "",
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) {
                      return SvgPicture.network(
                        cntMyProperties.arrPropertiesDetailsList[0].siteProgress
                                ?.SiteProgressListdata?[index].icon ??
                            "",
                        width: 190.w,
                        height: 107.w,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                Positioned(
                    left: 8.w,
                    bottom: 10.h,
                    child: Container(
                      padding: EdgeInsets.all(6.h),
                      decoration: BoxDecoration(
                          color: BLACK.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        cntMyProperties.arrPropertiesDetailsList[0].siteProgress
                                ?.SiteProgressListdata?[index].monthyear ??
                            "",
                        style: TextStyle(
                            fontFamily: fontFamily,
                            color: white,
                            fontWeight: FontWeight.w600,
                            fontSize: 9.sp),
                      ),
                    ))
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 180.w,
            child: Text(
              cntMyProperties.arrPropertiesDetailsList[0].siteProgress
                      ?.SiteProgressListdata?[index].sitename ??
                  "",
              style: TextStyle(
                  fontFamily: fontFamily,
                  color: new_black_color,
                  fontWeight: FontWeight.w400,
                  fontSize: 10.sp),
            ),
          )
        ],
      ),
    );
  }

  Widget exploreMoreShimmerWidget() {
    return ShimmerEffect(
      child: Container(
        padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12.w,
              crossAxisSpacing: 12.h,
              childAspectRatio: 2.8),
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
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 10),
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
        ),
      ),
    );
  }

  Widget myPropertiesListShimmerWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 70),
          // shimmerWidget(color: APP_GRAY_COLOR,height: 50,radius: 10,width: Get.width),

          ShimmerEffect(
            child: Container(
              height: 211.w,
              width: Get.width,
              decoration: BoxDecoration(
                  color: APP_GRAY_COLOR,
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }

  Widget siteProgressListShimmerWidget() {
    return SizedBox(
      height: 140.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 20.h, right: 10.h),
        physics: const ScrollPhysics(),
        itemCount: 4,
        itemBuilder: (context, index) {
          return ShimmerEffect(
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              height: 140.h,
              width: 191.w,
              decoration: BoxDecoration(
                  color: APP_GRAY_COLOR,
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
        },
      ),
    );
  }
}
