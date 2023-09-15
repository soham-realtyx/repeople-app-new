import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Helper/ApiResponse.dart';
import 'package:Repeople/Config/Helper/MoengageAnalyticsHandler.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Model/ComplaintModel/ComplaintListModel.dart';
import 'package:Repeople/Model/ComplaintModel/GrievanceDetailsModel.dart';
import 'package:Repeople/Widgets/CommomBottomSheet.dart';
import 'package:Repeople/Widgets/Loader.dart';
import 'package:dio/dio.dart' as dio;
import 'package:Repeople/Widgets/TextEditField.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Config/utils/colors.dart';
import '../../Model/CoOwnerModel/AddCoOwnerModel.dart';
import '../../Model/CommonModal/CommonModal.dart';
import '../../Model/Flat ListModal/FlatListModal.dart';
import '../../Widgets/select_dailog.dart';
import '../CommonHeaderController/CommenHeaderController.dart';

class ComplaintListController extends GetxController {
  RxInt loadmore = 0.obs;
  RxInt pagecount = 1.obs;
  RxDouble ratedata = 3.0.obs;
  RxString message = "".obs;
  RxString grievance_id = "".obs;
  RxString? project_id = "".obs;
  // RxString grievance_id = "63fef4325f8d5d76800ca77b".obs;
  ScrollController scrollController = ScrollController();
  RxList<GrievanceListModel> arrGrievanceList = RxList<GrievanceListModel>([]);
  RxList<NewGrievanceDetailsModel> arrGrievanceDetailsList =
      RxList<NewGrievanceDetailsModel>([]);
  Rx<Future<List<GrievanceListModel>>> futureGrievanceData =
      Future.value(<GrievanceListModel>[]).obs;
  RxList<GrievanceDetailsModel> arrGrievanceDetails =
      RxList<GrievanceDetailsModel>([]);
  Rx<Future<List<GrievanceDetailsModel>>> futureGrievanceDetails =
      Future.value(<GrievanceDetailsModel>[]).obs;
  TextEditingController txtsendmsg = new TextEditingController();
  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());

  AddCoOwner? dropdownvalue;
  FlatListModal? dropdownvaluenew;
  late Rx<AddCoOwner?> dropdownvalue1 = dropdownvalue.obs;
  late Rx<FlatListModal?> dropdownvalue1new = dropdownvaluenew.obs;

  AddCoOwner? dropdownvaluet;
  FlatListModal? dropdownvaluetnew;

  late Rx<AddCoOwner?> dropdownvaluet1 = dropdownvaluet.obs;
  late Rx<FlatListModal?> dropdownvaluet1new = dropdownvaluetnew.obs;

  GlobalKey<ScaffoldState> complaintscaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> DetailsscaffoldKey = GlobalKey<ScaffoldState>();

