import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Widgets/CustomButton.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:Repeople/Widgets/TextEditField.dart';
import '../Config/Constant.dart';
import '../Config/Function.dart';
import '../Config/utils/Strings.dart';
import '../Config/utils/colors.dart';

typedef void onTap();
BuildContext contextCommon = Get.context!;
enum TotalButton { ONE, TWO }

Future<void> HideKeyboard() async {
  FocusManager.instance.primaryFocus?.unfocus();
}


void bottomSheetDialog({required Widget child,
      // BuildContext? context,
      required String message,
      Widget? text,
      bool enableDrag = false,
      bool isDismissible = true,
      bool isHideAutoDialog = false,
      bool isCloseMenuShow = false,
      onWillPop,
      double? maxHeight,
      Color? backgroundColor,
      double? toppadding,
      Color? mainColor,
      int? hideDuration}) {
  HideKeyboard().then((value) {
    Future.delayed(const Duration(milliseconds: 300), () {
      Get.bottomSheet(
          Container(
            constraints: BoxConstraints(maxHeight: maxHeight ?? Get.height * 0.85),
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(contextCommon).viewInsets.bottom),
              child: WillPopScope(
                onWillPop: onWillPop,
                child: Stack(
                  children: [
                    Container(
                        clipBehavior: Clip.hardEdge,
                        margin: EdgeInsets.only(top: toppadding??60),
                        decoration: BoxDecoration(
                            color: mainColor ?? white,
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(20), topLeft: Radius.circular(20))),
                        child: SingleChildScrollView(
                          child: child,
                        )),
                    Container(
                      width: Get.width,
                      height: 60,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          color: backgroundColor ?? AppColors.GREEN,
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(20), topLeft: Radius.circular(20))),
                      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
                      child: Align(
                        alignment: Alignment.center,
                        child: message != ""
                            ? Center(
                              child: Text(
                          message.toString(),
                          textAlign: TextAlign.center,
                          style:
                              semiBoldTextStyle(fontSize: 18,txtColor:AppColors.WHITE, ),
                        ),
                            )
                            : text,
                      ),
                    ),
                    //if (isCloseMenuShow) Positioned(bottom: 15, right: 15, child: PopMenuButton()),
                  ],
                ),
              ),
            ),
          ),
          isScrollControlled: true,
          isDismissible: isDismissible,
          enableDrag: enableDrag,
          shape: const RoundedRectangleBorder(
            borderRadius:
            BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          backgroundColor: backgroundColor ?? AppColors.GREEN,
          enterBottomSheetDuration: const Duration(milliseconds: 500),
          exitBottomSheetDuration: const Duration(milliseconds: 500));
      if (isHideAutoDialog) {
        Future.delayed(Duration(seconds: hideDuration ?? 3), () {
          Get.back();
        });
      }
    });
  });
}


validationMsg(String msg) {
  FocusManager.instance.primaryFocus?.unfocus();
  // Future.delayed(Duration(milliseconds: 300), () {
  bottomSheetDialog(
      isDismissible: false,
      onWillPop: () async {
        return false;
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          showMessage(msg),
        ],
      ),
      isHideAutoDialog: true,
      message: "Error",
      hideDuration: HIDEDURATION,
      backgroundColor: AppColors.RED);
  // });
}


Widget showMessage(String message) {
  return Container(
    // height: 100,
    padding: const EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 40),
    child: Align(
      alignment: Alignment.topLeft,
      child: Text(
        message.toString().toLowerCase(),
        style: TextStyle(color: AppColors.BLACK, fontWeight: FontWeight.w400, fontSize: 16),
      ),
    ),
  );
}
Widget successMessageToast({String? message}){
  return Container(
    decoration: BoxDecoration(
        color: new_green_color,
        borderRadius: BorderRadius.circular(52)
    ),
    child: Text("${"✓"} ${message.toString()}",style: TextStyle(color:white,fontSize: 10.sp,fontWeight: FontWeight.w600,fontFamily: fontFamily)),
  );
}

