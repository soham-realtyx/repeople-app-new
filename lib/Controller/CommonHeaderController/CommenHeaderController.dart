import 'dart:ui';

import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Controller/BottomNavigator/BottomNavigatorController.dart';
import 'package:Repeople/Model/Theme/WidgetThemeListClass.dart';
import 'package:Repeople/Widgets/CustomAppBar.dart';

class CommonHeaderController extends GetxController {
  RxList<WidgetAppbarThemeListClass> arrHeaderThemeList = RxList<WidgetAppbarThemeListClass>();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    this.CreateHeaderThemeList();
  }

  // Close Data

  ClosePageCallback(){
    var getPageStringList = Get.currentRoute.split(" ");
    String pageName = getPageStringList.last;
    BottomNavigatorController cntBottom = Get.put(BottomNavigatorController());
    if(pageName == "ProjectListPage" || pageName == "FavoritePage"){
      cntBottom.SelectIndex(0);
    }
    else{
      Get.back();
    }
  }

  CreateHeaderThemeList() {
    arrHeaderThemeList.add(WidgetAppbarThemeListClass(COMMON_HEADER_1, (title , scaffoldKey) {
      return commonAppBar(title , scaffoldKey);
    }));
    arrHeaderThemeList.add(WidgetAppbarThemeListClass(COMMON_HEADER_2, (title , scaffoldKey) {
      return Common_Header2(title,scaffoldKey);
    }));
    arrHeaderThemeList.add(WidgetAppbarThemeListClass(COMMON_HEADER_3, (title , scaffoldKey) {
      return Common_Header3(title ,scaffoldKey);
    }));
    arrHeaderThemeList.add(WidgetAppbarThemeListClass(COMMON_HEADER_4, (title , scaffoldKey) {
      return Common_Header6(title , scaffoldKey);
    }));
    arrHeaderThemeList.add(WidgetAppbarThemeListClass(COMMON_HEADER_5, (title , scaffoldKey) {
      return Common_Header4(title , scaffoldKey);
    }));

    arrHeaderThemeList.refresh();
  }

  //<editor-fold desc = "Header 1 , Header 2 , Header 3 , Header 4 , Header 5">

  // appbar 1
  Widget commonAppBar(String title ,
      GlobalKey<ScaffoldState> scaffoldKey,
      {bool showSearch=false,
        bool isNotificationHide=false,
        Color? color,
        bool ismenuiconhide=false,
        bool iscentertitle=false,
        isshowhistoryicon=false,
      }) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: CustomDetailsAppBar(
          title: "Project List",
          height: APPBAR_HEIGHT,
          color: Colors.grey.shade200.withOpacity(0.2) ?? AppColors.WHITE.withOpacity(0.0),
          // color: APP_GRAY_COLOR,
          leadingWidget: [
            // InkWell(
            //     onTap: () => ClosePageCallback(),
            //     child: SvgPicture.asset(IMG_BACKARROW_SVG_NEW,height: 18,)
            // ),
            // SizedBox(width: 20),
            GestureDetector(
              onTap: () => ClosePageCallback(),
              child: Container(
                margin: const EdgeInsets.only(left: 14),
                width: 24,
                height: 24,
                // padding: EdgeInsets.only(left: 8,top: 6,bottom: 6,right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: hex("006CB5").withOpacity(0.2)
                ),
                child: Center(
                  child: SvgPicture.asset(IMG_LEFT_BACK_ARROW_SVG,height: 12,width: 6,color: hex("006CB5")),
                ),
              ),
            ),

            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: iscentertitle?
                Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: DARK_BLUE, fontSize: 18,
                        fontWeight: FontWeight.w700,
                      fontFamily: fontFamily,
                      // overflow: TextOverflow.ellipsis,
                    ),maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                )
                    : Text(
                  title,
                  style: TextStyle(color: DARK_BLUE, fontSize: 16,
                      fontWeight: FontWeight.w700,overflow: TextOverflow.ellipsis),maxLines: 1,
                ),
              ),
            )
          ],
          trillingWidget: [
          if(showSearch)  TrallingIconSearch(IMG_SEARCH,APP_FONT_COLOR,(){}),
          if(!isNotificationHide) TrallingIconNotification(APP_FONT_COLOR),
          const SizedBox(width: 12,),
          if(isshowhistoryicon)  TrailingHistoryIcon(APP_FONT_COLOR),
          if(!ismenuiconhide)  TrallingIconDrawer(IMG_MENU2, APP_FONT_COLOR,(){scaffoldKey.currentState!.openEndDrawer();})
          ],
        ),
      ),
    );
  }

  // appbar 2
  Widget Common_Header2(String title, GlobalKey<ScaffoldState> scaffoldKey,{
    bool isnotificationhide=false,bool ismenuiconhide=false,isshowhistoryicon=false,}) {
    return Container(
      height: APPBAR_HEIGHT,
      // color: APP_GRAY_COLOR,

      decoration: BoxDecoration(
          color: white,
          boxShadow: [BoxShadow(blurRadius: 2, color: Colors.black12, offset: Offset(1, 1))],
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25),bottomRight: Radius.circular(25)) ),
      padding: EdgeInsets.only(left: 10,right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              // margin: EdgeInsets.only(left: 10,right: 10),
              child:
          Row(
            children: [
              IconButton(onPressed: () => ClosePageCallback(), icon: Icon(Icons.arrow_back_ios)),
              Text(
                title,
                style: TextStyle(color: APP_FONT_COLOR, fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ],
          )),

          Container(
            child: Row(
              children: [
                if(!isnotificationhide)    TrallingIconNotification(APP_FONT_COLOR),
                if(isshowhistoryicon)     TrailingHistoryIcon(APP_FONT_COLOR),
                if(!ismenuiconhide)  TrallingIconDrawer(IMG_MENU1, APP_FONT_COLOR,(){
                  scaffoldKey.currentState!.openEndDrawer();
                })
              ],
            ),
          )
        ],
      ),
    );
  }

  // appbar 3
  Widget Common_Header3(String title,
      GlobalKey<ScaffoldState> scaffoldKey,{bool isnotificationhide=false,
        bool ismenuiconhide=false, MaterialColor? color,bool showsearch=false,
        isshowhistoryicon=false,

  }) {
    return Container(
      height: APPBAR_HEIGHT,
      color: color ?? white,
      padding: EdgeInsets.only(left: 10,right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(onPressed: () => ClosePageCallback(), icon: Icon(Icons.arrow_back_ios)),
          Text(
            // title,
            "",
            style: TextStyle(color: APP_FONT_COLOR, fontSize: 20, fontWeight: FontWeight.w600),
          ),

          Container(
            child: Row(
              children: [
                // TrallingIconNotification(APP_FONT_COLOR),
                if(showsearch)  TrallingIconSearch(IMG_SEARCH,APP_FONT_COLOR,(){
                }),
                if(isshowhistoryicon)     TrailingHistoryIcon(APP_FONT_COLOR),
                  if(!ismenuiconhide)  TrallingIconDrawer(Menu_icon_theme_index_2, APP_FONT_COLOR,(){
                  scaffoldKey.currentState!.openEndDrawer();
                })
              ],
            ),
          )
        ],
      ),
    );
    // return CustomDetailsAppBar(
    //   title: "Project List",
    //   height: APPBAR_HEIGHT,
    //   color: WHITE,
    //   leadingWidget: [
    //     IconButton(onPressed: () => ClosePageCallback(), icon: Icon(Icons.arrow_back_ios)),
    //     Padding(
    //       padding: const EdgeInsets.only(left: 10),
    //       child: Text(
    //         title,
    //         style: TextStyle(color: APP_FONT_COLOR, fontSize: 20, fontWeight: FontWeight.w600),
    //       ),
    //     )
    //   ],
    //   trillingWidget: [
    //     TrallingIconNotification(APP_FONT_COLOR),
    //     TrallingIconDrawer(IMG_MENU2, APP_FONT_COLOR,(){
    //       scaffoldKey.currentState!.openEndDrawer();
    //     })
    //   ],
    // );
  }

  // appbar 4
  // CustomDrawerController cnt_drawer =
  //     Get.put(CustomDrawerController()); // this for right side open drawer
  Widget Common_Header4(String title, GlobalKey<ScaffoldState> scaffoldKey,{
    bool isnotificationhide=false,MaterialColor? color,bool showsearch=false,isshowhistoryicon=false,}) {
    return Container(
        height: APPBAR_HEIGHT,
        color: color ?? white,
        padding: EdgeInsets.all(8),
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15)
          ),
          child:
          CustomDetailsAppBar(
            title: "Project List",
            height: APPBAR_HEIGHT,
            color: APP_THEME_COLOR,
            leadingWidget: [
              TrallingIconDrawer(Menu_icon_theme_index_4, white,(){
                scaffoldKey.currentState!.openDrawer();
              })
            ],
            trillingWidget: [
              if(showsearch)  TrallingIconSearch(IMG_SEARCH,white,(){
              }),
              if(!isnotificationhide)   TrallingIconNotification(white),
              if(isshowhistoryicon)     TrailingHistoryIcon(APP_FONT_COLOR),
            ],
          ),
        ));
  }

  // appbar 5
  Widget Common_Header5(String title, GlobalKey<ScaffoldState> scaffoldKey) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: CustomDetailsAppBar(
        title: "Project List",
        height: 60,
        leadingWidget: [
          IconButton(
              onPressed: () => ClosePageCallback(),
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
        ],
        trillingWidget: [TrallingIconNotification(BLACK), TrallingIconDrawer(IMG_MENU2, BLACK,(){
          scaffoldKey.currentState!.openEndDrawer();
        })],
      ),
    );
  }

  // appbar 6
  Widget Common_Header6(String title , GlobalKey<ScaffoldState> scaffoldKey,{
    bool isnotificationhide=false,MaterialColor? color,bool showsearch=false,isshowhistoryicon=false,}) {
    return CustomDetailsAppBar(
      title: "Project List",
      height: APPBAR_HEIGHT,

      color: color ?? APP_GRAY_COLOR,
      // color: APP_GRAY_COLOR,
      leadingWidget: [
        IconButton(onPressed: () => ClosePageCallback(), icon: Icon(Icons.arrow_back_ios)),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            // title,
            "",
            style: TextStyle(color: APP_FONT_COLOR, fontSize: 20, fontWeight: FontWeight.w600),
          ),
        )
      ],
      trillingWidget: [
        if(showsearch)  TrallingIconSearch(IMG_SEARCH,APP_FONT_COLOR,(){
        }),
    if(!isnotificationhide)    TrallingIconNotification(APP_FONT_COLOR),
        if(isshowhistoryicon)     TrailingHistoryIcon(APP_FONT_COLOR),
        TrallingIconDrawer(Menu_icon_theme_index_3, APP_FONT_COLOR,(){
          scaffoldKey.currentState!.openEndDrawer();
        })
      ],
    );
  }

//</editor-fold>

}
