import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Helper/HextoColor.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';

import 'CountryCodeDialog.dart';
import 'IntelCountryCode.dart';

String ccode = "91";
String isocode = "IN";
RxString isocode1 = "INDIA".obs;

typedef void OnTapPress();
typedef void OnChange(String value);
DateTime currentData = DateTime.now();
Future<TimeOfDay?> currenttime = Future(() => TimeOfDay.now());
TextEditingController txtDob = TextEditingController();
TextEditingController txtAnniversary = TextEditingController();

// TextEditingController txtscheduletime = TextEditingController();
Rxn<TextEditingController> txtscheduletime = Rxn(TextEditingController());
Rxn<TextEditingController> txtscheduledate = Rxn(TextEditingController());
FocusNode mobileFocusNode = FocusNode();
Rx<Country> selectedCountry = countryIndia().obs;
RxString countrystr = "IN".obs;
RxString countrycode = "+91".obs;
// TextEditingController txtscheduledate = TextEditingController();

TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
String? _hour, _minute, _time;



class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: capitalize(newValue.text),
      selection: newValue.selection,
    );
  }
}
  String capitalize(String value) {
    if(value.trim().isEmpty) return "";
    return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
  }
// @override
// void dispose() {
//   // TODO: implement dispose
//   //super.dispose();
//   isocode1.value.toString();
//   //Get.delete<DashboardController>();
// }

Widget SimpleTextField(
  String imageIcon,
  String labelText,
  String hintText,
  TextEditingController controller, [
  double leftIconPadding = 0,
  bool labelAlwaysOpen = true,
  bool isFocus = false,
  String? Function(String?)? validator,
]) {
  return TextFormField(
    autovalidateMode: AutovalidateMode.onUserInteraction,
    controller: controller,
    validator: validator,
    style: boldTextStyle(fontSize: 16, txtColor: APP_FONT_COLOR),
    decoration: InputDecoration(
        border: InputBorder.none,
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: gray_color_1)),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: LIGHT_GREY)),
        errorBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        disabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        focusedErrorBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        contentPadding: EdgeInsets.all(20),
        labelStyle: /*labelAlwaysOpen
            ? TextStyle(
                fontSize: 16,
                color: Colors.black.withOpacity(0.7),
                fontWeight: FontWeight.bold)
            : isFocus
                ? TextStyle(fontWeight: FontWeight.bold, color: APP_FONT_COLOR)
                : null*/
        TextStyle(
            fontSize: 14.sp,
            color:gray_color_1,
            fontFamily: fontFamily,
            fontWeight: FontWeight.w500),
        labelText: labelText,
        hintText: hintText,
        hintStyle: TextStyle(
            fontSize: 16.sp,
            fontFamily: fontFamily,
            color: Colors.grey.withOpacity(0.8),
            fontWeight: FontWeight.w700),
        focusColor: Colors.white,
        floatingLabelBehavior: labelAlwaysOpen
            ? FloatingLabelBehavior.always
            : FloatingLabelBehavior.auto,
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: leftIconPadding),
          child: Container(
            width: 50,
            height: 50,
            margin: EdgeInsets.only(right: 10),
            padding: const EdgeInsets.all(10.0),
            decoration: CustomDecorations().backgroundlocal(
                APP_GRAY_COLOR, cornarradius, 0, APP_GRAY_COLOR),
            child: Image.asset(imageIcon),
          ),
        )),
  );
}

Widget SimpleTextFieldNew(
     {OnTapPress? onTap,
    bool autoFocus = false,
    String? imageIcon,
    String? labelText,
    String? hintText,
    Color? labelcolor,
    TextEditingController? controller,
    List<TextInputFormatter>? inputformat,
    String? Function(String?)? validator,
    String? Function(String?)? onChanged,
    String? Function(String?)? onFieldSubmitted,
    TextInputType? textInputType,
    int? maxLength,
    int maxline = 1,
    double leftIconPadding = 0,
    bool labelAlwaysOpen = true,
    bool noautovalidation=false,
    bool isFocus = false} ) {
  return TextFormField(
    style: boldTextStyle(fontSize: 16, txtColor: APP_FONT_COLOR),
    // TextStyle(fontSize: 18, color: APP_FONT_COLOR, fontWeight: FontWeight.bold),
    autovalidateMode: noautovalidation?AutovalidateMode.disabled:AutovalidateMode.onUserInteraction,
    onTap: onTap,

    onChanged: onChanged,
    onFieldSubmitted: onFieldSubmitted,
    maxLength: maxLength,
    validator: validator,
    keyboardType: textInputType,
    controller: controller,
    decoration: InputDecoration(
        border: InputBorder.none,
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: gray_color_1)),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: LIGHT_GREY)),
        errorBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        disabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        focusedErrorBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        enabled: true,
        contentPadding: EdgeInsets.all(20),
        labelStyle:
        // labelAlwaysOpen
        //     ?
        TextStyle(
            fontSize: 14.sp,
            color:gray_color_1,
            fontFamily: fontFamily,
            fontWeight: FontWeight.w500),
            // : isFocus
            //     ? TextStyle(fontWeight: FontWeight.bold, color: APP_FONT_COLOR)
            //     : null,
        // labelStyle: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.7),
        //     fontWeight: FontWeight.bold),

        // : isFocus
        // ? TextStyle(fontWeight: FontWeight.bold, color: APP_FONT_COLOR)
        // : null,
        labelText: labelText,
        hintText: hintText,
        hintStyle: TextStyle(
            fontSize: 16.sp,
            color: Colors.grey.withOpacity(0.8),
            fontWeight: FontWeight.bold),
        focusColor: Colors.white,
        floatingLabelBehavior: labelAlwaysOpen
            ? FloatingLabelBehavior.always
            : FloatingLabelBehavior.auto,
        //  floatingLabelBehavior:
        // FloatingLabelBehavior.always,
        // prefixIcon: imageIcon!=""?Padding(
        //   padding: EdgeInsets.only(left: 0),
        //   child: Container(
        //     width: 50,
        //     height: 50,
        //     margin: EdgeInsets.only(right: 10),
        //     padding: const EdgeInsets.all(10.0),
        //     decoration: CustomDecorations()
        //         .backgroundlocal(APP_GRAY_COLOR, cornarradius, 0, APP_GRAY_COLOR),
        //     child: Image.asset(imageIcon ?? ""),
        //   ),
        // ):Container(width: 1,height: 1,)
        // prefixIcon: Padding(
        //   padding: EdgeInsets.only(left: leftIconPadding),
        //   child: Container(
        //     width: 50,
        //     height: 50,
        //     margin: EdgeInsets.only(right: 10),
        //     padding: const EdgeInsets.all(10.0),
        //     decoration: CustomDecorations().backgroundlocal(
        //         APP_GRAY_COLOR, cornarradius, 0, APP_GRAY_COLOR),
        //     child: imageIcon.toString().contains("svg")
        //         ? SvgPicture.asset(imageIcon ?? "")
        //         : Image.asset(imageIcon ?? ""),
        //   ),
        // )
    ),
  );
}