void  commonBottomSheet(
    {
      required BuildContext context,
      Widget? text,
      bool enableDrag = false,
      bool isDismissible = true,
      bool isHideAutoDialog = false,
      bool isCloseMenuShow = false,
      onWillPop,
      double? maxHeight,
      Color? fullSheetBackgroundColor,
      Color? mainColor,
      int? hideDuration,
      String? title,
      TextStyle? titlestyle,
      Color? titlecolor,



      bool? showclosebutton,
      TextStyle? closebuttonstyle,
      onTap? closebuttontap,
      Color? closebuttoncolor,
      Icon? closeicon,

      String? description,
      TextStyle? descriptionstyle,
      Color? descriptioncolor,

      Widget? button1,
      TextStyle? button1_style,
      Text? button1_text,
      TextStyle? button1_textstyle,
      Color? button1_text_color,
      onTap? button1_tap,

      String? cancel_text,
      TextStyle? canceltext_style,
      Color? canceltext_color,
      onTap? canceltext_tap,

      Widget? button2,
      TextStyle? button2_style,
      OnTapPress? button2_tap,
      String? button2_text,
      TextStyle? button2_textstyle,
      Color? button2_text_color,

      bool? isdescription2,
      String? description2,
      TextStyle? description2_style,
      Color? description2_color,

      bool? boxshadow,
      // required Widget icon,
      Color? sheetbackgroundcolor

      // OnTapPress? onTap,

    })
{
  HideKeyboard().then((value) {
    Future.delayed(Duration(milliseconds: 300), () {
      print(description2);
      showModalBottomSheet<void>(
        //barrierColor: AppColors.grey_color.withOpacity(0.2),
        backgroundColor: fullSheetBackgroundColor,
        enableDrag: true,
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 270,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color:  sheetbackgroundcolor,
              // color:  GREY_SHADE_200,
              // color:  Theme.of(context).scaffoldBackgroundColor,

              borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        //padding:  EdgeInsets.symmetric(vertical: 15.h,horizontal: 15.w),
                        padding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title??"",
                              style:titlestyle ??
                                  const TextStyle(fontSize: 14),
                            ),
                            showclosebutton==true
                                ?
                            InkWell(
                                hoverColor: AppColors.TRANSPARENT,
                                splashColor: AppColors.TRANSPARENT,
                                highlightColor: AppColors.TRANSPARENT,
                                onTap: closebuttontap,
                                child:
                                closeicon
                            ):
                            const SizedBox(),
                          ],
                        ),
                      ),
                      Padding(
                        padding:  const EdgeInsets.only(top: 30,bottom: 20),
                        child: Text(
                          description??"",
                          textAlign: TextAlign.center,
                          style:descriptionstyle ??
                              const TextStyle(fontSize: 14),
                        ),
                      ),
                      isdescription2==true?
                      Text(
                        description2??"",
                        textAlign: TextAlign.center,
                        style:description2_style ??
                            const TextStyle(fontSize: 14,),

                      ):const SizedBox(),

                    ],
                  ),
                ),
                Container(
                  height: 65,
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                      color:  Theme.of(context).primaryColor,
                      boxShadow: [
                        boxshadow==true?
                        BoxShadow(
                          offset: Offset(2,2),
                          spreadRadius: 15,
                          blurRadius: 10.0,
                          // color: AppColors.RED
                          color:  Theme.of(context).primaryColor,
                        ): BoxShadow(
                            color: AppColors.TRANSPARENT
                        )
                      ]
                  ),
                  // width: Get.width,
                  child: Row(
                    children: [
                      InkWell(
                        hoverColor: AppColors.TRANSPARENT,
                        splashColor: AppColors.TRANSPARENT,
                        highlightColor: AppColors.TRANSPARENT,
                        onTap: canceltext_tap,
                        child: Container(
                          width: Get.width/3,
                          child: Text(cancel_text??"",
                              textAlign: TextAlign.center,
                              style: canceltext_style ??TextStyle(
                                fontSize: 12,color: Color(0xff818181)
                              )
                          ),

                        ),
                      ),
                      Expanded(
                        child: button2 ??
                            InkWell(
                              splashColor: AppColors.TRANSPARENT,
                              hoverColor: AppColors.TRANSPARENT,
                              focusColor: AppColors.TRANSPARENT,
                              highlightColor: AppColors.TRANSPARENT,
                              onTap: button2_tap,
                              child: Container(
                                width: Get.width * 0.35,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: AppColors.ORANGE_COLOR,
                                  borderRadius: BorderRadius.circular(radius),
                                ),
                                child: Center(
                                  child: Text(
                                    button2_text ?? "",
                                    style:button2_textstyle??TextStyle(
                                        color: Theme.of(context).primaryColor, fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      );

      if (isHideAutoDialog) {
        Future.delayed(Duration(seconds: hideDuration ?? 3), () {
          // print('close * * * ');
          Get.back();
        });
      }
    });
  });



}

Widget AlertDialogButton(
    String? message,
    TotalButton? totalButton,
    String? buttonName,
    String? button2Name,
    onTap? onTap,
    onTap? onTap2,
    Color? bgColor,
    Color? bgColor2,
    TextStyle? textStyle,
    TextStyle? textStyle2) {
  return Container(
      width: Get.width,
      padding: EdgeInsets.all(30),
      child: Center(
        child: Column(
          children: [
            Text(
              message?.toString() ?? "",
              style:
                  regularTextStyle(txtColor: AppColors.BLACK,fontSize: 16),
              // TextStyle(color: AppColors.BLACK, fontWeight: FontWeight.w400, fontSize: 16.sp),
            ),
            SizedBox(
              height: 15.w,
            ),
            totalButton == TotalButton.ONE
                ?
            CustomButtons.WidgetButton(
                onTap: () => Get.back(),
                height: 45,
                width: Get.width,
                radius: 22,
                boxShadow: false,
                bgColor: bgColor ?? AppColors.WHITE,
                child: Text(
                  buttonName ?? "",
                  style: textStyle,
                ))
                : TwoButtonDesign(onTap, onTap2, bgColor, bgColor2, textStyle, textStyle2,
                buttonName, button2Name)
          ],
        ),
      ));
}

Widget TwoButtonDesign(
    onTap? onTap,
    onTap? onTap2,
    Color? bgColor,
    Color? bgColor2,
    TextStyle? textStyle,
    TextStyle? textStyle2,
    String? buttonName,
    String? button2Name,
    ) {
  return Row(
    children: [
      Expanded(
        child:
        OnTapButton(
            onTap:onTap,
            // width: Get.width-50,
            height: 40,
            decoration:
            CustomDecorations().backgroundlocal(APP_THEME_COLOR, cornarradius, 0, APP_THEME_COLOR),
            text: buttonName,
            style: TextStyle(color: white,fontWeight: FontWeight.w600, fontSize: 14)),
        // CustomButtons.WidgetButton(
        //   onTap: onTap,
        //   height: 45,
        //   width: Get.width,
        //   radius: 22,
        //   boxShadow: false,
        //   bgColor: bgColor ?? AppColors.WHITE,
        //   child: Text(
        //     buttonName ?? "",
        //     style: textStyle,
        //   ),
        // ),
      ),
      SizedBox(width: 30,),
      Expanded(
        child:
        OnTapButton(
            onTap: onTap2,
            // width: Get.width,
            height: 40,
            decoration:
            CustomDecorations().backgroundlocal(APP_GRAY_COLOR, cornarradius, 0, APP_GRAY_COLOR),
            text: button2Name,
            style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600, fontSize: 14)),
        // CustomButtons.WidgetButton(
        //   onTap: onTap2,
        //   height: 45,
        //   width: Get.width,
        //   radius: 22,
        //   boxShadow: false,
        //   bgColor: bgColor2 ?? AppColors.WHITE,
        //   child: Text(
        //     button2Name ?? "",
        //     style: textStyle2,
        //   ),
        // ),
      ),
    ],
  );
}

