import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../Config/Constant.dart';
import '../../../Config/Helper/HextoColor.dart';
import '../../../Config/utils/Images.dart';
import '../../../Config/utils/Strings.dart';
import '../../../Config/utils/colors.dart';
import '../../../Config/utils/styles.dart';
import '../../../Controller/ManagerFlowController/ManagerGrievanceDetails/ManagerGrievanceDetailsController.dart';
import '../../../Model/ComplaintModel/ComplaintListModel.dart';

import '../../../Widgets/ShimmerWidget.dart';
import '../../../Widgets/TextEditField.dart';
import '../../../Widgets/select_dailog.dart';
import '../ManagerChatingScreen/ManagerChatingScreen.dart';


class ManagerGrievaceDetails extends StatefulWidget {
  String projectid;
   ManagerGrievaceDetails({Key? key,required this.projectid}) : super(key: key);

  @override
  State<ManagerGrievaceDetails> createState() => _ManagerGrievaceDetailsState();
}

class _ManagerGrievaceDetailsState extends State<ManagerGrievaceDetails> {

  GlobalKey<ScaffoldState> GlobalManagerGrievanceListkey = GlobalKey<ScaffoldState>();

  ManagerGrievaceDetailsController cnt_man=Get.put(ManagerGrievaceDetailsController());


