import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Repeople/Model/Flat%20ListModal/FlatListModal.dart';
import 'package:Repeople/Widgets/TextEditField.dart';

import '../../Config/Constant.dart';
import '../../Config/Function.dart';
import '../../Config/utils/colors.dart';
import '../../Controller/CoOwnerConroller/AddCoOwnerConrtoller.dart';
import '../../Controller/CommonHeaderController/CommenHeaderController.dart';
import '../../Widgets/CommonBackButtonFor5theme.dart';


class AddCoOwnerPage extends StatefulWidget {
  const AddCoOwnerPage({Key? key}) : super(key: key);

  @override
  State<AddCoOwnerPage> createState() => _AddCoOwnerPageState();
}

class _AddCoOwnerPageState extends State<AddCoOwnerPage> {
  var AddCoOwnerKey=GlobalKey<ScaffoldState>();
  ScrollController scrollController = ScrollController();
  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());
  AddCoOwnerController cnt_add=Get.put(AddCoOwnerController());

  @override
  void initState(){
    super.initState();
    cnt_add.futureGrievanceData.value=cnt_add.RetrieveFlatListData().then((value) {
      setState((){});
      return value;
    });
    cnt_add.futureGrievanceData.refresh();
  }


  @override
  Widget build(BuildContext context) {

      return   GestureDetector(
        onTap: ()=>FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            backgroundColor: AppColors.BACKGROUND_WHITE,
            resizeToAvoidBottomInset: true,
            key: cnt_add.GlobalAddCo_OwnerPagekey,
            endDrawer: CustomDrawer(animatedOffset: Offset(1.0,0),),
            drawer: CustomDrawer(animatedOffset: Offset(-1.0,0),),
            body: SafeArea(
              child: Container(
                // color:Colors.grey.shade200,
                child: Stack(
                  children: [
                    NotificationListener<OverscrollIndicatorNotification> (
                      child: RefreshIndicator(
                        displacement: 60,
                        onRefresh: cnt_add.onRefresh,
                        child: CustomScrollView(
                          controller: scrollController,
                          physics: NeverScrollableScrollPhysics(),
                          keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                          scrollDirection: Axis.vertical,
                          slivers: [
                            SliverToBoxAdapter(
                              child: SizedBox(
                                height: APPBAR_HEIGHT,
                              ),
                            ),
                            SliverList(
                              delegate: SliverChildListDelegate([
                                Container(
                                  width: Get.width,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Obx(() => Container(
                                        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                        padding: EdgeInsets.symmetric(horizontal: 8,vertical: 20),
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
                                        child: Form(
                                          key: cnt_add.formkey,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Obx(() =>
                                                  DropdownButtonFormField<FlatListModal>(
                                                    isExpanded: true,
                                                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                                                    isDense:cnt_add.dropdownvalue1new.value!=null? false:true,
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
                                                          color: gray_color_1,
                                                          fontWeight: FontWeight.w500
                                                      ),
                                                      label: Text("Flat*"),
                                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                                      hintStyle: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.grey.withOpacity(0.7),
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                    dropdownColor: Colors.transparent,
                                                    elevation: 5,
                                                    value: null,
                                                    validator: (value) {
                                                      if (value == null) {
                                                        return "" + "Select a flat";
                                                      }
                                                      return null;
                                                    },

                                                    onChanged: (FlatListModal? newValue) {
                                                      cnt_add.dropdownvaluenew=FlatListModal();
                                                      cnt_add.dropdownvaluenew = newValue!;
                                                      cnt_add.dropdownvalue1new.value = newValue;
                                                      cnt_add.dropdownvalue1new.update((val) { });

                                                    },

                                                    selectedItemBuilder: (BuildContext context) {
                                                      return cnt_add.arrflatdataList.map<Widget>((value) {
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
                                                                    fontSize: 20, fontWeight: FontWeight.w700),
                                                              ),
                                                              Text(
                                                                value.unitdetails.toString() ,
                                                                // +
                                                                // "," +
                                                                // value.flatno.toString(),
                                                                style: TextStyle(fontSize: 13),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      }).toList();
                                                    },
                                                    items: cnt_add.arrflatdataList
                                                        .map<DropdownMenuItem<FlatListModal>>((FlatListModal value) {
                                                      var idx = cnt_add.arrflatdataList.indexOf(value);
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
                                                              cnt_add.dropdownvalue1new.value == value
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
                                              SizedBox(height: 20,),
                                             PhoneNumberTextField(cnt_add.txtContactNew),
                                              SizedBox(height: 30,),
                                              SubmitButton_4(),
                                              SizedBox(height: 10,)
                                            ],
                                          ),
                                        ),
                                      ))
                                      // cnt_add.Dropdownfield1()


                                    ],
                                  ),
                                ),
                              ]),
                            ),

                          ],
                        ),
                      ),
                      onNotification: (overscroll) {
                        overscroll.disallowIndicator();
                        return true;
                      },
                    ),
                    cnt_CommonHeader.commonAppBar(ADD_CO_OWNER, cnt_add.GlobalAddCo_OwnerPagekey,color: white)
                  ],
                ),
              ),
            )),
      );

  }

  Widget SubmitButton_4() {
    return OnTapButton(
        onTap: (){
          if(cnt_add.formkey.currentState!.validate()) {
            cnt_add.AddConerData();

          }

        },

        height: 40,
        decoration:
        CustomDecorations().backgroundlocal(APP_THEME_COLOR, cornarradius, 0, APP_THEME_COLOR),
        text: "Invite",
        style: TextStyle(color: white, fontSize: 14,fontWeight: FontWeight.w600)
    );
  }


}
