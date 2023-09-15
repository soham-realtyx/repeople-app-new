import 'dart:convert';
import 'dart:io';
import 'package:Repeople/View/DashboardPage/DashboardPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Helper/MoengageAnalyticsHandler.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Model/Theme/WidgetThemeListClass.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:Repeople/Widgets/Loader.dart';
import 'package:Repeople/Widgets/TextEditField.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Config/Helper/ApiResponse.dart';
import '../../Config/utils/styles.dart';
import 'package:dio/dio.dart' as dio;
import '../../Model/CommonModal/CommonModal.dart';
import '../../Model/UserProfileModel/UserProfileModel.dart';
import '../../Widgets/CommomBottomSheet.dart';
import '../../Widgets/select_dailog.dart';
import '../CommonHeaderController/CommenHeaderController.dart';
typedef void OnChange(String value);

class EditProfileController extends GetxController {
  RxList<WidgetThemeListClass> arrAllTheme = RxList<WidgetThemeListClass>();
  RxBool focusFirstName = false.obs;
  RxBool focusLastName = false.obs;
  RxBool focusEmailName = false.obs;
  RxBool focusEmailType = false.obs;
  RxBool focusContact = false.obs;
  RxBool focusProject = false.obs;
  RxBool focusBudget = false.obs;
  RxBool focusDate = false.obs;
  RxBool focusTime = false.obs;
  RxBool focusQuery = false.obs;
  RxBool isRegister = false.obs;

  RxBool isWhatsAppSwitch = false.obs;
  RxBool isAlternateSwitch = false.obs;
  RxString FilePath="".obs;

  TextEditingController txt_image = TextEditingController();

  TextEditingController txt_expire = TextEditingController(text: "06 May 2025");
  DateTime currentData = DateTime.now();

  // RxList<String> arrProfessionList = RxList(['Other','WholeSale','Financial Consultancy','Education','Construction']);


  Rx<UserProfileModel> obj_userprofiledetails = UserProfileModel().obs;
  Rx<Future<UserProfileModel>> futureuserprofiledetailsData = Future.value(UserProfileModel()).obs;

  RxString message = "".obs;

  Rx<CommonModal> obj_profession = CommonModal().obs;
  CommonModal obj_emailtype = CommonModal();

  RxList<CommonModal> arrProfessionList = RxList([]);
  RxList<CommonModal> arrEmailTypeList = RxList([]);

