import 'dart:convert';

import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/Helper/ApiResponse.dart';
import 'package:Repeople/Config/Helper/MoengageAnalyticsHandler.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Model/AddProperty/AddPropertyPlotModel.dart';
import 'package:Repeople/Model/AddProperty/AddPropertyUnitModel.dart';
import 'package:Repeople/Model/AddProperty/AddPropertyVillaModel.dart';
import 'package:Repeople/Model/AddProperty/AddPropertybuildingModel.dart';
import 'package:Repeople/Model/CommonModal/CommonModal.dart';
import 'package:Repeople/Model/Theme/WidgetThemeListClass.dart';
import 'package:Repeople/Widgets/CountryCodeDialog.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:Repeople/Widgets/IntelCountryCode.dart';
import 'package:Repeople/Widgets/Loader.dart';
import 'package:Repeople/Widgets/TextEditField.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Config/utils/styles.dart';
import '../../Widgets/CommomBottomSheet.dart';
import '../../Widgets/select_dailog.dart';
import '../CommonHeaderController/CommenHeaderController.dart';
enum PropertyType {
  PLOT,
  VILLA,
  BUILDING,
  NONE
}

class AddNewHomeController extends GetxController {
  RxList<WidgetThemeListClass> arrAllTheme = RxList<WidgetThemeListClass>();
  RxBool focusFirstName = false.obs;
  RxBool focusLastName = false.obs;
  RxBool focusEmailName = false.obs;
  BuildContext context = Get.context!;
  RxList<CommonModal> arrProjectList = RxList([]);
  CommonModal obj_project = CommonModal();
  AddPropertyUnitModel obj_unit = AddPropertyUnitModel();
  AddPropertyPlotModel obj_plot = AddPropertyPlotModel();
  AddPropertyVillaModel obj_villa = AddPropertyVillaModel();
  AddPropertybuildingModel obj_building = AddPropertybuildingModel();
  // RxList<String> arrBuildingList = RxList(['C','B','A']);
  RxBool isshowunitlist=false.obs;
  RxList<AddPropertyUnitModel> arrUnitNumberList = RxList([]);
  RxList<AddPropertyPlotModel> arrPlotList = RxList([]);
  RxList<AddPropertyVillaModel> arrVillaList = RxList([]);
  RxList<AddPropertybuildingModel> arrBuildingList = RxList([]);
  PropertyType selectedtype=PropertyType.NONE;
  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());
  GlobalKey<ScaffoldState> GlobaladdnewhomePagekey = GlobalKey<ScaffoldState>();
  RxBool isListContainData=true.obs;

  @override
  void onInit() {
    super.onInit();
    RetrieveProjectListData();

  }

  //<editor-fold desc=" Create All Theme List">

  SelectProject() {
    SelectProjectDialog((value) {
      obj_project=value;
      print(obj_project.id.toString()+" this is damnnnnn");
      txtProject.text = obj_project.name??"";
      ClearData();
      arrVillaList = RxList([]);
      arrPlotList = RxList([]);
      arrBuildingList = RxList([]);
      RetrievePropertyTypeListData();
      // SelectBuilding();
    });
  }
