import 'dart:developer';

import 'package:Repeople/Config/utils/SizeConfig.dart';
import 'package:Repeople/View/NewsDetailsPage/NewsDetailsPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Function.dart';
import 'package:Repeople/Config/Helper/MoengageAnalyticsHandler.dart';
import 'package:Repeople/Config/Helper/shared_prefrence.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/Strings.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Config/utils/styles.dart';
import 'package:Repeople/Model/Dashbord/BrandListClass.dart';
import 'package:Repeople/Model/Dashbord/ExploreMoreListClass.dart';
import 'package:Repeople/Model/Dashbord/ProjectListClass.dart';
import 'package:Repeople/Model/News/NewsModal.dart';
import 'package:Repeople/Model/ProjectListModal/ProjectListModal.dart';
import 'package:Repeople/Model/ReferralModal/ReferralModal.dart';
import 'package:Repeople/Model/Theme/WidgetThemeListClass.dart';
import 'package:Repeople/View/LoginPage/LoginPage.dart';
import 'package:Repeople/Widgets/CommomBottomSheet.dart';
import 'package:Repeople/Widgets/CustomDecoration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Config/Helper/ApiResponse.dart';
import '../../Model/Dashbord/DashboardOffersModel.dart';
import '../../Model/ProjectDetails/ProjectDetailsBlockClass.dart';
import '../../Model/RedeemPointsModal/RedeemPointListModel.dart';
import '../../Widgets/Loader.dart';
import '../../Widgets/ShimmerWidget.dart';
import '../../Widgets/TextEditField.dart';
import '../../Widgets/select_dailog.dart';

class DashboardController extends GetxController {
  RxList<WidgetThemeListClass> arrThemeWidget = RxList<WidgetThemeListClass>([]);
  RxList<WidgetThemeListClass> arrSetThemeWidget = RxList<WidgetThemeListClass>([]);

  // RxList<ProjectListClass> arrProjectList = RxList<ProjectListClass>([]);
  // Rx<Future<List<ProjectListClass>>> futureprojectlist = Future.value(<ProjectListClass>[]).obs;

  RxList<ProjectListModal> arrProjectList = RxList<ProjectListModal>([]);
  Rx<Future<List<ProjectListModal>>> futureprojectlist = Future.value(<ProjectListModal>[]).obs;

  RxList<ProjectListModal> arrfavProjectlist = RxList<ProjectListModal>();
  Rx<Future<List<ProjectListModal>>> futurearrfavprojectlist = Future.value(<ProjectListModal>[]).obs;

  RxList<NewsListModal> arrNewsListnew = RxList<NewsListModal>();
  Rx<Future<List<NewsListModal>>> futurenewsDatanew = Future.value(<NewsListModal>[]).obs;

  RxList<MenuItemModel> arrExploreMore = RxList<MenuItemModel>([]);
  Rx<Future<List<MenuItemModel>>> futurearrexploremorelist = Future.value(<MenuItemModel>[]).obs;

  RxList<MenuItemModel> arrSmartHomeBuyer = RxList<MenuItemModel>([]);
  Rx<Future<List<MenuItemModel>>> futurearrSmartHomeBuyerlist = Future.value(<MenuItemModel>[]).obs;

  RxList<MenuItemModel> arrOtherMenuOption = RxList<MenuItemModel>([]);
  Rx<Future<List<MenuItemModel>>> futurearrOtherMenuOptionlist = Future.value(<MenuItemModel>[]).obs;

  RxList<ExploreMoreListClass> arradminExploreMore = RxList<ExploreMoreListClass>([]);
  Rx<Future<List<ExploreMoreListClass>>> futurearradminexploremorelist = Future.value(<ExploreMoreListClass>[]).obs;

  RxList<ExploreMoreListClass> arrsmarthome = RxList<ExploreMoreListClass>([]);
  Rx<Future<List<ExploreMoreListClass>>> futurearrsmarthomelist = Future.value(<ExploreMoreListClass>[]).obs;

  RxList<BrandListClass> arrBrandList = RxList<BrandListClass>([]);
  Rx<Future<List<BrandListClass>>> futurebrandlist = Future.value(<BrandListClass>[]).obs;

