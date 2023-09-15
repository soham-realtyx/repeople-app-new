import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/View/DashboardPage/BottomnavigationBar.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:Repeople/Controller/MyPropertiesController/MyPropertiesController.dart';

class AccountStatementPage extends StatefulWidget {
  const AccountStatementPage({Key? key}) : super(key: key);

  @override
  State<AccountStatementPage> createState() => _AccountStatementPageState();
}

class _AccountStatementPageState extends State<AccountStatementPage> {
  MyPropertiesController cnt_Myproperties = Get.put(MyPropertiesController());
  CommonHeaderController cnt_HeaderController = Get.put(CommonHeaderController());
  GlobalKey<ScaffoldState> GlobalAccountStatementPagekey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.BACKGROUND_WHITE,
      key: GlobalAccountStatementPagekey,
      endDrawer: CustomDrawer(animatedOffset: Offset(1.0,0),),
      drawer: CustomDrawer(animatedOffset: Offset(1.0,0),),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 74.w),
                  AccountStatementData()
                ],
              ),
            ),
            cnt_HeaderController.commonAppBar("Account Statement",
            GlobalAccountStatementPagekey,isNotificationHide: true),
            Align(
              alignment: Alignment.bottomCenter,
              child: BottomNavigationBarClass(),
            )
          ],
        ),
      ),
    );
  }
  Widget AccountStatementData(){
    return Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.symmetric(horizontal: 20.h),
        itemCount: 6,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemBuilder: (context, index) {
          return _accountStatementList(index);
        },
      ),
    );
  }

  Widget _accountStatementList(int index){
    return Container(
        // height: 536.h,
        width: Get.width,
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.symmetric(horizontal: 106,vertical: 196),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: BLACK.withOpacity(0.05),
              spreadRadius: 0,
              blurRadius: 6,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Center(
          child: Image.asset(PDF_PNG_IMAGE,height: 143.h,width: 143.w,fit: BoxFit.cover),
        )
    );
  }
}
