import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/View/FacilitiesPage/FacilitiesHistoryPage.dart';
import 'package:Repeople/View/NewsListPage/NewsPage.dart';
import 'package:Repeople/View/RedeemPointPage/RedeemPointPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat, NumberFormat;
import 'package:Repeople/Config/Helper/HextoColor.dart';
import 'package:Repeople/Config/Helper/MoengageAnalyticsHandler.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Controller/NotificationController/NotificationDrawerController.dart';
import 'package:Repeople/Model/Dashbord/ExploreMoreListClass.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:Repeople/Widgets/NotificationCustomDrawer/NotificationCustomDrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:syncfusion_flutter_core/theme.dart';
import 'Constant.dart';
import 'utils/Images.dart';
import 'utils/colors.dart';



NotificationDrawerController drawerController = Get.put(NotificationDrawerController());
//GET SHARED PREFRENCEDATA
getSfStringValue(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String stringValue = prefs.getString(key) ?? '';
  return stringValue;
}

getSfBoolValue(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool boolval = prefs.getBool(key) ?? false;
  return boolval;
}

RxBool isDrawer1Open = false.obs;
RxBool isDrawer2Open = false.obs;

void toggleDrawer1() {

    isDrawer1Open.value = !isDrawer1Open.value;
    isDrawer2Open.value = false;

}

void toggleDrawer2() {

    isDrawer2Open.value = !isDrawer2Open.value;
    isDrawer1Open.value = false;

}

String capitalizeFirstLetter(String input) {
  if (input.isEmpty) {
    return input; // Handle empty string
  }
  return input[0].toUpperCase() + input.substring(1);
}
void Apploader(BuildContext context) {
  Get.dialog(
          Center(
              child: Container(
            width: 90,
            height: 90,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox.expand(
                  child: Image.asset('assets/images/loading.gif', height: 80, width: 80)),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: APP_THEME_COLOR, width: 2),
              borderRadius: BorderRadius.circular(45),
            ),
          )),
          barrierDismissible: false)
      .then((value) {
    if (Commonmessage != '') {
      displayDialog(context, Commonmessage, '');
      Commonmessage = '';
    }
  });
}

// void RemoveAppLoader(BuildContext context) {
//   Get.back();
//   // Navigator.of(context, rootNavigator: false).pop('dialog');
// }

double getSCREENWIDTH(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  return width;
}

double getSCREENHEIGHT(BuildContext context) {
  double height = MediaQuery.of(context).size.height;
  return height;
}

//SHOW ALERT Dialog
void displayDialog(BuildContext context, String massage, String title) {
  Get.generalDialog(pageBuilder: (buildContext, animation, secondaryAnimation) {
    Widget dialog = Builder(builder: (context) {
      return CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(massage),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text(
              "Dismiss",
              style: TextStyle(color: APP_FONT_COLOR),
            ),
            onPressed: () {
              Get.back();
            },
          )
        ],
      );
    });

    return dialog;
  });
}

Widget leadingIconOfAppbar(/*MaterialColor color*/) {
  return Container(
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child:
            SvgPicture.asset(
             // IMG_APPLOGO_SVG,
              REPEOPLE_APPLOGO_SVG,
              width: 126,

              color: hex("006CB5"),
                 height: 20,
            )
          // Image.asset(
          //   IMG_APPLOGO,
          //   width: 150,
          //   height: 60,
          //   color: color,
          // ),
        ),
      ],
    ),
  );
}

Widget TrallingIconNotification(MaterialColor color,{String notificationIcon = "",VoidCallback? onTap,}) {
  return Stack(
    children: [
      InkWell(
        splashColor: AppColors.TRANSPARENT,
        focusColor: AppColors.TRANSPARENT,
        highlightColor: AppColors.TRANSPARENT,
        hoverColor:  AppColors.TRANSPARENT,
        onTap: (){
          // OpenDrawer();
          MoengageAnalyticsHandler().track_event("notifications");
          Get.to(
              NotificationCustomDrawer(
                animatedOffset: Offset(1.0, 0),
              )
          );
        },
        child:
            //Image.asset(IMG_NOTIFICATON_PNG,height: 30,color: color),
        SvgPicture.asset(
          NOTIFICATION_SVG_ICONS,
          color: color,
          height: 24,
          width: 24,
        ),
      ),

      if(isbadgeshow.isTrue)   Positioned(
          left: 13,
          top: 4,
          child: ClipOval(
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: white,width: 1),
                color: hex("E20000"),
              ),
            ),
          )
      )
    ],
  );
}

