import 'dart:async';
import 'dart:convert';

import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Controller/MenuClickHandlerController/MenuClickHandler.dart';
import 'package:Repeople/View/DashboardPage/DashboardPage.dart';
import 'package:Repeople/Widgets/CommonBackButtonFor5theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/Helper/shared_prefrence.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Model/Theme/WidgetThemeListClass.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:Repeople/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Config/Helper/ApiResponse.dart';
import '../../../View/ManagerScreensFlow/ManagerDashboardScreens/ManagerDashBoardScreen.dart';
import '../../../Widgets/CommomBottomSheet.dart';
import '../../../Widgets/CustomAppBar.dart';
import '../../../Widgets/Loader.dart';
import '../../../Widgets/TextEditField.dart';
import '../../CommonHeaderController/CommenHeaderController.dart';


class ManagerLoginController extends GetxController {
  RxList<WidgetThemeListClass> arrThemeList = RxList<WidgetThemeListClass>();
  var formkeys=GlobalKey<FormState>();
  final mcntxt=Get.context;
  RxBool isPasswordvisible=true.obs;

  FocusNode mobileFocusNode = FocusNode();
  FocusNode otpFocusNode = FocusNode();

  GlobalKey<ScaffoldState> GlobalManagerLoginPagekey = GlobalKey<ScaffoldState>();


  Rxn<TextEditingController> txtContactNew = Rxn(TextEditingController());
  Rxn<TextEditingController> txtPassword = Rxn(TextEditingController());
  Rxn<TextEditingController> txtUserName = Rxn(TextEditingController());
  TextEditingController txtContact = TextEditingController();



  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement dispose

