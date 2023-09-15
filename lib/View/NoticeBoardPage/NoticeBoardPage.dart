import 'package:Repeople/Config/Helper/MoengageAnalyticsHandler.dart';
import 'package:Repeople/Config/Helper/TimeConverter.dart';
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:Repeople/View/DashboardPage/BottomnavigationBar.dart';
import 'package:Repeople/View/NoticeBoardPage/NoticeBoardDetailsPage.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Controller/NoticeBoardController/NoticeBoardController.dart';
import 'package:shimmer/shimmer.dart';
import '../../Config/utils/colors.dart';
import '../../Config/utils/styles.dart';
import '../../Model/UpdateModelClass/UpdateModelClass.dart';
import '../../Widgets/ShimmerWidget.dart';

class NoticeBoardPage extends StatefulWidget {
  @override
  NoticeBoardPageState createState() => new NoticeBoardPageState();
}

class NoticeBoardPageState extends State<NoticeBoardPage> {
  NoticeBoardController cnt_notice = Get.put(NoticeBoardController());
  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());
  @override
  Widget build(BuildContext context) {
    cnt_notice.arrAllTheme.clear();
    cnt_notice.arrReferralFAQList.clear();


    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_WHITE,
        key: cnt_notice.GlobalNoticePagekey,
        endDrawer: CustomDrawer(
          animatedOffset: Offset(1.0, 0),
        ),
        drawer: CustomDrawer(
          animatedOffset: Offset(-1.0, 0),
        ),
        // bottomNavigationBar: BottomNavigationBarClass(),
        body: SafeArea(
          child: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: SizedBox(height: APPBAR_HEIGHT,),),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Container(
                        width: Get.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListNoticeFuture()
                          ],
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
              cnt_CommonHeader.commonAppBar(
                  NOTICE_APPMENUNAME_CAP, cnt_notice.GlobalNoticePagekey,
                  color: white)
            ],
          ),
        ));
  }


  Widget ListNoticeFuture() {
    return  Obx(() {
      return
        FutureBuilder(
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null)
              return cnt_notice.arrNoticeLIst.length>0? Container(
                  padding: EdgeInsets.symmetric(horizontal: 0.0,vertical: 20),
                  child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: cnt_notice.arrNoticeLIst.length,
                      itemBuilder: (context,index){
                        UpdateModelClass obj=cnt_notice.arrNoticeLIst[index] ;
                        return NoticeBordDesign(index);

                      }
                  )
              ):Container(
                width: Get.width,
                height: 500,
                alignment: Alignment.center,
                child: Text("No Data Found", style: TextStyle(fontSize: 18, color: gray_color, fontWeight: FontWeight.w600, fontFamily: fontFamily,height: 1.5)),
              );
            else{
              return NoticeShimmerList();
            }
          },
          future: cnt_notice.futurearrNoticedatalist.value,
        );

    });
  }
  Widget NoticeList() {
    return Container(
      // height: 200,
      // color: Colors.orange,
      child: ListView.builder(
          padding: EdgeInsets.all(20),
          itemCount: cnt_notice.jobList.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return NoticeBordDesign(index);
          }),
    );
  }
  Widget NoticeBordDesign(int index) {
    UpdateModelClass obj = cnt_notice.arrNoticeLIst[index];
    return GestureDetector(
        onTap: () {
          // OnClickHandler(index);
          MoengageAnalyticsHandler().SendAnalytics({"notice_id":obj.id??"", "notice_name":obj.titile1 ?? ""},"notice_details");
          Get.to(()=>NoticeBoardDetailsPage( index: index,));
        },
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(cornarradius),
                  color: Colors.white,
                  boxShadow: [fullcontainerboxShadow]),
              child: Column(
                children: [
                  obj.document != "" && obj.document != null
                      ? Container(
                      width: Get.width,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: hex("f1f1f1"),
                              blurRadius: 0,
                              offset: Offset(0, 1),
                              spreadRadius: 0),
                        ],
                        borderRadius: BorderRadius.circular(cornarradius),
                      ),
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            enabled: true,
                            child: shimmerWidget(
                                height: 180, width: Get.width, radius: 0)),
                        fadeInDuration: Duration.zero,
                        fadeOutDuration: Duration.zero,
                        placeholderFadeInDuration: Duration.zero,
                        imageUrl: obj.document ?? "",
                        fit: BoxFit.fill,
                        errorWidget: (context, value, error) {
                          return Container(
                              color: Colors.grey.shade300,
                              child: Image.asset(
                                  cnt_notice.setImage(obj.extension.toString())));
                        },
                      ))
                      : SizedBox(),
                  Container(
                    padding:
                    EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  SizedBox(width: 5),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          obj.titile1 ?? "",
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: DARK_BLUE,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: fontFamily,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          timeAgoSinceDate(obj.dateTime.toString()),
                                          style: semiBoldTextStyle(
                                              txtColor: gray_color_1, fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
                top: 8.h,
                left: 8.w,
                child: obj.noticecategoryname!=""?Container(
                  padding: EdgeInsets.symmetric(vertical: 6.h,horizontal: 8.w),
                  decoration: BoxDecoration(
                      color: BLACK.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(6)
                  ),
                  child: Text(
                    obj.noticecategoryname??"",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: white,
                        fontSize: 8.sp,
                        fontFamily: fontFamily,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                ):SizedBox()
            )
          ],
        ));
  }

  Widget NoticeShimmerList(){
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        enabled: true,
        child: ListView.builder(
            itemCount: 5,
            shrinkWrap: true,
            primary: false,

            itemBuilder:(context,index){
              return Padding(
                padding: EdgeInsets.only(left: 20,right: 20,bottom: 15,top: 15),
                child: shimmerWidget(height: 200, width: Get.width, radius: 10),
              );
            } ));
  }

}