// add grievance declarationsss
  CommonModal obj_grievance = CommonModal();
  TextEditingController txtgrievance = TextEditingController();
  RxList<CommonModal> arrgrievanceList = RxList([]);

  TextEditingController txtflat = TextEditingController();
  FlatListModal obj_flatlist = FlatListModal();
  RxList<FlatListModal> arrflatdataList = RxList<FlatListModal>([]);
  Rxn<TextEditingController> txtMassageNew = Rxn(TextEditingController());

  bool firstAutoscrollExecuted = false;
  bool shouldAutoscroll = false;
  bool isemailValid = true;
  bool isnovalid = true;
  int fileType = (-1);
  File? fileValue;
  File? fileImage;
  String? imgPdf;
  RxList<PlatformFile> arrFileList = RxList<PlatformFile>([]);
  RxList<PlatformFile> arrImageList = RxList<PlatformFile>([]);
  RxList<PlatformFile> arrImageAndFileList = RxList<PlatformFile>([]);
  String? token;

  Rxn<TextEditingController> txtQueryNew = Rxn(TextEditingController());

  @override
  void onInit() {
    // TODO: implement onInit
    scrollController.addListener(() {
      print("im listning");
      scrollUpdate(scrollController);
    });
    GrievanceDetailsData();
    super.onInit();
  }

  restart() {
    futureGrievanceDetails.value = RetrieveGrievanceDetailsData();
    futureGrievanceDetails.refresh();

    RetrieveFlatListData();
    RetrievGrievanceListData();
  }

  ImagePicker imagePicker = ImagePicker();

  GrievanceDetailsData() {
    arrGrievanceDetailsList = RxList([
      NewGrievanceDetailsModel(
          title: "Masonry",
          date: "",
          senderType: "",
          created_by: "",
          msg: "The tiles are loose",
          userName: "Yash Goswami"),
      NewGrievanceDetailsModel(
          title: "Masonry",
          date: "17 Jun, 2023 11:32 AM",
          senderType: "1",
          images: [
            GRIEVANCE_IMAGE,GRIEVANCE_IMAGE,GRIEVANCE_IMAGE,GRIEVANCE_IMAGE,GRIEVANCE_IMAGE,GRIEVANCE_IMAGE
          ],
          created_by: "17 Jun, 2023 11:32 AM",
          msg: "The tiles are loose",
          userName: "Yash Goswami"),
      NewGrievanceDetailsModel(
          title: "Masonry",
          date: "17 Jun, 2023 11:32 AM",
          senderType: "1",
          created_by: "17 Jun, 2023 11:32 AM",
          msg:
              "Water typically enters from failed joint sealants, clogged drainage pipes, and other vulnerable points in the structure.",
          userName: "Yash Goswami"),
      //sender message
      NewGrievanceDetailsModel(
          title: "",
          date: " 17 Jun, 2023 2:30 PM",
          senderType: "2",
          created_by: " 17 Jun, 2023 2:30 PM",
          msg: "Sute we will look into it and we will do the needful ASAP",
          userName: "By Project Manager"),
      NewGrievanceDetailsModel(
          title: "Masonry",
          date: "17 Jun, 2023 11:32 AM",
          senderType: "1",
          created_by: "17 Jun, 2023 11:32 AM",
          msg: "Ok, Thank you",
          userName: "Yash Goswami"),
      NewGrievanceDetailsModel(
          title: "Masonry",
          date: "17 Jun, 2023 3:27 PM",
          senderType: "1",
          created_by: "17 Jun, 2023 3:27 PM",
          msg: "The tiles are loose",
          userName: "Yash Goswami"),
      NewGrievanceDetailsModel(
          title: "",
          date: " 18 Jun, 2023 11:30 AM",
          senderType: "2",
          created_by: " 18 Jun, 2023 11:30 AM",
          msg: "What would you like to do now?",
          userName: "By Project Manager",
        mylist: ["Continue further","End Conversation"]
      ),
    ]);
  }

  // Camera file type = 1;
  void CameraSelect() async {
    try {
      var response = await imagePicker.pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.front);
      if (response != null) {
        fileType = 1;
        arrFileList.clear();
        arrFileList.refresh();
        PlatformFile platformFile =
            PlatformFile(name: response.path, size: 50, path: response.path);
        arrImageList.add(platformFile);
        arrImageList.refresh();
        arrImageAndFileList.value = arrImageList;
        arrImageAndFileList.refresh();
      } else {
        print("No image selected");
      }
    } catch (e) {
      print("Error :--- \n $e");
    }
  }

  // Storage photo file type = 1
  void ChooseImage() async {
    try {
      var response = await imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (response != null) {
        fileType = 1;
        arrFileList.clear();
        arrFileList.refresh();
        PlatformFile platformFile =
            PlatformFile(name: response.path, size: 50, path: response.path);
        arrImageList.add(platformFile);
        arrImageList.refresh();
        arrImageAndFileList.value = arrImageList;
        arrImageAndFileList.refresh();
      } else {
        print("No Image Selected");
      }
    } catch (e) {
      print("Error :--- \n $e");
    }
  }

  // Storage file type = 0
  void FileChoose() async {
    try {
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

      if (response != null) {
        fileType = 0;
        arrImageList.clear();
        arrFileList.addAll(response.files);
        arrImageAndFileList = arrFileList;
      } else {
        print("No Selected any File");
      }
    } catch (e) {
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

  Widget FileBlock(int index) {
    if (fileType == 1) {
      fileImage = File(arrImageList[index].path!);
    } else {
      fileImage = File(arrFileList[index].path!);
      imgPdf = _setImage(arrFileList[index].extension!);
    }

    return Stack(
      children: [
        Container(
            margin: EdgeInsets.only(right: 9.w, bottom: 9.h),
            width: 98.w,
            height: 98.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(cornarradius)),
                border: Border.all(
                    color: APP_FONT_COLOR,
                    width: 0.5,
                    style: BorderStyle.solid)),
            clipBehavior: Clip.hardEdge,
            child: fileType == 1
                ? Image.file(
                    fileImage!,
                    width: 98.w,
                    height: 98.h,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    imgPdf!,
                    width: 98.w,
                    fit: BoxFit.cover,
                    height: 98.h,
                  )),
        Positioned(
            child: GestureDetector(
          onTap: () {
            if (fileType == 1) {
              arrImageList.removeAt(index);
              if (arrImageList.length == 0) {
                fileType = -1;
              }
            } else if (fileType == 0) {
              arrFileList.removeAt(index);
              if (arrFileList.length == 0) {
                fileType = -1;
              }
            }
          },
          child: Container(
            width: 98.w,
            height: 98.h,
            margin: EdgeInsets.only(right: 9.w, bottom: 9.h),
            decoration: BoxDecoration(
              color: DARK_BLUE.withOpacity(0.2),
              borderRadius: BorderRadius.all(Radius.circular(cornarradius)),
            ),
            child: Center(
              child: SvgPicture.asset(IMG_DELETE_SVG),
            ),
          ),
        )),
        // Positioned(
        //   top: 0.0,
        //   right: 0.0,
        //   child: new IconButton(
        //       padding: EdgeInsets.all(0.0),
        //       constraints: BoxConstraints(),
        //       icon: Icon(
        //         Icons.cancel,
        //       ),
        //       onPressed: () {
        //         if (fileType == 1) {
        //
        //             arrImageList.removeAt(index);
        //             if (arrImageList.length == 0) {
        //               fileType= -1;
        //             }
        //
        //         } else if (fileType == 0) {
        //
        //             arrFileList.removeAt(index);
        //             if (arrFileList.length == 0) {
        //               fileType = -1;
        //             }
        //
        //         }
        //         //update();
        //       }),
        // )
      ],
    );
  }

  OnSelectDialog() {
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
                  CameraSelect();
                },
                child: Text(
                  "Camera",
                  style: TextStyle(
                      color: APP_FONT_COLOR,
                      fontSize: 16,
                      fontWeight: FontWeight.normal),
                ),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Get.back();
                  ChooseImage();
                },
                child: Text(
                  "Choose Photo",
                  style: TextStyle(
                      color: APP_FONT_COLOR,
                      fontSize: 16,
                      fontWeight: FontWeight.normal),
                ),
              ),
              // CupertinoActionSheetAction(
              //   onPressed: (){
              //     Get.back();
              //     FileChoose();
              //   },
              //   child: Text("File",style: TextStyle(color: APP_FONT_COLOR,fontSize: 16, fontWeight:FontWeight.normal),),
              // ),
            ],
          );
        });
  }
  LoadPage() {

    futureGrievanceData.value = RetrieveGrievanceListData();
    futureGrievanceData.refresh();
    // scrollController.addListener(() {
    //   scrollUpdate();
    // });
  }

  Future<void> SendMessageData({String chattype = "2"}) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    appLoader(contextCommon);
    Map<String, dynamic> data = {};
    data['action'] = 'sendmessage';
    data['grievanceid'] = grievance_id.value.toString();
    data['message'] = txtsendmsg.text.trim();
    data['chattype'] = chattype;
    if (arrImageAndFileList.length > 0) {
      for (int i = 0; i < arrImageAndFileList.length; i++) {
        data['images[$i]'] =
            await dio.MultipartFile.fromFile(arrImageAndFileList[i].path!);
        //print(images[i].path);
      }
    }
    var headerdata = {
      "masterlisting": "false",
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE) ?? "",
    };
    debugPrint("send * *  $data");
    ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_GRIEVANCE_DETAILS,
        headerdata: headerdata,
        apiHeaderType: ApiHeaderType.Content);
    Map<String, dynamic>? responseData = await response.getResponse();
    if (responseData!['status'] == 1) {
      removeAppLoader(contextCommon);
      futureGrievanceDetails.value = RetrieveGrievanceDetailsData();
      futureGrievanceDetails.refresh();
      txtsendmsg.clear();
      arrImageAndFileList.clear();
      arrImageList.clear();
      arrFileList.clear();
      SuccessMsg(responseData['message']);
    } else {
      removeAppLoader(contextCommon);
      validationMsg(responseData['message']);
    }
  }

  Future<void> AddNewGrievanceData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    appLoader(contextCommon);
    try {
      Map<String, dynamic> data = {};
      data['action'] = 'insertgrievance';
      data['formevent'] = 'addright';
      data['message'] = txtMassageNew.value?.text.trim();
      data['unitdetails'] = json.encode(obj_flatlist.toJson());
      data['grievance'] = json.encode(obj_grievance.toJson());
      if (arrImageAndFileList.length > 0) {
        for (int i = 0; i < arrImageAndFileList.length; i++) {
          data['images[$i]'] =
              await dio.MultipartFile.fromFile(arrImageAndFileList[i].path!);
        }
      }
      var headerdata = {
        'userlogintype': sp.getString(SESSION_USERLOGINTYPE) ?? ""
      };
      print(data.toString() + "Add Grievance");
      ApiResponse response = ApiResponse(
          data: data,
          base_url: URL_GRIEVANCE_LIST,
          headerdata: headerdata,
          apiHeaderType: ApiHeaderType.Content);
      Map<String, dynamic>? responseData = await response.getResponse();
      log(responseData.toString());
      print("my grievance");
      if (responseData!['status'] == 1) {
        // MoengageAnalyticsHandler().track_event("add_new_grievance");
        MoengageAnalyticsHandler().SendAnalytics({"grievance":json.encode(obj_grievance.toJson()),"message":txtMassageNew.value?.text.trim(),"unitdetails":json.encode(obj_flatlist.toJson())},"add_new_grievance");

        restart();
        txtMassageNew.value?.clear();
        arrImageAndFileList.clear();
        arrImageList.clear();
        arrFileList.clear();
        dropdownvaluenew = FlatListModal();
        arrflatdataList.clear();
        // SuccessMsg(responseData['message']);
        LoadPage();
        navigator!.pop(contextCommon);
        Get.back(result: "1");
      } else {
        navigator!.pop(contextCommon);
        validationMsg(responseData['message']);
      }
    } catch (e) {
      navigator!.pop(contextCommon);
    }
  }

  Widget AttachementWidget([double leftPadding = 0, bool labelOpen = true]) {
    return Obx(() => GestureDetector(
          onTap: () {
            // OnSelectDialog();
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
                    labelOpen
                        ? Padding(
                            padding:
                                EdgeInsets.only(left: 0.0, right: 0, top: 10.h),
                            child: Text(
                              "Photos",
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: NewAppColors.GREY,
                                  /*arrImageAndFileList.value.length>0?Colors.grey.withOpacity(0.7):Colors.black.withOpacity(0.7),*/ fontWeight:
                                      FontWeight.bold),

                              // TextStyle(fontWeight: FontWeight.bold,color: Colors.black.withOpacity(0.7),fontSize: 12)
                            ),
                          )
                        : Container(),
                    SizedBox(height: 10.h),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: GridView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: arrImageAndFileList.value.length + 1,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 4.0,
                              mainAxisSpacing: 4.0,
                            ),
                            itemBuilder: (context, i) {
                              if (i == 0) {
                                return GestureDetector(
                                  onTap: () {
                                    OnSelectDialog();
                                  },
                                  child: Container(
                                    width: 98.w,
                                    height: 98.h,
                                    margin: EdgeInsets.only(
                                        right: 9.w, bottom: 9.h),
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      color: DARK_BLUE.withOpacity(0.2),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(cornarradius)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "+ADD",
                                        style: TextStyle(
                                            color: DARK_BLUE,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: fontFamily),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return FileBlock(i - 1);
                              }
                            }),
                      ),
                    )
                  ],
                )),

                // Divider(color: APP_FONT_COLOR, thickness: 0.2,)
              ],
            ),
          ),
        ));

    // });
  }

  Future<void> RateUsDataSend() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    appLoader(contextCommon);
    Map<String, dynamic> data = {};
    data['action'] = 'rating';
    data['grievanceid'] = grievance_id.value.toString();
    data['comment'] = txtQueryNew.value!.text.trim();
    data['rating'] = ratedata.value.toString();

    var headerdata = {
      //"useraction": "viewright",
      "masterlisting": "false",
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE) ?? "",
    };
    debugPrint("rate data * *  $data");
    ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_GRIEVANCE_LIST,
        headerdata: headerdata,
        apiHeaderType: ApiHeaderType.Content);
    Map<String, dynamic>? responseData = await response.getResponse();
    if (responseData!['status'] == 1) {
      removeAppLoader(contextCommon);
      txtQueryNew.value!.clear();
      ratedata.value = 3.0;
      Get.back();
      //restart();

      SuccessMsg(responseData['message']);
    } else {
      removeAppLoader(contextCommon);
      validationMsg(responseData['message']);
    }
  }

  Future<void> EscalateDataSend() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    appLoader(contextCommon);
    Map<String, dynamic> data = {};
    data['action'] = 'sendgrievanceescalate';
    data['grievanceid'] = grievance_id.value.toString();

    var headerdata = {
      //"useraction": "viewright",
      "masterlisting": "false",
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE) ?? "",
    };
    debugPrint("Escalate data * *  $data");
    ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_GRIEVANCE_LIST,
        headerdata: headerdata,
        apiHeaderType: ApiHeaderType.Content);
    Map<String, dynamic>? responseData = await response.getResponse();
    if (responseData!['status'] == 1) {
      removeAppLoader(contextCommon);

      restart();

      //SuccessMsg(responseData['message']);

    } else {
      removeAppLoader(contextCommon);
      validationMsg(responseData['message']);
    }
  }

  Future<List<GrievanceListModel>> RetrieveGrievanceListData() async {
    arrGrievanceList = RxList([]);
    SharedPreferences sp = await SharedPreferences.getInstance();
    var data = {
      'action': 'listraisegrievance',
      'nextpage': pagecount,
      'perpage': 10,
      'ordby': "1",
      'ordbycolumnname': "_id",
      "filter": "",
      if(project_id?.value!="")
      "fltprojectid":project_id?.value??""
      // "filter":searchtxt.text,
    };

    print("listraisegrievance" + data.toString());
    var headers = {
      // 'userpagename': 'property',
      // 'useraction': 'viewright',
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE) ?? "",
      //'cmpid': "60549434a958c62f010daa2f"
    };

    ApiResponse response = ApiResponse(
      data: data,
      base_url: URL_GRIEVANCE_LIST,
      apiHeaderType: ApiHeaderType.Content,
      headerdata: headers,
    );

    print(headers);

    Map<String, dynamic>? responseData = await response.getResponse();
    print("responseData");
    print(responseData);
    log(responseData.toString()+"grievance Details log");
    if (responseData!['status'] == 1) {
      List result = responseData['data'];
      loadmore.value = responseData['loadmore'];
      arrGrievanceList.value =
          List.from(result.map((e) => GrievanceListModel.fromJson(e)));

      arrGrievanceList.refresh();
      // print(result);

      print(arrGrievanceList.length);

      // RetrieveConstructionData();
      // RetrievePlotVillaData();

    } else {
      // print(message.value.toString()+"message");
      message.value = responseData['message'];
    }
    return arrGrievanceList;
  }

  scrollUpdateStory(ScrollController scrollController) {
    var maxScroll = scrollController.position.maxScrollExtent;
    var currentPosition = scrollController.position.pixels;
    scrollController.jumpTo(maxScroll);
  }

  Future<List<GrievanceDetailsModel>> RetrieveGrievanceDetailsData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    arrGrievanceDetails = RxList<GrievanceDetailsModel>([]);
    var data = {
      'action': 'showchathistory',
      'grievanceid': grievance_id.value.toString(),
    };
    print("showchathistory" + data.toString());
    var headers = {
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE) ?? "",
    };

    ApiResponse response = ApiResponse(
      data: data,
      base_url: URL_GRIEVANCE_DETAILS,
      apiHeaderType: ApiHeaderType.Content,
      headerdata: headers,
    );
    print(headers);
    print(URL_GRIEVANCE_DETAILS);
    Map<String, dynamic>? responseData = await response.getResponse();
    print("responseData");
    print("responseData***********" + responseData.toString());
    if (responseData!['status'] == 1) {
      arrGrievanceDetails.value = [
        GrievanceDetailsModel.fromJson(responseData)
      ];
      arrGrievanceDetails.refresh();

      //  scrollController.jumpTo(scrollController.position.maxScrollExtent);
      //scrollUpdateStory(scrollController);

      print(arrGrievanceList.length);
    } else {
      message.value = responseData['message'];
    }
    return arrGrievanceDetails;
  }

  Future<List<CommonModal>> RetrievGrievanceListData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    arrgrievanceList = RxList([]);
    var data = {'action': 'fillgrievancetype'};

    var headers = {
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE) ?? "",
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
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE) ?? "",
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
      if (arrflatdataList.isNotEmpty) obj_flatlist = arrflatdataList[0];

      for (int i = 0; i < arrflatdataList.length; i++) {
        if (arrflatdataList[i].projectid.toString() ==
            dropdownvalue1new.value?.projectid) {
          dropdownvaluenew = FlatListModal();
          dropdownvaluenew = arrflatdataList[i];
          dropdownvalue1new.value = arrflatdataList[i];
          dropdownvalue1new.update((val) {});
        }
      }

      // txtflat.text = obj_flatlist.name!;
      update();
      print(responseData);
      // print(arrflatdataList);
      print("arrflatdataList.length");
    }

    return arrflatdataList;
  }

  scrollUpdate(ScrollController scrollController) {
    var maxScroll = scrollController.position.maxScrollExtent;
    var currentPosition = scrollController.position.pixels;
    if (maxScroll == currentPosition) {
      if (loadmore == 1) {
        print(pagecount);
        pagecount++;
        RetrieveGrievanceListData();
        update();
      }
    }
  }

  SelectGrievanceType() {
    SelectGrievanceTypeDialog((value) {
      obj_grievance = value;
      txtgrievance.text = obj_grievance.name ?? "";
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

  Future<void> GrievanceStatusSend(String status) async {
    print('GrievanceStatusSend');
    SharedPreferences sp = await SharedPreferences.getInstance();
    appLoader(contextCommon);
    Map<String, dynamic> data = {};
    data['action'] = 'sendgrievancestatus';
    data['grievanceid'] = grievance_id.value.toString();
    data['send'] = status;

    var headerdata = {
      //"useraction": "viewright",
      "masterlisting": "false",
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE) ?? "",
    };
    debugPrint("Grievance Status* *  $data");
    ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_GRIEVANCE_LIST,
        headerdata: headerdata,
        apiHeaderType: ApiHeaderType.Content);

    Map<String, dynamic>? responseData = await response.getResponse();

    if (responseData!['status'] == 1) {
      removeAppLoader(contextCommon);

      restart();
    } else {
      removeAppLoader(contextCommon);
      validationMsg(responseData['message']);
    }
  }
}
