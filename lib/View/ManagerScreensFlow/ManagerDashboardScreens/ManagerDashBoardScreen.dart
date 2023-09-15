import 'package:Repeople/Controller/DashBoardHeaderController/DashboardHeaderController.dart';
import 'package:Repeople/View/DashboardPage/BottomnavigationBar.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Widgets/CommomBottomSheet.dart';
import 'package:Repeople/Widgets/CustomAppBar.dart';

import '../../../Controller/ManagerFlowController/ManagerDashboardController/ManagerDashboardController.dart';



class ManagerDashboardPage extends StatefulWidget {
  @override
  _ManagerDashboardPageState createState() => _ManagerDashboardPageState();
}

class _ManagerDashboardPageState extends State<ManagerDashboardPage> {


  // CustomDrawerController cnt_Drawer = Get.put(CustomDrawerController());
  ManagerDashboardController cnt_manager = Get.put(ManagerDashboardController());
  GlobalKey<ScaffoldState> ManagerDashboardkey = new GlobalKey<ScaffoldState>();
  DashboardHeaderController cnt_dashheader = Get.put(DashboardHeaderController());
  ScrollController scrollController=ScrollController();

  @override
  void initState() {
    super.initState();
    BottomNavigationBarClass().selectedIndex=0;
    cnt_manager.HomeController();
    cnt_dashheader.check.value=ManagerDashboardkey;
    scrollController.addListener(() {
      cnt_manager.scrollUpdate(scrollController);
    });
  }



  ExitDialog() {
    LoginDialoge(
        dialogtext: "Do you want to exit App?",
        stackicon: Image.asset(
          IMG_PLAYSTORE_PNG,
          color: Colors.white,
          width: 40,
          height: 40,
        ),
        firstbuttontap: () {
          Get.back();
        },
        secondbuttontap: () {
          exit(0);
        },
        secondbuttontext: "Yes",
        firstbuttontext: "No");
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => ExitDialog(),
        child: Scaffold(
            backgroundColor: AppColors.BACKGROUND_WHITE,
            key: ManagerDashboardkey,
            endDrawer: CustomDrawer(
              animatedOffset: Offset(1.0, 0),
            ),
            drawer: CustomDrawer(
              animatedOffset: Offset(-1.0, 0),
            ),
            body: Obx(() => Container(
                child: Stack(
                  children: [
                    CustomScrollView(
                      slivers: <Widget>[
                        SliverList(
                          delegate: SliverChildListDelegate([
                            SizedBox(height: 130,)
                          ]),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                              return cnt_manager.arrSetThemeWidget[index].widget;
                            },
                            // Or, uncomment the following line:
                            childCount: cnt_manager .arrSetThemeWidget.length,
                          ),
                        ),
                        SliverList(delegate: SliverChildListDelegate([SizedBox( height: 60,)]),)
                      ],
                    ),
                    dashBoardHeader(),
                  ],
                )))));
  }
  
}
