
import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:Repeople/Widgets/TextEditField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/utils/colors.dart';
import '../../Config/Constant.dart';
import '../../Controller/LoginController/LoginController.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin{

  LoginController cntLogin = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    cntLogin.txtOtp1?.stopListen();
    cntLogin.timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_WHITE,
      resizeToAvoidBottomInset: true,
      key: cntLogin.globalLOginPageKey,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: loginFormData(),
            )
          ],
        ),
      ),
    );
  }

  Widget loginFormData() {
    return Form(
      key: cntLogin.formKeys,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Stack(
                children: [
                  SizedBox(
                    height: Get.height,
                    width: Get.width,
                    child: Image.asset(
                      SPLASH_BACK_IMAGES,
                      // height: 750,
                      height: Get.height,
                      width: Get.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 0.w),
                  Padding(
                    padding:  EdgeInsets.only(top: 70.w,left: 20.h,right: 20.h),
                    child: Container(
                      margin:  EdgeInsets.only(top:170.w),
                      // margin: EdgeInsets.only(top: pageHeight - Get.height * 0.60),
                      child: Column(
                        children: [
                          // LoginForm_5(),
                          PhoneNumberTextField(cntLogin.txtContactNew),
                          SizedBox(height: 24.w),
                          OnLoginTapButton(
                            onTap: () {
                              if (cntLogin.formKeys.currentState!
                                  .validate() /* && isocode1.value!="" &&isocode1.value!="INDIA"*/) {
                                if (cntLogin.txtContactNew.value?.text.length == 10) {
                                  cntLogin.isOtpFieldShown.value = true;
                                  cntLogin.sendOtp();
                                }
                              }
                            },
                            height: 40.w,
                            width: Get.width,
                            decoration: BoxDecoration(
                                color: AppColors.WHITE,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color:hex("#006CB5"),width: 1 )
                            ),
                            text: "GET SMS OTP",
                            style: TextStyle(
                                color: hex("#006CB5"),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 68.h,left: 20.w,right: 20.w,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: OnLoginTapButton(
                          onTap: (){
                            // GetWhatsappText();
                            WALunchUrl("whatsapp://send?phone=$whatsAppLoginNo&text=${Uri.encodeFull(whatsAppLoginMessage)}");
                          },
                          height: 40.w,
                          width: Get.width,
                          decoration: CustomDecorations()
                              .backgroundlocal(APP_THEME_COLOR, 6, 0, APP_THEME_COLOR),
                          text: "Login with Whatsapp".toUpperCase(),
                          icon: Image.asset(WHATSAPP_IMAGES,height: 18.w,width: 18.h),
                          style:
                          TextStyle(color: white, fontSize: 12, fontWeight: FontWeight.w500)),
                    ),
                  ),
                ],
              ),
            ),

            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 227.w,
                width: Get.width,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(color: APP_THEME_COLOR),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 100.w),
                    Text(
                      "WELCOME TO REPEOPLE",
                      style: TextStyle(
                          letterSpacing: 0.8,
                          color: hex("#FFFFFF"),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 8.w),
                    Text(
                      "Tell us your mobile number",
                      style: TextStyle(
                          color: AppColors.WHITE,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            )

          ],
        ),
      ),
    );
  }

}