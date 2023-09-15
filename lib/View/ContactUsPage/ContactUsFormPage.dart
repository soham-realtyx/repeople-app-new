import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Controller/ContactController/ContactUsController.dart';
import 'package:Repeople/Controller/ContactController/ContactUsFormcontroller.dart';
import 'package:Repeople/View/DashboardPage/BottomnavigationBar.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:Repeople/Widgets/TextEditField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/utils/colors.dart';
import '../../Controller/CommonHeaderController/CommenHeaderController.dart';


class ContactUsFormPage extends StatefulWidget {
  const ContactUsFormPage({Key? key}) : super(key: key);

  @override
  State<ContactUsFormPage> createState() => _ContactUsFormPageState();
}

class _ContactUsFormPageState extends State<ContactUsFormPage> {
  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());
  ContactUsController cnt_ContactUs = Get.put(ContactUsController());
  ContactUsFormController cnt_ContactForm = Get.put(ContactUsFormController());
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_WHITE,
      resizeToAvoidBottomInset: true,
      key: cnt_ContactForm.GlobalContactsusformkey,
      endDrawer: CustomDrawer(
        animatedOffset: Offset(1.0, 0),
      ),
      drawer: CustomDrawer(
        animatedOffset: Offset(-1.0, 0),
      ),

      body: SafeArea(
        child: Stack(
          children: [
            NotificationListener<OverscrollIndicatorNotification> (
              child: ContactUs_Form_1(),
              onNotification: (overscroll) {
                overscroll.disallowIndicator();
                return true;
              },
            ),
            //cnt_cmt.Commitee_header("Committee", commitpagekey),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.BACKGROUND_WHITE,
                  boxShadow: [BoxShadow(color: hex("266CB5").withOpacity(0.1),offset: Offset(1,1),blurRadius: 5,spreadRadius: 3),],
                ),
                // color: AppColors.BACKGROUND_WHITE,
                padding: const EdgeInsets.only(left: 20, right: 20,top: 20,bottom: 20),
                child: SubmitButton_4(),
              ),),
            cnt_CommonHeader.commonAppBar(CONTACTUS, cnt_ContactForm.GlobalContactsusformkey,color: white),


          ],
        ),
      ),
      bottomNavigationBar:BottomNavigationBarClass() ,
    );
  }

  Widget ContactUs_Form_1(){
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(left: 0, right: 0),
        child: Form(
          key: cnt_ContactForm.formkey,
          child: Column(
            children: [
              simpleTextFieldNewWithCustomization(
                hintText: "John",
                maxLength: 72,
                imageIcon: IMG_USER_SVG_NEW,
                controller: cnt_ContactForm.txtFirstNameNew,
                inputFormat: [
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                  UpperCaseTextFormatter()],
                textCapitalization: TextCapitalization.sentences,
                textInputType: TextInputType.name,
                labelText: "First Name*",
                validator: (value) =>
                    validation(value, "Please enter first name"),
              ),

              SizedBox(
                height: 16,
              ),
              simpleTextFieldNewWithCustomization(
                  hintText: "Doe",
                  maxLength: 72,
                  imageIcon: IMG_USER_SVG_NEW,
                  inputFormat: [
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                    UpperCaseTextFormatter()],
                  controller: cnt_ContactForm.txtLastNameNew,
                  textInputType: TextInputType.name,
                  textCapitalization: TextCapitalization.sentences,
                  labelText: "Last Name*",
                  validator: (value) =>
                      validation(value, "Please enter last name")),


              SizedBox(
                height: 16,
              ),


              simpleTextFieldNewWithCustomization(
                  hintText: "johndoe@example.com",
                  imageIcon: IMG_EMAIL_SVG_NEW,
                  controller: cnt_ContactForm.txtEmailNew,
                  textInputType: TextInputType.emailAddress,
                  labelText: "Email*",
                  inputFormat: [
                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z@.]")),
                  ],
                  noAutoValidation: true,
                  validator: (value) => emailvalidation(value)),

              SizedBox(
                height: 16,
              ),
              //ContactTextField(txtContactNew),
              PhoneNumberTextField(cnt_ContactForm.txtContactNew),
              SizedBox(
                height: 16,
              ),
              CommonDropDownTextField(
                  labelText: "Subject*",
                  onTap: (){
                    cnt_ContactForm.SelectSubject();
                  },
                  // imageIcon: IMG_PROJECT_SVG_NEW,
                  imageIcon: IMG_SUBJECT_SVG_NEW,
                  controller: cnt_ContactForm.txtSubject,
                  hintText: cnt_ContactForm.txtSubject.text,
                  validator: (value)=> validation(value, "Please select subject")
              ),


              SizedBox(
                height: 16,
              ),

              QueryTextField_2a(cnt_ContactForm.txtQueryNew),

              SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget QueryTextField_2a(Rxn<TextEditingController>? controller) {
    return Obx(() =>TextFormField(
      maxLines: 2,
      controller: controller?.value,
      onChanged: (value){
        controller?.update((val) { });
      },
      validator:(value)=> validation(value, "Please enter message"),
      style: boldTextStyle(fontSize: 18, txtColor: APP_FONT_COLOR),
      decoration: InputDecoration(
        enabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: LIGHT_GREY)),
        focusedBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: LIGHT_GREY)),
        errorBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        disabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        focusedErrorBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        // border: InputBorder.none,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: "Message*",
        hintText: "",
        labelStyle: TextStyle(
          fontSize: 16,
          color:
          controller!.value!.text.toString().isNotEmpty? Colors.grey.withOpacity(0.7):
          Colors.black.withOpacity(0.7),
          // Colors.black.withOpacity(0.7),
          // fontWeight: FontWeight.bold
        ),
        hintStyle: TextStyle(color: LIGHT_GREY),
        contentPadding: EdgeInsets.all(20),

      ),
    ));
  }

  Widget SubmitButton_4() {
    return OnTapButton(
        onTap: () {
          if (cnt_ContactForm.formkey.currentState!.validate() ) {
            cnt_ContactForm.submitContactUsQuery();
          }
        },
        height: 40,
        decoration: CustomDecorations()
            .backgroundlocal(APP_THEME_COLOR, cornarradius, 0, APP_THEME_COLOR),
        text: "Submit",
        style:
        TextStyle(color: white, fontSize: 14, fontWeight: FontWeight.w600));
  }
}
