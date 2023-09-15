import 'dart:convert';
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:Repeople/Model/PropertiesDetailModel/PropertiesDetailModel.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:Repeople/Widgets/ShimmerWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Controller/ComplaintController/AddNewComplaintController.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Config/Function.dart';
import '../../Config/utils/Images.dart';
import '../../Config/utils/styles.dart';
import '../../Controller/ComplaintController/ComplaintListController.dart';
import '../../Model/Flat ListModal/FlatListModal.dart';
import '../../Widgets/CommomBottomSheet.dart';
import '../../Widgets/TextEditField.dart';

class rdata{
  Image? img;
  rdata({this.img});
}
class f_relation{
  String? fid;
  String? name;
  String? fno;
  String? bname;
  f_relation({this.fid, this.name, this.fno, this.bname});
}
class AddNewGrievance extends StatefulWidget {
  RxList<PropertiesDetailModel2>? myPropertiesDetailsList=RxList([]);

  AddNewGrievance({Key? key,this.myPropertiesDetailsList}) : super(key: key);
  @override
  _AddNewGrievanceState createState() => new _AddNewGrievanceState();
}
class _AddNewGrievanceState extends State<AddNewGrievance> {


  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());
  AddNewComplaintController cnt_addcom = Get.put(AddNewComplaintController());
  ComplaintListController cnt_comp = Get.put(ComplaintListController());

  int dropdownValue2=0;

  var flatdata;
  List data = [];
  final _formKey = GlobalKey<FormState>();

  TextEditingController msg=new TextEditingController();
  String? token;

  @override
  void initState() {
    cnt_comp.dropdownvaluenew=null;
    cnt_comp.dropdownvalue1.value=null;
    cnt_comp.arrImageAndFileList=RxList([]);
    cnt_comp.txtMassageNew.value?.clear();

    super.initState();

     cnt_comp.RetrievGrievanceListData();
     cnt_comp.RetrieveFlatListData().then((value) {setState(() {});});
     cnt_comp.dropdownvaluenew=FlatListModal();
     cnt_comp.dropdownvaluenew = FlatListModal();
     cnt_comp.dropdownvalue1new.value = FlatListModal();
  }

     _loaddata()async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    setState(() {
      flatdata=sharedPreferences.getString("data");
      flatdata=jsonDecode(flatdata);
      if(flatdata!=null && flatdata.length==1){
        dropdownValue2=int.parse(flatdata[0]['id'].toString());
      }
    });
  }








  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.BACKGROUND_WHITE,
      key: cnt_addcom.Globalnewgrievancekey,
      endDrawer: CustomDrawer(
        animatedOffset: Offset(1.0, 0),
      ),
      drawer: CustomDrawer(
        animatedOffset: Offset(-1.0, 0),
      ),
     //  appBar: buildAppBar(),
      body:  SafeArea(
        child: Form(
          key: _formKey,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              SingleChildScrollView(
                  child:  Padding(
                    padding: EdgeInsets.only( top: 80,right: 20,left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(widget.myPropertiesDetailsList!=null)Stack(
                          // alignment: Alignment.bottomCenter,
                          children: [
                            Container(
                              width: Get.width,
                              height: 100.w,
                              // margin: EdgeInsets.only(left: 20,right: 20),
                              padding: EdgeInsets.only(
                                  top: 8.w, bottom: 8.w, right: 8.w, left: 8.w),
                              decoration: CustomDecorations()
                                  .backgroundlocal(white, 10, 0, white),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // if(obj_MypropertiesList.logosvg!=null)
                                      Container(
                                        color: BACKGROUNG_GREYISH,
                                        child:
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child:
                                          // Image.network(obj_MypropertiesList.featureimg??"")

                                          CachedNetworkImage(
                                            width: 84.w, height: 84.w,
                                            placeholder: (context, url) => shimmerWidget(  width: 90, height: 85,radius:8 ),
                                            fadeInDuration: Duration.zero,
                                            fadeOutDuration: Duration.zero,
                                            placeholderFadeInDuration: Duration.zero,
                                            imageUrl:  widget.myPropertiesDetailsList![0].featureimg??"",
                                            fit: BoxFit.fill,
                                            errorWidget: (context, url, error) {
                                              return SvgPicture.network(
                                                  widget.myPropertiesDetailsList![0].featureimg??"",
                                                  width: 84.w, height: 85.w, fit: BoxFit.fill
                                                // height: 20, width: 20
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.h,
                                      ),
                                      Obx(() =>  Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          if(widget.myPropertiesDetailsList![0].inventorytypeid=="1")
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text("${widget.myPropertiesDetailsList![0].plot?.replaceAll(" ", "")}${","}",
                                                    style: boldTextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w500,
                                                        txtColor: new_black_color)),
                                                SizedBox(
                                                  height: 2.w,
                                                ),
                                                Text(
                                                    widget.myPropertiesDetailsList![0].inventorytype??"",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 12.sp,
                                                        fontFamily: fontFamily,
                                                        color: new_black_color)),
                                              ],
                                            ),
                                          if(widget.myPropertiesDetailsList![0].inventorytypeid=="2")
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text("${widget.myPropertiesDetailsList![0].villa?.replaceAll(" ", "")}${","}",
                                                    style: boldTextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w500,
                                                        txtColor: new_black_color)),
                                                SizedBox(
                                                  width: 2.w,
                                                ),
                                                Text(
                                                    widget.myPropertiesDetailsList![0].inventorytype??"",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 12.sp,
                                                        fontFamily: fontFamily,
                                                        color: new_black_color)),
                                              ],
                                            ),

                                          if(widget.myPropertiesDetailsList![0].inventorytypeid=="3")
                                            Column(
                                              crossAxisAlignment:  CrossAxisAlignment.start,
                                              children: [
                                                Text(widget.myPropertiesDetailsList![0].unit.toString().replaceAll(" ", ""),
                                                    style: boldTextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700,
                                                        txtColor: DARK_BLUE)),
                                                SizedBox(
                                                  height: 5.h,
                                                ),
                                                Text(
                                                    widget.myPropertiesDetailsList![0].floor??"",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 12.sp,
                                                        fontFamily: fontFamily,
                                                        color: new_black_color)),
                                              ],
                                            ),

                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          Text(
                                              widget.myPropertiesDetailsList![0].project??"",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 12.sp,
                                                  fontFamily: fontFamily,
                                                  color: new_black_color)),
                                          SizedBox(
                                            height: 2.h,
                                          ),
                                          Text(widget.myPropertiesDetailsList![0].area ?? "",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12.sp,
                                                  fontFamily: fontFamily,
                                                  color: new_black_color)),
                                        ],
                                      )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                                top: 8.h,
                                right: 30.w,
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 4),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: DARK_BLUE),
                                    child: Text("3BHK",
                                        style: semiBoldTextStyle(
                                            fontSize: 10, txtColor: white)),
                                  ),
                                ))
                          ],
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: Get.width,
                          decoration: CustomDecorations().backgroundlocal(
                              white, 10, 0, DARK_BLUE_WITH_OPACITY),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8,right: 8,top: 16,bottom: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[

                                CommonDropDownTextField(
                                  labelText: "Category*",
                                  onTap: () {
                                    cnt_comp.SelectGrievanceType();
                                  },
                                  // imageIcon: IMG_PROJECT_SVG_DASHBOARD,
                                  imageIcon: IMG_PROJECT_SVG_NEW,
                                  controller: cnt_comp.txtgrievance,
                                  hintText: cnt_comp.txtgrievance.text,
                                ),

                                SizedBox(height: 10),
                                Container(
                                    alignment: Alignment.center,
                                   child:
                                cnt_comp.AttachementWidget()),
                                Divider(color: LIGHT_GREY,thickness: 0.5,),
                                SizedBox(height: 10),
                                Obx(() =>
                                    DropdownButtonFormField<FlatListModal>(
                                      isExpanded: true,
                                      // autovalidateMode: AutovalidateMode.onUserInteraction,
                                      isDense:cnt_comp.dropdownvalue1new.value!=null? false:true,
                                      // // isExpanded: true,
                                      // itemHeight: 50,

                                      decoration: InputDecoration(
                                        hintText: "Select Flat",
                                        // hintStyle: TextStyle(color: Colors.black),
                                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: LIGHT_GREY)),
                                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: LIGHT_GREY)),
                                        errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                        disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                        focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                                        // contentPadding: EdgeInsets.all(20),
                                        labelStyle: TextStyle(
                                            fontSize: 16.sp,
                                            color:
                                            NewAppColors.GREY,

                                            fontWeight: FontWeight.w600),
                                        contentPadding: EdgeInsets.only(bottom: 5,top: 10),
                                        label: Text("Flat*"),
                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                        hintStyle: TextStyle(
                                            fontSize: 16.sp,
                                            height: 1.5,
                                            color: gray_color_1,
                                            fontWeight: FontWeight.w700),

                                      ),
                                      icon: SvgPicture.asset(IMG_DROPDOWN_SVG_2,height: 24,width: 24,),
                                      dropdownColor: Colors.transparent,
                                      elevation: 5,
                                      value: null,
                                      //  value: cnt_comp.dropdownvaluenew,
                                      validator: (value) {
                                        if (value == null) {
                                          return "" + "Select a flat";
                                        }
                                        return null;
                                      },

                                      onChanged: (FlatListModal? newValue) {
                                        cnt_comp.dropdownvaluenew=FlatListModal();
                                        cnt_comp.dropdownvaluenew = newValue!;
                                        cnt_comp.dropdownvalue1new.value = newValue;
                                        cnt_comp.dropdownvalue1new.update((val) { });

                                      },

                                      selectedItemBuilder: (BuildContext context) {
                                        return cnt_comp.arrflatdataList.map<Widget>((value) {
                                          return  Container(
                                            alignment: Alignment.centerLeft,
                                            constraints: const BoxConstraints(minWidth: 100),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  value.project.toString(),
                                                  style: TextStyle(
                                                      fontSize: 16.sp, fontWeight: FontWeight.w700),
                                                ),
                                                Text(
                                                  value.unitdetails.toString() ,
                                                  style: TextStyle(fontSize: 13.sp),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList();
                                      },
                                      items: cnt_comp.arrflatdataList
                                          .map<DropdownMenuItem<FlatListModal>>((FlatListModal value) {
                                        var idx = cnt_comp.arrflatdataList.indexOf(value);
                                        return DropdownMenuItem<FlatListModal>(
                                          value: value,
                                          child: Obx(()=>  Container(
                                            decoration: BoxDecoration(
                                              color: white,
                                              boxShadow: [
                                                if(idx.toString()=="0")  BoxShadow(
                                                    color: hex("266CB5").withOpacity(0.03),
                                                    blurRadius: 4,
                                                    offset: Offset(0,0),
                                                    spreadRadius: 4
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              children: [
                                                cnt_comp.dropdownvalue1new.value == value
                                                    ? Container(
                                                  height: 60,
                                                  width: 7,
                                                  color: APP_THEME_COLOR,
                                                )
                                                    : Container(
                                                  width: 10,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8.0,top: 8,bottom: 8),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        value.project.toString(),
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            fontWeight: FontWeight.w500),
                                                      ),
                                                      Text(
                                                        value.unitdetails.toString() ,
                                                        // "," +
                                                        // value.flatno.toString(),
                                                        style: TextStyle(fontSize: 13),
                                                      ),

                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),

                                        );
                                      }).toList(),
                                    )),
                                SizedBox(height: 10),
                                Container(
                                  alignment: Alignment.center,
                                  child: cnt_addcom.
                                QueryTextField_3
                                  (cnt_comp.txtMassageNew),),
                                SizedBox(height: 24.h,),
                                SubmitButton_4(),


                              ],),
                          ),
                        ),
                        SizedBox(height: 40.h,),
                      ],
                    ),
                  ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child:    cnt_CommonHeader.commonAppBar("New Grievance", cnt_addcom.Globalnewgrievancekey,color: white)
              ),

            ],
          ),),
      ),
    );
  }
  TextEditingController userController=new TextEditingController();


  Widget SubmitButton_4() {
    return OnTapButton(
        onTap: (){
          if (_formKey.currentState!.validate()) {
            cnt_comp.AddNewGrievanceData();
          }
        },
        height: 40,
        decoration:
        CustomDecorations().backgroundlocal(APP_THEME_COLOR, cornarradius, 0, APP_THEME_COLOR),
        text: "Submit".toUpperCase(),
        style: TextStyle(color: white, fontSize: 14,fontWeight: FontWeight.w500)
    );
  }

  Widget SubmitButton_1() {
    return Container(
      width: Get.width,
      padding: EdgeInsets.only(top: 30, bottom: 30),
      decoration: BoxDecoration(
          color: APP_THEME_COLOR,
          borderRadius:
          BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))),
      child: Center(
        child: OnTapButton(
            onTap: (){
              // if(_mySelection==0){
              //   ErrorMsg("Timming_System_Message_Chat_Screenievance Type", title: "error");
              //   //Scaffold.of(context).showSnackBar(SnackBar(content: Text('Timming_System_Message_Chat_Screenievance Type')));
              // }
              // if(dropdownValue2==0){
              //   ErrorMsg("Select Flat Building", title: "error");
              //   //Scaffold.of(context).showSnackBar(SnackBar(content: Text('Select Flat Building')));
              // }
              if (_formKey.currentState!.validate()) {

                // if(_mySelection!=0 && dropdownValue2!=0){
                  //   submitComplaint();

                  SuccessMsg("Submitted successfully", title: "Success");
                  Get.back();
                 // Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
                // }
              }
            },
            width: 120,
            height: 40,
            text: "Submit",
            decoration: CustomDecorations().backgroundlocal(white, cornarradius, 0, white),
            style: TextStyle(color: APP_FONT_COLOR)),
      ),
    );
  }

}
