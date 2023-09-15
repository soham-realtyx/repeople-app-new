import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Model/PropertiesDetailModel/PropertiesDetailModel.dart';
import 'package:Repeople/View/DashboardPage/BottomnavigationBar.dart';
import 'package:Repeople/View/PrivacyTermPage/PrivacyTermPage.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:Repeople/Widgets/ShimmerWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:Repeople/Controller/MyPropertiesController/MyPropertiesController.dart';

import 'package:Repeople/Widgets/CustomDecoration.dart';

class Re_SalePage extends StatefulWidget {
  RxList objMyPropertiesDetails=RxList([]);
  Re_SalePage({Key? key,required this.objMyPropertiesDetails}) : super(key: key);

  @override
  State<Re_SalePage> createState() => _Re_SalePageState();
}

class _Re_SalePageState extends State<Re_SalePage> {
  MyPropertiesController cnt_Myproperties = Get.put(MyPropertiesController());
  CommonHeaderController cnt_HeaderController = Get.put(CommonHeaderController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cnt_Myproperties.txtResaleNotes.value!.text='';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.BACKGROUND_WHITE,
      key: cnt_Myproperties.GlobalReSalePagekey,
      endDrawer: CustomDrawer(animatedOffset: Offset(1.0,0),),
      drawer: CustomDrawer(animatedOffset: Offset(1.0,0),),
      body: SafeArea(
        child: Stack(
          children: [

            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 70),
                  ReSaleHeaderData(),
                  SizedBox(height: 10.h),
                  ResaleFormData(),
                  SizedBox(height: 100.h),
                ],
              ),
            ),
            cnt_HeaderController.commonAppBar("Re-Sale",
                cnt_Myproperties.GlobalReSalePagekey,isNotificationHide: false),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: BottomNavigationBarClass(),
            // )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarClass(),
    );
  }
  Widget ReSaleHeaderData(){
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

  Widget ResaleFormData(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.symmetric(horizontal: 8,vertical: 20),
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
        children: [
          QueryTextField_2(cnt_Myproperties.txtResaleNotes),
          SizedBox(height: 70.h),
          GestureDetector(
            onTap: (){
              Get.to(
                  PrivacyTermPage(
                    title: "Terms & Conditions",
                  ),
                  preventDuplicates: false);
            },
            child: Text("Terms & Conditions",
                style: TextStyle(
                    fontSize: 12.sp, color: gray_color_1,fontWeight: FontWeight.w500)),
          ),
          SizedBox(height: 10.h),
          SubmitButton_4(),
        ],
      ),
    );
  }
  Widget QueryTextField_2(Rxn<TextEditingController>? controller) {
    return Obx(() =>TextFormField(
      maxLines: 2,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z@. ]")),
      ],

      controller: controller?.value,
      onChanged: (value){
        controller?.update((val) { });
      },
      style: boldTextStyle(fontSize: 16, txtColor: APP_FONT_COLOR),
      decoration: InputDecoration(
        enabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: gray_color_1)),
        focusedBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: gray_color_1)),
        errorBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        disabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        focusedErrorBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        // border: InputBorder.none,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: "Note",
        hintText: "",
        labelStyle: TextStyle(
            fontSize: 16.sp,
            color: gray_color_1,
            fontWeight: FontWeight.w500
          // controller!.value!.text.toString().isNotEmpty? Colors.grey.withOpacity(0.7):
          // Colors.black.withOpacity(0.7),
        ),
        hintStyle: TextStyle(color: NewAppColors.GREY),
        // contentPadding: EdgeInsets.all(20),


      ),
    ));
  }

  Widget SubmitButton_4() {
    return OnTapButton(
        onTap: () {
          cnt_Myproperties.AddReSale();
        },
        height: 40,
        decoration: CustomDecorations().backgroundlocal(APP_THEME_COLOR, cornarradius, 0, APP_THEME_COLOR),
        text: "Submit".toUpperCase(),
        style: TextStyle(color: white, fontSize: 14, fontWeight: FontWeight.w500));
  }

}