SuccessMsg(String msg, {String title = "Success"}) {
  FocusManager.instance.primaryFocus?.unfocus();
  // Future.delayed(Duration(milliseconds: 300), () {
  bottomSheetDialog(
      isDismissible: false,
      onWillPop: () async {
        return false;
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          showMessage(msg),
        ],
      ),

      isHideAutoDialog: true,
      message: title,
      hideDuration: HIDEDURATION,
      backgroundColor: AppColors.GREEN);
  // });
}
GrievanceAddSuccessMsg(String? msg) {
  FocusManager.instance.primaryFocus?.unfocus();
  // Future.delayed(Duration(milliseconds: 300), () {
  bottomSheetDialog(
      isDismissible: false,
      onWillPop: () async {
        return false;
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          successMessageToast(message: msg.toString()),
        ],
      ),

      isHideAutoDialog: true,
      hideDuration: HIDEDURATION,message: '');
  // });
}



ErrorMsg(String msg, {String title = "Error"}) {
  FocusManager.instance.primaryFocus?.unfocus();
  // Future.delayed(Duration(milliseconds: 300), () {
  bottomSheetDialog(
      isDismissible: false,
      onWillPop: () async {
        return false;
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          showMessage(msg),
        ],
      ),
      isHideAutoDialog: true,
      message: title,
      hideDuration: HIDEDURATION,
      backgroundColor: AppColors.RED_COLOR);
  // });
}