Widget OutlineTextField(
    {OnTapPress? onTap,
      bool autoFocus = false,
      TextEditingController? controller,
      bool readOnly = false,
      Color cursorColor = Colors.black,
      Color borderColor = Colors.black,
      String hintText = "",
      TextStyle? hintStyle,
      Widget? prefix,
      Widget? suffix,
      TextInputType? textInputType,
      EdgeInsetsGeometry? padding,
      String? errorText = "",
      String? Function(String?)? validator,
      int? maxLength}) {
  return TextFormField(
    onTap: onTap ?? null,
    autofocus: autoFocus,
    textAlign: TextAlign.left,
    maxLength: maxLength,
    keyboardType: textInputType,
    style: boldTextStyle(fontSize: 16, txtColor: APP_FONT_COLOR),
    validator: validator,
    readOnly: readOnly,
    controller: controller,
    cursorColor: cursorColor,
    textInputAction: TextInputAction.done,
    decoration: InputDecoration(
      counterText: "",
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: gray_color_1,width: 1)),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color:gray_color_1)),
      errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red)),
      disabledBorder: UnderlineInputBorder(
          borderSide:  BorderSide(color: Colors.red)),
      focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red)),
      hintText: hintText,
      hintStyle: hintStyle,
      prefixIcon: prefix ?? null,
      suffixIcon: suffix ?? null,
    ),
  );
}

Widget PhoneNumberTextField(Rxn<TextEditingController>? controller,[bool? readonly=false,bool? showcursor=true,bool? isPrefix=true,Widget? prefixIcons]) {

  return IntlPhoneCustomField(
    readOnly: readonly??false,
    showCursor: showcursor??true,
    controller: controller?.value,
    disableLengthCheck: false,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    textAlign: TextAlign.left,
    focusNode: mobileFocusNode,
    autofocus: false,
    mobilNo: false,
    keyboardType: TextInputType.number,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    textAlignVertical: TextAlignVertical.bottom,
    selectedCountry: selectedCountry.value,
    flagsButtonPadding: const EdgeInsets.only(left: 0),
    validator:(value)=>mobilevalidation(value!),

    onSubmitted: (value) {

    },
    style:  boldTextStyle(fontSize: 16, txtColor: APP_FONT_COLOR),
    dropdownIconPosition: IconPosition.trailing,
    dropdownIcon: Icon(Icons.arrow_drop_down,color: hex("#898989"),size: 26.h),
    dropdownTextStyle:boldTextStyle(fontSize: 16, txtColor: APP_FONT_COLOR),
    showCountryFlag: false,
    hintText: "9876543210",
    hintStyle: TextStyle(
        height: 1.3,
        fontSize: 16.sp,
        fontFamily: fontFamily,
        color: HexColor("#898989"),
        fontWeight: FontWeight.w700),
      pickerDialogStyle: PickerDialogCustomStyle(
      backgroundColor: AppColors.BACKGROUND_WHITE,
      countryCodeStyle:
      mediumTextStyle(fontSize: 14, txtColor: APP_FONT_COLOR),
      searchFieldCursorColor: AppColors.BLACK,
      countryNameStyle:
      mediumTextStyle(fontSize: 14, txtColor: APP_FONT_COLOR),
      listTileDivider: Container(
        height: 0.8,
        color: AppColors.grey_color,
      ),
    ),
    initialCountryCode: 'IN',
    cursorColor: AppColors.BLACK,
    onChanged: (phone) {
      countrystr.value = phone.countryISOCode;
      countrycode.value = phone.countryCode;
      if (controller!.value!.text.isNotEmpty){

      }
    },
    onCountryChanged: (country) {
      selectedCountry.value = country;
      controller?.value?.text = "";
    },

    decoration: InputDecoration(
      counterText: "",
      contentPadding: const EdgeInsets.only(bottom: 15),
      hintText: "9876543210",
      hintStyle: TextStyle(
          height: 1.8,
          fontSize: 16.sp,
          fontFamily: fontFamily,
          color: HexColor("#898989"),
          fontWeight: FontWeight.w700),
      // suffixIcon:
      // isPrefix!
      //     ? prefixIcons
      //     : Container(),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: gray_color_1)),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: LIGHT_GREY)),
      errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red)),
      disabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red)),
      focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red)),
      //labelText: 'Email',
    ),
  );
}

Widget alternatePhoneNumberTextField(Rxn<TextEditingController>? controller,[bool? readonly=false,bool? showCursor=true]) {

  return IntlPhoneCustomField(
    readOnly: readonly??false,
    showCursor: showCursor??true,
    controller: controller?.value,
    disableLengthCheck: false,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    textAlign: TextAlign.left,
    focusNode: mobileFocusNode,
    autofocus: false,
mobilNo: true,
    keyboardType: TextInputType.number,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    textAlignVertical: TextAlignVertical.bottom,
    selectedCountry: selectedCountry.value,
    flagsButtonPadding: const EdgeInsets.only(left: 0),
    validator:(value)=>mobilevalidation(value!),

    onSubmitted: (value) {

    },
    style:  boldTextStyle(fontSize: 16, txtColor: APP_FONT_COLOR),
    dropdownIconPosition: IconPosition.trailing,
    dropdownIcon: Icon(Icons.arrow_drop_down,color: hex("#898989"),size: 26.h),
    dropdownTextStyle:boldTextStyle(fontSize: 16, txtColor: APP_FONT_COLOR),
    showCountryFlag: false,
    hintText: "9876543210",
    hintStyle: TextStyle(
        height: 1.8,
        fontSize: 16.sp,
        fontFamily: fontFamily,
        color: HexColor("#898989"),
        fontWeight: FontWeight.w700),
    pickerDialogStyle: PickerDialogCustomStyle(
      backgroundColor: AppColors.BACKGROUND_WHITE,
      countryCodeStyle:
      mediumTextStyle(fontSize: 14, txtColor: APP_FONT_COLOR),
      searchFieldCursorColor: AppColors.BLACK,
      countryNameStyle:
      mediumTextStyle(fontSize: 14, txtColor: APP_FONT_COLOR),
      listTileDivider: Container(
        height: 0.8,
        color: AppColors.grey_color,
      ),
    ),
    initialCountryCode: 'IN',
    cursorColor: AppColors.BLACK,
    onChanged: (phone) {
      countrystr.value = phone.countryISOCode;
      countrycode.value = phone.countryCode;
      if (controller!.value!.text.isNotEmpty){

      }
    },
    onCountryChanged: (country) {
      selectedCountry.value = country;
      controller?.value?.text = "";
    },

    decoration: InputDecoration(
      counterText: "",
      contentPadding: const EdgeInsets.only(bottom: 15),
      hintText: "9876543210",
      hintStyle: TextStyle(
          height: 1.8,
          fontSize: 16.sp,
          fontFamily: fontFamily,
          color: HexColor("#898989"),
          fontWeight: FontWeight.w700),
      // suffixIcon:
      // isPrefix!
      //     ? prefixIcons
      //     : Container(),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: gray_color_1)),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: LIGHT_GREY)),
      errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red)),
      disabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red)),
      focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red)),
      //labelText: 'Email',
    ),
  );
}

