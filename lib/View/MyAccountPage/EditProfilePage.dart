import 'dart:io';

import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:Repeople/Widgets/TextEditField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:Repeople/Controller/MyAccountController/EditProfileController.dart';

class EditProfilePage extends StatefulWidget {
  final bool? isRegistered;
  const EditProfilePage({Key? key,this.isRegistered}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  CommonHeaderController cntCommonHeader = Get.put(CommonHeaderController());
  EditProfileController cntEditProfile = Get.put(EditProfileController());

  @override
  void initState() {
    // TODO: implement onInit
    super.initState();
    cntEditProfile.LoadData();
    cntEditProfile.isRegister.value=widget.isRegistered??false;
  }
  @override
  void dispose() {
    Get.delete<EditProfileController>();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    cntEditProfile.arrAllTheme.clear();
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_WHITE,
      key: cntEditProfile.GlobalEditProfilePagekey,
      endDrawer: CustomDrawer(
        animatedOffset: const Offset(1.0, 0),
      ),
      drawer: CustomDrawer(
        animatedOffset: const Offset(-1.0, 0),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: APPBAR_HEIGHT),
                  themeForm1(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            cntCommonHeader.commonAppBar(EDITPROFILE, cntEditProfile.GlobalEditProfilePagekey,color: white)
          ],
        ),
      ),
    );
  }
  Widget themeForm1() {
    return Container(
      color: AppColors.BACKGROUND_WHITE,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20,right: 20,top: 20),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: BLACK.withOpacity(0.1),
                  // spreadRadius: 0,
                  blurRadius: 4,
                  offset: const Offset(
                      0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                // SizedBox(height: 20,),
                // AccountLayout(),
                const SizedBox(height: 20,),
                editImageData(),
                const SizedBox(height: 10,),
                Form(
                  key: cntEditProfile.formKey,
                  child: Column(
                    children: [
                      simpleTextFieldNewWithCustomization(hintText: "John",
                          imageIcon: IMG_PROFILEUSER_SVG_DASHBOARD,
                          controller: cntEditProfile.txtFirstNameNew,
                          inputFormat: [UpperCaseTextFormatter()],
                          textInputType: TextInputType.name,
                          labelText: "First Name*",
                          textCapitalization: TextCapitalization.sentences,
                          validator: (value) =>
                              validation(value, "Please enter first name")),
                      const SizedBox(
                        height: 16,
                      ),
                      simpleTextFieldNewWithCustomization(hintText: "Doe",
                          imageIcon: IMG_PROFILEUSER_SVG_DASHBOARD,
                          controller: cntEditProfile.txtLastNameNew,
                          textInputType: TextInputType.name,
                          inputFormat: [UpperCaseTextFormatter()],
                          textCapitalization: TextCapitalization.sentences,
                          labelText: "Last Name*",
                          validator: (value) =>
                              validation(value, "Please enter last name")),
                      const SizedBox(
                        height: 16,
                      ),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          PhoneNumberTextField(
                              cntEditProfile.txtContactNew,true,false),
                          Positioned(
                              top: 26,
                              right: 0,
                              // alignment: Alignment.centerRight,
                              child: Obx(() => Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Image.asset(
                                    WHATSAPP_IMAGES,
                                    width: 20.w,
                                    height: 20.h,
                                  ),
                                  const SizedBox(width: 4),
                                  SizedBox(
                                    width: 40,
                                    height: 30,
                                    child: Switch(
                                      value: cntEditProfile.isWhatsAppSwitch.value,
                                      activeColor: DARK_BLUE,
                                      onChanged: (bool value) {
                                        cntEditProfile.isWhatsAppSwitch.value = value;
                                      },
                                    ),
                                  ),
                                ],
                              )))
                        ],
                      ),


                    ],
                  ),
                ),
                //SimpleTextField(IMG_ACCOUNT, "First Name*", "Enter", txtFirstName),
                const SizedBox(
                  height: 16,
                ),
                Stack(
                  children: [
                    alternatePhoneNumberTextField(
                        cntEditProfile.txtAlternateContactNew,false,true),
                    Positioned(
                        top: 26,
                        right: 0,
                        // alignment: Alignment.centerRight,
                        child: Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image.asset(
                              WHATSAPP_IMAGES,
                              width: 20.w,
                              height: 20.h,
                            ),
                            const SizedBox(width: 4),
                            SizedBox(
                              width: 40,
                              height: 30,
                              child: Switch(
                                value: cntEditProfile.isAlternateSwitch.value,
                                activeColor: DARK_BLUE,
                                onChanged: (bool value) {
                                  cntEditProfile.isAlternateSwitch.value = value;
                                },
                              ),
                            ),
                          ],
                        )))
                  ],
                ),
                // ContactTextField(txtAlternativeContactNew),
                const SizedBox(
                  height: 16,
                ),
                Form(
                  key: cntEditProfile.formKey2,
                  child: Column(
                    children: [

                      simpleTextFieldNewWithCustomization(
                          hintText: "johndoe@example.com",
                          imageIcon: IMG_MAIL_SVG,
                          controller: cntEditProfile.txtEmailNew,
                          textInputType: TextInputType.emailAddress,
                          labelText: "Email*",
                          validator: (value) =>
                              emailvalidation(value)),

                      const SizedBox(
                        height: 16,
                      ),
                      CommonDropDownTextField(
                          labelText: "Email Type*",
                          onTap: (){
                            cntEditProfile.selectEmailType();
                          },
                          imageIcon: IMG_DOLLAR_SVG,
                          controller: cntEditProfile.txtEmailType,
                          hintText: cntEditProfile.txtEmailType.text,
                          validator: (value)=>validation(value,"Please select email type")
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      CommonDropDownTextField(
                          labelText: "Profession*",
                          onTap: (){
                            cntEditProfile.selectProfession();
                          },
                          imageIcon: IMG_DOLLAR_SVG,
                          controller: cntEditProfile.txtProfession,
                          hintText: cntEditProfile.txtProfession.text,
                          validator: (value)=>validation(value,"Please select profession")
                      ),
                      const SizedBox(height: 16),
                      DropDownDOB(IMG_CALENDERDATE_SVG, "Date of Birth*", "Select Date of Birth", cntEditProfile.txtDobnew,),
                      const SizedBox(height: 16),
                      DropDownAnniversary(IMG_CALENDERDATE_SVG, "Anniversary*", "Select Anniversary", cntEditProfile.txtAnniversarynew),
                      const SizedBox(height: 20,),
                    ],
                  ),
                ),


                saveButton(),


              ],
            ),
          ),

        ],
      ),
    );
  }


  Widget editImageData(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Profile Photo",style:
        TextStyle(
            fontSize: 12.sp,
            color:gray_color_1,
            fontFamily: fontFamily,
            fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Obx(() => cntEditProfile.image.value!=""||profile_pic.value!="" ? Obx(() => Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 72.w,
                  height: 70.w,
                  decoration: BoxDecoration(
                    color: DARK_BLUE.withOpacity(0.2),
                    borderRadius:
                    const BorderRadius.all(Radius.circular(4)),
                  ),
                  child:
                  cntEditProfile.image.value!="" ?
                  Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4)
                      ),
                      child: Image.file(File(cntEditProfile.image.value),fit: BoxFit.cover,))
                      :
                  Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(

                          borderRadius: BorderRadius.circular(4)
                      ),
                      child: Image(image: NetworkImage(
                          profile_pic.value),
                          fit: BoxFit.cover)),
                ),
                Positioned(
                  top: -16.0,
                  right: -16.0,
                  child:  IconButton(
                      color: AppColors.BLACK,
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.cancel,
                      ),
                      onPressed: () {
                        profile_pic.value!=null;
                        profile_pic.value="";
                        cntEditProfile.image.value!=null;
                        cntEditProfile.image.value="";
                        profile_pic.refresh();
                        cntEditProfile.image.refresh();
                      }),
                )
              ],
            )) :GestureDetector(
              onTap: () {
                cntEditProfile.profileImagePicker();
              },
              child: Container(
                width: 72.w,
                height: 70.h,
                // margin: EdgeInsets.only(right: 9.w,bottom: 9.h),
                decoration: BoxDecoration(
                  color: DARK_BLUE.withOpacity(0.2),
                  borderRadius:BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    "+ADD",
                    style: TextStyle(
                        color: DARK_BLUE,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: fontFamily),
                  ),
                ),
              ),
            )),

          ],
        ),

        const SizedBox(height: 8,),
        Divider(color: gray_color_1,thickness: 1,),
      ],
    );
  }

  Widget accountLayout() {
    return Stack(
        clipBehavior: Clip.none,
        children: [
          Card(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 80),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(cornarradius)),
              ),
              elevation: 3,
              shadowColor: hex("266CB5").withOpacity(0.03),
              child: Container(
                  alignment: Alignment.bottomCenter,
                  width: double.infinity,
                  padding:
                  const EdgeInsets.only(bottom: 20, top: 70, left: 30, right: 30),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10,),
                        Obx(() => Text(
                          cntEditProfile.obj_userprofiledetails.value.personname??"",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        )),
                        const SizedBox(
                          height: 5,
                        ),

                      ]))),
          Positioned(left: 0, right: 0, bottom: 70, child: accountInfoData()),

        ]);
  }

  Widget accountInfoData() {

    return Column(
      //crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Obx(() {
                return   Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(55),
                      border: Border.all(color: AppColors.BACKGROUND_WHITE,width: 5)
                  ),
                  child:
                  cntEditProfile.image.value!="" ?
                  //Image.network(image.value)
                  Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle
                        //borderRadius: BorderRadius.circular(10)
                      ),
                      child: Image.file(File(cntEditProfile.image.value),fit: BoxFit.cover,))
                      :
                  Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle
                        //borderRadius: BorderRadius.circular(10)
                      ),
                      child: Image(image: NetworkImage(
                          profile_pic.value),
                          fit: BoxFit.cover)),
                );
              }),

              Positioned(
                bottom: 0,
                right: 5,
                child: InkWell(
                  hoverColor: AppColors.TRANSPARENT,
                  splashColor: AppColors.TRANSPARENT,
                  highlightColor: AppColors.TRANSPARENT,
                  onTap: (){
                    cntEditProfile.profileImagePicker();
                  },
                  child: Container(
                      width:30,
                      height: 30,
                      decoration: CustomDecorations().backgroundlocal(
                          APP_THEME_COLOR, 50, 0, APP_THEME_COLOR),
                      child: Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: SvgPicture.asset(
                          IMG_CAMERA_SVG_NEW,
                          fit: BoxFit.contain,
                          color: white,),
                      )

                  ),
                ),
              )
            ],
          ),
        ]);
  }

  Widget saveButton() {
    return Padding(padding: const EdgeInsets.symmetric
      (horizontal: 0,vertical: 10),child: OnTapButton(
        onTap: () {
          if(cntEditProfile.formKey.currentState!.validate()&&cntEditProfile.formKey2.currentState!.validate()){
            cntEditProfile.editProfile();
          }
        },
        height: 40.w,
        decoration: CustomDecorations().backgroundlocal(APP_THEME_COLOR, cornarradius, 0, APP_THEME_COLOR),
        text: "Save".toUpperCase(),
        style: TextStyle(color: white, fontFamily: fontFamily,fontWeight: FontWeight.w500, fontSize: 14.sp)));
  }

}
