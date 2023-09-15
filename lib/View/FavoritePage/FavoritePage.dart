import 'package:Repeople/Config/Helper/HextoColor.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Model/Dashbord/ProjectListClass.dart';
import 'package:Repeople/Model/ProjectListModal/ProjectListModal.dart';
import 'package:Repeople/View/DashboardPage/BottomnavigationBar.dart';
import 'package:Repeople/View/ProjectDetails/ProjectDetails.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:Repeople/Widgets/ShimmerWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Helper/MoengageAnalyticsHandler.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:Repeople/Controller/FavoriteController/FavoriteController.dart';

import '../../Config/utils/colors.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  CommonHeaderController cntCommonHeader = Get.put(CommonHeaderController());
  FavoriteController cntFavorite = Get.put(FavoriteController());
  GlobalKey<ScaffoldState> globalFavouritePageKey = GlobalKey<ScaffoldState>();



  @override
  void initState(){
    WidgetsBinding.instance.addPostFrameCallback((_){
      BottomNavigationBarClass().selectedIndex=3;
      cntFavorite.futurearrfavprojectlist.value = cntFavorite.RetrieveFavouritesProjectData();
      cntFavorite.futurearrfavprojectlist.refresh();
    });
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_WHITE,
      key: globalFavouritePageKey,
      endDrawer: CustomDrawer(
        animatedOffset: const Offset(1.0, 0),
      ),
      drawer: CustomDrawer(
        animatedOffset: const Offset(-1.0, 0),
      ),
      body: SafeArea(
          child: Obx(()=> Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: APPBAR_HEIGHT),
                    favouriteProjectListData(),
                    const SizedBox(height: APPBAR_HEIGHT),
                  ],
                ),
              ),
              cntCommonHeader.commonAppBar(FAVORITE_APPNAME,
                  globalFavouritePageKey,color: white),
              Align(
                alignment: Alignment.bottomCenter,
                child: BottomNavigationBarClass(selectedIndex: 3),
              )
            ],
          ),)
      ),
    );
  }

  Widget favouriteProjectListData(){
    return Obx(() => FutureBuilder(
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasError) {
          if (cntFavorite.arrfavProjectlist.isNotEmpty) {
            return ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: cntFavorite.arrfavProjectlist.length,
                itemBuilder: (context, i) {
                  return _generateProjectListData(i);
                });
          }else {
            return Container(
              // height: Get.height / 2,
              height: Get.height / 2.5,
              width: Get.width,
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              child: Obx(() {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      cntFavorite.message.value,
                      style: TextStyle(
                          color: AppColors.TEXT_TITLE, fontSize: 15),
                    ),
                  ],
                );
              }),
            );
          }
        } else {
          return projectShimmerWidget();
          // return Container();
        }

      },
      future: cntFavorite.futurearrfavprojectlist.value,
    ));
  }

  Widget _generateProjectListData(int index){
    ProjectListModal obj = cntFavorite.arrfavProjectlist[index];
    return GestureDetector(
      onTap: () {
        onNavigatorFav(obj);
      },
      child: Container(
          height: 351.w,
          width: Get.width,
          margin: const EdgeInsets.only(bottom: 20),
          decoration: const BoxDecoration(),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: CarouselSlider.builder(
                  carouselController: cntFavorite.controller_event,
                  itemCount: obj.gallery?.gallaryListdata?.length,
                  itemBuilder: (context, index2, realIndex) {
                    return CachedNetworkImage(
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
                      obj.gallery?.gallaryListdata?[index2].icon ?? "",
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) {
                        return SvgPicture.network(
                          obj.gallery?.gallaryListdata?[index2].icon ?? "",
                          // IMG_BUILD4,
                          // height: 250,
                          width: Get.width,
                          fit: BoxFit.cover,
                        );
                      },
                    );
                  },
                  options: CarouselOptions(
                      autoPlay: true,
                      height: 211.w,
                      viewportFraction: 1,
                      onPageChanged: (index, _) {
                        cntFavorite.current.value = index;
                        cntFavorite.current.refresh();
                      }),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: Get.width,
                  height: 164.w,
                  margin: const EdgeInsets.symmetric(horizontal: 20),

                  decoration: CustomDecorations().backgroundlocal(white, 10, 0, white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10.w,right: 8.w,left: 8.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                width: 84.w, height: 84.w,
                                // placeholder: (context, url) => LeadShimmerWidget(),
                                fadeInDuration: Duration.zero,
                                fadeOutDuration: Duration.zero,
                                placeholderFadeInDuration: Duration.zero,
                                imageUrl: obj.featureimg ?? "",
                                // imageUrl:  obj.imageIcon??"",
                                fit: BoxFit.fill,
                                errorWidget: (context, url, error) {
                                  return SvgPicture.network(
                                      obj.featureimg ?? "",
                                      width: 84.w, height: 84.w,
                                      fit: BoxFit.fill
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(obj.projectname ?? "",
                                    style: boldTextStyle(
                                        fontSize: 15, txtColor: DARK_BLUE)),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(obj.area ?? "",
                                    style: mediumTextStyle(
                                        fontSize: 10, txtColor: new_black_color)),
                              ],
                            ),

                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      obj.configurationList!=null?SizedBox(
                        height: 42.w,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount:  obj.configurationList?.length,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.only(right: 8.w,left: 8.w),
                          itemBuilder: (BuildContext context, int i) {
                            return Container(
                              margin: const EdgeInsets.only(right: 10),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.h, vertical: 6.w),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      offset: const Offset(0, 0),
                                      color:
                                      APP_THEME_COLOR.withOpacity(0.1),
                                      spreadRadius: 0)
                                ],
                                color: hex("F5F6FA"),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    obj.configurationList![i].configuration??"",
                                    style: boldTextStyle(
                                        fontSize: 10, txtColor: DARK_BLUE),
                                    textAlign: TextAlign.center,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        obj.configurationList![i].price??"",
                                        style: boldTextStyle(
                                            fontSize: 10,
                                            txtColor: hex("707070")),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        "${obj.configurationList![i].onward??""}",
                                        style: regularTextStyle(
                                            fontSize: 10,
                                            txtColor: hex("707070")),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ):const SizedBox()
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 24.w,
                top: 25.w,
                child: GestureDetector(
                  onTap: () {
                    cntFavorite.RemoveFavouriteBottomSheet(index);
                  },
                  child: Container(
                      height: 35.w,
                      width: 35.w,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: HexColor("#FFFFFF").withOpacity(0.8),
                      ),
                      child: SvgPicture.asset(IMG_FAVORITE_SVG_2)
                  ),
                ),
              ),
            ],
          )

      ),
    );
  }

  Widget projectShimmerWidget() {
    return ShimmerEffect(
        child: ListView.builder(
          shrinkWrap: true,
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              // height: Get.height,
                margin: const EdgeInsets.only(bottom: 10,right: 20,left: 20),
                padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(0.w),
                      child: shimmerWidget(   height: 200 .h,
                          width: Get.width,radius: 10),
                    ),
                  ],
                ));
          },
          itemCount: 6,
        ));
  }

  onNavigatorFav(ProjectListModal obj){
    MoengageAnalyticsHandler().SendAnalytics({"project_id" : obj.sId, "project_name": obj.projectname},"project_details");
    Get.to(ProjectDetails(projectid: obj.sId.toString()),duration: const Duration(milliseconds: 0),);
  }
  onNavigator(ProjectListClass obj){
    Get.to(ProjectDetails(projectid: obj.name.toString()),duration: const Duration(milliseconds: 0),);
  }

}