Widget OpenDrawer(){
  return Scaffold(
    key: drawerController.GlobalNotificationkey,
    drawer: NotificationCustomDrawer( animatedOffset: Offset(1.0, 0),),
  );
}

Widget TrailingHistoryIcon(MaterialColor color, {String notificationIcon = ""}){
  return Stack(
    children: [
      IconButton(
        icon: Icon(
          Icons.more_time,
          size: 30,
          color: color,
        ),
        onPressed: () {
          Get.to(FacilitiesHistoryPage());
          //Get.to(Document_Screen());

        },
      ),
      // Positioned(
      //     left: 25,
      //     top: 12,
      //     child: Icon(
      //       Icons.circle,
      //       size: 10,
      //       color: Colors.red,
      //     ))
    ],
  );

}

Widget TrallingIconDrawer(String drawerIcon, MaterialColor color , VoidCallback onTap) {
  return Stack(
    children: [
      InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(right: 10, left: 5),
          child:
           SvgPicture.asset(
             IMG_SIDE_MENU_SVG,
             height: 25,
             width: 25,
             color: color,
           )
          // Image.asset(
          //   // drawerIcon,
          //   drawerIcon,
          //   // IMG_SIDEMENU_PNG,
          //   height: 25,
          //   width: 25,
          //   color: color,
          // ),
        ),
      )
    ],
  );
}



Widget TrallingIconSearch(String drawerIcon, MaterialColor color , VoidCallback onTap) {
  return Stack(
    children: [
      InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(right: 10, left: 5),
          child: Image.asset(
            drawerIcon,
            height: 25,
            width: 25,
            color: color,
          ),
        ),
      )
    ],
  );
}

RedeemButton(FontWeight fontWeight) {
  return InkWell(
      onTap: (){
        Get.to(RedeemPointPage());
      },
      child: Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
    decoration: CustomDecorations().backgroundlocal(white, 8, 0, white),
    child: Text(
      "Redeem Now",
      style: TextStyle(fontSize: 12, fontWeight: fontWeight, color: gray_color),
    ),
  ));
}

Widget OnTapButton(
    {BoxDecoration? decoration,
    double? height,
    double? width,
    TextStyle? style,
    String? text,
    Widget? icon,
      VoidCallback? onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      alignment: Alignment.center,
      decoration: decoration,
      width: width,
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text!,
            style: style,
          ),
          SizedBox(width: 3,),
          icon == null ? Container() : icon
        ],
      ),
    ),
  );
}
Widget OnBookSiteVisitButton(
    {BoxDecoration? decoration,
      double? height,
      double? width,
      TextStyle? style,
      String? text,
      Widget? icon,
      VoidCallback? onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      alignment: Alignment.center,
      decoration: decoration,
      width: width,
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text!,
            style: style,
          ),
          SizedBox(width: 5,),
          icon == null ? Container() : icon
        ],
      ),
    ),
  );
}
Widget HorizontalDivider({double? height,double? width,Color? color}){
  return Container(
    width: width??Get.width,
    height: height??1,
    color: color??gray_color_1,
  );
}
Widget OnLoginTapButton(
    {BoxDecoration? decoration,
      double? height,
      double? width,
      TextStyle? style,
      String? text,
      Widget? icon,
      VoidCallback? onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      alignment: Alignment.center,
      decoration: decoration,
      width: width,
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon == null ? Container() : icon,
          SizedBox(width: 6,),
          Text(
            text!,
            style: style,
          ),


        ],
      ),
    ),
  );
}
void copyToClipboard(BuildContext contextt, String textToCopy) {
  Clipboard.setData(ClipboardData(text: textToCopy));
  ScaffoldMessenger.of(contextt).showSnackBar(
    SnackBar(
      content: Text('ReferralCode copied to clipboard'),
    ),
  );
}
urlLauncher(String url)async{
  await launchUrl(Uri.parse(url),mode: LaunchMode.externalApplication);
}
Widget ReferFriendFavoiteButton(
    {BoxDecoration? decoration, double? width, double? height, MaterialColor? color,VoidCallback? onTap}) {
  return InkWell(
      onTap: onTap,
      child:Container(
    height: height,
    width: width,
    decoration: decoration,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child:
      // objList.iconImage!.toString().contains("svg")?
      SvgPicture.asset(
        // IMG_REFERRALSTATUS_SVG,
        IMG_REFERRALSTATUS_SVG_NEW_2,
        height: 25,
        // color: BLACK,
        color: color,
          fit: BoxFit.contain,
        // width: 20,
        // By default our  icon color is white
        // color: selectedIndex.value == index ? APP_THEME_COLOR : APP_FONT_COLOR,
      ),
      // Image.asset(
      //   // IMG_REFER_FRIEND_ICON,
      //   IMG_REFERRALSTATUS_SVG,
      //   color: color,
      //   fit: BoxFit.contain,
      // ),
    ),
  ));
}



