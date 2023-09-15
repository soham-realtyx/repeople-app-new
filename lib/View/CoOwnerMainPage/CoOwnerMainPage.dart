import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/Helper/HextoColor.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:Repeople/View/CoOwnerMainPage/AddCoOwnerPage.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:Repeople/Widgets/ShimmerWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../Config/Constant.dart';
import '../../Config/utils/colors.dart';
import '../../Controller/CoOwnerConroller/CoOwnerPageController.dart';

class CoOwnerMainPage extends StatefulWidget {
  const CoOwnerMainPage({Key? key}) : super(key: key);

  @override
  State<CoOwnerMainPage> createState() => _CoOwnerMainPageState();
}

class _CoOwnerMainPageState extends State<CoOwnerMainPage>
    with TickerProviderStateMixin {
  CoOwnerMainPageController cnt_coowner = Get.put(CoOwnerMainPageController());
  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // Todo:implement code
    super.initState();

    cnt_coowner.LoadData();
    cnt_coowner.tabController = TabController(
        length: cnt_coowner.arrProjectDetailsList.length != null
            ? cnt_coowner.arrProjectDetailsList.length
            : 0,
        vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      cnt_coowner.tabController.addListener(() {
        if (cnt_coowner.tabController.indexIsChanging) {
          if (cnt_coowner.tabController.index == 0) {
            cnt_coowner.ismainpage = true.obs;

            setState(() {});
          } else {
            cnt_coowner.ismainpage = false.obs;
            setState(() {});
          }
        } else {
          // cnt_coowner.restart();
        }
      });

      cnt_coowner.futuretablist.value.then((value) {});
    });
  }

  @override
  Widget build(BuildContext context) {

    return Obx(() {
      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
              backgroundColor: AppColors.BACKGROUND_WHITE,
              endDrawer: CustomDrawer(
                animatedOffset: Offset(1.0, 0),
              ),
              drawer: CustomDrawer(
                animatedOffset: Offset(-1.0, 0),
              ),
              resizeToAvoidBottomInset: false,
              key: cnt_coowner.GlobalCo_OwnerPagekey,
              body: SafeArea(
                child: Container(
                  color: AppColors.BACKGROUND_WHITE,
                  // color:Colors.grey.shade200,
                  child: Stack(
                    children: [
                      NotificationListener<OverscrollIndicatorNotification>(
                        child: RefreshIndicator(
                          displacement: 60,
                          onRefresh: cnt_coowner.onRefresh,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                     FilterTabView1()
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
                      //cnt_coowner.Commitee_header("Co-Owner", coOwnerykey),

                      cnt_coowner.ismainpage.isTrue
                          ? Obx(() => Positioned(
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, bottom: 30),
                                child: SubmitButton_4(),
                              )
                              // cnt_coowner.SubmitButton_1(),

                              ))
                          : Container(),

                      cnt_CommonHeader.commonAppBar(CO_OWNER, cnt_coowner.GlobalCo_OwnerPagekey,color: white)
                    ],
                  ),
                ),
              )),
        ),
      );
    });
  }

  Widget SubmitButton_4() {
    return OnTapButton(
        onTap: (){
          Get.to(AddCoOwnerPage())!.then((value) {
            cnt_coowner.Restart();
          });
        },

        height: 40,
        decoration:
        CustomDecorations().backgroundlocal(APP_THEME_COLOR, cornarradius, 0, APP_THEME_COLOR),
        text: cnt_coowner.ismainpage.isTrue?"Add Co-owner":"",
        style: TextStyle(color: white, fontSize: 14,fontWeight: FontWeight.w600)
    );
  }

  Widget FilterTabView1() {
    return Obx(() {
      return FutureBuilder(
        builder: (_, index) {
          return Container(
            height: Get.height-230,
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
                                print(val);
                              },
                              unselectedLabelColor: Colors.grey[500],
                              tabs:[
                                Tab(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 5, right: 5),
                                    child: Text(
                                      "add",
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
                                      "response",
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
                    AddedMemberslist(),
                    ResponceMemberslist(),
                  ],
                ),

              ),
            ),
          );
        },
        future: cnt_coowner.futuretablist.value,
      );
    });
  }
  Widget AddedMemberslist(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
      child: Container(
        color: AppColors.BACKGROUND_WHITE,
        // height: Get.height,
        // padding: EdgeInsets.only(bottom: 200),
        child: Obx((){
          return  FutureBuilder(
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data != null) {
                if(cnt_coowner.arrProjectDetailsList.isNotEmpty)
                  return   ListView.builder(
                    // padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                      shrinkWrap: true,
                      itemCount: cnt_coowner.arrProjectDetailsList.length,
                      controller: scrollController,
                      physics: ScrollPhysics(),
                      itemBuilder: (_,ind){
                        final obj=cnt_coowner.arrProjectDetailsList[ind];
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
                                        child:obj.image !=null? Image(
                                            height: 60,
                                            width: 60,
                                            fit: BoxFit.cover,
                                            image: NetworkImage(obj.image.toString())):Image(
                                            height: 50,
                                            width: 50,
                                            fit: BoxFit.cover,
                                            image: AssetImage(IMG_USER_LOGIN)),
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
                                            child:Text(obj.contact.toString(),
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: gray_color,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: fontFamily/*,height: 1.5*/
                                              ),
                                              // semiBoldTextStyle(fontSize: 15),
                                              // TextStyle(fontSize: 15,fontWeight:FontWeight.bold,),
                                            ),),
                                          Padding(padding: EdgeInsets.only(left: 15,top:0,bottom: 2,right: 15),
                                            child: Text(obj.unitdetails.toString(),style: TextStyle(color: gray_color_1, fontSize: 12,fontWeight: FontWeight.w500),),),


                                        ],),),


                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
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
                                                    IMG_RESTART_SVG_NEW,color:
                                                  Colors.white,width: 15,height: 15,
                                                  )
                                                // Icon(Icons.cached_rounded,
                                                //   size: 15,color: Colors.white,)
                                              ),

                                            ),
                                            InkWell(onTap: (){
                                              cnt_coowner.RemoveAddCoWnerRequest(obj.id??"");
                                            },child:Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 5.0),
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
                                            )),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5,)
                                    /*for this changes*/
                                  ]),
                            ),),
                        );
                      });
                else return Center(child: Column(
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
                // return CoOwnerShimmerEffect();
              } else {
                return CoOwnerShimmerEffect();
              }
            },
            future: cnt_coowner.futureData.value,
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
        // padding: EdgeInsets.only(bottom: 145),
        child: Obx((){
          return  FutureBuilder(
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data != null) {
                if(cnt_coowner.responceuserlist.isNotEmpty)
                  return   ListView.builder(
                    //padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                      shrinkWrap: true,
                      itemCount: cnt_coowner.responceuserlist.length,
                      controller: cnt_coowner.scrollControllerresponse,
                      physics: ScrollPhysics(),

                      itemBuilder: (_,ind){
                        final obj=cnt_coowner.responceuserlist[ind];
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
                                          child:obj.image !=null? Image(
                                              height: 60,
                                              width: 60,
                                              fit: BoxFit.cover,
                                              image: NetworkImage(obj.image.toString())):Image(
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
                                            child:Text((!obj.contact.toString().contains("+91")?"+91 ":"")+
                                                obj.contact.toString(),style:
                                            semiBoldTextStyle(fontSize: 15),
                                              // TextStyle(fontSize: 15,fontWeight:FontWeight.bold,),
                                            ),),
                                          Padding(padding: EdgeInsets.only
                                            (left: 15,top:0,bottom: 0,right: 5),
                                            child:Text(obj.unitdetails??"",
                                              style:
                                              // semiBoldTextStyle(fontSize: 12,txtColor: Colors.grey),
                                              TextStyle(color: gray_color_1, fontSize: 12,fontWeight: FontWeight.w500),
                                              // TextStyle(fontSize: 12,color: Colors.grey,),
                                              maxLines: 1,overflow: TextOverflow.ellipsis,),),


                                        ],),),

                                    Flexible(
                                      flex: 3,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          // color: Colors.red[100],
                                          borderRadius: BorderRadius.circular(15),
                                          border: Border.all(color: HexColor(obj.color??"#b74093"),width: 0.5),
                                        ),
                                        child: Padding(padding: EdgeInsets.only(top: 5,bottom: 6,right: 8,left: 8),
                                          child:Text(obj.status??"",style: mediumTextStyle(fontSize: 10,txtColor: HexColor(obj.color??"#b74093")),maxLines: 1,overflow: TextOverflow.ellipsis,),),
                                      ),
                                    )




                                    /*for this changes*/
                                  ]),
                            ),),
                        );
                      });
                else return Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(image: AssetImage("assets/images/nodatafound.png")),
                    Padding(padding: EdgeInsets.only(top:15,bottom: 5,),
                      child:Text('No Data Found',style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold,),),),
                  ],
                ),);
                // return CoOwnerShimmerEffect();
              } else {
                return CoOwnerShimmerEffect();
              }
            },
            future: cnt_coowner.futureresponcelist.value,
          );


        }),
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
