
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Model/ReferralModal/ReferralModal.dart';
import 'package:Repeople/Model/Theme/WidgetThemeListClass.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Config/Helper/ApiResponse.dart';
import '../../Model/PrivacyPolicyModel/PrivacyPolicyModal.dart';
import '../../Model/ReferralModal/RefferralNewTermsAndCondition.dart';
import '../../Model/ReferralTermsAndConditionsModal/ReferralTermsAndConditionsModal.dart';
import '../CommonHeaderController/CommenHeaderController.dart';

//  FAQ = 0 & T&C = 1

class ReferralController extends GetxController {

  RxList<WidgetThemeListClass> arrAppTheme = RxList<WidgetThemeListClass>();
  RxList<WidgetThemeListClass> arrAllTheme = RxList<WidgetThemeListClass>();
  RxList<WidgetThemeListClass> arrFAQTheme = RxList<WidgetThemeListClass>();
  RxList<WidgetThemeListClass> arrTCTheme = RxList<WidgetThemeListClass>();
  RxList<ReferralFAQ> arrReferralFAQList = RxList<ReferralFAQ>();



  RxBool openContainer=true.obs;
  RxInt selectedButton = 0.obs;
  RxInt selectedvalue = 0.obs;
  RxInt selectedQuestion = (-1).obs; // initialValue
  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());
  GlobalKey<ScaffoldState> Globalreferralpagekey = GlobalKey<ScaffoldState>();
  RxList<ReferralModel> arrProjectDetailsList = RxList<ReferralModel>([]);
  Rx<Future<List<ReferralModel>>> futuretablist = Future.value(<ReferralModel>[]).obs;

  late TabController tabController;

  RxBool ismainpage=true.obs;
  RxBool isExpansialOpen=false.obs;
  var GlobalCo_OwnerPagekey = GlobalKey<ScaffoldState>();


  RxList<ReferralTermsAndConditionsModel> arrTermsAndConditionsList = RxList<ReferralTermsAndConditionsModel>([]);
  Rx<Future<List<ReferralTermsAndConditionsModel>>> futureTermsAndConditionsData =
      Future.value(<ReferralTermsAndConditionsModel>[]).obs;

  //new RxList Declaration
  RxList<RefferAFriendTermsAndConditionModel> arrTermsAndCondition = RxList([]);
  RxList<RefferAFriendTermsAndConditionModel> arrFAQS = RxList([]);

  //Future DEclaration
  Rx<Future<List<RefferAFriendTermsAndConditionModel>>> futureTermsAndCondition = Future.value(<RefferAFriendTermsAndConditionModel>[]).obs;
  Rx<Future<List<RefferAFriendTermsAndConditionModel>>> futureFAQS = Future.value(<RefferAFriendTermsAndConditionModel>[]).obs;

  // RxVariable Declaration
  RxString  IsTermsConditionEmpty = ''.obs;
  RxString  IsFAQSEmpty = ''.obs;


  RxList<PrivacyPolicyModel> arrfaqsList = RxList<PrivacyPolicyModel>([]);
  Rx<Future<List<PrivacyPolicyModel>>> futurefaqsData =
      Future.value(<PrivacyPolicyModel>[]).obs;

  Future<void> onRefresh() async {
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    RetrieveTermsAndConditionsData();
    RetrieveFAQsData();

    futureFAQS.value=RetrieveFAQS();
    futureTermsAndCondition.value=RetrieveTermsAndConditionData();


    // CreateFAQTheme();
  }

  Future<List<ReferralModel>> adddata()async {

    arrProjectDetailsList=RxList([]);


    arrProjectDetailsList.add(ReferralModel(title: "FAQs" ),);
    arrProjectDetailsList.add(ReferralModel(title: "T & C",),);

    arrProjectDetailsList.refresh();
    arrProjectDetailsList.obs;
    return arrProjectDetailsList;
  }

  CreateReferralFAQList() {
    // Question
    arrReferralFAQList.add(ReferralFAQ(lblLoremQuestion_1, lblLoremAnswer_1));
    arrReferralFAQList.add(ReferralFAQ(lblLoremQuestion_2, lblLoremAnswer_2));
  }

  //</editor-fold>
  OnSelectedButtonChange(int index) {
    print("object");
    print(selectedButton.value);
    // if(selectedvalue.value=="FAQs"){
    //   selectedButton.value=1;
    // }
    // else if(selectedvalue.value=="T & C"){
    //   selectedButton.value=0;
    // }

    // if(selectedvalue=="")
    selectedButton.value = index;
  }

  Future<List<RefferAFriendTermsAndConditionModel>> RetrieveTermsAndConditionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    try{
      arrTermsAndCondition = RxList([]);
      var data = {'action': 'listtermscondition',
        'isrefferal':'1'
      };

      var headers = {'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",};

      ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_TERMS_AND_CONDITION,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers,
      );
      Map<String, dynamic>? responseData = await response.getResponse();

      if (responseData!['status'] == 1) {
        List result = responseData['data'];
        arrTermsAndCondition.value =
            List.from(result.map((e) => RefferAFriendTermsAndConditionModel.fromJson(e)));
        arrTermsAndCondition.refresh();
      }
      else{
        IsTermsConditionEmpty.value=responseData['message'] ?? "No Data Found";
      }


    }catch(e){
      IsTermsConditionEmpty.value= "No Data Found";
    }

    return arrTermsAndCondition;
  }

  Future<List<RefferAFriendTermsAndConditionModel>> RetrieveFAQS() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    try{
      arrFAQS = RxList([]);
      var data = {'action': 'listfaqs',};

      var headers = {'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",};

      ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_FAQS,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers,
      );
      Map<String, dynamic>? responseData = await response.getResponse();

      if (responseData!['status'] == 1) {
        List result = responseData['data'];
        arrFAQS.value =
            List.from(result.map((e) => RefferAFriendTermsAndConditionModel.fromJson(e)));
        arrFAQS.refresh();
      }
      else{
        IsFAQSEmpty.value=responseData['message'] ?? "No Data Found";
      }


    }catch(e){
      IsFAQSEmpty.value= "No Data Found";
    }

    return arrFAQS;
  }

  Future<List<ReferralTermsAndConditionsModel>> RetrieveTermsAndConditionsData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    // print("arrTermsAndConditionsList.length");
    arrTermsAndConditionsList = RxList([]);
    var data = {
      'action': 'listtermscondition',
      'nextpage': "1",
      'perpage': "10",
      'ordby': "-1",
      'ordbycolumnname': "id",
      'filter': "",
    };
    var headers = {
      // "Authorization":"JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJ1c2VybmFtZSI6IjkxNjc4NzYwMjgiLCJleHAiOjE5MjkwOTkyMzUsImVtYWlsIjpudWxsLCJtb2JpbGVfbm8iOiI5MTY3ODc2MDI4Iiwib3JpZ19pYXQiOjE2MTM3MzkyMzUsImRldmljZV9pZCI6ImFiYyIsImJ1aWxkZXJfaWQiOiJyYXVuYWstZ3JvdXAiLCJndWVzdCI6ZmFsc2UsInVzZXJfdHlwZSI6Ik1hc3RlciBBZG1pbiIsInVzZXJfdHlwZV9pZCI6LTF9.oEqoeFWiljm6pylULqBL7IHzm1IJOHFh8xKJk1_TTKU",
      // "content-type":"application/json"
      'userpagename': 'master',
      'useraction': 'viewright',
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",

      // 'cmpid': "60549434a958c62f010daa2f"
    };
    ApiResponse response = ApiResponse(
      data: data,
      base_url: URL_TERMSANDCONDITIONSLIST,
      apiHeaderType: ApiHeaderType.Content,
      headerdata: headers,
    );
    Map<String, dynamic>? responseData = await response.getResponse();
    print(data);
    print(headers);
    print(URL_TERMSANDCONDITIONSLIST);
    if (responseData!['status'] == 1) {
      print(responseData);
      print("arrTermsAndConditionsList.length");
      List result = responseData['data'];
      arrTermsAndConditionsList.value =
          List.from(result.map((e) => ReferralTermsAndConditionsModel.fromJson(e)));
      arrTermsAndConditionsList.refresh();
      print(arrTermsAndConditionsList.length);


    }
    return arrTermsAndConditionsList;
  }

  Future<List<PrivacyPolicyModel>> RetrieveFAQsData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    // print("arrTermsAndConditionsList.length");
    arrfaqsList = RxList([]);
    var data = {
      'action': 'listfaqs',
      // 'nextpage': "1",
      // 'perpage': "10",
      // 'ordby': "-1",
      // 'ordbycolumnname': "id",
      // 'filter': "",
    };
    var headers = {
      // "Authorization":"JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJ1c2VybmFtZSI6IjkxNjc4NzYwMjgiLCJleHAiOjE5MjkwOTkyMzUsImVtYWlsIjpudWxsLCJtb2JpbGVfbm8iOiI5MTY3ODc2MDI4Iiwib3JpZ19pYXQiOjE2MTM3MzkyMzUsImRldmljZV9pZCI6ImFiYyIsImJ1aWxkZXJfaWQiOiJyYXVuYWstZ3JvdXAiLCJndWVzdCI6ZmFsc2UsInVzZXJfdHlwZSI6Ik1hc3RlciBBZG1pbiIsInVzZXJfdHlwZV9pZCI6LTF9.oEqoeFWiljm6pylULqBL7IHzm1IJOHFh8xKJk1_TTKU",
      // "content-type":"application/json"
      'userpagename': 'master',
      'useraction': 'viewright',
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",

      // 'cmpid': "60549434a958c62f010daa2f"
    };
    ApiResponse response = ApiResponse(
      data: data,
      base_url: URL_FAQSLIST,
      apiHeaderType: ApiHeaderType.Content,
      headerdata: headers,
    );
    Map<String, dynamic>? responseData = await response.getResponse();
    print(data);
    print(headers);
    print(URL_FAQSLIST);
    if (responseData!['status'] == 1) {
      print(responseData);
      print("arrfaqsList.length");
      List result = responseData['data'];
      arrfaqsList.value =
          List.from(result.map((e) => PrivacyPolicyModel.fromJson(e)));
      arrfaqsList.refresh();
      print(arrfaqsList.length);


    }
    return arrfaqsList;
  }
}