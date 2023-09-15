import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info/package_info.dart';
import 'package:Repeople/Config/Helper/ApiResponse.dart';
import 'package:Repeople/Config/Helper/MoengageAnalyticsHandler.dart';
import 'package:Repeople/Config/Helper/SessionData.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constant.dart';



class DeviceData {
final  FirebaseMessaging? firebaseMessaging= FirebaseMessaging.instance;
  int isforcefully = 0, isforcelogout = 0;

  String updateAppMsg = "";

  AppUpdateInfo? _updateInfo;
  bool _flexibleUpdateAvailable = false;

  DeviceData();

  //<editor-fold desc = "Send Device Data">

  Future<Map<String, dynamic>> getDeviceData() async {
    Map<String, dynamic> deviceData = <String, dynamic>{};

    String os = "";
    String deviceModelName = "";
    String macAddress = "";
    String deviceID = "";
    String osVersion = "";
    String appVersion = "";

    try {
      FirebaseMessaging.instance.requestPermission();
      await firebaseMessaging!.getToken(vapidKey: "").then((value) {
        deviceID = value!;
        print('deviceId = $deviceID');
      });

      firebaseMessaging!.onTokenRefresh.listen((event) {
        print('Token: $event');
      });

      // await firebaseMessaging!.getAPNSToken().then((value){
      //   deviceID = value!;
      //   print('deviceId = $deviceID' );
      // });
      MoengageAnalyticsHandler moengageAnalyticsHandler=MoengageAnalyticsHandler();
      moengageAnalyticsHandler.setFCMToken(deviceID);
      PackageInfo info = await PackageInfo.fromPlatform();
      appVersion = info.version;

      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        os = "ios";
        // deviceID = iosInf
        osVersion = iosInfo.systemVersion;
        deviceModelName = iosInfo.model;
        macAddress = iosInfo.identifierForVendor!;
      } else if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        // deviceID = androidInfo.id!;
        os = "android";
        osVersion = androidInfo.version.release;
        deviceModelName = androidInfo.model!;
        macAddress = androidInfo.id!;
      }
    } catch (e) {
      print(e);
    }
    // deviceData['action'] = 'insertdevice';
    // deviceData['formevent'] = 'addright';
    deviceData['appversion'] = appVersion;
    deviceData['devicemodelname'] = deviceModelName;
    deviceData['macaddress'] = macAddress;
    deviceData['deviceid'] = deviceID;
    deviceData['os'] = os;
    deviceData['osversion'] = osVersion;
    //for this particular app
   // deviceData['device_id'] = deviceModelName+"_"+macAddress;

    return deviceData;
  }

  Future<void> SendDeviceData() async {
    Map<String, dynamic> data = await getDeviceData();

    var data1 = {
      "action": 'insertdevice',
      "formevent": 'addright',
    };

    data.addAll(data1);

    Map<String, String> headers = {};
    headers['userpagename'] = APPDEVICE_APPMENUNAME;
    headers['useraction'] = 'addright';
    headers['masterlisting'] = 'false';

    print("------$data-----");

    ApiResponse response = ApiResponse(
        data: data,
        base_url:"" /*URL_DEVICE*/,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers);
    Map<String, dynamic>? responseData = await response.getResponse();
    print("insertdevice $responseData");

    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setDouble(SESSION_CREDIT, responseData!['credit'].toDouble());
    sp.setString(SESSION_DISCREDIT, responseData['dis_credit']);
    sp.setDouble(SESSION_POINTS, responseData['points'].toDouble());
    sp.setString(SESSION_DISPOINTS, responseData['dis_points']);

    if (responseData['status'] == 1) {
      print(responseData['message']);
    } else if (responseData['status'] == 3) {
      updateAppMsg = responseData['message'];
      isforcefully = responseData['isforcefully'];
      isforcelogout = responseData['isforcelogout'];

      InAppUpdateDialog();
    } else {
      print(responseData['message']);
    }
  }

  InAppUpdateDialog() async {
    if (!await getIsUpdateNotNow()) {
      if (Platform.isAndroid) {

        InAppUpdate.checkForUpdate().then((info) {
          print("*****************************");
          _updateInfo = info;
          print("_updateInfo $_updateInfo");
          if (Platform.isAndroid) {
            if (isforcefully == 1 && isforcelogout == 1) {
              //LogoutServie(Get.context!);
            }
            if (isforcefully == 0) {
              FlexibleUpdate();
            } else {
              ImmediateUpdate();
            }
          }
        }).catchError((e) {
          print(e.toString());
        });
      } else {
        //showAlertDialog(isforcefully, isforcelogout, updateAppMsg);
      }
    }
  }

  ImmediateUpdate() {
    _updateInfo!.updateAvailability == UpdateAvailability.updateAvailable
        ? InAppUpdate.performImmediateUpdate().then((result) {
            print("RESULT ******* $result");
            if (result == AppUpdateResult.success) {
              print("Success ImmediateUpdate");
            } else if (result == AppUpdateResult.userDeniedUpdate) {
              print("Denied ImmediateUpdate");
              InAppUpdateDialog();
            } else if (result == AppUpdateResult.inAppUpdateFailed) {
              print("Failed ImmediateUpdate");
            }
          }).catchError((e) {
            print("ImmediateUpdate ERROR***** ${e.toString()}");
          })
        : null;
  }

  FlexibleUpdate() {
    _updateInfo!.updateAvailability == UpdateAvailability.updateAvailable
        ? InAppUpdate.startFlexibleUpdate().then((result) {
            print("RESULT ******* $result");
            if (result == AppUpdateResult.success) {
              print("Success FlexibleUpdate");
            } else if (result == AppUpdateResult.userDeniedUpdate) {
              print("Denied FlexibleUpdate");
              StoreIsUpdateNotNowSessionData(true);
              // ImmediateUpdate();
            } else if (result == AppUpdateResult.inAppUpdateFailed) {
              print("Failed FlexibleUpdate");
            }
            InAppUpdate.completeFlexibleUpdate().then((_) {
              print("Success!*************************");
            }).catchError((e) {
              print(e.toString());
            });
          }).catchError((e) {
            print("FlexibleUpdate ERROR***** ${e.toString()}");
          })
        : null;
  }