  RxList<ProjectDetailsModal> arrProjectDetailsBlock = RxList<ProjectDetailsModal>();

  RxList<ProjectListClass> arrProjectDataList = RxList<ProjectListClass>();
  Rx<Future<List<ProjectListClass>>> futurearrprojectdatalist = Future.value(<ProjectListClass>[]).obs;

  RxList<RefferInfo> arrRefferInfo = RxList<RefferInfo>();
  Rx<Future<List<RefferInfo>>> futureRefferInfo = Future.value(<RefferInfo>[]).obs;


  RxList<DashboardOffersModel> arroffersliderlist = RxList<DashboardOffersModel>();
  Rx<Future<List<DashboardOffersModel>>> futureoffersliderlist = Future.value(<DashboardOffersModel>[]).obs;

  List<Widget> eventSliders =[];

  CarouselController controller_project = CarouselController();
  RxInt selectedIndexEvent = 0.obs;
  RxBool islogin = false.obs;
  RxString username = "".obs;
  RxString usertype = "".obs;
  NumberFormat numberFormat = NumberFormat.decimalPattern('hi');
  var formkey = GlobalKey<FormState>();

  //for carousal slider
  RxInt _current = 0.obs;
  CarouselController controller_event = CarouselController();
  int loadmore = 0;
  int pagecount = 1;
  bool isFilter = false;
  RxString message = "".obs;
  RxString TotalPoints = "".obs;
  String url = "";
  RxBool openContainer=true.obs;
  RxString EmptyMessage=''.obs;

  TextEditingController txt_Amount = new TextEditingController();
  TextEditingController txt_fcm = new TextEditingController();
  Rxn<TextEditingController> txtamountNew = Rxn(TextEditingController());

  //new RxList Declaration
  RxList<Vouchers> arrRedeemPoints = RxList([]);

  //Future Declaration
  Rx<Future<List<Vouchers>>> futureRedeemPoint = Future.value(<Vouchers>[]).obs;

  // RxVariable Declaration
  RxString  IsRedeemPointEmpty = ''.obs;

  //scroll-controller
  ScrollController scrollController = ScrollController();
  RxInt scrollindex = 0.obs;
  RxInt scrollTheme3index = 0.obs;
  RxInt scrollTheme4index = 0.obs;

