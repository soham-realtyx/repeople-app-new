
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/View/DashboardPage/BottomnavigationBar.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Helper/TimeConverter.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:Repeople/Controller/NoticeBoardController/NoticeBoardController.dart';
import 'package:Repeople/Model/UpdateModelClass/UpdateModelClass.dart';
import 'package:shimmer/shimmer.dart';

import '../../Config/utils/Strings.dart';
import '../../Widgets/ShimmerWidget.dart';

class NoticeBoardDetailsPage extends StatefulWidget {
  final int index;
   NoticeBoardDetailsPage({Key? key,required this.index}) : super(key: key);

  @override
  State<NoticeBoardDetailsPage> createState() => _NoticeBoardDetailsPageState();
}

class _NoticeBoardDetailsPageState extends State<NoticeBoardDetailsPage> {
  NoticeBoardController cnt_NoticeDetails = Get.put(NoticeBoardController());
  CommonHeaderController cnt_HeaderController = Get.put(CommonHeaderController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.BACKGROUND_WHITE,
        key: cnt_NoticeDetails.GlobalNoticeDetailsPagekey,
      endDrawer: CustomDrawer(
        animatedOffset: Offset(1.0, 0),
      ),
      drawer: CustomDrawer(
        animatedOffset: Offset(-1.0, 0),
      ),
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 70),
                    Notice_board_details(widget.index),
                    SizedBox(height: 100),
                  ],
                ),
              ),
              cnt_HeaderController.commonAppBar("Notice",
                  cnt_NoticeDetails.GlobalNoticeDetailsPagekey,isNotificationHide: false),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: BottomNavigationBarClass(),
              // )
            ],
          ),
        ),
    );
  }
  Widget Notice_board_details(int index) {
    UpdateModelClass obj = cnt_NoticeDetails.arrNoticeLIst[index];
    return Container(
      decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(cornarradius)),
      margin: EdgeInsets.only(left: 20, right: 20,top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          obj.document != "" && obj.document != null
              ? Stack(
                children: [
                  Container(
            width: Get.width,
            // height: 436.h,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(6),
                    border: Border.fromBorderSide(
                        BorderSide(color: white,width: 2))),
            child: ClipRRect(
                  borderRadius:
                  BorderRadius.circular(6),
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        enabled: true,
                        child: shimmerWidget(
                            height: 180,
                            width: Get.width,
                            radius: 0)),
                    fadeInDuration: Duration.zero,
                    fadeOutDuration: Duration.zero,
                    placeholderFadeInDuration: Duration.zero,
                    imageUrl: obj.document ?? "",
                    fit: BoxFit.fill,
                    errorWidget: (context, value, error) {
                      return Container(
                          color: Colors.grey.shade300,
                          child: Image.asset(
                              cnt_NoticeDetails.setImage(obj.extension.toString())));
                    },
                  ),
            ),
          ),
                  Positioned(
                      top: 8.h,
                      left: 8.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 6.h,horizontal: 8.w),
                        decoration: BoxDecoration(
                            color: BLACK.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(6)
                        ),
                        child: Text(
                          "Commercial News",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: white,
                              fontSize: 8.sp,
                              fontFamily: fontFamily,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                      )
                  )
                ],
              )
              : SizedBox(),

          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 8,
                ),
                Text(obj.titile1 ?? "",
                    style: TextStyle(
                      fontSize: 15,
                      color: DARK_BLUE,
                      fontWeight: FontWeight.w700,
                      fontFamily: fontFamily,
                    )),
                SizedBox(
                  height: 4 ,
                ),
                Text(
                  timeAgoSinceDate(obj.dateTime.toString()),
                  style: semiBoldTextStyle(
                      txtColor: gray_color_1, fontSize: 10),
                ),
                SizedBox(
                  height: 10,
                ),

                Text(obj.description ?? "",
                    style: TextStyle(
                        fontSize: 10.sp,
                        color: new_black_color,
                        fontFamily: fontFamily,
                        height: 1.5)),

              ],
            ),
          ),

        ],
      ),
    );
    // return Container(color: GREEN,);
  }

}