  GlobalKey<ScaffoldState> GlobalEditProfilePagekey = GlobalKey<ScaffoldState>();
  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    LoadData();
    image.value="";
    image.refresh();

  }

    LoadData(){
       retrieveUserProfileDetails();
       retrieveProfessionListData();
       retrieveEmailTypeListData();
    }
  @override
  void onClose() {
    // TODO: implement dispose
    super.onClose();
    isocode1.value="";
    isocode1.obs;
    // isocode="";
    txtContact.clear();
    ccode="";
    //Get.delete<DashboardController>();
  }
  //<editor-fold desc=" Create All Theme List">

  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtEmailType = TextEditingController();
  TextEditingController txtContact = TextEditingController();
  Rxn<TextEditingController> txtContactNew = Rxn(TextEditingController());
  Rxn<TextEditingController> txtAlternateContactNew = Rxn(TextEditingController());
  TextEditingController txtProfession = TextEditingController();
  TextEditingController txtBudget = TextEditingController();
  TextEditingController txtDob = TextEditingController();
  Rxn<TextEditingController>? txtDobnew = Rxn(TextEditingController());
  Rxn<TextEditingController>? txtAnniversarynew = Rxn(TextEditingController());
  TextEditingController txtAnniversary = TextEditingController();

  Rxn<TextEditingController> txtFirstNameNew = Rxn(TextEditingController());
  Rxn<TextEditingController> txtLastNameNew = Rxn(TextEditingController());
  Rxn<TextEditingController> txtEmailNew = Rxn(TextEditingController());

  var formKey = GlobalKey<FormState>();
  var formKey2 = GlobalKey<FormState>();



  Future<List<CommonModal>> retrieveProfessionListData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    arrProfessionList = RxList([]);
    var data = {'action': 'filloccupation'};

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
      List result = responseData['result'];
      arrProfessionList.value =
          List.from(result.map((e) => CommonModal.fromJson(e)));
      arrProfessionList.refresh();
      if(arrProfessionList.isNotEmpty){
      obj_profession.value = arrProfessionList[0];
      txtProfession.text = obj_profession.value.name!;}

    }
    return arrProfessionList;
  }

  Future<List<CommonModal>> retrieveEmailTypeListData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    arrEmailTypeList = RxList([]);
    var data = {'action': 'fillemailtype'};

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
      arrEmailTypeList.value =
          List.from(result.map((e) => CommonModal.fromJson(e)));
      arrEmailTypeList.refresh();
      if(arrEmailTypeList.isNotEmpty){
      obj_emailtype = arrEmailTypeList[0];
      txtEmailType.text = obj_emailtype.name!;}
    }
    return arrEmailTypeList;
  }

  editProfile() async {
    print(image.value);

    SharedPreferences sp = await SharedPreferences.getInstance();
       appLoader(contextCommon);

      Map<String, dynamic> data = {};

      data['action']= "userprofileupdate";
      data['fname'] = txtFirstNameNew.value?.text.trim();
      data['lname'] = txtLastNameNew.value?.text.trim();
      data['email'] = txtEmailNew.value?.text.trim();
      data['emailtype'] = obj_emailtype.id??"";
      data['proffession'] = json.encode([obj_profession.value.toJson()]);
      data['birthdate'] = txtDobnew?.value?.text.trim();
      data['anniversarydate'] = txtAnniversarynew?.value?.text.trim();
      data['alternatemobile'] = txtAlternateContactNew.value?.text.trim();
      data['alternatecountrycode'] = countrycode.value.toString();
      data['alternatecountrycodestr'] = countrystr.value.toString();
      data['iswhatsApp'] = isWhatsAppSwitch.value==true?"1":"0";
      data['isalternatewhatsApp'] = isAlternateSwitch.value==true?"1":"0";
      if(image.value.isNotEmpty){
        data['profileimg'] = await dio.MultipartFile.fromFile(image.value);
      }
      var headers = {
        'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??""
      };
      print("updateprofiledata**********"+data.toString());
      ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_USERPROFILEDETAILS,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers,
      );
      Map<String, dynamic>? responseData = await response.getResponse();
      if (responseData!['status'] == 1) {

        sp.setString(IS_WHATSAPP_KEY,data['iswhatsApp'].toString());
        sp.setString(ALTERNATE_WHATSAPP_KEY,data['isalternatewhatsApp'].toString());

         removeAppLoader(contextCommon);
         try{
           MoengageAnalyticsHandler().track_event("profile_update");
           MoengageAnalyticsHandler().SetUserIdentify(responseData[SESSION_CONTACT]);
           MoengageAnalyticsHandler().SetUserProfile(
               responseData[SESSION_UID],
               responseData[SESSION_CONTACT],
               responseData[SESSION_PERSONNAME],
               responseData[SESSION_EMAIL],
               responseData[SESSION_PROFILEPIC]
           );

         }catch(ex){
           print('logincontroller'+ex.toString());
         }
         retrieveUserProfileDetails().then((value) {
           SuccessMsg(responseData['message'], title: "Success");
           if(isRegister.value) {
             Get.offAll(()=>const DashboardPage());
           }else{
             Get.back(result: "1");
           }
           // Get.offAll(MyAccountPage());
         });
        userProffessionName.value=obj_profession.value.name??"";
        userProffessionName.refresh();
        isAlternateWSwitch.value="0";
        isAlternateWSwitch.refresh();
          image.value="";
          image.refresh();
      } else {

        removeAppLoader(contextCommon);
        validationMsg(responseData['message']);
        print(responseData['message']);
      }
  }

  selectProfession() {
    SelectProfessionDialog((value) {
      obj_profession.value=value;
      txtProfession.text = obj_profession.value.name??"";
    });
  }

  Future<dynamic> SelectProfessionDialog(ValueChanged<CommonModal> onChange) {
    return SelectDialog1.showModal<CommonModal>(
      Get.context!,
      label: "Select Profession",
      items: arrProfessionList,
      onChange: onChange,
      searchBoxDecoration: InputDecoration(prefixIcon: Icon(Icons.search,color: AppColors.grey_color), hintText: "Search",hintStyle: TextStyle(color: AppColors.grey_color)),
    );
  }

  selectEmailType() {
    selectEmailTypeDialog((value) {
      obj_emailtype=value;
      txtEmailType.text = obj_emailtype.name??"";
    });
  }

  Future<dynamic> selectEmailTypeDialog(ValueChanged<CommonModal> onChange) {
    return SelectDialog1.showModal<CommonModal>(

      Get.context!,
      label: "Select Email Type",
      items: arrEmailTypeList,
      onChange: onChange,
      searchBoxDecoration: InputDecoration(prefixIcon: Icon(Icons.search,color: AppColors.grey_color), hintText: "Search",hintStyle: TextStyle(color: AppColors.grey_color)),
    );
  }

  Future<UserProfileModel> retrieveUserProfileDetails() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var data = {
      'action': 'filluserprofile',
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
      obj_userprofiledetails.value= UserProfileModel.fromJson(responseData['data']);
      obj_userprofiledetails.refresh();
      sp.setString(SESSION_EMAIL, obj_userprofiledetails.value.email??"");
      sp.setString(SESSION_PERSONNAME, obj_userprofiledetails.value.personname??"");
      sp.setString(SESSION_PROFILEPIC, obj_userprofiledetails.value.profile??"");
      sp.setString(SESSION_FIRSTNAME, obj_userprofiledetails.value.fname??"");
      sp.setString(SESSION_LASTNAME, obj_userprofiledetails.value.lname??"");
      FillEditData(obj_userprofiledetails.value);

    } else {

      message.value = responseData['message'];

    }
    return obj_userprofiledetails.value;

  }

  FillEditData(UserProfileModel obj)async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    txtFirstNameNew.value?.text=obj.fname?.capitalizestring()??"";
    txtLastNameNew.value?.text=obj.lname?.capitalizestring()??"";
    txtEmailNew.value?.text=obj.email??"";
    txtContactNew.value?.text=obj.mobileno??"";
    txtAlternateContactNew.value?.text=obj.alternateMobile??"";

    print(image.value);
    print("image.value");
    if(obj.proffession!=null && obj.proffession!=""){
      retrieveProfessionListData().whenComplete(() {
        obj_profession.value = arrProfessionList.singleWhere((element) =>
        element.name.toString().trim().toLowerCase() ==
            obj_userprofiledetails.value.proffession.toString()
                .trim()
                .toLowerCase(),
            orElse: () => CommonModal());
        if (obj_profession.value == CommonModal() &&
            arrProfessionList.isNotEmpty) {
          obj_profession.value = arrProfessionList[0];
          txtProfession.text = obj_profession.value.name!;
        } else {
          txtProfession.text = obj_profession.value.name ?? "";
          print(obj_profession.value.name.toString());
        }
        userProffessionName.value = obj_profession.value.name ?? "";
        userProffessionName.refresh();


        sp.setString(SESSION_USERPROFESSIONNAME, obj_profession.value.name ?? "");
      });
    }
    if(obj.emailtype!=null){
      retrieveEmailTypeListData().whenComplete(() {
        obj_emailtype=arrEmailTypeList.singleWhere((element) => element.id==obj.emailtype,
            orElse: ()=>CommonModal());
        txtEmailType.text=obj_emailtype.name??"";
        print(obj_emailtype.name.toString());

      });
    }

    if(obj.isWhatsApp=="1"){
      isWhatsAppSwitch.value=true;
    }else{
      isWhatsAppSwitch.value=false;
    }

    if(obj.isAlternateWhatsApp=="1"){
      isAlternateSwitch.value=true;
    }else{
      isAlternateSwitch.value=false;
    }

    alternate_mobile.value=obj.alternateMobile??"";
    alternate_mobile.refresh();
    isAlternateWSwitch.value=obj.isAlternateWhatsApp??"";
    isWhatsApp.value=obj.isWhatsApp??"";
    txtDobnew?.value?.text=obj.bod??"";
    txtAnniversarynew?.value?.text=obj.anniversarydate?.capitalizestring()??"";

  }


  ImagePicker imagePicker = ImagePicker();
  RxString image="".obs;

  profileImagePicker(){
    showCupertinoModalPopup(
        context: Get.context!,
        builder: (context) {
          return CupertinoActionSheet(
            cancelButton: CupertinoActionSheetAction(
              child: Text("Close"),
              onPressed: () {
                Get.back();
              },
            ),
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  Get.back();
                  CheckCameraPermission();
                },
                child: Text(
                  "Camera",
                  style: TextStyle(color: APP_FONT_COLOR,fontSize: 16, fontWeight:FontWeight.normal),
                ),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Get.back();
                  ChooseImage();
                },
                child: Text(
                  "Choose Photo",
                  style: TextStyle(color: APP_FONT_COLOR,fontSize: 16, fontWeight:FontWeight.normal),
                ),
              ),
            ],
          );
        });
  }

  Future<void> CheckCameraPermission() async {
    if (Platform.isAndroid) {
      bool status = await Permission.camera.isGranted;
      if (status) {
        // further process
        CameraSelect();
      } else if (await Permission.camera.isDenied) {
        await Permission.camera.request().then((value) {
          if (value == PermissionStatus.granted) {
            // further process
            CameraSelect();
          } else if (value == PermissionStatus.denied) {
            // dialog
            // ValidationMsg("you can not access camera");
            print("you can not access camera");
            // BottomSheetDialog(
            //     isDismissible: false,
            //     child: Column(
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         ShowMessage("You can not access Camera"),
            //       ],
            //     ),
            //     isHideAutoDialog: true,
            //     message: "error",
            //     backgroundColor: AppColors.RED);
          }
        });
      }
    } else {
      CameraSelect();
    }
  }

  void CameraSelect() async {
    try {
      var response = await imagePicker.pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.front);
      if (response != null) {
        // ProfilePath.value=response.path;
        // ProfilePath.refresh();
        //
        // txt_image.text=ProfilePath.value.split("/").last.toString();
        File file = File(response.path);
        // SendUpdatedProfile(file);
        _cropImage(file);
      } else {
        print("No image selected");
      }
    } catch (e) {
      print("Error :--- \n $e");
    }
  }
  Future<void> _cropImage(File _pickedFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: _pickedFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      // uiSettings: buildUiSettings(context),
    );
    if (croppedFile != null) {

      image.value=croppedFile.path;
     print(image.value);
      // SendUpdatedProfile(croppedFile);
      print("photo update succesfully");
    }
  }

  Future<void> CheckStoargePermission() async {
    if (Platform.isAndroid) {
      bool status = await Permission.storage.isGranted;
      if (status) {
        // further process
        ChooseImage();
      } else if (await Permission.storage.isDenied) {
        await Permission.storage.request().then((value) {
          if (value == PermissionStatus.granted) {
            // further process
            ChooseImage();
          } else if (value == PermissionStatus.denied) {
            // dialog
            // ValidationMsg("you can not access gallery");
            print("you can not access gallery");
            // BottomSheetDialog(
            //     isDismissible: false,
            //     child: Column(
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         ShowMessage("You can not access Gallery"),
            //       ],
            //     ),
            //     isHideAutoDialog: true,
            //     message: "error",
            //     backgroundColor: AppColors.RED);
          }
        });
      }
    } else {
      ChooseImage();
    }
  }

  void ChooseImage() async {
    try {
      var response = await imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (response != null) {
        // ProfilePath.value=response.path;
        // ProfilePath.refresh();
        // txt_image.text=FilePath.value.split("/").last.toString();
        File file = File(response.path);
        _cropImage(file);
        // SendUpdatedProfile(file);
      } else {
        print("No Image Selected");
      }
    } catch (e) {
      print("Error :--- \n $e");
    }
  }

  Widget QueryTextField_1(TextEditingController controller) {
    return TextFormField(
      maxLines: 4,
      decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(cornarradius)),
              borderSide: BorderSide(color: LIGHT_GREY)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(cornarradius)),
              borderSide: BorderSide(color: LIGHT_GREY)),
          // prefixIconConstraints: BoxConstraints(
          //   maxHeight: 25,
          //   maxWidth: 25
          // ),
          hintText: "",
          hintStyle: TextStyle(color: LIGHT_GREY),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(
              left: 10,
              bottom: 65,
            ),
            child: Image.asset(
              IMG_EDIT,
              color: LIGHT_GREY,
              height: 28,
              width: 28,
            ),
          )),
    );
  }





}
enum DateSelection { DOB, Anniversary, KidDOB }