import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../Config/Constant.dart';
import '../../Model/Theme/WidgetThemeListClass.dart';
import '../../Model/VersionScreensModelClass/VersionModelScreen.dart';
import '../CommonHeaderController/CommenHeaderController.dart';

class LicenceController extends GetxController {
  RxList<WidgetThemeListClass> arrThemeList = RxList<WidgetThemeListClass>();
  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());
  GlobalKey<ScaffoldState> GlobalLicneceKey = GlobalKey<ScaffoldState>();
  
  //RxList Declaration
  RxList<VersionModelScreen> verisionList = RxList<VersionModelScreen>([]);

  RxString lblVersion = "".obs;

  @override
  void onInit() async{
    // TODO: implement onInit
    super.onInit();
    print(lblVersion);
    GetDependecyData();
  }

  
  GetDependecyData()async{
    verisionList=RxList([]);
    
    verisionList.add(VersionModelScreen(depencyname: "Dio",depencyversion: "4.0.6",depencydisciption: "A powerful HTTP client for Dart/Flutter, which supports global configuration, interceptors, FormData, request cancellation, file uploading/downloading, timeout, and custom adapters etc."));
    verisionList.add(VersionModelScreen(depencyname: "Shimmer",depencyversion: "2.0.0",depencydisciption: "A package provides an easy way to add shimmer effect in Flutter project"));
    verisionList.add(VersionModelScreen(depencyname: "url_launcher",depencyversion: "6.1.5",depencydisciption: "A Flutter plugin for launching a URL."));
    verisionList.add(VersionModelScreen(depencyname: "flutter_html",depencyversion: "2.2.1",depencydisciption: "This package is designed with simplicity in mind. Originally created to allow basic rendering of HTML content into the Flutter widget tree, this project has expanded to include support for basic styling as well! If you need something more robust and customizable, the package also provides a number of optional custom APIs for extremely granular control over widget rendering!"));
    verisionList.add(VersionModelScreen(depencyname: "get",depencyversion: "4.6.1",depencydisciption: "GetX is an extra-light and powerful solution for Flutter. It combines high-performance state management, intelligent dependency injection, and route management quickly and practically."));
    verisionList.add(VersionModelScreen(depencyname: "shared_preferences",depencyversion: "2.1.0",depencydisciption: "Wraps platform-specific persistent storage for simple data (NSUserDefaults on iOS and macOS, SharedPreferences on Android, etc.). Data may be persisted to disk asynchronously, and there is no guarantee that writes will be persisted to disk after returning, so this plugin must not be used for storing critical data."));
    verisionList.add(VersionModelScreen(depencyname: "flutter_svg",depencyversion: "2.1.0",depencydisciption: "This package provides a wrapper around Dart implementations of SVG parsing, including SVG path data. In particular, it provides efficient BytesLoader implementations for package:vector_graphics. This package is easier to use but not as performant as using the vector_graphics and vector_graphics_compiler packages directly. Those packages allow you to do ahead-of-time compilation and optimization of SVGs, and offer some more performant rasterization strategies at runtime."));
    verisionList.add(VersionModelScreen(depencyname: "google_maps_flutter",depencyversion: "2.0.6",depencydisciption: "Enable Google Map SDK for each platform"));

    verisionList.add(VersionModelScreen(depencyname: "percent_indicator",depencyversion: "3.0.1",depencydisciption: "Library that allows you to display progress widgets based on percentage, can be Circular or Linear, you can also customize it to your needs."));
    verisionList.add(VersionModelScreen(depencyname: "flutter_local_notifications",depencyversion: "9.2.0",depencydisciption: "A cross platform plugin for displaying and scheduling local notifications for Flutter applications with the ability to customise for each platform."));
    verisionList.add(VersionModelScreen(depencyname: "path_provider",depencyversion: "2.0.10",depencydisciption: "A Flutter plugin for finding commonly used locations on the filesystem. Supports Android, iOS, Linux, macOS and Windows."));
    verisionList.add(VersionModelScreen(depencyname: "firebase_messaging",depencyversion: "11.2.5",depencydisciption: "Flutter plugin for Firebase Cloud Messaging, a cross-platform messaging solution that lets you reliably deliver messages on Android and iOS."));
    verisionList.add(VersionModelScreen(depencyname: "cached_network_image",depencyversion: "3.2.3",depencydisciption: "A flutter library to show images from the internet and keep them in the cache directory."));

  }
}