void commondialog({
  BuildContext? context,
  BorderRadius? maincontainerborder,
  Color? bordercolor,
  double? stackraduis,
  required Widget stackicon,
  BorderRadius? stackborder,
  BorderRadius? buttonborder,
  MaterialColor? stackcolor,
  MaterialColor? maincontainercolor,
  required String dialogtext,
  // required Container firstbutton,
  required OnTapPress firstbuttontap,
  required String firstbuttontext,
  Color? firstbuttontextcolor,
  BoxDecoration? firstbuttonboxdecoration,
  FontWeight? firstbuttontextfontweight,
  required OnTapPress secondbuttontap,
  required String secondbuttontext,
  Color? secondbuttontextcolor,
  BoxDecoration? secondbuttonboxdecoration,
  FontWeight? secondbuttontextfontweight,
  // required Container secondbutton,

}){
  showDialog(
    barrierColor: Colors.black.withOpacity(0.3),
      barrierDismissible: false,
      context: contextCommon,
      builder: (context){
        //final themeprovider=Provider.of<ThemeNotifier>(context);
        return
          Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: maincontainerborder?? BorderRadius.circular(15.0)
              ),
              child: Stack(
                clipBehavior: Clip.none,
                // overflow: Overflow.visible,
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: bordercolor ?? Colors.transparent),
                      // color: Colors.white,
                        color: maincontainercolor?? APP_GRAY_COLOR,
                        borderRadius: buttonborder ?? BorderRadius.all(Radius.circular(20))),
                    height: Get.height/4.7,
                    child: Padding(
                      padding:  EdgeInsets.only(top: 30,left: 10,right: 10),
                      child: Column(
                        children: [
                          SizedBox(height: 5,),
                          Expanded(
                            flex: 3,
                            child: Container(
                              child: Center(
                                child: Text(
                                  dialogtext,
                                  // 'Are you sure you want to logout?',
                                  // 'Are you sure ',
                                  textAlign: TextAlign.center,
                                  style:
                                      semiBoldTextStyle(fontSize: 18,txtColor: Colors.black,),
                                  // TextStyle(
                                  //   fontWeight: FontWeight.w600,
                                  //   fontSize: 18,
                                  //   color: Colors.black,
                                  // ),
                                ),
                              ),
                            ),
                          ),

                          // const SizedBox(height: 10.0,),
                          // const SizedBox(height: 30.0,),
                          // firstbutton,
                          Expanded(
                            flex: 2,
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                      child:
                                    OnTapButton(
                                        onTap: firstbuttontap,
                                        // width: 100,
                                        height: 40,
                                        decoration: firstbuttonboxdecoration??
                                        CustomDecorations().backgroundlocal
                                          (Colors.grey, cornarradius, 0, Colors.grey,),
                                        text: firstbuttontext,
                                        style:

                                        TextStyle(
                                            color: firstbuttontextcolor ?? white,
                                            fontWeight: firstbuttontextfontweight??FontWeight.w600,
                                            fontSize: 14
                                        )),
                                  ),
                                  SizedBox(width: 15,),
                                  Expanded(
                                      child:
                                    OnTapButton(
                                        onTap:
                                          secondbuttontap,
                                          // Get.to(DashboardPage());

                                        // width: 100,
                                        height: 40,
                                        decoration:
                                        CustomDecorations().backgroundlocal(APP_THEME_COLOR, cornarradius, 0, APP_THEME_COLOR),
                                        text: secondbuttontext,
                                        style: TextStyle(color: secondbuttontextcolor ?? white,
                                            fontWeight: secondbuttontextfontweight ?? FontWeight.w600,
                                            fontSize: 14)),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height:10.0)

                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: -35,
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: stackborder ?? BorderRadius.all(Radius.circular(40))),
                        child: CircleAvatar(
                          backgroundColor:stackcolor ??APP_THEME_COLOR,
                          // backgroundColor: Colors.grey[900],
                          radius: stackraduis?? 35,
                          child: stackicon,
                          // const Icon(Icons.exit_to_app,size: 40.0,color:Colors.white,
                        )
                    ),
                  )
                ],
              )
          );

      }
  );
}