SelectMenu(String appmenuname) {
  if(appmenuname == NEWS_APPMENUNAME){
    MoengageAnalyticsHandler().track_event("news");
    Get.back();
    Get.to(NewsListPage());

  }

  arrDrawerListTile.forEach((element) {
    element.isselected = false;
  });
  MenuItemModel objUserright = new MenuItemModel();
  var contain =
  arrDrawerListTile.where((element) => element.alias == appmenuname);
  if (contain.isNotEmpty) {
    int index = arrDrawerListTile
        .indexWhere((element) => element.alias == appmenuname);
    objUserright = arrDrawerListTile[index];
    objUserright.isselected = true;
  }
  arrDrawerListTile.refresh();

}

Widget TextImage({String? imageIcon,double? size,Text? text,MaterialColor? color}){
  return Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      imageIcon.toString().contains("svg")?
      SvgPicture.asset(imageIcon!,height: size,width: size,color: color,):
      Image.asset(imageIcon!,height: size,width: size,color: color,),
      SizedBox(width: 5,),
      text!
    ],
  );
}

Widget ImageWithBackGround(
    {MaterialColor? backgroundColor, double? height, double? width, MaterialColor? imgColor ,
      borderColor ,required String? image,double? radius,double? padding,double? elevetion,
      double? imageheight,double? imagewidth,}){
  return Card(
    elevation: elevetion??0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(radius??cornarradius))
    ),
    clipBehavior: Clip.hardEdge,
    child: Container(
      height: height,
      width: width,
      padding: EdgeInsets.all(padding??8),
      decoration:
      CustomDecorations().
      backgroundwithshadow(backgroundColor!, radius??cornarradius, 0, borderColor??backgroundColor),
      // CustomDecorations().
      // backgroundlocal(backgroundColor!, radius??cornarradius, 0, borderColor??backgroundColor),
      child: image.toString().contains("svg")?
      SvgPicture.asset(image!,color: imgColor,width: imagewidth,height: imageheight,):
      Image.asset(image!,color: imgColor,width: imagewidth,height: imageheight,),
    ),
  );
}