//</editor-fold>
//
//   void showAlertDialog(int forceUpdate, int forceLogout, String message) {
//     showDialog(
//       context: Get.context!,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return WillPopScope(
//           onWillPop: () async {
//             return false;
//           },
//           child: SimpleDialog(
//             backgroundColor: AppColors.TRANSPARENT,
//             children: [
//               Container(
//                 width: Get.width,
//                 padding: EdgeInsets.only(top: 20.w, bottom: 10.w, left: 10.w, right: 10.w),
//                 // height: Get.height ,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.rectangle,
//                   color: AppColors.APP_THEME_COLOR,
//                   borderRadius: BorderRadius.all(Radius.circular(20)),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: <Widget>[
//                     ClipRRect(
//                       child: Image.asset(
//                         APP_UPDATE,
//                         height: 80.w,
//                         width: 80.w,
//                       ),
//                     ),
//                     SizedBox(
//                       height: 10.w,
//                     ),
//                     Text(
//                       "New Update Available",
//                       style: TextStyle(
//                           color: AppColors.WHITE, fontSize: 18.0, fontWeight: FontWeight.w700),
//                       textAlign: TextAlign.center,
//                     ),
//                     SizedBox(
//                       height: 10.w,
//                     ),
//                     Text(
//                       message,
//                       style: TextStyle(
//                         color: AppColors.WHITE.withOpacity(0.7),
//                         fontSize: 14.0,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     SizedBox(
//                       height: 25.w,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         if (forceUpdate == 0)
//                           Expanded(
//                             child: CustomButtons.WidgetButton(
//                                 onTap: () {
//                                   StoreIsUpdateNotNowSessionData(true);
//                                   Get.back();
//                                 },
//                                 child: Text(
//                                   "Later",
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                       color: AppColors.WHITE,
//                                       fontSize: 13.sp,
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                                 // height: Get.height,
//                                 // width: Get.width,
//                                 border: Border.all(color: AppColors.APP_THEME_DARK_COLOR, width: 3),
//                                 shadowColor: Colors.white12,
//                                 bgColor: AppColors.APP_THEME_COLOR,
//                                 padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
//                                 margin: EdgeInsets.only(left: 5, right: 5),
//                                 radius: 30),
//                           ),
//                         Expanded(
//                           child: CustomButtons.WidgetButton(
//                               onTap: () {
//                                 if (forceUpdate == 1 && forceLogout == 1) {
//                                   LogoutServie(Get.context!);
//                                   onUpdate();
//                                 } else {
//                                   onUpdate();
//                                 }
//                               },
//                               child: Text(
//                                 "Update Now",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                     color: AppColors.WHITE,
//                                     fontSize: 13.sp,
//                                     fontWeight: FontWeight.w600),
//                               ),
//                               // height: Get.height,
//                               // width: Get.width,
//                               border: Border.all(color: AppColors.APP_THEME_DARK_COLOR, width: 3),
//                               shadowColor: Colors.white12,
//                               bgColor: AppColors.BLUE,
//                               padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
//                               margin: EdgeInsets.only(left: 5, right: 5),
//                               radius: 30),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               )
//             ],
//           ),
//         );
//       },
//     );
//   }

  onUpdate() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    String appID = info.packageName;
    String url = "";
    if (Platform.isIOS) {
      url =
          // 'https://apps.apple.com/in/app/bike-outliner/id1588292384?mt=12';
          // 'https://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftwareUpdate?id=$appID&mt=8';
      'https://apps.apple.com/in/app/brikkin-agent/id1626597523';
    } else if (Platform.isAndroid) {
      url = 'https://play.google.com/store/apps/details?id=$appID';
    }

    //await LunchUrl(url);
  }
}
