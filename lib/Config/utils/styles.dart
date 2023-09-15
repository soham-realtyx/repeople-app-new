import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:Repeople/Config/Helper/HextoColor.dart';
import 'package:Repeople/Config/utils/colors.dart';

String fontFamily = "Montserrat";

TextStyle lightTextStyle({int fontSize = 14, Color? txtColor}) => TextStyle(
    fontSize: fontSize.sp,
    color: txtColor ?? AppColors.BLACK,
    fontWeight: FontWeight.w300,
    fontFamily: fontFamily);

TextStyle regularTextStyle(
        {int fontSize = 14, Color? txtColor, FontWeight? fontWeight}) =>
    TextStyle(
        fontSize: fontSize.sp,
        color: txtColor ?? AppColors.BLACK,
        fontFamily: fontFamily,
        fontWeight: fontWeight);

TextStyle mediumTextStyle({int fontSize = 14, Color? txtColor,FontWeight? fontWeight}) => TextStyle(
    fontSize: fontSize.sp,
    color: txtColor ?? AppColors.BLACK,
    fontWeight: fontWeight??FontWeight.w500,
    fontFamily: fontFamily);

TextStyle semiBoldTextStyle({int fontSize = 14, Color? txtColor,FontWeight? fontWeight}) => TextStyle(
      fontSize: fontSize.sp,
      color: txtColor ?? AppColors.BLACK,
      fontWeight: fontWeight??FontWeight.w600,
      fontFamily: fontFamily,
    );

TextStyle boldTextStyle({int fontSize = 14, Color? txtColor,FontWeight? fontWeight}) => TextStyle(
    fontSize: fontSize.sp,
    color: txtColor ?? AppColors.BLACK,
    fontWeight: fontWeight??FontWeight.w700,
    fontFamily: fontFamily);

TextStyle extraBoldTextStyle({int fontSize = 14, Color? txtColor,FontWeight? fontWeight}) => TextStyle(
    fontSize: fontSize.sp,
    color: txtColor ?? AppColors.BLACK,
    fontWeight: fontWeight??FontWeight.w800,
    fontFamily: fontFamily);

TextStyle ParagraphTextStyle({int fontSize = 13, Color? txtColor,}) => TextStyle(
    fontSize: fontSize.sp,
    color: txtColor ?? gray_color_2,
    fontFamily: fontFamily,
    height: 1.5);

BoxShadow fullcontainerboxShadow = BoxShadow(
    color: hex("266CB5").withOpacity(0.03),
    blurRadius: 4,
    offset: Offset(0, 0),
    spreadRadius: 4);
BoxShadow newcontainerboxShadow = BoxShadow(
    color: BLACK.withOpacity(0.03),
    blurRadius: 6,
    offset: Offset(0, 3),
    spreadRadius: 0);

BoxShadow smallcontainerboxShadow = BoxShadow(
    color: Colors.black.withOpacity(0.03),
    blurRadius: 4,
    offset: Offset(0, 6),
    spreadRadius: 2);
BoxShadow ExploreMOreboxShadow = BoxShadow(
    color: HexColor("#000000").withOpacity(0.9),
    blurRadius: 6,
    offset: Offset(2, 8),
    spreadRadius: 0);
