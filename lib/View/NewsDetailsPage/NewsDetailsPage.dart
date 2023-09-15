import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:Repeople/Widgets/ShimmerWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';

import '../../Model/News/NewsModal.dart';

class NewsDetailsPage extends StatefulWidget {
  // NewsListClass? obj;
  NewsListModal obj;
  NewsDetailsPage( {required this.obj});

  @override
  _NewsDetailsPageState createState() => _NewsDetailsPageState();
}

class _NewsDetailsPageState extends State<NewsDetailsPage> {
  CommonHeaderController cnt_Header = Get.put(CommonHeaderController());
  GlobalKey<ScaffoldState> NewsDetailsscaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_WHITE,
      key: NewsDetailsscaffoldKey,
      endDrawer: CustomDrawer(animatedOffset: Offset(1.0,0),),
      drawer: CustomDrawer(animatedOffset: Offset(-1.0,0),),
      body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: APPBAR_HEIGHT),
                    NewsDetailsTheme_1_new(widget.obj),
                    SizedBox(
                      height: 70,
                    ),
                  ],
                ),
              ),
              cnt_Header.commonAppBar(NEWS_APPMENUNAME_CAP, NewsDetailsscaffoldKey,color: AppColors.NEWAPPBARCOLOR)
            ],
          )
      ),
    );
  }
  Widget NewsDetailsTheme_1_new(NewsListModal obj) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),

            obj.newsimage != ""
                ? Stack(
              children: [
                ClipRRect(
                  borderRadius:
                  BorderRadius.circular(cornarradius),
                  child: CachedNetworkImage(
                    width: Get.width,
                    fit: BoxFit.fill,
                    fadeInDuration: Duration.zero,
                    fadeOutDuration: Duration.zero,
                    placeholderFadeInDuration: Duration.zero,
                    imageUrl: obj.newsimage ?? "",
                  ),
                ),
                obj.newscategory!.isNotEmpty
                    ? Positioned(
                    top: 10,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 6,
                          bottom: 6,
                          left: 8,
                          right: 8),
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(6),
                        color:
                        APP_FONT_COLOR.withOpacity(0.8),
                      ),
                      child: Center(
                        child: Text(
                          "${obj.newscategory ?? ""}",
                          maxLines: 2,
                          style: mediumTextStyle(
                              fontSize: 9, txtColor: white),
                          // TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: gray_color),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ))
                    : SizedBox()
              ],
            )
                : Container(),
            obj.newsimage != ""
                ? SizedBox(
              height: 10,
            )
                : SizedBox(),
            SizedBox(
              height: 10,
            ),
            Text(obj.title!,
                style: TextStyle(
                    fontSize: 15,
                    color: DARK_BLUE,
                    fontWeight: FontWeight.w700,
                    fontFamily: fontFamily,
                    height: 1.5)),
            SizedBox(
              height: 8,
            ),

            Text(
              obj.newspublishdate!,
              style: regularTextStyle(
                  txtColor: gray_color_1,
                  fontSize: 11,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 15,
            ),

            Html( data: obj.description ?? ""),

            // SizedBox(
            //   height: 8,
            // ),

            /*Html(
              data: '''
                      <p>Unlike Square Yards which was trying to address the retail market, ANAROCK&rsquo;s business model was focusing on a different go-to-market strategy. They entered the market via the mandate sale model.</p>

<p>First thing first, we love the responses you guys have sent via comments, emails, and messages. It motivates us to do better every time. In huge public demand, we have got our next title. And it would cater to the only Proptech unicorn India currently has, and it&rsquo;s NOBROKER.COM. But, for now, let&rsquo;s shift our focus back to where we left off. After covering the journey of Square Yards, let&rsquo;s look into ANAROCK and close this two-part series to conclude why we feel both these companies are on the same destinations via different journeys.</p>

                    <p>ANAROCK - How It All Began</p>

<p>It actually began in 2007 and not in 2017. Anuj Puri joined JLL in 2007 when his company Trammell Crow Meghraj (TCM), merged with the Indian arm of the global real estate services firm JLL. He held a 50% stake in JLL Residential and bought out the rest in 2017, turning the unit into ANAROCK.</p>

<p>Currently, ANAROCK is headquartered in Mumbai with a staff complement of over 1,500 qualified and experienced professionals. With offices in all major markets in the country and dedicated services in Dubai, ANAROCK also has a global footprint with over 80,000 preferred channel partners. Today, ANAROCK does everything under the sun when it comes to Real Estate Advisory. Furthermore, it goes without saying that in the last 5 years it has spread its wings to almost every sector that leading IPC consultants have been active in and today probably has gone beyond them including JLL India.</p>

                      ''',
            ),*/
            SizedBox(
              height: 8,
            ),
            obj.newssecondimage!=null?ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(
                fadeInDuration: Duration.zero,
                fadeOutDuration: Duration.zero,
                placeholderFadeInDuration: Duration.zero,
                imageUrl:obj.newssecondimage??"",
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  return shimmerWidget(width: Get.width,height: 184.w,radius: 6);
                },
                errorWidget: (context, url, error) {
                  return Image.network(
                    obj.newssecondimage??"",
                    height: 184.w,
                    width: Get.width,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ):SizedBox(),
            SizedBox(
              height: 180,
            ),
          ],
        ),
      ),
    );
  }
}