Widget simpleTextFieldNewWithCustomization(
    {OnTapPress? onTap,
      bool autoFocus = false,
      String? imageIcon,
      String? labelText,
      String? hintText,
      Color? labelColor,
      Rxn<TextEditingController>? controller,
      TextCapitalization? textCapitalization,
      List<TextInputFormatter>? inputFormat,
      String? Function(String?)? validator,
      String? Function(String?)? onChanged,
      String? Function(String?)? onFieldSubmitted,
      TextInputType? textInputType,
      Widget? suffixIcon,
      int? maxLength,
      int maxLine = 1,
      double leftIconPadding = 0,
      bool labelAlwaysOpen = true,
      bool noAutoValidation=false,
      bool isSuffixIcon=false,
      bool isFocus = false} ) {
  return Obx(() =>   TextFormField(
    style: boldTextStyle(fontSize: 16, txtColor: APP_FONT_COLOR),
    autovalidateMode:
    noAutoValidation?AutovalidateMode.disabled:AutovalidateMode.onUserInteraction,
    onTap: onTap,

    onChanged: onChanged ?? (value){
      controller?.update((val) { });
    },
    // textCapitalization: TextCapitalization.sentences,
    textCapitalization: textCapitalization??TextCapitalization.none,
    onFieldSubmitted: onFieldSubmitted,
    maxLength: maxLength,
    validator: validator,

    keyboardType: textInputType,
    inputFormatters: inputFormat,
    controller: controller?.value,
    decoration: InputDecoration(
      // counter: Container(),
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
      enabled: true,
      // contentPadding: EdgeInsets.all(20),
      labelStyle:  TextStyle(
          fontSize: 14.sp,
          color:gray_color_1,
          fontFamily: fontFamily,
          fontWeight: FontWeight.w500),
      labelText: labelText,
      hintText: hintText,
      hintStyle: TextStyle(
          height: 1.8,
          fontSize: 16.sp,
          fontFamily: fontFamily,
          color: HexColor("#898989"),
          fontWeight: FontWeight.w700),
      focusColor: Colors.white,
      floatingLabelBehavior: labelAlwaysOpen
          ? FloatingLabelBehavior.always
          : FloatingLabelBehavior.auto,
      suffixIcon: isSuffixIcon==true?suffixIcon:const SizedBox(),
    ),
  ));
}

String? mobilevalidation(String value) {
  print(isocode1.value.toString());
  print("isocode1.value.toString()");
  if (value.isEmpty) {
    return "       "+"Please enter mobile number";
  } else if (value.trim().isNotEmpty && !value.trim().isNumberOnly()) {
    return "       "+"Please enter only digits";
  } else if (value.length < 10) {
    return "       "+"Please enter 10 digits";
  } else if (value.length > 10) {
    return "       "+"Please enter only 10 digits";
  } else if (isocode1.isEmpty || isocode1.value=="INDIA") {
    return "       "+"Please select country code";
  } else {
    return null;
  }
}


Widget CommonDropDownTextField(
    {OnTapPress? onTap,
      bool autoFocus = false,
      String? imageIcon,
      String? labelText,
      String? hintText,
      TextEditingController? controller,
      List<TextInputFormatter>? inputformat,
      String? Function(String?)? validator,
      String? Function(String?)? onChanged,
      String? Function(String?)? onFieldSubmitted,
      TextInputType? textInputType,
      int? maxLength,
      int maxline = 1,
      double leftIconPadding = 0,
      bool labelAlwaysOpen = true,
      bool noautovalidation=false,
      double padding=0,
      bool isFocus = false}) {
  return TextFormField(
    onTap: onTap,
    style: boldTextStyle(fontSize: 16, txtColor: APP_FONT_COLOR),
    // TextStyle(fontSize: 18, color: APP_FONT_COLOR, fontWeight: FontWeight.w600),
    readOnly: true,
    controller: controller,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: validator,

    // validator: (value) =>
    //     validation(value, "Please select project"),
    decoration: InputDecoration(
        border: InputBorder.none,
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: gray_color_1)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: gray_color_1)),
        errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        disabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        focusedErrorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),

        labelStyle:  TextStyle(
            fontSize: 14.sp,
            color:gray_color_1,
            fontFamily: fontFamily,
            fontWeight: FontWeight.w500),
        labelText: labelText,
        hintText: hintText,
        hintStyle:  TextStyle(
            height: 1.8,
            fontSize: 16.sp,
            fontFamily: fontFamily,
            color: HexColor("#898989"),
            fontWeight: FontWeight.w700),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIconConstraints: const BoxConstraints(maxWidth: 30,minWidth: 10 ),
        // prefixIconConstraints: BoxConstraints(maxWidth: 50),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child:
          SvgPicture.asset(IMG_DROPDOWN_SVG_2,height: 24,width: 24,)
          //Icon(Icons.arrow_drop_down),
        )
    ),
  );
}


