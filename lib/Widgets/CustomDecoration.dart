import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Repeople/Config/Helper/HextoColor.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Config/utils/styles.dart';

import '../Config/utils/Images.dart';

class CustomDecorations {
  BoxDecoration background(String bgcolor,double radius,double width,String bordercolor){
    return BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
        border: Border.all(
            color:HexColor(bordercolor) ,
            width: width),
        color: HexColor(bgcolor)
    );
  }
  BoxDecoration exploreMoreBackground(String bgcolor,double radius,double width,String bordercolor){
    return BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        boxShadow: [smallcontainerboxShadow],
        border: Border.all(
            color:HexColor(bordercolor) ,
            width: width),
        color: HexColor(bgcolor)
    );
  }
  BoxDecoration backgroundlocal(MaterialColor bgcolor,double radius,double width,MaterialColor bordercolor){
    return BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        border: Border.all(
            color:bordercolor,
            width: width),
        color: bgcolor,
      boxShadow: [
        fullcontainerboxShadow
      ]
    );
  }

  BoxDecoration backgroundwithoutborder(MaterialColor bgcolor,double radius,double width){
    return BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        // border: Border.all(
        //     // color:bordercolor,
        //     width: width),
        color: bgcolor
    );
  }

  BoxDecoration backgroundwithshadow(
      MaterialColor bgcolor,double radius,double width,MaterialColor bordercolor){
    return BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        boxShadow: [smallcontainerboxShadow],
        border: Border.all(
            color:bordercolor,
            width: width),
        color: bgcolor
    );
  }


}

class CommanContainer{
  static Container arrowContainer(MaterialColor bgcolor,MaterialColor iconcolor,double? radius){
    return Container(
      height: 30,
      width: 30,
        padding: const EdgeInsets.all(8),
      decoration:
      CustomDecorations().backgroundlocal(bgcolor, radius??10, 0, bgcolor),
      child:
        SvgPicture.asset(IMG_RIGHTARROW_SVG_NEW,color: white,)
    );
  }
}



