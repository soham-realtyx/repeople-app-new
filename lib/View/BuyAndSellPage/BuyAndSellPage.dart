import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:Repeople/Model/BuyAndSellModel/BuyAndSellModel.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:Repeople/Widgets/ShimmerWidget.dart';
import 'package:Repeople/Widgets/TextEditField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:Repeople/Controller/BuyAndSellController/BuyAndSellController.dart';
import 'package:shimmer/shimmer.dart';

import '../../Config/Constant.dart';
import '../../Config/Function.dart';
import '../../Config/utils/colors.dart';
import '../../Config/utils/styles.dart';
import '../../Widgets/CommonBackButtonFor5theme.dart';


class BuyAndSellPage extends StatefulWidget {
  const BuyAndSellPage({Key? key}) : super(key: key);

  @override
  State<BuyAndSellPage> createState() => _BuyAndSellPageState();
}

class _BuyAndSellPageState extends State<BuyAndSellPage> with TickerProviderStateMixin{

  //controller Declaration
  BuyAndSellController cnt_bsc = Get.put(BuyAndSellController());
  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());


  @override
  void initState() {
    // Todo:implement code
    super.initState();
    cnt_bsc.tabController = TabController(length: 3, vsync: this);
    cnt_bsc.futurepropertylist.value=cnt_bsc.RetrievePropertyListData().then((value) {
      return value;
      Future.delayed(Duration(milliseconds: 100)).then((value) {
        return cnt_bsc.scrollUpdate(cnt_bsc.scrollController);
      });
    });
    cnt_bsc.tabController.addListener(() {
      if (cnt_bsc.tabController.indexIsChanging) {
        cnt_bsc.Pagecount.value=1;
        cnt_bsc.Pagecount.refresh();
        cnt_bsc.futurepropertylist.value=cnt_bsc.RetrievePropertyListData();
      } else {
        cnt_bsc.Pagecount.value=1;
        cnt_bsc.Pagecount.refresh();
        cnt_bsc.futurepropertylist.value=cnt_bsc.RetrievePropertyListData();
      }
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
              endDrawer: CustomDrawer(animatedOffset: Offset(1.0, 0),),
              drawer: CustomDrawer(animatedOffset: Offset(-1.0, 0),),
              resizeToAvoidBottomInset: false,
              key: cnt_bsc.GlobalBuyAndSellkey,
              body: SafeArea(
                child: Container(
                  color: AppColors.BACKGROUND_WHITE,
                  // color:Colors.grey.shade200,
                  child: Stack(
                    children: [
                      NotificationListener<OverscrollIndicatorNotification>(
                        child: CustomScrollView(
                          keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                          scrollDirection: Axis.vertical,
                          slivers: [
                            SliverToBoxAdapter(child: SizedBox(height: APPBAR_HEIGHT,)),
                            SliverList(
                              delegate: SliverChildListDelegate([
                                Container(
                                  width: Get.width,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      MainWidget(),
                                      TabViewWidget(),
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                          ],
                        ),
                        onNotification: (overscroll) {
                          overscroll.disallowIndicator();
                          return true;
                        },
                      ),
                      cnt_CommonHeader.commonAppBar(BUY_AND_SELL, cnt_bsc.GlobalBuyAndSellkey,color: white)
                    ],
                  ),
                ),
              )
          ),
        ),
      );
    });
  }

  Widget MainWidget(){
    return Padding(
      padding: const EdgeInsets.only(left: 20,right: 20),
      child: CommonDropDownTextField(
        labelText: "Select Property Type*",
        onTap: () {
          cnt_bsc.SelectProject();
        },
        imageIcon: IMG_PROJECT_SVG_NEW,
        controller: cnt_bsc.txtProject,
        hintText: cnt_bsc.txtProject.text,
      ),
    );
  }

  Widget TabViewWidget() {
    return Obx(() {
      return FutureBuilder(
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null){
            if(cnt_bsc.arrPropertyList.length>0){
              return Container(
                height: Get.height-230,
                color: white,
                child:  DefaultTabController(
                  length: 3,
                  child: Scaffold(
                    backgroundColor: AppColors.BACKGROUND_WHITE,
                    appBar:  PreferredSize(
                      preferredSize: Size.fromHeight(50.0), // here the desired height
                      child: Container(
                        color: AppColors.BACKGROUND_WHITE,
                        padding: EdgeInsets.only(left:0.0,top: 10,right: 0),
                        // margin: EdgeInsets.only(left: 20,right: 20),
                        child:Center(child: Padding(padding: EdgeInsets.only(left: 0),
                          child: DecoratedBox(decoration:
                          BoxDecoration(color: Colors.white.withOpacity(0.0),
                            border: Border(bottom: BorderSide(color: APP_THEME_COLOR.withOpacity(0.1), width: 2.sp)),
                          ),
                              child: TabBar(
                                  isScrollable: true,
                                  labelColor: APP_THEME_COLOR,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  indicatorColor:APP_THEME_COLOR,
                                  controller: cnt_bsc.tabController,
                                  onTap:(val){
                                    cnt_bsc.SubIndex.value=val;
                                    cnt_bsc.SubIndex.refresh();
                                  },
                                  unselectedLabelColor: Colors.grey[500],
                                  tabs:const [
                                    Tab(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 5, right: 5),
                                        child: Text(
                                          "Furnished",
                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),),
                                      ),
                                    ),
                                    Tab(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 5, right: 5),
                                        child: Text(
                                          "Semi Furnished",
                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                                        ),),),
                                    Tab(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 5, right: 5),
                                        child: Text(
                                          "Full Furnished",
                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),),
                                      ),
                                    ),
                                  ]
                              )),),),
                      ),
                    ),
                    body:TabBarView(
                      controller: cnt_bsc.tabController,
                      //clipBehavior: Clip.hardEdge,
                      children: [
                        Furnished(),
                        SemiFurnished(),
                        FullFurnished(),
                      ],
                    ),
                  ),
                ),
              );
            }
            else{
              return Container(
                height: Get.height*0.65,
                child: Center(child:
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Text(cnt_bsc.Message.value ?? "NO Data Found",style:
                  semiBoldTextStyle(fontSize: 18)
                    // TextStyle(fontSize: 15,fontWeight:FontWeight.bold,),
                  ),
                ),),
              );
            }
          }
          else{
            return ProjectShimmerEffect();
          }
        },
        future: cnt_bsc.futurepropertylist.value,
      );
    });
  }

  Widget SubListWidget(){
    return ListOfDesign();
  }

  Widget Furnished(){
    return SingleChildScrollView(child: SubListWidget());
  }
  Widget SemiFurnished(){
    return SingleChildScrollView(child: SubListWidget());
  }
  Widget FullFurnished(){
    return SingleChildScrollView(child: SubListWidget());
  }
  Widget ProjectShimmerEffect() {
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shimmerWidget(height: 120, width: Get.width, radius: cornarradius),
                  ],
                ),
              );
            } )


    );
  }

  Widget ListOfDesign(){
    return  Container(
        constraints: BoxConstraints(
            maxHeight: Get.height,
            minHeight: 50
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Container(
              child:     FutureBuilder(
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.data != null) {
                    return  ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: cnt_bsc.arrPropertyList.length,
                        physics:  BouncingScrollPhysics(),
                        controller: cnt_bsc.scrollController,
                        itemBuilder: (context,ind2){
                          BuyAndSellModel obj=cnt_bsc.arrPropertyList[ind2];
                          return Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Container(
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
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child:  Column(
                                    children: [
                                      Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[

                                            Expanded(
                                              child:  Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children:<Widget> [
                                                  Padding(padding: EdgeInsets.only(left: 15,top:0,bottom: 3),
                                                    child:

                                                    RichText(
                                                      text: TextSpan(
                                                        text: obj.title ?? "",
                                                        style: semiBoldTextStyle(fontSize: 15),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(padding: EdgeInsets.only(left: 15,top:0,bottom: 5),
                                                    child:Text(obj.address ?? "",style: mediumTextStyle(fontSize: 12,txtColor: Colors.grey)),),

                                                  Padding(padding: EdgeInsets.only(left: 15,top:5,bottom: 10),
                                                    child:Text((obj.area!+ " sq ft."),style: mediumTextStyle(fontSize: 12,)),),


                                                ],),
                                            ),
                                            if(obj.contact!=null && obj.contact!="")     GestureDetector (
                                                onTap: (){
                                                  cnt_bsc.makePhoneCall(obj.contact!=null?'+'+obj.contact.toString():'');
                                                },

                                                child: Padding(
                                                    padding: EdgeInsets.only(right: 15),
                                                    child: Container(
                                                      height: 40, width: 40,
                                                      padding: EdgeInsets.all(10),
                                                      decoration: BoxDecoration(shape: BoxShape.circle,color: APP_THEME_COLOR),
                                                      child: SvgPicture.asset(IMG_CALL_SVG_NEW, height: 20,color: white,),
                                                    ))

                                            ),
                                          ]),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                                padding: const EdgeInsets.only(left: 15.0,bottom: 5),
                                                child:   Wrap(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(right: 10),
                                                      decoration: BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                                offset:Offset(0,0),
                                                                color: APP_THEME_COLOR.withOpacity(0.1),
                                                                spreadRadius: 0
                                                            )
                                                          ],

                                                          borderRadius: BorderRadius.circular(15),
                                                          border: Border.all(color: APP_THEME_COLOR.withOpacity(0.7),)
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 8.0),
                                                        child: Text(obj.isproperty ?? "",style:
                                                        mediumTextStyle(fontSize: 10,txtColor: APP_THEME_COLOR),
                                                          textAlign: TextAlign.center,),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(right: 10),
                                                      decoration: BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                                offset:Offset(0,0),
                                                                color: APP_THEME_COLOR.withOpacity(0.1),
                                                                spreadRadius: 0
                                                            )
                                                          ],

                                                          borderRadius: BorderRadius.circular(15),
                                                          border: Border.all(color: APP_THEME_COLOR.withOpacity(0.7),)
                                                      ),
                                                      child: Wrap(
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 8.0),
                                                            child: Text(obj.configuration ?? "",style:
                                                            mediumTextStyle(fontSize: 10,txtColor: APP_THEME_COLOR),
                                                              textAlign: TextAlign.center,),
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                  ],
                                                )


                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 15.0,bottom: 5,top: 2),
                                            child: GestureDetector(
                                              onTap: (){
                                                cnt_bsc.Details_About_Unit_Bottom_sheet(obj.title! ,obj.description!);
                                              },
                                              child: Text("Details",style:
                                              boldTextStyle(fontSize: 12,txtColor: APP_THEME_COLOR),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),),
                              ),
                            ),
                            // ),
                          );
                        });
                  } else{
                    return Container();
                  }
                },
                future: cnt_bsc.futurepropertylist.value,
              )
          ),
        )
    );
  }

}
