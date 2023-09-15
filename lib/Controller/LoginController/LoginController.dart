
import 'dart:async';
import 'dart:convert';
import 'package:Repeople/Controller/MenuClickHandlerController/MenuClickHandler.dart';
import 'package:Repeople/View/DashboardPage/DashboardPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Helper/MoengageAnalyticsHandler.dart';
import 'package:Repeople/Config/Helper/shared_prefrence.dart';
import 'package:Repeople/Model/Theme/WidgetThemeListClass.dart';
import 'package:Repeople/View/OTPPage/OTPPage.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:Repeople/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Config/Helper/ApiResponse.dart';
import '../../Widgets/CommomBottomSheet.dart';

import '../../Widgets/Loader.dart';
import '../../Widgets/TextEditField.dart';
import '../CommonHeaderController/CommenHeaderController.dart';

class LoginController extends GetxController {
  RxList<WidgetThemeListClass> arrThemeList = RxList<WidgetThemeListClass>();

  var formKeys = GlobalKey<FormState>();
  bool isSendVerify = false;

  int levelClock = 60;
  late OTPInteractor _otpInteractor;
  RxBool isOtpFieldShown = false.obs;
  Rx<Duration> duration = Duration().obs; // for timer
  Timer? timer;
  final mcnTxt = Get.context;
  RxBool timerIsActive = true.obs;
  
  RxInt isUser=0.obs;
  
