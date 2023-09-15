
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Model/PropertiesDetailModel/PropertiesDetailModel.dart';
import 'package:Repeople/View/FullImageViewPage/FullImageViewPage.dart';
import 'package:Repeople/View/GrievanceDetailsPage/GrievanceDetailsPage.dart';
import 'package:Repeople/View/GrievancePages/AddNewComplaintScreen.dart';
import 'package:Repeople/View/GrievancePages/ComplaintConversionScreen.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:Repeople/Config/Helper/HextoColor.dart';
import 'package:Repeople/Config/Helper/MoengageAnalyticsHandler.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:Repeople/Controller/ComplaintController/ComplaintListController.dart';
import 'package:Repeople/Model/ComplaintModel/ComplaintListModel.dart';
import 'package:Repeople/Widgets/ShimmerWidget.dart';
import '../../Config/Constant.dart';
import '../../Config/Function.dart';
import '../../Config/utils/Strings.dart';
import '../../Widgets/CommonBackButtonFor5theme.dart';
import '../../Widgets/CustomDecoration.dart';

class ComplaintListScreen extends StatefulWidget {
   final String? projectID;

   RxList<PropertiesDetailModel2>? myPropertiesDetailsList=RxList([]);
    ComplaintListScreen({Key? key, this.projectID,this.myPropertiesDetailsList}) : super(key: key);
  @override
  _ComplaintListScreenState createState() => _ComplaintListScreenState();
}

