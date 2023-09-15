import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:Repeople/Controller/MenuClickHandlerController/MenuClickHandler.dart';
import 'package:Repeople/View/DashboardPage/DashboardPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/Helper/MoengageAnalyticsHandler.dart';
import 'package:Repeople/Config/Helper/shared_prefrence.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Model/Theme/WidgetThemeListClass.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:Repeople/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Config/Helper/ApiResponse.dart';
import '../../Widgets/CommomBottomSheet.dart';
import '../../Widgets/Loader.dart';
import '../../Widgets/TextEditField.dart';
import '../CommonHeaderController/CommenHeaderController.dart';

class OTPController extends GetxController {
  RxList<WidgetThemeListClass> arrThemeList = RxList<WidgetThemeListClass>();
  var formKeys = GlobalKey<FormState>();
  bool isSendVerify = false;
  RxBool isReferralText = false.obs;
  RxBool isReferralCode = true.obs;
  late AnimationController _controller;
  int levelClock = 60;
  late OTPInteractor _otpInteractor;
  RxBool isOtpFieldShown = false.obs;
  Rx<Duration> duration = const Duration().obs; // for timer
  Timer? timer;
  final mcnTxt = Get.context;
  RxBool timerIsActive = true.obs;
  FocusNode mobileFocusNode = FocusNode();
  FocusNode referFocusNode = FocusNode();
  FocusNode otpFocusNode = FocusNode();
  RxInt isNewUser=0.obs;
  RxString mobileNo="".obs;
  RxString otp = "".obs;
  CommonHeaderController cntCommonHeader = Get.put(CommonHeaderController());
  GlobalKey<ScaffoldState> globalLoginPageKey = GlobalKey<ScaffoldState>();

  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtOtpController = TextEditingController();
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
  Rxn<TextEditingController> txtReferCode = Rxn(TextEditingController());

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement dispose

    super.onClose();
    isocode1.value = "";
    isocode1.obs;
    // isocode="";
    txtContact.clear();
    txtContactNew.value?.clear();
    ccode = "";

