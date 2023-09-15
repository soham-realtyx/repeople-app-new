import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Controller/NewsListController/NewsListController.dart';
import 'package:Repeople/Model/News/NewsModal.dart';
import 'package:Repeople/View/DashboardPage/BottomnavigationBar.dart';
import 'package:Repeople/View/NewsDetailsPage/NewsDetailsPage.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:Repeople/Widgets/ShimmerWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Helper/MoengageAnalyticsHandler.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';

class NewsListPage extends StatefulWidget {
  const NewsListPage({Key? key}) : super(key: key);

  @override
  _NewsListPageState createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {

  NewsListController cnt_NewsList= Get.put(NewsListController());
  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());

  @override
  void initState() {
    super.initState();
    cnt_NewsList.RetrieveNewsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      key: cnt_NewsList.GlobalNewsPagekey,
      endDrawer: CustomDrawer(animatedOffset: Offset(1.0,0),),
      drawer: CustomDrawer(animatedOffset: Offset(-1.0,0),),
      backgroundColor: AppColors.BACKGROUND_WHITE,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: APPBAR_HEIGHT),
                  updatedNews(),
                  const SizedBox(height: 20),
                ],
              )
            ),
            cnt_CommonHeader.commonAppBar(NEWS_APPMENUNAME_CAP, cnt_NewsList.GlobalNewsPagekey,color: AppColors.NEWAPPBARCOLOR),
          ],
        )
      ),
    );
  }
  // Updated news 1
  Widget updatedNews() {
    return FutureBuilder(
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasError) {
          if (cnt_NewsList.arrNewsListnew.isNotEmpty) {
            return Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return _generateNewsItem_1(index);
                        },
                        itemCount: cnt_NewsList.arrNewsListnew.length != 0 ? cnt_NewsList.arrNewsListnew.length : 0,
                      ),
                    ),

                  ],
                ),
              ],
            );
          }
          else {
            return Container(
              height: Get.height / 2,
              width: Get.width,
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              child:
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "No data found",
                    style: TextStyle(
                        color: AppColors.TEXT_TITLE, fontSize: 15),
                  ),
                ],
              ),
            );
          }
        } else {
          return ImportantNewsShimmerWidget5();
        }},
      future: cnt_NewsList.futurenewsDatanew.value,

    );
  }

  Widget _generateNewsItem_1(int index) {
    NewsListModal obj = cnt_NewsList.arrNewsListnew[index];
    return
      InkWell(
        onTap: ()=>OnClickHandler(obj),
        child: Container(
          margin: const EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
          decoration: BoxDecoration(
            boxShadow: [fullcontainerboxShadow],
            color: white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(cornarradius),topRight:
            Radius.circular(cornarradius),bottomRight: Radius.circular(cornarradius),
                bottomLeft: Radius.circular(cornarradius)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              obj.newsimage!=""?
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child:
                    CachedNetworkImage(
                      fadeInDuration: Duration.zero,
                      fadeOutDuration: Duration.zero,
                      placeholderFadeInDuration: Duration.zero,
                      imageUrl: obj.newsimage??"",
                      fit: BoxFit.fill,
                      errorWidget: (context, url, error) {
                        return
                          Image.network(
                            obj.newsimage??"",
                            width: Get.width,
                            fit: BoxFit.cover,
                          );
                      },
                    ),
                  ),
                  obj.newscategory!.isNotEmpty?Positioned(
                      top: 10,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.only(top: 6,bottom: 6,left: 8,right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: APP_FONT_COLOR.withOpacity(0.8),
                        ),
                        child: Center(
                          child: Text(
                            capitalizeFirstLetter(obj.newscategory??""),
                            maxLines: 2,
                            style: mediumTextStyle(fontSize: 9, txtColor: white),
                            // TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: gray_color),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      )):const SizedBox()
                ],
              ):const SizedBox(),
              InkWell(
                onTap: ()=>OnClickHandler(obj),
                child: Stack(
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 8,top: 0,right: 8),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                capitalizeFirstLetter(obj.title??""),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: DARK_BLUE,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: fontFamily,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),

                              Text(
                                obj.newspublishdate!,
                                style: regularTextStyle(txtColor: gray_color_1,fontSize: 10,fontWeight: FontWeight.w600),),
                              const SizedBox(
                                height: 10,
                              ),
                            ])),

                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }

  Widget ImportantNewsShimmerWidget5() {
    return ShimmerEffect(
        child: Container(
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                shimmerWidget(width: Get.width, height: 185.h, radius: 10),
                SizedBox(height: 10),
                shimmerWidget(width: Get.width, height: 185.h, radius: 10),
              ],
            ),
          ),

        ));
  }

  OnClickHandler(NewsListModal obj){
    Get.to(()=>NewsDetailsPage(obj: obj,));
    // Get.bottomSheet(
    //     controller.arrAllThemeList[0].widget!(obj),isScrollControlled: true
    // );
  }

}
