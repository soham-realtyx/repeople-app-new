import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Model/Theme/WidgetThemeListClass.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Config/Helper/ApiResponse.dart';
import '../../Model/CommonModal/CommonModal.dart';
import '../../Model/Flat ListModal/FlatListModal.dart';
import '../../Widgets/select_dailog.dart';


class AddNewComplaintController extends GetxController{
  List<WidgetThemeListClass> arrAllThemList = [];
  int fileType = (-1);
  File? fileValue;

  final formKey = GlobalKey<FormState>();

  RxList<PlatformFile> arrFileList = RxList<PlatformFile>();
  RxList<PlatformFile> arrImageList = RxList<PlatformFile>();
  RxList<PlatformFile> arrImageAndFileList = RxList<PlatformFile>();

  TextEditingController txtProject = TextEditingController();

  CommonModal obj_grievance = CommonModal();
  TextEditingController txtgrievance = TextEditingController();
  RxList<CommonModal> arrgrievanceList = RxList([]);

  TextEditingController txtflat = TextEditingController();
  FlatListModal obj_flatlist = FlatListModal();
  RxList<FlatListModal> arrflatdataList = RxList<FlatListModal>([]);



  RxList<String> arrProjectList = RxList([
    'Lift Maintenance and Repair',
    'Civil Work',
    'Genrator',
    'plumbing Work',
    'others',
  ]);

  SelectProject() {
    SelectProjectDialog((value) {
      txtProject.text = value;
    });
  }

  SelectGrievanceType() {
    SelectGrievanceTypeDialog((value) {
      obj_grievance=value;
      txtgrievance.text = obj_grievance.name??"";
    });
  }


  Future<dynamic> SelectGrievanceTypeDialog(ValueChanged<dynamic> onChange) {
    return SelectDialog1.showModal(
      Get.context!,
      label: "Select Grievance",
      items: arrgrievanceList,
      onChange: onChange,
      searchBoxDecoration: const InputDecoration(
          prefixIcon: Icon(Icons.search), hintText: "Search"),
    );
  }
  Future<dynamic> SelectProjectDialog(ValueChanged<dynamic> onChange) {
    return SelectDialog1.showModal(
      Get.context!,
      label: "Select Grievance",
      items: arrProjectList,
      onChange: onChange,
      searchBoxDecoration: const InputDecoration(
          prefixIcon: Icon(Icons.search), hintText: "Search"),
    );
  }

  GlobalKey<ScaffoldState> Globalnewgrievancekey = GlobalKey<ScaffoldState>();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    RetrievGrievanceListData();
    RetrieveFlatListData();/*.whenComplete(() {
      arrflatdataList.refresh();
      // CreateAllThemeList();

    });*/