    super.onClose();
    isocode1.value="";
    isocode1.obs;
    txtContact.clear();
    txtContactNew.value?.clear();
    ccode="";
  }

  Widget ContactTextFieldLogin(TextEditingController controller, [double leftPadding = 0, bool labelOpen = true, bool hasFocus = true]) {
    return TextFormField(
      style:  boldTextStyle(fontSize: 18,txtColor: APP_FONT_COLOR),
      // TextStyle(fontWeight: FontWeight.w600),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      keyboardType: TextInputType.number,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      //key: cnt_login.mobilenumberKey,
      controller: controller,
      autofocus: true,
      focusNode: mobileFocusNode,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter mobile number";
        } else if (value.trim().isNotEmpty && !value.trim().isNumberOnly()) {
          return "Please enter only digits";
        }else if(value.length<10){
          return "Please enter 10 digits";
        }else if(value.length>10){
          return "Please enter only 10 digits";
        }
        else {
          return null;
        }
      },

      onChanged: (value) {
        if(value.length==10){
          mobileFocusNode.unfocus();
          // isOtpFieldShown.value=true;
          //
          // Future.delayed(Duration(seconds: 1)).then((value) {
          //   FocusScope.of(mcntxt!).requestFocus(otpFocusNode);
          //   FocusScope.of(mcntxt!).requestFocus(otpFocusNode);
          //   otpFocusNode.requestFocus();
          //   customlistner();
          //
          //   startTimer();
          // });

        }
        // cnt_Leads.errorTextFname.value = "";
        if (value.isNotEmpty) {
          //cnt_login.mobilenumberKey.currentState!.validate();
        }
      },
      decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: LIGHT_GREY)),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: LIGHT_GREY)),
          errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          // border: InputBorder.none,
          // enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: LIGHT_GREY)),
          // focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: LIGHT_GREY)),
          labelText: labelOpen ? "" : null,
          hintText: "9181828182",
          floatingLabelBehavior:
          labelOpen ? FloatingLabelBehavior.always : FloatingLabelBehavior.never,
          contentPadding: EdgeInsets.all(labelOpen ? 10 : 20),
          prefixIcon: Container(
            width: 120,
            margin: EdgeInsets.only(left: leftPadding),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  margin: EdgeInsets.only(
                    right: 10,
                  ),
                  padding: const EdgeInsets.all(10.0),
                  decoration: CustomDecorations()
                      .backgroundlocal(APP_GRAY_COLOR, cornarradius, 0, APP_GRAY_COLOR),
                  child: Image.asset(IMG_TELEPHONE),
                ),
                Column(
                  children: [
                    labelOpen
                        ? Text(
                      "Mobile *",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.black.withOpacity(0.7),
                          fontWeight: FontWeight.bold),
                    )
                        : hasFocus
                        ? Text(
                      "Mobile *",
                      style: TextStyle(
                          fontSize: 12,
                          color: APP_FONT_COLOR,
                          fontWeight: FontWeight.bold),
                    )
                        : Container(),
                    Row(
                      children: [
                        Text(
                          "91",
                          style: TextStyle(
                              fontSize: 18, color: APP_FONT_COLOR, fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.arrow_drop_down)
                      ],
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }



  Widget SendOtpWidget(){
    return Container(
      width: Get.width,
      padding: EdgeInsets.only(top: 30, bottom: 30),
      decoration: BoxDecoration(
          color: APP_THEME_COLOR,
          borderRadius:
          BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))),
      child: Center(
        child: OnTapButton(
            onTap: (){
              if(formkeys.currentState!.validate()){
                if(txtContact.text.length==10){


                  Future.delayed(Duration(seconds: 1)).then((value) {
                    // Login_otp_request_call();
                    FocusScope.of(mcntxt!).requestFocus(otpFocusNode);
                    FocusScope.of(mcntxt!).requestFocus(otpFocusNode);
                    otpFocusNode.requestFocus();
                  });
                }
              }

            },
            width: 120,
            height: 40,
            text: "Send Otp",
            decoration: CustomDecorations().backgroundlocal(white, cornarradius, 0, white),
            style: TextStyle(color: APP_FONT_COLOR)),
      ),
    );

  }

  Widget SubmitButton() {
    return OnTapButton(
        onTap: (){
          if(formkeys.currentState!.validate()){
            VerifyManagerCredentials();
          }
        },

        height: 40,
        decoration:
        CustomDecorations().backgroundlocal(APP_THEME_COLOR, cornarradius, 0, APP_THEME_COLOR),
        text: "Submit",
        style: TextStyle(color: white, fontSize: 14,fontWeight: FontWeight.w600)
    );
  }

  Widget SubmitButton_2() {
    return Container(
      width: Get.width,
      padding: EdgeInsets.only(top: 30, bottom: 30),
      decoration: BoxDecoration(
          color: APP_THEME_COLOR,
          borderRadius:
          BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))),
      child: Center(
        child: OnTapButton(
            onTap: (){
              if(formkeys.currentState!.validate()){
                if(txtContact.text.length==10 && txtPassword.value?.text.length==6){
                  UserSimplePreference.setstring(USER_MOBILE_NO, txtContact.text);
                  UserSimplePreference.setbool(IS_USER_LOGIN, true);
                  Get.deleteAll(force: true).then((value) {
                    Get.offAll(DashboardPage());
                    SuccessMsg("Login Successfully.", title: "Success");
                  });
                  txtContact.clear();
                  txtPassword.value?.clear();
                }
              }
            },
            width: 120,
            height: 40,
            text: "Submit",
            decoration: CustomDecorations().backgroundlocal(white, cornarradius, 0, white),
            style: TextStyle(color: APP_FONT_COLOR)),
      ),
    );
  }

  Widget SendOtpButton(){
    return OnTapButton(
        onTap: (){
          if(formkeys.currentState!.validate()/* && isocode1.value!="" &&isocode1.value!="INDIA"*/){
            if(txtContactNew.value?.text.length==10){

            }}

        },

        height: 40,
        width: Get.width,
        decoration:
        CustomDecorations().backgroundlocal(APP_THEME_COLOR, cornarradius, 0, APP_THEME_COLOR),
        text: "Send OTP",
        style: TextStyle(color: white, fontSize: 14,fontWeight: FontWeight.w600)
    );
  }

  Widget SubmitButton_3() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: OnTapButton(
          width: 140,
          height: 40,
          onTap: (){
            if(formkeys.currentState!.validate()){
              if(txtContact.text.length==10 && txtPassword.value?.text.length==6){
                UserSimplePreference.setstring(USER_MOBILE_NO, txtContact.text);
                UserSimplePreference.setbool(IS_USER_LOGIN, true);
                Get.deleteAll(force: true).then((value) {
                  Get.offAll(DashboardPage());
                  SuccessMsg("Login Successfully.", title: "Success");
                });
                txtContact.clear();
                txtPassword.value?.clear();
              }
            }
          },
          decoration:
          CustomDecorations().backgroundlocal(APP_THEME_COLOR, cornarradius, 0, APP_THEME_COLOR),
          text: "Submit",
          style: TextStyle(color: white, fontSize: 14,fontWeight: FontWeight.w600)),
    );
  }

  Widget SendOtpButton_3() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: OnTapButton(
          width: 140,
          height: 40,
          onTap: (){
            if(formkeys.currentState!.validate() && isocode1.value!="" &&isocode1.value!="INDIA"){
              if(txtContact.text.length==10){
                Future.delayed(Duration(seconds: 1)).then((value) {
                  FocusScope.of(mcntxt!).requestFocus(otpFocusNode);
                  FocusScope.of(mcntxt!).requestFocus(otpFocusNode);
                  otpFocusNode.requestFocus();
                });
              }}
          },
          decoration:
          CustomDecorations().backgroundlocal(APP_THEME_COLOR, cornarradius, 0, APP_THEME_COLOR),
          text: "Send OTP",
          style: TextStyle(color: white, fontSize: 14,fontWeight: FontWeight.w600)),
    );
  }

  Widget SubmitButton_4() {
    return Container(
      // color: Colors.red,
      width: Get.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: Colors.grey,height: 1,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
            child: OnTapButton(
                width: 140,
                height: 40,
                onTap: (){
                  if(formkeys.currentState!.validate()){
                    if(txtContact.text.length==10 && txtPassword.value?.text.length==6){
                      UserSimplePreference.setstring(USER_MOBILE_NO, txtContact.text);
                      UserSimplePreference.setbool(IS_USER_LOGIN, true);
                      Get.deleteAll(force: true).then((value) {
                        Get.offAll(DashboardPage());
                        SuccessMsg("Login Successfully.", title: "Success");
                      });
                      txtContact.clear();
                      txtPassword.value?.clear();
                    }
                  }

                },
                decoration:
                CustomDecorations().backgroundlocal(APP_THEME_COLOR, cornarradius, 0, APP_THEME_COLOR),
                text: "Submit",
                style: TextStyle(color: white, fontSize: 14,fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }



  VerifyManagerCredentials()async{
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      appLoader(contextCommon);
      Map<String, dynamic> data = {};
      data['action'] = 'authenticatelogin';
      data['username'] = txtUserName.value?.text.toString();
      data['password']=txtPassword.value?.text.toString();

      Map<String, dynamic> data1 = await deviceData.getDeviceData();
      data.addAll(data1);

      print(" * + * +* + *+ *+ $data");
      ApiResponse response = ApiResponse(
          data: data,
          base_url: URL_LOGIN,
          apiHeaderType: ApiHeaderType.Login);
      Map<String, dynamic>? responseData = await response.getResponse();
      debugPrint(responseData.toString());
      if (responseData!['status'] == 1) {

        sp.setString(REPEOPLE_MANAGER_CREDENTIAL, jsonEncode(responseData));
        storeManagerLoginSessionData(responseData).then((value) {

          cnt_Bottom.GetMenutList().then((value) {
            removeAppLoader(contextCommon);
            SuccessMsg(responseData['message'], title: "Success");
            Get.deleteAll(force: true).then((value) {

              cnt_Bottom.selectedIndex.value=0;
              Get.offAll(ManagerDashboardPage());
            });
            txtContactNew.value?.clear();
            txtPassword.value?.clear();
          });

        });

        isLogin=true;
        Is_Login.value=true;
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

//<editor-fold desc = "Power by 1 , Power by 2">


//</editor-fold>

}