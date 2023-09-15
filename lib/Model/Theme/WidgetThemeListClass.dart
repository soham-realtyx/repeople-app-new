import 'package:flutter/material.dart';
import 'package:Repeople/Model/News/NewsModal.dart';


// For Widget Identity

class WidgetThemeListClass{
  String themename;
  Widget widget;
  WidgetThemeListClass(this.themename,
      this.widget);
}
typedef Widget WidgetPageTitle(String title);
class WidgetThemeListClassWithTitle{
  String themename;
  WidgetPageTitle widget;
  WidgetThemeListClassWithTitle(this.themename,this.widget);
}

// For common header

typedef Widget WidgetTitle(String title , GlobalKey<ScaffoldState> scaffoldKey);  // this title call back function


class WidgetAppbarThemeListClass{
  String themename;
  bool? showsearch;
  WidgetTitle widget;

  WidgetAppbarThemeListClass(this.themename,this.widget, {this.showsearch=false});
}


// For news Details page

// typedef Widget WidgetDetails(NewsListClass newsObj); // call back for object
typedef Widget WidgetDetails(NewsListModal newsObj); // call back for object

class WidgetNewsDetailsThemeListClass{
  String? themename;
  WidgetDetails? widget;

  WidgetNewsDetailsThemeListClass(this.themename,this.widget);
}

// For Nodatafound page

typedef Widget WidgetChild(Widget widget); // call back for object;

class WidgetNoDataFoundTheme{
  String? themeName;
  WidgetChild widget;

  WidgetNoDataFoundTheme(this.themeName,this.widget);
}



