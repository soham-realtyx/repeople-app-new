import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Model/Theme/WidgetThemeListClass.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:Repeople/Widgets/TextEditField.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Config/Helper/ApiResponse.dart';
import '../../Model/CommonModal/CommonModal.dart';
import '../../Widgets/CommomBottomSheet.dart';
import '../../Widgets/select_dailog.dart';

class ContactUsFormController extends GetxController{

  RxList<WidgetThemeListClass> arrAllThemeList = RxList<WidgetThemeListClass>();

  var formkey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> GlobalContactsusformkey = GlobalKey<ScaffoldState>();
  Rxn<TextEditingController> txtContactNew = Rxn(TextEditingController());

  Rx<CommonModal> obj_subject = CommonModal().obs;
  RxList<CommonModal> arrsubjectList = RxList([]);
  // RxList<String> arrsubjectList = RxList([
  //   'Sign-Up Sign-In Issue',
  //   'OTP Issue',
  //   'Profile Detail',
  //   'Referral Issue',
  //   'Other',
  // ]);

  @override
  void onInit(){
    super.onInit();
    RetrieveSubjectListData();
  }

  @override
  void onClose() {
    // TODO: implement dispose

    super.onClose();
    isocode1.value="";
    isocode1.obs;
    txtContact.clear();
    ccode="";

    //Get.delete<DashboardController>();
  }

  //<editor-fold desc = "Api Calls">
  Future<List<CommonModal>> RetrieveSubjectListData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    arrsubjectList = RxList([]);
    var data = {'action': 'fillcontactus'};

    var headers = {'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"" };

    ApiResponse response = ApiResponse(
      data: data,
      base_url: URL_PROJECTLIST,
      apiHeaderType: ApiHeaderType.Content,
      headerdata: headers,
    );
    Map<String, dynamic>? responseData = await response.getResponse();

    if (responseData!['status'] == 1) {
      List result = responseData['data'];
      arrsubjectList.value =
          List.from(result.map((e) => CommonModal.fromJson(e)));
      arrsubjectList.refresh();
      obj_subject.value = arrsubjectList[0];
      txtSubject.text = obj_subject.value.name!;
    }

    return arrsubjectList;
  }