    //Get.delete<DashboardController>();
  }
  RxInt countText = 45.obs;
  //<editor-fold des="Appbar Theme">
  countDown() {
    countText.value = 45;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (countText.value == 0) {
        timer.cancel();
        countText.refresh();
        update();
      } else {
        countText.value--;
        countText.refresh();
        update();
      }
    });
  }



  Widget submitButton() {
    return OnTapButton(
        onTap: () {
          if (formKeys.currentState!.validate()) {
            if (txtContactNew.value?.text.length == 10 &&
                txtOtp!.text.length == 6) {
              VerifyOtp();
              // Is_Login.value = true;

            }
          }
        },
        height: 40,
        decoration: CustomDecorations()
            .backgroundlocal(APP_THEME_COLOR, cornarradius, 0, APP_THEME_COLOR),
        text: "Submit",
        style:
        TextStyle(color: white, fontSize: 14, fontWeight: FontWeight.w600));
  }

  Widget sendOtpButtons() {
    return OnTapButton(
        onTap: () {
          if (formKeys.currentState!
              .validate() /* && isocode1.value!="" &&isocode1.value!="INDIA"*/) {
            if (txtContactNew.value?.text.length == 10) {
              isOtpFieldShown.value = true;
              // SendOtp();
            }
          }
        },
        height: 40,
        width: Get.width,
        decoration: CustomDecorations()
            .backgroundlocal(APP_THEME_COLOR, cornarradius, 0, APP_THEME_COLOR),
        text: "Send OTP",
        style:
        TextStyle(color: white, fontSize: 14, fontWeight: FontWeight.w600));
  }

  void startTimer() {
    duration.value = Duration(seconds: 60);
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  void addTime() {
    final addSeconds = -1;
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
        style: TextStyle(fontSize: 12, color: Colors.black)
      // boldTextStyle(fontSize: 12,
      //     txtColor: AppColors.TEXT_FIELD_COLOR),
    );
    // return Text('${duration.inSeconds}',style: TextStyle(color: Colors.white,fontSize: 18,fontFamily: poppins_regular),);
  }

  customListner() {
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
          VerifyOtp();
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

  fetchRedeemPointCall() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    try{
      var data = {
        'action': 'fetchrepeoplepoint',
      };
      var headers = {
        'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",
      };
      ApiResponse response = ApiResponse(
        data: data,
        base_url: redeemPointsURL,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers,
      );
      Map<String, dynamic>? responseData = await response.getResponse();
      log( "fetch Repeople PointCall " + responseData.toString());
      if (responseData!['status'] == 1) {
        redeemPoints.value = responseData['remainingpoints'];
      }
      else{
        // redeemMessage.value=responseData['message'];
      }
    }catch(e){
      print(e.toString()+" my fetch redeem point error");
    }
  }

  whatsAppReferralDetails() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    try{
      var data = {
        'action': 'fetchreferraldetail',
      };
      var headers = {
        'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",
      };
      ApiResponse response = ApiResponse(
        data: data,
        base_url: whatsAppReferral,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers,
      );
      Map<String, dynamic>? responseData = await response.getResponse();
      log( "whatsApp referral call " + responseData.toString());
      if (responseData!['status'] == 1) {
        referralCode.value=responseData['referralcode'];
        referralLink.value=responseData['link'];
      }
      else{
        // redeemMessage.value=responseData['message'];
      }
    }catch(e){
      print(e.toString()+" my fetch redeem point error");
    }
  }

  ReSendOtp() async {
    try {
      appLoader(contextCommon);
      Map<String, dynamic> data = {};
      data['action'] = 'resendotp';
      data['mobileno'] = mobileNo.toString();
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
        customListner();
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

  VerifyOtp() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      appLoader(contextCommon);
      Map<String, dynamic> data = {};
      data['action'] = 'verifyotp';
      data['mobileno'] = mobileNo.toString();
      data['otp'] = txtOtp!.text.toString();
      data['type'] = LOGIN_TYPE;
      data['referralcode']=txtReferCode.value?.text.toString();
      Map<String, dynamic> data1 = await deviceData.getDeviceData();
      data.addAll(data1);
      print("verify otp * + * +* + *+ *+ $data");
      ApiResponse response = ApiResponse(
          data: data, base_url: URL_LOGIN, apiHeaderType: ApiHeaderType.Login);
      Map<String, dynamic>? responseData = await response.getResponse();
      if (responseData!['status'] == 1) {
        sp.setString(REPEOPLE_CUSTOMER_CREDENTIAL, json.encode(responseData));
        storeCustomerLoginSessionData(responseData).then((value) {
          try{
            MoengageAnalyticsHandler().SendAnalytics({"mobile_no":mobileNo.toString(),"otp":txtOtp!.text.toString()},'login');
            MoengageAnalyticsHandler().SetUserIdentify(SESSION_UID);
            MoengageAnalyticsHandler().SetUserProfile(
                responseData[SESSION_UID],
                responseData[SESSION_CONTACT],
                responseData[SESSION_PERSONNAME],
                responseData[SESSION_EMAIL],
                responseData[SESSION_PROFILEPIC]
            );
          }catch(ex){
            print('logincontroller error'+ex.toString());
          }
          cnt_Bottom.GetMenutList().then((value) {
            removeAppLoader(contextCommon);
            SuccessMsg(responseData['message'],
                title: "Success");
            fetchRedeemPointCall();
            whatsAppReferralDetails();
            Get.deleteAll(force: true).then((value) {
              if (responseData['isregistered'] == 1) {
                cnt_Bottom.selectedIndex.value = 0;
                Get.offAll(DashboardPage());
              } else {
                Get.offAll(()=>const DashboardPage(
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
      print(error);
    }
  }

}