// SliderWidget
Widget Sf_SliderIndicator({
  String? title,
  required dynamic value,
  ValueChanged<dynamic>? onChanged,
  required dynamic min,
  required dynamic max,
  final double? stepSize,
  final double? height,
  final double? width,
  final SliderStepDuration? stepDuration,
  final double? interval,
  final int minorTicksPerInterval= 0,
  final bool showTicks=false,
  final bool showLabels=false,
  final bool showDividers=false,
  final bool enableTooltip=false,
  final bool shouldAlwaysShowTooltip = false,
  final bool? isInversed,
  final Color? inactiveColor,
  final Color? activeColor,
  final LabelPlacement labelPlacement= LabelPlacement.onTicks,
  final EdgeLabelPlacement? edgeLabelPlacement,
  final NumberFormat? numberFormat,
  final DateFormat? dateFormat,
  final DateIntervalType? dateIntervalType,
  final LabelFormatterCallback? labelFormatterCallback,
  final TooltipTextFormatterCallback? tooltipTextFormatterCallback,
  final SfSliderSemanticFormatterCallback? semanticFormatterCallback,
  final SfTrackShape trackShape= const SfTrackShape(),
  final SfDividerShape dividerShape = const SfDividerShape(),
  final SfOverlayShape overlayShape = const SfOverlayShape(),
  final SfThumbShape thumbShape = const SfThumbShape(),
  final SfTickShape tickShape= const SfTickShape(),
  final SfTickShape? minorTickShape,
  final SfTooltipShape tooltipShape = const SfRectangularTooltipShape(),
  final Widget? thumbIcon,
  bool edit_option=false,
  Widget? editwidget,

}){
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0,left: 0,right: 0,bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title??"",
                style: TextStyle(fontWeight: FontWeight.w600,fontFamily: fontFamily,fontSize: 10.sp,color: LIGHT_GREY_COLOR),
              ),
              if(edit_option&&editwidget != null) editwidget
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 7.0,top: 10),
          child: Container(
            // width: width,
            // color: Colors.green,
            child:  SfSliderTheme(
              data: SfSliderThemeData(
                thumbRadius: 5.5,
                thumbStrokeWidth: 1.9,
                thumbStrokeColor: white,
                activeDividerColor: DARK_BLUE,
                activeTrackColor: APP_THEME_COLOR,
                thumbColor: APP_THEME_COLOR,
                inactiveDividerColor: AppColors.BLACK,
                // activeDividerStrokeWidth: 100,
                overlayColor: AppColors.TRANSPARENT,
                activeTrackHeight: 4.h,
                activeLabelStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontFamily: fontFamily,
                    fontSize: 9.sp,
                    color: gray_color_1
                ),
                inactiveLabelStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontFamily: fontFamily,
                    fontSize: 9.sp,
                    color: gray_color_1
                ),
                tooltipTextStyle: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontFamily: fontFamily,
                    fontSize: 9.sp,
                    color: new_black_color
                ),
                tooltipBackgroundColor: hex("4B465C").shade900.withOpacity(0.3),
              ),
              child: Container(
                width: width,
                height: height,
                child: SliderTheme(
                  data: SliderTheme.of(Get.context!).copyWith(
                    overlayShape: SliderComponentShape.noThumb,
                    trackHeight: 1
                  ),
                  child: SfSlider(
                          value: value,
                          min: min,
                          max: max,
                          showTicks:showTicks,
                          showLabels:showLabels,
                          onChanged: onChanged,
                          stepSize: stepSize,
                          stepDuration: stepDuration,
                          interval: interval,
                          thumbShape: thumbShape,
                          inactiveColor: inactiveColor,
                          activeColor: activeColor,
                          dateFormat: dateFormat,
                          dateIntervalType: dateIntervalType,
                          edgeLabelPlacement: EdgeLabelPlacement.auto,
                        enableTooltip: enableTooltip,
                        numberFormat: numberFormat,
                       dividerShape: dividerShape,
                    labelFormatterCallback: labelFormatterCallback,
                    labelPlacement: labelPlacement,
                    minorTicksPerInterval: minorTicksPerInterval,
                    semanticFormatterCallback: semanticFormatterCallback,
                    overlayShape: overlayShape,
                    shouldAlwaysShowTooltip: shouldAlwaysShowTooltip,
                    showDividers: showDividers,
                    thumbIcon: thumbIcon,
                    tickShape: tickShape,
                    tooltipShape: tooltipShape,
                    tooltipTextFormatterCallback: tooltipTextFormatterCallback,
                    trackShape: trackShape,
                      ),
                ),
              ),
            ),
              ),

          ),
        ],
    ),
  );
}

class ShowIndicator extends RoundSliderThumbShape {
  final _indicatorShape = const RectangularSliderValueIndicatorShape();

  ShowIndicator();

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double value,
        required double textScaleFactor,
        required Size sizeWithOverflow,
      }) {
    super.paint(context, center,
        activationAnimation: activationAnimation,
        enableAnimation: enableAnimation,
        sliderTheme: sliderTheme,
        value: value,
        textScaleFactor: textScaleFactor,
        sizeWithOverflow: sizeWithOverflow,
        isDiscrete: isDiscrete,
        labelPainter: labelPainter,
        parentBox: parentBox,
        textDirection: textDirection);
    _indicatorShape.paint(context, center,
        activationAnimation: const AlwaysStoppedAnimation(1),
        enableAnimation: enableAnimation,
        labelPainter: labelPainter,
        parentBox: parentBox,
        value: value,
        textScaleFactor: 0.6,
        sizeWithOverflow: sizeWithOverflow,
        textDirection: textDirection,
        isDiscrete: isDiscrete,
        sliderTheme: sliderTheme);
  }
}