  listiningdata() {
    scrollController.addListener(() {
      scrollUpdate();
    });
  }
  TotalRedeemablePoints() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    TotalPoints.value = sp.getString(SESSION_TOTALREDEEM_POINT) ?? "0";
  }

  createEventWidget() {
    eventSliders=arroffersliderlist.map((item) => Padding(
      padding: const EdgeInsets.only(top: 0.0,right: 15,bottom: 10.0),
      child: InkWell(
        hoverColor: AppColors.TRANSPARENT,
        splashColor: AppColors.TRANSPARENT,
        highlightColor: AppColors.TRANSPARENT,
        onTap: () async {
          await launchUrl(Uri.parse(item.sliderurl.toString()?? ""), mode: LaunchMode.externalApplication);
        },
        child: Container(
            height: 190.h,
            width: Get.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.w),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.w),
              // child: Image.network(item.toString(),fit: BoxFit.cover)
              child: CachedNetworkImage(
                fadeInDuration: Duration.zero,
                fadeOutDuration: Duration.zero,
                placeholderFadeInDuration: Duration.zero,
                imageUrl: item.sliderimage.toString(),
                fit: BoxFit.fill,
              ),
            )
        ),
      ),
    ))
        .toList();
  }

  scrollUpdate() {
    double width = double.parse(Get.width.round().toString());
    var maxScroll = scrollController.position.maxScrollExtent;
    var currentPosition = scrollController.position.pixels;

    if (currentPosition.round() % 400 == 0) {}
    scrollindex.value = (currentPosition / Get.width).round();
    scrollTheme3index.value = (currentPosition / Get.width).round();
    scrollTheme4index.value = (currentPosition / Get.width).round();
  }

  //<editor-fold desc = "Api Calls">

  Future<List<Vouchers>> RetrieveRedeemPointsData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    try{
      arrRedeemPoints = RxList([]);
      var data = {
        'action': 'fetchredeempoints',
        'fltvouchers':'1',
        'voucherlimit':'6'
      };

      var headers = {
        'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",
      };

      ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_REDEEM_POINTS,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers,
      );

      Map<String, dynamic>? responseData = await response.getResponse();

      if (responseData!['status'] == 1) {
        List result = responseData['data'];
        arrRedeemPoints.value = List.from(result.map((e) => Vouchers.fromJson(e)));
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

  Future<List<ProjectListModal>> RetrieveProjectData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    arrProjectList = RxList([]);
    print("test");
    var data = {
      'action': 'listproject',
      'nextpage': "1",
      'perpage': "10",
      'ordby': "1",
      'ordbycolumnname': "id",
      "filter":""
    };
    var headers = {
      'userpagename': 'master',
      // 'useraction': 'viewright',
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",
      // 'cmpid': "60549434a958c62f010daa2f"
    };

    ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_PROJECTLISTDASHBOARD,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers);

    Map<String, dynamic>? responseData = await response.getResponse();

    print(responseData);
    if (responseData!['status'] == 1) {
      List result = responseData['data'];
      arrProjectList.value = List.from(result.map((e) => ProjectListModal.fromJson(e)));
      arrProjectList.refresh();
      futureprojectlist.refresh();

    } else {
      message.value = responseData['message'];
    }
    return arrProjectList;
  }

  Future<List<RefferInfo>> RetrieveRefferInfoData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    try{
      arrRefferInfo = RxList([]);
      var data = {
        'action': 'generalreferral'
      };
      var headers = {'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",};
      ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_DETAILS,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers,
      );
      Map<String, dynamic>? responseData = await response.getResponse();

      if (responseData!['status'] == 1) {
        List result = responseData['data'];
        arrRefferInfo.value = List.from(result.map((e) => RefferInfo.fromJson(e)));
        arrRefferInfo.refresh();
        for(int i=0;i<arrRefferInfo.length;i++) {
          referralFriendsPoints.value=arrRefferInfo[i].title!.contains("Friend Login")?arrRefferInfo[i].points!:"";
        }
      }
      else{
        EmptyMessage.value=responseData['message'] ?? "No Data Found";
      }
    }catch(e){
      EmptyMessage.value= "No Data Found";
    }
    arrRefferInfo.refresh();
    futureRefferInfo.refresh();
    return arrRefferInfo;

  }

  Future<List<ProjectListModal>> RetrieveFavouritesProjectData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    arrfavProjectlist = RxList([]);
    var data = {
      'action': 'listproject',
      'nextpage': "1",
      'perpage': "10",
      'ordby': "1",
      'ordbycolumnname': "id",
      "filter":"",
      "favourite":"true"
    };
    var headers = {'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??""};

    ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_PROJECTLISTDASHBOARD,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers);

    print(headers);

    Map<String, dynamic>? responseData = await response.getResponse();

    if (responseData!['status'] == 1) {
      List result = responseData['data'];
      arrfavProjectlist.value =
          List.from(result.map((e) => ProjectListModal.fromJson(e)));
      arrfavProjectlist.refresh();
    } else {
      message.value = responseData['message'];
    }
    return arrfavProjectlist;

  }

  Future<void> RemoveFavoriteProjectData(int index) async {
    ProjectListModal objProject=arrfavProjectlist[index];
    SharedPreferences sp = await SharedPreferences.getInstance();

    Map<String, dynamic> data = {};
    data['action'] = 'addprojectfavourite';
    data['projectid'] = objProject.sId;
    data['favourite'] = "0";

    var headerdata = {'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??""};
    ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_PROJECTLISTDASHBOARD,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headerdata);
    Map<String, dynamic>? responseData = await response.getResponse();

    if (responseData!['status'] == 1) {
      futurearrfavprojectlist.value = RetrieveFavouritesProjectData();
    } else {
      print("add Fav-----" + responseData['message']);
    }
  }

  Future<List<NewsListModal>> RetrieveNewsData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    arrNewsListnew = RxList([]);
    print("test");
    Map<String,dynamic> data = {
      'action': 'listnews',
      'nextpage': "1",
      'perpage': "20",
      'ordby': "1",
      'ordbycolumnname': "id",
      //'filter':''
    };

    var headers = {
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",
    };

    ApiResponse response = ApiResponse(
      data: data,
      base_url: URL_NEWSS,
      apiHeaderType: ApiHeaderType.Content,
      headerdata: headers,
    );

    print(headers);

    Map<String, dynamic>?  responseData = await response.getResponse();
    print("responseData");
    print(responseData);

    if (responseData!['status'] == 1) {

      List result = responseData['data'];
      arrNewsListnew.value = List.from(result.map((e) => NewsListModal.fromJson(e)));
      arrNewsListnew.refresh();

      print(arrNewsListnew.length);

      // RetrieveConstructionData();
      // RetrievePlotVillaData();

    } else {
      // print(message.value.toString()+"message");
      message.value = responseData['message'];

    }
    return arrNewsListnew;

  }

