
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Helper/MoengageAnalyticsHandler.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Widgets/Loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../Config/Function.dart';
import '../../Config/Helper/ApiResponse.dart';
import '../../Config/Helper/HextoColor.dart';
import '../../Config/utils/Images.dart';
import '../../Config/utils/Strings.dart';
import '../../Config/utils/colors.dart';
import '../../Model/Dashbord/BrandListClass.dart';
import '../../Model/MyBuildingDirectoryModel/MyBuildingDirectoryModel.dart';
import '../../Model/RedeemPointsModal/RedeemHistoryModel.dart';
import '../../Model/RedeemPointsModal/RedeemPointListModel.dart';
import '../../Model/RedeemPointsModal/RedeemPointsModal.dart';
import '../../Widgets/CommomBottomSheet.dart';
import '../../Widgets/CommonBackButtonFor5theme.dart';
import '../../Widgets/CustomDecoration.dart';
import '../../Widgets/ShimmerWidget.dart';
import '../../Widgets/TextEditField.dart';
import '../../Widgets/select_dailog.dart';
import '../BottomNavigator/BottomNavigatorController.dart';
import '../CommonHeaderController/CommenHeaderController.dart';

class RedeemPointController extends GetxController {

  late TabController tabController;
  late TabController categoryTabController;

