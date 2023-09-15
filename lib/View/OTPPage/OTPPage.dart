
import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Controller/OTPController/OTPController.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:Repeople/Widgets/TextEditField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:pinput/pinput.dart';


class OTPPage extends StatefulWidget {
  final String? mobileNo;
  final int? isUser;
   const OTPPage({Key? key,this.mobileNo,this.isUser}) : super(key: key);

  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> with TickerProviderStateMixin{

  OTPController cntOtp = Get.put(OTPController());

  @override
  void initState() {
    super.initState();
    cntOtp.startTimer();
    cntOtp.countDown();
    cntOtp.mobileNo.value = widget.mobileNo??"";
    cntOtp.isNewUser.value = widget.isUser??0;
  }

  @override
  void dispose() {
    cntOtp.txtOtp1?.stopListen();
    cntOtp.timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_WHITE,
      resizeToAvoidBottomInset: true,
      key: cntOtp.globalLoginPageKey,
      body: SafeArea(
        child: Stack(
          children: [
            oTPFormData()
          ],
        ),
      ),
    );
  }
  Widget oTPFormData() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Stack(
        children: [
          Stack(
            children: [
              SizedBox(
                height: Get.height,
                width: Get.width,
                child: Image.asset(
                  SPLASH_BACK_IMAGES,
                  height: Get.height,
                  width: Get.width,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 0.w),
              Padding(
                padding:  EdgeInsets.only(top: 80.w,left: 20.h,right: 20.h),
                child: Container(
                  margin:  EdgeInsets.only(top:170.w),
                  // margin: EdgeInsets.only(top: pageHeight - Get.height * 0.60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      otpTextField(),
                      SizedBox(height: 24.w),
                      resendOtpView(),
                      SizedBox(height: 16.w),
                      if(widget.isUser==1)
                      Obx(() => cntOtp.isReferralText.value==false?haveReferralCodeText():referralCodeTextField()),
                    ],
                  ),
                ),
              ),
              Obx(() => Positioned(
                bottom: 68.h,
                left: cntOtp.countText.value != 0?94:20.w,
                right: cntOtp.countText.value != 0?94:20.w,
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child:  Obx(() => cntOtp.countText.value == 0?OnLoginTapButton(
                        onTap: (){
                          if (cntOtp.formKeys.currentState!.validate()) {
                            cntOtp.otpFocusNode.unfocus();
                            cntOtp.VerifyOtp();
                          }
                        },
                        height: 40.w,
                        width: Get.width,
                        decoration: CustomDecorations()
                            .backgroundlocal(APP_THEME_COLOR, 6, 0, APP_THEME_COLOR),
                        text: "CONTINUE",
                        style:
                        TextStyle(color: white, fontSize: 12, fontWeight: FontWeight.w500))
                        : GestureDetector(
                      onTap: () {
                        if (cntOtp.formKeys.currentState!.validate()) {

                        }
                      },
                      child: Container(
                        height: 51,
                        width: 185,
                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
                        decoration: BoxDecoration(
                            color: DARK_BLUE,
                            borderRadius: BorderRadius.circular(6)),
                        child: Image.asset(
                          width: 185,
                          height: 36,
                          otp_prgress_gif,
                          color: white,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    )
                ),
              )
              ),
            ],
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
                  GestureDetector(
                    onTap:(){
                      Get.back();
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Image.asset(BACK_ARROW_IMAGE,width: 6.h, height: 12.w,color: DARK_BLUE,)
                    ),
                  ),
                  SizedBox(height: 80.w),
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
                    "Enter the OTP sent to",
                    style: TextStyle(
                        color: AppColors.WHITE,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600),
                  ),Obx(() => Text(
                    "${"+91"} ${cntOtp.mobileNo.value}",
                    style: TextStyle(
                        color: AppColors.WHITE,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600),
                  )),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget resendOtpView() {
    return Obx(() => cntOtp.countText.value == 0
        ? GestureDetector(
      onTap: (){
        cntOtp.ReSendOtp();
      },
      child: Text(
        "RESEND",
        style: TextStyle(
            letterSpacing: 0.5,
            color: hex("#006CB5"),
            fontSize: 12.sp,
            fontWeight: FontWeight.w500),
      ),
    )
        : Text(
      "${cntOtp.countText.value} s",
      style: TextStyle(
          letterSpacing: 0.5,
          color: hex("#006CB5"),
          fontSize: 12.sp,
          fontWeight: FontWeight.w500),
    ));
  }

  Widget otpTextField() {
    return Form(
      key: cntOtp.formKeys,
      child: Container(
          width: Get.width,
          alignment: Alignment.centerLeft,
          child: Pinput(
            length: 6,
            autofocus: false,
            controller: cntOtp.txtOtp,
            textInputAction: TextInputAction.done,
            focusNode: cntOtp.otpFocusNode,

            validator: (value) {
              if (value!.isEmpty) {
                return "Please enter OTP";
              } else if (cntOtp.txtOtp!.length < 6) {
                return "Please enter 6 digits";
              } else {
                return null;
              }
              // return value == txtotp!.length < 6 ? "Please enter 6 digits" : 'Please enter OTP';
            },

            keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
            defaultPinTheme: PinTheme(
              width: 37.w,
              height: 46.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                    color: BLACK,
                    width: 1
                ),
              ),
              textStyle:  TextStyle(
                fontFamily: fontFamily,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: BLACK,
              ),
            ),
            focusedPinTheme: PinTheme(
              width: 37.w,
              height: 46.w,
              textStyle:  TextStyle(
                fontFamily: fontFamily,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: BLACK,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                    color: BLACK,
                    width: 1.5
                ),
              ),),
            showCursor: true,
            mainAxisAlignment: MainAxisAlignment.spaceBetween ,
            onCompleted: (pin) {
              cntOtp.otp.value = pin;
              cntOtp.VerifyOtp();
            },
          )),
    );
  }

  Widget haveReferralCodeText(){
    return GestureDetector(
      onTap:(){
        cntOtp.isReferralText.value=true;
      },
      child: Text(
        haveAReferralCodeText,
        style: TextStyle(
            color: DARK_BLUE,
            fontSize: 14.sp,
            fontFamily: fontFamily,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget referralCodeTextField(){
    return  simpleTextFieldNewWithCustomization(
        hintText: "kFQsvWm",
        imageIcon: IMG_PROFILEUSER_SVG_DASHBOARD,
        controller: cntOtp.txtReferCode,
        inputFormat: [UpperCaseTextFormatter()],
        textInputType: TextInputType.name,
        labelText: "Refer Code",
        textCapitalization: TextCapitalization.sentences,
        validator: (value) => validation(value, "Please enter referCode"));
  }
}