import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Constant.dart';

import '../../../Config/utils/Strings.dart';
import '../../../Config/utils/colors.dart';
import '../../../Controller/ManagerFlowController/ManagerAccountController/ManagerAccountController.dart';



class ManagerAccountScreen extends StatefulWidget {
  const ManagerAccountScreen({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<ManagerAccountScreen> {

  ManagerAccountController cnt_account = Get.put(ManagerAccountController());
  GlobalKey<ScaffoldState> GlobalManagerAccountPagekey = GlobalKey<ScaffoldState>();


  @override
  void initState(){
    cnt_account.arrAllTheme.clear();
    cnt_account.arrNoFoundListTheme.clear();
    cnt_account.CreateNoDataFoundTheme();
    cnt_account.CreateProjectWidgetTheme();
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<ManagerAccountController>();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_WHITE,
      key: GlobalManagerAccountPagekey,
      endDrawer: CustomDrawer(
        animatedOffset: Offset(1.0, 0),
      ),
      drawer: CustomDrawer(
        animatedOffset: Offset(-1.0, 0),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: APPBAR_HEIGHT,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      cnt_account.arrAllTheme.length == 0
                          ? ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return cnt_account.arrNoFoundListTheme[index].widget;
                        },
                        shrinkWrap: true,
                        // Or, uncomment the following line:
                        itemCount: cnt_account.arrNoFoundListTheme.length != 0
                            ? cnt_account.arrNoFoundListTheme.length
                            : 0,
                      )
                          : ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return  cnt_account.arrAllTheme[index].widget;
                        },
                        shrinkWrap: true,
                        // Or, uncomment the following line:
                        itemCount: cnt_account.arrAllTheme.length != 0
                            ? cnt_account.arrAllTheme.length
                            : 0,
                      ),
                        // cnt_account.FirstAccount()
                    ],
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