void LoginDialoge({
  BuildContext? context,
  BorderRadius? maincontainerborder,
  Color? bordercolor,
  double? stackraduis,
  required Widget stackicon,
  BorderRadius? stackborder,
  BorderRadius? buttonborder,
  MaterialColor? stackcolor,
  MaterialColor? maincontainercolor,
  required String dialogtext,
  // required Container firstbutton,
  required OnTapPress firstbuttontap,
  required String firstbuttontext,
  Color? firstbuttontextcolor,
  BoxDecoration? firstbuttonboxdecoration,
  FontWeight? firstbuttontextfontweight,
  required OnTapPress secondbuttontap,
  required String secondbuttontext,
  Color? secondbuttontextcolor,
  BoxDecoration? secondbuttonboxdecoration,
  FontWeight? secondbuttontextfontweight,
  // required Container secondbutton,

}){
  showDialog(
      barrierColor: Colors.black.withOpacity(0.3),
      barrierDismissible: false,
      context: contextCommon,
      builder: (context){
        //final themeprovider=Provider.of<ThemeNotifier>(context);
        return
          Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: maincontainerborder?? BorderRadius.circular(15.0)
              ),
              child: Stack(
                clipBehavior: Clip.none,
                // overflow: Overflow.visible,
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        // border: Border.all(color: bordercolor ?? Colors.transparent),
                        // color: Colors.white,
                        color: maincontainercolor?? APP_GRAY_COLOR,
                        borderRadius: buttonborder ?? BorderRadius.all(Radius.circular(20))),
                    height: 190,
                    child: Column(
                      children: [
                        SizedBox(height: 5,),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding:  EdgeInsets.only(top: 20,left: 10,right: 10),
                            child: Center(
                              child: Text(
                                dialogtext,
                                // 'Are you sure you want to logout?',
                                // 'Are you sure ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: APP_THEME_COLOR
                                ),),
                            ),
                          ),
                        ),

                        // const SizedBox(height: 10.0,),
                        // const SizedBox(height: 30.0,),
                        // firstbutton,
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: GestureDetector(
                                      onTap: firstbuttontap,
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15))
                                        ),
                                        child: Material(
                                            elevation: 1,
                                            color: white,
                                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15)),
                                            child:
                                            Center(child: Text(firstbuttontext,style:
                                            TextStyle(fontWeight: FontWeight.w600),))),
                                      ),
                                    )
                                ),
                                Expanded(
                                    child: GestureDetector(
                                      onTap: secondbuttontap,
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15))
                                        ),
                                        child: Material(
                                            elevation: 1,
                                            color: APP_THEME_COLOR,
                                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(15)),
                                            child: Center(
                                                child:
                                                Text(secondbuttontext,style:
                                                TextStyle(color: white,fontWeight: FontWeight.w600),))),
                                      ),
                                    )
                                ),





                              ],
                            ),
                          ),
                        ),
                        // SizedBox(height:20.0)



                      ],
                    ),
                  ),
                  Positioned(
                    top: -35,
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: stackborder ?? BorderRadius.all(Radius.circular(40))),
                        child: CircleAvatar(
                          backgroundColor:stackcolor ??APP_THEME_COLOR,
                          // backgroundColor: Colors.grey[900],
                          radius: stackraduis?? 35,
                          child: stackicon,
                          // const Icon(Icons.exit_to_app,size: 40.0,color:Colors.white,
                        )
                    ),
                  )
                ],
              )
          );

      }
  );
}