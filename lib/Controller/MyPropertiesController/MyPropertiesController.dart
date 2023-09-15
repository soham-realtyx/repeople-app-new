
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/Helper/ApiResponse.dart';
import 'package:Repeople/Model/AddProperty/MyPropertyModel.dart';
import 'package:Repeople/Model/CoOwnerModel/CoOwnerMainPageModel.dart';
import 'package:Repeople/Model/DemandsModel/DemandsModel.dart';
import 'package:Repeople/Model/Document/DocumentMainCategory.dart';
import 'package:Repeople/Model/Document/Document_Category_Model.dart';
import 'package:Repeople/Model/Flat%20ListModal/FlatListModal.dart';
import 'package:Repeople/Model/PropertiesDetailModel/PropertiesDetailModel.dart';
import 'package:Repeople/View/GrievancePages/ComplaintListScreen.dart';
import 'package:Repeople/View/MyBuildingDirectoryPage/MyBuildingDirectoryPage.dart';
import 'package:Repeople/View/NoticeBoardPage/NoticeBoardPage.dart';
import 'package:Repeople/Widgets/CommomBottomSheet.dart';
import 'package:Repeople/Widgets/Loader.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Helper/MoengageAnalyticsHandler.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Controller/CommonHeaderController/CommenHeaderController.dart';
import 'package:Repeople/Model/Dashbord/ExploreMoreListClass.dart';
import 'package:Repeople/Model/ManageMembersModel/ManageMembersModel.dart';
import 'package:Repeople/Model/MyPropertiesModel/MyPropertiesModel.dart';
import 'package:Repeople/Model/Theme/WidgetThemeListClass.dart';
import 'package:Repeople/View/AccountStatementPage/AccountStatementPage.dart';
import 'package:Repeople/View/DemandsPage/DemandsPage.dart';
import 'package:Repeople/View/ManageMembersPage/ManageMembersPage.dart';
import 'package:Repeople/View/MyPropertiesDocumentsPage/MyPropertiesDocumentsPage.dart';
import 'package:Repeople/View/PaymentSchedulePage/PaymentSchedulePage.dart';
import 'package:Repeople/View/Re-SalePage/Re-SalePage.dart';
import 'package:Repeople/View/RentalPage/RentalPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPropertiesController extends GetxController {
  RxList<WidgetThemeListClass> arrAllTheme = RxList<WidgetThemeListClass>();
  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());

  var RentalFormkey = GlobalKey<FormState>();
  var ReSaleFormkey = GlobalKey<FormState>();
  var addNewMemberformkey = GlobalKey<FormState>();


  RefreshRequest(){
    futureManageMemberData.value = RetriveManageMemberData();
    futureManageMemberData.refresh();
  }

  RxString projectID=''.obs;
  RxString inventoryType=''.obs;
  RxString inventoryTypeId=''.obs;
  RxString message=''.obs;
  RxString Requestmessage=''.obs;
  RxString? textButton='delete'.obs;
  RxString buildingId = ''.obs;
  RxString plotId = ''.obs;
  RxString villaId = ''.obs;
  RxString documentCategoryId = ''.obs;
  RxString documentTypeId = ''.obs;
  RxInt pageCount = 0.obs;
  RxString documentMessage = ''.obs;
  RxString paymentScheduleMessage = ''.obs;
  RxString demandsMessage = ''.obs;
  int fileType = (-1);
  File? fileValue;
  //FirebaseMessaging? firebaseMessaging;
  List<PlatformFile> arrFileList = [];
  List<PlatformFile> arrImageList = [];
  List<PlatformFile> arrImageAndFileList = [];

  RxBool? isOpen = false.obs;
  RxBool? isButton = false.obs;

  GlobalKey<ScaffoldState> GlobalMyPropertiesPagekey =
  GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> GlobalMyPropertiesListPagekey =
  GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> GlobalAccountStatementPagekey =
  GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> GlobalPaymentSchedulePagekey =
  GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> GlobalDemandsPagekey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> GlobalReceiptPagekey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> GlobalBuildingDirectoryPagekey =
  GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> GlobalNoticeBoardPagekey =
  GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> GlobalRentalPagekey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> GlobalReSalePagekey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> GlobalGrivancePagekey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> GlobalManageMembersPagekey =
  GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> GlobaladdNewMembersPagekey =
  GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> GlobalDocumentPagekey = GlobalKey<ScaffoldState>();

  Rxn<TextEditingController> txtNotes = Rxn(TextEditingController());
  Rxn<TextEditingController> txtResaleNotes = Rxn(TextEditingController());
  Rxn<TextEditingController> txtPropertyArea = Rxn(TextEditingController());
  Rxn<TextEditingController> txtExpectedRent = Rxn(TextEditingController());
  Rxn<TextEditingController> txtFirstNameNew = Rxn(TextEditingController());
  Rxn<TextEditingController> txtLastNameNew = Rxn(TextEditingController());
  Rxn<TextEditingController> txtContactNew = Rxn(TextEditingController());
  Rxn<TextEditingController> txtEmailNew = Rxn(TextEditingController());
  Rxn<TextEditingController> textcontroller = Rxn(TextEditingController());

  Rx<MyPropertyList> objMyProperties = MyPropertyList().obs;
  Rx<CoOwnerModel> objManageMember = CoOwnerModel().obs;

  Rx<PropertiesDetailModel2> objMyPropertiesDetails = PropertiesDetailModel2().obs;

  RxList<MenuItemModel> arrExploreMore = RxList<MenuItemModel>([]);
  Rx<Future<List<MenuItemModel>>> futurearrexploremorelist =
      Future.value(<MenuItemModel>[]).obs;

  RxList<MyPropertiesModel> arrMyPropertiesMore = RxList<MyPropertiesModel>([]);
  Rx<Future<List<MyPropertiesModel>>> futurearrMyPropertiesData2 =
      Future.value(<MyPropertiesModel>[]).obs;


  RxList<MyPropertyList> arrMyPropertiesList =
  RxList<MyPropertyList>([]);
  Rx<Future<List<MyPropertyList>>> futurearrMyPropertiesList =
      Future.value(<MyPropertyList>[]).obs;

  RxList<PropertiesDetailModel2> arrPropertiesDetailsList =
  RxList<PropertiesDetailModel2>([]);
  Rx<Future<List<PropertiesDetailModel2>>> futurearrPropertiesDetailsList =
      Future.value(<PropertiesDetailModel2>[]).obs;

  // Rx<Future<PropertiesDetailsModel>> futureProjectdetailsData = Future.value(PropertiesDetailsModel()).obs;
  RxList<PropertiesExploreModel> arrPaymentScheduleList =
  RxList<PropertiesExploreModel>([]);
  RxList<PropertiesExploreModel> arrDocumentList =
  RxList<PropertiesExploreModel>([]);
  Rx<Future<List<PropertiesExploreModel>>> futurearrPaymentScheduleList =
      Future.value(<PropertiesExploreModel>[]).obs;

  RxList<DemandsModel> arrDemandsList =
  RxList<DemandsModel>([]);
  Rx<Future<List<DemandsModel>>> futurearrDemandsList =
      Future.value(<DemandsModel>[]).obs;

  RxList<ManageMembersModel> arrManageMembersList =
  RxList<ManageMembersModel>([]);

  RxList<CoOwnerModel> arrManagerList = RxList<CoOwnerModel>([]);
  Rx<Future<List<CoOwnerModel>>> futureManageMemberData = Future.value(<CoOwnerModel>[]).obs;

  RxList<DocumentCommonModel> arrDocSubMainList =
  RxList<DocumentCommonModel>([]);
  Rx<Future<List<DocumentCommonModel>>> futureDocSubMainData =
      Future.value(<DocumentCommonModel>[]).obs;

  RxList<DocumentMainCtegory> arrDocMainList = RxList<DocumentMainCtegory>([]);
  Rx<DocumentMainCtegory> objDocMainList = DocumentMainCtegory().obs;
  Rx<Future<List<DocumentMainCtegory>>> futureDocMainData =
      Future.value(<DocumentMainCtegory>[]).obs;


  RxList<DocumentListMain> arrDocCategoryMainList =
  RxList<DocumentListMain>([]);
  Rx<Future<List<DocumentListMain>>> futureDocCategoryMainData =
      Future.value(<DocumentListMain>[]).obs;

  RxList<String> galleryList = RxList([]);
  RxList<String> siteProgressList = RxList([]);
  CarouselController controller_propertiesList = CarouselController();
  CarouselController controller_propertiesDetail = CarouselController();
  RxInt current = 0.obs;
  @override
  void onInit() {
    super.onInit();

    txtFirstNameNew.value!.text='';
    txtLastNameNew.value!.text='';
    txtContactNew.value!.text='';
    txtEmailNew.value!.text='';
    textcontroller.value!.text='';

    futurearrDemandsList.value = DemandsListData();
    futurearrMyPropertiesData2.value = MyPropertiesData();
    DocumentData();
    // DemadsListData();
    PaymentScheduleData();
    ManageMembersData();
  }


  @override
  void dispose() {
    super.dispose();
  }

  Widget CreateAppBarThemeList() {
    if (GLOBAL_THEME_INDEX.value == 0) {
      return cnt_CommonHeader.commonAppBar(
          "My Properties", GlobalMyPropertiesPagekey);
      return Container();
    } else {
      return cnt_CommonHeader.Common_Header4("", GlobalMyPropertiesPagekey,
          color: BACKGROUND_COLOR);
    }
  }

  onSearchTextChanged(String text) async {
    // arrDocSubMainList = RxList([]);
    if (text.isEmpty) {
      retrieveDocumentSubListData(id: "", categoryid: "", name: "");
      futureDocSubMainData.refresh();
      return;
    }
    retrieveDocumentSubListData(id: "", categoryid: "", name: text).then((
        value) {
      futureDocSubMainData.refresh();
    });
  }

  Future<List<DocumentListMain>> retrieveDocumentListData() async {
    arrDocCategoryMainList = RxList<DocumentListMain>([]);
    SharedPreferences sp = await SharedPreferences.getInstance();
    Map<String, dynamic> data = {
      'action': 'listcategory',
      for (int i = 0; i < arrDocMainList.length; i++)
        if (inventoryType.value == arrDocMainList[i].type)
          'documenttype_id': arrDocMainList[i].id
    };
    print(data.toString() + "====>>>>>>>");
    var headers = {
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE) ?? "",
    };

    ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_DOCUMENT_CATEGORY_LIST,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers);
    Map<String, dynamic>? responseData = await response.getResponse();
    log(responseData.toString() + " uvbdvubvbdbvd");
    if (responseData!['status'] == 1) {
      List result = responseData['result'];
      List<DocumentListMain> arrtemp = [];
      arrtemp = List.from(result.map((e) => DocumentListMain.fromJson(e)));
      arrDocCategoryMainList.addAll(arrtemp);
      arrDocCategoryMainList.refresh();
      documentCategoryId.value = arrDocCategoryMainList[0].id!;
      documentTypeId.value =
          arrDocCategoryMainList[0].documenttypeid.toString();
      // IsUpdatable.value=responseData['isupdate'] ?? "false";
    } else {
      message.value = responseData['message'];
    }
    return arrDocCategoryMainList;
  }

  Future<List<DocumentMainCtegory>> retrieveMainDocumentListData() async {
    arrDocMainList = RxList<DocumentMainCtegory>([]);
    SharedPreferences sp = await SharedPreferences.getInstance();
    Map<String, dynamic> data = {
      'action': 'filldocumenttype',
    };
    var headers = {
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE) ?? "",
    };

    ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_DOCUMENT_CATEGORY_LIST,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers);
    Map<String, dynamic>? responseData = await response.getResponse();

    if (responseData!['status'] == 1) {
      List result = responseData['result'];
      List<DocumentMainCtegory> arrtemp = [];
      arrtemp = List.from(result.map((e) => DocumentMainCtegory.fromJson(e)));
      arrDocMainList.addAll(arrtemp);
      arrDocMainList.refresh();
      // for (int i = 0; i < arrDocMainList.length; i++)
      // if (arrDocMainList.length > 0) {
      //   objDocMainList.value = arrDocMainList[i];
      // }
      // documentTypeId.value=arrDocMainList[0].id.toString();
    } else {
      message.value = responseData['message'];
    }
    return arrDocMainList;
  }

  Future<List<DocumentCommonModel>> retrieveDocumentSubListData(
      {required String id,
        required String name,
        required String categoryid}) async {
    try {
      arrDocSubMainList = RxList<DocumentCommonModel>([]);
      SharedPreferences sp = await SharedPreferences.getInstance();
      Map<String, dynamic> data = {
        'action': 'listdocument',
        'documenttype_id': documentTypeId.value,
        'document_categoryid': documentCategoryId.value,
        "plotid": plotId.value,
        "projectid": projectID.value,
        "villaid": villaId.value,
        "buildingid": buildingId.value,
        if(name.isNotEmpty)
          "filter" :name.trim().toString()
      };

      var headers = {
        'userlogintype': sp.getString(SESSION_USERLOGINTYPE) ?? "",
      };

      ApiResponse response = ApiResponse(
          data: data,
          base_url: URL_DOCUMENT_CATEGORY_LIST,
          apiHeaderType: ApiHeaderType.Content,
          headerdata: headers);
      Map<String, dynamic>? responseData = await response.getResponse();
      log(responseData.toString() + " RetrieveDocumentSubListData");
      if (responseData!['status'] == 1) {
        List result = responseData['data'];
        List<DocumentCommonModel> arrTemp = [];
        arrTemp = List.from(result.map((e) => DocumentCommonModel.fromJson(e)));
        arrDocSubMainList.addAll(arrTemp);
        arrDocSubMainList.refresh();
      } else {
        documentMessage.value = responseData['message'];
      }
    } catch (e) {
      print(e);
    }
    return arrDocSubMainList;
  }

  Future<RxList<MyPropertyList>> RetrieveMyPropertyListData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    arrMyPropertiesList = RxList([]);
    var data = {
      'action': 'fillcustomerflat'
    };

    var headers = {
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE) ?? "",

    };
    print(headers);
    ApiResponse response = ApiResponse(
      data: data,
      base_url: URL_PROJECTLIST,
      apiHeaderType: ApiHeaderType.Content,
      headerdata: headers,
    );


    print("before api call");
    try{

      Map<String, dynamic>? responseData = await response.getResponse();

      log(responseData.toString());
      debugPrint(responseData.toString());
      print("dvuivbuifbv");

      if(responseData!=null)
        if (responseData['status'] == 1) {
          List result = responseData['owner_unitdetails'];
          arrMyPropertiesList.value = List.from(result.map((e) => MyPropertyList.fromJson(e)));
          arrMyPropertiesList.refresh();
        }
    }catch(e){print(e.toString()+" my properties list error");}
    return arrMyPropertiesList;
  }


  Future<RxList<PropertiesDetailModel2>> retrievePropertiesDetails() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    arrPropertiesDetailsList=RxList([]);
    var data = {
      'action': 'customerpropertydetail',
      'nextpage': '1',
      'perpage': '10',
      'ordby': '1',
      'ordbycolumnname': 'id',
      'projectid': projectID.value,
      'inventorytypeid':inventoryTypeId.value,
      'inventorytype':inventoryType.value
    };
    print(data);
    print("dndndvvddv");
    var headers = {
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",
    };
    try{
      ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_PROPERTYDETAILS,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers,
      );
      Map<String, dynamic>? responseData = await response.getResponse();
      log(responseData.toString()+"project Details log");
      if (responseData!['status'] == 1) {
        List result = responseData['data'];
        arrPropertiesDetailsList.value =
            List.from(result.map((e) => PropertiesDetailModel2.fromJson(e)));
        // arrPropertiesDetailsList.value = PropertiesDetailsModel.fromJsonList(responseData['data']);
        arrPropertiesDetailsList.refresh();

        // if (objMyPropertiesDetails.value.gallery != null &&
        //     objMyPropertiesDetails.value.gallery!.galleryListdata != null) {
        //   for (var e in objMyPropertiesDetails.value.gallery!.galleryListdata!) {
        //     galleryList.add(e.icon.toString());
        //   }
        // }
        //
        if (arrPropertiesDetailsList.isNotEmpty&&arrPropertiesDetailsList![0].siteProgress!.SiteProgressListdata!= null
            ) {
          for (var e in arrPropertiesDetailsList![0].siteProgress!.SiteProgressListdata!) {
            siteProgressList.add(e.icon.toString());
          }
        }

      } else {
        message.value = responseData!['message'];
      }
    }catch(e){print(e.toString()+" my properties error");}
    return arrPropertiesDetailsList;

  }

  Future<RxList<DemandsModel>> DemandsListData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    arrDemandsList = RxList([]);
    var data = {
      'action': 'listdemands',
      'projectid': projectID.value
    };

    var headers = {
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE) ?? ""
    };

    ApiResponse response = ApiResponse(
      data: data,
      base_url: URL_DEMANDSLIST,
      apiHeaderType: ApiHeaderType.Content,
      headerdata: headers,
    );

    Map<String, dynamic>? responseData = await response.getResponse();
    log(responseData.toString());
    print("my demands data");
    try{
      if (responseData!['status'] == 1) {
        List result = responseData['data'];
        arrDemandsList.value = List.from(result.map((e) => DemandsModel.fromJson(e)));

        arrDemandsList.refresh();
      }
    }catch(e){print(e.toString()+"my propertiesDetails error");}
    return arrDemandsList;
  }


  Future<List<CoOwnerModel>> RetriveManageMemberData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    // if(pageCount.value==1){
    //   arrManagerList = RxList([]);}
    arrManagerList = RxList([]);
    var data = {
      'action': 'listcowner',
      "request": 'all',
    };

    var headers = {
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",
    };
    try{
      ApiResponse response = ApiResponse(
          data: data,
          base_url: URL_MEMBERS,
          apiHeaderType: ApiHeaderType.Content,
          headerdata: headers);

      Map<String, dynamic>? responseData = await response.getResponse();
      log(responseData.toString());
      print("response manage member data ");

      if (responseData!['status'] == 1) {
        List result = responseData['data'];
        // _loadMore.value = responseData['loadmore'];
        // _loadMore.refresh();
        List<CoOwnerModel> arrTempList = [];
        arrTempList = List<CoOwnerModel>.from(result.map((e) => CoOwnerModel.fromJson(e)));
        arrManagerList.addAll(arrTempList);
        arrManagerList.refresh();

      } else {
        Requestmessage.value = responseData['message'];
      }
    }catch(e){print(e.toString()+' manage member2 data');}
    return arrManagerList;

  }

  Future<void> RemoveAddMemberRequest(String requestid) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    appLoader(contextCommon);
    var data = {
      'action': 'clearrequest',
      "requestid":requestid.toString(),

    };
    var headers = {
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",
    };

    ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_MEMBERS,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers);

    Map<String, dynamic>? responseData = await response.getResponse();

    if (responseData!['status'] == 1) {
      RefreshRequest();
      removeAppLoader(contextCommon);
      SuccessMsg(responseData['message']);
    } else {
      removeAppLoader(contextCommon);
      validationMsg(responseData['message']);
    }
  }

  Future<void> ResendMemberRequest(String requestid) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    appLoader(contextCommon);
    var data = {
      'action': 'resendrequest',
      "requestid":requestid.toString(),

    };
    var headers = {
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",
    };

    ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_MEMBERS,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers);

    Map<String, dynamic>? responseData = await response.getResponse();

    if (responseData!['status'] == 1) {
      RefreshRequest();
      removeAppLoader(contextCommon);
      SuccessMsg(responseData['message']);
    } else {
      removeAppLoader(contextCommon);
      validationMsg(responseData['message']);
    }
  }

  Future<void> AddCownerData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    appLoader(contextCommon);
    Map<String, dynamic> data = {
      'action' : 'insertcowner',
      'mobile' : txtContactNew.value?.text.trim().toString(),
      'fname': txtFirstNameNew.value?.text.trim().toString(),
      'lname': txtLastNameNew.value?.text.trim().toString(),
      'email': txtEmailNew.value?.text.trim().toString(),
      'countrycodestr' : "in",
      'countrycode' : "+91",
      'unitdetails' :
      jsonEncode(arrPropertiesDetailsList.value).toString(),

      // {
      //   "projectid": "606fdd384ce36751a452ca74",
      //   "project": "The Pursuit of Happiness (TPOH)",
      //   "inventorytypeid": "2",
      //   "inventorytype": "Villa",
      //   "villaid": "61d002c9fb6b00002c005e47",
      //   "villa": " Villa 18",
      //   "unitdetails": "Villa,  Villa 18"
      // }
    };
    print(data.toString());
    print("my add co-owner");
    var headerdata = {
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",
    };

    ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_MEMBERS,
        headerdata: headerdata,
        apiHeaderType: ApiHeaderType.Content);

    Map<String, dynamic>? responseData = await response.getResponse();
    log(responseData.toString());
    print("my cowner list data");
    if (responseData!['status'] == 1) {
      removeAppLoader(contextCommon);
      Get.back(result: "1");
      RefreshRequest();
      SuccessMsg(responseData['message'], title: "Success");
    } else {
      removeAppLoader(contextCommon);
      validationMsg(responseData['message']);
    }
  }

  AddRental() async {
    Apploader(contextCommon);
    try{
      SharedPreferences sp = await SharedPreferences.getInstance();
      var data = {
        'action': 'insertrental',
        'projectid': projectID.value,
        'projectname': objMyPropertiesDetails.value.projectname??"",
        'formevent': 'addright',
        'propertyarea': txtPropertyArea.value?.text.toString(),
        'expectedrent':  txtExpectedRent.value?.text.toString(),
        'note': txtNotes.value?.text.toString()
      };
      print(data.toString() + "Add Rental");

      var headers = {
        'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",
      };

      ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_ADDRENTAL,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers,
      );
      Map<String, dynamic>? responseData = await response.getResponse();
      log(responseData.toString());
      if (responseData!['status'] == 1) {
        MoengageAnalyticsHandler().SendAnalytics({
          'action': 'insertrental',
          'projectid': projectID.value,
          'projectname': objMyPropertiesDetails.value.projectname??"",
          'formevent': 'addright',
          'propertyarea': txtPropertyArea.value?.text.toString(),
          'expectedrent':  txtExpectedRent.value?.text.toString(),
          'note': txtNotes.value?.text.toString()
        }, "add_rental");
        Navigator.pop(contextCommon);
        SuccessMsg(responseData['message'] ?? "Rental Add Successfully" );
        Get.back();
        removeAppLoader(contextCommon);
      }
      else{
        Navigator.pop(contextCommon);
        validationMsg(responseData['message'] ?? "Something Went Wrong");
      }
    }catch(e){
      validationMsg("Something Went Wrong");
      Navigator.pop(contextCommon);
    }


  }
  AddReSale() async {
    Apploader(contextCommon);
    try{
      SharedPreferences sp = await SharedPreferences.getInstance();
      var data = {
        'action': 'insertresale',
        'projectid': projectID.value,
        'projectname': objMyPropertiesDetails.value.projectname??"",
        'formevent': 'addright',
        'note': txtResaleNotes.value?.text.toString()
      };
      print(data.toString() + "Add ReSale");

      var headers = {
        'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",
      };

      ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_ADDRESALE,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers,
      );
      Map<String, dynamic>? responseData = await response.getResponse();
      log(responseData.toString());
      if (responseData!['status'] == 1) {
        MoengageAnalyticsHandler().SendAnalytics({
          'action': 'insertresale',
          'projectid': projectID.value,
          'projectname': objMyPropertiesDetails.value.projectname??"",
          'formevent': 'addright',
          'note': txtResaleNotes.value?.text.toString()
        }, "add_reSale");
        Navigator.pop(contextCommon);
        SuccessMsg(responseData['message'] ?? "Re-Sale Add Successfully" );
        Get.back();
        removeAppLoader(contextCommon);
      }
      else{
        Navigator.pop(contextCommon);
        validationMsg(responseData['message'] ?? "Something Went Wrong");
      }
    }catch(e){
      validationMsg("Something Went Wrong");
      Navigator.pop(contextCommon);
    }


  }


  //
  // Future<List<MyPropertiesListModel>> GetMyPropertoesListData() async {
  //   arrMyPropertiesList = RxList([]);
  //
  //   arrMyPropertiesList.add(MyPropertiesListModel(
  //       title: "601",
  //       projectAddress: "6th Floor, B4,",
  //       address: "White Field, Bengaluru",
  //       futureImage: BUILDING_IMAGE,
  //       projectImage: BUILDING_IMAGE,
  //       projectName: "WorldHome Superstar",
  //       userType: "Owner"));
  //   arrMyPropertiesList.add(MyPropertiesListModel(
  //       title: "601",
  //       projectAddress: "6th Floor, B4,",
  //       address: "White Field, Bengaluru",
  //       futureImage: BUILDING_IMAGE,
  //       projectImage: BUILDING_IMAGE,
  //       projectName: "WorldHome Superstar",
  //       userType: "Owner"));
  //
  //   return arrMyPropertiesList;
  // }


  Future<RxList<MyPropertiesModel>> MyPropertiesData() async{
    arrMyPropertiesMore.refresh();
    arrMyPropertiesMore = RxList([
      MyPropertiesModel(
          ID: "1",
          color: ACCOUNT_STATEMENT_COLOR,
          icon: account_statement_svg,
          title: "Account Statement",
          onTap: () {
            MoengageAnalyticsHandler().track_event("account_statement_page");
            Get.to(() => AccountStatementPage());
          }),
      MyPropertiesModel(
          ID: "2",
          color: PAYMENT_STATEMENT_COLOR,
          icon: payment_statement_svg,
          title: "Payment Schedule",
          onTap: () {
            MoengageAnalyticsHandler().track_event("payment_schedule_page");
            Get.to(() => PaymentSchedulePage(objMyPropertiesDetails: arrPropertiesDetailsList,));
          }),
      MyPropertiesModel(
          ID: "3",
          color: DEMANDS_COLOR,
          icon: demands_svg,
          title: "Demands",
          onTap: () {
            MoengageAnalyticsHandler().track_event("demands_page");
            Get.to(() => DemandsPage(objMyPropertiesDetails: arrPropertiesDetailsList,));
          }
      ),
      MyPropertiesModel(
          ID: "4",
          color: RECEIPT_COLOR,
          icon: receipt_svg,
          title: "Receipt",
          onTap: () {MoengageAnalyticsHandler().track_event("receipt_page");}),
      MyPropertiesModel(
          ID: "5",
          color: BUILDING_DIRECTORY_COLOR,
          icon: buildingDirectory_svg,
          title: "Building Directory",
          onTap: () {
            MoengageAnalyticsHandler().track_event("my_directory_page");
            Get.to(() => MyBuildingDirectoryPage(projectID: objMyPropertiesDetails.value.projectid??"",));
          }),
      MyPropertiesModel(
          ID: "6",
          color: NOTICE_BOARD_COLOR,
          icon: notice_board_svg,
          title: "Notice Board",
          onTap: () {
            MoengageAnalyticsHandler().track_event("notice_page");
            Get.to(() => NoticeBoardPage());
          }),
      MyPropertiesModel(
          ID: "7",
          color: RENTAL_COLOR,
          icon: rental_svg,
          title: "Rental",
          onTap: () {
            MoengageAnalyticsHandler().track_event("rental_page");
            Get.to(() => RentalPage(objMyPropertiesDetails: arrPropertiesDetailsList,));
          }),
      MyPropertiesModel(
          ID: "8",
          color: RE_SALE_COLOR,
          icon: reSale_svg,
          title: "Re-Sale",
          onTap: () {
            MoengageAnalyticsHandler().track_event("reSale_page");
            Get.to(() => Re_SalePage(objMyPropertiesDetails: arrPropertiesDetailsList,));
          }),
      MyPropertiesModel(
          ID: "9",
          color: GRIEVANCE_COLOR,
          icon: grievance_svg,
          title: "Grievance",
          onTap: () {
            MoengageAnalyticsHandler().track_event("grievance_page");
            Get.to(() => ComplaintListScreen(projectID: objMyPropertiesDetails.value.projectid??"",myPropertiesDetailsList:arrPropertiesDetailsList ,));
          }),
      MyPropertiesModel(
          ID: "10",
          color: MANAGE_MANAGER_COLOR,
          icon: manage_members_svg,
          title: "Manage Members",
          onTap: () {
            MoengageAnalyticsHandler().track_event("manage_members_page");
            Get.to(() => ManageMembersPage(objMyPropertiesDetails: arrPropertiesDetailsList,));
          }),
      MyPropertiesModel(
          ID: "11",
          color: DOCUMENT_COLOR,
          icon: document_svg,
          title: "Documents",
          onTap: () {
            MoengageAnalyticsHandler().track_event("properties_document_page");
            Get.to(() => MyPropertiesDocumentsPage(objMyPropertiesDetails: arrPropertiesDetailsList,));
          }),
    ]);
    arrMyPropertiesMore.refresh();
    return arrMyPropertiesMore;
  }

  DocumentData() {
    arrDocumentList = RxList([
      PropertiesExploreModel(
          title: "Allotment Letter", subTitle: "17 Jun, 2023"),
      PropertiesExploreModel(title: "Booking Form", subTitle: "17 Jun, 2023"),
      PropertiesExploreModel(
          title: "Club House Membership Cards", subTitle: "17 Jun, 2023"),
      PropertiesExploreModel(
          title: "Payment Due Date", subTitle: "23 May, 2023"),
      PropertiesExploreModel(
          title: "Electrical Layout", subTitle: "17 Jun, 2023"),
      PropertiesExploreModel(
          title: "Fire Safety Layout", subTitle: "17 Jun, 2023"),
      PropertiesExploreModel(
          title: "Payment Receipt", subTitle: "17 Jun, 2023"),
      PropertiesExploreModel(
          title: "Plumbing Layout", subTitle: "17 Jun, 2023"),
      PropertiesExploreModel(title: "Sales Deed", subTitle: "17 Jun, 2023"),
    ]);
  }

  ManageMembersData() {
    arrManageMembersList = RxList([
      ManageMembersModel(
          memberName: "Parth Goswami",
          memberImages: MANAGE_MEMBERS_PNG_IMAGE,
          memberEmail: "parth@gmail.com",
          mobileno: "+91 9854213210",
          memberType: "Co-owner".toUpperCase(),
          id: 1,
          seenType: "Active".toUpperCase(),
          buttonText: "Delete"),
      ManageMembersModel(
          memberName: "Stuti Goswami",
          memberImages: "",
          memberEmail: "stuti@gmail.com",
          mobileno: "+91 9854213210",
          memberType: "Co-owner".toUpperCase(),
          id: 2,
          seenType: "Pending".toUpperCase(),
          buttonText: ""),
    ]);
  }

  PaymentScheduleData() {
    arrPaymentScheduleList = RxList([
      PropertiesExploreModel(
          title: "Charge Type",
          subTitle: "Clubhouse Maintenance Charges",
          isOpen: false.obs,
          subList: [
            SubListModel(subTitle: "Maintenance Charges", title: "Mile Stone"),
            SubListModel(subTitle: "Total Due", title: "12,500.00"),
            SubListModel(subTitle: "Maintenance Charges", title: "Mile Stone"),
            SubListModel(subTitle: "Payment Due Date", title: "23 May, 2023"),
            SubListModel(subTitle: "Total Outstanding", title: "12,500.00"),
            SubListModel(subTitle: "Charge Paid Amount", title: "0.00")
          ]),
      PropertiesExploreModel(
          title: "Charge Type",
          subTitle: "Basic Cost",
          isOpen: false.obs,
          subList: [
            SubListModel(subTitle: "Maintenance Charges", title: "Mile Stone"),
            SubListModel(subTitle: "Total Due", title: "12,500.00"),
            SubListModel(subTitle: "Maintenance Charges", title: "Mile Stone"),
            SubListModel(subTitle: "Payment Due Date", title: "23 May, 2023"),
            SubListModel(subTitle: "Total Outstanding", title: "12,500.00"),
            SubListModel(subTitle: "Charge Paid Amount", title: "0.00")
          ]),
      PropertiesExploreModel(
          title: "Charge Type",
          subTitle: "Maintenance Charges",
          isOpen: false.obs,
          subList: [
            SubListModel(subTitle: "Maintenance Charges", title: "Mile Stone"),
            SubListModel(subTitle: "Total Due", title: "12,500.00"),
            SubListModel(subTitle: "Maintenance Charges", title: "Mile Stone"),
            SubListModel(subTitle: "Payment Due Date", title: "23 May, 2023"),
            SubListModel(subTitle: "Total Outstanding", title: "12,500.00"),
            SubListModel(subTitle: "Charge Paid Amount", title: "0.00")
          ]),
      PropertiesExploreModel(
          title: "Charge Type",
          subTitle: "Parking Charges",
          isOpen: false.obs,
          subList: [
            SubListModel(subTitle: "Maintenance Charges", title: "Mile Stone"),
            SubListModel(subTitle: "Total Due", title: "12,500.00"),
            SubListModel(subTitle: "Maintenance Charges", title: "Mile Stone"),
            SubListModel(subTitle: "Payment Due Date", title: "23 May, 2023"),
            SubListModel(subTitle: "Total Outstanding", title: "12,500.00"),
            SubListModel(subTitle: "Charge Paid Amount", title: "0.00")
          ]),
    ]);
  }

