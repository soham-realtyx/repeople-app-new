import 'package:flutter/material.dart';
import 'package:Repeople/Config/Helper/shared_prefrence.dart';
import 'package:Repeople/Controller/BottomNavigator/BottomNavigatorController.dart';
import 'package:get/get.dart';

import '../../Config/Constant.dart';

class BottomNavigationBarClass extends StatefulWidget {

  late int selectedIndex = 0;

  @override
  _BottomNavigationBarClassState createState() => _BottomNavigationBarClassState();
  BottomNavigationBarClass({super.key, this.selectedIndex = 0});
}

class _BottomNavigationBarClassState extends State<BottomNavigationBarClass> {
  RxBool isLogin=false.obs;
  BottomNavigatorController cntBottom = Get.put(BottomNavigatorController());
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      cntBottom.selectedIndex.value=widget.selectedIndex;
      isLogin.value=UserSimplePreference.getbool(IS_USER_LOGIN) ?? false;
      // TODO: implement initState
      cntBottom.futurethemelist.value= cntBottom.addthemeaccordinglist();
      cntBottom.futureData.value= cntBottom.adddata();
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return Obx(() =>   cnt_Bottom.arrBottomNavigationSelectList[0].widget);
      return FutureBuilder(
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState
              == ConnectionState.done &&
              snapshot.data != null) {
            return  Obx(() =>  cntBottom.arrBottomNavigationSelectList[GLOBAL_THEME_INDEX.value].widget);
          } else {
            // return Container(height: 100,color: Colors.red,);
            return   cntBottom.arrBottomNavigationSelectList[GLOBAL_THEME_INDEX.value].widget;
          }
        },
        future:cntBottom.futurethemelist.value,
      );
  }
}
