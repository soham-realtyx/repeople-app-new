
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Controller/AwardsController/AwardsController.dart';
import 'package:Repeople/Model/Awards/AwardsModalNew.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:Repeople/Widgets/ShimmerWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';


class AwardsDetailsPage extends StatefulWidget {
  final int? index;
  AwardsDetailsPage( {this.index});

  @override
  _AwardsDetailsPageState createState() => _AwardsDetailsPageState();
}

class _AwardsDetailsPageState extends State<AwardsDetailsPage> {
  CommonHeaderController cnt_Header = Get.put(CommonHeaderController());
  AwardsController cnt_Awards = Get.put(AwardsController());
  GlobalKey<ScaffoldState> AwardsDetailsscaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_WHITE,
      key: AwardsDetailsscaffoldKey,
      endDrawer: CustomDrawer(animatedOffset: Offset(1.0,0),),
      drawer: CustomDrawer(animatedOffset: Offset(-1.0,0),),
      body: SafeArea(
          child: Stack(
            children: [
              // SizedBox(height: 70,),
              // SizedBox(height: 70,),
              SingleChildScrollView(child: Award_1()),
              cnt_Header.commonAppBar(AWARDS_APPMENUNAME_CAP, AwardsDetailsscaffoldKey,color: AppColors.NEWAPPBARCOLOR)
            ],
          )
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
            return SingleChildScrollView(child: awards_details());
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
  Widget awards_details() {
    AwardsNewModal obj = cnt_Awards.arrAwardsDataListNew[widget.index!];
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20,top: 80),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(height: 100,),
            SizedBox(
              height: 20,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(cornarradius),
              child: CachedNetworkImage(
                fadeInDuration: Duration.zero,
                fadeOutDuration: Duration.zero,
                placeholderFadeInDuration: Duration.zero,
                imageUrl: obj.awardimg ?? "",
                fit: BoxFit.fill,
                errorWidget: (context, url, error) {
                  return Image.asset(
                    IMG_AWARDS,
                    height: 250,
                    width: Get.width,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              obj.awardcategory ??"Retail & Shopping Centre",//category
              style: TextStyle(
                fontSize: 10.sp,
                color: new_black_color,
                fontWeight: FontWeight.w400,
                fontFamily: fontFamily,
              ),
            ),
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
              height: 15,
            ),
            Text(obj.longdescription ?? "",

                style: TextStyle(
                  fontSize: 11.sp,
                  color: new_black_color,
                  fontFamily: fontFamily,
                  fontWeight: FontWeight.w600,

                )),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
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
}