Widget SliderIndicator(
    {String? title,
      String? subtitle,
      int? divisions,
      required double value,
      required OnChanged onChanged,
      required double min,
      required double max,
      MaterialColor? backgroundColor,
      MaterialColor? inActiveSliderColor,
      bool? edit_option=false,

      Widget? editwidget
    }) {
  return
    // Card(
    // color: backgroundColor??WHITE,
    //   child:
      /*Material(
        elevation: 1.0,
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight:
        Radius.circular(15),bottomRight: Radius.circular(15),bottomLeft: Radius.circular(15)),
        child:*/ Container(

          decoration: BoxDecoration(
            // color: WHITE,
            // borderRadius: BorderRadius.only(topLeft: Radius.circular(cornarradius),topRight:
            // Radius.circular(cornarradius),bottomRight: Radius.circular(cornarradius),
            //     bottomLeft: Radius.circular(cornarradius)),
            // boxShadow: [fullcontainerboxShadow]
          ),
          width: Get.width,
          // padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0,left: 0,right: 0,bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 2),
                      child: Text(
                        title??"",
                        style: TextStyle(fontWeight: FontWeight.w600,fontFamily: fontFamily,fontSize: 10.sp,color: LIGHT_GREY_COLOR),
                      ),
                    ),

                 if(edit_option!) editwidget!

                    // Text(
                    //   subtitle??"",
                    //   style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12),
                    // ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 7.0,top: 3),
                child: Container(
                  // color: Colors.green,
                  child: SliderTheme(

                    data: SliderThemeData(
                      trackShape: RoundedRectSliderTrackShape(),
                      valueIndicatorShape: RectangularSliderValueIndicatorShape(),
                      valueIndicatorColor: BORDER_GREY,
                      // showValueIndicator: ShowValueIndicator.always,
                      valueIndicatorTextStyle: TextStyle(
                        color: HexColor("#4B465C"),
                        fontSize: 9,
                        fontFamily: fontFamily,
                        fontWeight: FontWeight.w600
                      ),
                      overlayShape: SliderComponentShape.noThumb,
                      trackHeight: 4.0,
                      // valueIndicatorTextStyle: TextStyle(
                      //   color: Colors.white,
                      //   decorationColor: APP_THEME_COLOR,
                      //
                      //   // backgroundColor: APP_THEME_COLOR
                      //
                      //
                      // ),
                      // valueIndicatorColor: APP_THEME_COLOR,
                      // valueIndicatorShape: SliderComponentShape.noThumb,
                      // thumbColor: Color(0xFFEB1555),
                      // thumbShape: MySliderComponentShape(),
                      // tickMarkShape: SameHeightRoundedSliderTrackShape(),
                      inactiveTrackColor: inActiveSliderColor??APP_GRAY_COLOR,
                      activeTrackColor: APP_THEME_COLOR,
                      // overlayShape: RoundSliderOverlayShape(overlayRadius: 30.0),
                      thumbColor: APP_THEME_COLOR,
                      activeTickMarkColor: INDICATOR_SLIDER_COLOR,
                      inactiveTickMarkColor: INDICATOR_SLIDER_COLOR_INACTIVE,
                      // inactiveColor: inActiveSliderColor??APP_GRAY_COLOR,
                      // trackShape: CustomTrackShape(),
                    ),
                    child: Container(
                      // width: Get.width,
                      child: Slider(
                      // activeColor: APP_THEME_COLOR,
                      // inactiveColor: inActiveSliderColor??APP_GRAY_COLOR,
                      value: value,
                      min: min,
                      max: max,

                      divisions: divisions??max.round(),
                      label: '${value.toString()}',
                      onChanged: onChanged),
                  ),
                ),
              ),
              )],
          ),
        );
      // );
  // );
}