Widget ContactTextField(
    Rxn<TextEditingController> controller, [
      double leftPadding = 0,
      bool labelOpen = true,
      bool hasFocus = false,
      bool padding = false,
      String? Function(String?)? onChanged,
    ]) {
  return Obx(() =>  TextFormField(
    onChanged: onChanged ?? (value){
      print("im here value is changed");
      controller.update((val) { });
    },
    autovalidateMode: AutovalidateMode.onUserInteraction,
    inputFormatters: <TextInputFormatter>[
      FilteringTextInputFormatter.digitsOnly
    ],
    keyboardType: TextInputType.number,
    controller: controller.value,
    maxLength: 10,
    textAlignVertical: TextAlignVertical.bottom,
    style: boldTextStyle(fontSize: 16, txtColor: APP_FONT_COLOR),
    autofocus: false,
    validator:(value)=>mobilevalidation(value!),
    decoration: InputDecoration(
      counterText: "",
      //prefixIcon: Icon(Icons.star),
      prefixIcon: InkWell(
          onTap: (){
            CountryCodePicker(
              //showDropDownButton: true,
              //showOnlyCountryWhenClosed: false,
              showFlag: false,
              //enabled: false,
              //showFlagMain: false,
              //hideMainText: false,
              padding: const EdgeInsets.only(
                  right: 0),
              // initialSelection: isocode.toUpperCase(),
              initialSelection:
              isocode != null
                  ? isocode
                  .toString()
                  .toUpperCase()
                  : "IN",

              textStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.withOpacity(0.8),
                  fontWeight: FontWeight.bold),
              onChanged:
                  (CountryCode code) {
                print(code.name); //get the country name eg: Antarctica
                print(code.code); //get the country code like AQ for Antarctica
                print(code.dialCode); //get the country dial code +672 for Antarctica
                print(code.flagUri);
                // isocode = code.code!;
                ccode = code.dialCode!;

                //get the URL of flag. flags/aq.png for Antarctica
              },
            );
          },
          child:  Padding(
              padding: const EdgeInsets.only(top: 0,left: 10),
              child: SizedBox(
                  width: 80.w,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // Padding(
                        //   padding: EdgeInsets.only(left: leftPadding),
                        //   child: Container(
                        //     width: 50,
                        //     height: 50,
                        //     margin: EdgeInsets.only(
                        //       right: 0,
                        //     ),
                        //     padding: EdgeInsets.all(10.0),
                        //     decoration: CustomDecorations()
                        //         .backgroundlocal(APP_GRAY_COLOR,
                        //         cornarradius, 0, APP_GRAY_COLOR),
                        //     child:
                        //     // SvgPicture.asset(IMG_CALL_SVG),
                        //     SvgPicture.asset(IMG_CALL_SVG_NEW),
                        //     //Image.asset(IMG_TELEPHONE),
                        //   ),
                        // ),
                        Column(
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  padding:
                                  const EdgeInsets.only(left: 10,top: 0),
                                  child: Text(
                                    "Mobile*",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color:
                                        controller.value!.text.toString().isNotEmpty?
                                        Colors.grey.withOpacity(0.7):
                                        Colors.black.withOpacity(0.7),
                                        // Colors.black
                                        //     .withOpacity(0.7),
                                        fontWeight:
                                        FontWeight.bold),
                                  )),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      // alignment: Alignment.center,
                                        width: 50.w,
                                        height: 35,
                                        // color: Colors.green,
                                        padding: EdgeInsets.only(right: isocode1=="INDIA"?0:0),
                                        margin: EdgeInsets.only(bottom: isocode1=="INDIA"?2:0),
                                        child:Obx(()=> CountryCodePicker(
                                          //showDropDownButton: true,
                                          //showOnlyCountryWhenClosed: false,
                                          showFlag: false,
                                          //enabled: false,
                                          //showFlagMain: false,
                                          //hideMainText: false,
                                          padding: const EdgeInsets.only(right: 0),
                                          // initialSelection: isocode.toUpperCase(),
                                          initialSelection:isocode1==""?"IN": isocode.toString(),
                                          textStyle:isocode1=="INDIA" || isocode1.value=="" ?
                                          TextStyle(fontSize: 18,  color: Colors.grey.withOpacity(0.8), fontWeight: FontWeight.bold):
                                          boldTextStyle(fontSize: 18, txtColor: APP_FONT_COLOR),
                                          onChanged:
                                              (CountryCode code) {
                                            print(code
                                                .name); //get the country name eg: Antarctica
                                            print(code
                                                .code); //get the country code like AQ for Antarctica
                                            print(code
                                                .dialCode); //get the country dial code +672 for Antarctica
                                            print(code.flagUri);
                                            isocode = code.code!;
                                            isocode1.value=isocode;
                                            // ccode = code.dialCode!;
                                            //get the URL of flag. flags/aq.png for Antarctica
                                          },
                                        ))),
                                    Padding(padding: EdgeInsets.only(top: 1.w),child: const Icon(Icons.arrow_drop_down)),

                                  ]),

                            ])
                      ])))),
      //suffixIcon: user_email.text.isNotEmpty ?InkWell(child: Icon(Icons.check_circle,size: 15,color: Color(0xff6FCF97),)):SizedBox(),

      contentPadding: EdgeInsets.only(top: isocode1=="INDIA"?10.w:15.w, bottom: isocode1=="INDIA"?15:19),
      // contentPadding: EdgeInsets.all(20),
      labelText: labelOpen ? "" : null,
      hintText: "9876543210",
      hintStyle: TextStyle(
          fontSize: 16.sp,
          fontFamily: fontFamily,
          color: Colors.grey.withOpacity(0.8),
          fontWeight: FontWeight.w700),
      floatingLabelBehavior: labelOpen
          ? FloatingLabelBehavior.always
          : FloatingLabelBehavior.never,
      labelStyle: TextStyle(
          fontSize: 14.sp,
          color:controller.value!.text.toString().isNotEmpty? Colors.grey.withOpacity(0.7):
          Colors.black.withOpacity(0.7),
          fontWeight: FontWeight.w600),

      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: gray_color_1)),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: gray_color_1)),
      errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red)),
      disabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red)),
      focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red)),
      //labelText: 'Email',
    ),
  ));


}

Widget DropDownDOB(
    String imageIcon, String labelText, String hintText,
    // TextEditingController controller,
    Rxn<TextEditingController>? controller,
    [double leftPadding = 0,
    bool labelOpen = true,
    FontWeight fontWeight = FontWeight.w600,
    bool isFocus = false]) {
  return  Obx(() =>
      TextFormField(
        onChanged: (value){
          print("im in on change "+value);
          controller?.update((val) { });
        },
        readOnly: true,
        validator: (value) => validation(value, "Please select date"),
        onTap: () {
          OpenDatePickerDOBDialog( DateTime(1900), DateTime.now(), controller);
          controller?.update((val) { });
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller?.value,
        style: boldTextStyle(fontSize: 16, txtColor: APP_FONT_COLOR),
        // TextStyle(fontSize: 18, color: APP_FONT_COLOR, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: gray_color_1)),
          focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: gray_color_1)),
          errorBorder:
          const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          disabledBorder:
          const UnderlineInputBorder(borderSide:  BorderSide(color: Colors.red)),
          focusedErrorBorder:
          const UnderlineInputBorder(borderSide:  BorderSide(color: Colors.red)),
          // contentPadding: EdgeInsets.all(20),
          labelStyle: TextStyle(
              fontSize: 14.sp,
              color:gray_color_1,
              fontFamily: fontFamily,
              fontWeight: FontWeight.w500),
          // semiBoldTextStyle(fontSize: 16,txtColor: Colors.black.withOpacity(0.7),),
          // TextStyle(
          // fontSize: 16, color: Colors.black.withOpacity(0.7), fontWeight: FontWeight.bold),
          labelText: labelText,
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 16.sp, color: gray_color_1,fontWeight: FontWeight.w700,fontFamily: fontFamily,height: 1.5),
          // TextStyle(color: APP_FONT_COLOR, fontWeight: fontWeight),
          floatingLabelBehavior: labelOpen
              ? FloatingLabelBehavior.always
              : FloatingLabelBehavior.auto,
          // prefixIcon: Container(
          //   width: 50,
          //   height: 50,
          //   margin: EdgeInsets.only(right: 10, left: leftPadding),
          //   padding: const EdgeInsets.all(10.0),
          //   decoration: CustomDecorations()
          //       .backgroundlocal(APP_GRAY_COLOR, cornarradius, 0, APP_GRAY_COLOR),
          //   child: imageIcon.contains("svg")
          //       ? SvgPicture.asset(imageIcon)
          //       : Image.asset(imageIcon),
          // ),
            //suffixIconConstraints: BoxConstraints(maxWidth: 30,minWidth: 10 ),
            // prefixIconConstraints: BoxConstraints(maxWidth: 50),
            //suffixIcon: Icon(Icons.arrow_drop_down)

            suffixIconConstraints: const BoxConstraints(maxWidth: 40,minWidth: 10 ),
            // prefixIconConstraints: BoxConstraints(maxWidth: 50),
            suffixIcon: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child:
                SvgPicture.asset(IMG_DROPDOWN_SVG_2,height: 24,width: 24,)
              //Icon(Icons.arrow_drop_down),

            )
        ),
      ));
}

