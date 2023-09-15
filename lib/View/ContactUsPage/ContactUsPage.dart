import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Controller/ContactController/ContactUsController.dart';
import 'package:Repeople/Controller/ContactController/ContactUsFormcontroller.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:Repeople/Widgets/CustomDrawer/CustomDrawer.dart';
import 'package:Repeople/Widgets/ShimmerWidget.dart';
import 'package:Repeople/Widgets/TextEditField.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../Config/utils/colors.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  CommonHeaderController cntCommonHeader = Get.put(CommonHeaderController());
  ContactUsController cntContactUs = Get.put(ContactUsController());
  ContactUsFormController cntContactForm = Get.put(ContactUsFormController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_WHITE,
      resizeToAvoidBottomInset: true,
      key: cntContactUs.GlobalContactskey,
      endDrawer: CustomDrawer(
        animatedOffset: const Offset(1.0, 0),
      ),
      drawer: CustomDrawer(
        animatedOffset: const Offset(-1.0, 0),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            //
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  display1(),
                  const SizedBox(height: APPBAR_HEIGHT),
                ],
              ),
            ),
            cntCommonHeader.commonAppBar(CONTACTUS, cntContactUs.GlobalContactskey,color: white),


          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBarClass(),
    );
  }
  Widget display1() {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(left: 20,right: 20,top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: APPBAR_HEIGHT),
            Obx(() =>
            cntContactUs.loded.value?
                Stack(
                  children: [
                    Container(
                        height: 185.h,
                        width: Get.width,
                        decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(color: white,width: 1.5)
                        ),
                        child: googleMap2()
                    ),
                  ],
                )
                : ShimmerEffect(child: shimmerWidget( height: 185.h,
                width: Get.width,radius: 7))),
            const SizedBox(height: 20),
            contactUSForm(),
          ],
        ),
      ),
    );
  }

  Widget contactUSForm(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 20),
      decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [fullcontainerboxShadow]
      ),
      child: Form(
        key: cntContactForm.formkey,
        child: Column(
          children: [
            simpleTextFieldNewWithCustomization(
              hintText: "John",
              maxLength: 72,
              imageIcon: IMG_USER_SVG_NEW,
              controller: cntContactForm.txtFirstNameNew,
              inputFormat: [
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                UpperCaseTextFormatter()],
              textCapitalization: TextCapitalization.sentences,
              textInputType: TextInputType.name,
              labelText: "First Name*",
              validator: (value) =>
                  validation(value, "Please enter first name"),
            ),

            const SizedBox(
              height: 16,
            ),
            simpleTextFieldNewWithCustomization(
                hintText: "Doe",
                maxLength: 72,
                imageIcon: IMG_USER_SVG_NEW,
                inputFormat: [
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                  UpperCaseTextFormatter()],
                controller: cntContactForm.txtLastNameNew,
                textInputType: TextInputType.name,
                textCapitalization: TextCapitalization.sentences,
                labelText: "Last Name*",
                validator: (value) =>
                    validation(value, "Please enter last name")),


            const SizedBox(
              height: 16,
            ),


            simpleTextFieldNewWithCustomization(
                hintText: "johndoe@example.com",
                imageIcon: IMG_EMAIL_SVG_NEW,
                controller: cntContactForm.txtEmailNew,
                textInputType: TextInputType.emailAddress,
                labelText: "Email*",
                inputFormat: [
                  FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z@.]")),
                ],
                noAutoValidation: true,
                validator: (value) => emailvalidation(value)),

            const SizedBox(
              height: 16,
            ),

            PhoneNumberTextField(cntContactForm.txtContactNew),

            const SizedBox(
              height: 16,
            ),

            CommonDropDownTextField(
                labelText: "Subject*",
                onTap: (){
                  cntContactUs.SelectSubject();
                },
                // imageIcon: IMG_PROJECT_SVG_NEW,
                imageIcon: IMG_SUBJECT_SVG_NEW,
                controller: cntContactForm.txtSubject,
                hintText: cntContactForm.txtSubject.text,
                validator: (value)=> validation(value, "Please select subject")
            ),
            const SizedBox(
              height: 16,
            ),
            messageTextField(cntContactForm.txtQueryNew),

            const SizedBox(
              height: 24,
            ),
            submitButton(),

          ],
        ),
      ),
    );
  }


  Widget messageTextField(Rxn<TextEditingController>? controller) {
    return Obx(() =>TextFormField(
      maxLines: 2,
      controller: controller?.value,
      onChanged: (value){
        controller?.update((val) { });
      },
      validator:(value)=> validation(value, "Please enter message"),
      style: boldTextStyle(fontSize: 16, txtColor: APP_FONT_COLOR),
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: gray_color_1)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: gray_color_1)),
        errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        disabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        focusedErrorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: "Message*",
        hintText: "",
        labelStyle: TextStyle(
            fontSize: 14.sp,
            color:gray_color_1,
            fontFamily: fontFamily,
            fontWeight: FontWeight.w500),
        hintStyle: TextStyle(color: LIGHT_GREY),
      ),
    ));
  }

  Widget submitButton() {
    return OnTapButton(
        onTap: () {
          if (cntContactForm.formkey.currentState!.validate() ) {
            cntContactForm.submitContactUsQuery();
          }
        },
        height: 40,
        decoration: CustomDecorations()
            .backgroundlocal(APP_THEME_COLOR, cornarradius, 0, APP_THEME_COLOR),
        text: "Submit".toUpperCase(),
        style:
        TextStyle(color: white, fontSize: 12.sp,fontFamily: fontFamily, fontWeight: FontWeight.w700));
  }

  Widget googleMap2() {
    return Container(
      height: 185.h,
      width: Get.width,
      decoration: CustomDecorations().backgroundlocal(white, cornarradius, 2.5, white),
      child: ClipRRect(borderRadius: BorderRadius.circular(cornarradius),child:
      GoogleMap(
        gestureRecognizers: Set()
          ..add(Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer()))
          ..add(Factory<PanGestureRecognizer>(() =>
              PanGestureRecognizer()))
          ..add(Factory<ScaleGestureRecognizer>(() =>
              ScaleGestureRecognizer()))
          ..add(Factory<TapGestureRecognizer>(() =>
              TapGestureRecognizer()))
          ..add(Factory<VerticalDragGestureRecognizer>(
                  () => VerticalDragGestureRecognizer())),
        initialCameraPosition:
        CameraPosition(target: cntContactUs.currentLocation, zoom: 10),
        // markers: Set<Marker>.of(markerValue.values),
        markers: cntContactUs.markers,
        zoomControlsEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          cntContactUs.googleMapController = controller;
        },
      ),),
    );
  }
}
