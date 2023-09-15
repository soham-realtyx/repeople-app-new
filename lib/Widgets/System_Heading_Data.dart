import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Model/ComplaintModel/GrievanceDetailsModel.dart';
import 'package:Repeople/View/ManagerScreensFlow/ManagerChatingScreen/ManagerChatingScreen.dart';

import '../Config/utils/Strings.dart';
import '../Config/utils/styles.dart';

class System_Heading_Data extends StatelessWidget{
  final Activity? data;
  System_Heading_Data({this.data});
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
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipOval(
                      child:
                      data?.profile!=null && data?.profile!=''?Image(
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                          image: NetworkImage(data?.profile??"")):Image(
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                          image: AssetImage('assets/images/ic_login.png'))),
                ],
              ),
            ),
            // Container(
            //   constraints: BoxConstraints(
            //       maxWidth: MediaQuery.of(context).size.width/1.3
            //   ),
            //   decoration: new BoxDecoration(
            //     color: WHITE,
            //     boxShadow: [smallcontainerboxShadow],
            //     borderRadius: BorderRadius.only(
            //       topRight: Radius.circular(cornarradius),
            //       topLeft: Radius.circular(cornarradius),
            //       bottomLeft: Radius.circular(cornarradius),
            //       bottomRight: Radius.circular(cornarradius),
            //     ),
            //   ),
            //   child: Row(
            //     mainAxisAlignment:MainAxisAlignment.spaceBetween,
            //     children: <Widget>[
            //       Flexible(
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children:<Widget> [
            //             SizedBox(height: 10,),
            //             Padding(padding: EdgeInsets.symmetric(vertical: 0,horizontal: 8),
            //               child:Text(
            //                 title!,style:
            //               regularTextStyle(fontSize: 11,txtColor: Colors.black87),
            //
            //
            //                 // TextStyle(fontSize: 15,fontWeight:FontWeight.w400,color: Colors.black87,
            //                 //     fontFamily: "Montserrat-Medium"  ),
            //               ),),
            //             Container(
            //                 padding: EdgeInsets.only(top: 3),
            //                 width: MediaQuery.of(context).size.width/1.33,
            //                 child:  Row(
            //                   mainAxisAlignment:MainAxisAlignment.end,
            //                   children:<Widget> [
            //                     Text(datetime!,style:
            //                     regularTextStyle(fontSize: 8,txtColor: Colors.grey),
            //                       // TextStyle(fontSize: 10,color: Colors.grey,fontFamily: "Montserrat-Medium"),
            //                     ),
            //
            //
            //                   ],)),
            //             SizedBox(height: 10,),
            //           ],),
            //       ),
            //
            //     ],),
            // ),
            Expanded(
              flex: 5,
              child: Container(


                decoration: new BoxDecoration(
                      color: white,

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
                              data?.message??"",style:
                            regularTextStyle(fontSize: 11,txtColor: Colors.black87),

                              // TextStyle(fontSize: 15,fontWeight:FontWeight.w400,color: Colors.black87,
                              //     fontFamily: "Montserrat-Medium"  ),
                            ),),
                          Container(
                              padding: EdgeInsets.only(top: 3),
                              // width: MediaQuery.of(context).size.width/1.3,
                              child:  Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:MainAxisAlignment.end,
                                  children:<Widget> [
                                    Text(data?.time??"",style:
                                    regularTextStyle(fontSize: 8,txtColor: Colors.grey),
                                      // TextStyle(fontSize: 10,color: Colors.grey,fontFamily: "Montserrat-Medium"),
                                    ),
                                  ],),
                              )),
                          SizedBox(height: 10,),
                        ],),
                    ),

                  ],),
              ),
            ),
          ],),
     if(data!=null && data?.media!=null && data!.media!.isNotEmpty)
        Container(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // ClipOval(
                //     child:
                //     widget.cmp_lst!.msg_list![ind].profile_image!=null &&
                //         widget.cmp_lst!.msg_list![ind].profile_image!=''?
                //     Image(
                //         height: 40,
                //         width: 40,
                //         fit: BoxFit.cover,
                //         image: NetworkImage(widget.cmp_lst!.msg_list![ind].profile_image!)):Image(
                //         height: 40,
                //         width: 40,
                //         fit: BoxFit.cover,
                //         image:
                //         AssetImage
                //           ('assets/images/ic_login.png'))),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipOval(
                          child:
                          data?.profile!=null && data?.profile!=''?Image(
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                              image: NetworkImage(data?.profile??"")):Image(
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                              image: AssetImage('assets/images/ic_login.png'))),
                    ],
                  ),
                ),

                Expanded(
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
                            padding: EdgeInsets.only(right: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                InkWell( onTap : () {
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
                                            data?.media?[index]??""
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
              ],
            ))
       // Padding(padding: EdgeInsets.symmetric(vertical: 6),
       //    child:Text('tushar',style:
       //    mediumTextStyle(fontSize: 12,txtColor:Colors.black54)
       //      // TextStyle(fontSize: 12,
       //      //     fontWeight:FontWeight.w500,color: Colors.black54,fontFamily: "Montserrat-Medium"),
       //    ),),

      ],),);
  }

}