import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Model/Awards/AwardsModalNew.dart';
import 'package:Repeople/View/AwardsPage/AwardsDetailsPage.dart';
import 'package:Repeople/View/DashboardPage/BottomnavigationBar.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:Repeople/Widgets/ShimmerWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Controller/AwardsController/AwardsController.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';

class AwardsPage extends StatefulWidget {
  const AwardsPage({Key? key}) : super(key: key);

  @override
  _AwardsPageState createState() => _AwardsPageState();
}

class _AwardsPageState extends State<AwardsPage> {

  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());
  AwardsController cnt_Awards = Get.put(AwardsController());


  @override
  Widget build(BuildContext context) {
    cnt_Awards.arrAllTheme.clear();
    cnt_Awards.arrAwardsDataList.clear();
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_WHITE,
      key: cnt_Awards.GlobalAwardsPagekey,
      endDrawer: CustomDrawer(animatedOffset: Offset(1.0,0),),
      drawer: CustomDrawer(animatedOffset: Offset(-1.0,0),),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: APPBAR_HEIGHT),
                  Award_1(),
                  const SizedBox(height: APPBAR_HEIGHT),
                ],
              )
            ),
            cnt_CommonHeader.commonAppBar(
              AWARDS_APPMENUNAME_CAP,
              cnt_Awards.GlobalAwardsPagekey,
              color: AppColors.WHITE.withOpacity(0.0),
            ),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: BottomNavigationBarClass(),
            // ),
          ],
        ),
      ),
    );
  }
  Widget Award_1() {
    return FutureBuilder(
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasError) {
          if (cnt_Awards.arrAwardsDataListNew.isNotEmpty) {
            // return AwardsShimmerWidget1();
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(color: Colors.white),
                ),
                Obx(() {
                  // child:
                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return _generateAwards_1(index, context);
                    },
                    itemCount: cnt_Awards.arrAwardsDataListNew.length != 0
                        ? cnt_Awards.arrAwardsDataListNew.length
                        : 0,
                  );
                }),
              ],
            );
          } else {
            return Container(
              height: Get.height / 2,
              width: Get.width,
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              child:
              // Obx(() {
              //   return
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "No data found",
                    style: TextStyle(color: AppColors.TEXT_TITLE, fontSize: 15),
                  ),
                ],
              ),
              // }),
            );
          }
          //return LeadShimmerWidget();
        } else {
          return AwardsShimmerWidget1();
        }
      },
      future: cnt_Awards.futureawardsDatalistnew.value,
    );
  }
  Widget _generateAwards_1(int index, context) {
    AwardsNewModal obj = cnt_Awards.arrAwardsDataListNew[index];
    return InkWell(
        onTap: () {
          OnClickHandler(index);
          //showDialogFunc(context, obj.iconImage, obj.awardsTitle, obj.awardsDesc);
        },
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              decoration: BoxDecoration(
                  boxShadow: [fullcontainerboxShadow],
                  color: white,
                  borderRadius: BorderRadius.all(Radius.circular(cornarradius)),
                  border: Border.all(width: 1.2,color: white)
              ),
              //padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // padding: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          boxShadow: [fullcontainerboxShadow],
                          color: white,
                          borderRadius: BorderRadius.all(
                              Radius.circular(cornarradius))),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(cornarradius),
                        child: CachedNetworkImage(
                          // width: Get.width-10,
                          // placeholder: (context, url) => LeadShimmerWidget(),
                          fadeInDuration: Duration.zero,
                          fadeOutDuration: Duration.zero,
                          placeholderFadeInDuration: Duration.zero,
                          imageUrl: obj.awardimg ?? "",
                          // imageUrl: "https://s3.us-west-2.amazonaws.com/realtyxv2s3fullaccess/builder-8/awards/record-10/2019-08-01-071234_bc02c808-b42b-11e9-a396-02df5742e9fe.jpg",
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) {
                            return Image.network(
                              obj.awardimg ?? "",
                              width: Get.width,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 10,right: 10,left: 10,bottom: 10),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text( obj.awardcategory ??"Retail & Shopping Centre",
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: new_black_color,
                                fontWeight: FontWeight.w400,
                                fontFamily: fontFamily,
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Text(obj.awardname ?? "",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: DARK_BLUE,
                                fontWeight: FontWeight.w700,
                                fontFamily: fontFamily,
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Text(obj.shortdescription ?? "",
                              style: TextStyle(
                                  fontSize: 10.sp,
                                  color: new_black_color,
                                  fontFamily: fontFamily,
                                  fontWeight: FontWeight.w600
                              )),
                        ]),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget AwardsShimmerWidget1() {
    return ShimmerEffect(
        child: Container(
          // padding:
          // EdgeInsets.only(top: 10.h),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: shimmerWidget(width: Get.width, height: 200.h, radius: 10),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: shimmerWidget(width: Get.width, height: 200.h, radius: 10),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: shimmerWidget(width: Get.width, height: 200.h, radius: 10),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: shimmerWidget(width: Get.width, height: 200.h, radius: 10),
              ),
            ],
          ),
        ));
  }

  OnClickHandler(int index) {
    Get.to(()=>AwardsDetailsPage(index: index));
    // Get.bottomSheet(_generateAwards_Details(index), isScrollControlled: true);
  }
}

