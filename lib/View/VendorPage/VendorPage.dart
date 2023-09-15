import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:Repeople/Widgets/ShimmerWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Helper/MoengageAnalyticsHandler.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:Repeople/Controller/VendorsController/VendorsController.dart';
import '../../Config/utils/colors.dart';
import '../../Config/utils/styles.dart';

class VendorPage extends StatefulWidget {
  @override
  VendorPageState createState() => new VendorPageState();
}

class VendorPageState extends State<VendorPage> with TickerProviderStateMixin {
  VendorController cnt_Vendor = Get.put(VendorController());
  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());

  @override
  void initState() {
    super.initState();
    MoengageAnalyticsHandler().track_event("vendor_page");
    cnt_Vendor.LoadPage();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(toolbarHeight: 0,elevation: 0),
        backgroundColor: AppColors.BACKGROUND_WHITE,
        key: cnt_Vendor.GlobalVendorsPagekey,
        endDrawer: CustomDrawer(
          animatedOffset: Offset(1.0, 0),
        ),
        drawer: CustomDrawer(
          animatedOffset: Offset(-1.0, 0),
        ),
        body: SafeArea(
          child: Container(
            child: Stack(
                children: [
                  NotificationListener<OverscrollIndicatorNotification> (
                    child: RefreshIndicator(
                      displacement: 60,
                      onRefresh: cnt_Vendor.onRefresh,
                      child: CustomScrollView(
                        controller: cnt_Vendor.scrollController,
                        physics: AlwaysScrollableScrollPhysics(),
                        keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                        scrollDirection: Axis.vertical,
                        slivers: [
                          SliverToBoxAdapter(
                            child: SizedBox(
                              height: APPBAR_HEIGHT,
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildListDelegate([
                              Container(
                                width: Get.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:  EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                                      child: TextFormField(
                                        onTap: () {
                                          cnt_Vendor.SelectProject();
                                        },
                                        onChanged: (value){

                                        },
                                        readOnly: true,
                                        style: TextStyle(fontSize: 18, color: APP_FONT_COLOR, fontWeight: FontWeight.bold),
                                        controller: cnt_Vendor.txtProject,
                                        textAlignVertical: TextAlignVertical.top,
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        // validator: (value) =>
                                        //     validation(value, "Please select project"),
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: LIGHT_GREY)),
                                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: LIGHT_GREY)),
                                            errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                            disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                            focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                                            labelStyle:semiBoldTextStyle(fontSize: 16,txtColor: Colors.black.withOpacity(0.7)),
                                            hintText: cnt_Vendor.txtProject.text,
                                            hintStyle:
                                            boldTextStyle(fontSize: 18,txtColor: APP_FONT_COLOR),
                                            floatingLabelBehavior: FloatingLabelBehavior.always ,
                                            suffixIcon: Icon(Icons.arrow_drop_down)),
                                      ),
                                    ),
                                    VendorListView(),
                                  ],
                                ),
                              ),


                            ]),
                          ),
                        ],
                      ),
                    ),
                    onNotification: (overscroll) {
                      overscroll.disallowGlow();
                      return true;
                    },
                  ),

                  cnt_CommonHeader.commonAppBar(
                      VENDOR_APPMENUNAME_CAP, cnt_Vendor.GlobalVendorsPagekey,
                      color: white)
            ]),
          ),
        )
        );
  }

  Widget VendorListView(){

    return Obx(() {
      return FutureBuilder(
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
            print(cnt_Vendor.message.value);
            print("cnt_Vendor.message.value1111");
            return /*cnt_Vendor.obj_vendorslist!=null && cnt_Vendor.obj_vendorslist.value.toString()!="" &&*/
                // cnt_Vendor.obj_vendorslist.value.toString()!="null"
                /*cnt_Vendor.obj_vendorslist.value.id!="" &&  */
              cnt_Vendor.obj_vendorslist.value!=null
                  && cnt_Vendor.obj_vendorslist.value.roles!=null
                ?
              Obx(() =>
                GridView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount:
                  cnt_Vendor.obj_vendorslist.value!=null
                      && cnt_Vendor.obj_vendorslist.value.roles!=null &&
                      cnt_Vendor.obj_vendorslist.value.roles!.length!=0
                      ?
                  cnt_Vendor.obj_vendorslist.value.roles?.length:0
                  /*cnt_Vendor.obj_vendorslist.value.roles?.length!=0?
                                      cnt_Vendor.obj_vendorslist.value.roles?.length:0*/,
                  // 3,
                  itemBuilder: (context, i) {
                    return VendorCards(i);
                    // return Container();
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 0.0,
                    mainAxisSpacing: 0.0,
                    childAspectRatio: 2/2.3,
                  ),))
              // cnt_Vendor.VendorListShimmerWidget()
                :
                        Container(
                      height: Get.height*0.50,
                      child: Center(
                        child: Obx(() => Text(
                          // "No data found",
                          cnt_Vendor.message.value,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColors.TEXT_TITLE, fontSize: 15),
                        )),
                      ),
                    );
          } else {
            return VendorListShimmerWidget();
          }
        },
        future: cnt_Vendor.obj_futurevendorlistDetails.value,
      );
    });

  }


  Widget VendorCards(int index){
    return
      Obx(() =>
        GestureDetector(
          onTap: (){
            cnt_Vendor.VendorBottomsheeet(context,index);
          },
          child: Card(
          elevation: 0,
          color: Colors.transparent,
          child: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.only(top: 0),
                            alignment: Alignment.center,
                            height: 70,
                            width: 70,
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              boxShadow: [fullcontainerboxShadow],
                              shape: BoxShape.circle,
                              //border: Border.all(color: Colors.blue.withOpacity(0.08)),
                              //borderRadius: new BorderRadius.circular(35.0),
                              // color: APP_THEME_COLOR.withOpacity(0.01),
                              color: AppColors.WHITE,
                            ),
                            child:
                            cnt_Vendor.obj_vendorslist.value.roles?[index].icon!=""?
                            SvgPicture.network( cnt_Vendor.obj_vendorslist.value.roles?[index].icon??"")
                                :Image.asset("assets/repeople_icons/vendors_icons/ac-service.svg",)
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.only(left: 5,right: 5,top: 2, bottom: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle, color: APP_THEME_COLOR,
                              // border: Border.all(color: AppColors.BACKGROUND_WHITE)
                              // border: Border.all(color: AppColors.BACKGROUND_WHITE,width: 1)
                            ),
                            alignment: Alignment.center,
                            child: Text(cnt_Vendor.obj_vendorslist.value.roles?[index].total??"",
                                style:
                                semiBoldTextStyle(txtColor: AppColors.WHITE,fontSize: 10)),
                          ),
                        )
                      ]),
                  // Expanded(
                  //     child: Icon(
                  //   choice.icon,
                  //   size: 30.0,
                  // )),
                  SizedBox(height: 10,),
                  Text(cnt_Vendor.obj_vendorslist.value.roles?[index].name??"",
                    style: mediumTextStyle(fontSize: 12, txtColor: BLACK),),

                ]),
          )),
        ));
    //Container(height: 200,width: 200,color: AppColors.APP_THEME_COLOR,);
  }

  Widget VendorListShimmerWidget() {
    return ShimmerEffect(
        child: Container(
          // padding:
          // EdgeInsets.only(top: 10.h),
            child:
            GridView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: 6,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 0.0,
                mainAxisSpacing: 0.0,
                childAspectRatio: 2/1.9,
              ),
              itemBuilder:
                  (context, i) {
                return Padding(
                  padding: EdgeInsets.all(20.w),
                  child: shimmerWidget(width: 5.w, height: 20.h, radius: 80),
                );
                // return Container();
              },
            )
        ));
  }
}