Widget DropDownScheduleDate(String imageIcon, String labelText, String hintText,
    Rxn<TextEditingController>? controller,
    [double leftPadding = 0,
    bool labelOpen = true,
    FontWeight fontWeight = FontWeight.bold]) {
  return InkWell(
    onTap: () {
      //OpenDatePickerDOBDialog(DateTime.now(),DateTime(2100),txtscheduledate);
    },
    child: TextFormField(
      readOnly: true,
      validator: (value) => validation(value, "Please select date"),
      onTap: () {
        OpenDatePickerDOBDialog(DateTime(1900),DateTime.now(), controller);
      },
      controller: controller?.value,
      style:boldTextStyle(fontSize: 16, txtColor: APP_FONT_COLOR),
      // TextStyle(fontSize: 18, color: APP_FONT_COLOR, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        border: InputBorder.none,
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: gray_color_1)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: gray_color_1)),
        errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        disabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        focusedErrorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        contentPadding: const EdgeInsets.all(20),
        labelStyle: TextStyle(
            fontSize: 14.sp,
            color:gray_color_1,
            fontFamily: fontFamily,
            fontWeight: FontWeight.w500),
        labelText: labelText,
        hintText: hintText,
        hintStyle: boldTextStyle(fontSize: 16, txtColor: /*APP_FONT_COLOR*/Colors.grey.withOpacity(0.8),),
        floatingLabelBehavior: labelOpen
            ? FloatingLabelBehavior.always
            : FloatingLabelBehavior.auto,
        // prefixIcon: Container(
        //   width: 50,
        //   height: 50,
        //   margin: EdgeInsets.only(right: 10, left: leftPadding),
        //   padding: const EdgeInsets.all(10.0),
        //   decoration: CustomDecorations()
        //       .backgroundlocal(APP_GRAY_COLOR, cornarradius, 0, APP_GRAY_COLOR),
        //   child: Image.asset(imageIcon),
        // ),
      ),
    ),
  );
}

Widget ScheduleSiteVisite(String imageIcon, String labelText, String hintText,
    Rxn<TextEditingController>? controller,
    [double leftPadding = 0,
      bool labelOpen = true,
      FontWeight fontWeight = FontWeight.bold]) {
  return InkWell(
    onTap: () {
      //OpenDatePickerDOBDialog(DateTime.now(),DateTime(2100),txtscheduledate);
    },
    child: TextFormField(
      readOnly: true,
      validator: (value) => validation(value, "Please select date"),
      onTap: () {
        OpenDatePickerDOBDialog(DateTime.now(),DateTime(DateTime.now().year+5), controller);
      },
      controller: controller?.value,
      style: boldTextStyle(fontSize: 16, txtColor: APP_FONT_COLOR),
      // TextStyle(fontSize: 18, color: APP_FONT_COLOR, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        border: InputBorder.none,
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: gray_color_1)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: gray_color_1)),
        errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        disabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        focusedErrorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        // contentPadding: EdgeInsets.all(20),
        labelStyle: TextStyle(
            fontSize: 14.sp,
            color:gray_color_1,
            fontFamily: fontFamily,
            fontWeight: FontWeight.w500),
        labelText: labelText,
        hintText: hintText,
        hintStyle: TextStyle(
            height: 1.8,
            fontSize: 16.sp,
            fontFamily: fontFamily,
            color: HexColor("#898989"),
            fontWeight: FontWeight.w700),
        floatingLabelBehavior: labelOpen
            ? FloatingLabelBehavior.always
            : FloatingLabelBehavior.auto,

        // prefixIcon: Container(
        //   width: 50,
        //   height: 50,
        //   margin: EdgeInsets.only(right: 10, left: leftPadding),
        //   padding: const EdgeInsets.all(10.0),
        //   decoration: CustomDecorations()
        //       .backgroundlocal(APP_GRAY_COLOR, cornarradius, 0, APP_GRAY_COLOR),
        //   child: Image.asset(imageIcon),
        // ),
      ),
    ),
  );
}

Widget DropDownTime(String imageIcon, String labelText, String hintText,
    Rxn<TextEditingController> controller,
    [double leftPadding = 0,
    bool labelOpen = true,
    FontWeight fontWeight = FontWeight.bold]) {

  return InkWell(
    onTap: () {
      _selectTime(Get.context!);
      //OpenDatePickerDOBDialog(DateTime(1900),DateTime(2100));
    },
    child: TextFormField(
      readOnly: true,
      onTap: () {
        OpenTimePicker();
      },
      controller: txtscheduletime.value,
      style: boldTextStyle(fontSize: 16, txtColor: APP_FONT_COLOR),
      decoration: InputDecoration(
        border: InputBorder.none,
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: gray_color_1)),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: gray_color_1)),
        contentPadding: const EdgeInsets.all(20),
        labelStyle: TextStyle(
            fontSize: 14.sp,
            color:gray_color_1,
            fontFamily: fontFamily,
            fontWeight: FontWeight.w500),
        labelText: labelText,
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 16.sp,color: APP_FONT_COLOR,fontFamily: fontFamily, fontWeight: fontWeight),
        floatingLabelBehavior: labelOpen
            ? FloatingLabelBehavior.always
            : FloatingLabelBehavior.auto,
        prefixIcon: Container(
          width: 50,
          height: 50,
          margin: EdgeInsets.only(right: 10, left: leftPadding),
          padding: const EdgeInsets.all(10.0),
          decoration: CustomDecorations()
              .backgroundlocal(APP_GRAY_COLOR, cornarradius, 0, APP_GRAY_COLOR),
          child: Image.asset(imageIcon),
        ),
      ),
    ),
  );
}

