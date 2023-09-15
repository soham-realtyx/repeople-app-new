import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Config/Constant.dart';
import '../../Config/Helper/ApiResponse.dart';
import '../../Model/OffersModel/OffersModel.dart';
import '../CommonHeaderController/CommenHeaderController.dart';

class OffersPageController extends GetxController{
  RxInt current=0.obs;
  CarouselController controller_event = CarouselController();
  List<Widget> eventSliders =[];
  RxList<OffersModel> offerslist =RxList<OffersModel>([]);
  List<String> offerimages=[
    // "https://i.pinimg.com/736x/31/6e/fe/316efe8c60c411db0de604e3d40113c4.jpg",
    // "https://i.pinimg.com/originals/3f/9d/13/3f9d134631eccaab9cae262bb3a151a8.jpg",
    "https://zeevector.com/wp-content/uploads/best-Real-Estate-Advertising.jpg",
    "https://www.zricks.com/img/UpdatesBlog/f5491c77-1dd4-4524-b90b-a8ca729150caCirocco%20Offer-compressed.jpg",
  ];
  Rx<Future<List<OffersModel>>> futureData = Future.value(<OffersModel>[]).obs;
  CommonHeaderController cnt_CommonHeader = Get.put(CommonHeaderController());
  GlobalKey<ScaffoldState> GlobalOffersPagekey = GlobalKey<ScaffoldState>();


  RxString message = "".obs;
  String url = "";


  Future<List<OffersModel>> RetrieveOffersData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    offerslist = RxList([]);

    var data =
    {
      'action': 'listoffers',
      'nextpage': "1",
      'perpage': "20",
      'ordby': "1",
      'ordbycolumnname': "id",
      //"filter":""
    };

    print(data);

    var headers = {
      //'userpagename': 'master',
      //'useraction': 'viewright',
      'userlogintype': sp.getString(SESSION_USERLOGINTYPE)??"",
    };
    // print("headeers");


    ApiResponse response = ApiResponse(
      data: data,
      base_url: URL_OFFERSSS,
      apiHeaderType: ApiHeaderType.Content,
      headerdata: headers,
    );

    // print(headers);

    Map<String, dynamic>?  responseData = await response.getResponse();
    // print("responseData");
    print(responseData);

    if (responseData!['status'] == 1) {
      List result = responseData['data'];
      offerslist.value = List.from(result.map((e) => OffersModel.fromJson(e)));
      offerslist.refresh();
    } else {
      // print(message.value.toString()+"message");
      message.value = responseData['message'];
    }
    return offerslist;

  }

  @override
  void onInit() {
    print("initstate");
    // todo:implementation code here
    super.onInit();
    // CreateEventWidget();
  }

  @override
  void dispose() {
    super.dispose();
  }


  restart() {
    update();
  }

  Future<void> onRefresh() async {
    restart();
    update();
  }
  launchURL(String url) async {

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }}
}