  submitContactUsQuery() async {
    Apploader(contextCommon);
    try{

      SharedPreferences sp = await SharedPreferences.getInstance();

      Map<String, dynamic> data = {
        'action': 'addcontactus',
        'querytypeid': obj_subject.value.id.toString(),
        'message': txtQueryNew.value!.text,
        'fname': txtFirstNameNew.value!.text,
        'lname': txtLastNameNew.value!.text,
        'countrycode': "91",
        'countrycodestr': "in",
        'mobile': txtContactNew.value!.text,
        'email': txtEmailNew.value!.text,
      };
      print("contact my data");
      var headers = {
        'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",
      };

      ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_USERPROFILEDETAILS,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers,
      );
      Map<String, dynamic>? responseData = await response.getResponse();



      if (responseData!['status'] == 1) {
        Navigator.pop(contextCommon);
        SuccessMsg(responseData['message'] ?? "query sended successfully");
        Get.back();
      }
      else{
        Navigator.pop(contextCommon);
        validationMsg(responseData['message'] ?? "Something Went Wrong 5555");
      }

    }catch(e){
      Navigator.pop(contextCommon);
      validationMsg("Something Went Wrong 1231");
    }



  }


  RxBool focusFirstName = false.obs;
  RxBool focusLastName = false.obs;
  RxBool focusEmailName = false.obs;
  RxBool focusContact = false.obs;

  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtContact = TextEditingController();
  TextEditingController txtSubject = TextEditingController();
  TextEditingController txtQuery = TextEditingController();
  TextEditingController txtsddate = TextEditingController();
  Rxn<TextEditingController> txtFirstNameNew = Rxn(TextEditingController());
  Rxn<TextEditingController> txtLastNameNew = Rxn(TextEditingController());
  Rxn<TextEditingController> txtEmailNew = Rxn(TextEditingController());
  Rxn<TextEditingController> txtContactNew1 = Rxn(TextEditingController());
  Rxn<TextEditingController> txtQueryNew = Rxn(TextEditingController());
  Rxn<TextEditingController> txtScheduleDateNew = Rxn(TextEditingController());
  Rxn<TextEditingController> txtScheduleTimeNew = Rxn(TextEditingController());
  TextEditingController txtProject = TextEditingController();

  RxList<String> arrProjectList = RxList([
    'The Persuit of Happiness',
    'Shaligram Kinaro',
    'Shaligram Signature',
    'Sundaram Status',
    'Saffron Homes',
  ]);

  SelectProject() {
    SelectProjectDialog((value) {
      txtProject.text = value;
    });
  }

  Future<dynamic> SelectProjectDialog(ValueChanged<dynamic> onChange) {
    return SelectDialog1.showModal(
      Get.context!,
      label: "Select Project",
      items: arrProjectList,
      onChange: onChange,
      searchBoxDecoration: const InputDecoration(
          prefixIcon: Icon(Icons.search), hintText: "Search"),
    );
  }
  //TextEditingController txtSubject = TextEditingController();

  //<editor-fold desc = "Form 1">




  Widget TextFiled_1(){
    return Container(
      child: Form(
        key: formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: Get.mediaQuery.viewInsets.bottom),
              child:
              SimpleTextFieldNew(
                  hintText: "John",
                  // imageIcon: IMG_PROFILEUSER_SVG_DASHBOARD,
                  imageIcon: IMG_USER_SVG_NEW,
                  controller: txtFirstName,
                  labelText: "First Name*",

                  textInputType: TextInputType.name,
                  validator: (value) =>
                      validation(value, "Please enter first name")),
              //SimpleTextField(IMG_ACCOUNT, "First Name*", "Enter", txtFirstName),
            ),
            SizedBox(
              height: 5,
            ),
            SimpleTextFieldNew(
                hintText: "Doe",
                // imageIcon: IMG_PROFILEUSER_SVG_DASHBOARD,
                imageIcon: IMG_USER_SVG_NEW,
                controller: txtLastName,
                textInputType: TextInputType.name,
                labelText: "Last Name*",
                validator: (value) =>
                    validation(value, "Please enter last name")),
            //SimpleTextField(IMG_ACCOUNT, "Last Name*", "Enter", txtLastName),
            SizedBox(
              height: 5,
            ),
            SimpleTextFieldNew(
                hintText: "johndoe@example.com",
                // imageIcon: IMG_MAIL_SVG,
                imageIcon: IMG_EMAIL_SVG_NEW,
                controller: txtEmail,
                textInputType: TextInputType.emailAddress,
                labelText: "Email*",
                validator: (value) =>
                    emailvalidation(value)),
            //SimpleTextField(IMG_EMAIL, "Email Address*", "deo_john1@loremi.com", txtEmail),
            SizedBox(
              height: 5,
            ),
            PhoneNumberTextField(txtContactNew),
            //ContactTextField(txtContactNew),
            SizedBox(
              height: 5,
            ),
            CommonDropDownTextField(
              labelText: "Select Subject*",
              onTap: (){
                SelectSubject();
              },
              imageIcon: IMG_PROJECT_SVG_NEW,
              controller: txtSubject,
              hintText: txtSubject.text,
            ),
            // TextFormField(
            //   style: boldTextStyle(fontSize: 18,txtColor: APP_FONT_COLOR),
            //       // semiBoldTextStyle(fontSize: 18,txtColor: APP_FONT_COLOR),
            //   // TextStyle(fontSize: 18, color: APP_FONT_COLOR, fontWeight: FontWeight.bold),
            //   onTap: () {
            //     SelectSubject();
            //     // SelectProfession();
            //   },
            //   readOnly: true,
            //   controller: txtSubject,
            //   autovalidateMode: AutovalidateMode.onUserInteraction,
            //   //validator: (value) => validation(value, "Please select subject"),
            //   decoration: InputDecoration(
            //       border: InputBorder.none,
            //       enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: LIGHT_GREY)),
            //       focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: LIGHT_GREY)),
            //       errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
            //       disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
            //       focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
            //       contentPadding: EdgeInsets.only(top: 20,bottom: 20,left: 20,right: 0),
            //       labelStyle:
            //       TextStyle(
            //           fontSize: 16, color: Colors.black.withOpacity(0.7), fontWeight: FontWeight.bold),
            //       // TextStyle(
            //       //     fontSize: 16, color: Colors.black.withOpacity(0.7), fontWeight: FontWeight.bold),
            //       labelText: "Subject*",
            //       hintText: arrsubjectList[0].toString(),
            //       hintStyle:boldTextStyle(fontSize: 18,txtColor: APP_FONT_COLOR),
            //           // boldTextStyle(txtColor: APP_FONT_COLOR),
            //       // TextStyle(color: APP_FONT_COLOR),
            //       floatingLabelBehavior: FloatingLabelBehavior.always ,
            //       prefixIcon: Container(
            //         width: 50,
            //         height: 50,
            //         margin: EdgeInsets.only(right: 10, left: 0),
            //         padding: const EdgeInsets.all(10.0),
            //         decoration: CustomDecorations()
            //             .backgroundlocal(APP_GRAY_COLOR, cornarradius, 0, APP_GRAY_COLOR),
            //         child: SvgPicture.asset(IMG_PROJECT_SVG_DASHBOARD)
            //         // Image.asset(IMG_PROJECT),
            //       ),
            //       suffixIconConstraints: BoxConstraints(maxWidth: 30,minWidth: 10 ),
            //       suffixIcon: Icon(Icons.arrow_drop_down)
            //   ),
            // ),
            //DropDownScheduleDate(IMG_CALENDAR, "Schedule Date*", "Select Schedule Date", txtsddate,),
            // DropDownTextField(IMG_CALENDAR, "Schedule Date*", "Select", txtSubject),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }


  SelectSubject() {
    SelectSubjectDialog((value) {
      obj_subject.value=value;
      txtSubject.text = obj_subject.value.name??"";
    });
  }

  Future<dynamic> SelectSubjectDialog(ValueChanged<dynamic> onChange) {
    return SelectDialog1.showModal(
      Get.context!,
      label: "Select Subject",
      items: arrsubjectList,
      onChange: onChange,
      searchBoxDecoration:
      InputDecoration(prefixIcon: Icon(Icons.search), hintText: "Search"),
    );
  }

}