import 'package:Repeople/Config/Helper/HextoColor.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:Repeople/View/CoOwnerMainPage/AddCoOwnerPage.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:Repeople/Widgets/ShimmerWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:Repeople/Controller/VisitorController/VisitorPageController.dart';
import 'package:shimmer/shimmer.dart';
import '../../Config/Constant.dart';
import '../../Config/Function.dart';
import '../../Config/utils/colors.dart';
import '../../Config/utils/styles.dart';
import '../../Widgets/CommonBackButtonFor5theme.dart';

class VisitorPage extends StatefulWidget {
  String visitorid;

  VisitorPage({this.visitorid = ""});

  @override
  State<VisitorPage> createState() => _VisitorPageState();
}

class _VisitorPageState extends State<VisitorPage>
    with TickerProviderStateMixin {
  VisitorController cnt_visitor = Get.put(VisitorController());
  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());


  @override
  void initState() {
    // Todo:implement code
    super.initState();
    cnt_visitor.visitor_id.value=widget.visitorid;
    cnt_visitor.visitor_id.refresh();
    cnt_visitor.LoadData();
    cnt_visitor.scrollController.addListener(() {
      cnt_visitor.scrollUpdate(cnt_visitor.scrollController);
    });
    cnt_visitor.scrollControllerresponse.addListener(() {
      cnt_visitor.scrollUpdateResponse(cnt_visitor.scrollControllerresponse);
    });
    cnt_visitor.tabController = TabController(
        length:2,
        vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      cnt_visitor.tabController.addListener(() {

      });

      cnt_visitor.futuretablist.value.then((value) {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
              backgroundColor: AppColors.BACKGROUND_WHITE,
              endDrawer: CustomDrawer(
                animatedOffset: Offset(1.0, 0),
              ),
              drawer: CustomDrawer(
                animatedOffset: Offset(-1.0, 0),
              ),
              resizeToAvoidBottomInset: false,
              key: cnt_visitor.GlobalCo_OwnerPagekey,
              body: SafeArea(
                child: Container(
                  color: AppColors.BACKGROUND_WHITE,
                  // color:Colors.grey.shade200,
                  child: Stack(
                    children: [
                      NotificationListener<OverscrollIndicatorNotification>(
                        child: RefreshIndicator(
                          displacement: 60,
                          onRefresh: cnt_visitor.onRefresh,
                          child: SingleChildScrollView(
                            physics: ScrollPhysics(),
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               SizedBox(height: APPBAR_HEIGHT),
                               Container(
                                 width: Get.width,
                                 child: Column(
                                   mainAxisAlignment:
                                   MainAxisAlignment.start,
                                   crossAxisAlignment:
                                   CrossAxisAlignment.start,
                                   children: [
                                     FilterTabView1()
                                   ],
                                 ),
                               ),
                               SizedBox(height: APPBAR_HEIGHT),
                             ],
                           ),
                          ),
                        ),
                        onNotification: (overscroll) {
                          overscroll.disallowIndicator();
                          return true;
                        },
                      ),

                      cnt_CommonHeader.commonAppBar(VISITOR, cnt_visitor.GlobalCo_OwnerPagekey,color: white)
                    ],
                  ),
                ),
              )),
        ),
      );
    });
  }


  Widget FilterTabView1() {
    return Obx(() {
      return FutureBuilder(
        builder: (_, index) {
          return Container(
            height: Get.height,
            color: white,
            // color: Colors.red,
            child:  DefaultTabController(
              length: 2,
              child:
              Scaffold(
                backgroundColor: AppColors.BACKGROUND_WHITE,
                appBar:  PreferredSize(
                  preferredSize: Size.fromHeight(50.0), // here the desired height
                  child: Container(
                    color: AppColors.BACKGROUND_WHITE,
                    // width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(left:0.0,top: 10,right: 0),
                    margin: EdgeInsets.all(0),
                    child:Center(child: Padding(padding: EdgeInsets.only(left: 0),
                      child: DecoratedBox(decoration:
                      BoxDecoration(color: Colors.white.withOpacity(0.0),
                        // border: Border(
                        //   bottom: BorderSide(color: APP_THEME_COLOR.withOpacity(0.1), width: 0.5)),
                        border: Border(
                            bottom: BorderSide(color: APP_THEME_COLOR.withOpacity(0.1), width: 2.sp)),
                      ),
                          child: TabBar(
                            // isScrollable: true,
                              labelColor: APP_THEME_COLOR,
                              // indicatorColor: Color(0xFF243d7d),
                              // labelColor: Color(0xFF243d7d),
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicatorColor:APP_THEME_COLOR,
                              onTap:(val){
                                if(val==0){
                                  if(cnt_visitor.RequestTap.isTrue){
                                    cnt_visitor.RequestTap.value=false;
                                    cnt_visitor.RequestRestart();
                                  }
                                  // RefreshResponse();
                                }
                                if(val==1){

                                  if(cnt_visitor.ResponseTap.isTrue){
                                    cnt_visitor.ResponseTap.value=false;
                                    cnt_visitor.Restart();
                                  }

                                }
                              },
                              unselectedLabelColor: Colors.grey[500],
                              tabs: [
                                Tab(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 5, right: 5),
                                    child: Text(
                                      "Request",
                                      style:
                                      // semiBoldTextStyle(fontSize: 14,)
                                      TextStyle(
                                          fontSize: 15, fontWeight: FontWeight.w600),
                                    ),

                                  ),
                                ),
                                Tab(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 5, right: 5),
                                    child: Text(
                                      "Response",
                                      style:
                                      // semiBoldTextStyle(fontSize: 14,)
                                      TextStyle(
                                          fontSize: 15, fontWeight: FontWeight.w600),
                                    ),

                                  ),
                                ),
                              ]
                          )),),),

                  ),

                ),
                body: TabBarView(
                  children:  [
                    RequestMemberslist(),
                    ResponceMemberslist(),
                    // wd_timelineview(),
                    //Container(color: Colors.red,height: 100,),
                    // Container(color: Colors.black,height: 150,),
                  ],
                ),

              ),
            ),


          );
        },
        future: cnt_visitor.futuretablist.value,
      );
    });
  }
  Widget RequestMemberslist(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
      child: Container(
        color: AppColors.BACKGROUND_WHITE,
        // height: Get.height,
        padding: EdgeInsets.only(bottom: 65.h),
        child: Obx((){
          return  FutureBuilder(
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data != null) {
                if(cnt_visitor.arrProjectDetailsList.isNotEmpty)
                  return   Obx(() => ListView.builder(
                    // padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                      shrinkWrap: true,
                      controller: cnt_visitor.scrollController,
                      itemCount: cnt_visitor.arrProjectDetailsList.length,
                      physics: ScrollPhysics(),
                      itemBuilder: (_,ind){
                        final obj=cnt_visitor.arrProjectDetailsList[ind];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Container(
                            width: MediaQuery.of(_).size.width,
                            decoration: BoxDecoration(
                              color: white,
                              boxShadow: [fullcontainerboxShadow],
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(cornarradius),
                                topRight: Radius.circular(cornarradius),
                                bottomLeft: Radius.circular(cornarradius),
                                bottomRight: Radius.circular(cornarradius),
                              ),
                            ),
                            child:  Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(padding: EdgeInsets.only(left:5),
                                      child: ClipOval(
                                        child:obj.profile !=null && obj.profile !=""? Image(
                                            height: 60,
                                            width: 60,
                                            fit: BoxFit.cover,
                                            image: NetworkImage(obj.profile.toString())):Image(
                                            height: 50,
                                            width: 50,
                                            fit: BoxFit.cover,
                                            image: AssetImage(IMG_USER_LOGIN))

                                        ,
                                      ),

                                    ),
                                    Expanded(
                                      flex: 8,
                                      child:  Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        // mainAxisAlignment: MainAxisAlignment.start,
                                        children:<Widget> [
                                          Padding(padding: EdgeInsets.only(
                                              left: 15,top:0,bottom: 3,right: 10),
                                            child:Text(
                                              obj.personname??'',
                                              style:
                                              // semiBoldTextStyle(fontSize: 15),
                                              TextStyle(
                                                  fontSize: 15,
                                                  color: gray_color,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: fontFamily/*,height: 1.5*/
                                              ),
                                              // TextStyle(fontSize: 15,fontWeight:FontWeight.bold,),
                                            ),),
                                          Padding(padding: EdgeInsets.only(
                                              left: 15,top:3,bottom: 3,right: 10),
                                            child:Row(
                                              children: [
                                                Text(
                                                  obj.countryCode??'',
                                                  style:
                                                  // semiBoldTextStyle(fontSize: 15),
                                                  TextStyle(
                                                      fontSize: 12,
                                                      color: gray_color,
                                                      fontWeight: FontWeight.w600,
                                                      fontFamily: fontFamily/*,height: 1.5*/
                                                  ),
                                                  // TextStyle(fontSize: 15,fontWeight:FontWeight.bold,),
                                                ),
                                                Text(
                                                  obj.mobile??'',
                                                  style:
                                                  // semiBoldTextStyle(fontSize: 15),
                                                  TextStyle(
                                                      fontSize: 12,
                                                      color: gray_color,
                                                      fontWeight: FontWeight.w600,
                                                      fontFamily: fontFamily/*,height: 1.5*/
                                                  ),
                                                  // TextStyle(fontSize: 15,fontWeight:FontWeight.bold,),
                                                ),
                                              ],
                                            ),),
                                          Padding(padding: EdgeInsets.only
                                            (left: 15,top:0,bottom: 2,right: 15),
                                            child: Text(obj.fullunitdetails.toString(),style: TextStyle(color: gray_color_1, fontSize: 12,fontWeight: FontWeight.w500),),),


                                        ],),),


                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: (){
                                                cnt_visitor.AcceptBottomSheet(ind);
                                              },
                                              child: Container(
                                                clipBehavior: Clip.hardEdge,
                                                height: 25,
                                                width: 25,
                                                padding: EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color:APP_THEME_COLOR,
                                                  borderRadius: BorderRadius.circular(15),

                                                ),
                                                child: Center(
                                                    child:
                                                    SvgPicture.asset(
                                                      IMG_ACCEPTED_SVG_NEW,color:
                                                    Colors.white,width: 15,height: 15,
                                                    )
                                                  // Icon(Icons.cached_rounded,
                                                  //   size: 15,color: Colors.white,)
                                                ),

                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                              child: InkWell(
                                                onTap: (){
                                                  cnt_visitor.UpdateVisitorRequest(0, obj.id??"");
                                                },
                                                child: Container(
                                                  clipBehavior: Clip.hardEdge,
                                                  height: 25,
                                                  width: 25,
                                                  decoration: BoxDecoration(
                                                    // boxShadow: [
                                                    //   BoxShadow(
                                                    //       offset:Offset(0,0),
                                                    //       color: Colors.red.withOpacity(0.2),
                                                    //       spreadRadius: 0
                                                    //     // blurRadius: 10,
                                                    //   )
                                                    // ],
                                                    border: Border.all(color: Colors.red,width: 0.5),

                                                    borderRadius: BorderRadius.circular(15),

                                                  ),
                                                  child: Center(child:
                                                  SvgPicture.asset(IMG_CANCEL_SVG_NEW,color: Colors.red,width: 15,height: 15,)
                                                    // Image(image:
                                                    //
                                                    // AssetImage("assets/images/ic_close.png"),
                                                    //   color: Colors.red,width: 15,height: 15,)
                                                  ),

                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5,)
                                    /*for this changes*/
                                  ]),
                            ),),
                        );
                      }));
                else
                  return Center(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(image: AssetImage("assets/images/nodatafound.png")),
                      Padding(padding: EdgeInsets.only(top:15,bottom: 5,),
                        child:Text('No Data Found',style:
                        semiBoldTextStyle(fontSize: 15)
                          // TextStyle(fontSize: 15,fontWeight:FontWeight.bold,),
                        ),),
                    ],
                  ),);
              } else {
                return CoOwnerShimmerEffect();
              }
            },
            future: cnt_visitor.futureRequestData.value,
          );



        }),
      ),
    );
  }

  Widget ResponceMemberslist(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
      // padding: const EdgeInsets.all(8.0),
      child: Container(
        color: AppColors.BACKGROUND_WHITE,
        // height: Get.height,
        padding: EdgeInsets.only(bottom: 65.h),
        child: Obx((){
          return   FutureBuilder(
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data != null) {
                if(cnt_visitor.responceuserlist.isNotEmpty)
                  return   Obx(() => ListView.builder(
                    //padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                      shrinkWrap: true,
                      controller: cnt_visitor.scrollControllerresponse,
                      itemCount: cnt_visitor.responceuserlist.length,
                      physics: ScrollPhysics(),

                      itemBuilder: (_,ind){
                        final obj=cnt_visitor.responceuserlist[ind];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Container(
                            width: MediaQuery.of(_).size.width,
                            decoration: BoxDecoration(
                              color: white,
                              boxShadow: [fullcontainerboxShadow],
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(cornarradius),
                                topRight: Radius.circular(cornarradius),
                                bottomLeft: Radius.circular(cornarradius),
                                bottomRight: Radius.circular(cornarradius),
                              ),
                            ),
                            child:  Padding(
                              padding: const EdgeInsets.all(10.0),
                              // padding: const EdgeInsets.all(8.0),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[

                                    Padding(
                                      padding: EdgeInsets.only(left:5),
                                      child: Center(
                                        child: ClipOval(
                                          child:obj.profile !=null && obj.profile !=""?  Image(
                                              height: 60,
                                              width: 60,
                                              fit: BoxFit.cover,
                                              image: NetworkImage(obj.profile.toString())):Image(
                                              height: 50,
                                              width: 50,
                                              fit: BoxFit.cover,
                                              image: AssetImage(IMG_USER_LOGIN))

                                          ,
                                        ),
                                      ),

                                    ),
                                    Expanded(
                                      flex: 7,
                                      child:  Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children:<Widget> [
                                          Padding(padding: EdgeInsets.only(left: 15,top:0,bottom: 0,right: 5),
                                            child:Text(
                                              obj.personname.toString(),style:
                                            semiBoldTextStyle(fontSize: 15),
                                              // TextStyle(fontSize: 15,fontWeight:FontWeight.bold,),
                                            ),),
                                          Padding(padding: EdgeInsets.only(left: 15,top:3,bottom: 3,right: 5),
                                            child:Row(
                                              children: [
                                                Text("+91 ",style:
                                                semiBoldTextStyle(fontSize: 12),
                                                  // TextStyle(fontSize: 15,fontWeight:FontWeight.bold,),
                                                ),  Text(
                                                  obj.mobile.toString(),style:
                                                semiBoldTextStyle(fontSize: 12),
                                                  // TextStyle(fontSize: 15,fontWeight:FontWeight.bold,),
                                                ),
                                              ],
                                            ),),
                                          Padding(padding: EdgeInsets.only
                                            (left: 15,top:0,bottom: 0,right: 5),
                                            child:Text(obj.fullunitdetails.toString(),
                                              style:
                                              // semiBoldTextStyle(fontSize: 12,txtColor: Colors.grey),
                                              TextStyle(color: gray_color_1, fontSize: 12,fontWeight: FontWeight.w500),
                                              // TextStyle(fontSize: 12,color: Colors.grey,),
                                              maxLines: 1,overflow: TextOverflow.ellipsis,),),


                                        ],),),
                                    if(obj.acceptStatus!=null && obj.acceptStatus!="")
                                      Flexible(
                                        flex: 3,
                                        child: Container(
                                          // decoration: CustomDecorations().backgroundlocal(GREY_SHADE_300, cornarradius, 0, DARK_BLUE),
                                          decoration: BoxDecoration(
                                            // color: Colors.grey[300],
                                              borderRadius: BorderRadius.circular(15),
                                              border: Border.all(color: obj.acceptcolor!=null?HexColor(obj.acceptcolor.toString()):Colors.grey,width: 0.5)
                                          ),
                                          child:Padding(padding: EdgeInsets.only(top: 5,bottom: 6,right: 8,left: 8),
                                            child: Text(obj.acceptStatus??"",style:
                                            mediumTextStyle(fontSize: 10,txtColor: obj.acceptcolor!=null?HexColor(obj.acceptcolor.toString()):Colors.grey.shade700,),maxLines: 1,overflow: TextOverflow.ellipsis,),),
                                        ),
                                      )




                                    /*for this changes*/
                                  ]),
                            ),),
                        );
                      }));
                else
                  return Center(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(image: AssetImage("assets/images/nodatafound.png")),
                      Padding(padding: EdgeInsets.only(top:15,bottom: 5,),
                        child:Text('No Data Found',style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold,),),),
                    ],
                  ),);

              } else {
                return CoOwnerShimmerEffect();
              }
            },
            future: cnt_visitor.futureresponcelist.value,
          );


        }),
      ),
    );
  }

  Widget SubmitButton_4() {
    return OnTapButton(
        onTap: (){
          Get.to(AddCoOwnerPage());
          // if(formkey.currentState!.validate()){
          //   SuccessMsg("Submitted successfully", title: "Success");
          //   // Get.to(DashboardPage());
          //   Get.back();
          // }
        },

        height: 40,
        decoration:
        CustomDecorations().backgroundlocal(APP_THEME_COLOR, cornarradius, 0, APP_THEME_COLOR),
        text: cnt_visitor.ismainpage.isTrue?"Add Co-owner":"",
        style: TextStyle(color: white, fontSize: 14,fontWeight: FontWeight.w600)
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
              Get.to(AddCoOwnerPage());
              // if(formkey.currentState!.validate()){
              //   SuccessMsg("Submitted successfully", title: "Success");
              //   // Get.to(DashboardPage());
              // }
            },
            width: 120,
            height: 40,
            text:   cnt_visitor.ismainpage.isTrue?"Add Co-owner":"",
            decoration: CustomDecorations().backgroundlocal(TRANSPARENT, cornarradius, 0, white),
            style: TextStyle(color: APP_FONT_COLOR)),
      ),
    );
  }

  Widget CoOwnerShimmerEffect() {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        enabled: true,
        child: ListView.builder(
            itemCount: 5,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder:(_,index){
              return   Container(
                padding: EdgeInsets.all(15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
                      child: shimmerWidget(height: 100, width: Get.width, radius: 0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0,top: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          shimmerWidget(height: 12, width: 50, radius: 0),
                          SizedBox(height: 10,),
                          shimmerWidget(height: 12, width:150, radius: 0),
                        ],
                      ),
                    )

                  ],
                ),
              );
            } )


    );
  }
}