    arrflatdataList.refresh();
    update();

  }


  Future<List<CommonModal>> RetrievGrievanceListData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    arrgrievanceList = RxList([]);
    var data = {'action': 'fillgrievancetype'};

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
      arrgrievanceList.value =
          List.from(result.map((e) => CommonModal.fromJson(e)));
      arrgrievanceList.refresh();
      obj_grievance = arrgrievanceList[0];
      txtgrievance.text = obj_grievance.name!;
    }

    return arrgrievanceList;
  }

  Future<List<FlatListModal>> RetrieveFlatListData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    arrflatdataList = RxList([]);
    var data = {'action': 'fillcustomerflat'};

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

      List result = responseData['owner_unitdetails'];
      arrflatdataList.value =
          List.from(result.map((e) => FlatListModal.fromJson(e)));
      arrflatdataList.refresh();
      if(arrflatdataList.isNotEmpty)
      obj_flatlist = arrflatdataList[0];
      arrflatdataList.refresh();
      update();
    }

    return arrflatdataList;
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
            child: Text("Camera",style: TextStyle(color: APP_FONT_COLOR,fontSize: 16, fontWeight:FontWeight.normal),),
          ),
          CupertinoActionSheetAction(
            onPressed: (){
              Get.back();
              ChooseImage();
            },
            child: Text("Choose Photo",style: TextStyle(color: APP_FONT_COLOR,fontSize: 16, fontWeight:FontWeight.normal),),
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
        arrFileList.refresh();
        PlatformFile platformFile = PlatformFile(name: response.path, size: 50,path: response.path);
        arrImageList.add(platformFile);
        arrImageAndFileList.value = arrImageList;
        arrImageAndFileList.refresh();


        update();
      }
      else{
        print("No image selected");
      }
    }
    catch(e){
      if (kDebugMode) {
        print("Error :--- \n $e");
      }
    }

  }

  // Storage photo file type = 1
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
        arrImageAndFileList.value = arrImageList;
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
        arrImageAndFileList.value = arrFileList;
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

  Widget AttachementWidget([double leftPadding = 0 , bool labelOpen = true]){
    return Obx(() =>  GestureDetector(
      onTap: (){
        OnSelectDialog();
      },
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    labelOpen?Padding(
                      padding: const EdgeInsets.only(left: 10.0,right: 20,top: 20),
                      child: Text("File",style:
                      TextStyle(fontSize: 12, color:
                      arrImageAndFileList.length>0?Colors.grey.withOpacity(0.7):Colors.black.withOpacity(0.7), fontWeight: FontWeight.bold),

                          // TextStyle(fontWeight: FontWeight.bold,color: Colors.black.withOpacity(0.7),fontSize: 12)
                        ),
                    ):Container(),
                    Container(
                      width: Get.width,
                        child: arrImageAndFileList.length!=0? Container(
                          height: arrImageAndFileList.length !=0?100:10,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: arrImageAndFileList.length > 0 ? arrImageAndFileList.length : 0,
                              itemBuilder: (context, i) {
                                return   FileBlock(i);
                              }),
                        ):Container(
                          height: labelOpen?null:50,
                          width: labelOpen?null:120,
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0,right: 20,bottom: 20),
                            child: Text("Attach your file" , style:
                            TextStyle(
                                fontSize: 18,
                                color: Colors.grey.withOpacity(0.7),
                                fontWeight: FontWeight.bold),

                              // TextStyle(
                            //     color: Colors.black54
                            // ),
                            ),
                          ),
                        )
                    )
                  ],
                )
            ),

                // Divider(color: APP_FONT_COLOR, thickness: 0.2,)
              ],
            ),
          ),
    ));


    // });
  }

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
                  // arrImageList.removeAt(index);
                  arrImageAndFileList.removeAt(index);
                  arrImageAndFileList.refresh();
                  if (arrImageList.length == 0) {
                    fileType= -1;
                  }
                } else if (fileType == 0) {
                  // arrFileList.removeAt(index);
                  arrImageAndFileList.removeAt(index);
                  arrImageAndFileList.refresh();
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



  Widget QueryTextField_3(Rxn<TextEditingController> controller,[double leftPadding = 0 , bool labelOpen = true]) {
    return  Obx(() => TextFormField(
      controller: controller.value,
      style:
      boldTextStyle(fontSize: 16,txtColor: new_black_color),
      // TextStyle(fontSize: 18, color: APP_FONT_COLOR, fontWeight: FontWeight.bold),
      maxLines: 2,
      validator: (value){
        if (value!.isEmpty) {
          return "Please Enter Your Message";
        }
        else {
          return null;
        }
      },
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ]")),
      ],
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        // border: InputBorder.none,
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: LIGHT_GREY)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: LIGHT_GREY)),
        errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        disabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        focusedErrorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        floatingLabelBehavior: labelOpen?FloatingLabelBehavior.always:FloatingLabelBehavior.never,
        labelText: labelOpen?"Message*":null,
        hintText: "",
        hintStyle: TextStyle(color: LIGHT_GREY),
        labelStyle: TextStyle(
          fontSize: 16,
          color: NewAppColors.GREY,
            fontWeight: FontWeight.w600
          /*controller.value!.text.toString().isNotEmpty? Colors.grey.withOpacity(0.7):
          Colors.black.withOpacity(0.7),*/
        ),

        contentPadding: EdgeInsets.symmetric(horizontal: 0,vertical: 20),
      ),
      onChanged: (value){
        controller.update((val) { });
      },
    ));
  }

}