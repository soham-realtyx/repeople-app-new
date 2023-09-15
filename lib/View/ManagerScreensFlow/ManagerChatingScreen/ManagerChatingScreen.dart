import 'dart:io';

import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Controller/ComplaintController/ComplaintListController.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:Repeople/Widgets/System_Heading_Data.dart';
import 'package:Repeople/Widgets/Timing_System_Message_chat_Screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';





import 'package:intl/intl.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Model/ComplaintModel/ComplaintListModel.dart';
import 'package:Repeople/Model/ComplaintModel/GrievanceDetailsModel.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:Repeople/Widgets/ShimmerWidget.dart';


import '../../../Config/Function.dart';
import '../../../Config/Helper/HextoColor.dart';
import '../../../Config/utils/styles.dart';
import '../../../Widgets/CommomBottomSheet.dart';





class Manager_grievance_details extends StatefulWidget {
  final String? id;
  Manager_grievance_details({required this.id});

  @override
  Manager_grievance_detailsState createState() => new Manager_grievance_detailsState();
}
class Manager_grievance_detailsState extends State<Manager_grievance_details> {

  ComplaintListController cnt_cmplist = Get.put(ComplaintListController());

  GlobalKey<ScaffoldState> GlobalComplaintConversationPagekey = GlobalKey<ScaffoldState>();
  static final complaintconversionscaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _form_Key = GlobalKey<FormState>();
  ScrollController scrollController=ScrollController();
  @override
  void initState() {
    scrollController.addListener(() {
      cnt_cmplist.scrollUpdate(scrollController);
    });


    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cnt_cmplist.grievance_id.value=widget.id??"";
      cnt_cmplist.grievance_id.refresh();
      cnt_cmplist.futureGrievanceDetails.value=cnt_cmplist.RetrieveGrievanceDetailsData().whenComplete(() {
        if (scrollController.hasClients)
          scrollController.jumpTo(0.0);
        setState((){});

      });
      cnt_cmplist.futureGrievanceDetails.refresh();
      // cnt_cmplist.scrollController.animateTo(
      //   cnt_cmplist.scrollController.position.maxScrollExtent,
      //   duration: const Duration(milliseconds: 100),
      //   curve: Curves.easeIn,
      // );
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
  Widget ComplaintDetailsView() {
    return Obx(() {
      return FutureBuilder(
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasError) {
            if (cnt_cmplist.arrGrievanceDetails.isNotEmpty) {
              return Container(
                  child:  Obx(() {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(cornarradius),
                              boxShadow: [fullcontainerboxShadow],
                              color: white
                          ),
                          child: Padding(padding:
                          EdgeInsets.only(bottom: 6,top: 5,left: 10 ,right: 12),
                              child:  Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children:<Widget> [
                                  Row(children:<Widget> [   Container(
                                    alignment: Alignment.bottomCenter,
                                    decoration: new BoxDecoration(
                                      borderRadius: new BorderRadius.circular(35.0),
                                    ),
                                    child: Icon(Icons.access_time_filled,size: 35,color:
                                    HexColor(cnt_cmplist.arrGrievanceDetails.first.color??"#ff9f43"),),
                                  ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(padding: EdgeInsets.only(left: 10.0, right: 0.0, bottom: 0.0, top: 5.0),
                                            child:SizedBox(width:MediaQuery.of(context).size.width/1.8,
                                                child:Text(cnt_cmplist.arrGrievanceDetails.first.type??'',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: gray_color,
                                                      fontWeight: FontWeight.w600,
                                                      fontFamily: fontFamily,height: 1.5
                                                  ),
                                                ))),
                                        Padding( padding: EdgeInsets.only(left: 10.0, right: 0.0, bottom: 5.0, top: 5.0),
                                            child:Text(cnt_cmplist.arrGrievanceDetails.first.statusstr??"",style:
                                            // mediumTextStyle(
                                            //   txtColor: Colors.green[800],
                                            //   fontSize: 14
                                            // )
                                            TextStyle(
                                                fontSize: 13,
                                                color: HexColor(cnt_cmplist.arrGrievanceDetails.first.color??"#ff9f43"),
                                                fontFamily: fontFamily,height: 1.5
                                            )
                                              // TextStyle(
                                              //     color:Colors.green[800],
                                              //     fontWeight: FontWeight.w500,
                                              //     fontFamily: "Montserrat-Medium"
                                              // )
                                            ))
                                      ],),]),
                                  if( cnt_cmplist.arrGrievanceDetails.first.isescalate==1)
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[
                                          SizedBox(height: 15,),
                                          GestureDetector(
                                            onTap: () {
                                              cnt_cmplist.EscalateDataSend();
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                                              child: Text("Escalate",
                                                //   style: TextStyle(color:  Color(0xfff39100),
                                                //     fontWeight: FontWeight.w700
                                                // )
                                                style: mediumTextStyle(fontSize: 10,txtColor: AppColors.RED)
                                                ,),
                                              // decoration: BoxDecoration(
                                              //     color: Colors.red,
                                              //     borderRadius: BorderRadius.circular(5.0),
                                              //     border: Border.all(color:  Colors.white)
                                              // ),
                                              decoration: BoxDecoration(
                                                  color:AppColors.RED.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(15),
                                                  border: Border.all(color: AppColors.RED,width: 0.5)
                                              ),
                                            ),
                                          )
                                        ]),
                                  if( cnt_cmplist.arrGrievanceDetails.first.isclose==1)
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[
                                          SizedBox(height: 15,),
                                          GestureDetector(
                                            onTap: () {
                                              cnt_cmplist.GrievanceStatusSend('close');
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                                              child: Text("Close",
                                                style: mediumTextStyle(fontSize: 10,txtColor: AppColors.RED)
                                                ,),
                                              decoration: BoxDecoration(
                                                  color:AppColors.RED.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(15),
                                                  border: Border.all(color: AppColors.RED,width: 0.5)
                                              ),
                                            ),
                                          )
                                        ])
                                ],)),
                        ),
                        SizedBox(
                            child:ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: cnt_cmplist.arrGrievanceDetails.first.data?.length,
                                itemBuilder: (context,index){
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Timming_System_Message_Chat_Screen(message:cnt_cmplist.arrGrievanceDetails.first.data?[index].dateformatstr??"" ,mtype: false,),
                                      SizedBox(
                                          child:ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              // controller: cnt_cmplist.scrollController,
                                              physics: NeverScrollableScrollPhysics(),
                                              itemCount:  cnt_cmplist.arrGrievanceDetails.first.data?[index].activity?.length,
                                              itemBuilder: (context,ind){
                                                Activity? obj=cnt_cmplist.arrGrievanceDetails.first.data?[index].activity?[ind];
                                                if(obj?.chattype==3)
                                                  return   Manager_System_msg(message:obj?.message ,mtype: false,);
                                                else if(obj?.chattype==3 && obj?.status==2)
                                                  return   Manager_System_msg(message:obj?.message ,mtype: true,);
                                                else if(obj?.chattype==1)
                                                  // return   System_Heading_Data(data: obj);
                                                  return Manager_heading_data(data: obj);

                                                else if(obj?.chattype==2)
                                                  return   System_Heading_Data(data: obj);
                                                  // return Manager_heading_data(data: obj);
                                                else
                                                  return Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[

                                                    ],);

                                              })),


                                    ],);

                                }))


                      ],);
                  }));
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
                        cnt_cmplist.message.value,
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
        future: cnt_cmplist.futureGrievanceDetails.value,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_WHITE,
      key: GlobalComplaintConversationPagekey,
      endDrawer: CustomDrawer(
        animatedOffset: Offset(1.0, 0),
      ),
      drawer: CustomDrawer(
        animatedOffset: Offset(-1.0, 0),
      ),
      // appBar: buildAppBar(),
      body: SafeArea(child:
      Form(
        key: _formKey,
        child:Container(
          height: Get.height,
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              CustomScrollView(
                reverse: true,
                shrinkWrap: true,
                controller: scrollController,
                  slivers: [
                    SliverToBoxAdapter(child: SizedBox(height: APPBAR_HEIGHT,),),


                    SliverToBoxAdapter(
                        child:Padding(
                            padding: EdgeInsets.only(bottom: 50.0, top: 5.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                ComplaintDetailsView(),
                              ],
                            ))
                    ) ,
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: APPBAR_HEIGHT,
                      ),
                    ),
                  ]),

              Obx(() =>  Visibility(visible: cnt_cmplist.arrGrievanceDetails.isNotEmpty && cnt_cmplist.arrGrievanceDetails.first.israteus==1,child:  Positioned(
                  bottom: 0,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: new SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child:Container(
                            decoration: BoxDecoration(
                              color: AppColors.BACKGROUND_WHITE,
                              boxShadow:
                              // [BoxShadow(color: gray_color_1,offset: Offset(1,1),blurRadius: 5),],
                              [
                                BoxShadow(color:
                                hex("266CB5").withOpacity(0.1),offset: Offset(1,1),blurRadius: 5,spreadRadius: 3),],),


                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 20,horizontal: 15),

                              decoration: BoxDecoration(boxShadow: [fullcontainerboxShadow]),
                              child: Material(
                                // elevation: 1,
                                borderRadius: BorderRadius.circular(cornarradius),
                                child: OnTapButton(
                                    onTap: (){
                                      RateUsBottomsheeet();
                                    },
                                    decoration:
                                    CustomDecorations().backgroundlocal(GREEN, cornarradius, 0, GREEN),
                                    text: "Rate Us",
                                    height: 40,
                                    width: Get.width,
                                    style: TextStyle(color: white, fontSize: 14,fontWeight: FontWeight.w600)
                                ),


                              ),
                            ),
                          ),
                        )




                    ),)
              ))),
              Obx(() =>Visibility(
                  visible: cnt_cmplist.arrGrievanceDetails.isNotEmpty && cnt_cmplist.arrGrievanceDetails.first.ischatbox==1,
                  child:Positioned(
                      bottom: 0,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Column(children: <Widget>[
                          Container(
                              child: cnt_cmplist.arrImageAndFileList.length!=0? Container(
                                alignment: Alignment.centerLeft,
                                height: cnt_cmplist.arrImageAndFileList.length !=0?75.h:0,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount:
                                    cnt_cmplist.arrImageAndFileList.length > 0
                                        ? cnt_cmplist.arrImageAndFileList.length
                                        : 0,
                                    itemBuilder: (context, i) {
                                      return cnt_cmplist.FileBlock(i);
                                    }),
                              ):Container()),
                          new SizedBox(
                            width: MediaQuery.of(context).size.width,
                            // height: 100.0,
                            child:Container(
                              decoration: BoxDecoration(
                                color: AppColors.BACKGROUND_WHITE,
                                boxShadow:
                                // [BoxShadow(color: gray_color_1,offset: Offset(1,1),blurRadius: 5),],
                                [
                                  BoxShadow(color:
                                  hex("266CB5").withOpacity(0.1),offset: Offset(1,1),blurRadius: 5,spreadRadius: 3),],),

                              padding: const EdgeInsets.only(left: 20, right: 20,top: 20,bottom: 20),
                              child: Container(
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      fullcontainerboxShadow
                                      //   BoxShadow(
                                      //       color: Colors.black.withOpacity(0.05),
                                      //       //   color: Colors.black,
                                      //       blurRadius: 4,
                                      //       offset: Offset(0, 5),
                                      //       spreadRadius: 2)
                                    ]
                                ),
                                child: Material(
                                  color: Colors.white,
                                  // elevation: 1,
                                  borderRadius: BorderRadius.circular(cornarradius),
                                  child: TextField(
                                    controller: cnt_cmplist.txtsendmsg,
                                    // focusNode: focusnode,
                                    onSubmitted: (value) {

                                    },
                                    onChanged: (value) {
                                      // cnt_Search.patternOfSearch.value = value;
                                      // cnt_Search.patternOfSearch.refresh();
                                    },
                                    decoration: InputDecoration(
                                        hintText: 'Type your Message',
                                        hintStyle: regularTextStyle(
                                            txtColor: HexColor("#b4b4b4"), fontSize: 14),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.only(left: 20,right: 20,top: 15,bottom: 15),
                                        suffixIcon: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GestureDetector(
                                              onTap: (){
                                                cnt_cmplist.OnSelectDialog();
                                              },
                                              child: Container(
                                                // height: 15,
                                                // width: 15,
                                                  constraints: BoxConstraints(
                                                      maxWidth: 22,
                                                      maxHeight: 15
                                                  ),
                                                  decoration:  BoxDecoration(

                                                  ),
                                                  padding: EdgeInsets.all(0),
                                                  child: Image(
                                                      image: AssetImage("assets/images/ic_attachment.png"),color: Colors.black)
                                              ),
                                            ),
                                            SizedBox(width: 5,),
                                            InkWell(
                                                hoverColor: Colors.transparent,
                                                splashColor: Colors.transparent,
                                                highlightColor: Colors.transparent,
                                                onTap: () {
                                                  // onSearchTextChanged(searchtxt.text);
                                                },
                                                child: Container(
                                                  // padding: EdgeInsets.all(10),
                                                    margin: EdgeInsets.symmetric(
                                                        horizontal: 6, vertical: 5),
                                                    height: 30,
                                                    width: 30,
                                                    decoration: CustomDecorations().backgroundlocal(
                                                        APP_THEME_COLOR,
                                                        cornarradius,
                                                        0,
                                                        APP_THEME_COLOR),
                                                    child: IconButton(
                                                        onPressed:(){

                                                          setState(() {
                                                              if(/*cnt_cmplist.images_list.length>=1 ||*/  cnt_cmplist.txtsendmsg.text!=''){
                                                              cnt_cmplist.SendMessageData(chattype: "1");
                                                            }


                                                          });


                                                          // if(photo.length>0){
                                                          //   setState(() {
                                                          //     mplist.add(photo_list(cobdata: photo));
                                                          //     photo.clear();
                                                          //   });
                                                          //
                                                          // }
                                                        },icon: Icon(Icons.send,color:Colors.white,size: 15,))
                                                  // Icon(
                                                  //   Icons.search,
                                                  //   color: WHITE,
                                                  // ),
                                                )),
                                          ],
                                        )
                                      // Icon(
                                      //   Icons.search,
                                      //   color: Colors.black54,
                                      // )
                                    ),
                                    cursorColor: Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                          )

                        ],),)
                  ))),
            ],
          ),
        ),)),
    );
  }
  TextEditingController userController=new TextEditingController();

  RateUsBottomsheeet(){
    bottomSheetDialog(
      // context: Get.context,
      child: rateusbar(),
      // context: context,
      message: "Rate Us",
      backgroundColor: APP_THEME_COLOR,
      // mainColor: AppColors.MENUBG,
      isCloseMenuShow: true,
    );
  }


  
  Widget rateusbar(){
    return  SingleChildScrollView(
      child: Container(
          color: AppColors.BACKGROUND_WHITE,
          padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0), // content padding
              child: Form(
                key: _form_Key,
                child: new Column(
                  children: <Widget>[
                    // new ListTile(
                    //     title: new Text('Rate us',style: TextStyle( fontSize:20,fontWeight:FontWeight.bold,),),
                    //     onTap: () {
                    //
                    //     }),
                    // SizedBox(width: 100,child: Divider(height: 5,color: Colors.black,),),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      child: Column(children:<Widget> [
                        Padding(padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                          child:
                          // SvgPicture.asset(IMG_RATEUS_SVG_NEW,height: 80,)
                          Image(
                              height:100,
                              width:100,image:
                          AssetImage('assets/images/ic_success_half.png')),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 0),child:

                        Text('Rate Your Experience',textAlign:TextAlign.center,style: TextStyle(fontSize: 18,
                            /*fontFamily: myfont,color: kprimarycolor,*/fontWeight: FontWeight.bold),),),
                        Text('Do let us know how our Team did',style:
                        TextStyle(fontSize: 16,/*fontFamily: myfont,*/color: Colors.grey[700]),),
                        Padding(padding: EdgeInsets.symmetric(vertical: 20,horizontal: 0),
                            child: RatingBar.builder(
                              initialRating: cnt_cmplist.ratedata.value,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                cnt_cmplist.ratedata.value=rating;
                                cnt_cmplist.ratedata.refresh();
                                print(cnt_cmplist.ratedata.value);
                              },
                            ))
                        ,
                        // Padding(padding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),child: Container(
                        //   alignment: Alignment.topLeft,
                        //   decoration: BoxDecoration(
                        //       border: Border.all(color: Colors.blueGrey),
                        //       borderRadius: BorderRadius.circular(10),
                        //       color: Colors.white
                        //   ),
                        //   child: Padding(padding: EdgeInsets.only(bottom: 0,top: 0,left: 10,right: 0),
                        //     child:  Container(height: 100,child: TextFormField(
                        //       style:TextStyle( fontSize:20,/*fontFamily: myfont,*/color: Colors.black54),
                        //       keyboardType: TextInputType.multiline,
                        //       textInputAction: TextInputAction.newline,
                        //       maxLines: null,
                        //       validator: (value) {
                        //         if (value!.isEmpty) {
                        //           return 'Please enter some text';
                        //         }
                        //         return null;
                        //       },
                        //       onChanged: (value){
                        //         // if(regExp.hasMatch(value)){
                        //         //   isNameValid = true;
                        //         // } else {
                        //         //   isNameValid = false;
                        //         // }
                        //         setState(() {
                        //         });
                        //       },
                        //       decoration: InputDecoration(
                        //         border: InputBorder.none,
                        //         labelText: "Say Somthing",
                        //         labelStyle: TextStyle( fontSize:20,/*fontFamily: myfont,*/color: Colors.black54),
                        //         // errorText: isNameValid ? null : "Enter Query"
                        //       ),
                        //       // controller: linkcontroller,
                        //     ),),),
                        // ),)

                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 0,horizontal: 0),
                          child:
                          QueryTextField_2(cnt_cmplist.txtQueryNew),
                          //QueryTextField_2(userController),
                        ),
                      ],),),

                    Padding(
                      padding:  EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: SubmitButton(140)),
                    ),
                    // Center(
                    //   child: new SizedBox(
                    //     width: MediaQuery.of(context).size.width,
                    //     height: 50.0,
                    //     child:new RaisedButton(
                    //       color: Colors.blue[700],
                    //       textColor: Colors.white,
                    //       child: new Text('Submit',style: TextStyle(/*fontFamily: myfont,*/fontSize: 20.0),),
                    //       onPressed:(){
                    //         if (_formKey.currentState!.validate()) {
                    //           setState(() {
                    //           }
                    //           );
                    //           Toast.show('Review Submit');
                    //           Navigator.of(context).pop();
                    //         }
                    //
                    //       },
                    //     ),
                    //   ),),
                  ],
                ),))
      ),
    );

  }




  Widget QueryTextField_2(Rxn<TextEditingController>? controller) {
    return Obx(() =>TextFormField(
      maxLines: 2,
      validator: (value) {
        if(value!.isEmpty)
        {
          return "please enter message";
        }else{
          return null;
        }
      },
      controller: controller?.value,
      onChanged: (value){
        controller?.update((val) { });
      },
      style: boldTextStyle(fontSize: 18, txtColor: APP_FONT_COLOR),
      decoration: InputDecoration(
        enabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: LIGHT_GREY)),
        focusedBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: LIGHT_GREY)),
        errorBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        disabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        focusedErrorBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        // border: InputBorder.none,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: "Message",

        hintText: "Enter your message here",
        labelStyle: TextStyle(
            fontSize: 14.sp,
            color:gray_color_1,
            fontFamily: fontFamily,
            fontWeight: FontWeight.w500),

        // TextStyle(
        //     fontSize: 16, color: Colors.black.withOpacity(0.7), fontWeight: FontWeight.bold),
        hintStyle: TextStyle(color: LIGHT_GREY,fontSize: 16,fontWeight: FontWeight.w400),
        contentPadding: EdgeInsets.all(20),
        // prefixIcon: Padding(
        //   padding: const EdgeInsets.only(
        //     bottom: 40,
        //   ),
        //   child: Container(
        //       width: 50,
        //       height: 50,
        //       margin: EdgeInsets.only(right: 10),
        //       padding: const EdgeInsets.all(10.0),
        //       decoration: CustomDecorations().backgroundlocal(
        //           APP_GRAY_COLOR, cornarradius, 0, APP_GRAY_COLOR),
        //       child:
        //           // SvgPicture.asset(IMG_MESSAGE_SVG)
        //           SvgPicture.asset(IMG_MESSAGE_SVG_NEW)
        //       // Image.asset(IMG_EDIT),
        //       ),
        // )
      ),
    ));
  }

  Widget SubmitButton([double? width]){
    return OnTapButton(
        onTap: (){
          if(_form_Key.currentState!.validate() ){
            cnt_cmplist.RateUsDataSend();
            // SuccessMsg("Submitted successfully", title: "Success");
            // Get.back();
            // Get.to(DashboardPage());
          }else{
            //Get.back();
          }
        },
        decoration: CustomDecorations().backgroundlocal(APP_THEME_COLOR, cornarradius, 0, APP_THEME_COLOR),
        text: "Submit",
        width: width,
        height: 45,
        style: TextStyle(color: white)
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      title:Center(child: Text(cnt_cmplist.arrGrievanceDetails.first.raiseId.toString(),style: semiBoldTextStyle(),)),
      leading:
      new GestureDetector(onTap: () {
      },
        child: Icon(Icons.arrow_back_ios,color: Colors.black,),)
      ,
      actions: <Widget>[
        IconButton(icon: SvgPicture.asset(
          "assets/icon/menu.svg",
          height: 32,
          width: 20,
          // By default our  icon color is white
          color: Colors.black,
        ), onPressed:(){ },),
      ],
    );
  }
}
class Manager_System_msg extends StatelessWidget{
  final String?  message;
  final bool? mtype;
  Manager_System_msg({this.message,this.mtype});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
        child:Container(
            padding: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(cornarradius),
                gradient: LinearGradient(
                    colors:mtype!?[
                      Color(0xffFBDCDC),
                      Color(0xffFBDCDC),

                    ]:[

                      Color(0xfffff5c4),
                      Color(0xfffff5c4),
                    ]
                )),
            child: mtype!?Padding(padding: EdgeInsets.only(left: 5,right: 5),child:
            Text(message!,textAlign: TextAlign.center,
                style:
                regularTextStyle(txtColor:Color(0XFF4a421b),fontSize: 10 )
              // TextStyle(color:Colors.red[800],fontSize: 12),
            ),):
            Padding(padding: EdgeInsets.only(left: 5,right: 5),child:
            Text(message!,textAlign: TextAlign.center,style:
            regularTextStyle(txtColor:Color(0XFF4a421b),fontSize: 10 )
              // TextStyle(color:Colors.black,fontSize: 12),
            ),)

        ),),
    );
  }

}


