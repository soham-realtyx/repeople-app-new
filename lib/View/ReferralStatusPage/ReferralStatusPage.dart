import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:Repeople/Controller/ReferralStatusController/ReferralStatusController.dart';
import 'package:Repeople/Model/ReferralModal/RefrralListModel.dart';
import 'package:Repeople/View/DashboardPage/BottomnavigationBar.dart';
import 'package:Repeople/View/RedeemPointPage/RedeemPointPage.dart';
import 'package:Repeople/View/ReferaFriendPage/ReferAFriendFormPage.dart';
import 'package:Repeople/Widgets/CommomBottomSheet.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:Repeople/Widgets/ShimmerWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../Config/Constant.dart';
import '../../Config/utils/colors.dart';

class ReferralStatusPage extends StatefulWidget {
  const ReferralStatusPage({Key? key}) : super(key: key);

  @override
  State<ReferralStatusPage> createState() => _ReferralStatusPageState();
}

class _ReferralStatusPageState extends State<ReferralStatusPage> with TickerProviderStateMixin {

  ReferralStatusController cnt_status = Get.put(ReferralStatusController());
  ScrollController scrollController = ScrollController();
  CommonHeaderController cnt_header = Get.put(CommonHeaderController());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    cnt_status.tabController.dispose();
    cnt_status.categoryTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: AppColors.BACKGROUND_WHITE,
          endDrawer: CustomDrawer(animatedOffset: Offset(1.0,0),),
          drawer: CustomDrawer(animatedOffset: Offset(-1.0,0),),
          resizeToAvoidBottomInset: false,
          key: cnt_status.GlobalReedemkey,
          body: SafeArea(
            child: Stack(
              children: [
                NotificationListener<OverscrollIndicatorNotification>(
                  child: RefreshIndicator(
                    displacement: 60,
                    onRefresh: cnt_status.onRefresh,
                    child:SingleChildScrollView(
                      child:   SizedBox(
                        width: Get.width,
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: APPBAR_HEIGHT),
                            wdReferFriend(),
                            referredListCountingWidget(),
                            const SizedBox(height: 50,)
                          ],
                        ),
                      ),
                    )
                  ),
                  onNotification: (overscroll) {
                    overscroll.disallowIndicator();
                    return true;
                  },
                ),
                cnt_header.commonAppBar(
                    REFERRAL_STATUS, cnt_status.GlobalReedemkey,
                    color: Colors.grey.shade50.withOpacity(0.2))
              ],
            ),
          ),
          bottomNavigationBar:BottomNavigationBarClass(),
        ),
      );
    });
  }


  Widget wdReferFriend() {
    return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
        width: Get.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(cornarradius)),
            color: white,
            boxShadow: [fullcontainerboxShadow]),
        child: Material(
          color: Colors.white,
          elevation: 0,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding:
            const EdgeInsets.only(top: 20, left: 0, right: 0, bottom: 14),
            child: _generateReferFriend1(),
          ),
        ));
  }

  Widget _generateReferFriend1() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Text(redeemPoints.value.toString(),
                style: mediumTextStyle(txtColor: new_black_color, fontSize: 40)
            )),
            const SizedBox(
              width: 5,
            ),
            Text("pts",
                style: semiBoldTextStyle(txtColor: gray_color, fontSize: 15)
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Text(lblReferFriendLabel.toUpperCase(),
            style: mediumTextStyle(txtColor: gray_color_1, fontSize: 10)
        ),
        const SizedBox(
          height: 14,
        ),
        Divider(
          thickness: 1.h,
          color: BORDER_GREY,
        ),
        const SizedBox(
          height: 14,
        ),
        Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            children: [
              Expanded(
                child: OnTapButton(
                    text: lblReferFriendReferButton,
                    style: semiBoldTextStyle(txtColor: white, fontSize: 10),

                    icon: SvgPicture.asset(
                      IMG_RIGHTARROW_SVG_NEW /*,height: 13*/,
                      width: 10, color: white,
                      // alignment: Alignment.center,
                    ),
                    decoration: CustomDecorations()
                        .backgroundlocal(APP_THEME_COLOR, 8, 0, white),
                    height: 40,
                    onTap: () {
                      //Get.to(ReferAFriendPage());
                      Get.to(ReferAFriendFormPage());
                    }),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: OnTapButton(
                    text: lblReferFriendRedeemButton,
                    style: semiBoldTextStyle(
                        txtColor: APP_FONT_COLOR, fontSize: 10),
                    // TextStyle(color: APP_FONT_COLOR, fontSize: 11,fontWeight: FontWeight.w600),
                    icon: SvgPicture.asset(
                      IMG_RIGHTARROW_SVG_NEW /*,height: 13*/,
                      width: 10,
                      color: APP_FONT_COLOR,
                    ),
                    decoration: CustomDecorations()
                        .backgroundlocal(white, 8, 1, hex("e8e8e8")),
                    height: 40,
                    onTap: () {
                      Get.to(RedeemPointPage());
                    }),
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget referredListCountingWidget() {
    return Obx(() {
      return FutureBuilder(
        builder: (context, AsyncSnapshot snapshot)
      {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null){
          if (cnt_status.arrRefferalList.isNotEmpty) {
            return referredPoint();
          } else {
            return Center(child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(cnt_status.message.value),
            ));
          }
        }
          else {
            return RefferListShimmer();
          }
        },
        future: cnt_status.futureRefferallist.value,
      );
    });
  }

  Widget referredListWidget() {
    return Obx(() {
      return FutureBuilder(
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            if (cnt_status.arrRefferalList.isNotEmpty &&
                cnt_status.arrRefferalList[cnt_status.Indexselected.value].data!.length > 0) {
              return directoryData();
            } else {
              return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0,bottom: 50),
                    child: Text(cnt_status.message.value != "" && cnt_status.message.value != null
                        ? cnt_status.message.value
                        : "No Data Found"),
                  ));
            }
          } else {
            return RefferListShimmer();
          }
        },
        future: cnt_status.futureRefferallist.value,
      );
    });
  }

  Widget referredPoint() {
    return Obx(() => Container(
      margin: const EdgeInsets.only(
          left: 20, right: 20, top: 0, bottom: 0),
      decoration: CustomDecorations().backgroundlocal(white, 6, 0, white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 55.w,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 8,top: 8),
                itemCount: cnt_status.arrRefferalList.length,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  RefrralMainListModel obj = cnt_status.arrRefferalList[index];
                  return Obx(() => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        cnt_status.Indexselected.value = index;
                        cnt_status.Indexselected.refresh();
                        cnt_status.futureRefferallist.refresh();
                      },
                      child: Container(
                        // height: 52.h,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                            color: cnt_status.Indexselected.value == index
                                ? DARK_BLUE
                                : white,
                            border: Border.all(color: DARK_BLUE, width: 1)
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SvgPicture.network(
                                obj.icon.toString(),
                                fit: BoxFit.cover,
                                color: cnt_status.Indexselected.value == index
                                    ? white
                                    : DARK_BLUE,
                                width: 26,
                                height: 26,
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
                                        color: cnt_status.Indexselected.value == index
                                            ? white
                                            : DARK_BLUE,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    obj.count.toString(),
                                    style: TextStyle(
                                        color: cnt_status.Indexselected.value == index
                                            ? white
                                            : DARK_BLUE,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13),
                                  ),
                                ],
                              ),
                            ]),
                      ),
                    ),
                  ));
                }),
          ),
          SizedBox(height: 12.h),
          referredListWidget()
        ],
      ),
    ));
  }

  Widget directoryData() {
    return Obx(() {
      return ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: cnt_status.arrRefferalList[cnt_status.Indexselected.value].data?.length ?? 0,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (context, ind2) {
            Data obj = cnt_status.arrRefferalList[cnt_status.Indexselected.value].data![ind2];
            return InkWell(
                onTap: () {
                  RefferStepBottomSheet(obj);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8,right: 8,left: 8),
                  padding: EdgeInsets.only(left: 5, right: 5, top: 5.w, bottom: 5.w),
                  decoration: BoxDecoration(
                    color: DARK_BLUE.withOpacity(0.1),
                    boxShadow: [fullcontainerboxShadow],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(cornarradius),
                      topRight: Radius.circular(cornarradius),
                      bottomLeft: Radius.circular(cornarradius),
                      bottomRight: Radius.circular(cornarradius),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 5,
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                height: 60.0,
                                width: 60.0,
                                decoration: BoxDecoration(
                                  borderRadius:  BorderRadius.circular(32.0),
                                  color: DARK_BLUE.withOpacity(0.2),
                                ),
                                child: Text(
                                  obj.shortname.toString().toUpperCase(),
                                  style: TextStyle(
                                      color: gray_color,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 0, top: 5, bottom: 5),
                                  child: SizedBox(
                                    width: 120.w,
                                    child: Text(obj.name!.toString(),
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: DARK_BLUE,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: fontFamily,
                                            height: 1.5),
                                        maxLines: 2
                                      //TextStyle(fontSize: 15,fontWeight:FontWeight.bold,),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 0, top: 0, bottom: 0),
                                  child: Text(
                                    obj.email!.toString(),
                                    style: TextStyle(
                                        color: new_black_color,
                                        fontSize: 10.sp,
                                        fontFamily: fontFamily,
                                        fontWeight: FontWeight.w400),
                                    maxLines: 2,
                                    // TextStyle(fontSize: 12,color: APP_FONT_COLOR.withOpacity(0.7)),
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0, top: 3, bottom: 10),
                                    child: Text(
                                      obj.contact!.toString(),
                                      style: TextStyle(
                                          color: new_black_color,
                                          fontSize: 10.sp,
                                          fontFamily: fontFamily,
                                          fontWeight: FontWeight.w400),
                                      // TextStyle(fontSize: 12,color: APP_FONT_COLOR.withOpacity(0.7),),
                                    ))
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            InkWell(
                                hoverColor: AppColors.TRANSPARENT,
                                highlightColor: AppColors.TRANSPARENT,
                                splashColor: AppColors.TRANSPARENT,
                                child: Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    color: hex(obj.class1 ?? "#000000").withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 6, right: 8, left: 8),
                                    child: Text(
                                      obj.status.toString().toUpperCase(),
                                      style: mediumTextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          txtColor: hex(obj.class1 ?? "#000000")),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ]),
                ));
          });
    });
  }

  RefferStepBottomSheet(Data obj) {
    if (obj.refersteplist!.length > 0) {
      bottomSheetDialog(
          message: obj.name.toString(),
          backgroundColor: APP_THEME_COLOR,
          child: RefferStepData(obj));
    }
  }

  Widget RefferStepData(Data obj) {
    return Container(
      width: Get.width,
      height: 330,
      padding: EdgeInsets.all(15),
      child: ListView.builder(
        itemCount: obj.refersteplist?.length ?? 0,
        itemBuilder: (context, index) {
          ReferStepList stepobj = obj.refersteplist![index];
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: APP_THEME_COLOR,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5),
                      border:
                      Border.all(color: INDICATOR_SLIDER_COLOR, width: 1),
                    ),
                    child: Text(
                      stepobj.name.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  index != obj.refersteplist!.length - 1
                      ? IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 1,
                            height: 80,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: INDICATOR_SLIDER_COLOR,
                                    width: 0.5)),
                          ),
                        ),
                      ],
                    ),
                  )
                      : SizedBox()
                ],
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stepobj.description.toString(),
                    ),
                    SizedBox(height: 5),
                    Text('Points : ${stepobj.points}'),
                    SizedBox(height: 5),
                    if (stepobj.date != null && stepobj.date != '')
                      Text('Date : ${stepobj.date}')
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.network(
                    stepobj.icon.toString(),
                    width: 25,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border:
                        Border.all(color: hex(stepobj.color!), width: 1)),
                    child: Padding(
                      padding:
                      EdgeInsets.only(top: 5, bottom: 6, right: 8, left: 8),
                      child: Text(
                        stepobj.statusstr.toString(),
                        style: mediumTextStyle(
                            fontSize: 10, txtColor: hex(stepobj.color!)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget RefferCountingShimmer() {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        enabled: true,
        child: ListView.builder(
            itemCount: 5,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) {
              return Container(
                padding: EdgeInsets.all(15),
                child: shimmerWidget(height: 200, width: 120, radius: 10),
              );
            }));
  }

  Widget RefferListShimmer() {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        enabled: true,
        child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20),
            itemCount: 5,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (_, index) {
              return Container(
                padding: EdgeInsets.all(5),
                child: shimmerWidget(height: 120, width: Get.width, radius: 10),
              );
            }));
  }

}
