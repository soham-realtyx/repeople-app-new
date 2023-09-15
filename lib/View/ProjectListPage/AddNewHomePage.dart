import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:Repeople/Widgets/TextEditField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Controller/AddNewHomeController/AddNewHomeController.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';


class AddNewHomePage extends StatefulWidget {
  String title="";
  AddNewHomePage({required this.title});

  @override
  _AddNewHomePageState createState() => _AddNewHomePageState();
}

class _AddNewHomePageState extends State<AddNewHomePage> {

  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());
  AddNewHomeController cnt_home = Get.put(AddNewHomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_WHITE,
      key: cnt_home.GlobaladdnewhomePagekey,
      endDrawer: CustomDrawer(
        animatedOffset: Offset(1.0, 0),
      ),
      drawer: CustomDrawer(
        animatedOffset: Offset(-1.0, 0),
      ),
      body: SafeArea(
        child: Stack(
          children: [
             SingleChildScrollView(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   SizedBox(height: APPBAR_HEIGHT),
                   Theme_1(),
                   SizedBox(height: APPBAR_HEIGHT),
                 ],
               ),
             ),
            cnt_CommonHeader.commonAppBar(ADDNEWHOME, cnt_home.GlobaladdnewhomePagekey,color: AppColors.WHITE.withOpacity(0.0),)
          ],
        ),
      ),
    );
  }

  Widget Theme_1() {
    return Obx(() => Container(
      margin: const EdgeInsets.only(left: 20.0,right: 20,top: 15,bottom: 100),
      padding: const EdgeInsets.only(left: 8,right: 8,bottom: 20,top: 16),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: BLACK.withOpacity(0.1),
            // spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Form(
        key: cnt_home.formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            simpleTextFieldNewWithCustomization(
                hintText: "98753011",
                inputFormat: [
                  FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                  UpperCaseTextFormatter()],
                noAutoValidation: true,
                imageIcon: IMG_USER_SVG_NEW,
                textCapitalization: TextCapitalization.sentences,
                controller: cnt_home.txtBookingID,
                textInputType: TextInputType.number,
                labelText: "Booking ID*",
                validator: (value) =>
                    validation(value, "Please enter booking ID")),
            const SizedBox(height: 16),
            cnt_home.PhoneNumberTextField(cnt_home.txtContactNew),
            const SizedBox(height: 16),
            CommonDropDownTextField(
              labelText: "Project*",
              onTap: (){
                cnt_home.SelectProject();
              },
              imageIcon: IMG_PROJECT_SVG_DASHBOARD,
              controller: cnt_home.txtProject,
              hintText: "Select Project",
            ),
            const SizedBox(height: 16),
            Obx(() =>   Visibility(
              visible: cnt_home.isListContainData.isTrue,
              child: CommonDropDownTextField(
                labelText: "Building*",
                onTap: (){
                  cnt_home.SelectPropertyDialog();
                },
                imageIcon: IMG_PROJECT_SVG_DASHBOARD,
                controller: cnt_home.txtBuilding,
                hintText: "Select Building",
              ),
            )),
            Obx(() =>   Visibility(
                visible: cnt_home.isListContainData.isFalse,
                child: Column(
                  children: [
                    const SizedBox(height: 30,),
                    Text("NO Data Found For This Project",style:boldTextStyle(),),
                  ],
                )
            )),
            const SizedBox(height: 16),
            Visibility(
                visible: cnt_home.isshowunitlist.value,
                child: CommonDropDownTextField(
                  labelText: "Unit Number*",
                  onTap: (){
                    cnt_home.SelectUnitNo();
                  },
                  imageIcon: IMG_PROJECT_SVG_DASHBOARD,
                  controller: cnt_home.txtUnitNo,
                  hintText: 'Select Unit Number',
                )),
            const SizedBox(
              height: 30,
            ),
            submitButton(),
            const SizedBox(
              height: 4,
            ),
          ],
        ),
      ),
    ));
  }
  Widget SelectProjectTextField({double padding=0}){
    return   TextFormField(
      onTap: () {
        cnt_home.SelectProject();
        // SelectProfession();
      },
      style:
      boldTextStyle(fontSize: 18,txtColor: APP_FONT_COLOR),
      // TextStyle(fontSize: 18, color: APP_FONT_COLOR, fontWeight: FontWeight.w600),
      readOnly: true,
      controller: cnt_home.txtProject,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      // validator: (value) =>
      //     validation(value, "Please select project"),
      decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: LIGHT_GREY)),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: LIGHT_GREY)),
          errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          contentPadding: EdgeInsets.all(20),

          labelStyle:
          TextStyle(
              fontSize: 16, color: Colors.black.withOpacity(0.7), fontWeight: FontWeight.bold),
          labelText: "Select Project*",
          hintText: "Select Project",
          hintStyle:  boldTextStyle(fontSize: 18,txtColor: APP_FONT_COLOR),
          // semiBoldTextStyle(fontSize: 18,txtColor: APP_FONT_COLOR),
          floatingLabelBehavior: FloatingLabelBehavior.always ,
          prefixIcon: Padding(
            padding:  EdgeInsets.only(left: padding),
            child: Container(
                width: 50,
                height: 50,
                margin: EdgeInsets.only(right: 10, left: 0),
                padding: const EdgeInsets.all(10.0),
                decoration: CustomDecorations()
                    .backgroundlocal(APP_GRAY_COLOR, cornarradius, 0, APP_GRAY_COLOR),
                child: SvgPicture.asset(IMG_PROJECT_SVG_DASHBOARD)
              // Image.asset(IMG_PROJECT_SVG_DASHBOARD),
            ),
          ),
          suffixIcon: Icon(Icons.arrow_drop_down)),
    );
  }

  Widget submitButton() {
    return OnTapButton(
        onTap: (){
          if(cnt_home.formkey.currentState!.validate()){
            cnt_home.AddNewPropertyData();

            // Get.to(EditProfilePage());
          }
        },
        //width: Get.width - 32,
        height: 40,
        decoration: CustomDecorations().backgroundlocal(APP_THEME_COLOR, cornarradius, 0, APP_THEME_COLOR),
        text: "Submit".toUpperCase(),

        style: TextStyle(
            color: white,
            fontSize: 12.sp,
            fontFamily: fontFamily,
            fontWeight: FontWeight.w500)
      // TextStyle(color: WHITE, fontWeight: FontWeight.w600, fontSize: 14)
    );
  }
}