  FocusNode mobileFocusNode = FocusNode();
  FocusNode referFocusNode = FocusNode();
  FocusNode otpFocusNode = FocusNode();
  CommonHeaderController cntCommonHeader = Get.put(CommonHeaderController());
  GlobalKey<ScaffoldState> globalLOginPageKey = GlobalKey<ScaffoldState>();

  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtContact = TextEditingController();
  TextEditingController txtProject = TextEditingController();
  TextEditingController txtBudget = TextEditingController();
  TextEditingController txtScheduleDate = TextEditingController();
  TextEditingController txtScheduleTime = TextEditingController();
  TextEditingController txtQuery = TextEditingController();
  OTPTextEditController? txtOtp = OTPTextEditController(codeLength: 6);
  OTPTextEditController? txtOtp1 = OTPTextEditController(codeLength: 6);
  Rxn<TextEditingController> txtContactNew = Rxn(TextEditingController());

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    isocode1.value = "";
    isocode1.obs;
    // isocode="";
    txtContact.clear();
    txtContactNew.value?.clear();
    ccode = "";
    //Get.delete<DashboardController>();
  }


  void startTimer() {
    duration.value = const Duration(seconds: 60);
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void addTime() {
    const addSeconds = -1;
    final seconds = duration.value.inSeconds + addSeconds;
    if (seconds < 0) {
      timerIsActive.value = false;
      timer?.cancel();
    } else {
      duration.value = Duration(seconds: seconds);
    }
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    // final hours=twoDigits(duration.inHours.remainder(60));
    final minutes = twoDigits(duration.value.inMinutes.remainder(60));
    final seconds = twoDigits(duration.value.inSeconds.remainder(60));

    return Text('$minutes:$seconds',
        style: const TextStyle(fontSize: 12, color: Colors.black)
        // boldTextStyle(fontSize: 12,
        //     txtColor: AppColors.TEXT_FIELD_COLOR),
        );
    // return Text('${duration.inSeconds}',style: TextStyle(color: Colors.white,fontSize: 18,fontFamily: poppins_regular),);
  }

  customListener() {
    try {
      _otpInteractor = OTPInteractor();
      _otpInteractor
          .getAppSignature()
          //ignore: avoid_print
          .then((value) => print('signature - $value'));
      txtOtp1 = OTPTextEditController(
        codeLength: 6,
        //ignore: avoid_print
        onCodeReceive: (code) {
          print('Your Application receive code - $code');
          txtOtp!.clear();
          txtOtp!.text = txtOtp1!.text;
          verifyOtp();
        },
        otpInteractor: _otpInteractor,
      )..startListenUserConsent(
          (code) {
            final exp = RegExp(r'(\d{4})');
            return exp.stringMatch(code ?? '') ?? '';
            if (code?.length == 4) {
              // Verify_otp();
            }
          },
          strategies: [],
        );
    } catch (e) {
      print(e);
    }
  }

  sendOtp() async {
    try {
      appLoader(contextCommon);
      Map<String, dynamic> data = {};
      data['action'] = 'sendotp';
      data['mobileno'] = txtContactNew.value?.text.toString();
      data['countrycodeid'] = "+91";
      data['countrycodestr'] = "IN";
      // data['type'] = LOGIN_TYPE;
      print(" send otp * + * +* + *+ *+ $data");
      ApiResponse response = ApiResponse(
          data: data,
          base_url: URL_LOGIN,
          apiKey: API_CONSTKEY,
          apiHeaderType: ApiHeaderType.Login);
      Map<String, dynamic>? responseData = await response.getResponse();
      if (responseData!['status'] == 1) {
        isUser.value=responseData['newuser'];
        removeAppLoader(contextCommon);
        MoengageAnalyticsHandler().track_event("otp_page");
        Get.to(OTPPage(mobileNo: txtContactNew.value?.text.toString(),isUser: isUser.value,));
        SuccessMsg(responseData['message']);
          customListener();
          startTimer();
      } else {
        removeAppLoader(contextCommon);
        validationMsg(responseData['message']);
      }
    } catch (error) {
      removeAppLoader(contextCommon);
      print(error);
    }
  }

  reSendOtp() async {
    try {
      appLoader(contextCommon);
      Map<String, dynamic> data = {};
      data['action'] = 'resendotp';
      data['mobileno'] = txtContactNew.value?.text.toString();
      data['countrycodeid'] = "+91";
      data['countrycodestr'] = "in";
      data['type'] = LOGIN_TYPE;
      print(" * + * +* + *+ *+ $data");
      ApiResponse response = ApiResponse(
          data: data,
          base_url: URL_LOGIN,
          apiKey: API_CONSTKEY,
          apiHeaderType: ApiHeaderType.Login);
      print(data);
      Map<String, dynamic>? responseData = await response.getResponse();
      if (responseData!['status'] == 1) {
        removeAppLoader(contextCommon);
        SuccessMsg(responseData['message']);
        print(responseData['message']);
        customListener();
        Future.delayed(const Duration(seconds: HIDEDURATION + 1)).then((value) {
          FocusScope.of(mcnTxt!).requestFocus(otpFocusNode);
          otpFocusNode.requestFocus();
          startTimer();
        });
      } else {
        removeAppLoader(contextCommon);
        validationMsg(responseData['message']);
        print(responseData['message']);
      }
    } catch (error) {
      removeAppLoader(contextCommon);
      print(error);
    }
  }

  verifyOtp() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      appLoader(contextCommon);
      Map<String, dynamic> data = {};
      data['action'] = 'verifyotp';
      data['mobileno'] = txtContactNew.value?.text.toString();
      data['otp'] = txtOtp!.text.toString();
      data['type'] = LOGIN_TYPE;
      //data['referralcode']="";
      Map<String, dynamic> data1 = await deviceData.getDeviceData();
      data.addAll(data1);
      print(" * + * +* + *+ *+ $data");
      ApiResponse response = ApiResponse(
          data: data, base_url: URL_LOGIN, apiHeaderType: ApiHeaderType.Login);
      Map<String, dynamic>? responseData = await response.getResponse();
      debugPrint("${responseData}my response data");
      print("${responseData}my response data");
      if (responseData!['status'] == 1) {

        sp.setString(REPEOPLE_CUSTOMER_CREDENTIAL, json.encode(responseData));

        storeCustomerLoginSessionData(responseData).then((value) {
          try{

            MoengageAnalyticsHandler().SendAnalytics({"login_via":"otp"},'login');
            MoengageAnalyticsHandler().SetUserProfile(
                responseData[SESSION_UID],
                responseData[SESSION_CONTACT],
                responseData[SESSION_PERSONNAME],
                responseData[SESSION_EMAIL],
                responseData[SESSION_PROFILEPIC]
            );
          }catch(ex){
            print('loginController error $ex');
          }
          cnt_Bottom.GetMenutList().then((value) {
            removeAppLoader(contextCommon);
            SuccessMsg(responseData['message'], title: "Success");

            Get.deleteAll(force: true).then((value) {
              if (responseData['isregistered'] == 1) {
                cnt_Bottom.selectedIndex.value = 0;
                MoengageAnalyticsHandler().track_event("dashboard_page");
                Get.offAll(()=>const DashboardPage());
              } else {
                MoengageAnalyticsHandler().track_event("dashboard_page");
                Get.offAll(()=>
                    const DashboardPage(
                  isRegistered: true,
                ));
              }
            });
            txtContactNew.value?.clear();
            txtOtp!.clear();
          });
        });

        isLogin = true;
        Is_Login.value = true;
        print(responseData['msg']);
      } else {
        removeAppLoader(contextCommon);
        validationMsg(responseData['message']);
        print(responseData['message']);
      }
    } catch (error) {
      removeAppLoader(contextCommon);
      print("$error verify otp error");
    }
  }
  getWhatsappText() async {
    appLoader(contextCommon);
    var data = {
      "action": "getwhatsapptext",
    };
    print(data);
    ApiResponse response =
    ApiResponse(data: data, base_url: URL_LOGIN, apiHeaderType: ApiHeaderType.Login);
    Map<String, dynamic>? responseData = await response.getResponse().catchError((error) {
      removeAppLoader(Get.context!);
    });
    print(responseData);
    if (responseData!['status'] == 1) {
      removeAppLoader(Get.context!);
      WALunchUrl(
          "whatsapp://send?phone=${responseData['mobileno'].replaceAll(" ", "")}&text=${Uri.encodeFull(responseData['text'])}");
    } else {
      removeAppLoader(contextCommon);
      validationMsg(responseData['message']);
      
    }
  }
}
