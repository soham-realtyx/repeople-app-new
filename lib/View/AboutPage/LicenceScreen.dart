import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:Repeople/Controller/LicenceController/LicenceController.dart';
import 'package:Repeople/Model/VersionScreensModelClass/VersionModelScreen.dart';
import 'package:Repeople/View/DashboardPage/BottomnavigationBar.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:Repeople/Config/Constant.dart';

import '../../Config/utils/colors.dart';

class LicenceScreen extends StatefulWidget {
  const LicenceScreen({Key? key}) : super(key: key);

  @override
  State<LicenceScreen> createState() => _LicenceScreenState();
}

class _LicenceScreenState extends State<LicenceScreen> {
  LicenceController cnt_lic=Get.put(LicenceController());
  CommonHeaderController cnt_CommonHeader =Get.put(CommonHeaderController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: CustomDrawer(animatedOffset: Offset(1.0,0),),
      drawer: CustomDrawer(animatedOffset: Offset(-1.0,0),),
      body: SafeArea(
        child: Stack(
          children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: APPBAR_HEIGHT),
                Title_1(),
                SizedBox(height: APPBAR_HEIGHT),
              ],
            ),
          ),
            cnt_CommonHeader.commonAppBar(OPEN_SOURCE_LICENCE, cnt_lic.GlobalLicneceKey,color: white),
            Align(
              alignment: Alignment.bottomCenter,
              child: BottomNavigationBarClass(),
            )
          ],
        ),
      ),

    );
  }
  Widget Title_1() {
    return  Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
        child: ListView.builder(
            shrinkWrap: true,
            primary: false,
            scrollDirection: Axis.vertical,
            itemCount: cnt_lic.verisionList.length,
            itemBuilder:(context,index){
              VersionModelScreen obj = cnt_lic.verisionList[index];
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 0.0, right: 0.0, bottom: 10),
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: new BoxDecoration(
                            color: white,
                            boxShadow: [fullcontainerboxShadow],
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(cornarradius),
                              topLeft: Radius.circular(cornarradius),
                              bottomLeft: Radius.circular(cornarradius),
                              bottomRight: Radius.circular(cornarradius),
                            ),
                          ),
                          child: Theme(
                              data: Theme.of(Get.context!).copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                title: Text(obj.depencyname.toString(), style: TextStyle(fontSize: 15, color: gray_color, fontWeight: FontWeight.w600, fontFamily: fontFamily, height: 1.5)),
                                subtitle: Text(obj.depencyversion.toString() , style: TextStyle(fontSize: 13, color: gray_color_2, fontFamily: fontFamily, height: 1.5)),
                                trailing: Container(child: Icon(Icons.arrow_drop_down_outlined),) ,
                                initiallyExpanded: false,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      width: MediaQuery.of(Get.context!).size.width,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0),
                                        ),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            height: 1,
                                            color: APP_THEME_COLOR.withOpacity(0.1),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 17),
                                            child: Text(obj.depencydisciption.toString(),maxLines: 5,overflow: TextOverflow.ellipsis,style:TextStyle(fontSize: 13, color: gray_color, fontWeight: FontWeight.w400, fontFamily: fontFamily, ) ,),
                                          )

                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )

                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            } )
    );
  }
}