Widget DropDownAnniversary(String imageIcon, String labelText, String hintText,
    // TextEditingController controller,
    Rxn<TextEditingController>? controller,
    [double leftPadding = 0,
    bool labelOpen = true,
    FontWeight fontWeight = FontWeight.bold,
    bool isFocus = false]) {
  return  Obx(() =>
    TextFormField(
    readOnly: true,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: (value) => validation(value, "Please select date"),
      onChanged: (value){
        print("im in on change "+value);
        controller?.update((val) { });
      },

    onTap: () {
      // OpenDatePickerDOBDialog( DateTime(1900), DateTime.now(), controller);
      // controller?.update((val) { });
      OpenDatePickerAnniveraryDialog(
          DateTime(1900),DateTime.now(), controller);
      controller?.update((val) { });
    },
    controller: controller?.value,
    style: boldTextStyle(fontSize: 16, txtColor: APP_FONT_COLOR),
    //TextStyle(fontSize: 18, color: APP_FONT_COLOR, fontWeight: FontWeight.bold),
    decoration: InputDecoration(
      border: InputBorder.none,
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: gray_color_1)),
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: gray_color_1)),
      errorBorder:
      const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
      disabledBorder:
      const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
      focusedErrorBorder:
      const UnderlineInputBorder(borderSide:  BorderSide(color: Colors.red)),
      // contentPadding: EdgeInsets.all(20),
      labelStyle: TextStyle(
          fontSize: 14.sp,
          color:gray_color_1,
          fontFamily: fontFamily,
          fontWeight: FontWeight.w500),
      // TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.7), fontWeight: FontWeight.bold),
      labelText: labelText,
      hintText: hintText,
      hintStyle: TextStyle(fontSize: 16.sp, color: gray_color_1,fontWeight: FontWeight.w700,fontFamily: fontFamily,height: 1.5),
      floatingLabelBehavior: labelOpen ? FloatingLabelBehavior.always : FloatingLabelBehavior.auto,
      // prefixIcon: Container(
      //   width: 50,
      //   height: 50,
      //   margin: EdgeInsets.only(right: 10, left: leftPadding),
      //   padding: const EdgeInsets.all(10.0),
      //   decoration: CustomDecorations()
      //       .backgroundlocal(APP_GRAY_COLOR, cornarradius, 0, APP_GRAY_COLOR),
      //   child: imageIcon.contains("svg")
      //       ? SvgPicture.asset(imageIcon)
      //       : Image.asset(imageIcon),
      //   //Image.asset(imageIcon),
      // ),
    ),
    ));
}

OpenDatePickerDOBDialog(DateTime firstdate, DateTime lastdate,
    Rxn<TextEditingController>? datecontroller) async {
  DateTime? _datePicker = await showDatePicker(
    context: Get.context!,
    initialDate: currentData,
    firstDate: firstdate,
    lastDate: lastdate,
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: APP_THEME_COLOR, // <-- SEE HERE
            onPrimary: AppColors.White_color, // <-- SEE HERE
            onSurface: AppColors.BLACK, // <-- SEE HERE
          ),
          textTheme:const TextTheme(
              bodyText1: TextStyle(
                  fontSize: 10), // <-- here you can do your font smaller
              bodyText2:
                  TextStyle(fontSize: 8.0, fontFamily: 'Poppins-Medium')),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              primary: AppColors.BLACK, // button text color
            ),
          ),
        ),
        child: child!,
      );
    },
  );

  if (_datePicker != null) {
    currentData = _datePicker;
    var dateFormat = DateFormat("d MMMM y");

    print(_datePicker);
    datecontroller?.value?.text = dateFormat.format(_datePicker);
    datecontroller?.update((val) { });
  }
}

Future<Null> _selectTime(BuildContext context) async {
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: selectedTime,
  );
  if (picked != null)
    // setState(() {
  selectedTime = picked;
  _hour = selectedTime.hour.toString();
  _minute = selectedTime.minute.toString();
  _time = _hour! + ' : ' + _minute!;
  txtscheduletime.value?.text = _time!;
  // txtscheduletime.text = formatDate(
  //     DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
  //     [hh, ':', nn, " ", am]).toString();
  // });
}

OpenTimePicker() async {
  Future<TimeOfDay?> selectedTime = showTimePicker(
      initialTime: TimeOfDay.now(),
      context: Get.context!,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: APP_THEME_COLOR, // <-- SEE HERE
              onPrimary: AppColors.White_color, // <-- SEE HERE
              onSurface: AppColors.BLACK, // <-- SEE HERE
            ),
            textTheme: const TextTheme(
                bodyText1: TextStyle(
                    fontSize: 10), // <-- here you can do your font smaller
                bodyText2:
                    TextStyle(fontSize: 8.0, fontFamily: 'Poppins-Medium')),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: AppColors.BLACK, // button text color
              ),
            ),
          ),
          child: child!,
        );
      });

  currenttime = selectedTime;
  print(selectedTime);
}

OpenDatePickerAnniveraryDialog(DateTime firstdate, DateTime lastdate,
    Rxn<TextEditingController>? anniverserycontroller) async {
  DateTime? _datePicker = await showDatePicker(
    context: Get.context!,
    initialDate: currentData,
    firstDate: firstdate,
    lastDate: lastdate,
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: APP_THEME_COLOR, // <-- SEE HERE
            onPrimary: AppColors.White_color, // <-- SEE HERE
            onSurface: AppColors.BLACK, // <-- SEE HERE
          ),
          textTheme: const TextTheme(
              bodyText1: TextStyle(
                  fontSize: 10), // <-- here you can do your font smaller
              bodyText2:
                  TextStyle(fontSize: 8.0, fontFamily: 'Poppins-Medium')),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              primary: AppColors.BLACK, // button text color
            ),
          ),
        ),
        child: child!,
      );
    },
  );

  if (_datePicker != null) {
    currentData = _datePicker;
    var dateFormat = DateFormat("d MMMM y");

    print(_datePicker);
    anniverserycontroller?.value?.text = dateFormat.format(_datePicker);
    anniverserycontroller?.update((val) { });
  }
}

_selectTime_with_no(BuildContext context, int startTime, Rxn<TextEditingController>? timecontroller) async {
  final TimeOfDay? picked = await showTimePicker(
    builder: (BuildContext? context, Widget? child) {
      return Column(
        children: [
          Theme(
            data: Theme.of(context!).copyWith(
              colorScheme: ColorScheme.light(
                primary: APP_THEME_COLOR,
                onPrimary: AppColors.White_color,
                onSurface: APP_THEME_COLOR,
              ),
              textTheme: const TextTheme(
                  bodyText1: TextStyle(
                      fontSize: 10), // <-- here you can do your font smaller
                  bodyText2:
                  TextStyle(fontSize: 8.0, fontFamily: 'Poppins-Medium')),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: APP_THEME_COLOR, // button text color
                ),
              ),
            ),
            child: child!,
          ),
        ],
      );
    },
    context: context,
    initialTime: startTime == 0
        ? TimeOfDay.now()
        : TimeOfDay(hour: startTime ~/ 60, minute: startTime % 60),
  );
  if (picked != null) {
    selectedTime = picked;
  }
  final now = new DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, selectedTime.hour, selectedTime.minute);
  final format = DateFormat.jm();
  // print(tod.hour);//"6:00 AM"
  //   print(tod.minute);//"6:00 AM"
  //return format.format(dt);
  // int totoalmnt = (selectedTime.hour * 60) + selectedTime.minute;
  timecontroller!.value!.text = format.format(dt);
  print(timecontroller.toString() + "scheduledtimedsg");
  timecontroller.update((val) { });
  // return totoalmnt;
}