/*  DemadsListData() {
    arrDemandsList = RxList([
      PropertiesExploreModel(
          title: "Invoice No.",
          subTitle: "4400000357",
          isOpen: false.obs,
          subList: [
            SubListModel(
                subTitle: "Date 23 June, 2023", title: "Payment Due Date"),
            SubListModel(subTitle: "36,000.00", title: "Amount Due"),
            SubListModel(subTitle: "0.00", title: "Interest"),
            SubListModel(subTitle: "Partially Paid", title: "Demand Status"),
            SubListModel(subTitle: "Schedule Due", title: "36,000.00"),
            SubListModel(subTitle: "36,000.00", title: "Outstanding Due")
          ]),
      PropertiesExploreModel(
          title: "Invoice No.",
          subTitle: "4400000186",
          isOpen: false.obs,
          subList: [
            SubListModel(subTitle: "Date 23 June, 2023", title: "Payment Due"),
            SubListModel(subTitle: "36,000.00", title: "Amount Due"),
            SubListModel(subTitle: "0.00", title: "Interest"),
            SubListModel(subTitle: "Partially Paid", title: "Demand Status"),
            SubListModel(subTitle: "Schedule Due", title: "36,000.00"),
            SubListModel(subTitle: "36,000.00", title: "Outstanding Due")
          ]),
      PropertiesExploreModel(
          title: "Invoice No.",
          subTitle: "4400000092",
          isOpen: false.obs,
          subList: [
            SubListModel(subTitle: "Date 23 June, 2023", title: "Payment Due"),
            SubListModel(subTitle: "36,000.00", title: "Amount Due"),
            SubListModel(subTitle: "0.00", title: "Interest"),
            SubListModel(subTitle: "Partially Paid", title: "Demand Status"),
            SubListModel(subTitle: "Schedule Due", title: "36,000.00"),
            SubListModel(subTitle: "36,000.00", title: "Outstanding Due")
          ]),
      PropertiesExploreModel(
          title: "Invoice No.",
          subTitle: "4400000011",
          isOpen: false.obs,
          subList: [
            SubListModel(subTitle: "Date 23 June, 2023", title: "Payment Due"),
            SubListModel(subTitle: "36,000.00", title: "Amount Due"),
            SubListModel(subTitle: "0.00", title: "Interest"),
            SubListModel(subTitle: "Partially Paid", title: "Demand Status"),
            SubListModel(subTitle: "Schedule Due", title: "36,000.00"),
            SubListModel(subTitle: "36,000.00", title: "Outstanding Due")
          ]),
    ]);
  }*/


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
}

class PropertiesExploreModel {
  String? title;
  String? subTitle;
  String? icon;
  RxBool? isOpen = false.obs;
  List<SubListModel>? subList;
  PropertiesExploreModel(
      {this.title, this.subTitle, this.icon, this.subList, this.isOpen});
}

class SubListModel {
  String? title;
  String? subTitle;
  SubListModel({this.title, this.subTitle});
}