  @override
  void initState(){
    //todo:do your code here
    super.initState();
    cnt_man.projectid.value=widget.projectid;
    cnt_man.futureGrievanceData.value=  cnt_man.RetrieveGrievanceListData();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      key: GlobalManagerGrievanceListkey,
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
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                          (context,index){
                   return Column(
                     children: [
                       CommonDropDownTextField(
                           labelText: "Grievance Status",
                           onTap: (){
                             SelectSubject();
                           },
                           imageIcon: IMG_SUBJECT_SVG_NEW,
                           controller: cnt_man.txtSubject,
                           hintText: cnt_man.txtSubject.text,
                       ),

                       ComplaintListView(),
                     ],
                   );
                      },
                      childCount: 1
                  ),
                ),

              ],
            ),

          ],
        ),
      ),
    );
  }


  SelectSubject() {
    SelectSubjectDialog((value) {
      cnt_man.obj_subject.value=value;
      cnt_man.txtSubject.text = cnt_man.obj_subject.value.name??"";
     cnt_man.futureGrievanceData.value= cnt_man.RetrieveGrievanceListData();
    });
  }

  Future<dynamic> SelectSubjectDialog(ValueChanged<dynamic> onChange) {
    return SelectDialog1.showModal(
      Get.context!,
      label: "Select Grievance Status",
      items: cnt_man.arrFillterList,
      onChange: onChange,
      searchBoxDecoration:
      InputDecoration(prefixIcon: Icon(Icons.search), hintText: "Search"),
    );
  }

  Widget ComplaintListView() {
    return Obx(() {
      return FutureBuilder(
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasError) {
            if (cnt_man.arrGrievanceList.isNotEmpty) {
              return Container(
                  child: Column(
                    children: [
                      Obx(() {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics:  NeverScrollableScrollPhysics(),
                          itemBuilder: (_, index) {
                            return Obx(() {
                              return wd_cmpl_child(index);
                            });
                          },
                          itemCount: cnt_man.arrGrievanceList.length ,
                        );
                      }),
                      SizedBox(height: 50,),
                    ],
                  ));
            } else {
              return Container(
                height: Get.height / 2,
                width: Get.width,
                padding: const EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Obx(() {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        cnt_man.message.value,
                        style: mediumTextStyle(
                            txtColor: AppColors.TEXT_TITLE, fontSize: 15),
                      ),

                    ],
                  );
                }),
              );
            }
          } else {
            return ShimmerWidget();
          }
        },
        future: cnt_man.futureGrievanceData.value,
      );
    });
  }

  Widget ShimmerWidget() {
    return ShimmerEffect(
        child: Container(

          child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) {
                return Padding(
                  padding: EdgeInsets.all(8.w),
                  child: shimmerWidget(width: Get.width, height: 100.w, radius: 10),
                );
              },
              itemCount: 6),
        ));
  }

  Widget wd_cmpl_child(int index) {
    GrievanceListModel obj = cnt_man.arrGrievanceList[index];
    double space = 8.w;
    return GestureDetector(
        onTap: () {
          Get.to(Manager_grievance_details(id:obj.id??"" ));
        },
        child:Padding
          (
          padding: EdgeInsets.only(left: 0.0, right: 0.0, bottom: 0.0, top: 0.0),
          child:  Container(
            decoration: BoxDecoration(
              color: white,
              boxShadow: [fullcontainerboxShadow],
              borderRadius: BorderRadius.only(topLeft: Radius.circular(cornarradius),topRight:
              Radius.circular(cornarradius),bottomRight: Radius.circular(cornarradius),
                  bottomLeft: Radius.circular(cornarradius)),
            ),
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child:  Column(
              children: <Widget>[
                Padding(
                  padding:  EdgeInsets.all(2.0),
                  child: Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 4.0, top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Container(
                                child: Text(''+obj.raiseId.toString(),style:
                                semiBoldTextStyle(fontSize: 13,),
                                )),
                            Container(
                              decoration: BoxDecoration(
                                // color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: HexColor(obj.color??""),width: 0.5)
                              ),
                              child:Padding(padding: EdgeInsets.only(top: 5,bottom: 6,right: 10,left: 10),
                                child:Text(obj.status??"",style: mediumTextStyle(fontSize: 10,txtColor:HexColor(obj.color??"") ),maxLines: 1,overflow: TextOverflow.ellipsis,),),
                            )

                          ],),
                      ),
                      // Divider(color: APP_FONT_COLOR,thickness: 0.2,),
                      Divider(thickness: 1, color: hex("f1f1f1"),),

                      Padding( padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5.0, top: 5.0),
                          child: Text(obj.message!=""?getdata(obj.message??""):'',
                            style:
                            // mediumTextStyle(fontSize: 14),
                            TextStyle(
                                fontSize: 15,
                                color: gray_color,
                                fontWeight: FontWeight.w600,
                                fontFamily: fontFamily,height: 1.5
                            ),
                            // TextStyle(fontSize:18,/*fontFamily: myfont,*/color: Colors.black),))),],),
                          )),
                      if(obj.project!=null && obj.project!="")
                        Padding(
                          padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5.0, top: 5.0),
                          child: Container(
                            margin: EdgeInsets.only(top: 0),
                            padding: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue.withOpacity(0.08)),
                              borderRadius: new BorderRadius.circular(15.0),
                              // color: APP_THEME_COLOR.withOpacity(0.01),
                              color: AppColors.BACKGROUND_WHITE,
                            ),
                            child: Container(
                                child:Text(obj.project??"",
                                  style: TextStyle(color: gray_color, fontWeight: FontWeight.bold,fontSize: 10.w),
                                  // TextStyle(color:Colors.black,/*fontFamily: myfont*/)
                                )),

                          ),
                        ),
                      if(obj.reply!=null && obj.reply!="")
                        Padding(
                          padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5.0, top: 5.0),
                          child: Row(
                            children: [
                              Text('Last Replied by: ',
                                style: TextStyle(color: gray_color_1, fontSize: 11),
                              ),
                              Text(obj.reply ?? "",
                                style: mediumTextStyle(txtColor: gray_color, fontSize: 12),
                              ),


                            ],),
                        ),
                      if(obj.time!=null && obj.time!="")
                        Padding( padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 12.0, top: 5.0),
                            child:Text(/*date_data(complaint_list[index]['last_replied_at'])*/obj.time??'',
                              style:
                              // regularTextStyle(fontSize: 13),
                              regularTextStyle(txtColor: gray_color_1,fontSize: 11),
                              // TextStyle(color:Colors.black,/*fontFamily: myfont*/)
                            )),],),),
                // SizedBox(height: 5,),
                // Divider()
              ],

            ),
          ),
          // ),
        ));
  }

  String getdata(String str) {
    return str.length>20?str.substring(0,20)+"...":str;
  }



}
