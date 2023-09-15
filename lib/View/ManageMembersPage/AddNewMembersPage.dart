import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/View/DashboardPage/BottomnavigationBar.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:Repeople/Controller/MyPropertiesController/MyPropertiesController.dart';
import 'package:Repeople/Model/ManageMembersModel/ManageMembersModel.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:Repeople/Widgets/TextEditField.dart';


class AddNewMembersPage extends StatefulWidget {
  const AddNewMembersPage({Key? key}) : super(key: key);

  @override
  State<AddNewMembersPage> createState() => _AddNewMembersPageState();
}

class _AddNewMembersPageState extends State<AddNewMembersPage> {
  MyPropertiesController cnt_Myproperties = Get.put(MyPropertiesController());
  CommonHeaderController cnt_HeaderController = Get.put(CommonHeaderController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.BACKGROUND_WHITE,
      key: cnt_Myproperties.GlobaladdNewMembersPagekey,
      endDrawer: CustomDrawer(animatedOffset: Offset(1.0,0)),
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(height: APPBAR_HEIGHT,),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                          (context,index){
                        return cnt_Myproperties.arrAllTheme[index].widget;
                      },
                      childCount: cnt_Myproperties.arrAllTheme.length!=0?cnt_Myproperties.arrAllTheme.length:0
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 150,),
                ),
              ],
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 70),

                  AddNewMembersFormData(),

                  SizedBox(height: 100.h),
                ],
              ),
            ),
            cnt_HeaderController.commonAppBar("Add New Members",
                cnt_Myproperties.GlobaladdNewMembersPagekey,isNotificationHide: false),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: BottomNavigationBarClass(),
            // )
          ],
        ),
      ),
      bottomNavigationBar:  BottomNavigationBarClass(),
    );
  }

  Widget AddNewMembersFormData(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 8,vertical: 20),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: BLACK.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 6,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Form(
        key: cnt_Myproperties.addNewMemberformkey,
        child: Column(
          children: [
            simpleTextFieldNewWithCustomization(
                hintText: "John",
                maxLength: 72,
                imageIcon: IMG_USER_SVG_NEW,
                textCapitalization: TextCapitalization.sentences,
                inputFormat: [
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                  UpperCaseTextFormatter()],
                controller: cnt_Myproperties.txtFirstNameNew,
                labelText: "First Name*",
                validator: (value) =>
                    validation(value, "Please enter first name")),
            SizedBox(
              height: 14.h,
            ),

            simpleTextFieldNewWithCustomization(

                hintText: "Doe",
                maxLength: 72,
                imageIcon: IMG_USER_SVG_NEW,
                textCapitalization: TextCapitalization.sentences,
                inputFormat: [
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                  UpperCaseTextFormatter()],
                controller: cnt_Myproperties.txtLastNameNew,
                labelText: "Last Name*",

                validator: (value) =>
                    validation(value, "Please enter last name")),
            SizedBox(height: 10.h,),
            PhoneNumberTextField(cnt_Myproperties.txtContactNew),
            SizedBox(height: 14.h,),
            simpleTextFieldNewWithCustomization(
                hintText: "johndoe@example.com",
                // imageIcon: IMG_MAIL_SVG,
                imageIcon: IMG_EMAIL_SVG_NEW,
                controller: cnt_Myproperties.txtEmailNew,
                labelText: "Email*",

                validator: (value) => emailvalidation(value)),
            SizedBox(height: 20.h,),
            _submit_Button(),
          ],
        ),
      ),
    );
  }

  Widget _submit_Button() {
    return OnTapButton(
        onTap: () {
          if(cnt_Myproperties.addNewMemberformkey.currentState!.validate()){

          }
        },
        height: 40,
        decoration: CustomDecorations().backgroundlocal(APP_THEME_COLOR, cornarradius, 0, APP_THEME_COLOR),
        text: "Submit".toUpperCase(),
        style: TextStyle(color: white, fontSize: 12, fontWeight: FontWeight.w500));
  }

}
