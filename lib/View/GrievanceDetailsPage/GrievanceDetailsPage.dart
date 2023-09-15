import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Model/PropertiesDetailModel/PropertiesDetailModel.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:Repeople/Widgets/ShimmerWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:Repeople/Controller/ComplaintController/ComplaintListController.dart';
import 'package:Repeople/Model/ComplaintModel/ComplaintListModel.dart';
import '../../Config/Constant.dart';
import '../../Config/Function.dart';
import '../../Widgets/CustomDecoration.dart';

class GrievanceDetailsPage extends StatefulWidget {
  final String? id;
  RxList<PropertiesDetailModel2>? myPropertiesDetailsList=RxList([]);
   GrievanceDetailsPage({super.key, required this.id,this.myPropertiesDetailsList});

  @override
  _GrievanceDetailsPageState createState() => _GrievanceDetailsPageState();
}

class _GrievanceDetailsPageState extends State<GrievanceDetailsPage> {
  ComplaintListController cntCmpList = Get.put(ComplaintListController());
  CommonHeaderController cntCommonHeader = Get.put(CommonHeaderController());

  String? token;

  @override
  void initState() {
    super.initState();

    // cnt_cmplist.LoadPage();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: AppColors.BACKGROUND_WHITE,
          key: cntCmpList.DetailsscaffoldKey,
          endDrawer: CustomDrawer(
            animatedOffset: const Offset(1.0, 0),
          ),
          drawer: CustomDrawer(
            animatedOffset: const Offset(-1.0, 0),
          ),
          body: RefreshIndicator(
              onRefresh: () async {

              },
              child: Stack(
                children: <Widget>[
                  SingleChildScrollView(
                      physics: const ScrollPhysics(),
                      // controller: cnt_cmplist.scrollController,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 70),
                        child: Column(
                          children: [
                            widget.myPropertiesDetailsList!=null?grievanceDetailsHeader():SizedBox(),
                            grievanceDetailsList(),
                            const SizedBox(height: 50),
                          ],
                        ),
                      )),
                     cntCommonHeader.commonAppBar(COMPLAINT_APPMENUNAME_CAP, cntCmpList.DetailsscaffoldKey,color: AppColors.NEWAPPBARCOLOR),
                ],
              ))),
    );
  }

  Widget grievanceDetailsHeader(){
    return Stack(
      children: [
        Container(
          height: 126.h,
          decoration: BoxDecoration(
            color: white,
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: 50.h,
            width: Get.width,
            decoration: BoxDecoration(
              color: DARK_BLUE,
            ),
          ),
        ),
        Positioned(bottom: 0,right: 0,left: 0,child: Align(
          alignment: Alignment.bottomCenter,
          child:Stack(
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
                            child: CachedNetworkImage(
                              width: 84.w, height: 84.w,
                              placeholder: (context, url) => shimmerWidget(  width: 90, height: 85,radius:8 ),
                              fadeInDuration: Duration.zero,
                              fadeOutDuration: Duration.zero,
                              placeholderFadeInDuration: Duration.zero,
                              imageUrl:  widget.myPropertiesDetailsList?[0].featureimg??"",
                              fit: BoxFit.fill,
                              errorWidget: (context, url, error) {
                                return SvgPicture.network(
                                    widget.myPropertiesDetailsList?[0].featureimg??"",
                                    width: 84.w, height: 85.w, fit: BoxFit.fill
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
                            if(widget.myPropertiesDetailsList?[0].inventorytypeid=="1")
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("${widget.myPropertiesDetailsList?[0].plot?.replaceAll(" ", "")}${","}",
                                      style: boldTextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          txtColor: new_black_color)),
                                  SizedBox(
                                    height: 2.w,
                                  ),
                                  Text(
                                      widget.myPropertiesDetailsList?[0].inventorytype??"",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.sp,
                                          fontFamily: fontFamily,
                                          color: new_black_color)),
                                ],
                              ),
                            if(widget.myPropertiesDetailsList?[0].inventorytypeid=="2")
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("${widget.myPropertiesDetailsList?[0].villa?.replaceAll(" ", "")}${","}",
                                      style: boldTextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          txtColor: new_black_color)),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  Text(
                                      widget.myPropertiesDetailsList?[0].inventorytype??"",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.sp,
                                          fontFamily: fontFamily,
                                          color: new_black_color)),
                                ],
                              ),

                            if(widget.myPropertiesDetailsList!=null&&widget.myPropertiesDetailsList?[0].inventorytypeid=="3")
                              Column(
                                crossAxisAlignment:  CrossAxisAlignment.start,
                                children: [
                                  Text(widget.myPropertiesDetailsList![0].unit.toString().replaceAll(" ", ""),
                                      style: boldTextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          txtColor: DARK_BLUE)),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Text(
                                      widget.myPropertiesDetailsList?[0].floor??"",
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
                                widget.myPropertiesDetailsList?[0].project??"",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12.sp,
                                    fontFamily: fontFamily,
                                    color: new_black_color)),
                            SizedBox(
                              height: 2.h,
                            ),
                            Text(widget.myPropertiesDetailsList?[0].area ?? "",
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
        ),)
      ],
    );
  }

  Widget grievanceDetailsList(){
    return Obx(() => ListView.builder(
      itemCount: cntCmpList.arrGrievanceDetailsList.length,
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
        NewGrievanceDetailsModel objGrievance = cntCmpList.arrGrievanceDetailsList[index];
          if (objGrievance.senderType == "2") {
            return senderGrievanceCard(
                  userName: objGrievance.userName??"",
                  date: objGrievance.date??"",
                  title: objGrievance.title??"",
                  message: objGrievance.msg??"",
              mylistwidget: objGrievance.mylist
                );
          } else if (objGrievance.senderType == "1") {
            return myGrievanceCard(
              userName: objGrievance.userName??"",
              date: objGrievance.date??"",
              title: objGrievance.title??"",
              message: objGrievance.msg??"",
                mylistwidget: objGrievance.images
            );
          }else{
            return const Text("");
          }
        },
    ));
  }


  Widget myGrievanceCard({String? title,List? mylistwidget,String? message,String? userName,String? date}){
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin:  const EdgeInsets.only(right: 20,left: 50,bottom: 12),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: hex("CCE2F0"),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title??"",
              style: boldTextStyle(
                  fontSize: 13,
                  txtColor: new_black_color,
                  fontWeight: FontWeight.w700
              ),
            ),
            SizedBox(height: 4.h),
            mylistwidget!=null?SizedBox(
              height: mylistwidget!=null?50:0,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: const ScrollPhysics(),
                children: [
                  if(mylistwidget!=null)
                    for(int i=0;i<mylistwidget.length;i++)
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                            child: Image.asset(mylistwidget[i],width: 49,height: 49,fit: BoxFit.cover)),
                      )
                ],
              ),
            ):const SizedBox(),
            SizedBox(height: 4.h),
            SizedBox(
              width: 270.w,
              child: Text(message??"",
                style: TextStyle(
                    fontSize: 12.sp,
                    color: new_black_color,
                    fontFamily: fontFamily,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: 4.h),
            HorizontalDivider(
              color: white,
              height: 1,
              width: Get.width
            ),
            SizedBox(height: 4.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 140.w,
                  child: Text(userName??"",
                    style: TextStyle(
                        fontSize: 9.sp,
                        color: DARK_BLUE,
                        fontFamily: fontFamily,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Text( date??"",
                  style: TextStyle(
                      fontSize: 9.sp,
                      color: gray_color_1,
                      fontFamily: fontFamily,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget senderGrievanceCard({String? title,List? mylistwidget,String? message,String? userName,String? date}){
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin:  const EdgeInsets.only(right: 50,left: 20,bottom: 12,),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title!=""?Text(
              title??"",
              style: boldTextStyle(
                  fontSize: 13,
                  txtColor: new_black_color,
                  fontWeight: FontWeight.w700
              ),
            ):const SizedBox(),
            SizedBox(height: 4.h),

            message!=""?SizedBox(
              width: 270.w,
              child: Text(message??"",
                style: TextStyle(
                    fontSize: 12.sp,
                    color: new_black_color,
                    fontFamily: fontFamily,
                    fontWeight: FontWeight.w500),
              ),
            ):const SizedBox(),
            SizedBox(height: 6.h),
            mylistwidget!=null?SizedBox(
              height: mylistwidget!=null?25:0,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: const ScrollPhysics(),
                children: [
                  if(mylistwidget!=null)
                    for(int i=0;i<mylistwidget.length;i++)
                      Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.only(left: 12,top: 0,right: 12,bottom: 0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(34),
                              border: Border.all(width: 1,color: DARK_BLUE)
                          ),
                          child: Center(
                            child: Text(
                              mylistwidget[i],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: DARK_BLUE,
                                fontWeight: FontWeight.w600,
                                fontFamily: fontFamily,
                                fontSize: 10.sp,
                              ),
                            ),
                          )
                      )
                ],
              ),
            ):const SizedBox(),
            SizedBox(height: 6.h),

            HorizontalDivider(
                color: BORDER_GREY,
                height: 1,
                width: Get.width
            ),
            SizedBox(height: 4.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 140.w,
                  child: Text(userName??"",
                    style: TextStyle(
                        fontSize: 9.sp,
                        color: DARK_BLUE,
                        fontFamily: fontFamily,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Text( date??"",
                  style: TextStyle(
                      fontSize: 9.sp,
                      color: gray_color_1,
                      fontFamily: fontFamily,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
