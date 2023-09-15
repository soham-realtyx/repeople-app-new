import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:Repeople/Config/Constant.dart';
import 'package:Repeople/Config/utils/Images.dart';
import 'package:Repeople/Model/Theme/WidgetThemeListClass.dart';
import 'package:Repeople/Widgets/CommomBottomSheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Config/Helper/ApiResponse.dart';
import '../../Widgets/select_dailog.dart';
import '../CommonHeaderController/CommenHeaderController.dart';
import 'ContactUsFormcontroller.dart';

class ContactUsController extends GetxController {

  RxList<WidgetThemeListClass> arrAllThemeList = RxList<WidgetThemeListClass>();

  // LatLng currentLocation = LatLng(21.230628298128927, 72.8054828129031);
  LatLng currentLocation = LatLng(1.0,0.0);
  late Rx<CameraPosition> changedLocation;
  RxDouble zoomValue = double.parse('10').obs;
  MarkerId markerId = MarkerId("Marker");
  Map<MarkerId, Marker> markerValue = {};
  bool smallScreen = Get.width <= 400;
  GoogleMapController? googleMapController;
  final Set<Marker> markers = new Set();
  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());
  GlobalKey<ScaffoldState> GlobalContactskey = GlobalKey<ScaffoldState>();
  ContactUsFormController cnt_ContactForm = Get.put(ContactUsFormController());
  RxString address=''.obs;
  RxString latitude='0'.obs;
  RxString longitude='0'.obs;
  RxString message=''.obs;
  RxBool loded=false.obs;

  String addressTitle = "Totality Headquarters";
  String addressDesc = " 6th Floor, Swara Park Square, Rupani Circle, Sanskar Mandal Rd, "
      "Bhavnagar, Gujarat 364001";
  String km = "15 m";

  static void navigateTo(double lat, double lng) async {
    var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch ${uri.toString()}';
    }
  }



  @override
  void onInit() {
    super.onInit();
    RetrieveFlatListData();
  }

  //<editor-fold desc = "Api Calls">
  SelectSubject() {
    SelectSubjectDialog((value) {
      cnt_ContactForm.obj_subject.value=value;
      cnt_ContactForm.txtSubject.text = cnt_ContactForm.obj_subject.value.name??"";
    });
  }

  Future<dynamic> SelectSubjectDialog(ValueChanged<dynamic> onChange) {
    return SelectDialog1.showModal(
      Get.context!,
      label: "Select Subject",
      items: cnt_ContactForm.arrsubjectList,
      onChange: onChange,
      searchBoxDecoration:
      InputDecoration(prefixIcon: Icon(Icons.search), hintText: "Search"),
    );
  }

    RetrieveFlatListData() async {
    try{
      SharedPreferences sp = await SharedPreferences.getInstance();

      var data = {'action': 'fillcontactdetails'};

      var headers = {'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",};

      ApiResponse response = ApiResponse(
        data: data,
        base_url: URL_ABOUT_US,
        apiHeaderType: ApiHeaderType.Content,
        headerdata: headers,
      );
      Map<String, dynamic>? responseData = await response.getResponse();
      if (responseData!['status'] == 1) {
        latitude.value=responseData['latitude'].toString();
        longitude.value=responseData['longitude'].toString();
        address.value=responseData['address'];
        currentLocation=LatLng(double.parse(latitude.value), double.parse(longitude.value));
        loded.value=true;
        setMarkerIcon();
        update();

      }
      else{
        validationMsg(responseData['message'] ??"Something Went Wrong");
      }

    }catch(e){
      validationMsg("Something Went Wrong");
    }


  }



  setMarkerIcon() async {

    var value12 =
        await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)), IMG_LOCATION);
    Marker marker = Marker(markerId: markerId, icon: BitmapDescriptor.defaultMarker, position: currentLocation, visible: true);
    markerValue[markerId] = marker;
    update();
  }



}