//</editor-fold >

  _launchURL() async {
    const url = 'https://www.youtube.com/watch?v=dKelvxn7Ag8';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _smarthomeurl() async {
    const url = 'https://worldhome.totalityre.com/home';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  RxDouble height = 0.0.obs;
  RxInt selectedProjectIndex = 0.obs;
  PageController controller =
  PageController(initialPage: 0, viewportFraction: 0.5, keepPage: false);

  @override
  void onInit() async{
    super.onInit();
    futureoffersliderlist.value = RetrieveOfferSliderData().whenComplete(() => createEventWidget());
    futureRedeemPoint.value=RetrieveRedeemPointsData();
    islogin.value = UserSimplePreference.getbool(ISLOGIN) ?? false;
    username.value = UserSimplePreference.getString(SESSION_PERSONNAME) ?? "";
    usertype.value = UserSimplePreference.getString(SESSION_USERLOGINTYPE) ?? "";
    username.refresh();
    TotalRedeemablePoints();
    print(UserSimplePreference.getString(TOKEN_USER_NAME));
    futureprojectlist.value = RetrieveProjectData();
    futureRefferInfo.value = RetrieveRefferInfoData();
    futurearrfavprojectlist.value = RetrieveFavouritesProjectData();
    futurenewsDatanew.value = RetrieveNewsData();
    futureRefferInfo.refresh();
    futureprojectlist.refresh();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      GetExploreMore();
    });
    listiningdata();

  }

  Future<List<DashboardOffersModel>> RetrieveOfferSliderData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    arroffersliderlist = RxList([]);
    var data = {
      'action' : 'listslider'
    };
    var headers = {
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??""
    };
    ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_OFFER_SLIDER,
        apiHeaderType: ApiHeaderType.Content,
        headerdata :  headers
    );

    Map<String, dynamic>? responseData = await response.getResponse();
    print('responsedata+++++++++++++'+responseData.toString());
    if (responseData!['status'] == 1 ){
      List result = responseData['data'];
      arroffersliderlist.value = List.from(result.map((e) => DashboardOffersModel.fromJson(e)));
      arroffersliderlist.refresh();
    }else{
      EmptyMessage.value=responseData['message'] ?? "No Data Found";
    }
    print('arroffersliderlist.length==' + arroffersliderlist.length.toString());
    return arroffersliderlist;
  }


  @override
  void onReady() {
    print('onReady called');
    super.onReady();
  }

  @override
  void onClose() {
    print('onClose called');
    super.onClose();
  }

  @override
  void onDetached() {
    print('onDetached called');
  }

  @override
  void onInactive() {
    print('onInative called');
  }

  @override
  void onPaused() {
    print('onPaused called');
  }

  @override
  void onResumed() {
    print('onResumed called');
  }

  //<editor-fold desc="GET EXPLORE MORE LIST">

  GetExploreMore()async{
    Rx<UserrightsModal> arrUserRightsList=UserrightsModal().obs;
    var userrights=await GetUserRights("").then((value) {
      if(value !=null
          && value !=""
          && value !="null"


      ){
        arrUserRightsList=value;
        if(arrUserRightsList.value.exploreMore!=null
            && arrUserRightsList.value.HomeBuyerGuide!=null
            && arrUserRightsList.value.ExtraFeatures!=null
        ) {
          arrExploreMore.value=arrUserRightsList.value.exploreMore!.where((e) =>GetCurrentOsViewRight(e).value==1).toList();
          arrExploreMore.refresh();
          arrSmartHomeBuyer.value=arrUserRightsList.value.HomeBuyerGuide!.where((e) =>GetCurrentOsViewRight(e).value==1).toList();
          arrSmartHomeBuyer.refresh();
          arrOtherMenuOption.value=arrUserRightsList.value.ExtraFeatures!.where((e) =>GetCurrentOsViewRight(e).value==1).toList();
          arrOtherMenuOption.refresh();
        }

      }
    }) ;
  }
  // for reddem brand coupon vouchers
  OnRedeemBrangListForm(Vouchers obj) {
    if (islogin.isTrue) {
      txtamountNew.value?.text="";
      Get.bottomSheet(
          branddetailsbottomsheetnew(obj),
          enableDrag: true,
          isDismissible: true,
          clipBehavior: Clip.hardEdge,
          isScrollControlled: true,
          ignoreSafeArea: false);
    } else {
      LoginDialog();
    }
  }

  LoginDialog() {
    LoginDialoge(
        dialogtext: "You should login first to proceed further.",
        stackicon:
        SvgPicture.asset(
          IMG_APPLOGO1_SVG,
          width: 40,
          height: 40,
          fit: BoxFit.fill,
          color: white,
        ),
        firstbuttontap: () {
          Get.back();
        },
        secondbuttontap: () {
          Get.back();
          Get.to(LoginPage());
        },
        secondbuttontext: "Yes",
        firstbuttontext: "No");
  }

  OnRedeemTermsandconditions(Vouchers obj) {
    Get.bottomSheet(redeemtermsandconditionsbottomsheet(obj),
        enableDrag: true,
        // backgroundColor: Colors.white,
        isDismissible: true,
        clipBehavior: Clip.hardEdge,
        isScrollControlled: true,
        ignoreSafeArea: true);
  }


  Widget branddetailsbottomsheetnew(Vouchers obj) {
    return Container(
      height: Get.height * 0.85,
      decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(cornarradius)),
      // padding: EdgeInsets.only(top: 20,bottom: 20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                SizedBox(height: 20,),
                ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: obj.image != null && obj.image!=""
                      ? Container(
                    height: 70,
                    width: 70,
                    child: CachedNetworkImage(
                      // width: Get.width-10,
                      placeholder: (context, url) => Container(
                        height: 40,
                        width: 40,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(45),
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
                    ),
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
                    ),
                  ),
                ),

                SizedBox(height: 20,),
                Text(obj.name ?? "",style:
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
                  child: Html(data:obj.description ),
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
                          OnRedeemTermsandconditions(obj);
                        },
                        child: Text("T & C",
                            style: semiBoldTextStyle(
                                fontSize: 14, txtColor: APP_THEME_COLOR)
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
                boxShadow:
                // [BoxShadow(color: gray_color_1,offset: Offset(1,1),blurRadius: 5),],
                [
                  BoxShadow(color:
                  hex("266CB5").withOpacity(0.1),offset: Offset(1,1),blurRadius: 5,spreadRadius: 3),],
              ),
              padding: EdgeInsets.only(bottom: 20, top: 0),
              width: Get.width,
              // color: AppColors.BACKGROUND_WHITE,

              child: Form(
                key: formkey,
                child: Padding(
                  // width: 100,
                  //padding:  EdgeInsets.symmetric(horizontal: 15.0),
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
                            selectBudget(obj.amounttypeoption!);
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
                  ),

                ),
              ),
            ),
          ),

          Positioned(bottom: 0, child: SubmitButton_1(obj))
        ],
      ),
    );
  }

  selectBudget(List<String> mainlist) {
    selectBudgetDialog((value) {
      txtamountNew.value?.text = value;
    },mainlist);
  }

  Future<dynamic> selectBudgetDialog(ValueChanged<dynamic> onChange,List<String> mainlist) {
    return SelectDialog1.showModal(
      Get.context!,
      label: "Select Amount",
      showSearchBox: false,
      items: mainlist,
      onChange: onChange,
    );
  }

  Widget redeemtermsandconditionsbottomsheet(Vouchers obj) {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 15),
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
                  const SizedBox(
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
                  Html(data: obj.termsandconditions),
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
          // Get.to(DashboardPage());
        },
        width: Get.width,
        height: 50,
        decoration: CustomDecorations()
            .backgroundlocal(APP_THEME_COLOR, 0, 0, APP_THEME_COLOR),
        text: "Redeem Now",
        style:
        TextStyle(color: white, fontWeight: FontWeight.w600, fontSize: 14));
  }

  RedeemPointCall(Vouchers obj) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    appLoader(contextCommon);
    try{
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
      }
      else{
        Navigator.pop(contextCommon);
        validationMsg(responseData['message'] ?? "Somthing Went Wrong");
      }


    }catch(e){
      Navigator.pop(contextCommon);
      validationMsg("Somthing Went Wrong");
    }


  }




  RefferInfoBottomSheet(){
    if(arrRefferInfo.length > 0 ) {
      bottomSheetDialog(
          message: 'Information',
          backgroundColor: APP_THEME_COLOR,
          child: RefferInfoData()
      );
    }
  }

  Widget RefferInfoData(){
    return Container(
        width: Get.width,
        height: 250.h,
        padding: const EdgeInsets.all(15),
        child: ListView.builder(
          itemCount: arrRefferInfo.length ?? 0,
          itemBuilder: (context, index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: APP_THEME_COLOR,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: INDICATOR_SLIDER_COLOR,
                            width: 1),
                      ),
                      child: CachedNetworkImage(
                        width: 35, height: 35, fit: BoxFit.cover,
                        placeholder: (context, url) => shimmerWidget(  width: 35, height: 35,radius: 30 ),
                        fadeInDuration: Duration.zero,
                        fadeOutDuration: Duration.zero,
                        placeholderFadeInDuration: Duration.zero,
                        imageUrl: arrRefferInfo[index].icon??"",
                        errorWidget: (context, url, error) {
                          return Image.network(
                              arrRefferInfo[index].icon??"",
                              width: 35, height: 35, fit: BoxFit.cover
                          );
                        },
                      ),

                      // Image.network(arrRefferInfo[index].icon??"", width: 35, height: 35),
                    ),
                    index != arrRefferInfo.length-1 ?
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 1,
                              height: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(color: INDICATOR_SLIDER_COLOR, width: 0.5)),
                            ),
                          ),
                        ],
                      ),
                    ) : SizedBox()
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(arrRefferInfo[index].title.toString(), style: boldTextStyle(),),
                          const SizedBox(width: 10),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: INDICATOR_SLIDER_COLOR,width: 1)
                            ),
                            child: Padding(padding: EdgeInsets.only(top: 4,bottom: 4,right: 8,left: 8),
                              child:Text(arrRefferInfo[index].points.toString(),style: mediumTextStyle(fontSize: 10,txtColor: INDICATOR_SLIDER_COLOR),maxLines: 1,overflow: TextOverflow.ellipsis,),),
                          )
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(arrRefferInfo[index].description.toString()),
                    ],
                  ),
                ),
              ],
            );
          },
        )
    );
  }

  RemoveFavouriteBottomSheet(int index){
    bottomSheetDialog(
        backgroundColor: APP_THEME_COLOR,
        child: AlertDialogButton(
          "Are you sure you want to remove this project from favourites?",
          TotalButton.TWO,
          "Yes",
          "No",
              () => {
            Get.back(),
            RemoveFavoriteProjectData(index),
          },
              () =>
            Get.back(),

          APP_THEME_COLOR,
          AppColors.APP_GRAY_COLOR,mediumTextStyle(txtColor: Colors.white),mediumTextStyle(txtColor: Colors.black),),message: "Remove from favourites");

  }
  OnClickHandler(NewsListModal obj){
    // Get.to(()=>NewsDetailsPage(obj: obj,));
    // NewsDetailsController controller = Get.put(NewsDetailsController());
    // controller.CreateAllTheme();
    MoengageAnalyticsHandler().SendAnalytics({"news_id":obj.id??"","news_name":obj.title??""}, "news_details");
    Get.to(()=> NewsDetailsPage(obj: obj));
    // Get.bottomSheet(controller.arrAllThemeList[0].widget!(obj),isScrollControlled: true);
  }

}
