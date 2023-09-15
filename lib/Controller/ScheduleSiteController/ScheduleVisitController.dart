
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/View/ReferralPage/ReferralPage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/Helper/MoengageAnalyticsHandler.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Model/Theme/WidgetThemeListClass.dart';
import 'package:Repeople/Widgets/CommonBackButtonFor5theme.dart';
import 'package:Repeople/Widgets/CountryCodeDialog.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:Repeople/Widgets/IntelCountryCode.dart';
import 'package:Repeople/Widgets/TextEditField.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Config/Helper/ApiResponse.dart';
import '../../Config/utils/styles.dart';
import '../../Model/BudgetModel/BudgetModel.dart';
import '../../Model/CommonModal/CommonModal.dart';
import '../../Widgets/CommomBottomSheet.dart';
import '../../Widgets/select_dailog.dart';
import '../CommonHeaderController/CommenHeaderController.dart';

typedef void OnChange(String value);

class ScheduleSiteController extends GetxController {
  RxList<WidgetThemeListClass> arrAllTheme = RxList<WidgetThemeListClass>();
  RxBool focusFirstName = false.obs;
  RxBool focusLastName = false.obs;
  RxBool focusEmailName = false.obs;
  RxBool focusContact = false.obs;
  RxBool focusProject = false.obs;
  RxBool focusBudget = false.obs;
  RxBool focusDate = false.obs;
  RxBool focusTime = false.obs;
  RxBool focusQuery = false.obs;
  FocusNode mobileFocusNode = FocusNode();
  var formkey = GlobalKey<FormState>();
  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());
  GlobalKey<ScaffoldState> GlobalSchedualsitevisitkey = GlobalKey<ScaffoldState>();
  Rx<Country> selectedCountry = countryIndia().obs;
  RxString countrystr = "IN".obs;
  RxString countrycode = "+91".obs;
  RxList<CommonModal> arrProjectList = RxList([]);
  RxList<BudgetApiModel> arrBudgetMainList = RxList([]);
  Rx<CommonModal> obj_project = CommonModal().obs;
  Rx<BudgetApiModel> obj_budget = BudgetApiModel().obs;
  FocusNode fcn_node=FocusNode();

  RxList<String> arrBudgetList = RxList([
    '10 Lac - 1 Cr',
    '1 Cr - 1.25 Cr',
    '1.25 Cr - 3 Cr',
    '3 Cr - 4 Cr',
    '4 Cr - 5 Cr',
  ]);

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    ClearData();
    RetrieveProjectListData();
    RetrieveBudgetListData();
  }
  ClearData(){
    txtScheduleTime.text='';
    txtScheduleTimeNew.value?.text='';
    txtFirstNameNew.value?.text='';
    txtLastNameNew.value?.text='';
    txtEmailNew.value?.text='';
    txtScheduleDateNew.value?.text='';
    txtQueryNew.value?.text='';
    txtContactNew.value?.text='';
    obj_budget.value!=null;
    obj_budget.value.minbudget=0;
    obj_budget.value.maxbudget=0;
  }
  @override
  void onClose() {
    // TODO: implement dispose
    super.onClose();
    isocode1.value = "";
    isocode1.obs;
    txtContact.clear();
    ccode = "";
  }

  //<editor-fold desc=" Api Calls">

  Future<List<CommonModal>> RetrieveProjectListData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    arrProjectList = RxList([]);
    var data = {
      'action': 'fillproject',
      'flag' : '1'
    };
    var headers = {
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",
    };

    ApiResponse response = ApiResponse(
      data: data,
      base_url: URL_PROJECTLIST,
      apiHeaderType: ApiHeaderType.Content,
      headerdata: headers,
    );
    Map<String, dynamic>? responseData = await response.getResponse();

    if (responseData!['status'] == 1) {
      List result = responseData['result'];
      arrProjectList.value =
          List.from(result.map((e) => CommonModal.fromJson(e)));
      arrProjectList.refresh();
      if(arrProjectList.length>0){
        obj_project.value = arrProjectList[0];
        txtProject.text = obj_project.value.name!;
      }
    }
    return arrProjectList;
  }

  Future<List<BudgetApiModel>> RetrieveBudgetListData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    arrBudgetMainList = RxList([]);
    var data = {
      'action': 'fillbudget',
    };
    var headers = {
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",
    };

    ApiResponse response = ApiResponse(
      data: data,
      base_url: URL_PROJECTLIST,
      apiHeaderType: ApiHeaderType.Content,
      headerdata: headers,
    );
    Map<String, dynamic>? responseData = await response.getResponse();
    if (responseData!['status'] == 1) {
      List result = responseData['data'];
      arrBudgetMainList.value =
          List.from(result.map((e) => BudgetApiModel.fromJson(e)));
      arrBudgetMainList.refresh();
      if(arrBudgetMainList.length>0){
        obj_budget.value = arrBudgetMainList[0];
        txtBudget.text = obj_budget.value.name!;
      }


    }
    return arrBudgetMainList;
  }

   ConfirmSiteVisiteCall() async {
    Apploader(contextCommon);
    try{
      SharedPreferences sp = await SharedPreferences.getInstance();

      var data = {
        'action': 'addsitevisit',
        'fname': txtFirstNameNew.value?.text,
        'lname': txtLastNameNew.value?.text,
        'email': txtEmailNew.value?.text,
        'countrycode': "+"+selectedCountry.value.dialCode,
        'countrycodestr': selectedCountry.value.code.toLowerCase(),
        if(obj_project.value != null)  'projectid': obj_project.value.id,
        'schedule_date': txtScheduleDateNew.value?.text,
        'schedule_time':  txtScheduleTimeNew.value?.text,
        'comment': txtQueryNew.value?.text,
        'mobile': txtContactNew.value?.text,
        'minbudget': obj_budget.value.minbudget,
        'maxbudget': obj_budget.value.maxbudget,

      };
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
        MoengageAnalyticsHandler().SendAnalytics({
          'action': 'addsitevisit',
          'fname': txtFirstNameNew.value?.text,
          'lname': txtLastNameNew.value?.text,
          'email': txtEmailNew.value?.text,
          'countrycode': "+"+selectedCountry.value.dialCode,
          'countrycodestr': selectedCountry.value.code.toLowerCase(),
          if(obj_project.value != null)  'projectid': obj_project.value.id,
          'schedule_date': txtScheduleDateNew.value?.text,
          'schedule_time':  txtScheduleTimeNew.value?.text,
          'comment': txtQueryNew.value?.text,
          'mobile': txtContactNew.value?.text,
          'minbudget': obj_budget.value.minbudget,
          'maxbudget': obj_budget.value.maxbudget,
        }, "add_site_visit");
        Navigator.pop(contextCommon);
       SuccessMsg(responseData['message'] ?? "Schedule a Site visite Successfully" );
       Get.back();
      }
      else{
        Navigator.pop(contextCommon);
        validationMsg(responseData['message'] ?? "Somthing Went Wrong");
      }
    }catch(e){
      validationMsg("Somthing Went Wrong");
      Navigator.pop(contextCommon);
    }
  }

  SelectProject() {
    SelectProjectDialog((value) {
      obj_project.value=value;
      txtProject.text = obj_project.value.name??"";
    });
  }

  Future<dynamic> SelectProjectDialog(ValueChanged<dynamic> onChange) {
    return SelectDialog1.showModal<CommonModal>(

      Get.context!,
      label: "Select Project",
      items: arrProjectList,
      showSearchBox: false,
      onChange: onChange,
      searchBoxDecoration: const InputDecoration(
          prefixIcon: Icon(Icons.search), hintText: "Search"),
    );
  }

  SelectBudget() {
    SelectBudgetDialog((value) {
      obj_budget.value=value;
      txtBudget.text = obj_budget.value.name!;
    });
  }

  Future<dynamic> SelectBudgetDialog(ValueChanged<dynamic> onChange) {
    return SelectDialog1.showModal<BudgetApiModel>(
      Get.context!,
      label: "Select Budget",
      showSearchBox: false,
      items: arrBudgetMainList,
      onChange: onChange,
      searchBoxDecoration: const InputDecoration(
          prefixIcon: Icon(Icons.search), hintText: "Search"),
    );
  }

  //</editor-fold>



  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtContact = TextEditingController();
  TextEditingController txtProject = TextEditingController();
  TextEditingController txtBudget = TextEditingController();
  TextEditingController txtScheduleDate = TextEditingController();
  TextEditingController txtScheduleTime = TextEditingController();
  TextEditingController txtQuery = TextEditingController();


  Rxn<TextEditingController> txtFirstNameNew = Rxn(TextEditingController());
  Rxn<TextEditingController> txtLastNameNew = Rxn(TextEditingController());
  Rxn<TextEditingController> txtEmailNew = Rxn(TextEditingController());
  Rxn<TextEditingController> txtContactNew = Rxn(TextEditingController());
  Rxn<TextEditingController> txtQueryNew = Rxn(TextEditingController());
  Rxn<TextEditingController> txtScheduleDateNew = Rxn(TextEditingController());
  Rxn<TextEditingController> txtScheduleTimeNew = Rxn(TextEditingController());
  // Rxn<TextEditingController> txtFirstNameNew = Rxn(TextEditingController());
  FillProjectData(String project_id){
    if(project_id.isNotEmpty){
      RetrieveProjectListData().whenComplete(() {
        obj_project.value=arrProjectList.singleWhere((element) => element.id==project_id,
            orElse: ()=>CommonModal());
        if(obj_project==CommonModal() && arrProjectList.isNotEmpty){
          obj_project.value = arrProjectList[0];
          txtProject.text = obj_project.value.name!;
        }else {
          txtProject.text = obj_project.value.name ?? "";
          // print(obj_profession.name.toString());
        }
      });
    }
  }
  //<editor-fold desc = "Theme 1">
  Widget Theme_1([bool isshow=false]) {
    return Obx(() =>  Padding(
      padding:  const EdgeInsets.only(left: 20.0,right: 20,top: 10,bottom: 20),
      child: Container(
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
            Container(
              margin: const EdgeInsets.only(left: 0, right: 0),
              child: Form(
                key: formkey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    simpleTextFieldNewWithCustomization(
                      inputFormat: [
                        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                        UpperCaseTextFormatter()],
                        hintText: "John",
                        imageIcon: IMG_USER_SVG_NEW,
                        textCapitalization: TextCapitalization.sentences,
                        controller: txtFirstNameNew,
                        textInputType: TextInputType.name,
                        labelText: "First Name*",
                        maxLength: 72,
                       noAutoValidation: true,
                        validator: (value) =>
                            validation(value, "Please enter first name"),


                   ),
                    const SizedBox(
                      height: 16,
                    ),
                    simpleTextFieldNewWithCustomization(
                        hintText: "Doe",
                        inputFormat: [
                          FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                          UpperCaseTextFormatter()],
                        maxLength: 72,
                        noAutoValidation: true,
                        imageIcon: IMG_USER_SVG_NEW,
                        textCapitalization: TextCapitalization.sentences,
                        controller: txtLastNameNew,
                        textInputType: TextInputType.name,
                        labelText: "Last Name*",
                        validator: (value) =>
                            validation(value, "Please enter last name")),
                    const SizedBox(height: 16,),
                    simpleTextFieldNewWithCustomization(
                        hintText: "johndoe@example.com",
                        imageIcon: IMG_EMAIL_SVG_NEW,
                        controller: txtEmailNew,
                        textInputType: TextInputType.emailAddress,
                        labelText: "Email*",
                        noAutoValidation: true,
                        inputFormat: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z@.]")),
                        ],
                        validator: (value) => emailvalidation(value)),
                    const SizedBox(
                      height: 16,
                    ),
                    //ContactTextField(txtContactNew),
                    PhoneNumberTextField(txtContactNew),
                    const SizedBox(
                      height: 16,
                    ),
                    CommonDropDownTextField(
                      labelText: "Project*",

                      onTap: () {
                        if(isshow==true){
                          SelectProject();}
                      },
                      // imageIcon: IMG_PROJECT_SVG_DASHBOARD,
                      imageIcon: IMG_PROJECT_SVG_NEW,
                      controller: txtProject,
                      hintText: txtProject.text,
                    ),

                    const SizedBox(
                      height: 16,
                    ),
                    CommonDropDownTextField(
                      labelText: "Budget*",
                      onTap: () {
                        SelectBudget();
                      },
                      // imageIcon: IMG_DOLLAR_SVG,
                      imageIcon: IMG_BUDGET_SVG_NEW,
                      controller: txtBudget,
                      hintText: arrBudgetList[0].toString(),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ScheduleSiteVisite(/*IMG_CALENDERDATE_SVG*/ IMG_DATE_SVG_NEW,
                        "Schedule Date*", "Select", txtScheduleDateNew),
                    const SizedBox(
                      height: 16,
                    ),
                    // DropDownTime(IMG_CALENDAR, "Schedule Time*", "Select", txtscheduletime,),z
                  // DropDownTimeSelect(
                  //   IMG_TIME_SVG_NEW,
                  //     "Schedule Time*",
                  //     "Select",
                  //     txtScheduleTimeNew,
                  //   ),
                    CommonDropDownTextField(
                        labelText: "Schedule Time*",
                        onTap: () {
                          selectTime_with_no2(contextCommon, 0, txtScheduleTimeNew);
                        },
                        // imageIcon: IMG_DOLLAR_SVG,
                        validator: (value) => validation(value, "Please select time"),
                        imageIcon: IMG_BUDGET_SVG_NEW,
                        controller: txtScheduleTimeNew.value,
                        hintText: txtScheduleTimeNew.value?.text==""?"Select Time":""
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    QueryTextField_1(txtQueryNew),
                    // SizedBox(
                    //   height: 60,
                    // ),
                    SizedBox(
                      height: isshow?40:0,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            submitButton(),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    ));
  }
  Widget PhoneNumberTextField(Rxn<TextEditingController>? controller,) {
  //  cnt_Leads.ClearFocus();
    return /*Form(
      key: formMobileKey,
      child: */IntlPhoneCustomField(

        controller: txtContactNew.value,
        disableLengthCheck: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
        textAlign: TextAlign.left,
        focusNode: mobileFocusNode,
      autofocus: false,
      keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      textAlignVertical: TextAlignVertical.bottom,
        selectedCountry: selectedCountry.value,
      // flagsButtonPadding: EdgeInsets.only(left: 20),
      validator:(value)=>mobilevalidation(value!),
        onSubmitted: (value) {
          //FocusScope.of(contextCommon).requestFocus(cnt_Leads.emailFocusNode);
        },
      style:  boldTextStyle(fontSize: 16, txtColor: APP_FONT_COLOR),
        dropdownIconPosition: IconPosition.trailing,
        dropdownIcon: Icon(Icons.arrow_drop_down,size: 26),
        dropdownTextStyle:boldTextStyle(fontSize: 16, txtColor: APP_FONT_COLOR),
        showCountryFlag: false,
      hintText: "9876543210",
      hintStyle: TextStyle(
          fontSize: 16,
          color: NewAppColors.GREY,
          fontWeight: FontWeight.bold),
        pickerDialogStyle: PickerDialogCustomStyle(
          backgroundColor: AppColors.BACKGROUND_WHITE,
          countryCodeStyle:
          mediumTextStyle(fontSize: 14, txtColor: APP_FONT_COLOR),
          searchFieldCursorColor: AppColors.BLACK,
          countryNameStyle:
          mediumTextStyle(fontSize: 14, txtColor: APP_FONT_COLOR),
          listTileDivider: Container(
            height: 0.5,
            color: AppColors.grey_color,
          ),
        ),
        initialCountryCode: 'IN',
        cursorColor: AppColors.BLACK,
        onChanged: (phone) {
            countrycode.value = phone.countryCode;
          if (txtContactNew.value!.text.isNotEmpty) {
            // formMobileKey.currentState!.validate();
          }
        },
        onCountryChanged: (country) {
          selectedCountry.value = country;
          txtContactNew.value?.text = "";
          // formMobileKey.currentState!.validate();
        },
     // ),
      decoration: InputDecoration(
        counterText: "",
        // prefixIcon:  Padding(
        //         padding: EdgeInsets.only(top: 0,left: 10),
        //         child: SizedBox(
        //             width: 80.w,
        //             child: Row(
        //                 mainAxisAlignment: MainAxisAlignment.start,
        //                 crossAxisAlignment: CrossAxisAlignment.center,
        //                 children: <Widget>[
        //
        //                   Column(
        //                       mainAxisAlignment:
        //                       MainAxisAlignment.start,
        //                       crossAxisAlignment:
        //                       CrossAxisAlignment.start,
        //                       children: <Widget>[
        //                         Container(
        //                             padding:
        //                             EdgeInsets.only(left: 10,top: 0),
        //                             child: Text(
        //                               "Mobile*",
        //                               style: TextStyle(
        //                                   fontSize: 12,
        //                                   color: Colors.black
        //                                       .withOpacity(0.7),
        //                                   fontWeight:
        //                                   FontWeight.bold),
        //                             )),
        //
        //
        //                       ])
        //                 ]))),

        contentPadding: const EdgeInsets.only(bottom: 16),
        // contentPadding: EdgeInsets.all(20),
        //labelText: labelOpen ? "" : null,
        hintText: "9876543210",
        hintStyle: TextStyle(
            fontSize: 16,
            color: Colors.grey.withOpacity(0.8),
            fontWeight: FontWeight.bold),
        // floatingLabelBehavior: labelOpen
        //     ? FloatingLabelBehavior.always
        //     : FloatingLabelBehavior.never,
        // labelText: 'mobile*',
        // labelStyle: TextStyle(
        //     fontSize: 16,
        //     color:txtContactNew.value!.text.toString().isNotEmpty? Colors.grey.withOpacity(0.7):
        //     Colors.black.withOpacity(0.7),
        //     fontWeight: FontWeight.w600),

        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: LIGHT_GREY)),
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
  Widget SelectBudgetTextField({double padding = 0}) {
    return TextFormField(
      onTap: () {
        SelectBudget();
        // SelectProfession();
      },
      style: boldTextStyle(fontSize: 18, txtColor: APP_FONT_COLOR),
      // TextStyle(fontSize: 18, color: APP_FONT_COLOR, fontWeight: FontWeight.w600),
      readOnly: true,
      controller: txtBudget,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      // validator: (value) =>
      //     validation(value, "Please select budget"),
      decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: LIGHT_GREY)),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: LIGHT_GREY)),
          errorBorder:
          const UnderlineInputBorder(borderSide:  BorderSide(color: Colors.red)),
          disabledBorder:
          const UnderlineInputBorder(borderSide:  BorderSide(color: Colors.red)),
          focusedErrorBorder:
          const UnderlineInputBorder(borderSide:  BorderSide(color: Colors.red)),
          // contentPadding: EdgeInsets.all(20),
          contentPadding:
          const EdgeInsets.only(top: 20, bottom: 20, right: 0, left: 0),
          labelStyle: TextStyle(
              fontSize: 16,
              color: Colors.black.withOpacity(0.7),
              fontWeight: FontWeight.bold),
          labelText: "Select Budget*",
          hintText: arrBudgetList[0].toString(),
          hintStyle: boldTextStyle(fontSize: 18, txtColor: APP_FONT_COLOR),
          // semiBoldTextStyle(fontSize: 18,txtColor: APP_FONT_COLOR),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: padding),
            child: Container(
              width: 50,
              height: 50,
              margin: const EdgeInsets.only(right: 10, left: 0),
              padding: const EdgeInsets.all(10.0),
              decoration: CustomDecorations().backgroundlocal(
                  APP_GRAY_COLOR, cornarradius, 0, APP_GRAY_COLOR),
              child: Center(
                  child: SvgPicture.asset(
                IMG_DOLLAR_SVG, /*height: 25*/
              )
                  // Image.asset(IMG_DOLLAR,height: 25,)
                  ),
            ),
          ),
          suffixIconConstraints: const BoxConstraints(maxWidth: 30, minWidth: 10),
          // prefixIconConstraints: BoxConstraints(maxWidth: 50),
          suffixIcon: const Icon(Icons.arrow_drop_down)
          //suffixIcon: Icon(Icons.arrow_drop_down)),
          ),
    );
  }

  Widget SelectProjectTextField({double padding = 0}) {
    return TextFormField(
      onTap: () {
        SelectProject();
        // SelectProfession();
      },
      style: boldTextStyle(fontSize: 18, txtColor: APP_FONT_COLOR),
      // TextStyle(fontSize: 18, color: APP_FONT_COLOR, fontWeight: FontWeight.w600),
      readOnly: true,
      controller: txtProject,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      // validator: (value) =>
      //     validation(value, "Please select project"),
      decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: LIGHT_GREY)),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: LIGHT_GREY)),
          errorBorder:
          const UnderlineInputBorder(borderSide:  BorderSide(color: Colors.red)),
          disabledBorder:
          const UnderlineInputBorder(borderSide:  BorderSide(color: Colors.red)),
          focusedErrorBorder:
          const UnderlineInputBorder(borderSide:  BorderSide(color: Colors.red)),
          contentPadding:
          const EdgeInsets.only(top: 20, bottom: 20, right: 0, left: 0),
          // isCollapsed: false,
          // hintMaxLines: 1,
          labelStyle: TextStyle(
              fontSize: 16,
              color: Colors.black.withOpacity(0.7),
              fontWeight: FontWeight.bold),
          labelText: "Select Project*",
          hintText: arrProjectList[0].toString(),
          hintStyle: boldTextStyle(fontSize: 18, txtColor: APP_FONT_COLOR),
          // semiBoldTextStyle(fontSize: 18,txtColor: APP_FONT_COLOR),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: padding),
            child: Container(
                width: 50,
                height: 50,
                margin: const EdgeInsets.only(right: 10, left: 0),
                padding: const EdgeInsets.all(10.0),
                decoration: CustomDecorations().backgroundlocal(
                    APP_GRAY_COLOR, cornarradius, 0, APP_GRAY_COLOR),
                child: SvgPicture.asset(IMG_PROJECT_SVG_DASHBOARD)
                // Image.asset(IMG_PROJECT_SVG_DASHBOARD),
                ),
          ),
          suffixIconConstraints: const BoxConstraints(maxWidth: 30, minWidth: 10),
          // prefixIconConstraints: BoxConstraints(maxWidth: 50),
          suffixIcon: const Icon(Icons.arrow_drop_down)),
    );
  }

  Widget QueryTextField_1(Rxn<TextEditingController>? controller) {
    return Obx(() =>TextFormField(
      maxLines: 2,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z@. ]")),
      ],

      controller: controller?.value,
      onChanged: (value){
        controller?.update((val) { });
      },
      style: boldTextStyle(fontSize: 16, txtColor: APP_FONT_COLOR),
      decoration: InputDecoration(
        enabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: gray_color_1)),
        focusedBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: gray_color_1)),
        errorBorder:
        const UnderlineInputBorder(borderSide:  BorderSide(color: Colors.red)),
        disabledBorder:
        const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        focusedErrorBorder:
        const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        // border: InputBorder.none,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: "Message",
        hintText: "",
        labelStyle: TextStyle(
            fontSize: 14.sp,
            color:gray_color_1,
            fontFamily: fontFamily,
            fontWeight: FontWeight.w500),
        hintStyle: TextStyle(color: NewAppColors.GREY),
        // contentPadding: EdgeInsets.all(20),


      ),
    ));
  }

  Widget submitButton() {
    return OnTapButton(
        onTap: () {
          if (formkey.currentState!.validate() ) {
            ConfirmSiteVisiteCall();
          }
        },
        height: 40,
        decoration: CustomDecorations().backgroundlocal(APP_THEME_COLOR, cornarradius, 0, APP_THEME_COLOR),
        text: "Submit".toUpperCase(),
        style: TextStyle(color: white, fontSize: 12.sp, fontWeight: FontWeight.w500));
  }



}
