import 'dart:ui';

import 'package:Repeople/Config/Helper/MoengageAnalyticsHandler.dart';
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Model/Theme/WidgetThemeListClass.dart';
import 'package:flutter/material.dart';

import '../../Config/utils/styles.dart';

class DashboardHeaderController extends GetxController{
  
  RxList<WidgetThemeListClass> arrDashBoardHeader = RxList<WidgetThemeListClass>();
  Rxn<dynamic> check=Rxn();
  //var Dashboardkey1 = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void openDrawerOne() {
    // _scaffoldKey.currentState!.openDrawer();
    check.value.currentState!.openEndDrawer();
  }

  void openDrawerTwo() {
    // _scaffoldKey.currentState?.openDrawer();
    check.value.currentState!.openEndDrawer();
  }
  
  @override
  void onInit() {
    super.onInit();
    this.ListOfHedaer();
  }
  
  ListOfHedaer(){
    arrDashBoardHeader.add(WidgetThemeListClass(DASHBOARD_HEADER_1, wd_header1()));
    arrDashBoardHeader.add(WidgetThemeListClass(DASHBOARD_HEADER_2, wd_header2()));
    arrDashBoardHeader.add(WidgetThemeListClass(DASHBOARD_HEADER_3, wd_header3()));
    arrDashBoardHeader.add(WidgetThemeListClass(DASHBOARD_HEADER_4, wd_header4()));
    arrDashBoardHeader.add(WidgetThemeListClass(DASHBOARD_HEADER_5, wd_header5()));
  }

  //<editor-fold desc = " HEADER 1 , HEADER 2 , HEADER 3 , HEADER 4 ">

  // header2
  Widget wd_header2(){
    return Container(
      color: white,
      height: APPBAR_HEIGHT,
      alignment: Alignment.center,
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 20,
                    top: 05,
                    bottom: 5,
                    child: Row(
                      children: [
                        leadingIconOfAppbar()
                      ],
                    ),
                  ),
                  Positioned(
                    right: 5,
                    top: 5,
                    bottom: 5,
                    child: Row(
                        children: [
                          TrallingIconNotification(APP_FONT_COLOR),
                          TrallingIconDrawer(IMG_MENU2,APP_FONT_COLOR,(){
                            GlobalDeclaredkey.currentState!.openEndDrawer();
                          })
                        ]
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // header 1
  Widget wd_header1(){
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          //color: APP_GRAY_COLOR,
          height: 70.w,
          width: Get.width,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.0),
              boxShadow: [
                fullcontainerboxShadow
                // BoxShadow(
                //     color: Colors.black.withOpacity(0.03),
                //     blurRadius: 4,
                //     offset: Offset(0,5),
                //     spreadRadius: 1
                // )
              ]
          ),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 20,
                        top: 5,
                        bottom: 5,
                        child: Row(
                          children:[
                            leadingIconOfAppbar()
                          ],
                        ),
                      ),
                      Positioned(
                        right: 7,
                        top: 5,
                        bottom: 5,
                        child: Row(
                          children: [
                            TrallingIconNotification(APP_FONT_COLOR,

                            ),
                            SizedBox(width: 12,),
                            TrallingIconDrawer(IMG_MENU2,APP_FONT_COLOR,
                             () =>
                               openDrawerTwo()
                              //check.value.currentState!.openEndDrawer();

                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // header 3
  Widget wd_header3(){
    return Container(
      // color: WHITE,
      color: Colors.grey.shade50,
      height: APPBAR_HEIGHT,
      alignment: Alignment.center,
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 25,
                    top: 5,
                    bottom: 5,
                    child: Row(
                      children:[
                        leadingIconOfAppbar()
                      ],
                    ),
                  ),
                  Positioned(
                    right: 5,
                    top: 5,
                    bottom: 5,
                    child: Row(
                      children: [
                        // TrallingIconNotification(APP_FONT_COLOR),
                        TrallingIconDrawer(Menu_icon_theme_index_2,APP_FONT_COLOR,(){
                          GlobalDeclaredkey.currentState!.openEndDrawer();
                        })
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // header 4
  Widget wd_header4(){
    return Container(
      // color: APP_GRAY_COLOR,
      color: Colors.white,
      height: APPBAR_HEIGHT,
      alignment: Alignment.center,
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 25,
                    top: 5,
                    bottom: 5,
                    child: Row(
                      children:[
                        leadingIconOfAppbar()
                      ],
                    ),
                  ),
                  Positioned(
                    right: 5,
                    top: 5,
                    bottom: 5,
                    child: Row(
                      children: [
                        TrallingIconNotification(APP_FONT_COLOR),
                        TrallingIconDrawer(Menu_icon_theme_index_3,APP_FONT_COLOR,(){GlobalDeclaredkey.currentState!.openEndDrawer();})
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // header 5
  Widget wd_header5(){
    return Container(
      height: 100,
      alignment: Alignment.center,
      color: APP_THEME_COLOR,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: TrallingIconDrawer(Menu_icon_theme_index_4,white,(){
                        GlobalDeclaredkey.currentState!.openDrawer();
                      })
                    ),
                    // leadingIconOfAppbar(WHITE)
                    leadingIconOfAppbar()
                  ],
                ),
              ),
              Row(
                children: [
                  TrallingIconNotification(white)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }



//</editor-fold>




}