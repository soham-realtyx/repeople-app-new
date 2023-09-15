import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moengage_flutter/moengage_flutter.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Helper/MoengageAnalyticsHandler.dart';
import 'package:Repeople/Config/Helper/NotificationHandler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Repeople/Config/Helper/shared_prefrence.dart';
import 'package:uni_links/uni_links.dart';



import 'Config/Helper/NotificationListManager.dart';
import 'app_config.dart';
import 'main.dart';

Future<void> myBackgroundHandler(RemoteMessage message) async {
  print("-----------------------------------onBackgroundMessageDev--------------------------------------");
  try {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var count = sp.getInt(NOTIFICATION_COUNT);
    isbadgeshow.value=true;
    isbadgeshow.refresh();
    print(count);
    print(message.data);
    NotificationCountHandler(message.data['n_id'] ?? "");
  } catch (e, s) {

  }

  // setNotificationCount(count!+1);
}

bool? isLogin;
StreamSubscription? stream;

Future<void> initlizeLink() async {
  // print("reached");
  SharedPreferences sp = await SharedPreferences.getInstance();
  isLogin = sp.getBool(ISLOGIN) ?? false;

  var event;
  stream = linkStream.listen((eventtemp) async {

    if (eventtemp != "" && eventtemp != null) {
      event = eventtemp;
      callLinkOpen(event);
      // stream?.cancel();
    }
  });
}



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await UserSimplePreference.init();
  NotificationHandler notificationHandler = NotificationHandler();
  FirebaseMessaging.onBackgroundMessage(myBackgroundHandler);
  FirebaseMessaging.onMessageOpenedApp.listen(notificationHandler.onMessageOpenApp);
  FirebaseMessaging.onMessage.listen(notificationHandler.onMessage);

  MoengageAnalyticsHandler moengageAnalyticsHandler = MoengageAnalyticsHandler();
  moengageAnalyticsHandler.initMoengage();
  final MoEngageFlutter moengagePlugin = MoEngageFlutter(MOENGAGE_APP_ID);
  moengagePlugin.setPushClickCallbackHandler(moengageAnalyticsHandler.onPushClick);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  initlizeLink();
  runApp(MyApp());
  FlutterError.onError = (flutterdetails)=>FirebaseCrashlytics.instance.recordFlutterError(flutterdetails);
  //FirebaseCrashlytics.instance.crash();
  // 1
  AppConfig configuredApp = AppConfig(
    child: MyApp(title: "Dev repeople"),
    // 2
    environment: Environment.dev,
    // 3
    appTitle: 'Dev repeople',
  );
  // 4
  runApp(configuredApp);
}