Future<void> selectTime_with_no2(BuildContext context, int startTime, Rxn<TextEditingController>? timecontroller) async {
  final TimeOfDay? picked = await showTimePicker(
    builder: (BuildContext? context, Widget? child) {
      return Column(
        children: [
          Theme(
            data: Theme.of(context!).copyWith(
              colorScheme: ColorScheme.light(
                primary: APP_THEME_COLOR, // <-- SEE HERE
                onPrimary: AppColors.White_color, // <-- SEE HERE
                onSurface: APP_THEME_COLOR, // <-- SEE HERE
              ),
              textTheme: const TextTheme(
                  bodyText1: TextStyle(
                      fontSize: 10), // <-- here you can do your font smaller
                  bodyText2:
                  TextStyle(fontSize: 8.0, fontFamily: 'Poppins-Medium')),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: APP_THEME_COLOR, // button text color
                ),
              ),
            ),
            child: child!,
          ),
        ],
      );
    },
    context: context,
    initialTime: startTime == 0
        ? TimeOfDay.now()
        : TimeOfDay(hour: startTime ~/ 60, minute: startTime % 60),
  );
  if (picked != null) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
    final format = DateFormat.jm();
    timecontroller!.value!.text = format.format(dt);
    print(timecontroller.toString() + "scheduledtimedsg");
    timecontroller.update((val) {});
  }
}

Widget DropDownTimeSelect(String imageIcon, String labelText, String hintText,
    Rxn<TextEditingController>? controller,
    [double leftPadding = 0,
      bool labelOpen = true,
      FontWeight fontWeight = FontWeight.w600,
      bool isFocus = false]) {
  return  Obx(() =>InkWell(
    onTap: () {
      print("time");
      //_selectTime_with_no(Get.context!, 0);
    },
    child: TextFormField(
      onChanged:  (value){
        controller?.update((val) { });
      },
      onTap: () {
        _selectTime_with_no(Get.context!, 0,controller);
        print(controller.toString()+"my select time");
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) => validation(value, "Please select time"),
      readOnly: true,
      controller: txtscheduletime.value,
      style: boldTextStyle(fontSize: 16, txtColor: APP_FONT_COLOR),
      // TextStyle(fontSize: 18, color: APP_FONT_COLOR, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: gray_color_1)),
          focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: gray_color_1)),
          errorBorder:
          const UnderlineInputBorder(borderSide: const BorderSide(color: Colors.red)),
          disabledBorder:
          const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          focusedErrorBorder:
          const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          // contentPadding: EdgeInsets.all(20),
          labelStyle: TextStyle(
              fontSize: 14.sp,
              color:gray_color_1,
              fontFamily: fontFamily,
              fontWeight: FontWeight.w500),
          /*labelOpen
              ? TextStyle(
              fontSize: 16,
              color:controller!.value!.text.toString().isNotEmpty? Colors.grey.withOpacity(0.7):
              Colors.black.withOpacity(0.7),
              // color: Colors.black.withOpacity(0.7),
              fontWeight: FontWeight.bold)
              : isFocus
              ? TextStyle(
              fontWeight: FontWeight.bold, color: APP_FONT_COLOR
          )
              : null,*/
          // TextStyle(
          //     fontSize: 16, color: Colors.black.withOpacity(0.7), fontWeight: FontWeight.bold),
          labelText: labelText,
          hintText: hintText,
            hintStyle: TextStyle(
          height: 1.8,
          fontSize: 16.sp,
          fontFamily: fontFamily,
          color: Colors.grey.withOpacity(0.8),
          fontWeight: FontWeight.w700),
          // TextStyle(color: APP_FONT_COLOR, fontWeight: fontWeight),
          floatingLabelBehavior: labelOpen
              ? FloatingLabelBehavior.always
              : FloatingLabelBehavior.auto,
          // prefixIcon: Container(
          //   width: 50,
          //   height: 50,
          //   margin: EdgeInsets.only(right: 10, left: leftPadding),
          //   padding: const EdgeInsets.all(10.0),
          //   decoration: CustomDecorations().backgroundlocal(
          //       APP_GRAY_COLOR, cornarradius, 0, APP_GRAY_COLOR),
          //   child: imageIcon.toString().contains("svg")
          //       ? SvgPicture.asset(imageIcon)
          //       : Image.asset(imageIcon),
          // ),
          //suffixIconConstraints: BoxConstraints(maxWidth: 30,minWidth: 10 ),
          // prefixIconConstraints: BoxConstraints(maxWidth: 50),
          //suffixIcon: Icon(Icons.arrow_drop_down)
          // suffixIcon: Icon(Icons.arrow_drop_down)),

          suffixIconConstraints: const BoxConstraints(maxWidth: 40,minWidth: 10 ),
          // prefixIconConstraints: BoxConstraints(maxWidth: 50),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: SvgPicture.asset(IMG_DROPDOWN_SVG_2,height: 23,width: 23,)
          )
      ),
    ),
  ));
}
// Widget DropDownTimeSelect(String imageIcon, String labelText, String hintText,
//     Rxn<TextEditingController>? controller,
//     [double leftPadding = 0,
//     bool labelOpen = true,
//     FontWeight fontWeight = FontWeight.w600,
//     bool isFocus = false]) {
//   return  Obx(() =>InkWell(
//     onTap: () {
//       print("time");
//       //_selectTime_with_no(Get.context!, 0);
//     },
//     child: TextFormField(
//       onChanged:  (value){
//         controller?.update((val) { });
//       },
//
//       onTap: () {
//         _selectTime_with_no(Get.context!, 0, controller);
//       },
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       validator: (value) => validation(value, "Please select time"),
//       readOnly: true,
//       controller: controller?.value ,
//       style: boldTextStyle(fontSize: 18, txtColor: APP_FONT_COLOR),
//       // TextStyle(fontSize: 18, color: APP_FONT_COLOR, fontWeight: FontWeight.w600),
//       decoration: InputDecoration(
//           border: InputBorder.none,
//           enabledBorder:
//               UnderlineInputBorder(borderSide: BorderSide(color: LIGHT_GREY)),
//           focusedBorder:
//               UnderlineInputBorder(borderSide: BorderSide(color: LIGHT_GREY)),
//           errorBorder:
//               UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
//           disabledBorder:
//               UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
//           focusedErrorBorder:
//               UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
//           contentPadding: EdgeInsets.all(20),
//           labelStyle: labelOpen
//               ? TextStyle(
//                   fontSize: 16,
//               color:controller!.value!.text.toString().isNotEmpty? Colors.grey.withOpacity(0.7):
//               Colors.black.withOpacity(0.7),
//                  // color: Colors.black.withOpacity(0.7),
//                   fontWeight: FontWeight.bold)
//               : isFocus
//                   ? TextStyle(
//                       fontWeight: FontWeight.bold, color: APP_FONT_COLOR
//           )
//                   : null,
//           // TextStyle(
//           //     fontSize: 16, color: Colors.black.withOpacity(0.7), fontWeight: FontWeight.bold),
//           labelText: labelText,
//           hintText: hintText,
//           hintStyle: boldTextStyle(fontSize: 18, txtColor: /*APP_FONT_COLOR*/Colors.grey.withOpacity(0.8),),
//           // TextStyle(color: APP_FONT_COLOR, fontWeight: fontWeight),
//           floatingLabelBehavior: labelOpen
//               ? FloatingLabelBehavior.always
//               : FloatingLabelBehavior.auto,
//           // prefixIcon: Container(
//           //   width: 50,
//           //   height: 50,
//           //   margin: EdgeInsets.only(right: 10, left: leftPadding),
//           //   padding: const EdgeInsets.all(10.0),
//           //   decoration: CustomDecorations().backgroundlocal(
//           //       APP_GRAY_COLOR, cornarradius, 0, APP_GRAY_COLOR),
//           //   child: imageIcon.toString().contains("svg")
//           //       ? SvgPicture.asset(imageIcon)
//           //       : Image.asset(imageIcon),
//           // ),
//           //suffixIconConstraints: BoxConstraints(maxWidth: 30,minWidth: 10 ),
//           // prefixIconConstraints: BoxConstraints(maxWidth: 50),
//           //suffixIcon: Icon(Icons.arrow_drop_down)
//           // suffixIcon: Icon(Icons.arrow_drop_down)),
//
//           suffixIconConstraints: BoxConstraints(maxWidth: 40,minWidth: 10 ),
//           // prefixIconConstraints: BoxConstraints(maxWidth: 50),
//           suffixIcon: Padding(
//             padding: const EdgeInsets.only(right: 20.0),
//             child: Icon(Icons.arrow_drop_down),
//           )
//       ),
//     ),
//   ));
// }