class _ComplaintListScreenState extends State<ComplaintListScreen> {
  ComplaintListController cnt_cmplist = Get.put(ComplaintListController());
  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());

  String? token;

  @override
  void initState() {
    super.initState();
    cnt_cmplist.project_id?.value=widget.projectID??"";
    cnt_cmplist.LoadPage();
  }

  date_data(String data) {
    var datef = DateFormat('dd MMM yyyy ');
    var timef = DateFormat(' hh:mm a');

    var inputDate = DateTime.parse(data.toString());
//  var outputFormat = DateFormat('MMM dd yyyy   hh:mm a');
    var outputDate = datef.format(inputDate);
    outputDate += 'at';
    outputDate += timef.format(inputDate);
    return outputDate;
    //print(outputDate);
  }

  String getdata(String str) {
    return str.length > 20 ? str.substring(0, 20) + "..." : str;
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: AppColors.BACKGROUND_WHITE,
          key: cnt_cmplist.complaintscaffoldKey,
          endDrawer: CustomDrawer(
            animatedOffset: Offset(1.0, 0),
          ),
          drawer: CustomDrawer(
            animatedOffset: Offset(-1.0, 0),
          ),
          body: RefreshIndicator(
              onRefresh: () async {
                //     cnt_lead.AllDataRefresh();
              },
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      controller: cnt_cmplist.scrollController,
                      child: Padding(
                        padding: EdgeInsets.only(top: 80.h),
                        child: Column(
                          children: [
                            ComplaintListView(),
                            cnt_cmplist.arrGrievanceList.isNotEmpty &&
                                    cnt_cmplist.arrGrievanceList.length > 2
                                ? SizedBox(
                                    height: 100,
                                  )
                                : SizedBox()
                          ],
                        ),
                      )),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child:    cnt_CommonHeader.commonAppBar(
                        COMPLAINT_APPMENUNAME_CAP, cnt_cmplist.complaintscaffoldKey,
                        color: AppColors.NEWAPPBARCOLOR),
                  ),
                ],
              ))),
    );
  }



  Widget _getGrievanceListData(int index) {
    GrievanceListModel obj = cnt_cmplist.arrGrievanceList[index];
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    return Column(
      children: [
        index==0? obj.resolvedbyname=="" &&obj.resolveddate==""?SizedBox():Container(
            height: Get.height / 2,
            width: Get.width,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  IMG_GRIEVANCE_SVG,
                  height: 160.h,
                  width: 160.w,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 24),
                Text(
                  "Yayy...",
                  style: mediumTextStyle(
                      txtColor: AppColors.TEXT_TITLE, fontSize: 12),
                ),
                SizedBox(height: 20),
                Text(
                  "All issues are resolved!",
                  style: mediumTextStyle(
                      txtColor: AppColors.TEXT_TITLE, fontSize: 12),
                ),
                SizedBox(height: 30),
                SubmitButton_4()
              ],
            )):SizedBox(),
        GestureDetector(
          onTap: (){
            // Get.to(grievance_details(id: obj.id ?? ""));
            MoengageAnalyticsHandler().SendAnalytics({"grievance_id" : obj.id},"grievance_details");
            Get.to(GrievanceDetailsPage(id: obj.id ??"",myPropertiesDetailsList:  widget.myPropertiesDetailsList,));
          },
          child: Container(
            padding: EdgeInsets.all(8.h),
            margin: EdgeInsets.only(left: 20.w, bottom: 10.h, right: 20.w, top: 0.h),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [fullcontainerboxShadow],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /*obj.resolvedbyname!="" && obj.resolveddate!=""?*/Container(
                  padding: EdgeInsets.symmetric(vertical: 6,horizontal: 8),
                  decoration: BoxDecoration(
                    color:/* HexColor(obj.color??"")*/hex("4DB6AC"),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text( "Resolved by ",
                            style: TextStyle(
                                fontSize: 9.sp,
                                color: white,
                                fontFamily: fontFamily,
                                fontWeight: FontWeight.w400),
                          ),
                          Text( obj.resolvedbyname??"",
                            style: TextStyle(
                                fontSize: 9.sp,
                                color: white,
                                fontFamily: fontFamily,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      Text( obj.resolveddate??"",
                        style: TextStyle(
                            fontSize: 9.sp,
                            color: white,
                            fontFamily: fontFamily,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                )/*:SizedBox()*/,
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      obj.grievancetypename??"",
                      style: boldTextStyle(
                          fontSize: 13,
                          txtColor: new_black_color,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                    Text(
                      '${obj.raiseId}',
                      style: boldTextStyle(
                          fontSize: 13,
                          txtColor: new_black_color,
                          fontWeight: FontWeight.w700
                      ),
                    ),


                    // SizedBox(
                    //   width: 200.w,
                    //   child: Text(
                    //     obj.project??"",
                    //     style: boldTextStyle(fontSize: 14, txtColor: AppColors.BLACK),
                    //   ),
                    // ),


                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     Text(
                    //       '' + obj.raiseId.toString(),
                    //       style: semiBoldTextStyle(
                    //         fontSize: 13,
                    //       ),
                    //     ),
                    //     SizedBox(width: 10),
                    //     Container(
                    //       alignment: Alignment.centerLeft,
                    //       decoration: BoxDecoration(
                    //         // color: Colors.grey[300],
                    //           borderRadius: BorderRadius.circular(15),
                    //           border: Border.all(
                    //               color: HexColor(obj.color ?? ""),
                    //               width: 0.5)),
                    //       child: Padding(
                    //         padding: EdgeInsets.only(
                    //             top: 5, bottom: 6, right: 10, left: 10),
                    //         child: Text(
                    //           obj.status ?? "",
                    //           style: mediumTextStyle(
                    //               fontSize: 10,
                    //               txtColor: HexColor(obj.color ?? "")),
                    //           maxLines: 1,
                    //           overflow: TextOverflow.ellipsis,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     if (obj.time != null && obj.time != "")
                    //     Text(
                    //     obj.time??"",
                    //       style: TextStyle(
                    //           fontSize: 9.sp,
                    //           color: gray_color_1,
                    //           fontFamily: fontFamily,
                    //           fontWeight: FontWeight.w600),
                    //     ),
                    //     SizedBox(width: 15),
                    //     SvgPicture.asset(
                    //       IMG_DOTS_MENU_SVG,
                    //       height: 20.h,
                    //       width: 20.w,
                    //     ),
                    //   ],
                    // )
                  ],
                ),
                SizedBox(height: 8.h),
                if (obj.project != null && obj.project != "")
                  Text(
                    obj.project??"",
                    style: TextStyle(
                        fontSize: 11.sp,
                        color: gray_color_1,
                        fontFamily: fontFamily,
                        fontWeight: FontWeight.w400),
                  ),
                SizedBox(height: 8.h),
                Obx(() => cnt_cmplist.arrGrievanceList[index].raiseimage!.isNotEmpty?Container(height: 52,child: _grievanceImageList(index)):Container()),
                SizedBox(height: cnt_cmplist.arrGrievanceList[index].raiseimage!.isNotEmpty?8.h:0),
                obj.message!=""?SizedBox(
                  width: 325.w,
                  child: Text(obj.message??"",
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: new_black_color,
                        fontFamily: fontFamily,
                        fontWeight: FontWeight.w500),
                  ),
                ):SizedBox(),
                SizedBox(height: 4.h),
                HorizontalDivider(
                    color: BORDER_GREY,
                    height: 1,
                    width: Get.width
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    obj.raisedby!=""? SizedBox(
                      width: 200.w,
                      child: Text(obj.raisedby??"",
                        style: TextStyle(
                            fontSize: 9.sp,
                            color: DARK_BLUE,
                            fontFamily: fontFamily,
                            fontWeight: FontWeight.w600),
                      ),
                    ):SizedBox(),
                    obj.grievancedate!=""?Text( obj.grievancedate??"",
                      style: TextStyle(
                          fontSize: 9.sp,
                          color: gray_color_1,
                          fontFamily: fontFamily,
                          fontWeight: FontWeight.w600),
                    ):SizedBox(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _grievanceImageList(int index){
    return  Container(
      height: 50.h,
      child: Wrap(
        children: [
          for(int i=0;i<cnt_cmplist.arrGrievanceList[index].raiseimage!.length;i++)
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: GestureDetector(
                    onTap: (){
                      Get.to(FullImageViewPage(
                          list: cnt_cmplist.arrGrievanceList[index].raiseimage!, index: i
                      ),
                      );
                    },
                    child: CachedNetworkImage(
                      width: 49.w,
                      height: 49.w,
                      fadeInDuration: Duration.zero,
                      fadeOutDuration: Duration.zero,
                      placeholderFadeInDuration: Duration.zero,
                      imageUrl: cnt_cmplist.arrGrievanceList[index].raiseimage![i],
                      placeholder: (context, url) => shimmerWidget(width: 49.w,
                          height: 49.w,radius: 7),
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) {
                        return Image.network(
                          cnt_cmplist.arrGrievanceList[index].raiseimage![i],
                        );
                      },
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget ShimmerWidget() {
    return ShimmerEffect(
        child: Container(
          child: ListView.builder(
              shrinkWrap: true,

              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) {
                return Padding(
                  padding: EdgeInsets.only(left:20,right: 20,bottom: 20),
                  child: shimmerWidget(width: Get.width, height: 100.w, radius: 10),
                );
              },
              itemCount: 6),
        ));
  }

  Widget ComplaintListView() {
    return Obx(() {
      return FutureBuilder(
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasError&&snapshot.hasError!=null) {
            if (cnt_cmplist.arrGrievanceList.isNotEmpty) {
              return Column(
                children: [
                     ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (_, index) {
                        return Obx(() {
                          return _getGrievanceListData(index);
                        });
                      },
                      itemCount: cnt_cmplist.arrGrievanceList.length,
                    ),

                  const SizedBox(height: 30),
                  Padding(
                      padding:  const EdgeInsets.only(left: 20.0,right: 20,bottom: 50),
                      child:cnt_cmplist.arrGrievanceList.isNotEmpty? cnt_cmplist.arrGrievanceList[0].resolvedbyname==""?SubmitButton_4():SizedBox():SizedBox()
                  )
                ],
              );
            } else {
              return Container(
                  height: Get.height / 2,
                  width: Get.width,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        IMG_GRIEVANCE_SVG,
                        height: 160.h,
                        width: 160.w,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 24),
                      // Text(
                      //   cnt_cmplist.message.value,
                      //   style: mediumTextStyle(
                      //       txtColor: AppColors.TEXT_TITLE, fontSize: 15),
                      // ),
                      Text(
                        "Yayy...",
                        style: mediumTextStyle(
                            txtColor: AppColors.TEXT_TITLE, fontSize: 12),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "All issues are resolved!",
                        style: mediumTextStyle(
                            txtColor: AppColors.TEXT_TITLE, fontSize: 12),
                      ),
                      SizedBox(height: 30),
                      SubmitButton_4()
                    ],
                  ));
            }
          } else {
            return ShimmerWidget();
          }
        },
        future: cnt_cmplist.futureGrievanceData.value,
      );
    });
  }

  Widget SubmitButton_1() {
    return Container(
      width: Get.width,
      padding: EdgeInsets.only(top: 30, bottom: 30),
      decoration: BoxDecoration(
          color: APP_THEME_COLOR,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(15), topLeft: Radius.circular(15))),
      child: Center(
        child: OnTapButton(
            onTap: () {
              MoengageAnalyticsHandler().track_event("add_grievance_page");
              Get.to(AddNewGrievance(myPropertiesDetailsList: widget.myPropertiesDetailsList,));
            },
            width: 200,
            height: 40,
            text: "Report a New Grievance",
            decoration: CustomDecorations()
                .backgroundlocal(white, cornarradius, 0, white),
            style: regularTextStyle(txtColor: APP_FONT_COLOR)
            // TextStyle(color: APP_FONT_COLOR)
            ),
      ),
    );
  }

  Widget SubmitButton_4() {
    return OnTapButton(
        onTap: () {
          MoengageAnalyticsHandler().track_event("add_grievance_page");
          Get.to(AddNewGrievance(myPropertiesDetailsList: widget.myPropertiesDetailsList,))?.then((value) {
            if (value != null) {
              cnt_cmplist.restart();
            }
          });
        },
        height: 40,
        width: Get.width,
        decoration: CustomDecorations()
            .backgroundlocal(APP_THEME_COLOR, cornarradius, 0, APP_THEME_COLOR),
        text: "Add New Grievance".toUpperCase(),
        style:
            TextStyle(color: white, fontSize: 14, fontWeight: FontWeight.w500));
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,

      //backgroundColor:bgcolor,
      elevation: 0,
      title: Center(
          child: Text(
        "Grievance",
        style: TextStyle(),
      )),
      // Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //   Text("Favourite",style: TextStyle(color: kdtextblack),),
      //   // Image(
      //   //     height: 50.0,
      //   //     width:50.0,image: AssetImage('assets/images/doctor.png'))
      // ],),
      leading: new GestureDetector(
        onTap: () {
          Get.back();
        },
        // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AppDrawer())
        // ),
        child: Icon(
          Icons.arrow_back_ios,
        ),
      ),
      actions: <Widget>[
        // Icon(Icons.share,color: Colors.blue,),
        // SizedBox(width: 20.0/2),
        // Image(
        //     height: 35,
        //     width: 35,image: AssetImage('assets/images/profile.png')),
        // SizedBox(width: 20.0/2),
        IconButton(
          icon: SvgPicture.asset(
            "assets/icon/menu.svg",
            height: 32,
            width: 20,
            // By default our  icon color is white
            color: Colors.black,
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}
