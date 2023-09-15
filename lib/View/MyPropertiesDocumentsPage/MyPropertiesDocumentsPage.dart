import 'package:Repeople/Config/Helper/HextoColor.dart';
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Model/Document/Document_Category_Model.dart';
import 'package:Repeople/Model/PropertiesDetailModel/PropertiesDetailModel.dart';
import 'package:Repeople/View/DashboardPage/BottomnavigationBar.dart';
import 'package:Repeople/View/Document_Screen/View_Document_Screen.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:Repeople/Widgets/ShimmerWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:Repeople/Controller/MyPropertiesController/MyPropertiesController.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';

class MyPropertiesDocumentsPage extends StatefulWidget {
  RxList objMyPropertiesDetails=RxList([]);
  MyPropertiesDocumentsPage({Key? key, required this.objMyPropertiesDetails}) : super(key: key);

  @override
  State<MyPropertiesDocumentsPage> createState() => _MyPropertiesDocumentsPageState();
}

class _MyPropertiesDocumentsPageState extends State<MyPropertiesDocumentsPage> {
  MyPropertiesController cnt_Myproperties = Get.put(MyPropertiesController());
  CommonHeaderController cnt_HeaderController = Get.put(CommonHeaderController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cnt_Myproperties.futureDocSubMainData.value=cnt_Myproperties.retrieveDocumentSubListData( id: '', name: '', categoryid: '');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.BACKGROUND_WHITE,
        key: cnt_Myproperties.GlobalDocumentPagekey,
        endDrawer: CustomDrawer(animatedOffset: const Offset(1.0,0)),
        drawer: CustomDrawer(animatedOffset: const Offset(1.0,0)),
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 70),
                    MyPropertiesHeaderData(),
                    SizedBox(height: 16.h),
                    searchProjectTextField(),
                    SizedBox(height: 16.h),
                    myDocumentList(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
              cnt_HeaderController.commonAppBar("Documents",
                  cnt_Myproperties.GlobalDocumentPagekey,isNotificationHide: false),
              Align(
                alignment: Alignment.bottomCenter,
                child: BottomNavigationBarClass(),
              )
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding:  EdgeInsets.only(right: 6.w,bottom: 60.h),
          child: SpeedDial(
            icon: Icons.add,
            activeIcon: Icons.close,
            backgroundColor: DARK_BLUE,
            foregroundColor: white,
            activeBackgroundColor: AppColors.RED,
            activeForegroundColor: white,
            visible: true,
            closeManually: false,
            curve: Curves.bounceIn,
            overlayColor: BLACK,
            overlayOpacity: 0.5,
            spaceBetweenChildren: 6,
            children: [
              SpeedDialChild( //speed dial child
                child: Icon(Icons.camera_alt),
                backgroundColor: hex("E57373"),
                foregroundColor: white,
                label: 'Camera',
                labelStyle: TextStyle(fontSize: 14.sp,color: new_black_color,fontWeight: FontWeight.w700,fontFamily: fontFamily),
                onTap: () {
                  cnt_Myproperties.CameraSelect();
                },
              ),
              SpeedDialChild(
                child: Icon(Icons.upload),
                backgroundColor: hex("64B5F6"),
                foregroundColor: white,
                label: 'Choose Photo',
                labelStyle: TextStyle(fontSize: 14.sp,color: new_black_color,fontWeight: FontWeight.w700,fontFamily: fontFamily),
                onTap: () {
                  cnt_Myproperties.ChooseImage();
                },
              ),
              SpeedDialChild(
                child: Icon(Icons.file_copy),
                foregroundColor: white,
                backgroundColor: hex("4DD0E1"),
                label: 'File',
                labelStyle: TextStyle(fontSize: 14.sp,color: new_black_color,fontWeight: FontWeight.w700,fontFamily: fontFamily),
                onTap: () {
                  cnt_Myproperties.FileChoose();
                },
              ),
            ],
          ),
        )
    );
  }
  Widget MyPropertiesHeaderData(){
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


  Widget searchProjectTextField() {
    return Container(
      width: Get.width,
      padding: EdgeInsets.only(bottom: 0,top: 0,left: 20,right: 20),
      color: AppColors.BACKGROUND_WHITE,
      child: Autocomplete<DocumentCommonModel>(
        optionsBuilder: (value) {
          List<DocumentCommonModel> filter = [];
          if (value.text.isNotEmpty) {
            filter = [];
          }
          return filter;
        },
        initialValue: TextEditingValue.empty,
        onSelected: (value) {print(value);},
        optionsMaxHeight: Get.height / 3,
        fieldViewBuilder: (context, textcontroller, focusnode, onsubmit) {
          return Container(
            decoration: BoxDecoration(
                boxShadow: [fullcontainerboxShadow]
            ),
            child: Material(
              color: Colors.white,
              // elevation: 1,
              borderRadius: BorderRadius.circular(cornarradius),
              child: TextField(
                controller: textcontroller,
                focusNode: focusnode,
                onSubmitted: (value) {
                  cnt_Myproperties.onSearchTextChanged(textcontroller.text);
                },
                onChanged: (value) {
                  cnt_Myproperties.onSearchTextChanged(textcontroller.text);
                },
                onTap: (){

                },
                decoration: InputDecoration(
                    hintText: 'Search here',
                    hintStyle: regularTextStyle(
                        txtColor: HexColor("#b4b4b4"), fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(left: 20,right: 20,top: 15,bottom: 15),
                    suffixIcon: InkWell(
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          print("im tapping");
                          cnt_Myproperties.onSearchTextChanged(textcontroller.text);
                        },
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 4),
                            height: 30,
                            width: 30,
                            decoration: CustomDecorations().backgroundlocal(
                                APP_THEME_COLOR,
                                cornarradius,
                                0,
                                APP_THEME_COLOR),
                            child: SvgPicture.asset(
                              IMG_SEARCH_SVG_NEW_2,
                              color: white,
                            )
                        ))
                ),
                cursorColor: Colors.black54,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget myDocumentList() {
    return Obx(() {
      return FutureBuilder(
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasError &&
              snapshot.data != null) {
            if (cnt_Myproperties.arrDocSubMainList.isNotEmpty) {
              return documentListData();
            } else {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 80.0),
                  child: Text(
                    cnt_Myproperties.documentMessage.value,
                    style: mediumTextStyle(txtColor: new_black_color,fontWeight: FontWeight.w600,fontSize: 14),
                  ),
                ),
              );
            }
          } else {
            return myDocumentShimmerWidget();
          }
        },
        future: cnt_Myproperties.futureDocSubMainData.value,
      );
    });
  }

  Widget documentListData(){
    return ListView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      itemCount: cnt_Myproperties.arrDocSubMainList.length,
      itemBuilder: (context, index) {
        return _generateDocumentList(index);
      },
    );
  }

  Widget _generateDocumentList(int index){
    DocumentCommonModel objDoc = cnt_Myproperties.arrDocSubMainList[index];
    return GestureDetector(
      onTap: (){
        Get.to(view_document_new(
          title: objDoc.documentname.toString(),
          id: objDoc.id.toString(),
        ));
        // Get.to(()=>PDFScreen(path: objDoc.documentname.toString(),));
        // Get.to(()=>DocumentDetailsScreen(doc_id: "${cnt_Myproperties.arrDocMainList.value[index].id}",));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: white,
          boxShadow: [
            BoxShadow(
              color: BLACK.withOpacity(0.04),
              spreadRadius: 0,
              blurRadius: 6,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(PDF_PNG_IMAGE,height: 41.h,width: 41.w,fit: BoxFit.cover),
            SizedBox(width: 12.w,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  objDoc.documentname??"",
                  style: TextStyle(
                    color: DARK_BLUE,
                    fontWeight: FontWeight.w700,
                    fontFamily: fontFamily,
                    fontSize: 12.sp,
                  ),
                ),
                // SizedBox(height: 2,),
                // Text(
                //   objDoc.subTitle??"",
                //   style: TextStyle(
                //     color: BLACK,
                //     fontWeight: FontWeight.w500,
                //     fontFamily: fontFamily,
                //     fontSize: 10.sp,
                //   ),
                // ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget myDocumentHeaderShimmerWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20,top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerEffect(
            child: Container(
              height: 211.w,width: Get.width,
              decoration: BoxDecoration(
                  color: APP_GRAY_COLOR,
                  borderRadius: BorderRadius.circular(10)
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget myDocumentShimmerWidget() {
    return ListView.builder(
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.only(left: 20.h,right: 20.h),
        itemCount: 4,
        itemBuilder: (context, index) {
          return ShimmerEffect(
            child: Container(
              margin: EdgeInsets.only(bottom: 10.h),
              height: 50.w,width: Get.width,
              decoration: BoxDecoration(
                  color: APP_GRAY_COLOR,
                  borderRadius: BorderRadius.circular(10)
              ),
            ),
          );
        });
  }
}
