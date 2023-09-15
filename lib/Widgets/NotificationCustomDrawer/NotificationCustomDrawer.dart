import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:Repeople/Controller/NotificationController/NotificationController.dart';
import 'package:Repeople/Model/NotificationsModal/NotificationNewModel.dart';
import 'package:Repeople/Widgets/ShimmerWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Widgets/Animation/AnimatedDrawer.dart';
import 'package:shimmer/shimmer.dart';

import '../../Controller/NotificationController/NotificationDrawerController.dart';

class NotificationCustomDrawer extends StatefulWidget {

  final Offset? animatedOffset;
  const NotificationCustomDrawer({super.key, this.animatedOffset});
  @override
  _NotificationCustomDrawerState createState() => _NotificationCustomDrawerState();
}

class _NotificationCustomDrawerState extends State<NotificationCustomDrawer> {
  NotificationDrawerController drawerController = Get.put(NotificationDrawerController());
  NotificationController cntNotification=Get.put(NotificationController());
  CommonHeaderController cntHeaderController = Get.put(CommonHeaderController());
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.8),
      key: drawerController.GlobalNotificationkey,
      body: /*Obx(() =>   AnimatedDrawer(
        offset: widget.animatedOffset,
        duration: Duration(milliseconds: 800),*/
       // child:
        SafeArea(child: Drawer1()),
      // ),
      // ),
    );
  }

  Widget Drawer1() {
    print(Is_Login.value);
    return SafeArea(
      child: Align(
        alignment: Alignment.centerRight,
        child: Stack(
          children: [
            Container(
              // width: 320.w,
              width: Get.width,
              height: Get.height,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: APP_GRAY_COLOR,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(0),
                      bottomLeft: Radius.circular(0))),
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    const SizedBox(height: 112 ),
                    //NotificationStatusData(),
                    //SizedBox(height: 20),
                    NotificationListData(),
                  ],
                ),
              ),
            ),
            // Positioned(top: 0,child: DrawerHeader_1(),)
           cntHeaderController.commonAppBar("Notifications", drawerController.GlobalNotificationkey),
          ],
        ),
      ),
    );
  }

  Widget drawerHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 0,right: 20,left: 20),
      decoration: BoxDecoration(
          color: APP_THEME_COLOR,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(0),
          )),
      height: 88.h,
      width: Get.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Notifications",
            style: TextStyle(
              color: white,
              fontSize: 14.sp,
              fontFamily: fontFamily,
              fontWeight: FontWeight.w700,
            ),
          ),
          CloseIcon()
        ],
      ),
    );
  }

  Widget NotificationStatusData(){
    return Container(
      margin: EdgeInsets.only(left: 20,right: 20),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Invitation to Manage",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: fontFamily,
                    fontSize: 12.sp,
                    color: new_black_color
                ),
              ),
              Text("11hr ago",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: fontFamily,
                    fontSize: 8.sp,
                    color: gray_color_1
                ),
              ),

            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  width:40.w,
                  height: 40.h,
                  fadeInDuration: Duration.zero,
                  fadeOutDuration: Duration.zero,
                  placeholderFadeInDuration: Duration.zero,
                  imageUrl: MANAGE_MEMBERS_PNG_IMAGE,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) {
                    return Image.asset(MANAGE_MEMBERS_PNG_IMAGE,
                        width:40.w,
                        height: 40.h,
                        fit: BoxFit.cover
                    );

                  },
                ),
              ),
              SizedBox(width: 10),
              SizedBox(
                width: 210,
                child: Text(
                  "Radha Goswami has requested you to manage 602, B4, WorldHome Superstar as Co-owner.",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: fontFamily,
                      fontSize: 10.sp,
                      color: LIGHT_GREY_COLOR
                  ),

                ),
              )
            ],
          ),
          SizedBox(height: 10),
          Container(
            width: Get.width,
            height: 1,
            color: BORDER_GREY,
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 20.0,right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Custom_Button(onTap: (){},text: "Accept",color: DARK_BLUE),
                SizedBox(width: 8),
                Custom_Button(onTap: (){},text: "Reject",color: AppColors.RED),
              ],
            ),
          ),


        ],
      ),
    );
  }

  Widget NotificationListData(){
    return Obx((){
      return  FutureBuilder(
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            if(cntNotification.arrNotificationMainList.isNotEmpty) {
              return ListView.builder(
                itemCount: cntNotification.arrNotificationMainList.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(bottom: 18),
                physics: ScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return _notificationListData(index);
                },
              );
            } else {
              return Stack(
                children: [
                  Center(
                    child: Container(
                      color: white,
                      height: Get.height*0.6,
                      width: Get.width,
                      margin: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            IMG_NODATAFOUND,
                            height: 200,
                            width: 200,
                          ),

                          text1()
                        ],
                      ),
                    ),
                  ),

                ],
              );
            }
          } else {
            return notificationShimmerEffect();
          }
        },
        future: cntNotification.futureNotificationData.value,
      );
    });

  }

  Widget _notificationListData(int index){
    NotificationApiCall obj=cntNotification.arrNotificationMainList[index];
    return Column(
      children: [
        SizedBox(height: 8),
        index==0?NotificationStatusData():SizedBox(),
        SizedBox(height: 8),
        Container(
          margin: EdgeInsets.only(left: 20,right: 20,bottom: 10),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(10)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if(obj.title!=null && obj.title!='')Text(
                    obj.title??"",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: fontFamily,
                        fontSize: 12.sp,
                        color: new_black_color
                    ),
                  ),
                  if(obj.date!=null && obj.date!='')Text(obj.date??"",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: fontFamily,
                        fontSize: 8.sp,
                        color: gray_color_1
                    ),
                  ),

                ],
              ),
              SizedBox(height: 8),
              if(obj.message!=null && obj.message!='')SizedBox(
                width: 260,
                child: Text(
                  // "Welcome to the REPEOPLE Family “Happy Exploring",
                  obj.message??"",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: fontFamily,
                      fontSize: 10.sp,
                      color: LIGHT_GREY_COLOR
                  ),

                ),
              )


            ],
          ),
        ),

      ],
    );
  }

  Widget Custom_Button({String? text,GestureTapCallback? onTap,Color? color}){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 34,vertical: 12),
        decoration: BoxDecoration(
          color: white,
        ),
        child: Text(
          text!.toUpperCase(),
          style: TextStyle(
              color: color,
              fontSize: 12.sp,
              fontFamily: fontFamily,
              fontWeight: FontWeight.w500
          ),
        ),
      ),
    );
  }

  Widget CloseIcon() {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Container(
          height: 24,
          width: 24,
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.white.withOpacity(0.20),),
          child: SvgPicture.asset(
            IMG_CLOSE_SVG_NEW,
            color: white,
            fit: BoxFit.cover,
            height: 24,
            width: 24,
          )
      ),
    );
  }

  Widget text1() {
    return Container(
      child: Column(
        children: [
          Text(
            NO_DATAFOUND_TITLE,
            style: darkBigTextStyle(),
          ),

        ],
      ),
    );
  }

  Widget notificationShimmerEffect() {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        enabled: true,
        child: ListView.builder(
            itemCount: 8,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder:(_,index){
              return   Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(cornarradius),
                  ),),
                padding: EdgeInsets.symmetric(vertical: 8,horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shimmerWidget(height: 100.h, width: Get.width, radius: cornarradius),
                  ],
                ),
              );
            } )


    );
  }

}