class Manager_heading_data extends StatelessWidget{
  final Activity? data;
  Manager_heading_data({this.data});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
      child: Column(children: [
        if(data!=null && data!.message!=null && data!.message!.isNotEmpty)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Container(

                  decoration: new BoxDecoration(
                    color: Color(0xffdcf8c6),

                    boxShadow: [smallcontainerboxShadow],
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(cornarradius),
                      topLeft: Radius.circular(cornarradius),
                      bottomLeft: Radius.circular(cornarradius),
                      bottomRight: Radius.circular(cornarradius),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:<Widget> [
                            SizedBox(height: 10,),
                            Padding(padding: EdgeInsets.symmetric(vertical: 0,horizontal: 8),
                              child:Text(
                                data?.message??'',style:
                              regularTextStyle(fontSize: 11,txtColor: Colors.black87),
                              ),),
                            Container(
                                padding: EdgeInsets.only(top: 3),
                                // width: MediaQuery.of(context).size.width/1.3,
                                child:  Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Row(
                                    mainAxisAlignment:MainAxisAlignment.end,
                                    children:<Widget> [
                                      Text(data?.time??'',style:
                                      regularTextStyle(fontSize: 8,txtColor: Colors.grey),
                                      ),


                                    ],),
                                )),
                            SizedBox(height: 10,),
                          ],),
                      ),

                    ],),
                ),
              ),
              Expanded(
                flex:1 ,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ClipOval(
                        child:
                        data?.profile!=null && data?.profile!=''?Image(
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                            image: NetworkImage(data?.profile??'')):Image(
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                            image: AssetImage('assets/images/ic_login.png'))),
                  ],
                ),
              ),
            ],),
        if(data!=null && data!.media!=null && data!.media!.isNotEmpty)
          Container(
            margin:   EdgeInsets.only(top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  flex: 5,
                  child: Container(
                    child: SizedBox(
                      height: 65.h,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: data?.media?.length,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return   GestureDetector(onTap: (){

                          },child:
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                InkWell( onTap : () {
                                 // print('------------image click-----------------');
                                  //Get.to(FullImageViewPage(list: data!.media!, index: index));
                                  Get.to(FullImageViewSlider(list: data!.media!));
                                },

                                  child: Container(
                                    clipBehavior: Clip.hardEdge,
                                    decoration:BoxDecoration(
                                        borderRadius: BorderRadius.circular(cornarradius),
                                        boxShadow: [smallcontainerboxShadow]
                                    ),
                                    child: Image(
                                        height: 60,
                                        width: 80,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (BuildContext? context, Widget? child,ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) return child!;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress.expectedTotalBytes != null ?
                                              loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },
                                        image: NetworkImage(
                                            data?.media![index]??''
                                        )),
                                  ),
                                ),

                              ],
                            ),
                          ),);
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ClipOval(
                          child:
                          data?.profile!=null && data?.profile!=''?
                          Image(
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                              image: NetworkImage(data?.profile??"")):Image(
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                              image:
                              AssetImage
                                ('assets/images/ic_login.png'))),
                    ],
                  ),
                ),
              ],
            ),
          ),

      ],),);
  }



}

