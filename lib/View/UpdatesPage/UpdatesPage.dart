import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/View/UpdatesPage/UpdateDetailsPage.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../Config/Function.dart';
import '../../Config/utils/Images.dart';
import '../../Config/utils/Strings.dart';
import '../../Config/utils/colors.dart';
import '../../Controller/BottomNavigator/BottomNavigatorController.dart';
import '../../Controller/UpdatesController/UpdatesController.dart';
import '../../Model/UpdateModelClass/UpdateModelClass.dart';
import '../../Widgets/CommonBackButtonFor5theme.dart';
import '../../Widgets/CustomAppBar.dart';
import '../../Widgets/ShimmerWidget.dart';

typedef void OnTapPress();

class UpdatesPage extends StatefulWidget {
  UpdatesPage({Key? key}) : super(key: key);

  @override
  _UpdatesPageState createState() => _UpdatesPageState();
}

class _UpdatesPageState extends State<UpdatesPage>
    with TickerProviderStateMixin {
  UpdatesController cnt_updates = Get.put(UpdatesController());
  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());
  GlobalKey<ScaffoldState> updatesscaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    scrollController.addListener(() {
      cnt_updates.scrollUpdate(scrollController);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //Get.delete<DashboardController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_WHITE,
      key: cnt_updates.GlobalUpdatesPagekey,
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
                 SizedBox(height: APPBAR_HEIGHT),
                 ListUpdatesFuture(),
               ],
             ),
           ),
        cnt_CommonHeader.commonAppBar(UPDATES_APPMENUNAME_CAP, cnt_updates.GlobalUpdatesPagekey,color: white),
          ],
        ),
      ),
    );
  }


  OnClickHandler(int index) {
    // Get.bottomSheet(updates_details(index), isScrollControlled: true);
    Get.to(()=>UpdateDetailsPage(index: index,));
  }

  Widget updates_details(int index) {
    UpdateModelClass obj = cnt_updates.arrUpdateList[index];
    return Container(
      height: Get.height * 0.9,
      decoration:
      BoxDecoration(borderRadius: BorderRadius.circular(cornarradius)),
      child: Stack(
        children: [
          Container(
            height: Get.height * 0.4,
            color: Colors.transparent,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(cornarradius)),
              height: (Get.height * 0.86) /*-50*/,
              padding: EdgeInsets.only(left: 20, right: 20),
              child: SingleChildScrollView(
                // physics: NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SizedBox(height: 100,),
                    SizedBox(
                      height: 20,
                    ),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(cornarradius),
                        child: Container(
                            width: Get.width,
                            height: 190.h,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1.5, color: white),
                              borderRadius:
                              BorderRadius.circular(7),
                            ),
                            child: ClipRRect(
                              borderRadius:
                              BorderRadius.circular(7),
                              child: CachedNetworkImage(
                                // width: Get.width-10,
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                        baseColor:
                                        Colors.grey.shade300,
                                        highlightColor:
                                        Colors.grey.shade100,
                                        enabled: true,
                                        child: shimmerWidget(
                                            height: 180,
                                            width: Get.width,
                                            radius: 0)),
                                fadeInDuration: Duration.zero,
                                fadeOutDuration: Duration.zero,
                                placeholderFadeInDuration:
                                Duration.zero,
                                imageUrl: obj.document ?? "",
                                fit: BoxFit.fill,
                                errorWidget:
                                    (context, value, error) {
                                  return Container(
                                      color: Colors.grey.shade300,
                                      child: GestureDetector(
                                          onTap: () {},
                                          child: Image.asset(
                                              cnt_updates.setImage(obj
                                                  .extension
                                                  .toString()))));
                                },
                              ),
                            ))),

                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 310,
                      child: Text(obj.titile ?? "",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: DARK_BLUE,
                            fontWeight: FontWeight.w700,
                            fontFamily: fontFamily,
                          )),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Text(obj.dateTime ?? "",
                        style: TextStyle(
                            fontSize: 10.sp,
                            color: gray_color_1,
                            fontFamily: fontFamily,
                            fontWeight: FontWeight.w600)),

                    SizedBox(
                      height: 10,
                    ),
                    //Text(obj.desc!,style:  TextStyle(
                    Text(obj.description ?? "",
                        style: TextStyle(
                            fontSize: 10.sp,
                            color: gray_color_1,
                            fontFamily: fontFamily,
                            fontWeight: FontWeight.w600
                        )),

                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 5,right: 5),
          //   child: Card(
          //     clipBehavior: Clip.hardEdge,
          //     shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.all(Radius.circular(cornarradius))
          //     ),
          //     child: Image.asset(obj.image!,height: 180,width:Get.width,fit: BoxFit.fill,),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget ListUpdatesFuture() {
    return Obx(() {
      return FutureBuilder(
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            return cnt_updates.arrUpdateList.length > 0
                ? Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
                child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: cnt_updates.arrUpdateList.length,
                    itemBuilder: (context, index) {
                      UpdateModelClass obj =
                      cnt_updates.arrUpdateList[index];
                      return GestureDetector(
                        onTap: () {
                          OnClickHandler(index);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            obj.document != "" && obj.document != null
                                ? Container(

                                width: Get.width,
                                height: 190.h,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1.5, color: white),
                                  borderRadius:
                                  BorderRadius.circular(7),
                                ),
                                child: ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(7),
                                  child: CachedNetworkImage(
                                    // width: Get.width-10,
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                            baseColor:
                                            Colors.grey.shade300,
                                            highlightColor:
                                            Colors.grey.shade100,
                                            enabled: true,
                                            child: shimmerWidget(
                                                height: 180,
                                                width: Get.width,
                                                radius: 0)),
                                    fadeInDuration: Duration.zero,
                                    fadeOutDuration: Duration.zero,
                                    placeholderFadeInDuration:
                                    Duration.zero,
                                    imageUrl: obj.document ?? "",
                                    fit: BoxFit.fill,
                                    errorWidget:
                                        (context, value, error) {
                                      return Container(
                                          color: Colors.grey.shade300,
                                          child: GestureDetector(
                                              onTap: () {},
                                              child: Image.asset(
                                                  cnt_updates.setImage(obj
                                                      .extension
                                                      .toString()))));
                                    },
                                  ),
                                ))
                                : SizedBox(),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  SizedBox(
                                    width: 310,
                                    child: Text(obj.titile ?? "",
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: DARK_BLUE,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: fontFamily,
                                        )),
                                  ),
                                  SizedBox(
                                    height: 6.h,
                                  ),
                                  Text(obj.dateTime ?? "",
                                      style: TextStyle(
                                          fontSize: 10.sp,
                                          color: gray_color_1,
                                          fontFamily: fontFamily,
                                          fontWeight: FontWeight.w600)),
                                  // SizedBox(
                                  //   height: 10,
                                  // ),
                                  // Text(obj.description ?? "",
                                  //     style: TextStyle(
                                  //         fontSize: 10.sp,
                                  //         color: gray_color_1,
                                  //         fontFamily: fontFamily,
                                  //         fontWeight: FontWeight.w600)),
                                  // SizedBox(
                                  //   height: 15.0,
                                  // )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }))
                : Container(
              width: Get.width,
              height: 500,
              alignment: Alignment.center,
              child: Text("No Data Found",
                  style: TextStyle(
                      fontSize: 18,
                      color: gray_color,
                      fontWeight: FontWeight.w600,
                      fontFamily: fontFamily,
                      height: 1.5)),
            );
          } else {
            return UpdateShimmerList();
          }
        },
        future: cnt_updates.futurearrupdatetdatalist.value,
      );
    });
  }

  Widget UpdateShimmerList() {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        enabled: true,
        child: ListView.builder(
            itemCount: 5,
            shrinkWrap: true,
            primary: false,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 20,left: 20,top: 10),
                child: shimmerWidget(height: 200, width: Get.width, radius: 10),
              );
            }));
  }
}
