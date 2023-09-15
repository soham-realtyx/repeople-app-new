import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Model/CoOwnerModel/CoOwnerMainPageModel.dart';
import 'package:Repeople/Model/PropertiesDetailModel/PropertiesDetailModel.dart';
import 'package:Repeople/View/DashboardPage/BottomnavigationBar.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:Repeople/Widgets/ShimmerWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:Repeople/Controller/MyPropertiesController/MyPropertiesController.dart';

import 'package:Repeople/View/ManageMembersPage/AddNewMembersPage.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';

class ManageMembersPage extends StatefulWidget {
  RxList objMyPropertiesDetails=RxList([]);
  ManageMembersPage({Key? key, required this.objMyPropertiesDetails}) : super(key: key);

  @override
  State<ManageMembersPage> createState() => _ManageMembersPageState();
}

class _ManageMembersPageState extends State<ManageMembersPage> {
  MyPropertiesController cnt_Myproperties = Get.put(MyPropertiesController());
  CommonHeaderController cnt_HeaderController = Get.put(CommonHeaderController());

  @override
  void initState() {
    super.initState();
    cnt_Myproperties.futureManageMemberData.value=cnt_Myproperties.RetriveManageMemberData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.BACKGROUND_WHITE,
      key: cnt_Myproperties.GlobalManageMembersPagekey,
      endDrawer: CustomDrawer(animatedOffset: Offset(1.0,0)),
      drawer: CustomDrawer(animatedOffset: Offset(1.0,0)),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 70),
                  ManageMembersHeaderData(),
                  SizedBox(height: 16.h),
                  MyPropertiesListData(),
                  SizedBox(height: 40.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: _addNewMembers_Button(),
                  ),
                  SizedBox(height: 100.h),
                ],
              ),
            ),
            cnt_HeaderController.commonAppBar("Manage Members",
                cnt_Myproperties.GlobalManageMembersPagekey,isNotificationHide: false),
            Align(
              alignment: Alignment.bottomCenter,
              child: BottomNavigationBarClass(),
            )
          ],
        ),
      ),
    );
  }
  Widget ManageMembersHeaderData(){
    return Container(
      child: Stack(
        children: [
          Obx(() =>  Container(
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

  Widget MyPropertiesListData() {
    return Obx(() {
      return FutureBuilder(
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasError &&
              snapshot.data != null) {
            if (cnt_Myproperties.arrManagerList.isNotEmpty) {
              return ManageMembersListData();
            } else {
              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        "No Data Found",
                        style: mediumTextStyle(
                            fontSize: 12, txtColor: new_black_color),
                      ),
                    ),
                  ],
                ),
              );
            }
          } else {
            return MypropertiesListShimmerWidget();
          }
        },
        future: cnt_Myproperties.futureManageMemberData.value,
      );
    });
  }

  Widget ManageMembersListData(){
    return Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.symmetric(horizontal: 20),
        itemCount: cnt_Myproperties.arrManagerList.length,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemBuilder: (context, index) {
          return Obx(() => _manageMembersListData(index));
        },
      ),
    );
  }

  Widget _manageMembersListData(int index){
    CoOwnerModel objMember = cnt_Myproperties.arrManagerList[index];
    String custmername = "${objMember.invitee??''}".trim();
    String firstletter = custmername.isNotEmpty ? custmername.trim().substring(0,1) : '';
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: BLACK.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 6,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8.h,left: 8.w,right: 8.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: hex("F5F6FA"),width: 2.2)
                  ),
                  child: objMember.image!=""?ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      width:84.w,
                      height: 84.w,
                      fadeInDuration: Duration.zero,
                      fadeOutDuration: Duration.zero,
                      placeholderFadeInDuration: Duration.zero,
                      imageUrl: objMember.image??"",
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) {
                        return Image.network(objMember.image??"",
                            width:84.w,
                            height: 84.w,
                            fit: BoxFit.cover
                        );

                      },
                    ),
                  ):  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0.h,horizontal: 26.w),
                    child: Center(
                      child: Text(
                        firstletter,
                        style: TextStyle(
                            color: DARK_BLUE,
                            fontWeight: FontWeight.w700,
                            fontFamily: fontFamily,
                            fontSize: 48.sp
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        objMember.unitroletype!=null
                            ? Container(
                          padding: EdgeInsets.symmetric(horizontal: 4.w,vertical: 2.h),
                          decoration: CustomDecorations().backgroundlocal(hex("F4F4F4"), 6, 0, white),
                          child: Text(
                            objMember.unitroletype!.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: DARK_BLUE,
                                fontWeight: FontWeight.w600,
                                fontFamily: fontFamily,
                                fontSize: 10.sp
                            ),
                          ),
                        ):SizedBox(),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 4.w,vertical: 2.h),
                          decoration: CustomDecorations().backgroundlocal(DARK_BLUE, 6, 0, APP_THEME_COLOR),
                          child: Center(
                            child: Text(
                              objMember.status??"",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: white,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: fontFamily,
                                  fontSize: 10.sp
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      objMember.fullname??"",
                      style: TextStyle(
                          color: DARK_BLUE,
                          fontWeight: FontWeight.w600,
                          fontFamily: fontFamily,
                          fontSize: 12.sp
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      objMember.contact??"",
                      style: TextStyle(
                          color: new_black_color,
                          fontWeight: FontWeight.w500,
                          fontFamily: fontFamily,
                          fontSize: 10.sp
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      objMember.email??"",
                      style: TextStyle(
                          color: new_black_color,
                          fontWeight: FontWeight.w500,
                          fontFamily: fontFamily,
                          fontSize: 10.sp
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            height: 1,
            width: Get.width,
            color: BORDER_GREY,
          ),
          SizedBox(height: 8.h),
          objMember.status=="Accepted"?
          // cnt_Myproperties.textButton!.value.toLowerCase().contains("delete")
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: OnTapButton(
                onTap: () {
                  // Delete_Member_Bottom_sheet();
                  _showModalBottomSheetCustom(context,index);
                },
                height: 40,
                width: Get.width,
                decoration: BoxDecoration(color: white),
                text: "delete".toUpperCase(),
                style: TextStyle(color: DARK_BLUE, fontSize: 12, fontWeight: FontWeight.w500)),
          )
              :
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: OnTapButton(
                      onTap: () {
                        cnt_Myproperties.ResendMemberRequest(objMember.id??"");
                      },
                      height: 40,
                      decoration: BoxDecoration(color: white),
                      text: "Resend".toUpperCase(),
                      style: TextStyle(color: DARK_BLUE, fontSize: 12, fontWeight: FontWeight.w500)),
                ),
                Expanded(
                  child: OnTapButton(
                      onTap: () {
                        _showModalBottomSheetCustom(context,index);
                        // cnt_Myproperties.RemoveAddMemberRequest(objMember.id??"");
                      },
                      height: 40,
                      decoration: BoxDecoration(color: white),
                      text: "Cancel".toUpperCase(),
                      style: TextStyle(color: gray_color_1, fontSize: 12, fontWeight: FontWeight.w500)),
                )
              ],
            ),
          ),

          SizedBox(height: 8.h),
        ],
      ),
    );
  }


  Widget _addNewMembers_Button() {
    return OnTapButton(
        onTap: () {
          Get.to(()=>AddNewMembersPage());
        },
        height: 40,
        decoration: CustomDecorations().backgroundlocal(APP_THEME_COLOR, cornarradius, 0, APP_THEME_COLOR),
        text: "Add New Members".toUpperCase(),
        style: TextStyle(color: white, fontSize: 12, fontWeight: FontWeight.w500));
  }


  _showModalBottomSheetCustom(BuildContext context,int index) {
    showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Stack(
            children: [

              Container(
                  height: 190.h,
                  width: Get.width,
                  decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 48.h),
                      Text(
                        "Are you sure?",
                        style: TextStyle(
                            color: new_black_color,
                            fontWeight: FontWeight.w700,
                            fontFamily: fontFamily,
                            fontSize: 20
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "you want to Delete this ",
                            style: TextStyle(
                                color: new_black_color,
                                fontWeight: FontWeight.w500,
                                fontFamily: fontFamily,
                                fontSize: 14
                            ),
                          ),
                          Text(
                            cnt_Myproperties.arrManagerList[index].unitroletype??"",
                            style: TextStyle(
                                color: new_black_color,
                                fontWeight: FontWeight.w700,
                                fontFamily: fontFamily,
                                fontSize: 15
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: 14.h),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        height: 1,
                        width: Get.width,
                        color: BORDER_GREY,
                      ),
                      SizedBox(height: 14.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomDeleteButton(
                              text: "DELETE",
                              textColor: DARK_BLUE,
                              onTap: (){
                                Get.back();
                                cnt_Myproperties.RemoveAddMemberRequest(cnt_Myproperties.arrManagerList[index].id??"");
                              }
                          ),
                          SizedBox(width: 30),
                          CustomDeleteButton(
                              text: "CANCEL",
                              textColor: AppColors.RED,
                              onTap: () {
                                Get.back();
                              }
                          ),
                        ],
                      )
                    ],
                  )
              ),
              Container(
                height: 48.h,
                width: Get.width,
                padding: EdgeInsets.symmetric(horizontal: 20),
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: DARK_BLUE,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Alert",
                      style: TextStyle(
                          color: white,
                          fontWeight: FontWeight.w700,
                          fontFamily: fontFamily,
                          fontSize: 14.sp
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Get.back();
                      },
                      child: Container(
                        width: 24.w,
                        height: 24.h,
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: white.withOpacity(0.2)
                        ),
                        child: SvgPicture.asset(
                          IMG_CLOSE_SVG_NEW,
                          color: white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        }
    );
  }

  Widget CustomDeleteButton({String? text,Color? textColor,GestureTapCallback? onTap}){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: white,
        padding: EdgeInsets.symmetric(horizontal: 43,vertical: 12),
        child: Text(
          text??"",
          style: TextStyle(
              fontSize: 12.sp,
              fontFamily: fontFamily,
              fontWeight: FontWeight.w500,
              color: textColor
          ),
        ),
      ),
    );
  }

  Widget MypropertiesListShimmerWidget() {
    return ShimmerEffect(
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),

        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: 4,
          itemBuilder: (context, i) {
            return Container(
              margin: EdgeInsets.only(bottom: 14),
              height: 160.w,
              width: Get.width,
              decoration: BoxDecoration(
                  color: APP_GRAY_COLOR,
                  borderRadius: BorderRadius.circular(10)
              ),
            );
          },
        ),
      ),
    );
  }

}
