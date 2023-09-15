import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moengage_flutter/moengage_flutter.dart';
import 'package:Repeople/Config/Helper/MoengageAnalyticsHandler.dart';
import 'package:Repeople/Config/Helper/NotificationHandler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Repeople/Config/Helper/shared_prefrence.dart';
import 'package:uni_links/uni_links.dart';

import 'Config/Constant.dart';

import 'Config/Helper/NotificationListManager.dart';
import 'app_config.dart';
import 'main.dart';

Future<void> myBackgroundHandler(RemoteMessage message) async {
  print(
      "-----------------------------------onBackgroundMessageProd--------------------------------------");

  try {
    // SharedPreferences.setMockInitialValues({});
    SharedPreferences sp = await SharedPreferences.getInstance();

    var count = sp.getInt(NOTIFICATION_COUNT);
    print(count);
    print(message.data);
    NotificationCountHandler(message.data['n_id'] ?? "");
    isbadgeshow.value=true;
    isbadgeshow.refresh();
    print("message.data[n_id] ${message.data["n_id"]}");
    // GetUpdateAttendingStatus(message.data["n_id"]);
  } catch (e, s) {
    print(s);
  }

  // setNotificationCount(count!+1);
}

bool? isLogin;
StreamSubscription? stream;

Future<void> initlizeLink() async {

  SharedPreferences sp = await SharedPreferences.getInstance();
  isLogin = sp.getBool(ISLOGIN) ?? false;
 // isLogin = sp.getBool(ISLOGIN) ?? false;

  var event;
  stream = linkStream.listen((eventtemp) async {
    print("event ==================== $eventtemp");
    if (eventtemp != "" && eventtemp != null) {
      event = eventtemp;
      callLinkOpen(event);

      // stream?.cancel();
    }
  });
}

void main() async {
  print("MY PROD App");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await UserSimplePreference.init();

  MoengageAnalyticsHandler moengageAnalyticsHandler = MoengageAnalyticsHandler();
  moengageAnalyticsHandler.initMoengage();
  final MoEngageFlutter moengagePlugin = MoEngageFlutter(MOENGAGE_APP_ID);
  moengagePlugin.setPushClickCallbackHandler(moengageAnalyticsHandler.onPushClick);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  NotificationHandler notificationHandler = NotificationHandler();
  FirebaseMessaging.onBackgroundMessage(myBackgroundHandler);
  FirebaseMessaging.onMessageOpenedApp.listen(notificationHandler.onMessageOpenApp);
  FirebaseMessaging.onMessage.listen(notificationHandler.onMessage);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  initlizeLink();
  runApp(MyApp());
  FlutterError.onError = (flutterdetails)=>FirebaseCrashlytics.instance.recordFlutterError(flutterdetails);


  AppConfig configuredApp = AppConfig(
    child: MyApp(title: "Repeople"),
    // 1
    environment: Environment.prod,
    // 2
    appTitle: 'Repeople',
  );
  runApp(configuredApp);
}