  RxList<MyBuildingDirectoryModel> arrProjectDetailsList = RxList<MyBuildingDirectoryModel>([]);
  Rx<Future<List<MyBuildingDirectoryModel>>> futureData = Future.value(<MyBuildingDirectoryModel>[]).obs;
  Rx<Future<List<MyBuildingDirectoryModel>>> futuretablist = Future.value(<MyBuildingDirectoryModel>[]).obs;
  Rx<Future<List<CategoryName>>> futureCategorytablist = Future.value(<CategoryName>[]).obs;
  RxList<CategoryName> arrcategoryDetailsList = RxList<CategoryName>([]);
  TextEditingController txt_Amount = new TextEditingController();
  RxList<BrandListClass> arrBrandList = RxList<BrandListClass>([]);
  RxList<RedeemPointsModal> arrredeemList = RxList<RedeemPointsModal>([]);
  Rx<Future<List<RedeemPointsModal>>> futureredeemData = Future.value(<RedeemPointsModal>[]).obs;
  ScrollController scrollController = ScrollController();
  // final _controller = TextEditingController();
  List<String> brandimages = [];
  NumberFormat numberFormat = NumberFormat.decimalPattern('hi');
  //text editing controller
  TextEditingController searchtxt=TextEditingController();
  TextEditingController txtamount = TextEditingController();


  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());
  GlobalKey<ScaffoldState> Globalreedmkey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();
  Rxn<TextEditingController> txtamountNew = Rxn(TextEditingController());
  //RxVariable Declaration
  RxString TotalPoints = "".obs;

  //new RxList Declaration
  RxList<RedeemListModel> arrRedeemPoints = RxList([]);
  RxList<RedeemHistoryModel> arrRedeemHistory = RxList([]);

  //Future Declaration
  Rx<Future<List<RedeemListModel>>> futureRedeemPoint = Future.value(<RedeemListModel>[]).obs;
  Rx<Future<List<RedeemHistoryModel>>> futureRedeemHistory = Future.value(<RedeemHistoryModel>[]).obs;

  // RxVariable Declaration
  RxString  IsRedeemPointEmpty = ''.obs;
  RxString  IsRedeemHistoryEmpty = ''.obs;
  RxString pointMessage = "".obs;


  //<editor-fold desc = "On Search TextChaged">
  onSearchTextChanged(String text) async {
    if (text.isEmpty) {
      RetrieveRedeemPointsData();
      futureRedeemPoint.refresh();
      return;
    }
    RetrieveRedeemPointsData(filtter: text).then((value) {
      futureRedeemPoint.refresh();
    });


  }


  GetRedeemList() {
    arrredeemList.clear();
    arrredeemList.addAll([
      RedeemPointsModal(name: "Redeem Points", redeem_details_list: [
        RedeemListDetailsModel(
            redeemdetailslistdescription: "",
            redeemdetailslistimage: IMG_BUILD1,
            redeemdetailslistname: "Travel & Tourism"),
        RedeemListDetailsModel(
            redeemdetailslistdescription: "",
            redeemdetailslistimage: IMG_RESTAURANT,
            redeemdetailslistname: "Restaurant Fooda & Drinks"),
        RedeemListDetailsModel(
            redeemdetailslistdescription: "",
            redeemdetailslistimage: IMG_ELECTRONICS,
            redeemdetailslistname: "Electronics"),
        RedeemListDetailsModel(
            redeemdetailslistdescription: "",
            redeemdetailslistimage: IMG_SPORTSANDFITNESS,
            redeemdetailslistname: "Sports & Fitness"),
        RedeemListDetailsModel(
            redeemdetailslistdescription: "",
            redeemdetailslistimage: IMG_ELECTRONICS,
            redeemdetailslistname: "Mobile Recharges"),
        RedeemListDetailsModel(
            redeemdetailslistdescription: "",
            redeemdetailslistimage: IMG_BUILD1,
            redeemdetailslistname: "Others"),
        // RedeemListDetailsModel(
        //     redeemdetailslistdescription: "",
        //     redeemdetailslistimage: IMG_BUILD1,
        //     redeemdetailslistname: "Others"
        // ),
        // RedeemListDetailsModel(
        //     redeemdetailslistdescription: "",
        //     redeemdetailslistimage: IMG_BUILD1,
        //     redeemdetailslistname: "Others"
        // ),
        // RedeemListDetailsModel(
        //     redeemdetailslistdescription: "",
        //     redeemdetailslistimage: IMG_BUILD1,
        //     redeemdetailslistname: "Others"
        // ),
        // RedeemListDetailsModel(
        //     redeemdetailslistdescription: "",
        //     redeemdetailslistimage: IMG_BUILD1,
        //     redeemdetailslistname: "Others"
        // ),
      ]),
      RedeemPointsModal(name: "Redeem History", redeem_details_list: [])
    ]);
  }

  fetchRedeemPointCall() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    try{
      var data = {
        'action': 'fetchrepeoplepoint',
      };
      var headers = {'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",};
      ApiResponse response = ApiResponse(
        data: data,
        base_url: redeemPointsURL,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers,
      );
      Map<String, dynamic>? responseData = await response.getResponse();

      if (responseData!['status'] == 1) {
        redeemPoints.value=responseData['remainingpoints'];
      }
      else{
        pointMessage.value=responseData['message'];
        // ValidationMsg(responseData['message'] ?? "");
      }
    }catch(e){
      print(e.toString()+" my fetch redeem point error");
    }
  }

  Future<List<RedeemListModel>> RetrieveRedeemPointsData({String filtter=''}) async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    try{
      arrRedeemPoints = RxList([]);
      var data = {
        'action': 'fetchredeempoints',
        if(filtter!=null && filtter!="") 'filter' : filtter
      };


      var headers = {'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",};

      ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_REDEEM_POINTS,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers,
      );
      Map<String, dynamic>? responseData = await response.getResponse();

      if (responseData!['status'] == 1) {
        List result = responseData['data'];
        arrRedeemPoints.value =
            List.from(result.map((e) => RedeemListModel.fromJson(e)));
        arrRedeemPoints.refresh();
      }
      else{
        IsRedeemPointEmpty.value=responseData['message'] ?? "No Data Found";
      }


    }catch(e){
      IsRedeemPointEmpty.value= "No Data Found";
    }
    futureRedeemPoint.refresh();
    return arrRedeemPoints;

  }

  Future<List<RedeemHistoryModel>> RetrieveRedeemHistoryData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    try{
      arrRedeemHistory = RxList([]);
      var data = {'action': 'fetchredeemhistory'};

      var headers = {'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",};

      ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_REDEEM_POINTS,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers,
      );
      Map<String, dynamic>? responseData = await response.getResponse();

      if (responseData!['status'] == 1) {
        List result = responseData['data'];
        arrRedeemHistory.value =
            List.from(result.map((e) => RedeemHistoryModel.fromJson(e)));
        arrRedeemHistory.refresh();
      }
      else{
        IsRedeemHistoryEmpty.value=responseData['message'] ?? "No Data Found";
      }


    }catch(e){
      IsRedeemHistoryEmpty.value= "No Data Found";
    }
    return arrRedeemHistory;

  }

  RedeemPointCall(Vouchers obj) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    appLoader(contextCommon);
    try{
      arrRedeemHistory = RxList([]);
      var data = {
        'action': 'applyredeemnow',
        'voucherid':obj.id,
        'amount':txtamountNew.value?.text,
        'amounttype' : obj.amounttype
      };

      var headers = {'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",};

      ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_REDEEM_POINTS,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers,
      );
      Map<String, dynamic>? responseData = await response.getResponse();

      if (responseData!['status'] == 1) {
        Navigator.pop(contextCommon);
        SuccessMsg(responseData['message'] ?? "Redeem Successfully");
        Get.back();
        Get.back();

        futureRedeemHistory.value=RetrieveRedeemHistoryData();
        fetchRedeemPointCall();
      }
      else{
        Navigator.pop(contextCommon);
        validationMsg(responseData['message'] ?? "Something Went Wrong");
      }


    }catch(e){
      Navigator.pop(contextCommon);
      validationMsg("Something Went Wrong");
    }
    return arrRedeemHistory;

  }

  //</editor-fold>




  GetBrandList() async {
    arrBrandList = RxList<BrandListClass>([]);

    arrBrandList.add(new BrandListClass(IMG_MYNTRA));
    arrBrandList.add(new BrandListClass(IMG_MAX));
    arrBrandList.add(new BrandListClass(IMG_AMAZON));

    arrBrandList.add(new BrandListClass(IMG_NIKE));
    arrBrandList.add(new BrandListClass(IMG_FLIPKART));
    arrBrandList.add(new BrandListClass(IMG_MAX));

    arrBrandList.add(new BrandListClass(IMG_NIKE));
    arrBrandList.add(new BrandListClass(IMG_AMAZON));
    arrBrandList.add(new BrandListClass(IMG_MAX));

    arrBrandList.add(new BrandListClass(IMG_NIKE));
    arrBrandList.add(new BrandListClass(IMG_FLIPKART));
    arrBrandList.add(new BrandListClass(IMG_MAX));
    arrBrandList.add(new BrandListClass(IMG_NIKE));
    arrBrandList.add(new BrandListClass(IMG_AMAZON));
    arrBrandList.add(new BrandListClass(IMG_MAX));
    arrBrandList.add(new BrandListClass(IMG_NIKE));
    arrBrandList.add(new BrandListClass(IMG_MYNTRA));
    arrBrandList.add(new BrandListClass(IMG_FLIPKART));
  }

  TotalRedeemablePoints() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    TotalPoints.value=sp.getString(SESSION_TOTALREDEEM_POINT) ?? "0";
  }

  OnRedeemBrangListForm(Vouchers obj) {
    txtamountNew.value?.text="";
    Get.bottomSheet(

        branddetailsbottomsheetnew(obj),
        enableDrag: true,
        isDismissible: true,
        clipBehavior: Clip.hardEdge,
        isScrollControlled: true,
        ignoreSafeArea: false);
  }

  Widget branddetailsbottomsheetnew(Vouchers obj) {
    return Container(
      height: Get.height * 0.85,
      decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(cornarradius)),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                SizedBox(height: 20,),
                Padding(
                  padding: EdgeInsets.only(left: 0),
                  child: Container(

                    width: 70,
                    height: 70,
                    child: ClipOval(
                      child: obj.image != null && obj.image!=""
                          ? CachedNetworkImage(

                        placeholder: (context, url) => Container(
                          height: 40,
                          width: 40,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(35),
                            child: Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                enabled: true,
                                child: shimmerWidget(height: 180, width: Get.width, radius: 0)),
                          ),
                        ),
                        fadeInDuration: Duration.zero,
                        fadeOutDuration: Duration.zero,
                        placeholderFadeInDuration: Duration.zero,
                        imageUrl: obj.image ?? "",
                        fit: BoxFit.fill,
                      )
                          : Container(
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.grey,
                        ),
                        child: Text(obj.name!.substring(0, 1).toString().toUpperCase(), style: semiBoldTextStyle(txtColor: Colors.white, fontSize: 25)),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Text(
                    obj.name ?? "",
                    style:
                    TextStyle(
                        fontSize: 15,
                        color: gray_color,
                        fontWeight: FontWeight.w600,
                        fontFamily: fontFamily,height: 1.5
                    )
                  //semiBoldTextStyle(fontSize: 16),
                ),
                //TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
                SizedBox(
                  height: 20,
                ),
                Padding(
                    padding:
                    EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
                    child:
                    Html(data: obj.description.toString() ?? "",)
                ),
                SizedBox(
                  height: 0,
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 160, top: 10),
                  width: Get.width,
                  color: Colors.white,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          OnRedeemTermsandconditions(obj.termsandconditions.toString());
                        },
                        child: Text("T & C",
                            style: semiBoldTextStyle(
                                fontSize: 14, txtColor: APP_THEME_COLOR)
                          // TextStyle(color: APP_THEME_COLOR,fontSize: 14,
                          //     fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(height: 20,),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 50,
            child: Container(
              // height: 90,
              decoration: BoxDecoration(
                color: white,
                boxShadow: [
                  BoxShadow(color: hex("266CB5").withOpacity(0.1),offset: Offset(1,1),blurRadius: 5,spreadRadius: 3),],
              ),
              padding: EdgeInsets.only(bottom: 20, top: 0),
              width: Get.width,
              child: Form(
                key: formkey,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    child:
                    Column(
                      children: [
                        if(obj.amounttype ==1)   simpleTextFieldNewWithCustomization(
                          hintText: "Please enter amount",
                          imageIcon: "",
                          controller: txtamountNew,
                          inputFormat:
                          [FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),],
                          textInputType: TextInputType.number,
                          labelText: "Redeem Amount*",
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter amount";
                            } else if (value.trim().isNotEmpty &&
                                !value.trim().isNumberOnly()) {
                              return "Please enter only digits";
                            } else if (value.length > 3) {
                              return "Please enter amount in valid range";
                            } else if (int.parse(txtamountNew.value!.text.toString()) <= 0) {
                              return "Please enter value greater than 0";
                            }
                            else {
                              return null;
                            }
                          },
                        ),
                        if(obj.amounttype ==2)   CommonDropDownTextField(
                            labelText: "Redeem Amount*",
                            onTap: () {
                              SelectBudget(obj.amounttypeoption!);
                            },
                            // imageIcon: IMG_DOLLAR_SVG,
                            imageIcon: IMG_BUDGET_SVG_NEW,
                            controller: txtamountNew.value,
                            hintText: "Please Select Amount",
                            validator: (value){
                              if(txtamountNew.value!.text.isEmpty){
                                return "please select amount";
                              }
                              else{
                                return null;
                              }

                            }
                        ),
                      ],
                    )

                ),
              ),
            ),
          ),
          Positioned(bottom: 0, child: SubmitButton_1(obj))
        ],
      ),
    );
  }

  SelectBudget(List<String> mainlist) {
    SelectBudgetDialog((value) {

      txtamountNew.value?.text = value;
    },mainlist);
  }

  Future<dynamic> SelectBudgetDialog(ValueChanged<dynamic> onChange,List<String> mainlist) {
    return SelectDialog1.showModal(
      Get.context!,
      label: "Select Amount",
      showSearchBox: false,
      items: mainlist,
      onChange: onChange,
    );
  }

  OnRedeemTermsandconditions(String description) {
    Get.bottomSheet(redeemtermsandconditionsbottomsheet(description),
        enableDrag: true,
        // backgroundColor: Colors.white,
        isDismissible: true,
        clipBehavior: Clip.hardEdge,
        isScrollControlled: true,
        ignoreSafeArea: true);
  }

  BrandBottomsheeet(RedeemListModel obj) {
    bottomSheetDialog(
      child: wd_Brands3(obj),
      message: "Brand List",
      backgroundColor: APP_THEME_COLOR,
      isCloseMenuShow: true,
    );
  }

  RedeemHistoryBottomsheeet(RedeemHistoryModel obj) {
    bottomSheetDialog(
      // context: Get.context,
      child: redeemhistorybottomsheet(obj),
      // context: context,
      message: obj.name ?? "example",
      backgroundColor: APP_THEME_COLOR,
      // mainColor: AppColors.MENUBG,
      isCloseMenuShow: true,
    );
  }

  Future<void> onRefresh() async {
    update();
  }

  restart() {
    update();
  }










  Future<List<MyBuildingDirectoryModel>> adddata() async {
    arrProjectDetailsList = RxList([]);
    List<CategoryName> CategoryNamelist = [];
    List<CategoryName> CategoryNamelist2 = [];
    List<User> users = [];
    List<User> users2 = [];

    users.add(User(
        name: "Travel & Tourism",
        images: IMG_BUILD1,
        blockno: "B 201",
        ownership: "Owner"));
    users.add(User(
        name: "Restaurant Fooda & Drinks",
        images: IMG_BUILD2,
        blockno: "B 201",
        ownership: "Owner"));
    users.add(User(
        name: "Electronics",
        images: IMG_BUILD3,
        blockno: "B 201",
        ownership: "Owner"));
    users.add(User(
        name: "Sports & Fitness",
        images: IMG_BUILD1,
        blockno: "B 201",
        ownership: "Owner"));
    users.add(User(
        name: "Mobile Recharges",
        images: IMG_BUILD1,
        blockno: "B 201",
        ownership: "Owner"));

    users2.add(User(
        name: "priyanshu",
        category: "others",
        images: IMG_BUILD1,
        blockno: "B 202",
        ownership: "Owner"));
    users2.add(User(
        name: "neel",
        category: "others",
        images: IMG_BUILD1,
        blockno: "B 203",
        ownership: "Owner"));

    CategoryNamelist.add(CategoryName(
        categoryicon: IMG_BUILD1, categoryname: "All", udata: users));
    CategoryNamelist.add(CategoryName(
        categoryicon: IMG_BUILD1, categoryname: "doctor", udata: users2));
    CategoryNamelist.add(CategoryName(
        categoryicon: IMG_BUILD1, categoryname: "secretory", udata: users));

    CategoryNamelist2.add(CategoryName(
        categoryicon: IMG_BUILD1, categoryname: "All", udata: users));
    CategoryNamelist2.add(CategoryName(
        categoryicon: IMG_BUILD1, categoryname: "doctor", udata: users2));

    arrProjectDetailsList.add(
      MyBuildingDirectoryModel(
          project_name: "Redeem Point", Categoryname: CategoryNamelist),
    );
    arrProjectDetailsList.add(
      MyBuildingDirectoryModel(
          project_name: "Redeem History", Categoryname: CategoryNamelist2),
    );
    //arrProjectDetailsList.add(MyBuildingDirectoryModel(project_name: "SHALIGRAM KINARO2",Categoryname:CategoryNamelist ),);
    arrProjectDetailsList.refresh();
    arrProjectDetailsList.obs;
    return arrProjectDetailsList;
  }

  ClosePageCallback() {
    var getPageStringList = Get.currentRoute.split(" ");
    String pageName = getPageStringList.last;
    BottomNavigatorController cntBottom = Get.put(BottomNavigatorController());
    if (pageName == "ProjectListPage" || pageName == "FavoritePage") {
      cntBottom.SelectIndex(0);
    } else {
      Get.back();
    }
  }

  Widget ProjectSearchBar1() {
    return Container(
      // margin: EdgeInsets.only(left: 25, right: 25),
      child: Row(
        children: [
          Expanded(
            child: Material(
              color: Colors.white,
              elevation: 1,
              borderRadius: BorderRadius.circular(cornarradius),
              // decoration: CustomDecorations().backgroundlocal(WHITE, cornarradius, 0, WHITE),
              child: TextField(
                controller: searchtxt,
                onChanged:(val){
                  // onSearchTextChanged(val);
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search here...",
                    hintStyle:
                    mediumTextStyle(txtColor: HexColor("#b4b4b4")),
                    // TextStyle(
                    //     fontWeight: FontWeight.w500,
                    //     color: HexColor("#b4b4b4")),
                    contentPadding: EdgeInsets.only(left: 20)),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                // onSearchTextChanged(searchtxt.text);
              },child:Container(
            height: 50,
            width: 50,
            decoration:
            CustomDecorations().backgroundlocal(APP_THEME_COLOR, 50, 0, APP_THEME_COLOR),

            child: Icon(
              Icons.search,
              color: white,
            ),
          ))
        ],
      ),
    );
  }

  Widget Textfieldlayout() {
    return Container(
      child: TextFormField(
        // onChanged: (value){
        //   searchData(st = value.trim().toLowerCase());
        //   // Method For Searching
        // },
        decoration: InputDecoration(
          hintText: "Search your brand and categories",
          suffixIcon: Icon(Icons.search),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
          ),
        ),
      ),
    );
  }


  void logoutdialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          //final themeprovider=Provider.of<ThemeNotifier>(context);
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Stack(
                clipBehavior: Clip.none,
                // overflow: Overflow.visible,
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(),
                        borderRadius:
                        const BorderRadius.all(Radius.circular(20))),
                    height: 200,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(9, 50, 10, 0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Are you sure you want to logout?',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    // Navigator.of(context).pop();
                                    Navigator.pop(context, false);
                                  },
                                  //style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => null)),
                                  //color: Colors.grey[600],
                                  child: const Text(
                                    'No',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    // Navigator.of(context).pop();
                                    // SharedPreferences prefs = await SharedPreferences.getInstance();
                                    // prefs.setString('token',"");
                                    // prefs.remove('token');
                                    //
                                    // print("yes");
                                    // Navigator.pushReplacement(context,
                                    //     MaterialPageRoute(builder: (BuildContext ctx) => login_page()));
                                    // Navigator.of(context).pop();
                                  },
                                  //color: Colors.blueAccent,
                                  child: const Text(
                                    'Yes',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      top: -40,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(),
                            borderRadius:
                            const BorderRadius.all(Radius.circular(40))),
                        child: CircleAvatar(
                            backgroundColor: Colors.white,
                            // backgroundColor: Colors.grey[900],
                            radius: 40,
                            child: const Icon(
                              Icons.exit_to_app,
                              size: 50.0,
                            )),
                      )),
                ],
              ));
        });
  }




  Widget redeemhistorybottomsheet(RedeemHistoryModel obj) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      width: Get.width,
      height: Get.height * 0.50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          // Text("Activation Code",
          //     style: semiBoldTextStyle(txtColor: Colors.grey[600], fontSize: 12)
          //     ),
          // Text("-",
          //     style: semiBoldTextStyle(txtColor: Colors.grey[600], fontSize: 12)
          //
          //     ),
          // SizedBox(
          //   height: 20,
          // ),
          Text("Card No",
              style: semiBoldTextStyle(txtColor: Colors.grey[600], fontSize: 12)
            // TextStyle(
            //     color: Colors.grey[600],
            //     fontSize: 12,
            //     fontWeight: FontWeight.w600
            // ),
          ),
          // SizedBox(height: 10,),
          Text("-"),
          SizedBox(
            height: 20,
          ),
          Text("Expiry Date",
              style: semiBoldTextStyle(txtColor: Colors.grey[600], fontSize: 12)
            // TextStyle(
            //     color: Colors.grey[600],
            //     fontSize: 12,
            //     fontWeight: FontWeight.w600
            // ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(obj.date??"",
              style: semiBoldTextStyle(txtColor: Colors.grey[600], fontSize: 12)
            // TextStyle(
            //     color: Colors.grey[600],
            //     fontSize: 12,
            //     fontWeight: FontWeight.w600
            // ),
          ),
          SizedBox(
            height: 20,
          ),
          Text("Card Price",
              style: semiBoldTextStyle(txtColor: Colors.grey[600], fontSize: 12)
            // TextStyle(
            //     color: Colors.grey[600],
            //     fontSize: 12,
            //     fontWeight: FontWeight.w600
            // ),
          ),
          // SizedBox(height: 10,),
          Text("${obj.redeemamount??""}",
              style: semiBoldTextStyle(txtColor: Colors.grey[600], fontSize: 12)
            // TextStyle(
            //     color: Colors.grey[600],
            //     fontSize: 12,
            //     fontWeight: FontWeight.w600
            // ),
          ),
          SizedBox(
            height: 20,
          ),
          Text("Pin or URL",
              style: semiBoldTextStyle(txtColor: Colors.grey[600], fontSize: 12)
            // TextStyle(
            //     color: Colors.grey[600],
            //     fontSize: 12,
            //     fontWeight: FontWeight.w600
            // ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(obj.vouchercode??"",
              style: semiBoldTextStyle(txtColor: Colors.grey[600], fontSize: 12)
            // TextStyle(
            //     color: Colors.grey[600],
            //     fontSize: 12,
            //     fontWeight: FontWeight.w600
            // ),
          ),
          // SizedBox(height: 10,),
        ],
      ),
    );
  }



  Widget wd_Brands3(RedeemListModel obj) {
    return Container(
        height: Get.height * 0.50,
        decoration: CustomDecorations().backgroundlocal(white, 15, 0, white),
        child: SingleChildScrollView(
          child: Column(
            children: [

              GridView.builder(
                padding: EdgeInsets.only(left: 20, right: 20,top: 20),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 15,
                    crossAxisCount: 4, childAspectRatio: 0.9),
                itemBuilder: (context, i) {
                  return _generateBrandCell3(i,obj.vouchers![i]);
                },
                itemCount: obj.vouchers!.length,
              ),
            ],
          ),
        ));
  }

  Widget _generateBrandCell3(int index,Vouchers obj) {

    return GestureDetector(
      onTap: () {
        OnRedeemBrangListForm(obj);
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration:
        BoxDecoration(
            color: white,
            shape: BoxShape.circle,
            border: Border.all(color: hex("f1f1f1")),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 4,
                  offset: Offset(0,0),
                  spreadRadius: 4
              )
            ]
        ),


        child:   Padding(
          padding: EdgeInsets.only(left: 0),
          child: Container(
            width: Get.width,
            child: ClipOval(
              child: obj.image != null && obj.image!=""
                  ? CachedNetworkImage(

                placeholder: (context, url) => Container(
                  height: 40,
                  width: 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(35),
                    child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        enabled: true,
                        child: shimmerWidget(height: 180, width: Get.width, radius: 0)),
                  ),
                ),
                fadeInDuration: Duration.zero,
                fadeOutDuration: Duration.zero,
                placeholderFadeInDuration: Duration.zero,
                imageUrl: obj.image ?? "",
                fit: BoxFit.fill,
              )
                  : Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.grey,
                ),
                child: Text(
                    obj.name!
                        .substring(0, 1)
                        .toString()
                        .toUpperCase(),
                    style: semiBoldTextStyle(
                        txtColor: Colors.white,
                        fontSize: 25)
                  // TextStyle(
                  //     fontSize: 25,
                  //     color: Colors.white,
                  //     fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget redeemtermsandconditionsbottomsheet(String description) {
    return Container(
      height: Get.height * 0.85,
      decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(cornarradius)),
      padding: EdgeInsets.only(left: 20,right: 20),
      child: Stack(
        children: [
          ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Terms and conditions",
                    style:
                    TextStyle(
                        fontSize: 15,
                        color: gray_color,
                        fontWeight: FontWeight.w600,
                        fontFamily: fontFamily,height: 1.5
                    ),
                    //TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Html(data: description ?? ""),
                  SizedBox(height: 20,)
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget SubmitButton_1(Vouchers obj) {
    return OnTapButton(
        onTap: () {
          if (formkey.currentState!.validate()) {
            RedeemPointCall(obj);
          }
        },
        width: Get.width,
        height: 50,
        decoration: CustomDecorations()
            .backgroundlocal(APP_THEME_COLOR, 0, 0, APP_THEME_COLOR),
        text: "Redeem Now",
        style:
        TextStyle(color: white, fontWeight: FontWeight.w600, fontSize: 14));
  }

}
