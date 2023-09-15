import 'package:Repeople/Config/Helper/MoengageAnalyticsHandler.dart';
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Controller/OffersPageController/OffersPageController.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:Repeople/Widgets/ShimmerWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/utils/colors.dart';

import '../../Controller/CommonHeaderController/CommenHeaderController.dart';

class OffersPage extends StatefulWidget {
  const OffersPage({Key? key}) : super(key: key);

  @override
  State<OffersPage> createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  var OffersPageKey=GlobalKey<ScaffoldState>();
  OffersPageController cnt_offers = Get.put(OffersPageController());
  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());
  ScrollController scrollController = ScrollController();

  @override
  void initState(){
    super.initState();
    cnt_offers.futureData.value=cnt_offers.RetrieveOffersData();
    cnt_offers.futureData.refresh();
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
            key: cnt_offers.GlobalOffersPagekey,
            body: SafeArea(
              child: Container(
                child: Stack(
                  children: [
                    NotificationListener<OverscrollIndicatorNotification> (
                      child: RefreshIndicator(
                        displacement: 80,
                        onRefresh: cnt_offers.onRefresh,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment
                                .center,
                            children: [
                              const SizedBox(height: APPBAR_HEIGHT),
                              offersSliderData(),
                              const SizedBox(height: APPBAR_HEIGHT),
                            ],
                          ),
                        )
                      ),
                      onNotification: (overscroll) {
                        overscroll.disallowIndicator();
                        return true;
                      },
                    ),
                    cnt_CommonHeader.commonAppBar(OFFER_APPMENUNAME_CAP, cnt_offers.GlobalOffersPagekey,color: white)
                  ],
                ),
              ),
            )),
      );
    });
  }
  Widget offersSliderData(){
    return Obx(() =>
        FutureBuilder(
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.done && snapshot.data!=null) {
              if (cnt_offers.offerslist.isNotEmpty) {
                return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CarouselSlider.builder(
                            itemCount: cnt_offers.offerslist.length,
                            itemBuilder: (context, index, realIndex) {
                              return
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0,right: 15),
                                  child: InkWell(
                                    hoverColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: (){
                                      MoengageAnalyticsHandler().SendAnalytics({"offer_name":cnt_offers.offerslist[index].offername.toString()},"offer_slider_tap");
                                      cnt_offers.launchURL(cnt_offers.offerslist[index].offerredirect.toString());
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(width: 1.5,color: BORDER_GREY)
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child:
                                        CachedNetworkImage(
                                          placeholder: (context, url) => leadShimmerWidget(),
                                          fadeInDuration: Duration.zero,
                                          fadeOutDuration: Duration.zero,
                                          placeholderFadeInDuration: Duration.zero,
                                          imageUrl: cnt_offers.offerslist[index].potraitimg.toString(),
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) {
                                            return
                                              Image.asset(
                                                cnt_offers.offerslist[index].potraitimg.toString(),
                                                width: Get.width,
                                                fit: BoxFit.cover,
                                              );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                            },
                            options: CarouselOptions(
                                height: Get.height/1.5,
                                enlargeCenterPage: true,
                                autoPlay: true,
                                aspectRatio: 2.0,
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enableInfiniteScroll: true,
                                // autoPlayAnimationDuration: Duration(milliseconds: 800),
                                viewportFraction: 0.8,
                                scrollDirection: Axis.horizontal,
                                enlargeStrategy: CenterPageEnlargeStrategy.height,
                                onPageChanged: (index,_){
                                  cnt_offers.current.value=index;
                                  cnt_offers.current.refresh();
                                }
                            ),
                            carouselController: cnt_offers.controller_event,
                          ),
                          const SizedBox(height: 45),

                          Obx(() {
                            return
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: cnt_offers.offerslist
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  return GestureDetector(
                                    onTap: () {
                                      cnt_offers.controller_event.animateToPage(entry.key);
                                    },
                                    child: Container(
                                      width: 8.0,
                                      height: 8.0,
                                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: cnt_offers.current == entry.key
                                            ? Colors.black
                                            : Colors.grey,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                          }),
                        ],
                      );
              }
              else {
                return Container(
                    height: Get.height / 2,
                    width: Get.width,
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "No data found",
                          style: TextStyle(
                              color: AppColors.TEXT_TITLE, fontSize: 15),
                        ),
                      ],
                    )
                );
              }
            } else {
              return leadShimmerWidget();
            }},
          future: cnt_offers.futureData.value,

        ));

  }

  CreateEventWidget() {
    cnt_offers.eventSliders=cnt_offers.offerimages.map((item) =>
        Padding(
          padding: const EdgeInsets.only(top: 20.0,right: 15),
          child: InkWell(
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: (){
              // _launchURL(item.offerredirect.toString());
            },
            child: Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  // child: Image.network(item.toString(),fit: BoxFit.cover)
                  child: CachedNetworkImage(
                    placeholder: (context, url) => leadShimmerWidget(),
                    fadeInDuration: Duration.zero,
                    fadeOutDuration: Duration.zero,
                    placeholderFadeInDuration: Duration.zero,
                    imageUrl: cnt_offers.offerimages.toString(),
                    fit: BoxFit.cover,
                  ),
                )

            ),
          ),
        )
    ).toList();
  }

  Widget leadShimmerWidget() {
    return ShimmerEffect(
        child: Center(
          child: Container(
            alignment: Alignment.center,
            child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (_, index) {
                  return Padding(
                    padding: EdgeInsets.all(30.w),
                    child: shimmerWidget(width: Get.width, height: 500.w, radius: 10),
                  );
                },
                itemCount: 1),
          ),
        ));
  }
}
