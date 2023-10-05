import 'dart:async';

import 'package:Repeople/Config/Helper/ControllerBinding.dart';
import 'package:Repeople/View/SplashScreen/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:moengage_flutter/model/inapp/click_data.dart';
import 'package:moengage_flutter/model/inapp/inapp_data.dart';
import 'package:moengage_flutter/model/inapp/self_handled_data.dart';
import 'package:moengage_flutter/model/moe_init_config.dart';
import 'package:moengage_flutter/model/permission_result.dart';
import 'package:moengage_flutter/model/push/push_campaign_data.dart';
import 'package:moengage_flutter/model/push/push_config.dart';
import 'package:moengage_flutter/model/push/push_token_data.dart';
import 'package:moengage_flutter/moengage_flutter.dart';
import 'package:Repeople/Config/Helper/MoengageAnalyticsHandler.dart';
import 'package:Repeople/Config/Helper/NotificationHandler.dart';
import 'package:Repeople/Config/Helper/shared_prefrence.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';
import 'Config/Constant.dart';
import 'Config/Helper/NotificationListManager.dart';
import 'Config/Helper/utils.dart';
import 'Config/utils/colors.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

Future<void> myBackgroundHandler(RemoteMessage message) async {
  print(
      "-----------------------------------onBackgroundMessage--------------------------------------");

  try {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var count = sp.getInt(NOTIFICATION_COUNT);
    print(count);
    print(message.data);
    isbadgeshow.value=true;
    isbadgeshow.refresh();
    NotificationCountHandler(message.data['n_id'] ?? "");
  }
  catch (e,s) {
    print(s);
  }

}
const tag = "MoeRepeople_";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
  // SystemChrome.setSystemUIOverlayStyle(
  // const SystemUiOverlayStyle(statusBarColor: Colors.white)
  // );
  await UserSimplePreference.init();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  initlizeLink();
  runApp(MyApp());
  FlutterError.onError = (flutterdetails)=>FirebaseCrashlytics.instance.recordFlutterError(flutterdetails);
  //FirebaseCrashlytics.instance.crash();
}

bool? isLogin;
StreamSubscription? stream;

Future<void> initlizeLink() async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  isLogin = sp.getBool(ISLOGIN) ?? false;

  // isLogin = sp.getBool(ISLOGIN) ?? false;

  String event;
  stream = linkStream.listen((eventtemp) async {
    print("event ==================== $eventtemp");
    if (eventtemp != "" && eventtemp != null) {
      event = eventtemp;
      callLinkOpen(event);
      print(eventtemp);
    }
  });
}

class MyApp extends StatefulWidget {
  String? title;
  MyApp({Key? key,this.title = "repeople"}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{
  MoengageAnalyticsHandler moengageAnalyticsHandler = MoengageAnalyticsHandler();
  // FirebaseMessaging _firebaseMessaging;
  final MoEngageFlutter moengagePlugin = MoEngageFlutter(MOENGAGE_APP_ID);


  final MoEngageFlutter _moengagePlugin = MoEngageFlutter(
      MOENGAGE_APP_ID,
      moEInitConfig: MoEInitConfig(
          pushConfig: PushConfig(
              shouldDeliverCallbackOnForegroundClick: true)
      ));


  void _onPushClick(PushCampaignData message) {
    debugPrint(
        "$tag Main : _onPushClick(): This is a push click callback from native to flutter. Payload $message");
  }

  void _onInAppClick(ClickData message) {
    debugPrint(
        "$tag Main : _onInAppClick() : This is a inapp click callback from native to flutter. Payload $message");
  }

  void _onInAppShown(InAppData message) {
    debugPrint(
        "$tag Main : _onInAppShown() : This is a callback on inapp shown from native to flutter. Payload $message");
  }

  void _onInAppDismiss(InAppData message) {
    debugPrint(
        "$tag Main : _onInAppDismiss() : This is a callback on inapp dismiss from native to flutter. Payload $message");
  }

  void _onInAppSelfHandle(SelfHandledCampaignData message)async{
    debugPrint(
        "$tag Main : _onInAppSelfHandle() : This is a callback on inapp self handle from native to flutter. Payload $message");

  }

  void _onPushTokenGenerated(PushTokenData pushToken) {
    debugPrint(
        "$tag Main : _onPushTokenGenerated() : This is callback on push token generated from native to flutter: PushToken: $pushToken");
  }

  void _permissionCallbackHandler(PermissionResultData data) {
    debugPrint("$tag Permission Result: $data");
  }
  @override
  void initState() {
    super.initState();
    moengagePlugin.setPushClickCallbackHandler(_onPushClick);
    moengageAnalyticsHandler.initMoengage();

  }
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: ControllerBinding(),
      title: APP_NAME,
      color: white,
      defaultGlobalState: true,
      debugShowCheckedModeBanner: false,
      themeMode:ThemeMode.light ,
      home: const SplashScreen(),
      builder: (context, child) {
        final mediaQueryData = MediaQuery.of(context);
        final scale = mediaQueryData.textScaleFactor.clamp(1.0, 1.0);
        return MediaQuery(
          data: mediaQueryData.copyWith(textScaleFactor: scale),
          child: child!,
        );
      },
      theme: ThemeData(
        primaryColor: APP_THEME_COLOR,
        fontFamily: 'Montserrat',
        primarySwatch: APP_FONT_COLOR,
        appBarTheme: AppBarTheme(
          color: white,
          centerTitle: true,
        ),
      ),
    );
  }
}