class FullImageViewSlider extends StatefulWidget {
  List<String> list;
  FullImageViewSlider({required this.list});

  @override
  State<FullImageViewSlider> createState() => _FullImageViewSliderState();
}

class _FullImageViewSliderState extends State<FullImageViewSlider> {
  RxInt _current=0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.TRANSPARENT,
        leading: IconButton(
          padding: EdgeInsets.all(0),
          onPressed: (){
            Get.back();
          },
          icon: Icon(Icons.arrow_back,color: white,size: 25),
          splashColor: AppColors.TRANSPARENT,
          highlightColor:AppColors.TRANSPARENT,
          hoverColor: AppColors.TRANSPARENT,
        ),),
      backgroundColor: AppColors.BLACK,
      body: Center(
        child: Container(
          child: Stack(
            children: [
              CarouselSlider.builder(
                itemCount: widget.list.length,
                itemBuilder: (context, index, realIndex) {
                  return ClipRRect(
                    child: CachedNetworkImage(
                      height: 400,
                      imageUrl: widget.list[index],
                      fadeInDuration: Duration.zero,
                      fadeOutDuration: Duration.zero,
                      placeholderFadeInDuration: Duration.zero,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) {
                        return Container();
                      },
                    )
                  );
                },
                options: CarouselOptions(autoPlay: true,height: 400, viewportFraction: 1,
                onPageChanged: (index,_){
                setState(() {
                  _current.value=index;
                  _current.refresh();
                });
                })
               ),
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: 10,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: widget.list!.asMap().entries.map((entry) {
                        return Container(
                          width: 8.0,
                          height: 8.0,
                          margin: EdgeInsets.symmetric(horizontal: 2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _current == entry.key
                                ? Colors.black
                                : Colors.white,
                          ),
                        );
                      }).toList(),
                    ),
                  )),

            ],
          ),
        ),
      ),
    );
  }
}
