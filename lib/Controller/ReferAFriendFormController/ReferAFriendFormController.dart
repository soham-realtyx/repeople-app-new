import 'dart:convert';
import 'dart:io';
import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/View/MyContactsPage/MyContactsPage.dart';
import 'package:Repeople/View/ReferralPage/ReferralPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/Helper/ApiResponse.dart';
import 'package:Repeople/Config/Helper/MoengageAnalyticsHandler.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Model/BudgetModel/BudgetModel.dart';
import 'package:Repeople/Model/CommonModal/CommonModal.dart';
import 'package:Repeople/Model/Theme/WidgetThemeListClass.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:Repeople/Widgets/Loader.dart';
import 'package:Repeople/Widgets/TextEditField.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:shimmer/shimmer.dart';
import '../../Config/utils/styles.dart';
import '../../Model/ReferralModal/RefferralNewTermsAndCondition.dart';
import '../../Widgets/CommomBottomSheet.dart';
import '../../Widgets/ShimmerWidget.dart';
import '../../Widgets/select_dailog.dart';
import '../CommonHeaderController/CommenHeaderController.dart';

class ReferAFriendFormController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    CategoryData();
    RetrieveBudgetListData();
    RetrieveCityListData();
    contactNew.refresh();
    Update();
  }
  Contact? contact = Contact();
  RxString myname = "".obs;
  @override
  void onClose() {
    // TODO: implement dispose
    super.onClose();
    isocode1.value = "";
    isocode1.obs;
    txtContact.clear();
    ccode = "";
  }

  void Update(){
    contactNew.refresh();
    if(contactNew!=null) {
      txtFirstNameNew.value?.text = contactNew.value.name.first.toString();
      txtLastNameNew.value?.text = contactNew.value.name.last.toString();
      txtContactNew.value?.text = contactNew.value.phones.isNotEmpty ? contactNew.value.phones.last.number.replaceAll("+91", "").replaceAll(" ", "") : '(none)';
      // cnt_ReferFriendForm.txtEmailNew.value?.text = widget.contact!.emails.isNotEmpty ? widget.contact!.emails.first.address : '(none)';
      print(contactNew.value.name.last.toString());
      print("vdvdv");
    }
  }

  RxList<WidgetThemeListClass> arrAllThemeList = RxList<WidgetThemeListClass>();
  RxList<CateGoryValueModel> CategoryList = RxList<CateGoryValueModel>();
  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());

  GlobalKey<ScaffoldState> Globalrefereafriendkey = GlobalKey<ScaffoldState>();
  RxBool focusFirstName = false.obs;
  RxBool focusLastName = false.obs;
  RxBool focusEmailName = false.obs;
  RxBool focusContact = false.obs;
  RxInt Category = 0.obs;
  Rx<CategorySelect>? CategoryOption = CategorySelect.Residential.obs;
  RxString IsTermsConditionEmpty = ''.obs;

  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtContact = TextEditingController();
  Rxn<TextEditingController> txtContactNew = Rxn(TextEditingController());
  TextEditingController txtBudget = TextEditingController();
  TextEditingController txtCity = TextEditingController();

  Rxn<TextEditingController> txtFirstNameNew = Rxn(TextEditingController());
  Rxn<TextEditingController> txtLastNameNew = Rxn(TextEditingController());
  Rxn<TextEditingController> txtEmailNew = Rxn(TextEditingController());
  Rxn<TextEditingController> txtQueryNew = Rxn(TextEditingController());
  Rxn<TextEditingController> txtScheduleDateNew = Rxn(TextEditingController());
  Rxn<TextEditingController> txtScheduleTimeNew = Rxn(TextEditingController());

  RxList<RefferAFriendTermsAndConditionModel> arrTermsAndCondition = RxList([]);
  Rx<Future<List<RefferAFriendTermsAndConditionModel>>>
  futureTermsAndCondition =
      Future.value(<RefferAFriendTermsAndConditionModel>[]).obs;

  var formkey = GlobalKey<FormState>();
  RxList<BudgetApiModel> arrBudgetMainList = RxList([]);
  Rx<BudgetApiModel> obj_budget = BudgetApiModel().obs;
  RxList<CommonModal> arrCityList = RxList([]);
  Rx<CommonModal> obj_city = CommonModal().obs;
  RxBool isSelected = true.obs;
  String desc =
      "1. $lblBookYourSiteDesc\n\n2. $lblBookYourSiteDesc\n\n3. $lblBookYourSiteDesc";

  CategoryData() {
    CategoryList = RxList([
      CateGoryValueModel(title: "Residential"),
      CateGoryValueModel(title: "Commercial")
    ]);
  }

  Rx<Future<List<Contact>>> futureContactList2 = Future.value(<Contact>[]).obs;


  RxList<Contact> mycontacts = RxList<Contact>([]);
  RxList<Contact> mycontacts2 = RxList<Contact>([]);
  Rx<Contact> contactNew=Contact().obs;
  TextEditingController searchController = new TextEditingController();
  RxBool permissionDenied = false.obs;
  List<Contact> contactsFiltered = [];

  Future<List<Contact>> fetchContacts() async {
    mycontacts=RxList([]);
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      permissionDenied.value = true;
    } else {
      final contacts = await FlutterContacts.getContacts();
      mycontacts.value = contacts;
      mycontacts2.value=contacts.toList();
    }
    mycontacts.refresh();
    return mycontacts;
  }


  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }


  Rxn<TextEditingController> txtSearch = Rxn(TextEditingController());

  Future<void> CheckContactPermission() async {

    if (Platform.isAndroid || Platform.isIOS) {
      bool status = await FlutterContacts.requestPermission(readonly: true);
      if (status) {
        (futureContactList2.value = fetchContacts())
            .then((value) =>

            Get.to(()=>MyContacts())

        );
        // Globalrefereafriendkey.currentState?.dispose();
      } else{
        validationMsg("you can not access contact");
      }
    }
  }



  Widget Refer_a_friend_Theme_1() {
    return Container(
      alignment: Alignment.center,
      color: Colors.transparent,
      child: Material(
          color: white,
          borderRadius: BorderRadius.circular(15),
          elevation: 0,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DataOfPopup(),
                SizedBox(
                  height: 50,
                ),
                Container(
                  //margin: EdgeInsets.all(20),
                    child: FooterButton_1())
              ],
            ),
          )),
    );
  }

  Widget DataOfPopup() {
    return Obx(() {
      return FutureBuilder(
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            if (arrTermsAndCondition.isNotEmpty) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: arrTermsAndCondition.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    RefferAFriendTermsAndConditionModel obj =
                    arrTermsAndCondition[index];
                    return Html(data: obj.description);
                  });
            } else {
              return Container(
                height: 120.h,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Text(IsTermsConditionEmpty.value,
                        style: semiBoldTextStyle(fontSize: 15)
                      // TextStyle(fontSize: 15,fontWeight:FontWeight.bold,),
                    ),
                  ),
                ),
              );
            }
          } else {
            return ShimmerEffect(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 5.0, bottom: 5, left: 1, right: 1),
                    child: shimmerWidget(
                        width: 80, height: 50, radius: cornarradius),
                  );
                },
                itemCount: 3,
              ),
            );
          }
        },
        future: futureTermsAndCondition.value,
      );
    });
  }

  Widget FooterButton_1() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 3,
          child: GestureDetector(
            onTap: () {
              Get.back();
              Get.to(ReferralPage(
                selectedvalue: 0,
              ));
            },
            child: Center(
              child: Text("FAQs",
                  textAlign: TextAlign.center,
                  style: extraBoldTextStyle(
                      txtColor: Colors.black.withOpacity(0.5), fontSize: 12)
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              height: 40,
              width: 30,
              decoration: BoxDecoration(
                  color: APP_THEME_COLOR,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text("Agree T & C",
                    textAlign: TextAlign.center,
                    style: mediumTextStyle(txtColor: Colors.white, fontSize: 12)
                ),
              ),
            ),
          ),

        )
      ],
    );
  }

  Future<void> SubmitReferData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    appLoader(contextCommon);
    try {
      var data = {
        'action': 'insertreferral',
        'formevent': 'addright',
        'fname': txtFirstNameNew.value?.text.trim().toString(),
        'lname': txtLastNameNew.value?.text.trim().toString(),
        'mobile': txtContactNew.value?.text.trim().toString(),
        'countrycode': countrycode.value,
        'countrycodestr': countrystr.value.toLowerCase(),
        'email': txtEmailNew.value?.text.trim().toString(),
        'budget': jsonEncode(obj_budget).toString(),
        'city': jsonEncode(obj_city).toString(),
        'category': CategoryOption?.value == CategorySelect.Residential?"Residential":"Commercial"
      };
      print(data.toString() + " this is my own custome data");
      var headers = {
        'userlogintype': sp.getString(SESSION_USERLOGINTYPE) ?? "",
      };
      ApiResponse response = ApiResponse(
          data: data,
          base_url: URL_REFFRAL,
          apiHeaderType: ApiHeaderType.Content,
          headerdata: headers);
      Map<String, dynamic>? responseData = await response.getResponse();
      print("insert Refer" + responseData.toString());
      if (responseData!['status'] == 1) {
        MoengageAnalyticsHandler().SendAnalytics({
          'fname': txtFirstNameNew.value?.text.trim().toString(),
          'lname': txtLastNameNew.value?.text.trim().toString(),
          'mobile': txtContactNew.value?.text.trim().toString(),
          'countrycode': countrycode.value,
          'countrycodestr': countrystr.value.toLowerCase(),
          'email': txtEmailNew.value?.text.trim().toString(),
          'budget': jsonEncode(obj_budget).toString(),
          'city': jsonEncode(obj_city).toString(),
          'category': CategoryOption?.value == CategorySelect.Residential?"Residential":"Commercial"
        },"refer_a_friend_form_submit");
        removeAppLoader(contextCommon);
        SuccessMsg(responseData['message']);
        Get.back();
      } else {
        removeAppLoader(contextCommon);
        validationMsg(responseData['message']);
      }
    } catch (e) {
      removeAppLoader(contextCommon);
      validationMsg("Something Went Wrong");
    }
  }

  //<editor-fold desc = "Api Calls">
  Future<List<RefferAFriendTermsAndConditionModel>>
  RetrieveTermsAndConditionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    try {
      appLoader(contextCommon);
      arrTermsAndCondition = RxList([]);
      var data = {'action': 'listtermscondition', 'isrefferal': '1'};

      var headers = {
        'userlogintype': sp.getString(SESSION_USERLOGINTYPE) ?? "",
      };

      ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_TERMS_AND_CONDITION,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers,
      );
      Map<String, dynamic>? responseData = await response.getResponse();

      if (responseData!['status'] == 1) {
        removeAppLoader(contextCommon);
        List result = responseData['data'];
        arrTermsAndCondition.value = List.from(
            result.map((e) => RefferAFriendTermsAndConditionModel.fromJson(e)));
        arrTermsAndCondition.refresh();
      } else {
        removeAppLoader(contextCommon);
        IsTermsConditionEmpty.value =
            responseData['message'] ?? "No Data Found";
      }
    } catch (e) {
      removeAppLoader(contextCommon);
      IsTermsConditionEmpty.value = "No Data Found";
    }

    return arrTermsAndCondition;
  }

  Future<List<BudgetApiModel>> RetrieveBudgetListData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    arrBudgetMainList = RxList([]);
    var data = {
      'action': 'fillbudget',
    };
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
      arrBudgetMainList.value =
          List.from(result.map((e) => BudgetApiModel.fromJson(e)));
      arrBudgetMainList.refresh();
      if (arrBudgetMainList.length > 0) {
        obj_budget.value = arrBudgetMainList[0];
        txtBudget.text = obj_budget.value.name!;
      }
    }
    return arrBudgetMainList;
  }

  Future<List<CommonModal>> RetrieveCityListData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    arrCityList = RxList([]);
    var data = {
      'action': 'fillcity',
    };
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
      List result = responseData['result'];
      arrCityList.value = List.from(result.map((e) => CommonModal.fromJson(e)));
      arrCityList.refresh();
      if (arrCityList.length > 0) {
        obj_city.value = arrCityList[0];
        txtCity.text = obj_city.value.name!;
      }
    }
    return arrCityList;
  }


  SelectBudget() {
    SelectBudgetDialog((value) {
      obj_budget.value = value;
      txtBudget.text = obj_budget.value.name ?? "";
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

  SelectCity() {
    SelectCityDialog((value) {
      obj_city.value = value;
      txtCity.text = obj_city.value.name ?? "";
    });
  }

  Future<dynamic> SelectCityDialog(ValueChanged<dynamic> onChange) {
    return SelectDialog1.showModal<CommonModal>(
      Get.context!,
      label: "Select city",
      items: arrCityList,
      onChange: onChange,
      searchBoxDecoration: const InputDecoration(
          prefixIcon: Icon(Icons.search), hintText: "Search"),
    );
  }

  //<editor-fold desc = "Refer A Form 1">


}

class CateGoryValueModel {
  String? title;
  CateGoryValueModel({this.title});
}

enum CategorySelect { Residential, Commercial }
