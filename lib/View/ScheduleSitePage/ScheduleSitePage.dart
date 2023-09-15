import 'package:Repeople/Controller/ScheduleSiteController/ScheduleVisitController.dart';
import 'package:Repeople/View/DashboardPage/BottomnavigationBar.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import '../../Config/utils/colors.dart';

class ScheduleSitePage extends StatefulWidget {
  const ScheduleSitePage({Key? key}) : super(key: key);

  @override
  _ScheduleSitePageState createState() => _ScheduleSitePageState();
}

class _ScheduleSitePageState extends State<ScheduleSitePage> {


  ScheduleSiteController cnt_ScheduleSite = Get.put(ScheduleSiteController());
  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());
  @override
  void initState() {
    super.initState();
    cnt_ScheduleSite.ClearData();

  }

  @override
  Widget build(BuildContext context) {
    cnt_ScheduleSite.arrAllTheme.clear();
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_WHITE,
      key: cnt_ScheduleSite.GlobalSchedualsitevisitkey,
      endDrawer: CustomDrawer(
        animatedOffset: Offset(1.0, 0),
      ),
      drawer: CustomDrawer(
        animatedOffset: Offset(-1.0, 0),
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: APPBAR_HEIGHT),
                  cnt_ScheduleSite.Theme_1(true),
                ],
              ),
            ),
            cnt_CommonHeader.commonAppBar(
                SCHEDULE_SITE, cnt_ScheduleSite.GlobalSchedualsitevisitkey,
                color: white)
          ],
        ),
      ),
      bottomNavigationBar:BottomNavigationBarClass() ,
    );
  }
}
