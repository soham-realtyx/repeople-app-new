import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Model/PropertiesDetailModel/PropertiesDetailModel.dart';
import 'package:Repeople/View/DashboardPage/BottomnavigationBar.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:Repeople/Widgets/ShimmerWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:Repeople/Controller/MyPropertiesController/MyPropertiesController.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';

class PaymentSchedulePage extends StatefulWidget {
   RxList objMyPropertiesDetails=RxList([]);
  PaymentSchedulePage({Key? key, required this.objMyPropertiesDetails}) : super(key: key);

  @override
  State<PaymentSchedulePage> createState() => _PaymentSchedulePageState();
}

class _PaymentSchedulePageState extends State<PaymentSchedulePage> {
  MyPropertiesController cnt_Myproperties = Get.put(MyPropertiesController());
  CommonHeaderController cnt_HeaderController = Get.put(CommonHeaderController());
  GlobalKey<ScaffoldState> GlobalAccountStatementPagekey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.BACKGROUND_WHITE,
      key: cnt_Myproperties.GlobalPaymentSchedulePagekey,
      endDrawer: CustomDrawer(animatedOffset: Offset(1.0,0),),
      drawer: CustomDrawer(animatedOffset: Offset(1.0,0),),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: APPBAR_HEIGHT),
                  PaymentScheduleHeaderData(),
                  SizedBox(height: 20.w),
                  PaymentScheduleData(),
                  SizedBox(height: 150.w),
                ],
              ),
            ),
            cnt_HeaderController.commonAppBar("Payment Schedule",
                cnt_Myproperties.GlobalPaymentSchedulePagekey),
            Align(
              alignment: Alignment.bottomCenter,
              child: BottomNavigationBarClass(),
            )
          ],
        ),
      ),
    );
  }

  Widget PaymentScheduleHeaderData(){
    return Container(
      child: Stack(
        children: [
          Obx(() =>   Container(
            height: 287.w,
            width: Get.width,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                      height: 211.w,
                      width: Get.width,
                      color: AppColors.APP_BLACK_38,
                      child:  Obx(() => CarouselSlider.builder(
                        carouselController: cnt_Myproperties.controller_propertiesDetail,
                        itemCount:  widget.objMyPropertiesDetails[0].gallery !=null &&
                            widget.objMyPropertiesDetails[0].gallery!.galleryListdata !=null &&
                            widget.objMyPropertiesDetails[0].gallery!.galleryListdata!.length!=0?
                        widget.objMyPropertiesDetails[0].gallery!.galleryListdata!.length : 0,
                        itemBuilder: (context, index2, realIndex) {
                          return InkWell(
                            onTap: () {
                              // Get.to(FullImageViewPage(
                              //     list: projectsliderimages, index: index));
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
                              imageUrl:
                              widget.objMyPropertiesDetails[0].gallery?.galleryListdata?[index2].icon.toString() ?? "",
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) {
                                return Image.network(
                                  widget.objMyPropertiesDetails[0].gallery?.galleryListdata?[index2].icon.toString() ?? "",
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
                              cnt_Myproperties.current.value = index;
                              cnt_Myproperties.current.refresh();
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
                        child:    Center(
                          child: Text(widget.objMyPropertiesDetails[0].unitroletype??"",
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
                              margin: EdgeInsets.only(left: 20,right: 20),
                              padding: EdgeInsets.only(
                                  top: 8.w, bottom: 8.w, right: 8.w, left: 8.w),
                              decoration: CustomDecorations()
                                  .backgroundlocal(white, 10, 0, white),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // if(obj_MypropertiesList.logosvg!=null)
                                      Container(
                                        color: BACKGROUNG_GREYISH,
                                        child:
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child:
                                          // Image.network(obj_MypropertiesList.featureimg??"")

                                          CachedNetworkImage(
                                            width: 84.w, height: 84.w,
                                            placeholder: (context, url) => shimmerWidget(  width: 90, height: 85,radius:8 ),
                                            fadeInDuration: Duration.zero,
                                            fadeOutDuration: Duration.zero,
                                            placeholderFadeInDuration: Duration.zero,
                                            imageUrl:  widget.objMyPropertiesDetails[0].featureimg??"",
                                            fit: BoxFit.fill,
                                            errorWidget: (context, url, error) {
                                              return SvgPicture.network(
                                                  widget.objMyPropertiesDetails[0].featureimg??"",
                                                  width: 84.w, height: 85.w, fit: BoxFit.fill
                                                // height: 20, width: 20
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.h,
                                      ),
                                      Obx(() =>  Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          if(widget.objMyPropertiesDetails[0].inventorytypeid=="1")
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text("${widget.objMyPropertiesDetails[0].plot?.replaceAll(" ", "")}${","}",
                                                    style: boldTextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w500,
                                                        txtColor: new_black_color)),
                                                SizedBox(
                                                  height: 2.w,
                                                ),
                                                Text(
                                                    widget.objMyPropertiesDetails[0].inventorytype??"",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 12.sp,
                                                        fontFamily: fontFamily,
                                                        color: new_black_color)),
                                              ],
                                            ),
                                          if(widget.objMyPropertiesDetails[0].inventorytypeid=="2")
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text("${widget.objMyPropertiesDetails[0].villa?.replaceAll(" ", "")}${","}",
                                                    style: boldTextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w500,
                                                        txtColor: new_black_color)),
                                                SizedBox(
                                                  width: 2.w,
                                                ),
                                                Text(
                                                    widget.objMyPropertiesDetails[0].inventorytype??"",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 12.sp,
                                                        fontFamily: fontFamily,
                                                        color: new_black_color)),
                                              ],
                                            ),

                                          if(widget.objMyPropertiesDetails[0].inventorytypeid=="3")
                                            Column(
                                              crossAxisAlignment:  CrossAxisAlignment.start,
                                              children: [
                                                Text(widget.objMyPropertiesDetails[0].unit.toString().replaceAll(" ", ""),
                                                    style: boldTextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700,
                                                        txtColor: DARK_BLUE)),
                                                SizedBox(
                                                  height: 5.h,
                                                ),
                                                Text(
                                                    widget.objMyPropertiesDetails[0].floor??"",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 12.sp,
                                                        fontFamily: fontFamily,
                                                        color: new_black_color)),
                                              ],
                                            ),

                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          Text(
                                              widget.objMyPropertiesDetails[0].project??"",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 12.sp,
                                                  fontFamily: fontFamily,
                                                  color: new_black_color)),
                                          SizedBox(
                                            height: 2.h,
                                          ),
                                          Text(widget.objMyPropertiesDetails[0].area ?? "",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12.sp,
                                                  fontFamily: fontFamily,
                                                  color: new_black_color)),
                                        ],
                                      )),
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
                                    padding: EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 4),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
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
      ),
    );
  }

  Widget PaymentScheduleData(){
    return Obx(() {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.WHITE,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: BORDER_GREY,width: 1.2),
          boxShadow: [
            BoxShadow(
              color: hex("A5A3AE").withOpacity(0.03),
              // spreadRadius: 3,
              blurRadius: 4,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: ListView.builder(
          itemCount: cnt_Myproperties.arrPaymentScheduleList.length,
          // padding: EdgeInsets.only(left: 20,right: 20,bottom: 10,top: 10),
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            PropertiesExploreModel objProperties = cnt_Myproperties.arrPaymentScheduleList[index];
            return
              Obx(() => Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Theme(
                      data: ThemeData().copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        backgroundColor:white,
                        expandedAlignment: Alignment.centerLeft,
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        tilePadding: EdgeInsets.only(left: 20,right: 20,bottom: 8,top: 8),
                        maintainState: false,
                        initiallyExpanded: false,
                        title: Text(objProperties.title ?? "",
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: LIGHT_GREY_COLOR,
                                fontWeight: FontWeight.w600,
                                fontFamily: fontFamily,
                                height: 1.5)),
                        subtitle: Text(objProperties.subTitle ?? "",
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: DARK_BLUE,
                                fontWeight: FontWeight.w600,
                                fontFamily: fontFamily,
                                height: 1.8)),
                        onExpansionChanged: (value) {
                          objProperties.isOpen?.value=value;
                        },
                        trailing:objProperties.isOpen?.value!=true?SvgPicture.asset(IMG_PLUS_SVG):SvgPicture.asset(IMG_MINUS_SVG),
                        children: [
                          if(cnt_Myproperties.arrPaymentScheduleList[index].subList!=null)
                            for(int i=0;i<objProperties.subList!.length; i++)
                              Container(
                                width: Get.width,
                                padding: EdgeInsets.only(top: 12.0.w,left: 20.h,bottom: 16.w,right: 20.h),
                                decoration: BoxDecoration(
                                    color: BACKGROUNG_GREYISH,
                                    border: Border(left: BorderSide(width: 4,color: DARK_BLUE))
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      objProperties.subList![i].subTitle??"",
                                      style: TextStyle(
                                          color:LIGHT_GREY_COLOR,
                                          fontSize: 12.sp,
                                          fontFamily: fontFamily,
                                          fontWeight: FontWeight.w400
                                      ),
                                    ),
                                    SizedBox(height: 5,),
                                    Text(
                                      objProperties.subList![i].title??"",
                                      style: TextStyle(
                                          color:DARK_BLUE,
                                          fontSize: 14.sp,
                                          fontFamily: fontFamily,
                                          fontWeight: FontWeight.w700
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                        ],
                      ),
                    ),
                    Container(
                      width: Get.width,
                      height: 1,
                      color: BORDER_GREY,
                    )
                  ],
                ),
              ));
          },

        ),
      );
    });
  }

}