Widget DropDownTextField(String imageIcon, String labelText, String hintText,
    TextEditingController controller,
    [double leftPadding = 0,
    bool labelOpen = true,
    FontWeight fontWeight = FontWeight.w600]) {
  return InkWell(

    onTap: () {},
    child: TextFormField(
      style: TextStyle(fontSize: 16, color: APP_FONT_COLOR, fontWeight: FontWeight.w600),
      readOnly: true,
      decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: gray_color_1)),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: gray_color_1)),
          contentPadding: const EdgeInsets.all(20),
          labelStyle: TextStyle(
              fontSize: 14.sp,
              color:gray_color_1,
              fontFamily: fontFamily,
              fontWeight: FontWeight.w500),
          labelText: labelText,
          hintText: hintText,
          hintStyle: TextStyle(
            color: APP_FONT_COLOR,
            fontFamily: fontFamily,

            fontWeight: fontWeight,
          ),
          floatingLabelBehavior: labelOpen
              ? FloatingLabelBehavior.always
              : FloatingLabelBehavior.auto,
          prefixIcon: Container(
            width: 50,
            height: 50,
            margin: EdgeInsets.only(right: 10, left: leftPadding),
            padding: const EdgeInsets.all(10.0),
            decoration: CustomDecorations().backgroundlocal(
                APP_GRAY_COLOR, cornarradius, 0, APP_GRAY_COLOR),
            child: Image.asset(imageIcon),
          ),
          suffixIcon: Padding(
          padding: const EdgeInsets.only(top: 16.0),
  child: SvgPicture.asset(IMG_DROPDOWN_SVG_2,height: 23,width: 23,)
  ))
    ),
  );
}

Widget SimpleTextFormField(
    {BuildContext? context,
    OnTapPress? onTap,
    bool autoFocus = false,
    bool obscureText = false,
    TextEditingController? controller,
    bool readOnly = false,
    bool showCursor = true,
    bool firstCharCapital = true,
    Color cursorColor = Colors.black,
    Color borderColor = Colors.black,
    String hintText = "Send Message...",
    // String errorText = "",
    TextStyle? hintStyle,
    Widget? prefix,
    Widget? suffix,
    FontWeight? fontWeight,
    TextInputType? keyboardType,
    EdgeInsetsGeometry? padding,
    String? errorText = "",
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
    TextInputAction? textInputAction,
    double? fontSize = 16,
    String? Function(String?)? validator,
    int? maxLength,
    OnChange? onChange,
    List<TextInputFormatter>? inputFormatters}) {
  return TextFormField(
    onTap: onTap,
    autofocus: autoFocus,
    maxLength: maxLength,
    textCapitalization: firstCharCapital
        ? TextCapitalization.sentences
        : TextCapitalization.none,
    style: TextStyle(
        color: AppColors.WHITE, fontSize: 15, fontWeight: fontWeight ?? null),
    validator: validator,
    readOnly: readOnly,
    focusNode: focusNode,
    controller: controller,
    keyboardType: keyboardType,
    // autovalidateMode: AutovalidateMode.disabled ,
    // textCapitalization: TextCapitalization.characters,
    obscureText: obscureText,
    cursorColor: cursorColor,
    showCursor: showCursor,
    inputFormatters: inputFormatters,
    textInputAction: textInputAction,
    // onSubmitted: (value) {
    //   FocusScope.of(context!).requestFocus(nextFocusNode);
    // },
    onFieldSubmitted: (value) {
      FocusScope.of(context!).requestFocus(nextFocusNode);
    },
    onChanged: onChange,
    decoration: InputDecoration(
      // errorText: errorText!.isNotEmpty ? errorText : null,
      counterText: "",
      border: InputBorder.none,
      contentPadding:
          // padding ?? EdgeInsets.symmetric(vertical: 17, horizontal: 15),
      const EdgeInsets.only(top: 15, left: 15),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: AppColors.APP_THEME_COLOR)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: gray_color_1)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: AppColors.APP_THEME_COLOR)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: AppColors.APP_THEME_COLOR)),
      hintText: "Send Message...",
      hintStyle: TextStyle(
        fontSize: 16.sp,
        fontFamily: fontFamily,
        fontWeight: FontWeight.w700,
        color: LIGHT_GREY.withOpacity(0.3),
      ),
      prefixIcon: prefix,
      suffixIcon: Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 15),
        child: IconButton(
          padding: const EdgeInsets.all(0),
          icon: Container(),
          onPressed: () {},
        ),
      ),
    ),
  );
}

String? validation(String? value, String message) {
  if (value!.trim().isEmpty) {
    return message;
  } else {
    return null;
  }
}



String? emailvalidation(String? value) {
  bool emailValid = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(value!);
  if (value.trim().isEmpty) {
    return ""+"Please enter your email";
  } else if (!emailValid) {
    return ""+"Please enter your valid email";
  } else {
    return null;
  }
}
