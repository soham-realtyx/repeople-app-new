import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Model/Document/Document_List_Model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;

import '../../Config/Constant.dart';
import '../../Config/Function.dart';
import '../../Config/Helper/ApiResponse.dart';
import '../../Config/utils/Images.dart';
import '../../Config/utils/Strings.dart';
import '../../Config/utils/colors.dart';
import '../../Widgets/CommomBottomSheet.dart';
import '../../Widgets/CustomDecoration.dart';
import '../CommonHeaderController/CommenHeaderController.dart';

class AddDocumentController extends GetxController {



  TextEditingController DocumentNamecntr=new TextEditingController();
  Rxn<TextEditingController> txtdocumentNew = Rxn(TextEditingController());
  RxList<Doc_List_Model> arrDocCategoryList = RxList<Doc_List_Model>([]);
  Rx<Future<List<Doc_List_Model>>> futureDocCategoryData = Future.value(<Doc_List_Model>[]).obs;

  final formKey = GlobalKey<FormState>();
  int loadmore = 0;
  int pagecount = 1;
  ImagePicker imagePicker = ImagePicker();
  RxString message = "Something Went Wrong".obs;
  RxString DocumentTypeId=''.obs;
  RxString DocumentTypeName=''.obs;
  RxBool isCancel = false.obs;
  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());
  GlobalKey<ScaffoldState> GlobalAddDocumentScreenkey = GlobalKey<ScaffoldState>();

  RxInt addrights = 0.obs;

  int fileType = (-1);
  File? fileValue;

  List<PlatformFile> arrFileList = [];
  List<PlatformFile> arrImageList = [];
  List<PlatformFile> arrImageAndFileList = [];

  File? fileImage;
  String? imgPdf;


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }


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


  void ChooseImage() async{
    try{
      var response = await imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if(response!=null){
        fileType = 1;
        arrFileList.clear();
        PlatformFile platformFile = PlatformFile(name: response.path, size: 50,path: response.path);
        arrImageList.add(platformFile);
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


  Widget FileBlock(int index){

    print(arrImageList.length);
    print(arrFileList.length);

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
            child: fileType== 1
                ? Image.file(
              fileImage!,
              height: 80,
              width: 80,
              fit: BoxFit.fill,
            )
                : Image.asset(imgPdf!, height: 100, width: 100)),
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

//<editor-fold desc = "Document Add APi Call">

   AddDocumentData() async {
    try{

      Apploader(contextCommon);

      SharedPreferences sp = await SharedPreferences.getInstance();
      Map<String, dynamic> data = {
        'action': 'adddocument',
        'documentname':txtdocumentNew.value!.text,
        'document_categoryid':DocumentTypeId.value,
        'document_category':DocumentTypeName.value,
        'formevent':'addright',

      };
      if(arrImageAndFileList.length>0){
        data['document'] = await dio.MultipartFile.fromFile(arrImageAndFileList.first.path.toString());
      }

      var headers = {'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",};

      ApiResponse response = ApiResponse(
          data: data,
          base_url: URL_DOCUMENT_CATEGORY_LIST,
          apiHeaderType: ApiHeaderType.Content,
          headerdata: headers

      );


      Map<String, dynamic>? responseData = await response.getResponse();
      Navigator.pop(contextCommon);
      if (responseData!['status'] == 1) {
        arrImageList.clear();
        arrFileList.clear();
        arrImageAndFileList.clear();
        DocumentNamecntr.clear();
        SuccessMsg(responseData['message'] ?? "document added successfully",title: "Success");
        Get.back(result: "1");


      } else {
        Navigator.pop(contextCommon);
        message.value = responseData['message'];
        validationMsg(message.value);

      }

    }catch(e){
      print(e);
      Navigator.pop(contextCommon);
      validationMsg("Something Went Wrong");
    }


  }

//</editor-fold>






}