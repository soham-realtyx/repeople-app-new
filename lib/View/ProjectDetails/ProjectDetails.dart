import 'dart:async';

import 'package:Repeople/Config/Helper/DownloadFile.dart';
import 'package:Repeople/Config/Helper/HextoColor.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Controller/ProjectDetailsController/ProjectDetailsController.dart';
import 'package:Repeople/Controller/ScheduleSiteController/ScheduleVisitController.dart';
import 'package:Repeople/Model/ProjectDetails/ProjectDetailsModal.dart';
import 'package:Repeople/View/DashboardPage/BottomnavigationBar.dart';
import 'package:Repeople/View/FullImageViewPage/FullImageViewPage.dart';
import 'package:Repeople/View/ProjectGalleryScreen/ProjectGalleryScreen.dart';
import 'package:Repeople/Widgets/CommomBottomSheet.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:Repeople/Widgets/ShimmerWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Helper/MoengageAnalyticsHandler.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProjectDetails extends StatefulWidget {
  final String projectid;
  ProjectDetails({required this.projectid});

  @override
  _ProjectDetailsState createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {
  ProjectDetailsController cntProjectDetails =
      Get.put(ProjectDetailsController());
  CommonHeaderController cntHeaderController =
      Get.put(CommonHeaderController());
  ScheduleSiteController cntScheduleSite = Get.put(ScheduleSiteController());
  late final ScrollController? controller = ScrollController();
  RxBool isVal = false.obs;
  late StreamSubscription<bool> keyboardSubscription;
  GlobalKey<ScaffoldState> globalScheduleSiteVisitKey =
      GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    cntProjectDetails.ProjectId.value = widget.projectid;
    BottomNavigationBarClass().selectedIndex=1;
    var keyboardVisibilityController = KeyboardVisibilityController();
    // Query
    print(
        'Keyboard visibility direct query: ${keyboardVisibilityController.isVisible}');
    // Subscribe
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      print('Keyboard visibility update. Is visible: $visible');
      cntProjectDetails.KeyBoardVisblity.value = visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.BACKGROUND_WHITE,
      key: cntProjectDetails.GlobalProjectDetailsPagekey,
      endDrawer: CustomDrawer(
        animatedOffset: const Offset(1.0, 0),
      ),
      drawer: CustomDrawer(
        animatedOffset: const Offset(1.0, 0),
      ),
      body: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Obx(() => SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 70),
                      detailsTitleHeader(),
                      projectDetailsBlockHeader(),
                      projectDescHeader(),
                      // cnt_ProjectDetails.Link_Download_Header_1(),
                      overviewSection(),
                      connectivityData1(),
                      gallerySection(),
                      locationSection(),
                      amenitiesSection(),
                      // Highlight_section(),
                      siteProgressSection(),
                      planLayoutSection(),
                      siteVisitSection(),
                    ],
                  ),
                )),
            cntHeaderController.commonAppBar(
                "", cntProjectDetails.GlobalProjectDetailsPagekey,
                isNotificationHide: true),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBarClass(),
    );
  }

  Widget detailsTitleHeader() {
    return FutureBuilder(
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return Stack(
            children: [
              if (cntProjectDetails
                      .obj_svprojectdetails.value.gallery?.gallerydata !=
                  null)
                SizedBox(
                  height: 346.w,
                  width: Get.width,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: CarouselSlider.builder(
                          carouselController:
                              cntProjectDetails.controller_event,
                          itemCount: cntProjectDetails.obj_svprojectdetails
                              .value.gallery?.gallerydata?.length,
                          itemBuilder: (context, index, realIndex) {
                            return Obx(() => CachedNetworkImage(
                                  height: 211.w,
                                  width: Get.width,
                                  placeholder: (context, url) =>
                                      sliderShimmer(),
                                  fadeInDuration: Duration.zero,
                                  fadeOutDuration: Duration.zero,
                                  placeholderFadeInDuration: Duration.zero,
                                  imageUrl: cntProjectDetails
                                          .obj_svprojectdetails
                                          .value
                                          .gallery
                                          ?.gallerydata?[index]
                                          .icon ??
                                      "",
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) {
                                    return Image.network(
                                      cntProjectDetails
                                              .obj_svprojectdetails
                                              .value
                                              .gallery
                                              ?.gallerydata?[index]
                                              .icon ??
                                          "",
                                      width: Get.width,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ));
                          },
                          options: CarouselOptions(
                              autoPlay: true,
                              height: 211.w,
                              viewportFraction: 1,
                              onPageChanged: (index, _) {
                                cntProjectDetails.current.value = index;
                                cntProjectDetails.current.refresh();
                              }),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: Get.width,
                          height: 160.w,
                          margin: const EdgeInsets.symmetric(horizontal: 20),

                          decoration: CustomDecorations()
                              .backgroundlocal(white, 10, 0, white),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 8.w,right: 8.w, left: 8.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        width: 84.w,
                                        height: 84.w,
                                        fadeInDuration: Duration.zero,
                                        fadeOutDuration: Duration.zero,
                                        placeholderFadeInDuration: Duration.zero,
                                        imageUrl: cntProjectDetails
                                            .obj_svprojectdetails.value.featureimg
                                            .toString(),
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            shimmerWidget(
                                                width: 84.h,
                                                height: 84.w,
                                                radius: 10),
                                        errorWidget: (context, url, error) {
                                          return Image.network(
                                              cntProjectDetails
                                              .obj_svprojectdetails.value.featureimg
                                              .toString(),
                                              width: 84.w,
                                              height: 84.w,
                                              fit: BoxFit.cover);
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            cntProjectDetails.obj_svprojectdetails
                                                .value.projectname
                                                .toString(),
                                            style: boldTextStyle(
                                                fontSize: 15,
                                                txtColor: DARK_BLUE)),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Text(
                                            cntProjectDetails
                                                .obj_svprojectdetails.value.area
                                                .toString(),
                                            style: mediumTextStyle(
                                                fontSize: 10,
                                                txtColor: new_black_color)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              bHKContainerDesign()
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        right: 24.w,
                        top: 24.h,
                        child: GestureDetector(
                          onTap: () {
                            cntProjectDetails
                                        .obj_svprojectdetails.value.isfavourite
                                        .toString() ==
                                    "1"
                                ? MoengageAnalyticsHandler().SendAnalytics({
                                    "project_name": cntProjectDetails
                                            .obj_svprojectdetails
                                            .value
                                            .projectname ??
                                        "",
                                    "project_id": cntProjectDetails
                                            .obj_svprojectdetails.value.sId ??
                                        ""
                                  }, "project_favorite")
                                : MoengageAnalyticsHandler().SendAnalytics({
                                    "project_name": cntProjectDetails
                                            .obj_svprojectdetails
                                            .value
                                            .projectname ??
                                        "",
                                    "project_id": cntProjectDetails
                                            .obj_svprojectdetails.value.sId ??
                                        ""
                                  }, "project_unfavorite");
                            print('---fav click---');
                            if (cntProjectDetails.islogin.isTrue) {
                              cntProjectDetails.AddFavoriteProjectData();
                              cntProjectDetails.obj_svprojectdetails.refresh();
                            } else {
                              cntProjectDetails.LoginDialog();
                            }
                          },
                          child: Container(
                            height: 35.h,
                            width: 35.w,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: HexColor("#FFFFFF").withOpacity(0.8),
                            ),
                            child: cntProjectDetails
                                        .obj_svprojectdetails.value.isfavourite
                                        .toString() ==
                                    "1"
                                ? SvgPicture.asset(IMG_FAVORITE_SVG_2)
                                : SvgPicture.asset(IMG_FAVORITE_SVG),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        } else {
          return ShimmerEffect(
            child: Container(
              padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
              child: Container(
                margin: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 5),
                decoration: BoxDecoration(
                  color: APP_GRAY_COLOR,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 211.w,
                width: Get.width,
              ),
            ),
          );
        }
      },
      future: cntProjectDetails.futureProjectdetailsData.value,
    );
  }

  Widget bHKContainerDesign() {
    return FutureBuilder(
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return SizedBox(
            height: 45.w,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: cntProjectDetails
                  .obj_svprojectdetails.value.configuration?.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(right: 8.w, left: 8.w),
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.only(right: 10.w),
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(0, 0),
                            color: APP_THEME_COLOR.withOpacity(0.1),
                            spreadRadius: 0)
                      ],
                      borderRadius: BorderRadius.circular(10),
                      color: hex("F5F6FA")),
                  child: Column(
                    children: [
                      Text(
                        cntProjectDetails.obj_svprojectdetails.value
                                .configuration?[index].configuration ??
                            "",
                        style: TextStyle(
                            color: DARK_BLUE,
                            fontWeight: FontWeight.w700,
                            fontSize: 10.sp),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            cntProjectDetails.obj_svprojectdetails.value
                                    .configuration?[index].price ??
                                "",
                            style: TextStyle(
                                color: LIGHT_GREY_COLOR,
                                fontWeight: FontWeight.w700,
                                fontSize: 10.sp),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            cntProjectDetails.obj_svprojectdetails.value
                                    .configuration?[index].onward ??
                                "",
                            style: TextStyle(
                                fontSize: 10.sp,
                                color: LIGHT_GREY_COLOR,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        } else {
          return ShimmerEffect(
            child: Container(
              padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
              child: SizedBox(
                height: 45.w,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder: (context, i) {
                      return Container(
                        margin: const EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                          color: APP_GRAY_COLOR,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: 115,
                        height: 40,
                      );
                    }),
              ),
            ),
          );
        }
      },
      future: cntProjectDetails.futureProjectdetailsData.value,
    );
  }

  Widget projectDetailsBlockHeader() {
    return Obx(
      () => FutureBuilder(
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            return cntProjectDetails
                            .obj_svprojectdetails.value.headarr?.length !=
                        0 &&
                    cntProjectDetails.obj_svprojectdetails.value.headarr != null
                ? GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 20, bottom: 0),
                    itemBuilder: (context, i) {
                      return _generateProjectBlock1(i);
                    },
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.8,
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 2),
                    itemCount:
                        cntProjectDetails.obj_svprojectdetails.value.headarr !=
                                    null &&
                                cntProjectDetails.obj_svprojectdetails.value
                                    .headarr!.isNotEmpty
                            ? cntProjectDetails
                                .obj_svprojectdetails.value.headarr?.length
                            : 0,
                  )
                : const SizedBox();
          } else {
            return ShimmerEffect(
                child: GridView.builder(
              shrinkWrap: true,
              primary: false,
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 20, bottom: 5),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, i) {
                return Container(
                  padding: const EdgeInsets.only(
                      top: 0, left: LEFT_PADDING, right: 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: APP_GRAY_COLOR,
                  ),
                  width: 50,
                  height: 100,
                );
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4),
              itemCount: 4,
            ));
          }
        },
        future: cntProjectDetails.futureProjectdetailsData.value,
      ),
    );
  }

  Widget _generateProjectBlock1(int index) {
    return Container(
      width: 120.w,
      height: 120.h,
      decoration: CustomDecorations()
          .backgroundlocal(white, 6, 0, DARK_BLUE_WITH_OPACITY),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
              cntProjectDetails
                      .obj_svprojectdetails.value.headarr?[index].title ??
                  "",
              style: boldTextStyle(txtColor: LIGHT_GREY_COLOR, fontSize: 10)),
          const SizedBox(
            height: 3,
          ),
          Text(
              cntProjectDetails
                      .obj_svprojectdetails.value.headarr?[index].details ??
                  "",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: new_black_color,
                  fontSize: 12.sp,
                  fontFamily: fontFamily,
                  fontWeight: FontWeight.w400))
        ],
      ),
    );
  }

  Widget projectDescHeader() {
    return Obx(() => FutureBuilder(
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              return cntProjectDetails.obj_svprojectdetails.value.description
                              ?.longdesc !=
                          null &&
                      cntProjectDetails.obj_svprojectdetails.value.description
                              ?.longdesc !=
                          ''
                  ? Container(
                      margin:
                          const EdgeInsets.only(left: 20, right: 20, top: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(lblProjectDetailDescTitle,
                                  style: TextStyle(
                                      color: gray_color_1,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: fontFamily)
                                  // TextStyle(color: gray_color, fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Expanded(
                                child: Container(
                                  height: 1.h,
                                  // margin: EdgeInsets.only(right: 30),
                                  width: Get.width,
                                  color: BORDER_GREY,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          HtmlWidget(
                            cntProjectDetails.obj_svprojectdetails.value
                                    .description?.longdesc ??
                                "",
                            textStyle: mediumTextStyle(
                              txtColor: gray_color,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox();
            } else {
              return ShimmerEffect(
                  child: Container(
                      padding:
                          const EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: 4,
                          itemBuilder: (context, i) {
                            return Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                      color: APP_GRAY_COLOR,
                                      borderRadius: BorderRadius.circular(10)),
                                  width: Get.width,
                                  height: 20,
                                  // color: APP_GRAY_COLOR,
                                ),
                              ],
                            );
                          })));
            }
          },
          future: cntProjectDetails.futureProjectdetailsData.value,
        ));
  }

  Widget overviewSection() {
    return FutureBuilder(
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return Obx(
            () =>
                cntProjectDetails.obj_svprojectdetails.value.overview?.length !=
                            0 &&
                        cntProjectDetails.obj_svprojectdetails.value.overview !=
                            null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20, top: 10),
                              child: Row(
                                children: [
                                  Text(lblOverviewTitle,
                                      style: TextStyle(
                                          color: gray_color_1,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: fontFamily)
                                      // TextStyle(color: gray_color, fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 1.h,
                                      // margin: EdgeInsets.only(right: 30),
                                      width: Get.width,
                                      color: BORDER_GREY,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            overviewBlock(),
                            // divider(),
                          ])
                    : const SizedBox(),
          );
        } else {
          return Container();
        }
      },
      future: cntProjectDetails.futureProjectdetailsData.value,
    );
  }

  Widget overviewBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: cntProjectDetails.obj_svprojectdetails.value.overview !=
                      null &&
                  cntProjectDetails
                          .obj_svprojectdetails.value.overview?.length !=
                      0
              ? cntProjectDetails.obj_svprojectdetails.value.overview?.length
              : 0,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 0, left: 20, right: 20),
                  child: Text(
                      cntProjectDetails.obj_svprojectdetails.value
                              .overview?[index].lable ??
                          "",
                      style: TextStyle(
                          color: new_black_color,
                          fontSize: 12.sp,
                          fontFamily: fontFamily,
                          fontWeight: FontWeight.w500)),
                ),
                const SizedBox(
                  height: 6,
                ),
                if (cntProjectDetails
                        .obj_svprojectdetails.value.overview?[index].lable
                        .toString() ==
                    "Construction Status")
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 0, left: 20, right: 20),
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: cntProjectDetails
                                  .obj_svprojectdetails.value.overview !=
                              null
                          ? cntProjectDetails.obj_svprojectdetails.value
                                      .overview![index].data1 !=
                                  null
                              ? cntProjectDetails.obj_svprojectdetails.value
                                          .overview![index].data1?.length !=
                                      0
                                  ? cntProjectDetails.obj_svprojectdetails.value
                                      .overview![index].data1?.length
                                  : 0
                              : 0
                          : 0,
                      itemBuilder: (BuildContext context, int index2) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 18.0),
                          child: Text(
                            cntProjectDetails.obj_svprojectdetails.value
                                .overview![index].data1![index2].description
                                .toString(),
                            style: TextStyle(
                              color: new_black_color,
                              fontSize: 10.sp,
                              fontFamily: fontFamily,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        );
                      },
                      // child:
                    ),
                  ),
                if (cntProjectDetails
                        .obj_svprojectdetails.value.overview?[index].lable
                        .toString() ==
                    "Project Location")
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0, left: 20),
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: cntProjectDetails
                                  .obj_svprojectdetails.value.overview !=
                              null
                          ? cntProjectDetails.obj_svprojectdetails.value
                                      .overview![index].data1 !=
                                  null
                              ? cntProjectDetails.obj_svprojectdetails.value
                                          .overview![index].data1?.length !=
                                      0
                                  ? cntProjectDetails.obj_svprojectdetails.value
                                      .overview![index].data1?.length
                                  : 0
                              : 0
                          : 0,
                      itemBuilder: (BuildContext context, int index2) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 18.0),
                          child: Text(
                            cntProjectDetails.obj_svprojectdetails.value
                                .overview![index].data1![index2].location
                                .toString(),
                            style: TextStyle(
                                color: new_black_color,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w400,
                                fontFamily: fontFamily),
                          ),
                        );
                      },
                      // child:
                    ),
                  ),
                // else
                if (cntProjectDetails
                            .obj_svprojectdetails.value.overview?[index].lable
                            .toString() !=
                        "Project Location" &&
                    cntProjectDetails
                            .obj_svprojectdetails.value.overview?[index].lable
                            .toString() !=
                        "Construction Status" &&
                    cntProjectDetails
                            .obj_svprojectdetails.value.overview?[index].lable
                            .toString() !=
                        "RERA" &&
                    cntProjectDetails
                            .obj_svprojectdetails.value.overview?[index].lable
                            .toString() !=
                        "Brochure")
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 18, left: 0, right: 0),
                    child: SizedBox(
                      height: 65,
                      child: ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index1) {
                          return _generateConstructorImages(index, index1);
                        },
                        itemCount: cntProjectDetails
                                    .obj_svprojectdetails.value.overview !=
                                null
                            ? cntProjectDetails.obj_svprojectdetails.value
                                        .overview![index].data1 !=
                                    null
                                ? cntProjectDetails.obj_svprojectdetails.value
                                            .overview![index].data1?.length !=
                                        0
                                    ? cntProjectDetails.obj_svprojectdetails
                                        .value.overview![index].data1?.length
                                    : 0
                                : 0
                            : 0,
                      ),
                    ),
                  ),

                if (cntProjectDetails
                        .obj_svprojectdetails.value.overview?[index].lable
                        .toString() ==
                    "RERA")
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 19, vertical: 0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: cntProjectDetails
                                  .obj_svprojectdetails.value.overview !=
                              null
                          ? cntProjectDetails.obj_svprojectdetails.value
                                      .overview![index].data1 !=
                                  null
                              ? cntProjectDetails.obj_svprojectdetails.value
                                          .overview![index].data1?.length !=
                                      0
                                  ? cntProjectDetails.obj_svprojectdetails.value
                                      .overview![index].data1?.length
                                  : 0
                              : 0
                          : 0,
                      itemBuilder: (BuildContext context, int index3) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                    child: Wrap(
                                  children: [
                                    Text(
                                      cntProjectDetails
                                          .obj_svprojectdetails
                                          .value
                                          .overview![index]
                                          .data1![index3]
                                          .reranumber
                                          .toString(),
                                      style: TextStyle(
                                          color: new_black_color,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: fontFamily),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        MoengageAnalyticsHandler()
                                            .SendAnalytics({
                                          "rera_number": cntProjectDetails
                                              .obj_svprojectdetails
                                              .value
                                              .overview![index]
                                              .data1![index3]
                                              .reranumber
                                              .toString()
                                        }, "project_RERA");
                                        if (cntProjectDetails
                                                .obj_svprojectdetails
                                                .value
                                                .overview![index]
                                                .data1![index3]
                                                .reracertificate !=
                                            "") {
                                          DownloadFile(
                                              downloadType: DownloadType.URL,
                                              url: cntProjectDetails
                                                  .obj_svprojectdetails
                                                  .value
                                                  .overview![index]
                                                  .data1![index3]
                                                  .reracertificate);
                                        } else {
                                          validationMsg("file not found");
                                        }
                                      },
                                      child: Text("( ReraCertificate)",
                                          style: regularTextStyle(
                                              txtColor: DARK_BLUE,
                                              fontSize: 10)),
                                    ),
                                  ],
                                )),
                              ],
                            ),
                            const SizedBox(
                              height: 18,
                            )
                          ],
                        );
                      },
                    ),
                  ),

                if (cntProjectDetails
                        .obj_svprojectdetails.value.overview?[index].lable
                        .toString() ==
                    "Brochure")
                  SizedBox(
                    height: 130.w,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 0),
                      physics: const BouncingScrollPhysics(),
                      itemCount: cntProjectDetails
                                  .obj_svprojectdetails.value.overview !=
                              null
                          ? cntProjectDetails.obj_svprojectdetails.value
                                      .overview![index].data1 !=
                                  null
                              ? cntProjectDetails.obj_svprojectdetails.value
                                          .overview![index].data1?.length !=
                                      0
                                  ? cntProjectDetails.obj_svprojectdetails.value
                                      .overview![index].data1?.length
                                  : 0
                              : 0
                          : 0,
                      itemBuilder: (BuildContext context, int index4) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: cntProjectDetails
                                          .obj_svprojectdetails
                                          .value
                                          .overview![index]
                                          .data1!
                                          .length >
                                      1
                                  ? 0.0
                                  : 0.0,
                              horizontal: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(cornarradius),
                                    child: CachedNetworkImage(
                                      height: 107.w,
                                      width: 190.w,
                                      placeholder: (context, url) =>
                                          shimmerWidget(
                                              height: 107.h,
                                              width: 190.w,
                                              radius: 8),
                                      fadeInDuration: Duration.zero,
                                      fadeOutDuration: Duration.zero,
                                      placeholderFadeInDuration: Duration.zero,
                                      imageUrl: cntProjectDetails
                                              .obj_svprojectdetails
                                              .value
                                              .overview![index]
                                              .data1![index4]
                                              .brochurefile ??
                                          "",
                                      fit: BoxFit.fill,
                                      errorWidget: (context, url, error) {
                                        return Image.network(
                                            cntProjectDetails
                                                .obj_svprojectdetails
                                                .value
                                                .overview![index]
                                                .data1![index4]
                                                .brochurefile ??
                                                "",
                                            height: 107.w,
                                            width: 190.w,
                                            fit: BoxFit.fill
                                            // height: 20, width: 20
                                            );
                                      },
                                    ),
                                  ),
                                  Positioned(
                                      top: 10.h,
                                      right: 8.w,
                                      child: GestureDetector(
                                        onTap: () {
                                          MoengageAnalyticsHandler()
                                              .SendAnalytics(
                                                  {"brochure_no": index4 + 1},
                                                  "project_brochure_download");
                                          DownloadFile(
                                            downloadType: DownloadType.URL,
                                            url: cntProjectDetails
                                                .obj_svprojectdetails
                                                .value
                                                .overview![index]
                                                .data1![index4]
                                                .brochurefile
                                                .toString(),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              color: white.withOpacity(0.8)),
                                          child: SvgPicture.asset(
                                              IMG_FILE_DOWNLOAD_SVG),
                                        ),
                                      ))
                                ],
                              ),
                              const SizedBox(height: 9),
                              Text("Brochure ${index4 + 1}",
                                  style: mediumTextStyle(
                                      txtColor: gray_color_1, fontSize: 10)),
                            ],
                          ),
                        );
                      },
                    ),
                  )
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _generateConstructorImages(int indx, index1) {
    return InkWell(
      //onTap: () => ChangeIndex(index1),
      child: Container(
          margin: EdgeInsets.only(
              left: index1 == 0 ? 20 : 5,
              right:
                  cntProjectDetails.agencyimages.length - 1 == index1 ? 20 : 5),
          decoration: CustomDecorations().backgroundlocal(
              cntProjectDetails.selectedIndex.value == index1
                  ? APP_THEME_COLOR
                  : white,
              cornarradius,
              0,
              white),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                width: 116.w,
                height: 65.h,
                placeholder: (context, url) => Container(),
                fadeInDuration: Duration.zero,
                fadeOutDuration: Duration.zero,
                placeholderFadeInDuration: Duration.zero,
                imageUrl: cntProjectDetails.obj_svprojectdetails.value
                    .overview![indx].data1![index1].image
                    .toString(),
                fit: BoxFit.cover,
                errorWidget: (context, url, error) {
                  return Image.network(
                      cntProjectDetails.obj_svprojectdetails.value
                          .overview![indx].data1![index1].image
                          .toString(),
                      height: 107.w,
                      width: 190.w,
                      fit: BoxFit.fill
                    // height: 20, width: 20
                  );
                },
              ))),
    );
  }

  Widget connectivityData1() {
    return Obx(() => FutureBuilder(
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              if (cntProjectDetails.obj_svprojectdetails.value.locationimg !=
                      null &&
                  cntProjectDetails.obj_svprojectdetails.value.locationimg !=
                      "") {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20.0, right: 20, top: 20),
                      child: Row(
                        children: [
                          Text("Connectivity",
                              style: TextStyle(
                                  color: gray_color_1,
                                  fontSize: 12.sp,
                                  fontFamily: fontFamily,
                                  fontWeight: FontWeight.w700)),
                          SizedBox(
                            width: 10.w,
                          ),
                          Expanded(
                            child: Container(
                              height: 1.h,
                              width: Get.width,
                              color: BORDER_GREY,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      height: 185.h,
                      width: Get.width,
                      margin: const EdgeInsets.symmetric(horizontal: 20.0),
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(6)),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => ZoomableImage(
                                imageUrl: cntProjectDetails.obj_svprojectdetails
                                        .value.locationimg ??
                                    "",
                              ));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: CachedNetworkImage(
                            fadeInDuration: Duration.zero,
                            fadeOutDuration: Duration.zero,
                            placeholderFadeInDuration: Duration.zero,
                            imageUrl: cntProjectDetails
                                    .obj_svprojectdetails.value.locationimg ??
                                "",
                            fit: BoxFit.cover,
                            placeholder: (context, url) {
                              return shimmerWidget(
                                  height: 185.h, width: Get.width, radius: 6);
                            },
                            errorWidget: (context, url, error) {
                              return Image.network(
                                cntProjectDetails.obj_svprojectdetails.value
                                        .locationimg ??
                                    "",
                                height: 185.h,
                                width: Get.width,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return const SizedBox();
              }
            } else {
              return connectivityShimmer();
            }
          },
          future: cntProjectDetails.futureProjectdetailsData.value,
        ));
  }

  Widget gallerySection() {
    return Obx(() => FutureBuilder(
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              if (cntProjectDetails
                          .obj_svprojectdetails.value.gallery?.gallerydata !=
                      null &&
                  cntProjectDetails
                          .obj_svprojectdetails.value.gallery!.gallerydata !=
                      "") {
                return Obx(() => cntProjectDetails.obj_svprojectdetails.value
                                .gallery?.gallerydata?.length !=
                            0 &&
                        cntProjectDetails.obj_svprojectdetails.value.gallery
                                ?.gallerydata !=
                            null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20, top: 16),
                              child: Row(
                                children: [
                                  Text(
                                      cntProjectDetails.obj_svprojectdetails
                                              .value.gallery?.lable
                                              ?.toUpperCase() ??
                                          "",
                                      style: TextStyle(
                                          color: gray_color_1,
                                          fontSize: 12.sp,
                                          fontFamily: fontFamily,
                                          fontWeight: FontWeight.w700)),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 1.h,
                                      width: Get.width,
                                      color: BORDER_GREY,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 10.h),
                            galleryDataGridView()
                          ])
                    : const SizedBox());
              } else {
                return const Text("No Data Found");
              }
            } else {
              return galleryShimmer();
              // return Container();
            }
          },
          future: cntProjectDetails.futureProjectdetailsData.value,
        ));
  }

  Widget galleryDataGridView() {
    return Obx(() => cntProjectDetails
                .obj_svprojectdetails.value.gallery?.gallerydata !=
            null
        ? GridView.builder(
            itemCount:
                cntProjectDetails.obj_svprojectdetails.value.gallery != null &&
                        cntProjectDetails.obj_svprojectdetails.value.gallery
                                ?.gallerydata !=
                            null &&
                        cntProjectDetails.obj_svprojectdetails.value.gallery!
                                .gallerydata!.length >
                            5
                    ? 6
                    : 0,
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 20, right: 20),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                focusColor: AppColors.TRANSPARENT,
                highlightColor: AppColors.TRANSPARENT,
                hoverColor: AppColors.TRANSPARENT,
                splashColor: AppColors.TRANSPARENT,
                onTap: () {
                  if (index != 5) {
                    MoengageAnalyticsHandler()
                        .track_event("project_gallery_view");
                    Get.to(() => FullImageViewPage(
                        title: cntProjectDetails.obj_svprojectdetails.value
                            .gallery?.gallerydata?[index].name,
                        list: cntProjectDetails.gallerylist,
                        index: index));
                  }
                },
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(cornarradius),
                      child: CachedNetworkImage(
                        width: 120.w,
                        height: 120.h,
                        fadeInDuration: Duration.zero,
                        fadeOutDuration: Duration.zero,
                        placeholderFadeInDuration: Duration.zero,
                        placeholder: (context, url) => shimmerWidget(
                            width: 120.w, height: 120.h, radius: 8),
                        imageUrl: cntProjectDetails.obj_svprojectdetails.value
                                .gallery?.gallerydata?[index].icon ??
                            "",
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) {
                          return Image.network(
                            cntProjectDetails.obj_svprojectdetails.value.gallery
                                    ?.gallerydata?[index].icon ??
                                "",
                          );
                        },
                      ),
                    ),
                    Positioned(
                        child: index == 5
                            ? InkWell(
                                onTap: () {
                                  MoengageAnalyticsHandler()
                                      .track_event("project_gallery_page");
                                  Get.to(() => const ProjectGalleryScreen());
                                },
                                child: Container(
                                  width: 120.w,
                                  height: 120.h,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(cornarradius),
                                      color: DARK_BLUE.withOpacity(0.4)),
                                  child: Center(
                                      child: Text(
                                    "${"+"}${cntProjectDetails.obj_svprojectdetails.value.gallery!.gallerydata!.length - 6}",
                                    style: TextStyle(
                                        color: white,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: fontFamily),
                                  )),
                                ),
                              )
                            : const SizedBox())
                  ],
                ),
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8,
            ),
          )
        : const SizedBox());
  }

  Widget locationSection() {
    return Obx(() =>
        cntProjectDetails.obj_svprojectdetails.value.location?.lable != null
            ? Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("Location",
                            style: TextStyle(
                                color: gray_color_1,
                                fontSize: 12.sp,
                                fontFamily: fontFamily,
                                fontWeight: FontWeight.w700)),
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(
                          child: Container(
                            height: 1.h,
                            width: Get.width,
                            color: BORDER_GREY,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        googleMap(),
                      ],
                    ),
                  ],
                ),
              )
            : Container());
  }

  Widget googleMap() {
    cntProjectDetails.currentLocation = cntProjectDetails.obj_svprojectdetails
            .value.location?.latlongdata?[0].project_location ??
        const LatLng(19.262224, 72.9565016);
    // print(currentLocation);
    // print("currentLocation123");
    return Container(
      height: 185.w,
      width: Get.width,
      decoration:
          CustomDecorations().backgroundlocal(white, cornarradius, 2.5, white),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cornarradius),
        child: GoogleMap(
          gestureRecognizers: Set()
            ..add(Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer()))
            ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
            ..add(
                Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()))
            ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer()))
            ..add(Factory<VerticalDragGestureRecognizer>(
                () => VerticalDragGestureRecognizer())),
          initialCameraPosition: CameraPosition(
              target: cntProjectDetails.currentLocation, zoom: 10),
          // markers: Set<Marker>.of(markerValue.values),
          markers: cntProjectDetails.markers,
          zoomControlsEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            cntProjectDetails.googleMapController = controller;
          },
        ),
      ),
    );
  }

  Widget amenitiesSection() {
    return Obx(() => FutureBuilder(
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              return Obx(() => cntProjectDetails.obj_svprojectdetails.value
                              .amenities?.amenitiesdata?.length !=
                          0 &&
                      cntProjectDetails.obj_svprojectdetails.value.amenities
                              ?.amenitiesdata !=
                          null
                  ? Padding(
                      padding:
                          const EdgeInsets.only(left: 20.0, right: 20, top: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("Amenities",
                                  style: TextStyle(
                                      color: gray_color_1,
                                      fontSize: 12.sp,
                                      fontFamily: fontFamily,
                                      fontWeight: FontWeight.w700)),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Container(
                                  height: 1.h,
                                  // margin: EdgeInsets.only(right: 30),
                                  width: Get.width,
                                  color: BORDER_GREY,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                  "${cntProjectDetails.obj_svprojectdetails.value.amenities!.amenitiesdata!.length - 1}+",
                                  style: TextStyle(
                                      color: gray_color_1,
                                      fontSize: 12.sp,
                                      fontFamily: fontFamily,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          amenitiesData()
                        ],
                      ),
                    )
                  : const SizedBox());
            } else {
              return ShimmerEffect(
                child: SizedBox(
                  height: 185.h,
                  width: Get.width,
                  child: GridView.builder(
                    shrinkWrap: true,
                    primary: false,
                    padding:
                        const EdgeInsets.only(left: 20.0, right: 20, top: 20),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 150,
                        height: 50,
                        margin: const EdgeInsets.only(right: 10, bottom: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: APP_GRAY_COLOR,
                        ),
                      );
                    },
                    physics: const ScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, childAspectRatio: 0.4),
                    itemCount: 12,
                  ),
                ),
              );
              // return Container();
            }
          },
          future: cntProjectDetails.futureProjectdetailsData.value,
        ));
  }

  Widget amenitiesData() {
    return SizedBox(
      height: 185.h,
      width: Get.width,
      child: GridView.builder(
        shrinkWrap: true,
        primary: false,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Obx(() => _amenitiesData(index));
        },
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 0.4),
        itemCount:
            cntProjectDetails.obj_svprojectdetails.value.amenities != null &&
                    cntProjectDetails.obj_svprojectdetails.value.amenities
                            ?.amenitiesdata !=
                        null &&
                    cntProjectDetails.obj_svprojectdetails.value.amenities
                            ?.amenitiesdata?.length !=
                        0
                ? cntProjectDetails
                    .obj_svprojectdetails.value.amenities?.amenitiesdata?.length
                : 0,
      ),
    );
  }

  Widget _amenitiesData(int index) {
    return Container(
      width: Get.width,
      margin: const EdgeInsets.only(bottom: 12),
      decoration:
          CustomDecorations().backgroundlocal(white, 6, 1.5, BORDER_GREY),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 12.w),
          Container(
            alignment: Alignment.center,
            child: cntProjectDetails.obj_svprojectdetails.value.amenities!
                    .amenitiesdata![index].amenityimage
                    .toString()
                    .contains("svg")
                ? SvgPicture.network(
                    cntProjectDetails.obj_svprojectdetails.value.amenities
                            ?.amenitiesdata?[index].amenityimage ??
                        "",
                    width: 28.w,
                    height: 28.w,
                  )
                : Image.network(
                    cntProjectDetails.obj_svprojectdetails.value.amenities
                            ?.amenitiesdata?[index].amenityimage ??
                        "",
                    width: 28.w,
                    height: 28.w,
                  ),
          ),
          SizedBox(width: 10.w),
          SizedBox(
            width: 70.h,
            child: Text(
              cntProjectDetails.obj_svprojectdetails.value.amenities
                      ?.amenitiesdata?[index].name ??
                  "",
              style: mediumTextStyle(fontSize: 11, txtColor: hex("707070")),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  Widget siteProgressSection() {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return Obx(
            () => cntProjectDetails.obj_svprojectdetails.value.siteprog
                            ?.siteprogressdata?.length !=
                        0 &&
                    cntProjectDetails.obj_svprojectdetails.value.siteprog
                            ?.siteprogressdata !=
                        null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, top: 14, right: 20),
                        child: Row(
                          children: [
                            Text(
                                cntProjectDetails.obj_svprojectdetails.value
                                        .siteprog?.lable ??
                                    "",
                                style: TextStyle(
                                    color: gray_color_1,
                                    fontSize: 12.sp,
                                    fontFamily: fontFamily,
                                    fontWeight: FontWeight.w700)),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Container(
                                height: 1.h,
                                // margin: EdgeInsets.only(right: 30),
                                width: Get.width,
                                color: BORDER_GREY,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                      siteProgressBlock(),
                    ],
                  )
                : const SizedBox(),
          );
        } else {
          return ShimmerEffect(
              child: Container(
            margin: const EdgeInsets.only(
              top: 20,
            ),
            height: 170,
            // padding: EdgeInsets.symmetric(horizontal: 15,),
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              padding:
                  const EdgeInsets.only(left: 20, right: 8, bottom: 0, top: 0),
              // site_progress.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 0, right: 8, bottom: 0, top: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: const EdgeInsets.only(right: 8),
                          height: 128.h,
                          width: 190.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: APP_GRAY_COLOR,
                          ))
                    ],
                  ),
                );
              },
            ),
          ));
          // return Container();
        }
      },
      future: cntProjectDetails.futureProjectdetailsData.value,
    );
  }

  Widget siteProgressBlock() {
    return Container(
      margin: const EdgeInsets.only(
        top: 0,
      ),
      height: 130.w,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount:
            cntProjectDetails.obj_svprojectdetails.value.siteprog != null &&
                    cntProjectDetails.obj_svprojectdetails.value.siteprog
                            ?.siteprogressdata !=
                        null &&
                    cntProjectDetails.obj_svprojectdetails.value.siteprog
                            ?.siteprogressdata?.length !=
                        0
                ? cntProjectDetails.obj_svprojectdetails.value.siteprog
                    ?.siteprogressdata?.length
                : 0,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
                left: index == 0 ? 20 : 8,
                right: (cntProjectDetails.obj_svprojectdetails.value.siteprog
                                ?.siteprogressdata?.length)! -
                            1 ==
                        index
                    ? 20
                    : 8,
                bottom: 0,
                top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  focusColor: AppColors.TRANSPARENT,
                  highlightColor: AppColors.TRANSPARENT,
                  hoverColor: AppColors.TRANSPARENT,
                  splashColor: AppColors.TRANSPARENT,
                  onTap: () {
                    MoengageAnalyticsHandler().SendAnalytics({
                      "site_name": cntProjectDetails.obj_svprojectdetails.value
                              .siteprog?.siteprogressdata?[index].sitename ??
                          ""
                    }, "site_progress");
                    Get.to(FullImageViewPage(
                        list: cntProjectDetails.siteprogress,
                        title: cntProjectDetails.obj_svprojectdetails.value
                                .siteprog?.siteprogressdata?[index].sitename ??
                            "",
                        index: index));
                  },
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: CachedNetworkImage(
                          width: 190.w,
                          height: 107.w,
                          fadeInDuration: Duration.zero,
                          fadeOutDuration: Duration.zero,
                          placeholderFadeInDuration: Duration.zero,
                          imageUrl: cntProjectDetails.obj_svprojectdetails.value
                                  .siteprog?.siteprogressdata?[index].icon ??
                              "",
                          placeholder: (context, url) => shimmerWidget(
                              width: 190.w, height: 107.w, radius: 7),
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) {
                            return Image.network(
                              cntProjectDetails
                                      .obj_svprojectdetails
                                      .value
                                      .siteprog
                                      ?.siteprogressdata?[index]
                                      .icon ??
                                  "",
                            );
                          },
                        ),
                      ),
                      Positioned(
                          left: 8.w,
                          bottom: 10.h,
                          child: Container(
                            padding: EdgeInsets.all(6.w),
                            decoration: BoxDecoration(
                                color: BLACK.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(6)),
                            child: Text(
                              cntProjectDetails
                                      .obj_svprojectdetails
                                      .value
                                      .siteprog
                                      ?.siteprogressdata?[index]
                                      .monthyear ??
                                  "",
                              style: TextStyle(
                                  fontFamily: fontFamily,
                                  color: white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 9.sp),
                            ),
                          ))
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  cntProjectDetails.obj_svprojectdetails.value.siteprog
                          ?.siteprogressdata?[index].sitename ??
                      "",
                  style: TextStyle(
                      fontFamily: fontFamily,
                      color: new_black_color,
                      fontWeight: FontWeight.w400,
                      fontSize: 10.sp),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget planLayoutSection() {
    LayoutModal? layoutList;
    layoutList = cntProjectDetails.obj_svprojectdetails.value.layout;
    final seen = <String>{};
    final unique = layoutList?.layoutdata
        ?.where((str) => seen.add(str.layouttype.toString()))
        .toList();

    return SizedBox(
        width: double.infinity,
        child:  Obx(() =>FutureBuilder(
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                !snapshot.hasError &&
                snapshot.data != null) {
              if (cntProjectDetails.obj_svprojectdetails.value.layout != null) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              cntProjectDetails.obj_svprojectdetails.value
                                      .layout?.lable ??
                                  "",
                              style: TextStyle(
                                  color: gray_color_1,
                                  fontSize: 12.sp,
                                  fontFamily: fontFamily,
                                  fontWeight: FontWeight.w700)),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Container(
                              height: 1.h,
                              // margin: EdgeInsets.only(right: 30),
                              width: Get.width,
                              color: BORDER_GREY,
                            ),
                          ),
                          SizedBox(
                                height: 40,
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 1, left: 8, top: 8, bottom: 8),
                                    child: ToggleButtons(
                                      borderColor: APP_THEME_COLOR,
                                      fillColor: APP_THEME_COLOR,
                                      borderWidth: 0,
                                      selectedBorderColor: APP_THEME_COLOR,
                                      selectedColor: AppColors.WHITE,
                                      borderRadius: BorderRadius.circular(5),
                                      onPressed: (int indexMain) {
                                        cntProjectDetails.isSelected.value = [];
                                        unique
                                            .asMap()
                                            .forEach((index2, element) {
                                          if (indexMain == index2) {
                                            cntProjectDetails.isSelected
                                                .add(true);
                                            cntProjectDetails
                                                    .layoutString.value =
                                                element.layouttype.toString();
                                          } else {
                                            cntProjectDetails.isSelected
                                                .add(false);
                                          }
                                        });
                                      },
                                      isSelected: cntProjectDetails.isSelected,
                                      children: unique!.map((e) {
                                        return Obx(() => Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 3.0),
                                              child: Text(
                                                e.layouttype ?? "",
                                                style: TextStyle(
                                                    fontSize: 10.sp,
                                                    color: cntProjectDetails
                                                                .layoutString
                                                                .value ==
                                                            e.layouttype
                                                        ? white
                                                        : APP_THEME_COLOR,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: fontFamily),
                                              ),
                                            ));
                                      }).toList(),
                                    )),
                              ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    planLayoutBlock(),
                  ],
                );
              } else {
                return const SizedBox();
              }
              //return LeadShimmerWidget();
            } else {
              return const SizedBox();
            }
          },
          future: cntProjectDetails.futureProjectdetailsData.value,
        )));
  }

  Widget planLayoutBlock() {
    return Obx(() => SizedBox(
          height: 110.h,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: cntProjectDetails
                .obj_svprojectdetails.value.layout?.layoutdata?.length,
            // plan_layout.length,
            itemBuilder: (context, index) {
              return Obx(() => cntProjectDetails.layoutString.value ==
                      cntProjectDetails.obj_svprojectdetails.value.layout!
                          .layoutdata![index].layouttype
                  ? Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 0, top: 0),
                      child: InkWell(
                        onTap: () {
                          MoengageAnalyticsHandler().SendAnalytics({
                            "layout_type": cntProjectDetails
                                .obj_svprojectdetails
                                .value
                                .layout!
                                .layoutdata![index]
                                .layouttype
                          }, "project_layout");
                          Get.to(FullImageViewPage(
                              title: cntProjectDetails
                                      .obj_svprojectdetails
                                      .value
                                      .layout!
                                      .layoutdata![index]
                                      .layoutname ??
                                  "",
                              list: cntProjectDetails.layoutString.value ==
                                      "Floor Plan"
                                  ? cntProjectDetails.floorplan
                                  : cntProjectDetails.layoutString.value ==
                                          "Layout Plan"
                                      ? cntProjectDetails.layoutplan
                                      : cntProjectDetails.unitplan,
                              index: index));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: CachedNetworkImage(
                            height: 110.w,
                            width: 190.h,
                            fadeInDuration: Duration.zero,
                            fadeOutDuration: Duration.zero,
                            placeholderFadeInDuration: Duration.zero,
                            imageUrl: cntProjectDetails.obj_svprojectdetails
                                    .value.layout!.layoutdata![index].icon ??
                                "",
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) {
                              return Image.network(
                                cntProjectDetails.plan_layout[index].toString(),
                                height: 110.h,
                                width: 190.w,
                              );
                            },
                          ),
                        ),
                      ))
                  : Container());
            },
          ),
        ));
  }

  Widget siteVisitSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 24),
          child: Row(
            children: [
              Text("Schedule a Site Visit",
                  style: TextStyle(
                      color: gray_color_1,
                      fontSize: 12.sp,
                      fontFamily: fontFamily,
                      fontWeight: FontWeight.w700)
                  // TextStyle(color: APP_FONT_COLOR, fontWeight: FontWeight.bold),
                  ),
              SizedBox(width: 10.w),
              Expanded(
                child: Container(
                  height: 1.h,
                  // margin: EdgeInsets.only(right: 30),
                  width: Get.width,
                  color: BORDER_GREY,
                ),
              )
            ],
          ),
        ),
        // SizedBox(height: 5),
        SizedBox(
            width: Get.width,
            child: Column(
              children: [
                cntScheduleSite.Theme_1(false),
              ],
            )),
      ],
    );
  }

  Widget highlightSection() {
    return Obx(
      () => cntProjectDetails.obj_svprojectdetails.value.highlight
                      ?.highlightsdata?.length !=
                  0 &&
              cntProjectDetails
                      .obj_svprojectdetails.value.highlight?.highlightsdata !=
                  null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                highLight(),
                const SizedBox(
                  height: 15,
                ),
                cntProjectDetails.divider(),
              ],
            )
          : const SizedBox(),
    );
  }

  Widget highLight() {
    return Container(
        margin: const EdgeInsets.only(left: 0, right: 0, top: 0),
        padding: const EdgeInsets.only(left: 0, top: 0, bottom: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                shrinkWrap: true,
                primary: false,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return _generateHighlightItem(index);
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.88,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15),
                itemCount:
                    cntProjectDetails.obj_svprojectdetails.value.highlight !=
                                null &&
                            cntProjectDetails.obj_svprojectdetails.value
                                    .highlight?.highlightsdata !=
                                null &&
                            cntProjectDetails.obj_svprojectdetails.value
                                    .highlight?.highlightsdata?.length !=
                                0
                        ? cntProjectDetails.obj_svprojectdetails.value.highlight
                            ?.highlightsdata?.length
                        : 0,
              ),
            ),
          ],
        ));
  }

  Widget _generateHighlightItem(int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          focusColor: AppColors.TRANSPARENT,
          highlightColor: AppColors.TRANSPARENT,
          hoverColor: AppColors.TRANSPARENT,
          splashColor: AppColors.TRANSPARENT,
          onTap: () {
            projectDescBottomSheet(
                cntProjectDetails.obj_svprojectdetails.value.highlight
                    ?.highlightsdata?[index].name,
                cntProjectDetails.obj_svprojectdetails.value.highlight
                    ?.highlightsdata?[index].description);
          },
          child: Container(
            margin: const EdgeInsets.only(top: 5),
            decoration: CustomDecorations()
                .backgroundlocal(white, 30, 0, APP_GRAY_COLOR),
            padding: const EdgeInsets.all(5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: SizedBox(
                  height: 50,
                  width: 50,
                  // alignment: Alignment.center,
                  child: CachedNetworkImage(
                    fadeInDuration: Duration.zero,
                    fadeOutDuration: Duration.zero,
                    placeholderFadeInDuration: Duration.zero,
                    imageUrl: cntProjectDetails.obj_svprojectdetails.value
                            .highlight?.highlightsdata?[index].highlighticon ??
                        "",
                    fit: BoxFit.fill,
                    errorWidget: (context, url, error) {
                      return Image.network(
                        cntProjectDetails.obj_svprojectdetails.value.highlight
                                ?.highlightsdata?[index].highlighticon ??
                            "",
                        height: 20,
                        width: 20,
                      );
                    },
                  )
                  // Image.asset(
                  //   obj.imageIcon!,
                  //   height: 30,
                  //   width: 30,
                  // ),
                  ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
            cntProjectDetails.obj_svprojectdetails.value.highlight
                    ?.highlightsdata?[index].name ??
                "",
            // obj.title!,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: mediumTextStyle(
              txtColor: gray_color,
              fontSize: 11,
            )
            //       TextStyle(fontWeight: FontWeight.w500,color: gray_color),
            )
      ],
    );
  }

  Widget connectivityShimmer() {
    return ShimmerEffect(
        child: Container(
            height: 185.h,
            width: Get.width,
            margin: const EdgeInsets.only(left: 20.0, right: 20, top: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: APP_GRAY_COLOR,
            )));
  }

  Widget galleryShimmer() {
    return ShimmerEffect(
        child: GridView.builder(
      itemCount: 6,
      shrinkWrap: true,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: APP_GRAY_COLOR,
          ),
          height: 120.h,
          width: 120.w,
        );
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
    ));
  }

  projectDescBottomSheet(title, description) {
    if (description != null && description != '') {
      bottomSheetDialog(
          message: title,
          backgroundColor: APP_THEME_COLOR,
          child: Container(
              width: Get.width,
              padding: const EdgeInsets.all(20),
              child: Text(description)));
    }
  }

  Widget sliderShimmer() {
    return ShimmerEffect(
        child: Container(
      padding: const EdgeInsets.only(left: 0, right: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        color: APP_GRAY_COLOR,
      ),
      width: Get.width,
      height: 100,
    ));
  }
}
