import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:Repeople/Widgets/ShimmerWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Helper/MoengageAnalyticsHandler.dart';
import 'package:shimmer/shimmer.dart';
import '../../Config/Constant.dart';
import '../../Config/utils/colors.dart';
import '../../Controller/ComitteeController/committeeController.dart';
import '../../Controller/CommonHeaderController/CommenHeaderController.dart';

class committeePage extends StatefulWidget {
  const committeePage({Key? key}) : super(key: key);

  @override
  State<committeePage> createState() => _committeePageState();
}

class _committeePageState extends State<committeePage> with SingleTickerProviderStateMixin {

  CommitteController cnt_cmt=Get.put(CommitteController());
  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());



  @override
  void initState(){
    super.initState();
    MoengageAnalyticsHandler().track_event("committee_page");
    cnt_cmt.LoadData();
    cnt_cmt.scrollController.addListener(() {
      cnt_cmt.scrollUpdate(cnt_cmt.scrollController);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.BACKGROUND_WHITE,
        endDrawer: CustomDrawer(animatedOffset: Offset(1.0,0),),
        drawer: CustomDrawer(animatedOffset: Offset(-1.0,0),),
        resizeToAvoidBottomInset: false,
        key: cnt_cmt.GlobalCommiteePagekey,
        body: SafeArea(
          child: Container(
            child: Stack(
              children: [
                NotificationListener<OverscrollIndicatorNotification> (
                  child: RefreshIndicator(
                    displacement: 60,
                    onRefresh: cnt_cmt.onRefresh,
                    child: CustomScrollView(
                      controller: cnt_cmt.scrollController,
                      physics: AlwaysScrollableScrollPhysics(),
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
                              child: CommitteView(),
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
                cnt_CommonHeader.commonAppBar(COMMITTEE_APPMENUNAME_CAP, cnt_cmt.GlobalCommiteePagekey,color: white)


              ],
            ),
          ),
        )
    );
  }

  Widget CommitteView() {
    return  Column(
      children: [
        BuildingDirectoryMainView(),
        SizedBox(height: 5,),
        Obx(() =>  Visibility(
            visible:cnt_cmt.projectvisible.isTrue,
            child:  MemberList()))
      ],
    );

  }
  Widget BuildingDirectoryMainView() {
    return  Obx(() {
      return
        FutureBuilder(
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null)
              if(cnt_cmt.arrProjectList.length !=1){
                return Column(children: [
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                    child: TextFormField(
                      onTap: () {
                        cnt_cmt.SelectProject();
                      },
                      readOnly: true,
                      style: TextStyle(fontSize: 18, color: APP_FONT_COLOR, fontWeight: FontWeight.bold),
                      controller: cnt_cmt.txtProject,
                      textAlignVertical: TextAlignVertical.top,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      // validator: (value) =>
                      //     validation(value, "Please select project"),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: LIGHT_GREY)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: LIGHT_GREY)),
                          errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                          disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                          focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                          contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                          labelStyle:semiBoldTextStyle(fontSize: 16,txtColor: Colors.black.withOpacity(0.7)),
                          // TextStyle(
                          //     fontSize: 16, color: Colors.black.withOpacity(0.7), fontWeight: FontWeight.bold),
                          // labelText: "Select Project*",
                          hintText: 'Select Project',
                          hintStyle: boldTextStyle(fontSize: 18,txtColor: APP_FONT_COLOR),

                          // TextStyle(color: APP_FONT_COLOR, fontWeight: FontWeight.bold),
                          floatingLabelBehavior: FloatingLabelBehavior.always ,
                          // prefixIcon: Container(
                          //   width: 50,
                          //   height: 50,
                          //   margin: EdgeInsets.only(right: 10, left: 0,bottom: 10),
                          //   padding: const EdgeInsets.all(10.0),
                          //   decoration: CustomDecorations()
                          //       .backgroundlocal(APP_GRAY_COLOR, cornarradius, 0, APP_GRAY_COLOR),
                          //   child:
                          //   SvgPicture.asset(IMG_PROJECT_SVG_NEW) ,
                          //   // Image.asset(IMG_PROJECT),
                          // ),
                          suffixIcon: Icon(Icons.arrow_drop_down)),
                    ),
                  ),
                ],);
              }
              else{
                return SizedBox(height: 10,);
              }
            else{
              return ProjectShimmerEffect();
            }
          },
          future: cnt_cmt.futureProjectData.value,
        );

    });
  }

  Widget MemberList() {
    return Obx(() {
      return FutureBuilder(
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null  ) {
            if(cnt_cmt.arrCommiteeList.isNotEmpty){
              return MemberListData();
            }
            else{
              return Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(image: AssetImage(IMG_NO_DATA_FOUND)),
                  Padding(padding: EdgeInsets.only(top:15,bottom: 5,),
                    child:Text(cnt_cmt.message.value,style:
                    semiBoldTextStyle(fontSize: 15)
                      // TextStyle(fontSize: 15,fontWeight:FontWeight.bold,),
                    ),),
                ],
              ),);
            }


          } else {
            return ProjectShimmerEffect();
          }
        },
        future: cnt_cmt.futureCommiteeListData.value,
      );
    });
  }

  Widget MemberListData(){
    return Obx(() {
      return Container(
          child:    ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              controller: cnt_cmt.scrollController,
              itemCount:cnt_cmt.arrCommiteeList.length,
              physics:  ClampingScrollPhysics(),
              itemBuilder: (context,ind){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[ Padding(padding: EdgeInsets.only(left:20,top:10,bottom: 5),
                      child:Text(
                        cnt_cmt.arrCommiteeList[ind].role??"",
                        style:TextStyle(color: gray_color_1, fontSize: 14,fontWeight: FontWeight.w600), // ),
                        //TextStyle(color: Colors.black,fontSize: 17),
                      )),
                    if(cnt_cmt.arrCommiteeList[ind].commitees!=null)
                      ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: cnt_cmt.arrCommiteeList[ind].commitees!.isNotEmpty?
                          cnt_cmt.arrCommiteeList[ind].commitees!.length :0,
                          physics:  ClampingScrollPhysics(),
                          itemBuilder: (context,ind2){
                            return  Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                              child:
                              Container(
                                padding: EdgeInsets.only(left:15,right: 15),
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
                                width: MediaQuery.of(context).size.width,
                                child:  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[

                                      Padding(padding: EdgeInsets.only(left:0),
                                        child:
                                        ClipOval(
                                          child: cnt_cmt.arrCommiteeList[ind].commitees![ind2].profile!=null?
                                          cnt_cmt.arrCommiteeList[ind].commitees![ind2].profile!.contains("svg")?
                                          SvgPicture.network(
                                            cnt_cmt.arrCommiteeList[ind].commitees![ind2].profile.
                                            toString(),
                                            height: 60,
                                            width: 60,
                                            fit: BoxFit.cover,
                                          ):
                                          Image(
                                              height: 60,
                                              width: 60,
                                              fit: BoxFit.cover,
                                              image:
                                              NetworkImage(cnt_cmt.arrCommiteeList[ind].commitees![ind2].profile.
                                              toString()))
                                              :
                                          Container(
                                            height: 50,
                                            width: 50,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(50),
                                              color: Colors.grey,
                                            ),
                                            child:
                                            Padding(
                                              padding:
                                              EdgeInsets.all(0),child:
                                            Text(cnt_cmt.arrCommiteeList[ind].commitees![ind2].personname!.substring(0,1).toString().toUpperCase(),
                                              style:
                                              TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.bold),
                                            ),),
                                          )
                                          ,
                                        ),

                                      ),
                                      Expanded(
                                        child:  Row(
                                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Expanded(
                                              flex: 6,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children:<Widget> [
                                                  Padding(padding: EdgeInsets.only(left: 15,top:10,bottom: 5),
                                                    child:Text(cnt_cmt.arrCommiteeList[ind].commitees![ind2].personname??"",
                                                      style:
                                                      TextStyle(
                                                          fontSize: 15,
                                                          color: gray_color,
                                                          fontWeight: FontWeight.w600,
                                                          fontFamily: fontFamily,height: 1.5
                                                      ),
                                                      //TextStyle(fontSize: 15,fontWeight:FontWeight.bold,),
                                                    ),),
                                                  SizedBox(
                                                    width: 140,
                                                    child: Padding(padding: EdgeInsets.only(left: 15,top:0,bottom: 0),
                                                      child:Text(cnt_cmt.arrCommiteeList[ind].commitees![ind2].email ?? '',
                                                        style:
                                                        TextStyle(color: gray_color_1, fontSize: 12,fontWeight: FontWeight.w500),
                                                      ),),
                                                  ),
                                                  Padding(padding: EdgeInsets.only(left: 15,top:3,bottom: 10),
                                                      child:Text(cnt_cmt.arrCommiteeList[ind].commitees![ind2].mobileno??"",
                                                        style:
                                                        TextStyle(color: gray_color_1, fontSize: 12,fontWeight: FontWeight.w500),
                                                      ))],),
                                            ),

                                            Expanded(
                                              flex: 4,
                                              child: Row(
                                                children: [
                                                  InkWell(
                                                      splashColor: AppColors.TRANSPARENT,
                                                      hoverColor: AppColors.TRANSPARENT,
                                                      focusColor: AppColors.TRANSPARENT,
                                                      highlightColor:
                                                      AppColors.TRANSPARENT,
                                                      onTap: () {
                                                        print(  cnt_cmt.arrCommiteeList[ind].commitees![ind2].countrycode.toString()+cnt_cmt.arrCommiteeList[ind].commitees![ind2].mobileno.toString());
                                                        print("checking whatsapp");
                                                        cnt_cmt.launchWhatsapp(
                                                            cnt_cmt.arrCommiteeList[ind].commitees![ind2].mobileno!=null?
                                                            cnt_cmt.arrCommiteeList[ind].commitees![ind2].countrycode.toString()+cnt_cmt.arrCommiteeList[ind].commitees![ind2].mobileno.toString():'', "Hello");

                                                      },
                                                      child: Padding(
                                                          padding:
                                                          EdgeInsets.only(right: 10),
                                                          child: Container(
                                                            height: 38,
                                                            width: 38,
                                                            padding: EdgeInsets.all(10),
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape.circle,
                                                                color: AppColors.GREEN),
                                                            child: SvgPicture.asset(
                                                              IMG_WHATSAPP_SVG_NEW,
                                                              height: 20,
                                                              color: white,
                                                            ),
                                                          )
                                                      )),
                                                  GestureDetector(
                                                      onTap: (){
                                                        cnt_cmt.makePhoneCall(cnt_cmt.arrCommiteeList[ind].commitees![ind2].mobileno!=null?/*'+91 '+*/
                                                        cnt_cmt.arrCommiteeList[ind].commitees![ind2].mobileno.toString():'');
                                                      },

                                                      child:
                                                      Padding(
                                                          padding: EdgeInsets.only(
                                                              right: 0),
                                                          child: Container(
                                                            height: 38,
                                                            width: 38,
                                                            padding: EdgeInsets.all(10),
                                                            decoration: BoxDecoration
                                                              (shape: BoxShape.circle,color: APP_THEME_COLOR),
                                                            child: SvgPicture.asset(IMG_CALL_SVG_NEW,
                                                              height: 20,color: white,),
                                                          ))
                                                  ),
                                                ],
                                              ),
                                            ),],),)


                                      /*for this changes*/
                                    ]),),
                              // ),
                            );
                          }),
                    SizedBox(height: 15,),
                    ind!=cnt_cmt.arrCommiteeList.length-1?Divider(
                      thickness: 0.5,
                      color: APP_THEME_COLOR.withOpacity(0.1),
                      // color: BLACK,
                    ):SizedBox(),

                  ]
                  ,)
                ;})
      );
    });

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
                    shimmerWidget(height: 100, width: Get.width, radius: 10),
                  ],
                ),
              );
            } )


    );
  }

  Widget TabShimmerEffect() {
    return Container(
        height: 50,
        margin: EdgeInsets.only(left: 10, right: 10, top: 5),
        child:  ShimmerEffect(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (_, index) {
              return Padding(
                padding:
                const EdgeInsets.only(top: 5.0, bottom: 5, left: 1, right: 1),
                child: shimmerWidget(width: 80, height: 50, radius: 0),
              );
            },
            itemCount: 1,
          ),
        ));
  }
}
