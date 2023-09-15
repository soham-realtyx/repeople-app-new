import 'package:flutter/material.dart';
import 'package:Repeople/Config/utils/colors.dart';

typedef void OnTap();

class CustomButtons {
  static Widget RoundIconButton(
      {Color bgColor = Colors.white,
      double radius = 10,
      double? height,
      double? width,
      String? image,
      Color? imgColor,
      bool boxShadow = true,
      Color shadowColor = Colors.black26,
      OnTap? onTap,
      double imgSize = 25}) {
    return InkWell(
        splashColor: AppColors.TRANSPARENT,
        hoverColor: AppColors.TRANSPARENT,
        focusColor: AppColors.TRANSPARENT,
        onTap: onTap,
        child: Material(
          color: AppColors.TRANSPARENT,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                color: bgColor,
                boxShadow: boxShadow
                    ? [
                        BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 1,
                            offset: Offset(0,1),
                            spreadRadius: 1
                        )
                      ]
                    : []),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                  child: Image.asset(
                image!,
                color: imgColor,
                height: imgSize,
                width: imgSize,
                fit: BoxFit.fill,
              )),
            ),
          ),
        ));
  }

  static Widget WidgetButton(
      {Color bgColor = Colors.white,
      double radius = 10,
      double? height,
      double? width,
      bool boxShadow = true,
      Color shadowColor = Colors.black26,
      OnTap? onTap,
      required Widget child}) {
    return InkWell(
        splashColor: AppColors.TRANSPARENT,
        hoverColor: AppColors.TRANSPARENT,
        focusColor: AppColors.TRANSPARENT,
        onTap: onTap,
        child: Container(
          width: width,
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              color: bgColor,
              boxShadow: boxShadow
                  ? [
                      BoxShadow(
                        color: shadowColor,
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 1),
                      )
                    ]
                  : []),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: child),
          ),
        ));
  }

  static Widget BorderWidgetButton(
      {Color bgColor = Colors.white,
      double radius = 10,
      double? height,
      double? width,
      Color? borderColor = Colors.black,
      double borderWidth = 1,
      bool boxShadow = true,
      Color shadowColor = Colors.black26,
      OnTap? onTap,
      required Widget child}) {
    return InkWell(
        splashColor: AppColors.TRANSPARENT,
        hoverColor: AppColors.TRANSPARENT,
        focusColor: AppColors.TRANSPARENT,
        onTap: onTap,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              color: bgColor,
              border: Border.all(
                color: borderColor!,
                width: borderWidth
              ),
              boxShadow: boxShadow
                  ? [
                      BoxShadow(
                        color: shadowColor,
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 1),
                      )
                    ]
                  : []),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: child),
          ),
        ));
  }
}
