import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:Repeople/Model/CommonModal/CommonModal.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:Repeople/Widgets/ShimmerWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Helper/MoengageAnalyticsHandler.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:shimmer/shimmer.dart';

import '../../Config/Constant.dart';
import '../../Config/Function.dart';
import '../../Config/utils/colors.dart';
import '../../Controller/MyBuildingDirectoryController/MyBuildingDirectoryController.dart';


class MyBuildingDirectoryPage extends StatefulWidget {
  final String? projectID;
  MyBuildingDirectoryPage({Key? key, this.projectID}) : super(key: key);

  @override
  State<MyBuildingDirectoryPage> createState() => _MyBuildingDirectoryPageState();
}

class _MyBuildingDirectoryPageState extends State<MyBuildingDirectoryPage>  with TickerProviderStateMixin{
  MyBuildingDirectoryController cnt_dir = Get.put(MyBuildingDirectoryController());
  ScrollController scrollController = ScrollController();
  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());
  @override
  void initState(){
    super.initState();
    cnt_dir.projectID.value=widget.projectID??"";
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

      cnt_dir.scrollController.addListener(() {
        cnt_dir.scrollUpdate(cnt_dir.scrollController);
      });
      cnt_dir.Indexselected.value=cnt_dir.arrOccupationList.length;
      cnt_dir.futureProjectListData.value=cnt_dir.RetrieveProjectListData().whenComplete((){
        cnt_dir.futureOccupationData.value=cnt_dir.RetrieveOccupationListData().whenComplete(() {

          // cnt_dir.categoryTabController=TabController(length: cnt_dir.arrOccupationList.length, vsync: this);
          // cnt_dir.futureDirectoryListData.value=cnt_dir.RetrieveBuildingDirectoryListData();
          cnt_dir.futureDirectoryListData.value=cnt_dir.RetrieveBuildingDirectoryListData();

          // if(cnt_dir.arrOccupationList.length>0){
          //   cnt_dir.categoryTabController.addListener(() {
          //     if (cnt_dir.categoryTabController.indexIsChanging)
          //     {
          //     }else{
          //       setState(() {
          //         cnt_dir.obj_Occupation.value=cnt_dir.arrOccupationList[cnt_dir.categoryTabController.index];
          //         cnt_dir.futureDirectoryListData.value=cnt_dir.RetrieveBuildingDirectoryListData(callinfromtab: true);
          //         cnt_dir.futureDirectoryListData.refresh();
          //       });
          //
          //     }
          //   });
          // }

        });
      });



    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return   GestureDetector(
        onTap: ()=>FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            backgroundColor: AppColors.BACKGROUND_WHITE,
            endDrawer: CustomDrawer(animatedOffset: Offset(1.0,0),),
            drawer: CustomDrawer(animatedOffset: Offset(-1.0,0),),
            resizeToAvoidBottomInset: false,
            key: cnt_dir.GlobalMyBUildingDirectorieskey,
            body: SafeArea(
              child: Container(
                // color:Colors.grey.shade200,
                child: Stack(
                  children: [
                    NotificationListener<OverscrollIndicatorNotification> (
                      child: RefreshIndicator(
                        displacement: 60,
                        onRefresh: cnt_dir.onRefresh,
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child:  CategoryView(),
                        ),
                      ),
                      onNotification: (overscroll) {
                        overscroll.disallowIndicator();
                        return true;
                      },
                    ),
                    cnt_CommonHeader.commonAppBar("My Building Directory", cnt_dir.GlobalMyBUildingDirectorieskey,
                      color: white,showSearch: false,iscentertitle: false,)


                  ],
                ),
              ),
            )),
      );
    });
  }

  Widget CategoryView(){
    return Obx(() {
      return  Column(
        children: [
          SizedBox(height: 80),
          BuildingDirectoryCategoryData(),
          SizedBox(height: 5),
          DirectoryData(),
          SizedBox(height: 20),

        ],
      );
    });

  }

  Widget BuildingDirectoryCategoryData(){
    return FutureBuilder(
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null)
          if(cnt_dir.arrOccupationList.isNotEmpty) {
            return Container(
              height: 56,
              child: ListView.builder(
                  padding: EdgeInsets.only(left: 20, right: 12),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: cnt_dir.arrOccupationList.length,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    CommonModal obj = cnt_dir.arrOccupationList[index];
                    return Obx(() => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          cnt_dir.Indexselected.value = index;
                          cnt_dir.obj_Occupation.refresh();
                          cnt_dir.Indexselected.refresh();
                          MoengageAnalyticsHandler().SendAnalytics({"occupation_id" : obj.id??"", "occupation_name":  obj.name??""},"occupation_filter_list");
                          cnt_dir.futureDirectoryListData.value=cnt_dir.RetrieveBuildingDirectoryListData(callinfromtab: true,Occupation_id: obj.id??"");
                          cnt_dir.arrDirectoryListList.refresh();
                          cnt_dir.futureDirectoryListData.refresh();
                          cnt_dir.futureOccupationData.refresh();
                          cnt_dir.arrOccupationList.refresh();

                        },
                        child: Container(
                          // margin: EdgeInsets.only(top: 2,bottom: 2),
                          // height: 56,
                          padding: EdgeInsets.only(right: 26,bottom: 8,left: 8,top: 8),
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(6.0)),
                            color: cnt_dir.Indexselected.value == index
                                ? DARK_BLUE
                                : white,
                            boxShadow: [
                              BoxShadow(
                                color: BLACK.withOpacity(0.05),
                                spreadRadius: 0,
                                blurRadius: 6,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),

                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: cnt_dir.Indexselected.value == index
                                          ? white
                                          : hex(obj.color??""),
                                      borderRadius: BorderRadius.circular(6)
                                  ),
                                  child: SvgPicture.network(
                                    obj.icon??"",
                                    fit: BoxFit.cover,
                                    color: cnt_dir.Indexselected.value == index
                                        ? DARK_BLUE
                                        : white,
                                    width: 26,
                                    height: 26,
                                  ),
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      obj.name ?? "0",
                                      style: TextStyle(
                                          color: cnt_dir.Indexselected.value == index
                                              ? white
                                              : BLACK,
                                          fontFamily: fontFamily,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.sp),
                                    ),
                                  ],
                                ),
                              ]),
                        ),
                      ),
                    ));
                  }),
            );
          } else{
            return Container(
              // height: 400,
              width: Get.width,
              child: Center(
                child: Text(""),
              ),
            );
          }
        else {
          return Container(
              height: 50,
              // padding: EdgeInsets.only(right: 10),
              child: ShimmerEffect(
                child: ListView.builder(
                  padding: EdgeInsets.only(left: 10,right: 10),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (_, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: shimmerWidget(width: 110, height: 50, radius: 10),
                    );
                  },
                  itemCount: 4,
                ),
              )
          );
        }
      },
      future: cnt_dir.futureOccupationData.value,
    );
  }

  Widget DirectoryData(){
    return Obx(() {
      return cnt_dir.arrOccupationList.length>0?  Container(
          constraints: BoxConstraints(
              maxHeight: Get.height,
              minHeight: 50
          ),
          child:  Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Container(
              // height: Get.height,
                child: Obx(() =>   FutureBuilder(
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.data != null) {
                      if(cnt_dir.arrDirectoryListList.isNotEmpty) {
                        return Obx(() =>
                            ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(bottom: 200.0),
                                controller: scrollController,
                                scrollDirection: Axis.vertical,
                                itemCount: cnt_dir.arrDirectoryListList.length,
                                physics: ScrollPhysics(),
                                itemBuilder: (context, ind2) {
                                  final obj = cnt_dir
                                      .arrDirectoryListList[ind2];
                                  return Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: BLACK.withOpacity(0.04),
                                            spreadRadius: 0,
                                            blurRadius: 6,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 8),
                                        child: Container(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width,
                                          child: Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .center,
                                              children: <Widget>[
                                                Column(
                                                  children: [
                                                    Container(
                                                      height: 84.w,
                                                      width: 84.w,
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius
                                                              .circular(10),
                                                          border: Border.all(
                                                              color: BACKGROUNG_GREYISH,
                                                              width: 2)
                                                      ),
                                                      child: obj.profile != null
                                                          ?
                                                      ClipRRect(
                                                        borderRadius: BorderRadius
                                                            .circular(10),
                                                        child: CachedNetworkImage(
                                                          height: 84.w,
                                                          width: 84.w,
                                                          placeholder: (context,
                                                              url) =>
                                                              ShimmerEffect(
                                                                child: shimmerWidget(
                                                                    height: 84
                                                                        .w,
                                                                    width: 84.w,
                                                                    radius: 10),
                                                              ),
                                                          fadeInDuration: Duration
                                                              .zero,
                                                          fadeOutDuration: Duration
                                                              .zero,
                                                          placeholderFadeInDuration: Duration
                                                              .zero,
                                                          imageUrl: obj.profile
                                                              .toString(),
                                                          fit: BoxFit.fill,
                                                          errorWidget: (context,
                                                              url, error) {
                                                            return SvgPicture
                                                                .network(
                                                                obj.profile
                                                                    .toString(),
                                                                height: 84.w,
                                                                width: 84.w,
                                                                fit: BoxFit.fill
                                                            );
                                                          },
                                                        ),
                                                      )
                                                          :
                                                      Container(
                                                        height: 84.w,
                                                        width: 84.h,
                                                        alignment: Alignment
                                                            .center,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius
                                                              .circular(10),
                                                          color: BACKGROUNG_GREYISH,
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .all(0), child:
                                                        Text(obj.personname!
                                                            .substring(0, 1)
                                                            .toString()
                                                            .toUpperCase(),
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                            boldTextStyle(
                                                                fontSize: 48,
                                                                txtColor: DARK_BLUE)
                                                        ),),
                                                      )
                                                      ,
                                                    ),
                                                  ],
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .start,
                                                    children: <Widget>[
                                                      obj.occupation != ""
                                                          ? Padding(
                                                        padding: EdgeInsets
                                                            .only(left: 15,
                                                            top: 0,
                                                            bottom: 5),
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                              horizontal: 5,
                                                              vertical: 3),
                                                          decoration: BoxDecoration(
                                                              color: cnt_dir
                                                                  .colorList[ind2 %
                                                                  cnt_dir
                                                                      .colorList
                                                                      .length],
                                                              borderRadius: BorderRadius
                                                                  .circular(6)
                                                          ),
                                                          child: Text(
                                                              obj.occupation!
                                                                  .toUpperCase(),
                                                              textAlign: TextAlign
                                                                  .center,
                                                              style:
                                                              TextStyle(
                                                                  fontSize: 10
                                                                      .sp,
                                                                  color: white,
                                                                  fontWeight: FontWeight
                                                                      .w600,
                                                                  fontFamily: fontFamily)
                                                            // TextStyle(fontSize: 12,color: Colors.grey,),
                                                          ),
                                                        ),)
                                                          : SizedBox(),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .only(left: 15,
                                                            top: 0,
                                                            bottom: 3),
                                                        child: Text(obj
                                                            .personname ?? '',
                                                            style:
                                                            TextStyle(
                                                                fontSize: 13.sp,
                                                                fontFamily: fontFamily,
                                                                fontWeight: FontWeight
                                                                    .w700,
                                                                color: DARK_BLUE
                                                            )
                                                          // TextStyle(fontSize: 15,fontWeight:FontWeight.bold,),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .only(left: 15,
                                                            top: 0,
                                                            bottom: 3),
                                                        child: Text(
                                                            '102, 1st Floor, B4, WorldHome Superstar',
                                                            style:
                                                            TextStyle(
                                                                fontSize: 10.sp,
                                                                fontFamily: fontFamily,
                                                                fontWeight: FontWeight
                                                                    .w500,
                                                                color: BLACK
                                                            )
                                                          // TextStyle(fontSize: 15,fontWeight:FontWeight.bold,),
                                                        ),
                                                      ),
                                                    ],),
                                                ),
                                                if(obj.mobile != null &&
                                                    obj.mobile !=
                                                        "") GestureDetector(
                                                    onTap: () {
                                                      cnt_dir.makePhoneCall(
                                                          obj.mobile != null
                                                              ? '+91 ' + obj
                                                              .mobile.toString()
                                                              : '');
                                                    },

                                                    child: Container(

                                                      // height: 40, width: 40,
                                                      padding: EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8.w,
                                                          vertical: 30.h),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius
                                                              .circular(6),
                                                          // shape: BoxShape.circle,
                                                          color: hex("F9F9F9")),
                                                      child: SvgPicture.asset(
                                                        IMG_CALL_NEW_SVG,
                                                        height: 24.w,
                                                        width: 24.h,
                                                        color: DARK_BLUE,),
                                                    )
                                                ),
                                              ]),),
                                      ),
                                    ),
                                    // ),
                                  );
                                }));
                      }else{
                        return
                          Container(
                            height: 400,
                            width: Get.width,
                            child: Center(
                              child: Text("No Data Found", style: boldTextStyle(fontSize: 14,fontWeight: FontWeight.w600,txtColor: BLACK),),
                            ),
                          );
                      }
                    } else{
                      return DirectoryShimmerEffect();
                    }
                  },
                  future: cnt_dir.futureDirectoryListData.value,
                ))
            ),
          )

      ):SizedBox();
    });

  }
  Widget DirectoryShimmerEffect() {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        enabled: true,
        child: ListView.builder(
            itemCount: 5,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder:(_,index){
              return   Container(
                padding: EdgeInsets.only(left: 10,right: 10,bottom: 20,top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shimmerWidget(height: 100, width: Get.width, radius: cornarradius),
                  ],
                ),
              );
            } )


    );
  }
}





