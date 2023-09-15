


import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Helper/ApiResponse.dart';
import 'package:Repeople/Config/Helper/MoengageAnalyticsHandler.dart';
import 'package:Repeople/Config/Helper/shared_prefrence.dart';
import 'package:Repeople/View/OTPPage/OTPPage.dart';
import 'package:Repeople/Widgets/CommomBottomSheet.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
bool? isLogin = false;
callLinkOpen(var event) async {
  print(event);
  SharedPreferences sp = await SharedPreferences.getInstance();
  isLogin = sp.getBool(ISLOGIN) ?? false;
  bool isContainsWaba = event.contains("/waba-login/");
  bool isContainsWhatsapp = event.contains("/whatsapp-login/");
  bool isContainsInvitee = event.contains("/invitee/");
  bool isContainsBinvitee = event.contains("/binvitee/");
  String whatsLogin = "";
  String invitee = "";
  if (isContainsWaba) {
    whatsLogin = "/waba-login/";
  } else if (isContainsWhatsapp) {
    whatsLogin = "/whatsapp-login/";
  }

  if (isContainsInvitee) {
    invitee = "/invitee/";
  } else if (isContainsBinvitee) {
    invitee = "/binvitee/";
  }

  if (isContainsWaba || isContainsWhatsapp) {
    var data = event.split(whatsLogin);
    print(data);
    if (data[1] != null && data[1].isNotEmpty) {
      WhatsappLogin(data[1].toString().replaceAll("?data=", ""));
    }
  } else if ((isContainsInvitee || isContainsBinvitee) && !isLogin!) {
    var data = event.split(invitee);
    if (data[1] != null && data[1].isNotEmpty /*&& !isLogin!*/) {
      Get.to(()=>const OTPPage(
        // referral_code: data[1].toString().replaceAll("?data=", ""),
      ));
    }
  } else {
    // checkLoginOrNot();
  }
}

WhatsappLogin(String loginId) async {
  // AppLoader(Get.context!);
  var data = {
    "action": "verifywhatsapplogin",
    "id": loginId,
  };
  print("verifywhatsapplogin data ===========$data");
  ApiResponse response = ApiResponse(
      data: data, base_url: URL_LOGIN, apiHeaderType: ApiHeaderType.Login);
  Map<String, dynamic>? responseData = await response.getResponse();
  print("verifywhatsapplogin responseData ===========$responseData");
  if (responseData!['status'] == 1) {
    if (responseData['isregistered'] == 1) {
      storeCustomerLoginSessionData(responseData).then((value) {
        if (responseData['isapplaunched'] == 1) {
          // Get.offAll(
          //   DashboardPage(isLogin: true),
          // );
          try {
            MoengageAnalyticsHandler()
                .SendAnalytics({"Login_via": "whatsapp"}, 'Login');

            MoengageAnalyticsHandler()
                .SetUserIdentify(responseData[SESSION_CONTACT]);

            MoengageAnalyticsHandler().SetUserProfile(
              responseData[SESSION_UID],
              responseData[SESSION_CONTACT],
              responseData[SESSION_PERSONNAME],
              responseData[SESSION_EMAIL],
              responseData[SESSION_PROFILEPIC],
            );
          } catch (ex) {
            print('logincontroller' + ex.toString());
          }
          // gooffAllHomePageWithParams(isLogin: true);
        } else {
          // Get.offAll(WaitListPage(isLogin: true));
          // Get.offAll(AppNotLaunchPage(isLogin: true));
        }
      });
    } else {
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString(SESSION_CMPID, responseData['cmpid']);
      // Get.offAll(RegistrationPage(
      //   mobileno: responseData['contact'],
      //   str_action: ACTION_REGISTRATION,
      //   referral_code: "",
      //   isWhatsappLogin: true,
      // ));
    }
  } else {
    validationMsg(responseData['message']);
    print(responseData['message']);
  }

  // RemoveAppLoader(context);
}