ClearData(){
  isshowunitlist.value=false;
  isshowunitlist.refresh();
   txtBuilding.text = "";
   txtUnitNo.text = "";
  obj_unit = AddPropertyUnitModel();
  obj_plot = AddPropertyPlotModel();
  obj_villa = AddPropertyVillaModel();
  obj_building = AddPropertybuildingModel();
}
  Future<dynamic> SelectProjectDialog(ValueChanged<dynamic> onChange) {
    return SelectDialog1.showModal<CommonModal>(
      Get.context!,
      label: "Select Project",
      items: arrProjectList,
      showSearchBox: false,
      onChange: onChange,
      searchBoxDecoration:
      const InputDecoration(prefixIcon: Icon(Icons.search), hintText: "Search"),
    );
  }


  SelectBuilding() {
    SelectBuildingDialog((value) {
      txtBuilding.text = value;
    });
  }
  Future<dynamic> SelectBuildingDialog(ValueChanged<dynamic> onChange) {
    return SelectDialog1.showModal(
      Get.context!,
      label: "Select Building",
      items: arrBuildingList,
      onChange: onChange,
      searchBoxDecoration:
      const InputDecoration(prefixIcon: Icon(Icons.search), hintText: "Search"),
    );
  }
  SelectUnitNo() {
    SelectUnitNoDialog((value) {
      obj_unit=value;
      txtUnitNo.text = obj_unit.name??'';
    });
  }

  Future<dynamic> SelectUnitNoDialog(ValueChanged<dynamic> onChange) {
    return SelectDialog1.showModal(
      Get.context!,
      label: "Select Unit No",
      items: arrUnitNumberList,
      onChange: onChange,
      searchBoxDecoration:
      const InputDecoration(prefixIcon: Icon(Icons.search), hintText: "Search"),
    );
  }

  SelectPropertyDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogView();
        },
        useSafeArea: true,
        barrierDismissible: false);
  }
  SelectedProperty(PropertyType type) {

    if(type==PropertyType.PLOT){
      isshowunitlist.value=false;
      selectedtype=PropertyType.PLOT;
      isshowunitlist.refresh();
       obj_unit = AddPropertyUnitModel();
       obj_villa = AddPropertyVillaModel();
       obj_building = AddPropertybuildingModel();
      txtBuilding.text=obj_plot.plotname??'';

    } else if(type==PropertyType.VILLA){
      isshowunitlist.value=false;
      selectedtype=PropertyType.VILLA;
      isshowunitlist.refresh();
      obj_unit = AddPropertyUnitModel();
      obj_plot = AddPropertyPlotModel();
      obj_building = AddPropertybuildingModel();
      txtBuilding.text=obj_villa.vilaname??'';

    } else if(type==PropertyType.BUILDING){
      obj_unit = AddPropertyUnitModel();
      obj_plot = AddPropertyPlotModel();
      obj_villa = AddPropertyVillaModel();
      isshowunitlist.value=true;
      selectedtype=PropertyType.BUILDING;
      isshowunitlist.refresh();
      txtBuilding.text=obj_building.buildingname??'';
      RetrieveUnitListData();
    }
    update();
  }

  Widget DialogView() {
    return Obx(() =>  Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.WHITE,
        ),
        width: Get.width,
        height: Get.height / 1.7,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: Container(
                color: AppColors.WHITE,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (arrPlotList.length>0)
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5.w),
                              Text(
                                'Plot',
                                style: semiBoldTextStyle(),
                              ),
                              Divider(),
                              SizedBox(height: 5.w),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (_, index) {
                                  AddPropertyPlotModel obj =
                                  arrPlotList[index];
                                  return InkWell(
                                    onTap: () {
                                      obj_plot=obj;
                                      Get.back();
                                      SelectedProperty(PropertyType.PLOT);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 12, top: 12),
                                      child: Container(
                                        child: Text(
                                          obj.plotname??"",
                                          style: regularTextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: arrPlotList.length,
                              ),
                                SizedBox(
                                  height: 20.w,
                                ),



                            ],
                          ),
                        ),
                      if (arrVillaList.length>0)
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5.w),
                              Text(
                                'Villa',
                                style: semiBoldTextStyle(),
                              ),
                              const Divider(),
                              SizedBox(height: 5.w),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (_, index) {
                                  AddPropertyVillaModel obj =
                                  arrVillaList[index];
                                  return InkWell(
                                    onTap: () {
                                      obj_villa=obj;
                                      SelectedProperty(PropertyType.VILLA);
                                      Get.back();

                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 12, top: 12),
                                      child: Container(
                                        child: Text(
                                          obj.vilaname??"",
                                          style:  regularTextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: arrVillaList.length,
                              ),
                              SizedBox(
                                height: 20.w,
                              ),
                            ],
                          ),
                        ),
                      if(arrBuildingList.value.isNotEmpty)
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5.w),
                              Text(
                                'Building',
                                style: semiBoldTextStyle(),
                              ),
                              Divider(),
                              SizedBox(height: 5.w),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (_, index) {
                                  AddPropertybuildingModel obj =
                                  arrBuildingList[index];
                                  return InkWell(
                                    onTap: () {
                                      obj_building=obj;
                                      Get.back();
                                      SelectedProperty(PropertyType.BUILDING);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 12, top: 12),
                                      child: Container(
                                        child: Text(
                                          obj.buildingname??"",
                                          style:  regularTextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: arrBuildingList.length,
                              ),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Select Property Type", style: boldTextStyle()),
                    Divider(thickness: 2),
                    SizedBox(
                      height: 5.w,
                    ),
                    // TextField(
                    //   decoration: InputDecoration(
                    //       border: UnderlineInputBorder(),
                    //       prefixIcon: Icon(Icons.search),
                    //       hintText: "Search"),
                    // ),
                  ],
                ),
              ),
            ),
            Positioned(
                bottom: 0,
                right: 0,
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Close",
                      style: TextStyle(color: Colors.black38, fontSize: 14),
                    )))
          ],
        ),
      ),
    ));
  }

  Future<List<CommonModal>> RetrieveProjectListData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    arrProjectList = RxList([]);
    var data = {
      'action': 'fillproject',
      'flag': '1',

    };

    var headers = {
      // "Authorization":"JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJ1c2VybmFtZSI6IjkxNjc4NzYwMjgiLCJleHAiOjE5MjkwOTkyMzUsImVtYWlsIjpudWxsLCJtb2JpbGVfbm8iOiI5MTY3ODc2MDI4Iiwib3JpZ19pYXQiOjE2MTM3MzkyMzUsImRldmljZV9pZCI6ImFiYyIsImJ1aWxkZXJfaWQiOiJyYXVuYWstZ3JvdXAiLCJndWVzdCI6ZmFsc2UsInVzZXJfdHlwZSI6Ik1hc3RlciBBZG1pbiIsInVzZXJfdHlwZV9pZCI6LTF9.oEqoeFWiljm6pylULqBL7IHzm1IJOHFh8xKJk1_TTKU",
      // "content-type":"application/json"

      'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",


      // 'cmpid': "60549434a958c62f010daa2f"
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
      obj_project = arrProjectList[0];
      txtProject.text = obj_project.name!;
      if(obj_project.id!=null){
        RetrievePropertyTypeListData();
      }
    }
    return arrProjectList;
  }

  Future<List<AddPropertyUnitModel>> RetrieveUnitListData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    arrUnitNumberList = RxList([]);
    var data = {
      'action': 'fillprojectunit',
     'projectid': obj_project.id??"",
      'buildingid': obj_building.buildingid??"",

    };

    var headers = {
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",
      // 'cmpid': "60549434a958c62f010daa2f"
    };

    ApiResponse response = ApiResponse(
      data: data,
      base_url: URL_PROJECTLIST,
      apiHeaderType: ApiHeaderType.Content,
      headerdata: headers,
    );
    Map<String, dynamic>? responseData = await response.getResponse();

    if (responseData!['status'] == 1) {
      List result = responseData['data']['unit'];
      MoengageAnalyticsHandler().SendAnalytics({'project_id': obj_project.id??"",
        'building_id': obj_building.buildingid??"",'project_name':obj_project.name??""}, "add_new_property");
      arrUnitNumberList.value =
          List.from(result.map((e) => AddPropertyUnitModel.fromJson(e)));
      arrUnitNumberList.refresh();
      // obj_unit = arrUnitNumberList[0];
      // txtUnitNo.text = obj_unit.name!;

    }
    return arrUnitNumberList;
  }

  Future<void> RetrievePropertyTypeListData() async {
    Apploader(contextCommon);
    SharedPreferences sp = await SharedPreferences.getInstance();
    arrVillaList = RxList([]);
    arrPlotList = RxList([]);
    arrBuildingList = RxList([]);
    var data = {
      'action': 'fillprojectunit',
      'projectid': obj_project.id??"",
    };

    var headers = {'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",};

    ApiResponse response = ApiResponse(
      data: data,
      base_url: URL_PROJECTLIST,
      apiHeaderType: ApiHeaderType.Content,
      headerdata: headers,
    );
    Map<String, dynamic>? responseData = await response.getResponse();

    print(responseData.toString()+" this is my building reponce");
    print("my lengthhhh is more than 1");

    if (responseData!['status'] == 1) {

      if(responseData['data']['plot']!=null){
        List plotresult = responseData['data']['plot'];
        arrPlotList.value =
            List.from(plotresult.map((e) => AddPropertyPlotModel.fromJson(e)));
        arrPlotList.refresh();
      }
      if( responseData['data']['villa']!=null){
        List villaresult = responseData['data']['villa'];
        arrVillaList.value =
            List.from(villaresult.map((e) => AddPropertyVillaModel.fromJson(e)));
        arrVillaList.refresh();
      }

      if( responseData['data']['building']!=null){
        List buildingresult = responseData['data']['building'];
        arrBuildingList.value =
            List.from(buildingresult.map((e) => AddPropertybuildingModel.fromJson(e)));
        arrBuildingList.refresh();
      }

       isListContainData.value=false;

      print("my lengthhhh is more than 2");
      if(arrPlotList.length>0 || arrBuildingList.length>0 || arrVillaList.length>0){
        print("my lengthhhh is more than 3");
        isListContainData.value=true;
        isListContainData.refresh();
      }
      Navigator.pop(contextCommon);

    }else{
      isListContainData.value=false;
      isListContainData.refresh();
      Navigator.pop(contextCommon);
    }

  }

  Future<void> AddNewPropertyData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    appLoader(contextCommon);
    Map<String, dynamic> data = {};
    data['action'] = 'insertuserrequest';
    data['formevent'] = "addright";
    data['mobileno'] = txtContactNew.value.text.trim().toString();
    data['bookingid'] = txtBookingID.value?.text.trim().toString();

  if(selectedtype==PropertyType.PLOT){
    data['unitdetails'] = jsonEncode(obj_plot).toString();
  }
    if(selectedtype==PropertyType.VILLA){
      data['unitdetails'] = jsonEncode(obj_villa).toString();
    }
    if(selectedtype==PropertyType.BUILDING){
      data['unitdetails'] = jsonEncode(obj_unit.toJson()).toString();
    }

    var headerdata = {
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",
    };
    debugPrint("add property data * *  $data");
    ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_USERPROFILEDETAILS,
        headerdata: headerdata,
        apiHeaderType: ApiHeaderType.Content);
    Map<String, dynamic>? responseData = await response.getResponse();
    if (responseData!['status'] == 1) {
      removeAppLoader(contextCommon);
      Get.back();
      SuccessMsg(responseData['message']);

    } else {
      removeAppLoader(contextCommon);
      validationMsg(responseData['message']);

    }
  }


  //</editor-fold>

  TextEditingController txtProject = TextEditingController();
  TextEditingController txtContactNew = TextEditingController();
  TextEditingController txtBuilding = TextEditingController();
  TextEditingController txtUnitNo = TextEditingController();
  Rxn<TextEditingController> txtBookingID = Rxn(TextEditingController());
  var formkey = GlobalKey<FormState>();

  //<editor-fold desc = "Theme 1">


  Future<dynamic> SelectUnitNumberDialog(ValueChanged<dynamic> onChange) {
    return SelectDialog.showModal<AddPropertyUnitModel>(

      Get.context!,
      label: "Select Unit Number",
      items: arrUnitNumberList,
      onChange: onChange,
      searchBoxDecoration: InputDecoration(prefixIcon: Icon(Icons.search,color: AppColors.grey_color), hintText: "Search",hintStyle: TextStyle(color: AppColors.grey_color)),
    );
  }
  Widget PhoneNumberTextField(TextEditingController? controller,) {
    return IntlPhoneCustomField(

      controller: txtContactNew,
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
      dropdownIcon: const Icon(Icons.arrow_drop_down,size: 26),
      dropdownTextStyle:boldTextStyle(fontSize: 16, txtColor: APP_FONT_COLOR),
      showCountryFlag: false,
      hintText: "9876543210",

      hintStyle: TextStyle(
          fontSize: 16,
          color: gray_color_1,
          height: 1,
          fontWeight: FontWeight.w700),
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
        if (txtContactNew.value.text.isNotEmpty) {
          // formMobileKey.currentState!.validate();
        }
      },
      onCountryChanged: (country) {
        selectedCountry.value = country;
        txtContactNew.text = "";
        // formMobileKey.currentState!.validate();
      },
      // ),
      decoration: InputDecoration(
        counterText: "",
        contentPadding: EdgeInsets.only(bottom: 16),
        hintText: "9876543210",
        hintStyle: TextStyle(
            fontSize: 16,
            color: Colors.grey.withOpacity(0.8),
            fontWeight: FontWeight.bold),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: gray_color_1)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: LIGHT_GREY)),
        errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red)),
        disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red)),
        focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red)),

      ),
    );
  }


  Widget Submit() {
    return Container(
      width: Get.width,
      padding: EdgeInsets.only(top: 30, bottom: 30),
      decoration: BoxDecoration(
          color: APP_THEME_COLOR,
          borderRadius:
          BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))),
      child: Center(
        child: OnTapButton(
            width: 120,
            height: 40,
            text: "Submit",
            decoration: CustomDecorations().backgroundlocal(white, cornarradius, 0, white),
            style: TextStyle(color: APP_FONT_COLOR)),
      ),
    );
  }


}
