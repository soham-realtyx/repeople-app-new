import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/Helper/shared_prefrence.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:Repeople/Controller/ManagerFlowController/ManagerLoginController/ManagerLoginController.dart';
import 'package:Repeople/View/DashboardPage/DashboardPage.dart';
import 'package:Repeople/Widgets/CommomBottomSheet.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:Repeople/Widgets/TextEditField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/utils/colors.dart';

import '../../../Config/Constant.dart';


class ManagerLoginPage extends StatefulWidget {
  const ManagerLoginPage({Key? key}) : super(key: key);

  @override
  _ManagerLoginPageState createState() => _ManagerLoginPageState();
}

class _ManagerLoginPageState extends State<ManagerLoginPage> with TickerProviderStateMixin{

  ManagerLoginController cntManagerLogin = Get.put(ManagerLoginController());
  CommonHeaderController cntCommonHeader = Get.put(CommonHeaderController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_WHITE,
      resizeToAvoidBottomInset: true,
      key: cntManagerLogin.GlobalManagerLoginPagekey,
      endDrawer: CustomDrawer(animatedOffset: const Offset(1.0,0),),
      drawer: CustomDrawer(animatedOffset: const Offset(-1.0,0),),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
                child: managerLoginFormData()),
            cntCommonHeader.commonAppBar(MANAGER_LOGIN_APPMENUNAME, cntManagerLogin.GlobalManagerLoginPagekey,color: white,
                isNotificationHide: true,ismenuiconhide: true),

            Align(alignment: Alignment.bottomCenter,child: submitButton()),
            
          ],
        ),
      ),

    );
  }

  Widget managerLoginFormData() {
    var pageHeight = Get.height - Get.mediaQuery.padding.top - APPBAR_HEIGHT;
    return Form(
      key:cntManagerLogin.formkeys,
      child:
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 100,
              ),
              Container(
                  decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [fullcontainerboxShadow]
                  ),
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.all(10),
                  child:
                  SvgPicture.asset(
                    IMG_APPLOGO1_SVG,
                    width: 100,
                    height: 100,
                    color: hex("332B67"),
                  )
              ),
              Container(
                margin: const EdgeInsets.only(top:30),
                child: Column(
                  children: [managerLoginForm()],
                ),
              ),
              // SizedBox(
              //   height: 40,
              // ),
            ],
          ),



    );
  }
  
  Widget managerLoginForm() {
    return Obx(() =>
        Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                simpleTextFieldNewWithCustomization(
                  inputFormat: [
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                    /* UpperCaseTextFormatter()*/],
                  hintText: "John",
                  imageIcon: IMG_USER_SVG_NEW,
                  textCapitalization: TextCapitalization.sentences,
                  controller: cntManagerLogin.txtUserName,
                  textInputType: TextInputType.name,
                  labelText: "User Name*",
                  validator: (value) =>
                      validation(value, "Please enter user name"),
                ),
                SizedBox(height: 20.w,),
                passwordField(cntManagerLogin.txtPassword, IMG_OTP_SVG_NEW, "Password*", "Password"),
                const SizedBox(height: 40,)
              ],
            )
        ));
  }

  Widget passwordField(Rxn<TextEditingController>? controller, String imageIcon,String labelText, String hintText, [double leftPadding = 0, bool labelOpen = true, bool hasFocus = true]) {
    return   TextFormField(

      controller: controller?.value,
      obscuringCharacter: '●',
      focusNode: cntManagerLogin.otpFocusNode,
      onChanged: (value) {
        controller.update((val) { });
      },
      obscureText: cntManagerLogin.isPasswordvisible.value,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter password";
        }
        else {
          return null;
        }
      },
      style: boldTextStyle(fontSize: 18, txtColor: APP_FONT_COLOR),
      decoration: InputDecoration(
        counterText: "",
        border: InputBorder.none,
        enabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: gray_color_1)),
        focusedBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: gray_color_1)),
        errorBorder:
        const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        disabledBorder:
        const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        focusedErrorBorder:
        const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        // contentPadding: const EdgeInsets.all(20),
         enabled: true,
        isDense: true,
        hintStyle: TextStyle(fontSize: 15,height: 1.8,
            color: Colors.grey.withOpacity(0.8), fontWeight: FontWeight.bold),

        labelStyle:TextStyle(
            fontSize: 16,

            color:controller!.value!.text.toString().isNotEmpty? Colors.grey.withOpacity(0.7):
            Colors.black.withOpacity(0.7),
            fontWeight: FontWeight.w600),
        labelText: labelText,
        hintText: hintText,
        contentPadding:  const EdgeInsets.only(bottom: 16),
        suffixIcon: Container(
          padding: const EdgeInsets.only(top: 20,bottom: 16),
          child: GestureDetector(
              onTap: (){
                cntManagerLogin.isPasswordvisible.value=!cntManagerLogin.isPasswordvisible.value;
              },
              child:cntManagerLogin.isPasswordvisible.isTrue?const Icon(Icons.visibility_off): Icon(Icons.visibility)),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  Widget submitButton() {
    return Container(
      margin: const EdgeInsets.only(right: 20,left: 20,bottom: 20),
      child: OnTapButton(
          onTap: (){
            if(cntManagerLogin.formkeys.currentState!.validate()){


                cntManagerLogin.VerifyManagerCredentials();

            }
          },
          width: Get.width-32,
          height: 44,

          decoration:
          CustomDecorations().backgroundlocal(APP_THEME_COLOR, cornarradius, 0, APP_THEME_COLOR),
          text: "Submit",
          style: TextStyle(color: white,fontWeight: FontWeight.w600, fontSize: 14)),
    );
  }
}