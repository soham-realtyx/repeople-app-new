
import 'dart:async';
import 'dart:ui';

import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Controller/ProjectDetailsController/ProjectDetailsController.dart';
import 'package:Repeople/View/DashboardPage/BottomnavigationBar.dart';
import 'package:Repeople/View/FullImageViewPage/FullImageViewPage.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/Helper/MoengageAnalyticsHandler.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:Repeople/Widgets/CustomAppBar.dart';
import 'package:Repeople/Widgets/ShimmerWidget.dart';



class ProjectGalleryScreen extends StatefulWidget {
  final String? projectid;
  const ProjectGalleryScreen({super.key,  this.projectid});

  @override
  _ProjectGalleryScreenState createState() => _ProjectGalleryScreenState();
}

class _ProjectGalleryScreenState extends State<ProjectGalleryScreen> {

  ProjectDetailsController cntProjectDetails = Get.put(ProjectDetailsController());
  CommonHeaderController cntHeaderController = Get.put(CommonHeaderController());
  late final ScrollController? controller=ScrollController();
  RxBool isVal=false.obs;
  late StreamSubscription<bool> keyboardSubscription;
  GlobalKey<ScaffoldState> globalProjectDetailsPageKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.BACKGROUND_WHITE,
      key: globalProjectDetailsPageKey,
      endDrawer: CustomDrawer(animatedOffset: const Offset(1.0,0),),
      body: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding:  EdgeInsets.only(top:70.h),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    galleryDataGridView()
                  ],
                ),
              ),
            ),
            // ),
            cntHeaderController.commonAppBar("Gallery", globalProjectDetailsPageKey,
              ),
            Align(
              alignment: Alignment.bottomCenter,
              child: BottomNavigationBarClass(),
            )
          ],
        ),
      ),
    );
  }

  Widget galleryDataGridView(){
    return Obx(() =>  FutureBuilder(
      builder: (_, snapshot)
      {
        if (snapshot.connectionState
            == ConnectionState.done && snapshot.data != null) {
          if (cntProjectDetails.obj_svprojectdetails.value.gallery!.gallerydata!.isNotEmpty) {
            return GridView.builder(
              itemCount:
              cntProjectDetails.obj_svprojectdetails.value.gallery?.gallerydata
                  ?.length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(left: 20, right: 20),
              physics: const ScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  focusColor: AppColors.TRANSPARENT,
                  highlightColor: AppColors.TRANSPARENT,
                  hoverColor: AppColors.TRANSPARENT,
                  splashColor: AppColors.TRANSPARENT,
                  onTap: () {
                    MoengageAnalyticsHandler().track_event("project_gallery_view");
                    Get.to(() => FullImageViewPage(
                        title: cntProjectDetails.obj_svprojectdetails.value
                            .gallery?.gallerydata?[index].name,
                        list: cntProjectDetails.gallerylist,
                        index: index));
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
                          placeholder: (context, url) => shimmerWidget( width: 120.w,
                              height: 120.h,radius: 8),
                          imageUrl: cntProjectDetails.obj_svprojectdetails
                              .value.gallery
                              ?.gallerydata?[index].icon ?? "",
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) {
                            return Image.asset(
                              cntProjectDetails.obj_svprojectdetails.value
                                  .gallery?.gallerydata?[index]
                                  .icon ?? "",
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                );
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
            );
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
                      cntProjectDetails.message.value,
                      style: TextStyle(
                          color: AppColors.TEXT_TITLE, fontSize: 15),
                    ),
                  ],
                );
              }),
            );
          }
        }else {
          return shimmerGalleryData();
          // return Container();
        }
      },
      future: cntProjectDetails.futureProjectdetailsData.value,
    ));
  }

  Widget shimmerGalleryData(){
    return ShimmerEffect(
        child:
        GridView.builder(
          shrinkWrap: true,
          primary: false,
          padding: const EdgeInsets.only(left: 20,right: 20),
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, i) {
            return
              Container(
                padding: const EdgeInsets.only(top: 0, left: LEFT_PADDING, right: 0),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                  color: APP_GRAY_COLOR,),
                width: 120.w,
                height: 120.h,

              );
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemCount: 4
          ,
        )
    );
  }
}



