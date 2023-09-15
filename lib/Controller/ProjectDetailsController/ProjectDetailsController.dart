
import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'package:Repeople/Controller/ScheduleSiteController/ScheduleVisitController.dart';
import 'package:flutter/foundation.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/Helper/shared_prefrence.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Config/utils/colors.dart';
import 'package:Repeople/Model/Dashbord/ProjectListClass.dart';
import 'package:Repeople/Model/ProjectDetails/ProjectBasicInfo.dart';
import 'package:Repeople/Model/ProjectDetails/ProjectDetailsBlockClass.dart';
import 'package:Repeople/Model/Theme/WidgetThemeListClass.dart';
import 'package:Repeople/View/LoginPage/LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Config/Helper/ApiResponse.dart';
import '../../Model/ProjectDetails/HighlightsModal.dart';
import '../../Model/ProjectDetails/ProjectDetailsModal.dart';
import '../../Widgets/CommomBottomSheet.dart';
import '../CommonHeaderController/CommenHeaderController.dart';

class ProjectDetailsController extends GetxController {


  RxList<ProjectListClass> arrProjectDataList = RxList<ProjectListClass>();
  RxList<HighlightsModal> arrhighlightslist = RxList<HighlightsModal>();
  RxList<HighlightsModal> arramenitieslist = RxList<HighlightsModal>();
  RxList<WidgetThemeListClass> arrThemeList = RxList<WidgetThemeListClass>();
  RxList<WidgetThemeListClass> arrSetThemeWidget = RxList<WidgetThemeListClass>();
  RxList<ProjectBasicInfo> arrProjectDetailsBlock = RxList<ProjectBasicInfo>();
  // RxList<ProjectDetailsModal> arrProjectDetailsBlock = RxList<ProjectDetailsModal>();
  RxList<ProjectBasicInfo> arrProjectBasicInfoList = RxList<ProjectBasicInfo>();
  RxList<ProjectBasicInfo> arrEssentialList = RxList<ProjectBasicInfo>();
  List<Configuration> configurationlist = [];
  Rx<ProjectDetailsModal> obj_projectdetails = ProjectDetailsModal().obs;
  ScrollController scrollController = ScrollController();
  ScheduleSiteController cnt_ScheduleSite = Get.put(ScheduleSiteController());
  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());

  //new RxList for images
  RxList<String> connectivityList=RxList([]);
  RxString connectivityImage = ''.obs;
  RxList<String> gallerylist=RxList([]);
  RxList<String> siteprogress=RxList([]);
  RxList<String> floorplan=RxList([]);
  RxList<String> layoutplan=RxList([]);
  RxList<String> unitplan=RxList([]);

  ProjectDetailsModalNew? project_details_obj;
  // ProjectDetailsModalNew obj_svprojectdetails = ProjectDetailsModalNew();
  Rx<ProjectDetailsModalNew> obj_svprojectdetails = ProjectDetailsModalNew().obs;
  Rx<Future<ProjectDetailsModalNew>> futureProjectdetailsData = Future.value(ProjectDetailsModalNew()).obs;

  //carousal Controller event
  CarouselController controller_event = CarouselController();
  RxInt current=0.obs;
  RxBool islogin = false.obs;


  RxList<ProjectDetailsModalNew> arrProjectDetailsList = RxList<ProjectDetailsModalNew>([]);
  Rx<Future<List<ProjectDetailsModalNew>>> futureprojectdetailslist = Future.value(<ProjectDetailsModalNew>[]).obs;

  GlobalKey<ScaffoldState> GlobalProjectDetailsPagekey = GlobalKey<ScaffoldState>();

  bool istapped=false;
  RxList<bool> isSelected=RxList();
  RxString layoutString='Intialized'.obs;
  RxString ProjectId=''.obs;
  RxBool KeyBoardVisblity=false.obs;

  //new declaration
  var formkey = GlobalKey<FormState>();
  Rxn<TextEditingController> txtFirstNameNew = Rxn(TextEditingController());
  Rxn<TextEditingController> txtLastNameNew = Rxn(TextEditingController());
  Rxn<TextEditingController> txtEmailNew = Rxn(TextEditingController());
  Rxn<TextEditingController> txtContactNew = Rxn(TextEditingController());
  Rxn<TextEditingController> txtQueryNew = Rxn(TextEditingController());
  Rxn<TextEditingController> txtScheduleDateNew = Rxn(TextEditingController());
  Rxn<TextEditingController> txtScheduleTimeNew = Rxn(TextEditingController());
  TextEditingController txtProject = TextEditingController();
  TextEditingController txtBudget = TextEditingController();


  RxList<WidgetThemeListClass> arrAllTheme = RxList<WidgetThemeListClass>();

  List<String> amenitiesimages = [
    IMG_AMENITIES_GYM_SVG_NEW,
    IMG_AMENITIES_LANDSCAPE_SVG_NEW,
    IMG_AMENITIES_CHILDREN_SVG_NEW
  ];

  bool isloading = false;
  // List<bool> _isSelected=[];
  // bool isFirst;

  List<String> agencyimages = [
    "https://lh5.googleusercontent.com/Nc0FtGNWUd1mTITNtK-vwFZ1EyY7dwDubHUl-uhMwqd2ITtA5kdXI6i-5MQfQeKUl6FKJsxTXytz0WXLhsqZdF6OBZQihF9hGhD_0wDrLKmJbmDsyqPg1TmvHWDDgdbpZZqoRnTb=s0",
    "https://cdn.logojoy.com/wp-content/uploads/2018/05/30150858/1914.png",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjoc7FXbvbEZoV7eCA8swfqiAuG8bN5R6XfA&usqp=CAU",
    "https://d1wnwqwep8qkqc.cloudfront.net/uploads/stage/stage_image/53858/optimized_large_thumb_stage.jpg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQXXfnM1ApTuRVDMiL1qImuWrh82JjKFdmXGttBc8ao0NP8oawobMyPaPowb0Wq83u-hDY&usqp=CAU",
  ];

  List<String> constrfundingimages = [
    "https://www.capitalmind.in/wp-content/uploads/2019/01/JM-financial-logo.jpg" ];
  List<String> loanimages = [
    "https://blog.ipleaders.in/wp-content/uploads/2022/05/HDFC.webp",
    "https://cdn.freebiesupply.com/logos/thumbs/2x/lic-logo.png",
  ];
  List<String> site_progress = [
    "https://d3cl79h6n1fe0x.cloudfront.net/wp-content/uploads/2020/01/15085115/11.jpeg",
    "https://d3cl79h6n1fe0x.cloudfront.net/wp-content/uploads/2018/03/12131948/AdobeStock_88620839.jpeg",
    "https://www.saamana.com/wp-content/uploads/2017/01/building-construction.jpg",
    "https://wallpaperaccess.com/full/937107.jpg",
  ];

  List<String> plan_layout = [
    "https://www.livehome3d.com/assets/img/articles/how-to-draw-a-floor-plan/floor-plan-of-a-house-with-a-pool.jpg",
    "https://wpmedia.roomsketcher.com/content/uploads/2022/01/06145940/What-is-a-floor-plan-with-dimensions.png",
    "https://cdn.shopify.com/s/files/1/2829/0660/products/Wynnchester-First-Floor_M_1200x.jpg",
    "https://www.homeplansindia.com/uploads/1/8/8/6/18862562/hfp-4005-ground-floor_orig.jpg",
  ];

  List<String> projectsliderimages = [
    IMG_BUILD4,
  ];

  // LatLng currentLocation = LatLng(21.230628298128927, 72.8054828129031);
  late LatLng currentLocation;
  MarkerId markerId = MarkerId("Marker");
  bool smallScreen = Get.width <= 400;
  GoogleMapController? googleMapController;

  Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> markers = new Set();

  RxInt selectedIndex = 0.obs;
  RxString message = "".obs;
  RxBool isColored=false.obs;


  int loadmore = 0;
  int pagecount = 1;
  bool isFilter = false;

  String url = "";

  _launchURL() async {
    const url = 'https://www.youtube.com/watch?v=dKelvxn7Ag8';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    islogin.value = UserSimplePreference.getbool(ISLOGIN) ?? false;
    futureProjectdetailsData.value=RetrieveProjectDetails().then((value) {
      RetriveisSelectedValues();
      cnt_ScheduleSite.FillProjectData(ProjectId.value);
      return value;
    });

  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<ProjectDetailsController>();
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

  Future<void> AddFavoriteProjectData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    Map<String, dynamic> data = {};
    data['action'] = 'addprojectfavourite';
    data['projectid'] = ProjectId.value ?? "";
    data['favourite'] = obj_svprojectdetails.value.isfavourite=="1"?"0":"1";

    var headerdata = {
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??""
    };

    print(data);
    print(headerdata);
    print("favourite data");
    ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_PROJECTLISTDASHBOARD,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headerdata);
    Map<String, dynamic>? responseData = await response.getResponse();

    if (responseData!['status'] == 1) {
      if (obj_svprojectdetails.value.isfavourite.toString() == "1") {
        obj_svprojectdetails.value.isfavourite = "0" ;

      } else {
        obj_svprojectdetails.value.isfavourite = "1" ;

      }

      obj_svprojectdetails.refresh();
      futureProjectdetailsData.refresh();
    } else {
      print("add Fav-----" + responseData['message']);
    }
  }

  Future<ProjectDetailsModalNew> RetrieveProjectDetails() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    isloading=true;
    var data = {
      'action': 'viewprojectdetails',
      'projectid': ProjectId.value
    };
    var headers = {'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",};

    ApiResponse response = ApiResponse(
      data: data,
      base_url: URL_PROJECTDETAILS,
      apiHeaderType: ApiHeaderType.Content,
      headerdata: headers,
    );
    print(data);
    print("obj_svprojectdetails.value.gallery?.gallerydata?.length");
    Map<String, dynamic>? responseData = await response.getResponse();
    log(responseData.toString()+"project Details log");
    debugPrint(responseData.toString());
    if (responseData!['status'] == 1) {
      isloading=false;
      obj_svprojectdetails.value= ProjectDetailsModalNew.fromJson(responseData);

      obj_svprojectdetails.refresh();
      print(obj_svprojectdetails.value.gallery?.gallerydata![0].icon.toString());

      if(obj_svprojectdetails.value.gallery!.gallerydata!.length>0){
        obj_svprojectdetails.value.gallery?.gallerydata?.map((e) =>
            gallerylist.add(e.icon.toString())
        ).toList();
      }

      // if(obj_svprojectdetails.value.locationimg!.length>0){
      // obj_svprojectdetails.value.locationimg!.map((e) =>
      //    connectivityList.add(e?.locationimg??"")
      // ).toList();
      // }


      if(obj_svprojectdetails.value.siteprog!.siteprogressdata!.length>0){
        obj_svprojectdetails.value.siteprog!.siteprogressdata?.map((e) =>
            siteprogress.add(e.icon.toString())
        ).toList();
      }

      if(obj_svprojectdetails.value.layout!.layoutdata!.length>0){
        obj_svprojectdetails.value.layout!.layoutdata?.map((e) {
          if(e.layouttype.toString()=="Floor Plan"){
            floorplan.add(e.icon.toString());
          }
          else if(e.layouttype.toString()=="Unit Plan"){
            unitplan.add(e.icon.toString());
          }
          else{
            layoutplan.add(e.icon.toString());
          }
        }

        ).toList();
      }




      if(obj_svprojectdetails.value.location?.latlongdata?.length!=0)
      {
        for(var i in obj_svprojectdetails.value.location?.latlongdata??[])

          if(i.longitude!=0 && i.latitude!=0)
          {
            print(i.longitude+" yy  "+i.latitude);
            if(i.marker_image!=""){

              Uint8List bytes = (await NetworkAssetBundle(Uri.parse(i.marker_image??"")).load(i.marker_image??"")).buffer.asUint8List();
              if(i.project_location!=LatLng(0, 0)){
                markers.add(Marker(
                    draggable: false,
                    markerId: MarkerId(i.name??""),
                    position:i.project_location,
                    infoWindow: InfoWindow(title: i.name,),
                    // icon: BitmapDescriptor.fromBytes(bytes)
                    icon: BitmapDescriptor.defaultMarker
                ));

              }
            }else{
              if(i.project_location!=LatLng(0, 0)){
                markers.add(Marker(
                    draggable: false,
                    markerId: MarkerId(i.name??""),
                    position:i.project_location,
                    infoWindow: InfoWindow(title: i.name,),
                    icon:BitmapDescriptor.defaultMarker
                ));
              }

            }
          }
      }


    } else {

      message.value = responseData['message'];
      isloading=false;
    }
    return obj_svprojectdetails.value;

  }

  Future<RxList<bool>>  RetriveisSelectedValues() async{
    final seen = Set<String>();
    LayoutModal? layoutlist;
    layoutlist=obj_svprojectdetails.value.layout;
    final unique = layoutlist?.layoutdata?.where((str) => seen.add(str.layouttype.toString())).toList();


    unique?.asMap().forEach((index,element) {
      if(index==0){
        isSelected.value.add(true);
        layoutString.value=element.layouttype.toString();
      }
      else{
        isSelected.value.add(false);

      }

    });
    return isSelected;
  }
  CreateConfigurationlist() {
    // configurationlist.clear();
    configurationlist = ([]);
    configurationlist
        .addAll([
      Configuration("1 BHK", '99 Lacs '),
      Configuration("2 BHK", '1.04 Cr '),
      Configuration("3 BHK", '2.15 Cr '),
      Configuration("4 BHK", '3.10 Cr '),]);
  }

  // Change Selected basic index
  ChangeIndex(int index) {
    selectedIndex.value = index;
    arrProjectBasicInfoList.refresh();
  }

  // Image array
  CreateProjectList() {
    arrProjectDataList.add(new ProjectListClass("Worldhome Hudson", "Andheri(E)", IMG_BUILD1, ["1 BHK"], false));
    arrProjectDataList.add(new ProjectListClass("Worldhome FLorence", "Vile Parle(W)", IMG_BUILD2, ["1 BHK", "2 BHK"], false));
    arrProjectDataList.add(new ProjectListClass("Worldhome Savannah", "Malad (E)", IMG_BUILD1, ["2 BHK"], false));
    arrProjectDataList.add(new ProjectListClass("Worldhome Victoria", "Pokhran Road", IMG_BUILD2, ["3 BHK"], false));
    arrProjectDataList.refresh();
  }
  Projectdetailsblock() {
    arrProjectDetailsBlock.add(ProjectBasicInfo("New Launch", IMG_STATUS_SVG_NEW, "Status"));
    arrProjectDetailsBlock.add(ProjectBasicInfo("Completed (Ready With OC)", IMG_CONSTRUCTIONSTATUS_SVG_NEW, "Construction Status"));
    arrProjectDetailsBlock.add(ProjectBasicInfo("December 2021", IMG_POSSESIONDATE_SVG_NEW, "Possession Date"));
    arrProjectDetailsBlock.add(ProjectBasicInfo("CC", IMG_LEGAL_SVG_NEW, "Legal"));
    // arrProjectDetailsBlock.add(ProjectBasicInfo(BASIC_INFO_GALLERY, IMG_PROJECT_DETAILS_GALLERY, "Gallery"));
    arrProjectDetailsBlock.refresh();
  }

  // Essential List
  CreateEssentialList() {
    arrEssentialList.add(ProjectBasicInfo(ESSENTIALS_BANK, IMG_ESSENTIALS_BANK_SVG_NEW, "Bank"));
    arrEssentialList.add(ProjectBasicInfo(ESSENTIALS_COLLEGE, IMG_ESSENTIALS_COLLEGE_SVG_NEW, "College"));
    arrEssentialList.add(ProjectBasicInfo(ESSENTIALS_HOSPITAL, IMG_ESSENTIALS_HOSPITAL_SVG_NEW, "Hospital"));
    arrEssentialList.add(ProjectBasicInfo(ESSENTIALS_RESTAURANT, IMG_ESSENTIALS_RESTAURANT_SVG_NEW, "Restaurant"));
    arrEssentialList.refresh();
  }

  CreateHighlightsList() {
    arrhighlightslist.add(HighlightsModal(ESSENTIALS_BANK, IMG_HIGHLIGHTS_DECK_SVG_NEW, "3 Side Open Deck Balcony"));
    arrhighlightslist.add(HighlightsModal(ESSENTIALS_COLLEGE, IMG_HIGHLIGHTS_WORKFROMHOME_SVG_NEW, "Work From Home space in 3.5 BHK flats"));
    arrhighlightslist.add(HighlightsModal(ESSENTIALS_HOSPITAL, IMG_HIGHLIGHTS_PARKING_SVG_NEW, "Per Flat 2 wheelers parking"));
    arrhighlightslist.add(HighlightsModal(ESSENTIALS_RESTAURANT, IMG_HIGHLIGHTS_SOLARSYSTEM_SVG_NEW, "Solar based common amenities"));
    arrhighlightslist.add(HighlightsModal(ESSENTIALS_RESTAURANT, IMG_HIGHLIGHTS_RESTAURANT_SVG_NEW, "Proximity to restaurants"));
    arrhighlightslist.add(HighlightsModal(ESSENTIALS_RESTAURANT, IMG_HIGHLIGHTS_COLLEGE_SVG_NEW, "Proximity to college"));
    arrhighlightslist.add(HighlightsModal(ESSENTIALS_RESTAURANT, IMG_HIGHLIGHTS_SCHOOL_SVG_NEW, "Proximity to school"));
    arrhighlightslist.refresh();
  }

  CreateAmenitiesList() {
    arramenitieslist.add(
        HighlightsModal(ESSENTIALS_BANK, IMG_AMENITIES_GYM_SVG_NEW, "Gym"));
    arramenitieslist.add(HighlightsModal(ESSENTIALS_COLLEGE,
        IMG_AMENITIES_CHILDREN_SVG_NEW, "Children's play area"));
    arramenitieslist.add(HighlightsModal(ESSENTIALS_HOSPITAL,
        IMG_AMENITIES_LANDSCAPE_SVG_NEW, "Landscape Garden"));
    arramenitieslist.refresh();
  }

  //<editor-fold desc = "All Theme List ">

  CreateBasicInfoList() {
    arrProjectBasicInfoList.add(ProjectBasicInfo(
        BASIC_INFO_OVERVIEW, IMG_OVERVIEW_SVG_NEW, "Overview"));
    arrProjectBasicInfoList.add(ProjectBasicInfo(
        BASIC_INFO_LOCATION, IMG_LOCATION_SVG_NEW, "Location"));
    arrProjectBasicInfoList.add(ProjectBasicInfo(
        BASIC_INFO_HIGHLIGHT, IMG_HIGHLIGHT_SVG_NEW, "Highlight"));
    arrProjectBasicInfoList.add(ProjectBasicInfo(
        BASIC_INFO_AMENITIES, IMG_AMENITIES_SVG_NEW, "Amenities"));
    arrProjectBasicInfoList.add(
        ProjectBasicInfo(BASIC_INFO_GALLERY, IMG_GALLERY_SVG_NEW, "Gallery"));
    arrProjectBasicInfoList.refresh();

    // CreateEssentialList();
  }


  Widget divider() {
    return    Divider(
      thickness: 0.5,
      color: APP_THEME_COLOR.withOpacity(0.1),
    );
  }

  Widget backarrow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Container(
            margin: EdgeInsets.only(left: 10),
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20)),
            child: Center(
                child: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  size: 20,
                )),
          ),
        ),
      ],
    );
  }
}