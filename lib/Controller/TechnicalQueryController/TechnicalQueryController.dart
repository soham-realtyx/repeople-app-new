import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Model/Theme/WidgetThemeListClass.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:Repeople/Widgets/TextEditField.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart' as dio;

import '../../Config/Helper/ApiResponse.dart';
import '../../Config/utils/styles.dart';
import '../../Model/CommonModal/CommonModal.dart';
import '../../Widgets/CommomBottomSheet.dart';
import '../../Widgets/CommonBackButtonFor5theme.dart';
import '../../Widgets/select_dailog.dart';
import '../CommonHeaderController/CommenHeaderController.dart';


class TechnicalQueryController extends GetxController{
  List<WidgetThemeListClass> arrAllThemList = [];
  int fileType = (-1);
  File? fileValue;
  //FirebaseMessaging? firebaseMessaging;
  List<PlatformFile> arrFileList = [];
  List<PlatformFile> arrImageList = [];
  List<PlatformFile> arrImageAndFileList = [];

  var formkey = GlobalKey<FormState>();
  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());
  GlobalKey<ScaffoldState> GlobalTechnicalkey = GlobalKey<ScaffoldState>();
// final FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    //firebaseMessaging = FirebaseMessaging.instance;
    //_register();
    RetrieveSubjectListData();
  }
  void launchUrl(String url) async {
    if (await canLaunch(url)) {
      launch(url);
    } else {
      throw "Could not launch $url";
    }
  }

  register()async {
    print("token");
    try{
      await FirebaseMessaging.instance.getToken().then((value) {
        txtMassage.text=value!;
        print('deviceId = $value');
      });
   }catch(ex){
      txtMassage.text=ex.toString();
      print(ex);
    }
  }

  Rx<CommonModal> obj_subject = CommonModal().obs;
  RxList<CommonModal> arrsubjectList = RxList([]);

  OnSelectDialog(){
    showCupertinoModalPopup(context: Get.context!, builder: (context){
      return CupertinoActionSheet(
        cancelButton: CupertinoActionSheetAction(
          child: Text("Close"),
          onPressed: (){
            Get.back();
          },
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: (){
              Get.back();
              CameraSelect();

            },
            child: Text("Camera",style:
            TextStyle(color: APP_FONT_COLOR,fontSize: 16, fontWeight:FontWeight.normal),),
          ),
          CupertinoActionSheetAction(
            onPressed: (){
              Get.back();
              ChooseImage();
            },
            child: Text("Choose Photo",style:
            TextStyle(color: APP_FONT_COLOR,fontSize: 16, fontWeight:FontWeight.normal),),
          ),
          CupertinoActionSheetAction(
            onPressed: (){
              Get.back();
              FileChoose();
            },
            child: Text("File",style: TextStyle(color: APP_FONT_COLOR,fontSize: 16, fontWeight:FontWeight.normal),),
          ),
        ],
      );
    });
  }

  ImagePicker imagePicker = ImagePicker();

  // Camera file type = 1;
  void CameraSelect()async{
    try{
      var response = await imagePicker.pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.front
      );
      if(response != null){
        fileType= 1;
        arrFileList.clear();
        PlatformFile platformFile = PlatformFile(name: response.path, size: 50,path: response.path);
        arrImageList.add(platformFile);
        arrImageAndFileList = arrImageList;
        update();
      }
      else{
        print("No image selected");
      }
    }
    catch(e){
      print("Error :--- \n $e");
    }

  }

  // Storage photo file type = 1
  void ChooseImage() async{
    try{
      var response = await imagePicker.pickMultiImage(
      imageQuality: 50,

      );
      if(response!=null){
        fileType = 1;
        arrFileList.clear();
        List<PlatformFile> arrImageTempList = [];
        arrImageTempList= response.map((e) =>PlatformFile(name: e.path, size: 50,path: e.path) ).toList();
        arrImageList.addAll(arrImageTempList);
        //PlatformFile platformFile = PlatformFile(name: response.path, size: 50,path: response.path);
        //arrImageList.add(platformFile);
        arrImageAndFileList = arrImageList;
        update();
      }
      else{
        print("No Image Selected");
      }
    }
    catch(e){
      print("Error :--- \n $e");
    }
  }

  // Storage file type = 0
 void FileChoose()async{
    try{
      FilePickerResult? response = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: [
          'txt',
          'pdf',
          'xls',
          'xlsx',
          'docx',
          'ppt',
          'doc',
          'ppt',
          'pptx'
        ],
      );

      if(response!=null){
        fileType = 0;
        arrImageList.clear();
        arrFileList.addAll(response.files);
        arrImageAndFileList = arrFileList;
        update();
      }
      else{
        print("No Selected any File");
      }
    }catch(e){
      print("Error :--- \n $e");
    }

  }


  String _setImage(String extension) {
    if (extension == "txt") {
      return IMG_FILEICON;
    } else if (extension == "pdf") {
      return IMG_PDFICON;
    } else if (extension == "xls" || extension == "xlsx") {
      return IMG_XLSICON;
    } else if (extension == "doc" || extension == "docx") {
      return IMG_DOCICON;
    } else if (extension == "ppt" || extension == "pptx") {
      return IMG_PPTICON;
    } else {
      return IMG_FILEICON;
    }
  }

  //</editor-fold>

  //<editor-fold desc = "File Picker Widget">
  File? fileImage;
  String? imgPdf;



  Widget FileBlock(int index){

    if (fileType == 1) {
      fileImage = File(arrImageList[index].path!);
    } else {
      fileImage = File(arrFileList[index].path!);
      imgPdf = _setImage(arrFileList[index].extension!);
    }

    return Stack(
      children: [
        Container(
            margin: EdgeInsets.all(5),
            height: 80,
            width: 80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(cornarradius)),
                border: Border.all(color: APP_FONT_COLOR,width: 0.5,style: BorderStyle.solid)
            ),
            clipBehavior: Clip.hardEdge,
            child: fileType == 1
                ? Image.file(
              fileImage!,
              height: 80,
              width: 80,
              fit: BoxFit.fill,
            ) : Image.asset(imgPdf!, height: 100, width: 100),
        ),
        Positioned(
          top: 0.0,
          right: 0.0,
          child: new IconButton(
              padding: EdgeInsets.all(0.0),
              constraints: BoxConstraints(),
              icon: Icon(
                Icons.cancel,
              ),
              onPressed: () {
                if (fileType == 1) {
                  arrImageList.removeAt(index);
                  if (arrImageList.length == 0) {
                    fileType= -1;
                  }
                } else if (fileType == 0) {
                  arrFileList.removeAt(index);
                  if (arrFileList.length == 0) {
                    fileType = -1;
                  }
                }
                update();
              }),
        )
      ],
    );
  }
  //</editor-fold>

  TextEditingController txtSubject = TextEditingController();
  TextEditingController txtFile = TextEditingController();
  TextEditingController txtMassage = TextEditingController();
  Rxn<TextEditingController> txtMassageNew = Rxn(TextEditingController());

  //<editor-fold desc = "Theme 2">
  SelectSubject() {
    SelectSubjectDialog((value) {
      obj_subject.value=value;
      txtSubject.text = obj_subject.value.name??"";
    });
  }

  Future<dynamic> SelectSubjectDialog(ValueChanged<dynamic> onChange) {
    return SelectDialog1.showModal(
      Get.context!,
      label: "Select subject",
      items: arrsubjectList,
      onChange: onChange,
      searchBoxDecoration:
      const InputDecoration(prefixIcon: Icon(Icons.search), hintText: "Search"),
    );
  }

  //<editor-fold desc = "Api Calles ">
  Future<List<CommonModal>> RetrieveSubjectListData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    arrsubjectList = RxList([]);
    var data = {'action': 'filltechnicalquery'};

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
      List result = responseData['data'];
      arrsubjectList.value =
          List.from(result.map((e) => CommonModal.fromJson(e)));
      arrsubjectList.refresh();
      obj_subject.value = arrsubjectList[0];
      txtSubject.text = obj_subject.value.name!;
    }

    return arrsubjectList;
  }

  SubmitTechnicalQuery() async {
    Apploader(contextCommon);
    try{

      SharedPreferences sp = await SharedPreferences.getInstance();

      Map<String, dynamic> data = {
        'action': 'addtechnicalquery',
        'message': txtMassageNew.value!.text,
        'querytype': obj_subject.value.id.toString(),


      };

      if (arrImageAndFileList.length > 0) {
        for (int i = 0; i < arrImageAndFileList.length; i++) {
          data['images[$i]'] = await dio.MultipartFile.fromFile(arrImageAndFileList[i].path!);
          //print(images[i].path);
        }
      }

      print(data.toString()+" this is my text data");

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
        validationMsg(responseData['message'] ?? "Something Went Wrong");
      }

    }catch(e){
      Navigator.pop(contextCommon);
      validationMsg("Something Went Wrong");
    }



  }


}